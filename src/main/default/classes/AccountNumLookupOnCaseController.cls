public class AccountNumLookupOnCaseController {

    private final Account_Details__c accRec;
    public string accId {get;set;}
    public list<Account_Details__c> accList{get;set;}
    
    public AccountNumLookupOnCaseController(ApexPages.StandardController controller){
        this.accRec = (Account_Details__c)Controller.getRecord();
        accId = System.currentPageReference().getParameters().get('accId'); 
        personAccounts(accId);
    }
    
    public void personAccounts(string accId){
        list<Person_Account__c> paList = new list<Person_Account__c>();
            paList = [SELECT Id,
                             Account_Number__c, Account_Number__r.RecType__c, Account_Number__r.Name FROM Person_Account__c WHERE PersonID__c =:accId];
        accountDetails(paList);
             
    }
    
    public void accountDetails(list<Person_Account__c> paList){
        set<String> accountNumberSet = new set<String>();
        set<Id> accIdset = new set<Id>();
        set<String> acctypeSet = new set<String>();
        for(Person_Account__c var: paList){
            accountNumberSet.add(var.Account_Number__r.Name);
            acctypeSet.add(var.Account_Number__r.RecType__c);
            accIdSet.add(var.Account_Number__c);
        }
        accList = new list<Account_Details__c>();
        if(acctypeSet.contains('ACCT')){
            accList = [SELECT Id,
                              Name,
                              RecType__c,
                              TypeTranslate__c,
                              ID1__c,
                              Balance__c,
                              WARNING_01_CODE__c,
                              WARNING_02_CODE__c,
                              WARNING_03_CODE__c,
                              WARNING_04_CODE__c,
                              WARNING_05_CODE__c,
                              WARNING_06_CODE__c,
                              WARNING_07_CODE__c,
                              WARNING_08_CODE__c,
                              WARNING_09_CODE__c,
                              WARNING_10_CODE__c,
                              WARNING_11_CODE__c,
                              WARNING_12_CODE__c,
                              WARNING_13_CODE__c,
                              WARNING_14_CODE__c,
                              WARNING_15_CODE__c,
                              WARNING_16_CODE__c,
                              WARNING_17_CODE__c,
                              WARNING_18_CODE__c,
                              WARNING_19_CODE__c,
                              WARNING_20_CODE__c,
                              Combined_Account_ID__c,
                              Reference__c,
                              Brand__c FROM Account_Details__c Where Name IN:accountNumberSet ORDER BY Name asc, RecType__c asc];
        }else{
            accList = [SELECT Id,
                              Name,
                              RecType__c,
                              TypeTranslate__c,
                              ID1__c,
                              Balance__c,
                              WARNING_01_CODE__c,
                              WARNING_02_CODE__c,
                              WARNING_03_CODE__c,
                              WARNING_04_CODE__c,
                              WARNING_05_CODE__c,
                              WARNING_06_CODE__c,
                              WARNING_07_CODE__c,
                              WARNING_08_CODE__c,
                              WARNING_09_CODE__c,
                              WARNING_10_CODE__c,
                              WARNING_11_CODE__c,
                              WARNING_12_CODE__c,
                              WARNING_13_CODE__c,
                              WARNING_14_CODE__c,
                              WARNING_15_CODE__c,
                              WARNING_16_CODE__c,
                              WARNING_17_CODE__c,
                              WARNING_18_CODE__c,
                              WARNING_19_CODE__c,
                              WARNING_20_CODE__c,
                              Combined_Account_ID__c,
                              Reference__c,
                              Brand__c  FROM Account_Details__c Where Id IN:accIdSet ORDER BY Name asc, RecType__c asc];
        }
    }
}