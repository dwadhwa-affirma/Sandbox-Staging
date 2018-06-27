@isTest

public class NeedAssessmentLightningControllerTest
{
	//Initial Test Data
	//Add Logic to Create data required
	public static string accountid = null;
	@testSetup
 static void setupTestData(){
  	system.debug('###setupTestData');
		    
		    Account account_Obj = new Account(Name = 'MARIA BANDA', PersonHasOptedOutOfEmail = false, 
		    				NA_Eligibility__c = false, 
		    			NA_LEAV_Complete__c = true, NA_LECF_Complete__c = true, NA_LECP_Complete__c = true, 
		    			NA_LEEM_Complete__c = true, NA_LEHS_Complete__c = true,
						NA_LEHS_Update__c = null, NA_LEMD_Complete__c = false, 
						NA_LEMP_Complete__c = false, NA_LEMQ_Complete__c = true, NA_LEOL_Complete__c = true, 
						NA_LEOM_Complete__c = true, NA_LEOM_Update__c = null, NA_LEPT_Complete__c = true, 
						NA_LESB_Complete__c = false, NA_LESF_Complete__c = true, NA_LEWS_Complete__c = true, 
						NA_Opt_Out_Date__c = null, NA_Opt_Out_Updated__c = null, 
						NA_Opt_Out__c = false);
		    Insert account_Obj; 
		    accountid = account_Obj.id;
		    system.debug('###setupTestData##account_Obj' + account_Obj.id);
		    Needs_Assesment__c needs_assesment_Obj = new Needs_Assesment__c(
		    		CreatedDate = Date.ValueOf('2017-12-18 12:23:33'), 
		    		LastModifiedDate = Date.ValueOf('2018-02-02 07:12:25'), 
		    		Member__c = account_Obj.id, CDs__c = false, College_Plan__c = 'Both', 
		    		College_Timeframe__c = '3-5 years', College__c = 'Prefer Not to Answer', Complete_PFCE__c = false, 
		    		Do_you_Rent_or_Own__c = 'Prefer Not To Answer', EBMS_Complete__c = false, EMYS_Complete__c = false, 
		    		Home_Improvement_Plan__c = 'Finance', Home_Improvement_Timeframe__c = '6-12 months', 
		    		Home_Improvement__c = 'Yes', Housing_Last_Updated_On__c = null, LEAV_AnticipateFinance__c = 'Yes', LEAV_ContactPreferences__c = 'test', LEAV_CurrentBalance__c = 1231321.00, LEAV_CurrentLoanProvider__c = 'Citibank', LEAV_CurrentRate__c = 12.69, LEAV_Current__c = 'No', LEAV_EndDateLoan__c = Date.ValueOf('2017-12-22 00:00:00'), LEAV_Last_Updated_On__c = Date.ValueOf('2018-01-19 00:00:00'), LEAV_PlanDate__c = Date.ValueOf('2017-12-30 00:00:00'), LEAV_PlanningToBuy__c = 'Yes', LECF_800_Feedback__c = null, LECF_800__c = true, LECF_ATM_Feedback__c = null, LECF_ATM__c = true, LECF_Branch_Feedback__c = null, LECF_Branch__c = true, LECF_Comment__c = 'w', LECF_Experience_Improvement_Feedback__c = 'wd', LECF_Last_Updated_On__c = Date.ValueOf('2018-02-01 00:00:00'), LECF_Member_Feedback__c = null, LECF_Mobile_banking_Feedback__c = null, LECF_Mobile_banking__c = false, LECF_Online_banking_Feedback__c = null, LECF_Online_banking__c = true, LECP_Comments__c = null, LECP_ContactPhone_No__c = false, LECP_ContactPhone_Yes__c = false, LECP_Last_Updated_On__c = Date.ValueOf('2018-01-22 00:00:00'), LECP_Written_Materials_Way_To_Send_Email__c = true, LECP_Written_Materials_Way_To_Send_Mail__c = true, LEEM_Comments__c = 'sad1', LEEM_Deductible_Plan_No__c = false, LEEM_Deductible_Plan_Yes__c = false, LEEM_Deductible_Plan__c = 'Yes', LEEM_Health_Savings_Account_No__c = false, LEEM_Health_Savings_Account_Yes__c = false, LEEM_Health_Savings_Account__c = 'No', LEEM_Last_Updated_On__c = Date.ValueOf('2018-02-01 00:00:00'), LEEM_Money_In_Primary_Account__c = 12.00, LEEM_Retirement_Savings_Accounts_Comment__c = null, LEEM_Savings_For_Retirement_401__c = true, LEEM_Savings_For_Retirement_IRA__c = true, LEEM_Savings_For_Retirement_O_Account__c = true, LEEM_Savings_For_Retirement_O_R_Account__c = true, LEHS_1_Status__c = 'Not Presented', LEHS_2_Status__c = 'Not Presented', LEHS_Comment__c = 'asds', LEHS_Complete__c = false, LEHS_Current_Balance__c = 12.00, LEHS_Current_Lender__c = 'Spectrum Credit Union', LEHS_End_Date__c = null, LEHS_Have_Realtor__c = 'Yes', LEHS_Last_Updated_On__c = Date.ValueOf('2018-01-22 00:00:00'), LEHS_Planning_to_Purchase__c = 'No', LEHS_Purchase_When__c = '3-6 months', LEHS_Rate__c = 12.00, LEMD_ATM__c = true, LEMD_At_another_financial_insti_YesNo__c = null, LEMD_At_another_financial_institution__c = false, LEMD_CFCU_Spectrum_YesNo__c = null, LEMD_CFCU_Spectrum__c = false, LEMD_CommentsDC__c = 'aaaaaaaaa', LEMD_CommentsForDD__c = null, LEMD_In_person_branch__c = true, LEMD_Last_Updated_On__c = Date.ValueOf('2018-01-22 00:00:00'), LEMD_Mobile__c = true, LEMD_No__c = false, LEMD_Online__c = true, LEMP_Carry_Credit_Card_Balance__c = 'Yes', LEMP_Credit_Card_Usage_Cash_Back__c = true, LEMP_Credit_Card_Usage_Comments__c = null, LEMP_Credit_Card_Usage_Low_Interest_Rate__c = true, LEMP_Credit_Card_Usage_No_Annual_Fee__c = true, LEMP_Credit_Card_Usage_Other__c = null, LEMP_Credit_Card_Usage_Reason_Comments__c = null, LEMP_Credit_Card_Usage_Rewards__c = true, LEMP_Credit_Card_You_Use_Often__c = null, LEMP_Debit_Card_Usage_Comments__c = null, LEMP_Debit_Card_Usage_Gasstation__c = true, LEMP_Debit_Card_Usage_Grocries__c = true, LEMP_Debit_Card_Usage_Online__c = true, LEMP_Debit_Card_Usage_Other__c = true, LEMP_Debit_Card_Usage_Retail__c = true, LEMP_International_Transfer_Comments__c = null, LEMP_International_Transfer_Frequency__c = 'Rarely', LEMP_Last_Updated_On__c = Date.ValueOf('2018-01-22 00:00:00'), LEMP_Pay_Individuals_A2A__c = true, LEMP_Pay_Individuals_ACH__c = true, LEMP_Pay_Individuals_BillPay__c = true, LEMP_Pay_Individuals_CC__c = true, LEMP_Pay_Individuals_Check__c = false, LEMP_Pay_Individuals_DC__c = true, LEMP_Pay_Individuals_Other__c = true, LEMP_Pay_MoveMoney_A2A__c = true, LEMP_Pay_MoveMoney_ACH__c = true, LEMP_Pay_MoveMoney_BillPay__c = true, LEMP_Pay_MoveMoney_CC__c = true, LEMP_Pay_MoveMoney_Check__c = false, LEMP_Pay_MoveMoney_DC__c = true, LEMP_Pay_MoveMoney_Other__c = true, LEMP_Pay_Recurring_A2A__c = false, LEMP_Pay_Recurring_ACH__c = false, LEMP_Pay_Recurring_BillPay__c = false, LEMP_Pay_Recurring_CC__c = false, LEMP_Pay_Recurring_Check__c = false, LEMP_Pay_Recurring_DC__c = false, LEMP_Pay_Recurring_Other__c = false, LEMP_Payment_Transfer_Comments__c = null, LEMP_Transfer_Comments__c = null, LEMP_Transfer_Frequency__c = null, LEMQ_Last_Updated_On__c = Date.ValueOf('2018-01-22 00:00:00'), LEOL_Last_Updated_On__c = Date.ValueOf('2018-01-22 00:00:00'), LEOL_Other_Existing_Loans__c = 'No', LEOM_1_Status__c = 'Not Presented', LEOM_2_Status__c = 'Not Presented', LEOM_3_Status__c = 'Not Presented', LEOM_4_Status__c = 'Not Presented', LEOM_5_Status__c = 'Not Presented', LEOM_6_Status__c = 'Not Presented', LEOM_7_Status__c = 'Not Presented', LEOM_College_Update__c = Date.ValueOf('2017-12-26 00:00:00'), LEOM_Comments__c = 'sadsads', LEOM_Complete__c = false, LEOM_Home_Update__c = Date.ValueOf('2017-12-26 00:00:00'), LEOM_Last_Updated_On__c = Date.ValueOf('2018-01-19 00:00:00'), LEOM_Life_Events_Update__c = Date.ValueOf('2017-12-25 00:00:00'), LEOM_Medical_Update__c = Date.ValueOf('2017-12-26 00:00:00'), LEOM_Other_Expenses_Update__c = Date.ValueOf('2017-12-26 00:00:00'), LEOM_PlanUnforeseen__c = 'asdsd', LEOM_RV_Boat_Update__c = Date.ValueOf('2017-12-26 00:00:00'), LEOM_Retirement_Update__c = Date.ValueOf('2017-12-28 00:00:00'), LEOM_Travel_Update__c = Date.ValueOf('2017-12-26 00:00:00'), LEPT_Comments__c = 'aaaaaaaaaaaaa', LEPT_Convenient_locations__c = true, LEPT_Deposit_rates__c = true, LEPT_Financial_Institution__c = 'Chase Bank', LEPT_Have_financial_advisor_there__c = false, LEPT_Last_Response_Date_For_FI__c = Date.ValueOf('2017-12-26 00:00:00'), LEPT_Last_Response_Date_for_Comments__c = Date.ValueOf('2017-12-22 00:00:00'), LEPT_Last_Updated_On__c = Date.ValueOf('2017-12-26 00:00:00'), LEPT_Loan_rates__c = false, LEPT_Online_mobile_apps__c = false, LEPT_Other__c = false, LESB_Aware_ConvBranching__c = null, LESB_Aware_SharedBranching__c = null, LESB_Last_Updated_On__c = Date.ValueOf('2018-01-22 00:00:00'), LESB_SharedBranching_Comments__c = 'aaaaaaaaaaaaaaaaaaaaaaa', LESF_ATM_Location_YesNo__c = 'Yes', LESF_ATM_Location__c = false, LESF_Aware_ATM_Netword__c = false, LESF_Aware_ATM_Network_YesNo__c = 'Yes', LESF_Comments__c = 'aaaaaaaaaaaaaaa', LESF_Last_Updated_On__c = Date.ValueOf('2018-01-18 00:00:00'), LEWS_CFCU_ATM__c = true, LEWS_Comment__c = 'SADS', LEWS_InPerson__c = true, LEWS_Last_Updated_On__c = Date.ValueOf('2018-01-22 00:00:00'), LEWS_Other_ATM__c = true, LEWS_Shared_ATM__c = false, Life_Events_Plan__c = 'Savings', Life_Events_Timeframe__c = '3-6 months', Life_Events__c = 'Yes', Medical_Plan__c = 'Finance', Medical_Timeframe__c = '10+ years', Medical__c = 'No', Other_Plan__c = 'Finance', Other_Timeframe__c = '3-6 months', Other__c = 'Yes', Purchase_RV_Boat_Plan__c = 'Both', Purchase_RV_Boat_Timeframe__c = '6-12 months', Purchase_RV_Boat__c = 'Yes', REC_LEAV_1__c = true, REC_LEAV_Outcome_1__c = 'Interested at a later date', REC_LECF_1__c = true, REC_LECF_2__c = true, REC_LECF_3__c = false, REC_LECF_4__c = true, REC_LECF_Outcome_1__c = 'Not Presented', REC_LECF_Outcome_2__c = 'Interested at a later date', REC_LECF_Outcome_3__c = 'Not Presented', REC_LECF_Outcome_4__c = 'Not Presented', REC_LEEM_1__c = true, REC_LEEM_2__c = true, REC_LEMD_1__c = false, REC_LEMD_2__c = false, REC_LEMD_3__c = false, REC_LEMD_Outcome_1__c = 'Not Presented', REC_LEMD_Outcome_2__c = 'Not Presented', REC_LEMD_Outcome_3__c = 'Not Presented', REC_LEMP_1__c = false, REC_LEMP_2__c = false, REC_LEMP_3__c = false, REC_LEMP_4__c = false, REC_LEMP_5__c = false, REC_LEMP_6__c = false, REC_LEMP_7__c = false, REC_LEMP_8__c = false, REC_LEMP_Outcome_1__c = null, REC_LEMP_Outcome_2__c = null, REC_LEMP_Outcome_3__c = null, REC_LEMP_Outcome_4__c = null, REC_LEMP_Outcome_5__c = null, REC_LEMP_Outcome_6__c = null, REC_LEMP_Outcome_7__c = null, REC_LEMP_Outcome_8__c = null, REC_LEMQ_Outcome_1__c = 'Informed', REC_LEPT_1__c = false, REC_LEPT_Outcome_1__c = 'Not Presented', Rec_Comment__c = 'sadsa', Rec_LEEM_Outcome_1__c = 'Interested soon', Rec_LEEM_Outcome_2__c = 'Not Presented', Rec_LEHS_1_Outcome__c = null, Rec_LEHS_1__c = true, Rec_LEHS_2__c = true, Rec_LEHS_Outcome_2__c = null, Rec_LEMQ_1__c = true, Rec_LEOL_1__c = true, Rec_LEOL_Outcome_1__c = 'Not Presented', Rec_LEOM_1__c = true, Rec_LEOM_2__c = true, Rec_LEOM_3__c = false, Rec_LEOM_4__c = false, Rec_LEOM_5__c = true, Rec_LEOM_6__c = true, Rec_LEOM_7__c = false, Rec_LEOM_Outcome_1__c = 'Not Presented', Rec_LEOM_Outcome_2__c = 'Not Presented', Rec_LEOM_Outcome_3__c = 'Interested at a later date', Rec_LEOM_Outcome_4__c = 'Interested at a later date', Rec_LEOM_Outcome_5__c = 'Not Presented', Rec_LEOM_Outcome_6__c = 'Not Presented', Rec_LEOM_Outcome_7__c = 'Not Presented', Retirement_Plan__c = 'Finance', Retirement_Timeframe__c = '1-3 years', Retirement__c = null, Travel_Plan__c = 'Savings', Travel_Timeframe__c = '5-10 years', Travel__c = 'Yes', Rec_LEHS_3__c = false, Rec_LEHS_Outcome_3__c = 'Not Presented', LEHS_End_Year__c = 2042, LEHS_Type_of_Mortgage__c = '20 Year Fixed', Rec_LEOL_2__c = true, Rec_LEOL_Outcome_2__c = 'Not Presented', Retirement_New__c = 'Yes');
		    Insert needs_assesment_Obj; 
		    
		    
		      Account_Details__c account_details_Obj = new Account_Details__c(Onboarded__c = false, RecType__c = 'ACCT', TypeTranslate__c = '2-TRUST');
    			Insert account_details_Obj;
		    
			Person_Account__c person_account_Obj = new Person_Account__c(Account_Number__c = account_details_Obj.id, PersonID__c = account_Obj.id, Relationship__c = null, TypeTranslate__c = '0000/Primary');
    		Insert person_account_Obj; 
    		
    		InsertCustomSettings('Contact Preference');
    		InsertCustomSettings('Current Feedback');
    		InsertCustomSettings('Housing');
    		InsertCustomSettings('Other Loan');
    		InsertCustomSettings('Auto Vehicle');
    		InsertCustomSettings('NA Other Milestones');
    		InsertCustomSettings('Move Your Money');
    		InsertCustomSettings('MakingDeposits');
    		InsertCustomSettings('Withdrawal');
    		InsertCustomSettings('Shared Branching');
    		InsertCustomSettings('ATM Network');
    		InsertCustomSettings('PrimaryTransaction');
    		InsertCustomSettings('Earn More');
    		InsertCustomSettings('Extend Benifits');
    		
    		
    		
		    
  }
  
