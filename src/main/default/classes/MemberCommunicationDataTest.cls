@isTest
public with sharing class MemberCommunicationDataTest {
    @testSetup
    static void setupTestData(){
        Account account_Obj = new Account(LastName = 'BANDATest', FirstName = 'MARIATest', Type = 'null', PersonHasOptedOutOfEmail = false, NA_Eligibility__c = false, NA_LEAV_Complete__c = true, NA_LECF_Complete__c = true, NA_LECP_Complete__c = true, NA_LEEM_Complete__c = true, NA_LEHS_Complete__c = true, NA_LEMD_Complete__c = false, NA_LEMP_Complete__c = false, NA_LEMQ_Complete__c = true, NA_LEOL_Complete__c = true, NA_LEOM_Complete__c = true, NA_LEPT_Complete__c = true, NA_LESB_Complete__c = false, NA_LESF_Complete__c = true, NA_LEWS_Complete__c = true, NA_Opt_Out__c = false, smagicinteract__SMSOptOut__pc = false, et4ae5__HasOptedOutOfMobile__pc = false);
        Insert account_Obj;
        Account account_Obj1 = new Account(LastName = 'BANDATest1', FirstName = 'MARIATest1', Type = 'null', PersonHasOptedOutOfEmail = false, NA_Eligibility__c = false, NA_LEAV_Complete__c = true, NA_LECF_Complete__c = true, NA_LECP_Complete__c = true, NA_LEEM_Complete__c = true, NA_LEHS_Complete__c = true, NA_LEMD_Complete__c = false, NA_LEMP_Complete__c = false, NA_LEMQ_Complete__c = true, NA_LEOL_Complete__c = true, NA_LEOM_Complete__c = true, NA_LEPT_Complete__c = true, NA_LESB_Complete__c = false, NA_LESF_Complete__c = true, NA_LEWS_Complete__c = true, NA_Opt_Out__c = false, smagicinteract__SMSOptOut__pc = false, et4ae5__HasOptedOutOfMobile__pc = false);
        Insert account_Obj1; 
        
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
                                  )};
                                      Insert account_details_Obj;
        Account_Details__c obj = [select id,name from Account_Details__c where id =: account_details_Obj[0].id];
        List<Person_Account__c> person_obj= new List<Person_Account__c>{
            new Person_Account__c(TypeTranslate__c='0000/Primary',Account_Number__c = account_details_Obj[0].id, PersonID__c = account_Obj.Id), 
                new Person_Account__c(TypeTranslate__c='0000/Primary',Account_Number__c = account_details_Obj[0].Id, PersonID__c = account_Obj.Id)}; 
                    Insert person_obj;
        
        String RecTypeId= [select Id from RecordType where (Name='IVR Authentication Log') and (SobjectType='Authenticated_Log__c')].Id;
        Authenticated_Log__c al = new Authenticated_Log__c(RecordTypeID=RecTypeId,Brand__c='Test');
        insert al;
        
         String RecTypeId1= [select Id from RecordType where (Name='OOW Execution Log') and (SobjectType='Authenticated_Log__c')].Id;
        Authenticated_Log__c al1 = new Authenticated_Log__c(RecordTypeID=RecTypeId1, OOW_Notes__c ='Test', OOW_Reason__c= 'reason1',OOW_Status__c ='passed');
        insert al1;
        
        SNAIL_Remote_Setting__c sr = new SNAIL_Remote_Setting__c();
        sr.name='BDIWebService';
        sr.Url__c='https://dev2ssl.businessdatainc.com';
        insert sr;
        
        MC_PIN_Change__c mp = new MC_PIN_Change__c();
        mp.Member_Number__c = obj.name;
        insert mp;
        
        MC_Limit_Change__c ml = new MC_Limit_Change__c();
        ml.Member_Number__c = obj.name;
        insert ml;
        
    }
    static testMethod void GetAllDataTest() {
        TEst.starttest();
        
        List<Account> obj = [select id from Account limit 1];
        List<Account_Details__c> objd = [select id,name from Account_Details__c limit 1];
        List<MC_PIN_Change__c> objmp = [select id,Member_Number__c from MC_PIN_Change__c limit 1];
        List<MC_Limit_Change__c> objml = [select id,Member_Number__c from MC_Limit_Change__c limit 1];
        
        list<string> str = 	new list<string>();
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());
        date dt = date.newinstance(2000, 2, 17);
        MemberCommunicationData.GetMemberCommData(str,null,null,obj[0].Id,'30');
        MemberCommunicationData.GetMemberCommData(str,null,null,objd[0].Id,'30');
        MemberCommunicationData.GetMemberCommData(str,dt,null,obj[0].Id,'Date Range');
        MemberCommunicationData.GetMemberCommData(str,dt,null,objd[0].Id,'Date Range');
        MemberCommunicationData.GetBDICommData(str,dt,null,obj[0].Id,'Date Range');
        MemberCommunicationData.GetBDICommData(str,null,null,obj[0].Id,'30');
        MemberCommunicationData.GetSalesforceData(str,null,null,obj[0].Id,'30');
        MemberCommunicationData.GetSalesforceData(str,dt,null,obj[0].Id,'Date Range');
        MemberCommunicationData.GetOOWData(null,null,'30',obj[0].Id);
        MemberCommunicationData.GetOOWData(dt,null,'Date Range',obj[0].Id);
        MemberCommunicationData.GetMCPingChangeData(str,null,null,obj[0].Id,'30');
        MemberCommunicationData.GetMCLimitChangeData(str,null,null,obj[0].Id,'30');
        ApexPages.currentPage().getParameters().put('aburl', 'test');
        
        MemberCommunicationData md = new MemberCommunicationData(); 
        string strblob = md.BlobText;
        TEst.stoptest();
    } 
}