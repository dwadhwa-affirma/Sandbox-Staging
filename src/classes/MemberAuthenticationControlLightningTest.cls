@isTest

private class MemberAuthenticationControlLightningTest {

    @testSetup static void setup() {
    	
    	List<Member_Authentication_Scoring_Model__c> ScoringModellist = new List<Member_Authentication_Scoring_Model__c>();
    	
        RecordType rec = [select Id,Name,SobjectType from RecordType where SobjectType='Case' Limit 1];
        
    	Member_Authentication_Scoring_Model__c sm1 = new Member_Authentication_Scoring_Model__c(Name='1',Authentication_Type__c='OTP',Foreign_Domestic_Flag__c='NA',IsDomestic__c=true,IsForeign__c=false,IsPass__c=false,Negative_Point_Value__c=5,Positive_Point_Value__c=8);
    	Member_Authentication_Scoring_Model__c sm2 = new Member_Authentication_Scoring_Model__c(Name='2',Authentication_Type__c='OOW',Foreign_Domestic_Flag__c='DOMESTIC',IsDomestic__c=true,IsForeign__c=false,IsPass__c=false,Negative_Point_Value__c=3,Positive_Point_Value__c=3);
    	Member_Authentication_Scoring_Model__c sm3 = new Member_Authentication_Scoring_Model__c(Name='3',Authentication_Type__c='PIN Change',Foreign_Domestic_Flag__c='NA',IsDomestic__c=true,IsForeign__c=false,IsPass__c=false,Negative_Point_Value__c=3,Positive_Point_Value__c=0);
        Member_Authentication_Scoring_Model__c sm4 = new Member_Authentication_Scoring_Model__c(Name='4',Authentication_Type__c='PIN Change',Foreign_Domestic_Flag__c='NA',IsDomestic__c=false,IsForeign__c=true,IsPass__c=false,Negative_Point_Value__c=3,Positive_Point_Value__c=0);
    	Member_Authentication_Scoring_Model__c sm5 = new Member_Authentication_Scoring_Model__c(Name='5',Authentication_Type__c='Debit Pin',Foreign_Domestic_Flag__c='DOMESTIC',IsDomestic__c=true,IsForeign__c=false,IsPass__c=false,Negative_Point_Value__c=1,Positive_Point_Value__c=8);
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
        ScoringModellist.add(sm3);
        ScoringModellist.add(sm4);
        ScoringModellist.add(sm5);
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
        Profile pf= [Select Id from profile where Name='System Administrator'];

        User uu=new User(firstname = 'Deepika', 
                         lastName = 'Wadhwa', 
                         email = 'DeepikaWadhwa@test.com', 
                         Username = 'DeepikaWadhwa@test.com', 
                         EmailEncodingKey = 'ISO-8859-1', 
                         Alias = 'dwadh', 
                         TimeZoneSidKey = 'America/Los_Angeles', 
                         LocaleSidKey = 'en_US', 
                         LanguageLocaleKey = 'en_US', 
                         ProfileId = pf.Id
                        ); 
        
        
        insert uu;
    }
    
