public  class CreateLocationController {
    
    @AuraEnabled   
    public static Map<string, object> FetchData(string AccountID){
        Map<string, object> Results= New Map<string, object>();
        String roleId = UserInfo.getUserRoleId();

        List<Account> acclist = [Select Id,Name from Account where Id =: AccountID limit 1];
        if(acclist.size()>0){
            Account acc = acclist[0];
            Results.put('ParentRecord', acc);
            system.debug('parentid'+acc);
        }
               
        List<Profile> PROFILE = [SELECT Id, Name FROM Profile WHERE Id=:userinfo.getProfileId() LIMIT 1];
       String ProflieName = PROFILE[0].Name;
        Map<id, UserRole> MapUserRole = new Map<id, UserRole>([SELECT Id,Name FROM UserRole where Id=:roleId  limit 1]);

        if(MapUserRole.values().Name.startsWith('AVP') || MapUserRole.values().Name.startsWith('VP') 
          || MapUserRole.values().Name.startsWith('Branch Manager') || ProflieName =='CFCU Admin')
        {
       Results.put('IsEligible',true);
    }
        else
        {
          Results.put('IsEligible',false); 
            
        }
        
return  Results;          
    }
    
    @AuraEnabled
    public static String LocationInsertUpdate(string parentId, Account accountObject){     
        System.debug('ParentId:'+parentId);
        System.debug('AccountObject:'+accountObject);
        List<RecordType> recTypes=[SELECT Id,Name FROM RecordType 
                                   WHERE sObjectType='Account' and Name='SubAccount'];
        
        accountObject.ParentId=parentId;
        accountObject.Name= accountObject.Location_Name__c;

        if(recTypes.size()>0){
            accountObject.RecordTypeId=recTypes[0].Id;
        }
        
        update accountObject;   
        
        return accountObject.Id;         
    }    
}