  public static void InsertCustomSettings(string value)
  {
  GracePeriod__c	  mycs = new GracePeriod__c(); 
              mycs.Name= value;
              mycs.ExpiresInDays__c = 1;
              mycs.GracePeriod__c = 1;
              insert mycs;  
  }
  
  public static testmethod void Test_SaveNeedAssessmentDataHousing(){
  		test.startTest();
  		
    	account acc = [select id from account limit 1];
		accountid = acc.id;
		system.debug('##accountid' + accountid);	
		List<Needs_Assesment__c> na = new List<Needs_Assesment__c>();
		na = getAssessment();
		NeedAssessmentLightningController.SaveNeedAssessmentData(na[0], 'Housing', accountid, null, null);				
		test.stopTest();
  }
  
  public static testmethod void Test_SaveNeedAssessmentDataContactPreference(){
  		test.startTest();
  		
    	account acc = [select id from account limit 1];
		accountid = acc.id;
		system.debug('##accountid' + accountid);	
		List<Needs_Assesment__c> na = new List<Needs_Assesment__c>();
		na = getAssessment();
		NeedAssessmentLightningController.SaveNeedAssessmentData(na[0], 'ContactPreference', accountid, null, null);				
		test.stopTest();
  }
  
  public static testmethod void Test_SaveNeedAssessmentDataATMNETWORK(){
  		test.startTest();
  		
    	account acc = [select id from account limit 1];
		accountid = acc.id;
		system.debug('##accountid' + accountid);	
		List<Needs_Assesment__c> na = new List<Needs_Assesment__c>();
		na = getAssessment();
		NeedAssessmentLightningController.SaveNeedAssessmentData(na[0], 'ATMNETWORK', accountid, null, null);				
		test.stopTest();
  }
  
