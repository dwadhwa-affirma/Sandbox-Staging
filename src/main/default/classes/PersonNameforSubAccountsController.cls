public class PersonNameforSubAccountsController {
    
    private final Account_Details__c cRec;
    public string accId;
    public string accId1;
    public list<Person_Account__c> paList{get;set;}
    
    public PersonNameforSubAccountsController(ApexPages.StandardController controller){
      //  this.cRec = (Account_Details__c)Controller.getRecord();
        accId = System.currentPageReference().getParameters().get('Id');
        system.debug('Account Id is:::::'+accId);
        if(accId!=NULL || accId!=''){
            personAccounts(accId);    
        }else{
            
        }
    } 
        
        public void personAccounts(string accId){
       
         paList = new list<Person_Account__c>();         
       //  paList = [SELECT Id FROM Person_Account__c WHERE Account_Number__c =:accId];            
       //  System.debug('PersonAccount List is:::'+paList);     
        
         Account_Details__c accDetails = [Select Parent_Account__c from Account_Details__c where Id=:accId Limit 1];          
            if(accDetails.Parent_Account__c != null){
              accId1 = accDetails.Parent_Account__c;
            }else{
             // ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,'Parent account number not available.'));
            }
 
         paList = [SELECT Id,
                          Account_Number__c,
                          PersonId__c,
                          PersonID__r.Name,
                          TypeTranslate__c FROM Person_Account__c WHERE Account_Number__c =:accId OR Account_Number__c =:accId1];
            
         System.debug('Person AccountList is:::::'+paList); 
      
    }
    }