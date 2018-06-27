@isTest
private class MemberAccountControllerTest
{
	
	// Test Method: GetAccountDetails
	public static testmethod void Test_GetAccountDetails(){
		//SetUp();
		//string accountid = '';
		Id rtId = [SELECT Id FROM RecordType WHERE IsPersonType = TRUE AND SObjectType='Account' LIMIT 1].Id;
		Account acc = new Account();
    	acc.RecordTypeID=rtId;
    	acc.FirstName='Test FName';
        acc.LastName='Test LName';    	
        insert acc;
  
        Account_Details__c accDetail = new Account_Details__c();
        accDetail.Name = 'Test123';
        accDetail.RecType__c = 'ACCT';
        accDetail.Reference__c = 'BC02';
        //accDetail.Comment_Block_01__c = 'TELEPHONE/EMAIL CHANGED WITHIN 60 DAYS';
        insert accDetail;
        
        Account_Details__c accDetail1 = new Account_Details__c();
        accDetail1.Name = 'Test123';
        accDetail1.RecType__c = 'ACCT';
        accDetail1.Reference__c = 'BC02';
        accDetail1.Parent_Account__c = accDetail.Id;
        //accDetail.Comment_Block_01__c = 'TELEPHONE/EMAIL CHANGED WITHIN 60 DAYS';
        insert accDetail1;
        
        Person_Account__c pa = new Person_Account__c();
        pa.PersonID__c = acc.Id;
        pa.Account_Number__c = accDetail.Id;        
        insert pa;
        
        pa = new Person_Account__c();
        pa.PersonID__c = acc.Id;
        pa.Account_Number__c = accDetail1.Id;        
        insert pa;
        
       
        MemberAccountController.GetAccountDetails(accDetail1.id);
		// TODO : Change following Assert Statement
		System.Assert(MemberAccountController.GetAccountDetails(accDetail1.id) != null);
		//TearDown();
	}
}