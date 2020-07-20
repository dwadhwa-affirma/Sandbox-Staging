public class PersonLookUpOnCaseSubAccsController {

    private final Account accRec;
    public string accId {get;set;}
    public string accId1;
    public list<Account> accList{get;set;}
    public list<Person_Account__c> paList{get;set;}
    
    public PersonLookUpOnCaseSubAccsController(ApexPages.StandardController controller){
        this.accRec = (Account)Controller.getRecord();
        accId = System.currentPageReference().getParameters().get('accId'); 
        personAccounts(accId);
    }
    
    public void personAccounts(string accId){
        paList = new list<Person_Account__c>();
        
     /*   Account_Details__c accDetails = [Select Parent_Account__r.Name from Account_Details__c where Parent_Account__r.Name != null and Id=:accId Limit 1];
         accId1 = accDetails.Parent_Account__c; */
        Account_Details__c accDetails = [Select Parent_Account__r.Name from Account_Details__c where Id=:accId Limit 1];          
            if(accDetails.Parent_Account__r.Name != null){
              accId1 = accDetails.Parent_Account__c;
            }else{
            
            }
        
            paList = [SELECT Id,
                             Account_Number__c, 
                             PersonID__c,
                             Account_Number__r.RecType__c, 
                             Account_Number__r.Name,
                             PersonID__r.Name,
                             RecType__c,
                             TypeTranslate__c FROM Person_Account__c WHERE Account_Number__c =:accId OR Account_Number__c =:accId1];
        accountDetails(paList);
             
    }
    
    public void accountDetails(list<Person_Account__c> paList){
             
          set<Id> accountIdSet = new set<Id>();
        for(Person_Account__c var: paList){
            accountIdSet.add(var.PersonID__c);
        }
        
        accList = new list<Account>();

        accList = [Select Id,
                          Name,
                          Alternate_Email__pc,
                          FirstName,
                          MiddleName,
                          LastName,
                          PersonEmail,
                          Residential_City__pc,
                          Residential_Country_Code__pc,
                          Residential_Country__pc,
                          Residential_Extra_Address__pc,
                          Residential_State__pc,
                          Residential_Street__pc,
                          Residential_Zipocde__pc,
                          PersonHomePhone FROM Account Where Id IN:accountIdSet];
    } 
}