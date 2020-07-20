public class PersonLookUpOnCaseController {

   // private final Account_Details__c accRec;
    private final Account accRec;
    public string accId {get;set;}
  //  public list<Account_Details__c> accList{get;set;}
    public list<Account> accList{get;set;}
    public list<Person_Account__c> paList{get;set;}
    
    public PersonLookUpOnCaseController(ApexPages.StandardController controller){
       // this.accRec = (Account_Details__c)Controller.getRecord();
        this.accRec = (Account)Controller.getRecord();
        accId = System.currentPageReference().getParameters().get('accId'); 
        personAccounts(accId);
    }
    
    public void personAccounts(string accId){
        paList = new list<Person_Account__c>();
            paList = [SELECT Id,
                             Account_Number__c, 
                             PersonID__c,
                             Account_Number__r.RecType__c, 
                             Account_Number__r.Name,
                             PersonID__r.Name,
                             TypeTranslate__c FROM Person_Account__c WHERE Account_Number__c =:accId];
        accountDetails(paList);
          for(Person_Account__c item : paList)
          {
          	
          	if(item.PersonID__r != null && item.PersonID__r.Name != null)
          	{
          		item.PersonID__r.Name = item.PersonID__r.Name.replace('\'','\\\'');
          	}
          }   
             
    }
    
    public void accountDetails(list<Person_Account__c> paList){
      
        set<String> accountNameSet = new set<String>();
        for(Person_Account__c var: paList){
            accountNameSet.add(var.PersonID__r.Name);
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
                          PersonHomePhone FROM Account Where Name IN:accountNameSet];
    }
}