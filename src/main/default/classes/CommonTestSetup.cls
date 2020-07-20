@IsTest
public class CommonTestSetup {

    @TestSetup static void initData()
    {
        string fid ='0000999999';
        
        Account acc = new Account(Name='Test');
        insert acc;
        
        List<Account_Details__c> Account_Details = new List<Account_Details__c>();
        Account_Details__c ad = new Account_Details__c();
        ad.Name = fid;
        ad.Reference__c = 'BC01';
        Account_Details.add(ad);
        insert Account_Details;
        
        Person_Account__c pa = new Person_Account__c();
        pa.Account_Number__c = ad.id;
        pa.Name_Type__c = 0;
        pa.PersonID__c = acc.Id;
        insert pa;
    
        Case cas = new Case();
        cas.Subject = 'Test Subject Inquires';
        cas.Description = 'Test Description Inquires';
        cas.Account_Number__c = pa.Account_Number__c;
        cas.AccountID = acc.id;
        cas.Primary_Category__c = 'Inquires';
        cas.Status ='Open';
        insert cas;
    }
}