    static testMethod void GetAccountNumberTest() {
        
        Account acc = [Select id from Account where FirstName='U' limit 1 ];
        
        Map<string,string> Accountnumber = new Map<string,string>();
        Map<string,Object> MemberVerificationNumber = new Map<string,Object>();
       
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
        
        MemberAuthenticationControllerLightning.AuthenticationLogWrapper.GetLogHistoryDetailData(acc.id,'gewwwsegv-sewswrw-2eqed-qrq','IVRgewwwsegv-sewswrw-2eqed-qrq');
        MemberAuthenticationControllerLightning.JointMemberRelationshipWrapper Jointwrapper = new MemberAuthenticationControllerLightning.JointMemberRelationshipWrapper();
        Jointwrapper.AccountNumber = '123456';
        Jointwrapper.RelationShip = 'RelationShip';
        Jointwrapper.JointMembername = 'JointMembername';
        Jointwrapper.ID = acc.id;
        
        Accountnumber = MemberAuthenticationControllerLightning.GetAccountNumber(acc.id);
        MemberVerificationNumber = MemberAuthenticationControllerLightning.MemberVerificationAttemptsCheck(acc.id,'gewwwsegv-sewswrw-2eqed-qrq', 'Pass','1234','0000084','123-4567-765','www.googgle.com','IVRgewwwsegv-sewswrw-2eqed-qrq',true,'aa','ss',3, true);
        MemberVerificationNumber = MemberAuthenticationControllerLightning.MemberVerificationAttemptsCheck(acc.id, 'gewwwsegv-sewswrw-2eqed-qrq', 'True','1234','0000084','123-4567-765','www.googgle.com','IVRgewwwsegv-sewswrw-2eqed-qrq',true,'aa','ss',3, false);
        
        Test.startTest();
        CFCUWalletInfo = MemberAuthenticationControllerLightning.GetCFCUWalletInfo(acc.id,'IVRgewwwsegv-sewswrw-2eqed-qrq');
        Test.stopTest();
        AuthwrapperList =  MemberAuthenticationControllerLightning.GetLogHistoryData(acc.id, 12, 'gewwwsegv-sewswrw-2eqed-qrq');
        getAuthLEvel = MemberAuthenticationControllerLightning.getLevel(acc.id);
    }
     static testMethod void LogDataFunctionsTest() {
     	
        Account acc = [Select id from Account where FirstName='U' limit 1 ];
        Account_Details__c ad = [select id from Account_Details__c where name = '00001' limit 1];
        User u = [select id , name from user where Firstname = 'Deepika' limit 1]; 
        MemberAuthenticationControllerLightning.SaveOOWLogData('passed','00002',acc.id,'reason','Test1','gewwwsegv-sewswrw-2eqed-qrq', 'Test Test1','Error','IVRgewwwsegv-sewswrw-2eqed-qrq');
        MemberAuthenticationControllerLightning.KYMSaveLogData(acc.id,'reason','Test1','gewwwsegv-sewswrw-2eqed-qrq');
        MemberAuthenticationControllerLightning.PublicWalletSaveLogData(acc.id,'reason','gewwwsegv-sewswrw-2eqed-qrq','Pass','Pass','Pass','Pass','Pass','IVRgewwwsegv-sewswrw-2eqed-qrq');
        MemberAuthenticationControllerLightning.CFCUWalletSaveLogData(acc.id,'reason','gewwwsegv-sewswrw-2eqed-qrq','Pass','Pass','Pass','Pass','Pass','Pass','IVRgewwwsegv-sewswrw-2eqed-qrq');
        MemberAuthenticationControllerLightning.GetFailedDesiredLevelLog(acc.id);
	    MemberAuthenticationControllerLightning.SaveOTPCancelledAttempt(acc.id,'gewwwsegv-sewswrw-2eqed-qrq','IVRgewwwsegv-sewswrw-2eqed-qrq');
        Test.startTest();
        MemberAuthenticationControllerLightning.SaveCaseWithLogData(acc.id,'00002','casecomment',ad.id,'gewwwsegv-sewswrw-2eqed-qrq','IVRgewwwsegv-sewswrw-2eqed-qrq');
        Test.stopTest(); 
        MemberAuthenticationControllerLightning.getPublicWalletInfo(acc.id,'IVRgewwwsegv-sewswrw-2eqed-qrq');
        MemberAuthenticationControllerLightning.SaveLastAchievableLevelLogs(acc.id,'gewwwsegv-sewswrw-2eqed-qrq','Level 1','IVRgewwwsegv-sewswrw-2eqed-qrq');
        MemberAuthenticationControllerLightning.GetSupervisor(acc.id,10,'gewwwsegv-sewswrw-2eqed-qrq');
        string str = MemberAuthenticationControllerLightning.substring('reason',2);
       
        
        
    }
    static testMethod void LogDataFunctionsTest1() {
         Account acc = [Select id from Account where FirstName='U' limit 1 ];
         Account_Details__c ad = [select id from Account_Details__c where name = '00001' limit 1];
         User u = [select id , name from user where Firstname = 'Deepika' limit 1]; 
         Map<string,Object> NextAuthenticationType = new Map<string,Object>();
         Test.startTest();
         NextAuthenticationType = MemberAuthenticationControllerLightning.GetNextAuthenticationType(acc.id, 'Domestic', 3,2, True, True, True, True,True, True,'IVRgewwwsegv-sewswrw-2eqed-qrq');
         MemberAuthenticationControllerLightning.InsertLogData(acc.id,'failed','Level 1','654555555','1715','http:test.com','Verbal',u.name,'Test','gewwwsegv-sewswrw-2eqed-qrq','IVRgewwwsegv-sewswrw-2eqed-qrq');
        Test.stopTest(); 
    }
   static testMethod void getMemberSearchDataTest(){
   	
   		Map<string,object> objmap = new Map<string,object>();
   		objmap = MemberAuthenticationControllerLightning.getMemberSearchData('9169954478', '00002', '1715', '04-04-1963');
   		objmap = MemberAuthenticationControllerLightning.getMemberSearchData('9169954478', '00002', '1715', '04-04-1963');
   	
   }
    
    
        
}