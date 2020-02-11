@isTest

private class MemberAuthenticationControlLightningTest {

    @testSetup static void setup() {
    	
    	List<Member_Authentication_Scoring_Model__c> ScoringModellist = new List<Member_Authentication_Scoring_Model__c>();
    	
        RecordType rec = [select Id,Name,SobjectType from RecordType where SobjectType='Case' Limit 1];
        
    	Member_Authentication_Scoring_Model__c sm1 = new Member_Authentication_Scoring_Model__c(Name='1',Authentication_Type__c='OTP',Foreign_Domestic_Flag__c='NA',IsDomestic__c=true,IsForeign__c=true,IsPass__c=false,Negative_Point_Value__c=5,Positive_Point_Value__c=8);
    	Member_Authentication_Scoring_Model__c sm2 = new Member_Authentication_Scoring_Model__c(Name='3',Authentication_Type__c='OOW',Foreign_Domestic_Flag__c='DOMESTIC',IsDomestic__c=true,IsForeign__c=true,IsPass__c=false,Negative_Point_Value__c=3,Positive_Point_Value__c=3);
    	
        OOW_Flow_URL__c oowf = new OOW_Flow_URL__c();
        oowf.Name = 'OOW Boomi Flow URL';
        oowf.URL__c = 'www.google.com';
        insert oowf;
        
        CaseRecordType__c crt = new CaseRecordType__c();
        crt.Name = 'Test';
        crt.Primary_Category__c = 'Account Maintenance';
        crt.Secondary_Category__c = 'Special Situations';
        crt.Teritiary_Category__c = 'Unusual Activity';
        crt.RecordTypeId__c = rec.id;
        crt.SLA__c = 10;
        insert crt;
        
    	ScoringModellist.add(sm1);
    	ScoringModellist.add(sm2);
     	insert ScoringModellist;
     	
     	List<Account_Details__c> Account_Details_List = new List<Account_Details__c>();
     	Account_Details__c ad = new Account_Details__c(Name = '00001',TypeTranslate__c = '1-PERSONAL',Balance__c = 5000,RecType__c = 'LOAN');
     	Account_Details__c ad1 = new Account_Details__c(Name = '00002',TypeTranslate__c = '1-PERSONAL',Balance__c = 5000,RecType__c = 'ACCT');
        Account_Details_List.add(ad);
        Account_Details_List.add(ad1);
        insert Account_Details_List;
        
        List<Account> Account_Object_List = new List<Account>();
        Account acobj = new Account(FirstName = 'U',LastName = 'D',PersonID__c ='V000098',BIRTH_DATE__pc = date.parse('04/04/1963'),Employee_Restricted_Access__c = 1234,Home_Phone__pc = '9169954478',Email_raw__c = 'test@test.com', ID_2_Type__pc = 0);
        Account_Object_List.add(acobj);
        insert Account_Object_List;
     
        List<Person_Account__c> Person_Account_List = new List<Person_Account__c>();
        Person_Account__c pc = new Person_Account__c(Account_Number__c = ad.id,PersonID__c = acobj.id,RecType__c = 'LOAN',TypeTranslate__c = '001/Beneficiary');
        Person_Account__c pc1 = new Person_Account__c(Account_Number__c = ad1.id,PersonID__c = acobj.id,RecType__c = 'ACCT',TypeTranslate__c = '001/Joint Member');
        Person_Account__c pc2 = new Person_Account__c(Account_Number__c = ad.id,PersonID__c = acobj.id,RecType__c = 'LOAN',TypeTranslate__c = '001/Trustee');
        Person_Account__c pc3 = new Person_Account__c(Account_Number__c = ad1.id,PersonID__c = acobj.id,RecType__c = 'ACCT',TypeTranslate__c = '001/Custodian');
        Person_Account__c pc4 = new Person_Account__c(Account_Number__c = ad.id,PersonID__c = acobj.id,RecType__c = 'LOAN',TypeTranslate__c = '001/Primary');
        Person_Account__c pc5 = new Person_Account__c(Account_Number__c = ad1.id,PersonID__c = acobj.id,RecType__c = 'ACCT',TypeTranslate__c = '001/Representative Payee');
       	Person_Account_List.add(pc);
       	Person_Account_List.add(pc1);
        Person_Account_List.add(pc2);
       	Person_Account_List.add(pc3);
        Person_Account_List.add(pc4);
       	Person_Account_List.add(pc5);
       	insert Person_Account_List;
        
        Account acc = [Select id from Account where FirstName='U' limit 1 ];
        
        List<Authenticated_Log__c> loglist = new List<Authenticated_Log__c>();
       	Authenticated_Log__c log1 = new Authenticated_Log__c(GUID__c = 'gewwwsegv-sewswrw-2eqed-qrq', SalesforceID__c = acc.id, IVR_Sent_URL__c = 'www', CallerPhoneNumber__c = '123-2323-232', EnteredMemberNumber__c = '00000084',EnteredSSN__c = '1715');
        Authenticated_Log__c log2 = new Authenticated_Log__c(GUID__c = 'gewwwsegv-sewswrw-2eqed-qrq', SalesforceID__c = acc.id, IVR_Sent_URL__c = 'www1', CallerPhoneNumber__c = '123-2323-231', EnteredMemberNumber__c = '00000081',EnteredSSN__c = '1714');
        loglist.add(log1);
        loglist.add(log2);    
        insert loglist;
    }
    