  public static testmethod void Test_SaveNeedAssessmentDataAutoVehicle(){
  		test.startTest();
  		
    	account acc = [select id from account limit 1];
		accountid = acc.id;
		system.debug('##accountid' + accountid);	
		List<Needs_Assesment__c> na = new List<Needs_Assesment__c>();
		na = getAssessment();
		NeedAssessmentLightningController.SaveNeedAssessmentData(na[0], 'AutoVehicle', accountid, null, null);				
		test.stopTest();
  }
  
   public static testmethod void Test_SaveNeedAssessmentDataWithdrawals(){
  		test.startTest();
  		
    	account acc = [select id from account limit 1];
		accountid = acc.id;
		system.debug('##accountid' + accountid);	
		List<Needs_Assesment__c> na = new List<Needs_Assesment__c>();
		na = getAssessment();
		NeedAssessmentLightningController.SaveNeedAssessmentData(na[0], 'Withdrawals', accountid, null, null);				
		test.stopTest();
  }
  
  public static testmethod void Test_SaveNeedAssessmentDataSharedBranching(){
  		test.startTest();
  		
    	account acc = [select id from account limit 1];
		accountid = acc.id;
		system.debug('##accountid' + accountid);	
		List<Needs_Assesment__c> na = new List<Needs_Assesment__c>();
		na = getAssessment();
		NeedAssessmentLightningController.SaveNeedAssessmentData(na[0], 'SharedBranching', accountid, null, null);				
		test.stopTest();
  }
  
