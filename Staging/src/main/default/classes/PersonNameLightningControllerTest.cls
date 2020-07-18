@isTest
private class PersonNameLightningControllerTest
{
	
	@testSetup
static void SetUp()
{
		test.StartTest();

		RecordType objRecordType = [SELECT Id,Name FROM RecordType WHERE Name='MemberShip'];
		RecordType objRecordType1 = [SELECT Id,Name FROM RecordType WHERE Name='Person Account'];
		
		Account_Details__c  act = new Account_Details__c(Name = '0000147163', Balance__c = 0.00, Combined_Account_ID__c = '0000147163S0100P0100', ID1__c = '0100', Onboarded__c = true, RecType__c = 'ACCT', TypeTranslate__c = '1-PRIMARY SHARE', RecordType = objRecordType);
		Insert act;
		
		Account_Details__c  act1 = new Account_Details__c(Name = '0000147163', Balance__c = 0.00, Combined_Account_ID__c = '0000147163S0100P0100', ID1__c = '0100', Onboarded__c = true, RecType__c = 'SHAR', TypeTranslate__c = '1-PRIMARY SHARE', RecordType = objRecordType1, Parent_Account__c = act.Id);
		Insert act1;
		
		
		List<Account> account_Obj = new List<Account>{new Account(LastName = 'BANDATest', FirstName = 'MARIATest', Type = 'null', Member_Verification_OTP_Invalid_Attempt__c = system.now(), Home_Phone__pc = '123456333390', Mobile_Phone__pc = '258963147852', Work_Phone__pc = '233333232323', PersonEmail = 'test@test.com', Alternate_Email__pc = 'abc@abc.com'),
		      												new Account(LastName = 'BANDATest1', FirstName = 'MARIATest1', Type = 'null', Member_Verification_OTP_Invalid_Attempt__c = system.now(), Home_Phone__pc = '1234563333903', Mobile_Phone__pc = '2589631478524', Work_Phone__pc = '2333332323235', PersonEmail = 'test@test.com1', Alternate_Email__pc = 'abc@abc.com1')};
    	Insert account_Obj;
    
		List<Person_Account__c> person_obj= new List<Person_Account__c>{new Person_Account__c(Account_Number__c = act.Id, PersonID__c = account_Obj[0].Id), new Person_Account__c(Account_Number__c = act1.Id, PersonID__c = account_Obj[1].Id)};
		     Insert person_obj;
		     
		test.StopTest();
}
	
	// Test Method: getData
	public static testmethod void Test_getData(){
		
		List<Account_Details__c> objAct_Details= [select Id from Account_Details__c limit 2];
		
		
		// TODO : Change following Assert Statement
		System.Assert(PersonNameLightningController.getData(objAct_Details[0].Id) != null);
		
	}
	
	
	public static testmethod void Test_getData1(){
		
		List<Account_Details__c> objAct_Details= [select Id from Account_Details__c limit 2];
		
		
		// TODO : Change following Assert Statement
		System.Assert(PersonNameLightningController.getData(objAct_Details[1].Id) != null);
		
	}
}