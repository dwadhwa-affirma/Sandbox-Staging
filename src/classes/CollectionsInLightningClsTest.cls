@isTest

private class CollectionsInLightningClsTest
{
	
	static void SetUp(){
		test.StartTest();
	}

	static void TearDown(){
		test.StopTest();
	}
	
	// Test Method: getPicklistValues
	public static testmethod void Test_getPicklistValues(){
		SetUp();
		string objpicklistfieldsmap = '';
		// TODO : Change following Assert Statement
		Account acc = new Account(
           //RecordTypeID=RecTypeId,
           FirstName='Test FName',
           LastName='Test LName',
           PersonMailingStreet='test@yahoo.com',
           PersonMailingPostalCode='12345',
           PersonMailingCity='SFO',
           PersonEmail='test@yahoo.com',
           PersonHomePhone='1234567',
           PersonMobilePhone='12345678');
         
        insert acc;
		Needs_Assesment__c NC;
        NC = new Needs_Assesment__c();
        
		NC.Home_Improvement__c = 'Prefer Not to Answer';
        NC.Home_Improvement_Timeframe__c='3-6 months';
        NC.Home_Improvement_Plan__c= 'Finance';
        NC.College__c= 'Yes';
        NC.College_Timeframe__c= '3-6 months';
        NC.College_Plan__c='Both';
        NC.Medical__c='Prefer Not to Answer';
        NC.Medical_Timeframe__c='3-6 months';
        NC.Medical_Plan__c='Both';
        NC.Purchase_RV_Boat__c='Yes';
        NC.Purchase_RV_Boat_Timeframe__c='3-6 months';
        NC.Purchase_RV_Boat_Plan__c='Savings';
        NC.Retirement_New__c='Yes';
        NC.Retirement_Timeframe__c='3-6 months';
        NC.Retirement_Plan__c='Savings';
        NC.Travel__c= 'Yes';
        NC.Travel_Timeframe__c='3-6 months';
        NC.Travel_Plan__c='Savings';
        NC.Life_Events__c='Prefer Not to Answer';
        NC.Life_Events_Timeframe__c='3-6 months';
        NC.Life_Events_Plan__c='Finance';
        NC.Other__c='Yes';
        NC.Other_Timeframe__c='3-6 months';
        NC.Other_Plan__c= 'Savings';   
        NC.Member__c =  acc.Id;
        insert NC;
        
        CollectionsInLightningCls.getPicklistValues('{"Needs_Assesment__c":["Do_you_Rent_or_Own__c","LEHS_Current_Lender__c","LEHS_Type_of_Mortgage__c","LEHS_Planning_to_Purchase__c","LEHS_Purchase_When__c","LEHS_Have_Realtor__c"]}');
	//	System.Assert(CollectionsInLightningCls.getPicklistValues(objpicklistfieldsmap) != null);
		TearDown();
	}
	// Test Method: getExistingLoans
	public static testmethod void Test_getExistingLoans(){
		SetUp();
		string assessmentid = '';
		// TODO : Change following Assert Statement
		System.Assert(CollectionsInLightningCls.getExistingLoans(assessmentid) != null);
		TearDown();
	}
	// Test Method: getMembershipLoans
	public static testmethod void Test_getMembershipLoans(){
		SetUp();
		string assessmentid = '';
		// TODO : Change following Assert Statement
		System.Assert(CollectionsInLightningCls.getMembershipLoans(assessmentid) != null);
		TearDown();
	}
	// Test Method: GetDepositData
	public static testmethod void Test_GetDepositData(){
		SetUp();
		string assessmentid = '';
		// TODO : Change following Assert Statement
		System.Assert(CollectionsInLightningCls.GetDepositData(assessmentid) != null);
		TearDown();
	}
	// Test Method: getYearPickList
	public static testmethod void Test_getYearPickList(){
		SetUp();
		// TODO : Change following Assert Statement
		System.Assert(CollectionsInLightningCls.getYearPickList() != null);
		TearDown();
	}
}