    static testMethod void GetAccountNumberTest() {
        
        Account acc = [Select id from Account where FirstName='U' limit 1 ];
        
        Map<string,string> Accountnumber = new Map<string,string>();
        Map<string,Object> MemberVerificationNumber = new Map<string,Object>();
        Map<string,Object> NextAuthenticationType = new Map<string,Object>();
        Map<string,Object> getAuthLevel = new Map<string,Object>();
        Map<string,List<Object>> CFCUWalletInfo = new Map<string,List<Object>>();
        
        List<Member_Verification_Attempt__c> mvaList = new List<Member_Verification_Attempt__c>();
       
        MemberAuthenticationControllerLightning.AuthenticationLogWrapper Authwrapper = new MemberAuthenticationControllerLightning.AuthenticationLogWrapper();
        List<MemberAuthenticationControllerLightning.AuthenticationLogWrapper> AuthwrapperList = new List<MemberAuthenticationControllerLightning.AuthenticationLogWrapper>();
        Authwrapper.CreatedDate = string.valueOfGmt(system.now());
        Authwrapper.LogNumber = '0002';
        Authwrapper.UserName = 'Deepika Wadhwa';
        Authwrapper.MemberNumber = '123456';
        Authwrapper.PhoneNumber = '1234567789';
        Authwrapper.AuthenticationType = 'type';
        Authwrapper.Decision = 'Decision';
        Authwrapper.CaseNumber = '22222';
        Authwrapper.OverrideRequestType = 'Verbal';
        Authwrapper.OverrideRequestedSupervisor = 'Deepika Wadhwa'; 
        
        MemberAuthenticationControllerLightning.AuthenticationLogWrapper.GetLogHistoryDetailData(acc.id,'gewwwsegv-sewswrw-2eqed-qrq');
        MemberAuthenticationControllerLightning.JointMemberRelationshipWrapper Jointwrapper = new MemberAuthenticationControllerLightning.JointMemberRelationshipWrapper();
        Jointwrapper.AccountNumber = '123456';
        Jointwrapper.RelationShip = 'RelationShip';
        Jointwrapper.JointMembername = 'JointMembername';
        Jointwrapper.ID = acc.id;
        
        Accountnumber = MemberAuthenticationControllerLightning.GetAccountNumber(acc.id);
        MemberVerificationNumber = MemberAuthenticationControllerLightning.MemberVerificationAttemptsCheck(acc.id,'gewwwsegv-sewswrw-2eqed-qrq', 'Pass','1234','0000084','123-4567-765','www.googgle.com');
        MemberVerificationNumber = MemberAuthenticationControllerLightning.MemberVerificationAttemptsCheck(acc.id, 'gewwwsegv-sewswrw-2eqed-qrq', 'True','1234','0000084','123-4567-765','www.googgle.com');
        NextAuthenticationType = MemberAuthenticationControllerLightning.GetNextAuthenticationType(acc.id, 'Domestic', 3,2, True, True, True, True,True, True);
        CFCUWalletInfo = MemberAuthenticationControllerLightning.GetCFCUWalletInfo(acc.id);
        AuthwrapperList =  MemberAuthenticationControllerLightning.GetLogHistoryData(acc.id, 12, 'gewwwsegv-sewswrw-2eqed-qrq');
        getAuthLEvel = MemberAuthenticationControllerLightning.getLevel(acc.id);
    }
     static testMethod void LogDataFunctionsTest() {
     	
        Account acc = [Select id from Account where FirstName='U' limit 1 ];
        Account_Details__c ad = [select id from Account_Details__c where name = '00001' limit 1];
         
        MemberAuthenticationControllerLightning.SaveOOWLogData('passed','00002',acc.id,'reason','Test1','gewwwsegv-sewswrw-2eqed-qrq', 'Test Test1','Error');
        MemberAuthenticationControllerLightning.KYMSaveLogData(acc.id,'reason','Test1','gewwwsegv-sewswrw-2eqed-qrq');
        MemberAuthenticationControllerLightning.PublicWalletSaveLogData(acc.id,'reason','gewwwsegv-sewswrw-2eqed-qrq');
        MemberAuthenticationControllerLightning.CFCUWalletSaveLogData(acc.id,'reason','gewwwsegv-sewswrw-2eqed-qrq');
        MemberAuthenticationControllerLightning.GetFailedDesiredLevelLog(acc.id);
	    MemberAuthenticationControllerLightning.SaveOTPCancelledAttempt(acc.id,'gewwwsegv-sewswrw-2eqed-qrq');
        Test.startTest();
        MemberAuthenticationControllerLightning.SaveCaseWithLogData(acc.id,'00002','casecomment',ad.id,'gewwwsegv-sewswrw-2eqed-qrq');
        Test.stopTest(); 
        MemberAuthenticationControllerLightning.getPublicWalletInfo(acc.id);
        MemberAuthenticationControllerLightning.SaveLastAchievableLevelLogs(acc.id,'gewwwsegv-sewswrw-2eqed-qrq','Level 1');
        MemberAuthenticationControllerLightning.GetSupervisor(acc.id,10,'gewwwsegv-sewswrw-2eqed-qrq');
        string str = MemberAuthenticationControllerLightning.substring('reason',2);
        MemberAuthenticationControllerLightning.InsertLogData(acc.id,'reason','failed','654555555','1715','04/04/1963','http:test.com','Verbal','Deepika Wadhwa','gewwwsegv-sewswrw-2eqed-qrq');
        
        
    }
   static testMethod void getMemberSearchDataTest(){
   	
   		Map<string,object> objmap = new Map<string,object>();
   		objmap = MemberAuthenticationControllerLightning.getMemberSearchData('9169954478', '00002', '1715', '04-04-1963');
   		objmap = MemberAuthenticationControllerLightning.getMemberSearchData('9169954478', '00002', '1715', '04-04-1963');
   	
   }
    
    
        
}