  public static testmethod void Test_SaveNeedAssessmentDataPaymentsTransfers(){
  		test.startTest();
  		
    	account acc = [select id from account limit 1];
		accountid = acc.id;
		system.debug('##accountid' + accountid);	
		List<Needs_Assesment__c> na = new List<Needs_Assesment__c>();
		na = getAssessment();
		NeedAssessmentLightningController.SaveNeedAssessmentData(na[0], 'PaymentsTransfers', accountid, null, null);				
		test.stopTest();
  }
	
	
	public static testmethod void Test_SaveNeedAssessmentDataDeposits(){
  		test.startTest();
  		
    	account acc = [select id from account limit 1];
		accountid = acc.id;
		system.debug('##accountid' + accountid);	
		List<Needs_Assesment__c> na = new List<Needs_Assesment__c>();
		na = getAssessment();
		NeedAssessmentLightningController.SaveNeedAssessmentData(na[0], 'Deposits', accountid, null, null);				
		test.stopTest();
  }	
  
  
  public static testmethod void Test_SaveNeedAssessmentDataCurrentFeedback(){
  		test.startTest();
  		
    	account acc = [select id from account limit 1];
		accountid = acc.id;
		system.debug('##accountid' + accountid);	
		List<Needs_Assesment__c> na = new List<Needs_Assesment__c>();
		na = getAssessment();
		NeedAssessmentLightningController.SaveNeedAssessmentData(na[0], 'CurrentFeedback', accountid, null, null);				
		test.stopTest();
  }	
		
