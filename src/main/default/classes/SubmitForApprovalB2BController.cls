public class SubmitForApprovalB2BController {

    @AuraEnabled
    public static Map<string,string> saveOpportunity(string OpportunityId, String SEGStatus) {
        
        Map<string,string> result = new  Map<string,string>();
        String OppClosed;
        
      	Opportunity opp = [SELECT id, AccountId,StageName,SEG_Status__c FROM Opportunity where id =: OpportunityId];     
     	Account acc = [select id,SEG_Status__c from Account where id =: opp.AccountId];
        Contact con = [select id,SEG_Status__c from contact where AccountId =: acc.id];
        
        if(opp.StageName != 'Closed Won' && opp.StageName != 'Closed Lost'){
            
            if(opp != null){
                opp.SEG_Status__c = SEGStatus;
                system.debug('opp'+opp);        
                update opp;
            }
            if(acc != null){
                acc.SEG_Status__c = SEGStatus;
                system.debug('acc'+acc);        
                update acc;
            }
            if(con != null){
                con.SEG_Status__c = SEGStatus;
                system.debug('con'+con);        
                update con;
            }	
        }
        else{
            result.put('OppClosed','True');
            system.debug('result'+result);
        }
        return result;
    }	
    
    @AuraEnabled
    public static Map<string,string> getProfileName(string OpportunityId) {
        
        Map<string,string> result = new  Map<string,string>();
        String SaveDisabled;
        List<string> Profiles = new List<String>{'System Administrator','Bizdev'};
        List<string> Roles = new List<String>{'AVP, Business Development','Strategic Initiative Mgr',
            									'SVP, Retail Delivery','VP, Strategic Initiatives'};
            
        Id profileId = userinfo.getProfileId();
         
        User userInfo = [Select Id,	name,UserRole.Name from User where Id =: userInfo.getUserId()];
        String Username = userInfo.Name;
        String Role = userInfo.UserRole.name;
		String profileName=[Select Id,Name from Profile where Id=:profileId].Name;
		system.debug('ProfileName'+profileName);
        system.debug('Username '+Username);
        system.debug('Role '+userInfo.UserRole.name);
        
        if((Role != 'AVP, Business Development' && Role != 'Strategic Initiative Mgr' && Role != 'SVP, Retail Delivery'
            && Role != 'VP, Strategic Initiatives') && 
           (Username != 'Lana Aliyev' && Username != 'Lonny Nathanson' && Username != 'Mark Catalano' && Username != 'Rakesh Joshi')){
            
        	SaveDisabled = 'true';
        }
        
       
        result.put('SaveDisabled',SaveDisabled); 
      
        system.debug(SaveDisabled);
        return result; 
    }    
}