@isTest
public class EDSMemberAlertsTest {
    
    @testSetup
    static void setupTestData(){
        
        Wires_Notification_EmailTo__c suud1 = new Wires_Notification_EmailTo__c();
      	suud1.Name = 'Email For Testing';
        suud1.Emails__c ='test@test.com';
      	insert suud1;
        
        test.startTest();
        Account account_Obj = new Account(FirstName = 'MARIA', LastName = 'BANDA',Email_raw__c = 'test@test.com', PersonEmail = 'test@test.com', PersonHasOptedOutOfEmail = false, NA_Eligibility__c = false, NA_LEAV_Complete__c = true, NA_LECF_Complete__c = true, NA_LECP_Complete__c = false, NA_LEEM_Complete__c = true, NA_LEHS_Complete__c = true, NA_LEMD_Complete__c = false, NA_LEMP_Complete__c = false, NA_LEMQ_Complete__c = true, NA_LEOL_Complete__c = true, NA_LEOM_Complete__c = true, NA_LEPT_Complete__c = true, NA_LESB_Complete__c = false, NA_LESF_Complete__c = true, NA_LEWS_Complete__c = true, NA_Opt_Out__c = false);
        Insert account_Obj; 

        Account_Details__c account_details_Obj = new Account_Details__c(Reference__c ='BC02',Name = '0260049344', Comment_Block_01__c = 'null', Comment_Block_02__c = 'null', Comment_Block_03__c = 'null', Comment_Block_04__c = 'umang', Comment_Block_05__c = 'test', Comment_Block_06__c = 'null', Comment_Block_07__c = 'null', Comment_Block_08__c = 'null', Comment_Block_09__c = 'null', Comment_Block_10__c = 'null', Comment_Block_11__c = 'null', Comment_Block_12__c = 'null', Comment_Block_13__c = 'null', Comment_Block_14__c = 'null', Comment_Block_15__c = 'null', Comment_Block_16__c = 'null', Comment_Block_17__c = 'null', Comment_Block_18__c = 'null', Comment_Block_19__c = 'null', Comment_Block_20__c = 'null', Comments_Block__c = 'SPECTRUM CREDIT UNION', Onboarded__c = false, RecType__c = 'ACCT', WARNING_01_CODE__c = 'null', WARNING_02_CODE__c = 'null', WARNING_03_CODE__c = 'null', WARNING_04_CODE__c = 'null', WARNING_05_CODE__c = 'null', WARNING_06_CODE__c = 'null', WARNING_07_CODE__c = 'null', WARNING_08_CODE__c = 'null', WARNING_09_CODE__c = 'null', WARNING_10_CODE__c = 'null', WARNING_11_CODE__c = 'null', WARNING_12_CODE__c = 'null', WARNING_13_CODE__c = 'null', WARNING_14_CODE__c = 'null', WARNING_15_CODE__c = 'null', WARNING_16_CODE__c = 'null', WARNING_17_CODE__c = 'null', WARNING_18_CODE__c = 'null', WARNING_19_CODE__c = 'null', WARNING_20_CODE__c = 'null', TypeTranslate__c =  '1-PERSONAL');
        Insert account_details_Obj;

        Account_Details__c account_details_Obj1 = new Account_Details__c(Reference__c ='BC02',Name = '0000000123', Comment_Block_01__c = 'null', Comment_Block_02__c = 'null', Comment_Block_03__c = 'null', Comment_Block_04__c = 'umang', Comment_Block_05__c = 'test', Comment_Block_06__c = 'null', Comment_Block_07__c = 'null', Comment_Block_08__c = 'null', Comment_Block_09__c = 'null', Comment_Block_10__c = 'null', Comment_Block_11__c = 'null', Comment_Block_12__c = 'null', Comment_Block_13__c = 'null', Comment_Block_14__c = 'null', Comment_Block_15__c = 'null', Comment_Block_16__c = 'null', Comment_Block_17__c = 'null', Comment_Block_18__c = 'null', Comment_Block_19__c = 'null', Comment_Block_20__c = 'null', Comments_Block__c = 'SPECTRUM CREDIT UNION', Onboarded__c = false, RecType__c = 'ACCT', WARNING_01_CODE__c = 'null', WARNING_02_CODE__c = 'null', WARNING_03_CODE__c = 'null', WARNING_04_CODE__c = 'null', WARNING_05_CODE__c = 'null', WARNING_06_CODE__c = 'null', WARNING_07_CODE__c = 'null', WARNING_08_CODE__c = 'null', WARNING_09_CODE__c = 'null', WARNING_10_CODE__c = 'null', WARNING_11_CODE__c = 'null', WARNING_12_CODE__c = 'null', WARNING_13_CODE__c = 'null', WARNING_14_CODE__c = 'null', WARNING_15_CODE__c = 'null', WARNING_16_CODE__c = 'null', WARNING_17_CODE__c = 'null', WARNING_18_CODE__c = 'null', WARNING_19_CODE__c = 'null', WARNING_20_CODE__c = 'null', TypeTranslate__c =  '2-TRUST');
        Insert account_details_Obj1;

        Person_Account__c person_account_Obj = new Person_Account__c(TypeTranslate__c = '0000/Primary',PersonID__c= account_Obj.id,Account_Number__c = account_details_Obj.id);
        Insert person_account_Obj; 

        Person_Account__c person_account_Obj1 = new Person_Account__c(TypeTranslate__c = '0006/Trustee',PersonID__c= account_Obj.id,Account_Number__c = account_details_Obj1.id);
        Insert person_account_Obj1; 
    }
    
    static testMethod void test_getData_UseCase1(){
        EDS_Member_Alerts__c obj1 = new EDS_Member_Alerts__c();
        obj1.Account_Number__c = '0260049344';
        obj1.OdsKey__c = '123456789';
        insert obj1;  

        EDS_Member_Alerts__c obj2 = new EDS_Member_Alerts__c();
        obj2.Account_Number__c = '0000000123';
        obj2.OdsKey__c = '123456789';
        insert obj2;  
    }
    
	static testMethod void test_getData_UseCase2(){
        EDS_Member_Alerts__c obj1 = new EDS_Member_Alerts__c();
        obj1.Account_Number__c = '0260049344';
        obj1.Email__c = 'test@test.com';
        obj1.OdsKey__c = '123456789';
        insert obj1;
    }
    
    static testMethod void test_getData_UseCase3(){
        EDS_Member_Alerts__c obj1 = new EDS_Member_Alerts__c();
        obj1.Mobile_Phone__c = '1234567891';
        obj1.Account_Number__c = '0260049344';
        obj1.OdsKey__c = '123456789';
        insert obj1;  
    }
}