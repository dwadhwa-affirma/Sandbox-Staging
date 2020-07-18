@isTest
private class CloseCaseControllerTest {
 	
 	@testSetup
	static void setupTestData(){
		Create_SLA__c cl = new Create_SLA__c();
        cl.Status__c = 'Open';
        cl.Name = 'Open';
        cl.hours__c = 8;
        insert cl;
        
        Create_SLA__c cl1 = new Create_SLA__c();
        cl1.Status__c = 'In Process';
        cl1.Name = 'In Process';
        cl1.hours__c = 20;
        insert cl1;
        
        Create_SLA__c cl2 = new Create_SLA__c();
        cl2.Status__c = 'Resolution';
        cl2.Name = 'Resolution';
        cl2.hours__c = 20;
        insert cl2;
        
        test.startTest();
		Account account_Obj = new Account(LastName = 'BANDATest', FirstName = 'MARIATest', Type = 'null', PersonHasOptedOutOfEmail = false);
    	Insert account_Obj; 
    	Account_Details__c act_details_obj = new Account_Details__c(Name = '0000147163', Balance__c = 0.00, Combined_Account_ID__c = '0000147163S0100P0100', ID1__c = '0100', Onboarded__c = true, RecType__c = 'ACCT', TypeTranslate__c = '1-PRIMARY SHARE');
    	Insert act_details_obj;
    	Case case_obj = new Case(Status = 'In Process', Origin = null, Subject = 'Test', ClosedDate = null, IsEscalated = false, AccountId = account_Obj.Id, Account_Number__c = act_details_obj.Id, Primary_Category__c = 'Account Maintenance', Secondary_Category__c = 'Account Services', Tertiary_Category__c = 'Extended Check Hold');
    	Insert case_obj;
    	test.stopTest();
	}

    static testMethod void myUnitTest() {
        Case case_obj = [select Id from case limit 1];
        CloseCaseController.FetchCaseData(case_obj.Id);        
        CloseCaseController.closeCaseSave(case_obj.Id,'Open','test', 'test Comments');
    }
}