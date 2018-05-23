public class PersonNameController {
    
    private final Account_Details__c cRec;
    public string accId;
    public list<Person_Account__c> paList{get;set;}
    
    public PersonNameController(ApexPages.StandardController controller){
       // this.cRec = (Account_Details__c)Controller.getRecord();
        accId = System.currentPageReference().getParameters().get('Id');
        if(accId != null){
        Account_Details__c objNmae = [select id,Name from Account_Details__c where id=:accId];
        
        system.debug('Account Id is:::::'+accId);
        if(accId!=NULL || accId!=''){
            personAccounts(objNmae.Name);    
        }else{
            
        }
        }
    } 
        
        public void personAccounts(string accId){
       
         paList = new list<Person_Account__c>();
         list<Aggregateresult>   paList2 = new list<Aggregateresult>();
         paList2 = [SELECT 
                          
                          PersonId__c,
                          PersonID__r.Name,
                          TypeTranslate__c FROM Person_Account__c WHERE Account_Number__r.Name =:accId group by   PersonId__c, PersonID__r.Name,TypeTranslate__c];
              for(AggregateResult ar: paList2)
              {
              	Person_Account__c P =  NEW Person_Account__c();
              	
              	p.PersonId__c = (string)ar.get('PersonId__c');
              	P.PersonID__r = NEW Account();
              	P.PersonID__r.nAME =  (string)ar.get('Name');
              	P.TypeTranslate__c =   (string)ar.get('TypeTranslate__c');
              	paList.ADD(P);
              	
              }       
        
                          
         System.debug('Person AccountList is:::::'+paList);         
    }   
    }