		public static testmethod void Test_SaveNeedAssessmentDataOtherMilestones(){
  		test.startTest();
  		
    	account acc = [select id from account limit 1];
		accountid = acc.id;
		system.debug('##accountid' + accountid);	
		List<Needs_Assesment__c> na = new List<Needs_Assesment__c>();
		na = getAssessment();
		NeedAssessmentLightningController.SaveNeedAssessmentData(na[0], 'OtherMilestones', accountid, null, null);				
		test.stopTest();
  }	
		
	public static testmethod void Test_SaveNeedAssessmentDataPrimaryAccount(){
  		test.startTest();
  		
    	account acc = [select id from account limit 1];
		accountid = acc.id;
		system.debug('##accountid' + accountid);	
		List<Needs_Assesment__c> na = new List<Needs_Assesment__c>();
		na = getAssessment();
		NeedAssessmentLightningController.SaveNeedAssessmentData(na[0], 'PrimaryAccount', accountid, null, null);				
		test.stopTest();
  }		
  
  	public static testmethod void Test_SaveNeedAssessmentDataExistingLoans(){
  		test.startTest();
  		
    	account acc = [select id from account limit 1];
		accountid = acc.id;
		system.debug('##accountid' + accountid);	
		List<Needs_Assesment__c> na = new List<Needs_Assesment__c>();
		na = getAssessment();
		List<NA_Other_Existing_Loans__c> listQueue = new List<NA_Other_Existing_Loans__c>();
	    string dataserialize = JSON.serialize(listQueue);
	    
		NeedAssessmentLightningController.SaveNeedAssessmentData(na[0], 'ExistingLoans', accountid, dataserialize, null);				
		test.stopTest();
  }
  public static testmethod void Test_SaveNeedAssessmentDataMembership(){
  		test.startTest();
  		
    	account acc = [select id from account limit 1];
		accountid = acc.id;
		system.debug('##accountid' + accountid);	
		List<Needs_Assesment__c> na = new List<Needs_Assesment__c>();
		na = getAssessment();
		
		List<NA_Membership_Referral_Questions__c> listQueue = new List<NA_Membership_Referral_Questions__c>();
	    string dataserialize = JSON.serialize(listQueue);
		
		NeedAssessmentLightningController.SaveNeedAssessmentData(na[0], 'Membership', accountid, dataserialize, null);				
		test.stopTest();
  }		
		public static testmethod void Test_SaveNeedAssessmentDataEarnMore(){
  		test.startTest();
  		
    	account acc = [select id from account limit 1];
		accountid = acc.id;
		system.debug('##accountid' + accountid);	
		List<Needs_Assesment__c> na = new List<Needs_Assesment__c>();
		na = getAssessment();
		
		List<NA_Deposit__c> listQueue = new List<NA_Deposit__c>();
	    string dataserialize = JSON.serialize(listQueue);
    
    
		NeedAssessmentLightningController.SaveNeedAssessmentData(na[0], 'EarnMore', accountid, dataserialize, null);				
		test.stopTest();
  }		
  public static testmethod void Test_SaveNeedAssessmentDataRecommendations(){
  		test.startTest();
  		
    	account acc = [select id from account limit 1];
		accountid = acc.id;
		system.debug('##accountid' + accountid);	
		List<Needs_Assesment__c> na = new List<Needs_Assesment__c>();
		na = getAssessment();
		NeedAssessmentLightningController.SaveNeedAssessmentData(na[0], 'Recommendations', accountid, null, null);				
		test.stopTest();
  }		
  
