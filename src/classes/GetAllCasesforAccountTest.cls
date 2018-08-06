/**
 * This class contains unit tests for validating the behavior of Apex classes
 * and triggers.
 *
 * Unit tests are class methods that verify whether a particular piece
 * of code is working properly. Unit test methods take no arguments,
 * commit no data to the database, and are flagged with the testMethod
 * keyword in the method definition.
 *
 * All test methods in an organization are executed whenever Apex code is deployed
 * to a production organization to confirm correctness, ensure code
 * coverage, and prevent regressions. All Apex classes are
 * required to have at least 75% code coverage in order to be deployed
 * to a production organization. In addition, all triggers must have some code coverage.
 * 
 * The @isTest class annotation indicates this class only contains test
 * methods. Classes defined with the @isTest annotation do not count against
 * the organization size limit for all Apex scripts.
 *
 * See the Apex Language Reference for more information about Testing and Code Coverage.
 */
@isTest
private class GetAllCasesForAccountTest {
@testSetup
static void setupTestData(){
		
  }

    static testMethod void myUnitTest() {
    	    test.startTest();
		    List<Account_Details__c> account_details_Obj = new List<Account_Details__c>{
						    new Account_Details__c(Name = '0000147163', Balance__c = 0.00, Combined_Account_ID__c = '0000147163S0100P0100', ID1__c = '0100', Onboarded__c = true, RecType__c = 'ACCT', TypeTranslate__c = '1-PRIMARY SHARE',WARNING_01_CODE__c='ABC',
WARNING_02_CODE__c='ABC',
WARNING_03_CODE__c='ABC',
WARNING_04_CODE__c='ABC',
WARNING_05_CODE__c='ABC',
WARNING_06_CODE__c='ABC',
WARNING_07_CODE__c='ABC',
WARNING_08_CODE__c='ABC',
WARNING_09_CODE__c='ABC',
WARNING_10_CODE__c='ABC',
WARNING_11_CODE__c='ABC',
WARNING_12_CODE__c='ABC',
WARNING_13_CODE__c='ABC',
WARNING_14_CODE__c='ABC',
WARNING_15_CODE__c='ABC',
WARNING_16_CODE__c='ABC',
WARNING_17_CODE__c='ABC',
WARNING_18_CODE__c='ABC',
WARNING_19_CODE__c='ABC',
WARNING_20_CODE__c='ABC',
Comment_Block_01__c='ABC',
Comment_Block_02__c='ABC',
Comment_Block_03__c='ABC',
Comment_Block_04__c='ABC',
Comment_Block_05__c='ABC',
Comment_Block_06__c='ABC',
Comment_Block_07__c='ABC',
Comment_Block_08__c='ABC',
Comment_Block_09__c='ABC',
Comment_Block_10__c='ABC',
Comment_Block_11__c='ABC',
Comment_Block_12__c='ABC',
Comment_Block_13__c='ABC',
Comment_Block_14__c='ABC',
Comment_Block_15__c='ABC',
Comment_Block_16__c='ABC',
Comment_Block_17__c='ABC',
Comment_Block_18__c='ABC',
Comment_Block_19__c='ABC',
Comment_Block_20__c='ABC'
),
						    new Account_Details__c(Name = '0000147163', Balance__c = 0.00, Combined_Account_ID__c = '0000147163S0100P0100', ID1__c = '0100', Onboarded__c = true, RecType__c = 'SHAR', TypeTranslate__c = '1-PRIMARY SHARE',WARNING_01_CODE__c='ABC',
WARNING_02_CODE__c='ABC',
WARNING_03_CODE__c='ABC',
WARNING_04_CODE__c='ABC',
WARNING_05_CODE__c='ABC',
WARNING_06_CODE__c='ABC',
WARNING_07_CODE__c='ABC',
WARNING_08_CODE__c='ABC',
WARNING_09_CODE__c='ABC',
WARNING_10_CODE__c='ABC',
WARNING_11_CODE__c='ABC',
WARNING_12_CODE__c='ABC',
WARNING_13_CODE__c='ABC',
WARNING_14_CODE__c='ABC',
WARNING_15_CODE__c='ABC',
WARNING_16_CODE__c='ABC',
WARNING_17_CODE__c='ABC',
WARNING_18_CODE__c='ABC',
WARNING_19_CODE__c='ABC',
WARNING_20_CODE__c='ABC',
Comment_Block_01__c='ABC',
Comment_Block_02__c='ABC',
Comment_Block_03__c='ABC',
Comment_Block_04__c='ABC',
Comment_Block_05__c='ABC',
Comment_Block_06__c='ABC',
Comment_Block_07__c='ABC',
Comment_Block_08__c='ABC',
Comment_Block_09__c='ABC',
Comment_Block_10__c='ABC',
Comment_Block_11__c='ABC',
Comment_Block_12__c='ABC',
Comment_Block_13__c='ABC',
Comment_Block_14__c='ABC',
Comment_Block_15__c='ABC',
Comment_Block_16__c='ABC',
Comment_Block_17__c='ABC',
Comment_Block_18__c='ABC',
Comment_Block_19__c='ABC',
Comment_Block_20__c='ABC'
),
						    new Account_Details__c(Name = '0000147163', Balance__c = 0.00, Combined_Account_ID__c = '0000147163S0100P0100', ID1__c = '0100', Onboarded__c = true, RecType__c = 'CARD', TypeTranslate__c = '1-PRIMARY SHARE',WARNING_01_CODE__c='ABC',
WARNING_02_CODE__c='ABC',
WARNING_03_CODE__c='ABC',
WARNING_04_CODE__c='ABC',
WARNING_05_CODE__c='ABC',
WARNING_06_CODE__c='ABC',
WARNING_07_CODE__c='ABC',
WARNING_08_CODE__c='ABC',
WARNING_09_CODE__c='ABC',
WARNING_10_CODE__c='ABC',
WARNING_11_CODE__c='ABC',
WARNING_12_CODE__c='ABC',
WARNING_13_CODE__c='ABC',
WARNING_14_CODE__c='ABC',
WARNING_15_CODE__c='ABC',
WARNING_16_CODE__c='ABC',
WARNING_17_CODE__c='ABC',
WARNING_18_CODE__c='ABC',
WARNING_19_CODE__c='ABC',
WARNING_20_CODE__c='ABC',
Comment_Block_01__c='ABC',
Comment_Block_02__c='ABC',
Comment_Block_03__c='ABC',
Comment_Block_04__c='ABC',
Comment_Block_05__c='ABC',
Comment_Block_06__c='ABC',
Comment_Block_07__c='ABC',
Comment_Block_08__c='ABC',
Comment_Block_09__c='ABC',
Comment_Block_10__c='ABC',
Comment_Block_11__c='ABC',
Comment_Block_12__c='ABC',
Comment_Block_13__c='ABC',
Comment_Block_14__c='ABC',
Comment_Block_15__c='ABC',
Comment_Block_16__c='ABC',
Comment_Block_17__c='ABC',
Comment_Block_18__c='ABC',
Comment_Block_19__c='ABC',
Comment_Block_20__c='ABC'
)
						};
						

		    Insert account_details_Obj;
		    
		        Account account_Obj = new Account(LastName = 'BANDATest', FirstName = 'MARIATest', Type = 'null', PersonHasOptedOutOfEmail = false, NA_Eligibility__c = false, NA_LEAV_Complete__c = true, NA_LECF_Complete__c = true, NA_LECP_Complete__c = true, NA_LEEM_Complete__c = true, NA_LEHS_Complete__c = true, NA_LEMD_Complete__c = false, NA_LEMP_Complete__c = false, NA_LEMQ_Complete__c = true, NA_LEOL_Complete__c = true, NA_LEOM_Complete__c = true, NA_LEPT_Complete__c = true, NA_LESB_Complete__c = false, NA_LESF_Complete__c = true, NA_LEWS_Complete__c = true, NA_Opt_Out__c = false, smagicinteract__SMSOptOut__pc = false, et4ae5__HasOptedOutOfMobile__pc = false);
    Insert account_Obj; 
    
    Account_Details__c obj = [select id from Account_Details__c where id =: account_details_Obj[0].id];
    
    	List<Person_Account__c> person_obj= new List<Person_Account__c>{
    		new Person_Account__c(TypeTranslate__c='0000/Primary',Account_Number__c = account_details_Obj[0].id, PersonID__c = account_Obj.Id), 
    		new Person_Account__c(TypeTranslate__c='0000/Primary',Account_Number__c = account_details_Obj[0].Id, PersonID__c = account_Obj.Id), 
    		new Person_Account__c(Account_Number__c = account_details_Obj[2].Id, PersonID__c = account_Obj.Id)};
		     Insert person_obj;
		     
		Account account_Obj1 = new Account(LastName = 'BANDATest1', FirstName = 'MARIATest1', Type = 'null', PersonHasOptedOutOfEmail = false, NA_Eligibility__c = false, NA_LEAV_Complete__c = true, NA_LECF_Complete__c = true, NA_LECP_Complete__c = true, NA_LEEM_Complete__c = true, NA_LEHS_Complete__c = true, NA_LEMD_Complete__c = false, NA_LEMP_Complete__c = false, NA_LEMQ_Complete__c = true, NA_LEOL_Complete__c = true, NA_LEOM_Complete__c = true, NA_LEPT_Complete__c = true, NA_LESB_Complete__c = false, NA_LESF_Complete__c = true, NA_LEWS_Complete__c = true, NA_Opt_Out__c = false, smagicinteract__SMSOptOut__pc = false, et4ae5__HasOptedOutOfMobile__pc = false);
    Insert account_Obj1;      
		List<Person_Account__c> person_obj1= 
		new List<Person_Account__c>{new Person_Account__c(TypeTranslate__c='0000/Primary',Account_Number__c = account_details_Obj[1].Id, PersonID__c = account_Obj.Id), 
			new Person_Account__c(TypeTranslate__c='0000/Primary',Account_Number__c = account_details_Obj[2].Id, PersonID__c = account_Obj1.Id)};
		     Insert person_obj1; 	
		    	
		List<Case> case_Obj = new List<Case>{
		    new Case(Status = 'In Process', Origin = null, Subject = 'Test', ClosedDate = null, IsEscalated = false, AccountId = account_Obj.Id, Account_Number__c = account_details_Obj[0].Id, Additional_Documents__c = false, Staff_Escalated__c = false, Five_Day_Flag__c = false, IsMarkDeleted__c = false, IsMarkRead__c = false, IsMarkSaved__c = false, Primary_Category__c = 'Account Maintenance', Secondary_Category__c = 'Account Services', Tertiary_Category__c = 'Extended Check Hold', MaritzCX__Response_Deleted_From_MaritzCX__c = false, SLATemp__c = false),
		    new Case(Status = 'In Process', Origin = null, Subject = 'Test', ClosedDate = null, IsEscalated = false, AccountId = account_Obj.Id, Account_Number__c = account_details_Obj[0].Id, Additional_Documents__c = false, Staff_Escalated__c = false, Five_Day_Flag__c = false, IsMarkDeleted__c = false, IsMarkRead__c = false, IsMarkSaved__c = false, Primary_Category__c = 'Account Maintenance', Secondary_Category__c = 'Account Services', Tertiary_Category__c = 'Extended Check Hold', MaritzCX__Response_Deleted_From_MaritzCX__c = false, SLATemp__c = false),
		    new Case(Status = 'In Process', Origin = null, Subject = 'Test', ClosedDate = null, IsEscalated = false, AccountId = account_Obj.Id, Account_Number__c = account_details_Obj[0].Id, Additional_Documents__c = false, Staff_Escalated__c = false, Five_Day_Flag__c = false, IsMarkDeleted__c = false, IsMarkRead__c = false, IsMarkSaved__c = false, Primary_Category__c = 'Account Maintenance', Secondary_Category__c = 'Account Services', Tertiary_Category__c = 'Extended Check Hold', MaritzCX__Response_Deleted_From_MaritzCX__c = false, SLATemp__c = false),
		    new Case(Status = 'In Process', Origin = null, Subject = 'Test', ClosedDate = null, IsEscalated = false,AccountId = account_Obj.Id,  Account_Number__c = account_details_Obj[0].Id, Additional_Documents__c = false, Staff_Escalated__c = false, Five_Day_Flag__c = false, IsMarkDeleted__c = false, IsMarkRead__c = false, IsMarkSaved__c = false, Primary_Category__c = 'Account Maintenance', Secondary_Category__c = 'Account Services', Tertiary_Category__c = 'Extended Check Hold', MaritzCX__Response_Deleted_From_MaritzCX__c = false, SLATemp__c = false)
		    
                }; 
             /* List<Case> case_Obj = new List<Case>();
              
              Case cs1 = new Case(Status = 'In Process', Origin = null, Subject = 'Test', ClosedDate = null, IsEscalated = false, AccountId = account_Obj.Id, Account_Number__c = account_details_Obj[0].Id, Additional_Documents__c = false, Staff_Escalated__c = false, Five_Day_Flag__c = false, IsMarkDeleted__c = false, IsMarkRead__c = false, IsMarkSaved__c = false, Primary_Category__c = 'Account Maintenance', Secondary_Category__c = 'Account Services', Tertiary_Category__c = 'Extended Check Hold', MaritzCX__Response_Deleted_From_MaritzCX__c = false, SLATemp__c = false);
              Case cs2 = new Case(Status = 'In Process', Origin = null, Subject = 'Test', ClosedDate = null, IsEscalated = false, AccountId = account_Obj.Id, Account_Number__c = account_details_Obj[0].Id, Additional_Documents__c = false, Staff_Escalated__c = false, Five_Day_Flag__c = false, IsMarkDeleted__c = false, IsMarkRead__c = false, IsMarkSaved__c = false, Primary_Category__c = 'Account Maintenance', Secondary_Category__c = 'Account Services', Tertiary_Category__c = 'Extended Check Hold', MaritzCX__Response_Deleted_From_MaritzCX__c = false, SLATemp__c = false);
              Case cs3 = new Case(Status = 'In Process', Origin = null, Subject = 'Test', ClosedDate = null, IsEscalated = false, AccountId = account_Obj.Id, Account_Number__c = account_details_Obj[0].Id, Additional_Documents__c = false, Staff_Escalated__c = false, Five_Day_Flag__c = false, IsMarkDeleted__c = false, IsMarkRead__c = false, IsMarkSaved__c = false, Primary_Category__c = 'Account Maintenance', Secondary_Category__c = 'Account Services', Tertiary_Category__c = 'Extended Check Hold', MaritzCX__Response_Deleted_From_MaritzCX__c = false, SLATemp__c = false);
              Case cs4 = new Case(Status = 'In Process', Origin = null, Subject = 'Test', ClosedDate = null, IsEscalated = false,AccountId = account_Obj.Id,  Account_Number__c = account_details_Obj[0].Id, Additional_Documents__c = false, Staff_Escalated__c = false, Five_Day_Flag__c = false, IsMarkDeleted__c = false, IsMarkRead__c = false, IsMarkSaved__c = false, Primary_Category__c = 'Account Maintenance', Secondary_Category__c = 'Account Services', Tertiary_Category__c = 'Extended Check Hold', MaritzCX__Response_Deleted_From_MaritzCX__c = false, SLATemp__c = false);
              
              case_Obj.Add(cs1);
              case_Obj.Add(cs2);
              case_Obj.Add(cs3);
              case_Obj.Add(cs4);*/
                         
			  Insert case_Obj;
              
		
		
        Case case1 =[select Id from Case limit 1]; 
      	
      	
            
        Case case2 =[select Id from Case limit 1 offset 1];
        Case case3 =[select Id from Case limit 1 offset 2];    
         String Caseids = case2.id + ',' + case3.id;
            
       	System.currentPageReference().getParameters().put('recId',case1.Id);
        
            
            GetAllCasesForAccount ga = new GetAllCasesForAccount();
            ga.Caseids = Caseids;
            ga.ButtonSave_Click();
             
            
        
	   		
       
       
        	List<String> caseids1 = new List<String>();
        	caseids1.Add(case3.id);
           
            GetAllCasesForAccount.GetAllCases(case1.id);
	        GetAllCasesForAccount.ButtonSave_Click1(case1.id,caseids1); 
	        RelatedCaseList.GetRelatedCases(case1.id);
        Test.StopTest();
        
    }
}