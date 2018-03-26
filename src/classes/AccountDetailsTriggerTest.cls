@isTest
public class AccountDetailsTriggerTest {
    
    static testMethod void testMethod1(){
        
        Account_Details__c accDetails = new Account_Details__c();
            accDetails.Name = 'test';
            accDetails.SecureEmailAddress__c = 'sample@sample.com';
            accDetails.Created_By_User__c = 1;
        insert accDetails;
        
        Episys_User__c eu = new Episys_User__c();
            eu.Episys_ID__c = 1;
            eu.Episys_Name__c = 'testname';
            accDetails.SecureEmailAddress__c = 'sample@sample.com';
        insert eu;

        accDetails.SecureEmailAddress__c = 'sample@sample2.com';
        accDetails.Created_By_User_Text__c = 'testnameUpdate';
        accDetails.Balance__c = 100;
        update accDetails;
        
        WarningCodeMapping__c wm = new WarningCodeMapping__c();
            wm.Name = 'Rec001';
            wm.Warning_Code_Number__c = '001';
            wm.Warning_Code_Text__c = '001-NO BATCH POSTING ALLOWED';
        insert wm;
        
        accDetails.WARNING_01_CODE__c = '001-NO BATCH POSTING ALLOWED...';
        accDetails.SecureEmailAddress__c = 'sample@sample3.com';
        accDetails.Balance__c = 200;
        update accDetails;        

		Account_Details__c accDetails2 = [Select Id,SecureEmailAddress__c from Account_Details__c where Name = 'test' limit 1];
        accDetails2.SecureEmailAddress__c = 'sample@sample3.com';
        update accDetails2;        


    }
}