public class PersonNameController {
    
    private final Account_Details__c cRec;
    public string accId;
    public list<Person_Account__c> paList{get;set;}
    
    public PersonNameController(ApexPages.StandardController controller){
       // this.cRec = (Account_Details__c)Controller.getRecord();
        accId = System.currentPageReference().getParameters().get('Id');
        system.debug('Account Id is:::::'+accId);
        if(accId!=NULL || accId!=''){
            personAccounts(accId);    
        }else{
            
        }
    } 
        
        public void personAccounts(string accId){
       
         paList = new list<Person_Account__c>();
            
         paList = [SELECT Id,
                          Account_Number__c,
                          PersonId__c,
                          PersonID__r.Name,
                          TypeTranslate__c FROM Person_Account__c WHERE Account_Number__c =:accId];
         System.debug('Person AccountList is:::::'+paList);         
    }   
    }