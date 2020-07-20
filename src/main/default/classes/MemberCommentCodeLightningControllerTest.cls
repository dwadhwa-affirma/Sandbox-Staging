@isTest
private class MemberCommentCodeLightningControllerTest
{

	 @testSetup
	static void setupTestData(){
	    test.startTest();
	    Account account_Obj = new Account(Name = 'MARIA BANDA', PersonHasOptedOutOfEmail = false, NA_Eligibility__c = false, NA_LEAV_Complete__c = true, NA_LECF_Complete__c = true, NA_LECP_Complete__c = false, NA_LEEM_Complete__c = true, NA_LEHS_Complete__c = true, NA_LEMD_Complete__c = false, NA_LEMP_Complete__c = false, NA_LEMQ_Complete__c = true, NA_LEOL_Complete__c = true, NA_LEOM_Complete__c = true, NA_LEPT_Complete__c = true, NA_LESB_Complete__c = false, NA_LESF_Complete__c = true, NA_LEWS_Complete__c = true, NA_Opt_Out__c = false);
	    Insert account_Obj; 
	    Account_Details__c account_details_Obj = new Account_Details__c(Name = '0260049344', Comment_Block_01__c = 'null', Comment_Block_02__c = 'null', Comment_Block_03__c = 'null', Comment_Block_04__c = 'umang', Comment_Block_05__c = 'test', Comment_Block_06__c = 'null', Comment_Block_07__c = 'null', Comment_Block_08__c = 'null', Comment_Block_09__c = 'null', Comment_Block_10__c = 'null', Comment_Block_11__c = 'null', Comment_Block_12__c = 'null', Comment_Block_13__c = 'null', Comment_Block_14__c = 'null', Comment_Block_15__c = 'null', Comment_Block_16__c = 'null', Comment_Block_17__c = 'null', Comment_Block_18__c = 'null', Comment_Block_19__c = 'null', Comment_Block_20__c = 'null', Comments_Block__c = 'SPECTRUM CREDIT UNION', Onboarded__c = false, RecType__c = 'ACCT', WARNING_01_CODE__c = 'null', WARNING_02_CODE__c = 'null', WARNING_03_CODE__c = 'null', WARNING_04_CODE__c = 'null', WARNING_05_CODE__c = 'null', WARNING_06_CODE__c = 'null', WARNING_07_CODE__c = 'null', WARNING_08_CODE__c = 'null', WARNING_09_CODE__c = 'null', WARNING_10_CODE__c = 'null', WARNING_11_CODE__c = 'null', WARNING_12_CODE__c = 'null', WARNING_13_CODE__c = 'null', WARNING_14_CODE__c = 'null', WARNING_15_CODE__c = 'null', WARNING_16_CODE__c = 'null', WARNING_17_CODE__c = 'null', WARNING_18_CODE__c = 'null', WARNING_19_CODE__c = 'null', WARNING_20_CODE__c = 'null');
	    Insert account_details_Obj; 
	    Person_Account__c person_account_Obj = new Person_Account__c(PersonID__c= account_Obj.id,Account_Number__c = account_details_Obj.id);
	    Insert person_account_Obj; 
	    test.stopTest();
  }
  
   static testMethod void test_getData_UseCase1(){
   		List<Account> account_Obj  =  [SELECT Id,Name,CreatedDate,CreatedById,LastModifiedDate,LastModifiedById,PersonHasOptedOutOfEmail,NA_Eligibility__c,NA_LEAV_Complete__c,NA_LECF_Complete__c,NA_LECP_Complete__c,NA_LEEM_Complete__c,NA_LEHS_Complete__c,NA_LEMD_Complete__c,NA_LEMP_Complete__c,NA_LEMQ_Complete__c,NA_LEOL_Complete__c,NA_LEOM_Complete__c,NA_LEPT_Complete__c,NA_LESB_Complete__c,NA_LESF_Complete__c,NA_LEWS_Complete__c,NA_Opt_Out__c from Account limit 1];
   	
   			MemberCommentsCodeLightningController.getData(account_Obj[0].id);
   }
}