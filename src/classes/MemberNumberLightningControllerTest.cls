@isTest
private class MemberNumberLightningControllerTest
{
	
	public static testmethod void Test_FetchAccounts(){
		test.StartTest();
		
		Person_Account__c person_account_Obj = new Person_Account__c(CreatedDate = DateTime.now(), LastModifiedDate = DateTime.now(), Name_Type__c = 21, TypeTranslate__c = '001/Primary');
    	Insert person_account_Obj; 
				
		System.Assert(MemberNumberLightningController.FetchAccounts('0000147163') != null);
		test.StopTest();
	}
}