  private static List<Needs_Assesment__c> getAssessment()
  {
		List<Needs_Assesment__c> na = [select Id,LEEM_Last_Updated_On__c,LEMQ_Last_Updated_On__c,LEOM_Last_Updated_On__c,LEAV_Last_Updated_On__c ,LESF_Last_Updated_On__c, LESB_Last_Updated_On__c, LEMD_Last_Updated_On__c, LECP_Last_Updated_On__c, LEHS_Last_Updated_On__c, LEOL_Last_Updated_On__c, LECF_Last_Updated_On__c, LEWS_Last_Updated_On__c,LECP_Written_Materials_Way_To_Send_Email__c,LECP_Written_Materials_Way_To_Send_Mail__c,Do_you_Rent_or_Own__c,
    	  		LEHS_Current_Lender__c, LEHS_Type_of_Mortgage__c,LEHS_Rate__c,LEHS_Current_Balance__c,LEHS_End_Year__c,LEHS_Planning_to_Purchase__c,LEHS_Purchase_When__c, LEHS_Have_Realtor__c,
    	  		LEHS_Comment_New__c,Rec_LEHS_1__c,Rec_LEHS_2__c, LECF_800__c,LECF_Experience_Improvement_Feedback_New__c, LECF_Online_banking__c, LECF_Mobile_banking__c, LECF_ATM__c, LECF_Comment_New__c,
    	  		LEMP_Last_Updated_On__c, LEPT_Last_Updated_On__c, LECF_Branch__c,LESB_Aware_SharedBranching__c,LESB_Aware_ConvBranching__c,LESB_SharedBranching_Comments_New__c,REC_LEMD_3__c,
    	  		LEAV_Current__c, LEAV_CurrentLoanProvider__c, LEAV_CurrentRate__c, LEAV_CurrentBalance__c, LEAV_EndDateLoan__c,LEMP_Credit_Card_Usage_Reason_Comments_N__c,
    	  		LEAV_PlanningToBuy__c, LEAV_PlanDate__c, LEAV_AnticipateFinance__c, LEAV_ContactPreferences_New__c,REC_LEAV_1__c, REC_LECF_4__c, REC_LECF_3__c, REC_LECF_2__c, REC_LECF_1__c, LEWS_Comment_New__c, LEWS_InPerson__c, LEWS_Other_ATM__c, LEWS_Shared_ATM__c, LEWS_CFCU_ATM__c,    	  		
    	  		Home_Improvement__c, Home_Improvement_Timeframe__c, Home_Improvement_Plan__c, College__c, College_Timeframe__c, College_Plan__c,
				Medical__c, Medical_Timeframe__c, Medical_Plan__c, Purchase_RV_Boat__c, Purchase_RV_Boat_Timeframe__c, Purchase_RV_Boat_Plan__c, Retirement_New__c, Retirement_Timeframe__c, 
				Retirement_Plan__c, Travel__c, Travel_Timeframe__c, Travel_Plan__c, Life_Events__c, Life_Events_Timeframe__c, Life_Events_Plan__c, Other__c, Other_Timeframe__c, Other_Plan__c,
				Rec_LEOM_1__c,Rec_LEOM_2__c,Rec_LEOM_3__c,Rec_LEOM_4__c,Rec_LEOM_5__c,Rec_LEOM_6__c,LEOM_PlanUnforeseen_New__c,LEOM_Comments_New__c,LEMP_Credit_Card_You_Use_Often_New__c,
				LEOM_Home_Update__c,LEOM_College_Update__c, LEOM_Medical_Update__c, LEOM_RV_Boat_Update__c, LEOM_Retirement_Update__c, REC_LEEM_1__c,REC_LEMP_1__c, REC_LEMP_2__c, REC_LEMP_3__c, REC_LEMP_4__c, REC_LEMP_5__c, REC_LEMP_6__c, REC_LEMP_7__c, REC_LEMP_8__c,
				LEOM_Travel_Update__c,LEOM_Life_Events_Update__c, LEOM_Other_Expenses_Update__c, LEMD_CFCU_Spectrum_YesNo__c, LEMD_At_another_financial_insti_YesNo__c, LEMD_CommentsForDD_New__c, LEMD_In_person_branch__c, Needs_Assesment__c.LEMD_ATM__c, LEMD_Online__c, LEMD_Mobile__c, 
				LEMD_CommentsDC_New__c, REC_LEMD_1__c, REC_LEMD_2__c,LESF_Aware_ATM_Network_YesNo__c, LESF_ATM_Location_YesNo__c,LESF_Comments_New__c,LEMP_Credit_Card_Usage_Other_New__c,LEMP_Credit_Card_Usage_Low_Interest_Rate__c,LEMP_Credit_Card_Usage_Cash_Back__c,LEMP_Credit_Card_Usage_Rewards__c,LEMP_Credit_Card_Usage_No_Annual_Fee__c,
				LEPT_Financial_Institution__c, LEPT_Convenient_locations__c, LEPT_Deposit_rates__c, LEPT_Loan_rates__c,LEMP_Credit_Card_Usage_Comments_New__c,
				LEPT_Have_financial_advisor_there__c, LEPT_Online_mobile_apps__c,LEPT_Other__c,REC_LEPT_1__c, LEPT_Comments_New__c,LEMP_Pay_Recurring_Check__c, LEMP_Debit_Card_Usage_Comments_New__c, LEMP_International_Transfer_Comments_New__c, LEMP_Pay_Recurring_BillPay__c, LEMP_Pay_Recurring_DC__c, LEMP_Pay_Recurring_CC__c, LEMP_Pay_Recurring_ACH__c, LEMP_Pay_Recurring_A2A__c, LEMP_Pay_Recurring_Other__c, LEMP_Pay_Individuals_Check__c, LEMP_Pay_Individuals_BillPay__c, LEMP_Pay_Individuals_DC__c, LEMP_Pay_Individuals_CC__c, LEMP_Pay_Individuals_ACH__c, LEMP_Pay_Individuals_A2A__c, LEMP_Pay_Individuals_Other__c, LEMP_Pay_MoveMoney_Check__c, LEMP_Pay_MoveMoney_BillPay__c, LEMP_Pay_MoveMoney_DC__c, LEMP_Pay_MoveMoney_CC__c, LEMP_Pay_MoveMoney_ACH__c, LEMP_Pay_MoveMoney_A2A__c, LEMP_Pay_MoveMoney_Other__c, LEMP_Payment_Transfer_Comments_New__c, LEMP_Transfer_Frequency__c, LEMP_Transfer_Comments_New__c, LEMP_International_Transfer_Frequency__c, 
				LEOL_Other_Existing_Loans__c, Rec_LEOL_1__c, Rec_LEOL_2__c,LEMP_Debit_Card_Usage_Retail__c,LEMP_Carry_Credit_Card_Balance__c,
				Rec_LEMQ_1__c, LEEM_Money_In_Primary_Account__c, LEEM_Savings_For_Retirement_401__c,LEEM_Savings_For_Retirement_IRA__c,LEMP_Debit_Card_Usage_Grocries__c, LEMP_Debit_Card_Usage_Gasstation__c, LEMP_Debit_Card_Usage_Online__c, LEMP_Debit_Card_Usage_Other__c, 
				LEEM_Savings_For_Retirement_O_R_Account__c,LEEM_Savings_For_Retirement_O_Account__c,LEEM_Comments_New__c,LEEM_Deductible_Plan__c,LEEM_Health_Savings_Account__c, REC_LEEM_2__c,
				Rec_LEOM_Outcome_1__c,Rec_LEEM_Outcome_2__c, REC_LEMD_Outcome_2__c,REC_LEMD_Outcome_1__c, Rec_LEEM_Outcome_1__c, Rec_LEOM_Outcome_2__c, Rec_LEOM_Outcome_3__c, Rec_LEOM_Outcome_4__c, Rec_LEOM_Outcome_5__c, Rec_LEOM_Outcome_6__c, 
				Rec_LEOM_Outcome_7__c, Rec_LEOL_Outcome_1__c, Rec_LEOL_Outcome_2__c, REC_LEAV_Outcome_1__c, Rec_LEHS_1_Outcome__c, 
				Rec_LEHS_Outcome_2__c, Rec_LECF_Outcome_1__c, Rec_LECF_Outcome_2__c, Rec_LECF_Outcome_3__c, Rec_LECF_Outcome_4__c, 
				REC_LEMP_Outcome_1__c, REC_LEMP_Outcome_2__c, REC_LEMP_Outcome_3__c, REC_LEMP_Outcome_4__c, REC_LEMP_Outcome_5__c, 
				REC_LEMP_Outcome_6__c, REC_LEMP_Outcome_7__c, REC_LEMP_Outcome_8__c, REC_LEPT_Outcome_1__c, REC_LEMD_Outcome_3__c, 
				REC_LEMQ_Outcome_1__c, Rec_Comment__c, LECF_Branch_Feedback__c,LECF_800_Feedback__c, LECF_Online_banking_Feedback__c, LECF_ATM_Feedback__c,
				LECF_Mobile_banking_Feedback__c, Member__c
    	  		from Needs_Assesment__c where Member__c =: accountid limit 1];
    	  		
    	  		return na;
  }
  
  
  public static testmethod void Test_FetchNeedAssessmentData(){
  	
	 	test.startTest();
		account acc = [select id from account limit 1];
		accountid = acc.id;
		system.debug('##accountid' + accountid);
		NeedAssessmentLightningController.FetchNeedAssessmentData(accountid);
		test.stopTest();
	}
}