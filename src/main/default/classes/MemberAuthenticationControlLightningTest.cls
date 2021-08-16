@isTest

private class MemberAuthenticationControlLightningTest {

    @testSetup static void setup() {
      
       
      List<Member_Authentication_Scoring_Model__c> ScoringModellist = new List<Member_Authentication_Scoring_Model__c>();
      
        RecordType rec = [select Id,Name,SobjectType from RecordType where SobjectType='Case' Limit 1];
        
      Member_Authentication_Scoring_Model__c sm1 = new Member_Authentication_Scoring_Model__c(Name='1',Authentication_Type__c='OTP',Foreign_Domestic_Flag__c='DOMESTIC',IsDomestic__c=true,IsForeign__c=false,IsPass__c=false,Negative_Point_Value__c=5,Positive_Point_Value__c=8);
      Member_Authentication_Scoring_Model__c sm2 = new Member_Authentication_Scoring_Model__c(Name='2',Authentication_Type__c='OOW',Foreign_Domestic_Flag__c='DOMESTIC',IsDomestic__c=true,IsForeign__c=false,IsPass__c=false,Negative_Point_Value__c=3,Positive_Point_Value__c=3);
      Member_Authentication_Scoring_Model__c sm3 = new Member_Authentication_Scoring_Model__c(Name='3',Authentication_Type__c='PIN Change',Foreign_Domestic_Flag__c='NA',IsDomestic__c=true,IsForeign__c=false,IsPass__c=false,Negative_Point_Value__c=3,Positive_Point_Value__c=0);
        Member_Authentication_Scoring_Model__c sm4 = new Member_Authentication_Scoring_Model__c(Name='4',Authentication_Type__c='PIN Change',Foreign_Domestic_Flag__c='NA',IsDomestic__c=false,IsForeign__c=true,IsPass__c=false,Negative_Point_Value__c=3,Positive_Point_Value__c=0);
      Member_Authentication_Scoring_Model__c sm5 = new Member_Authentication_Scoring_Model__c(Name='5',Authentication_Type__c='CFCU Wallet',Foreign_Domestic_Flag__c='DOMESTIC',IsDomestic__c=true,IsForeign__c=false,IsPass__c=false,Negative_Point_Value__c=3,Positive_Point_Value__c=4);
        Member_Authentication_Scoring_Model__c sm6 = new Member_Authentication_Scoring_Model__c(Name='6',Authentication_Type__c='Public Wallet',Foreign_Domestic_Flag__c='DOMESTIC',IsDomestic__c=true,IsForeign__c=false,IsPass__c=false,Negative_Point_Value__c=2,Positive_Point_Value__c=3);
        Member_Authentication_Scoring_Model__c sm7 = new Member_Authentication_Scoring_Model__c(Name='7',Authentication_Type__c='Public Wallet',Foreign_Domestic_Flag__c='Foreign',IsDomestic__c=false,IsForeign__c=true,IsPass__c=false,Negative_Point_Value__c=2,Positive_Point_Value__c=4);
        Member_Authentication_Scoring_Model__c sm8 = new Member_Authentication_Scoring_Model__c(Name='8',Authentication_Type__c='Debit Pin',Foreign_Domestic_Flag__c='Foreign',IsDomestic__c=false,IsForeign__c=true,IsPass__c=false,Negative_Point_Value__c=1,Positive_Point_Value__c=8);
        Member_Authentication_Scoring_Model__c sm9 = new Member_Authentication_Scoring_Model__c(Name='9',Authentication_Type__c='Debit Pin',Foreign_Domestic_Flag__c='Domestic',IsDomestic__c=true,IsForeign__c=false,IsPass__c=false,Negative_Point_Value__c=1,Positive_Point_Value__c=8);
       
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

        Member360_TypeTranslate__c t= new Member360_TypeTranslate__c();
     t.name='0000/Primary';
        insert t;
        Member360_TypeTranslate__c t1= new Member360_TypeTranslate__c();
        t1.name='001/Beneficiary';
        insert t1;
        Member360_TypeTranslate__c t2= new Member360_TypeTranslate__c();
        t2.name='001/Joint Member';
        insert t2;
        Member360_TypeTranslate__c t3= new Member360_TypeTranslate__c();
        t3.name='001/Trustee';
        insert t3;
        Member360_TypeTranslate__c t4= new Member360_TypeTranslate__c();
        t4.name='001/Custodian';
        insert t4;
        Member360_TypeTranslate__c t5= new Member360_TypeTranslate__c();
        t5.name='001/Primary';
        insert t5;
        Member360_TypeTranslate__c t6= new Member360_TypeTranslate__c();
        t6.name='001/Representative Payee';
     insert t6;
        
      ScoringModellist.add(sm1);
      ScoringModellist.add(sm2);
        ScoringModellist.add(sm3);
        ScoringModellist.add(sm4);
        ScoringModellist.add(sm5);
        ScoringModellist.add(sm6);
        ScoringModellist.add(sm7);
        ScoringModellist.add(sm8);
        ScoringModellist.add(sm9);
       insert ScoringModellist;
         List<Member_Authentication_Level_Model__c> LevelModel = new List<Member_Authentication_Level_Model__c>();
          Member_Authentication_Level_Model__c l1 = new Member_Authentication_Level_Model__c(Name='1',Tiers__c= 'Level 1', Range_Start__c=0,Range_End__c=5);
         Member_Authentication_Level_Model__c l2 = new Member_Authentication_Level_Model__c(Name='2',Tiers__c= 'Level 2', Range_Start__c=6,Range_End__c=8);
         Member_Authentication_Level_Model__c l3 = new Member_Authentication_Level_Model__c(Name='3',Tiers__c= 'Level 3', Range_Start__c=9);
        LevelModel.add(l1);
        LevelModel.add(l2);
        LevelModel.add(l3);
        insert LevelModel;        
        
       List<Account_Details__c> Account_Details_List = new List<Account_Details__c>();
       Account_Details__c ad = new Account_Details__c(Name = '00001',TypeTranslate__c = '1-PERSONAL',Balance__c = 5000,RecType__c = 'LOAN');
       Account_Details__c ad1 = new Account_Details__c(Name = '00002',TypeTranslate__c = '1-PERSONAL',Balance__c = 5000,RecType__c = 'ACCT');
        Account_Details__c ad2 = new Account_Details__c(Name = '0000084',TypeTranslate__c = '1-PERSONAL',Balance__c = 5000,RecType__c = 'ACCT',High_Value_Flag__c=1);
        
        Account_Details_List.add(ad);
        Account_Details_List.add(ad1);
         Account_Details_List.add(ad2);
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
        Person_Account__c pc6 = new Person_Account__c(Account_Number__c = ad2.id,PersonID__c = acobj.id,RecType__c = 'ACCT',TypeTranslate__c = '0000/Primary');
         Person_Account_List.add(pc);
         Person_Account_List.add(pc1);
        Person_Account_List.add(pc2);
         Person_Account_List.add(pc3);
        Person_Account_List.add(pc4);
         Person_Account_List.add(pc5);
        Person_Account_List.add(pc6);
         insert Person_Account_List;
        
        Account acc = [Select id from Account where FirstName='U' limit 1 ];
        
        List<Authenticated_Log__c> loglist = new List<Authenticated_Log__c>();
         Authenticated_Log__c log1 = new Authenticated_Log__c(GUID__c = 'abc-123', SalesforceID__c = acc.id, IVR_Sent_URL__c = 'www', CallerPhoneNumber__c = '123-2323-232', EnteredMemberNumber__c = '00000084',EnteredSSN__c = '1715');
        Authenticated_Log__c log2 = new Authenticated_Log__c(GUID__c = 'abc-123', SalesforceID__c = acc.id, IVR_Sent_URL__c = 'www1', CallerPhoneNumber__c = '123-2323-231', EnteredMemberNumber__c = '00000081',EnteredSSN__c = '1714');
        loglist.add(log1);
        loglist.add(log2);    
       
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
         
    
         Account obj_Account = [select Id from Account limit 1];
        string accid = obj_Account.Id;
       RecordType OTPRec = [select Id,Name,SobjectType from RecordType where Name ='OTP Authentication Log' and SobjectType='Authenticated_Log__c' limit 1];
         Authenticated_Log__c log3 = new Authenticated_Log__c();
        log3.IVR_GUID__c ='abc-123';
        log3.RecordTypeId = OTPRec.id;
        log3.CreatedDate = system.today();
        log3.SalesforceID__c = accid;
        log3.OTP_Status__c = 'Pass';
        loglist.add(log3);   
        
        RecordType rec1 = [Select id, Name, sobjecttype from RecordType where Name='Master Authentication Log'];
        
        Authenticated_Log__c log4 = new Authenticated_Log__c();
        log4.IVR_GUID__c ='abc-123';
        log4.RecordTypeId = rec1.id;
        loglist.add(log4);
        
       RecordType recpw = MemberAuthenticationControllerLightning.GetRecordTypeData('Authenticated_Log__c', 'Public Wallet Log'); 
         Authenticated_Log__c log5 = new Authenticated_Log__c();
        log5.IVR_GUID__c ='abc-123';
        log5.RecordTypeId = recpw.id;
        log5.CreatedDate = system.today();
        log5.SalesforceID__c = accid;
        log5.Public_Wallet_Status__c= 'Pass';
        loglist.add(log5);    
        insert loglist;
    }
    
    static testMethod void GetAccountNumberTest() {
         Test.startTest();
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
        MemberVerificationNumber = MemberAuthenticationControllerLightning.MemberVerificationAttemptsCheck(acc.id,'abc-123', 'Pass','1234','0000084','123-4567-765','www.googgle.com','abc-123',true,'aa','ss',3, true,false,'','','','','','','1234');
        MemberVerificationNumber = MemberAuthenticationControllerLightning.MemberVerificationAttemptsCheck(acc.id, 'abc-123', 'True','1234','0000084','123-4567-765','www.googgle.com','abc-123',true,'aa','ss',3, false, true, '','','','','','','1234');
        MemberVerificationNumber = MemberAuthenticationControllerLightning.MemberVerificationAttemptsCheck(acc.id, 'abc-123', 'True','1234','0000084','123-4567-765','www.googgle.com','abc-123',false,'aa','ss',3, false, false, '','','','','','','1234');        
        AuthwrapperList =  MemberAuthenticationControllerLightning.GetLogHistoryData(acc.id, 12, 'abc-123');
        getAuthLEvel = MemberAuthenticationControllerLightning.getLevel(acc.id); 
        Test.stopTest();
       
       
    }
    static testMethod void GetAccountNumberTest3() {
        
        Account acc = [Select id from Account where FirstName='U' limit 1 ];
         Map<string,List<Object>> CFCUWalletInfo = new Map<string,List<Object>>();
        Test.startTest();
        CFCUWalletInfo = MemberAuthenticationControllerLightning.GetCFCUWalletInfo(acc.id,'abc-123');
       
        Test.stopTest();
        
    }
    static testMethod void LogDataFunctionsTest2() {
        Test.startTest();
        Account acc = [Select id from Account where FirstName='U' limit 1 ];
        MemberAuthenticationControllerLightning.GetSupervisor(acc.id,10,'abc-123');
        Test.stopTest();
    }
     static testMethod void LogDataFunctionsTest3() {
        Test.startTest();
          RecordType rec1 = [Select id, Name, sobjecttype from RecordType where Name='Master Authentication Log'];
          List<Authenticated_Log__c> MasterAuthenticationLog = MemberAuthenticationControllerLightning.GetDataForMasterAuthenticationLog('abc-123', rec1.id);
         list<object> obj = new List<object>();
       
        Account acc = [Select id from Account where FirstName='U' limit 1 ];
        Account_Details__c ad = [select id from Account_Details__c where name = '00001' limit 1];
        User u = [select id , name from user where Firstname = 'Deepika' limit 1]; 
        MemberAuthenticationControllerLightning.SaveOOWLogData('passed','00002',acc.id,'reason','Test1','abc-123', 'Test Test1','Error','abc-123');
        
        MemberAuthenticationControllerLightning.KYMSaveLogData(acc.id,'reason','Test1','abc-123');
        MemberAuthenticationControllerLightning.PublicWalletSaveLogData(acc.id,'reason','abc-123','Pass','Pass','Pass','Pass','Pass','abc-123','test1','test2','test3', 'test4', 'test5','0000234534');
        MemberAuthenticationControllerLightning.CFCUWalletSaveLogData(acc.id,'reason','abc-123','Pass','Pass','Pass','Pass','Pass','Pass','abc-123',obj, obj,obj,obj,'test1', 'test2','0000234534');
        MemberAuthenticationControllerLightning.GetFailedDesiredLevelLog(acc.id);
      MemberAuthenticationControllerLightning.SaveOTPCancelledAttempt(acc.id,'abc-123','abc-123');
         MemberAuthenticationControllerLightning.SaveOTPCancelledAttempt(acc.id,' ',' ');
      
        Test.stopTest();
    }
     static testMethod void LogDataFunctionsTest4() {
        Test.startTest();
        RecordType rec1 = [Select id, Name, sobjecttype from RecordType where Name='Master Authentication Log'];
        
        Authenticated_Log__c log4 = new Authenticated_Log__c();
        log4.IVR_GUID__c ='abc-123';
        log4.RecordTypeId = rec1.id;
        insert log4;
         List<Authenticated_Log__c> masterlog = MemberAuthenticationControllerLightning.GetMasterLogData(log4.id);
         
         List<Authenticated_Log__c> MasterAuthenticationLog = MemberAuthenticationControllerLightning.GetDataForMasterAuthenticationLog('abc-1234', rec1.id);
         list<object> obj = new List<object>();
       
        Account acc = [Select id from Account where FirstName='U' limit 1 ];
        List<Authenticated_Log__c> logdata = MemberAuthenticationControllerLightning.GetMAAPLogData(acc.id);
        Account_Details__c ad = [select id from Account_Details__c where name = '00001' limit 1];
        User u = [select id , name from user where Firstname = 'Deepika' limit 1]; 
       
        MemberAuthenticationControllerLightning.SaveOOWLogData('passed','00002',acc.id,'reason','Test1','abc-1234', 'Test Test1','Error','abc-1234');
       
        MemberAuthenticationControllerLightning.PublicWalletSaveLogData(acc.id,'reason','abc-1234','Pass','Pass','Pass','Pass','Pass','abc-1234','test1','test2','test3', 'test4', 'test5','0000234534'); 
        MemberAuthenticationControllerLightning.PublicWalletSaveLogData(acc.id,'reason','','Pass','Pass','Pass','Pass','Pass','','test1','test2','test3', 'test4', 'test5','0000234534');  
        MemberAuthenticationControllerLightning.CFCUWalletSaveLogData(acc.id,'reason','','Pass','Pass','Pass','Pass','Pass','Pass','',obj, obj,obj,obj,'test1', 'test2','0000234534'); 
        MemberAuthenticationControllerLightning.CFCUWalletSaveLogData(acc.id,'reason','abc-1234','Pass','Pass','Pass','Pass','Pass','Pass','abc-1234',obj, obj,obj,obj,'test1', 'test2','0000234534'); 
        MemberAuthenticationControllerLightning.SaveOTPCancelledAttempt(acc.id,'',''); 
        Test.stopTest();
    }
     static testMethod void LogDataFunctionsTest() {
       
          Account acc = [Select id from Account where FirstName='U' limit 1 ];
          Account_Details__c ad = [select id from Account_Details__c where name = '00001' limit 1];
         Test.startTest();
          MemberAuthenticationControllerLightning.SaveCaseWithLogData(acc.id,'00002','casecomment',ad.id,'abc-123','abc-123');
        Test.stopTest(); 
        MemberAuthenticationControllerLightning.getPublicWalletInfo(acc.id,'abc-123');
         MemberAuthenticationControllerLightning.getPublicWalletInfo(acc.id,'abc-1234'); 
        MemberAuthenticationControllerLightning.SaveLastAchievableLevelLogs(acc.id,'abc-123','Level 1','abc-123','123-4567-765','0000084','123455','True','True','True','True','Test','1','True','1234','True', 5,18,'1234');
       MemberAuthenticationControllerLightning.SaveLastAchievableLevelLogs(acc.id,' ','Level 1',' ','123-4567-765','0000084','123455','True','True','True','True','Test','1','True','1234','True',0,18,'1234');
        string str = MemberAuthenticationControllerLightning.substring('reason',2);
       
        
        
    }
    static testMethod void LogDataFunctionsTest1() {
         Account acc = [Select id from Account where FirstName='U' limit 1 ];
         Account_Details__c ad = [select id, Name from Account_Details__c where name = '00001' limit 1];
         User u = [select id , name from user where Firstname = 'Deepika' limit 1]; 
         Map<string,Object> NextAuthenticationType = new Map<string,Object>();
         Test.startTest();
         NextAuthenticationType = MemberAuthenticationControllerLightning.GetNextAuthenticationType(acc.id, 'Domestic', 3,2, True, True, 'True', True,True, True,'abc-123',ad.Name);
         MemberAuthenticationControllerLightning.InsertLogData(acc.id,'failed','Level 1','654555555','1715','http:test.com','Verbal',u.name,'Test','abc-123','abc-123');
         Test.stopTest(); 
    }
   static testMethod void getMemberSearchDataTest(){
     
       Map<string,object> objmap = new Map<string,object>();
       objmap = MemberAuthenticationControllerLightning.getMemberSearchData('9169954478', '00002', '1715', '04-04-1963', true,'true');
       objmap = MemberAuthenticationControllerLightning.getMemberSearchData('9169954478', '00002', '1715', '04-04-1963', true,'false');
     
   }
    
    static testMethod void SaveFailedDesiredLevelLog(){
         Account acc = [Select id from Account where FirstName='U' limit 1 ];
         MemberAuthenticationControllerLightning.SaveFailedDesiredLevelLog(acc.id, 'Pass','Pass','abc-123','abc-123');
        MemberAuthenticationControllerLightning.SaveFailedDesiredLevelLog(acc.id, 'Pass','Pass','abc-12345','abc-12345');
    }
    
    static testMethod void GetTabsToAchieveNextLevel(){
         Account acc = [Select id from Account where FirstName='U' limit 1 ];
        List<Member_Authentication_Scoring_Model__c> scoreDomestic =  MemberAuthenticationControllerLightning.GetScoringModelData('Domestic');
          List<Member_Authentication_Scoring_Model__c> scoreForeign =  MemberAuthenticationControllerLightning.GetScoringModelData('Foreign');
        List<Member_Authentication_Level_Model__c> level = MemberAuthenticationControllerLightning.GetMemberAuthenticationLevel();
        map<string, List<string>> mapstr =  MemberAuthenticationControllerLightning.GetTabsToAchieveNextLevel(level, scoreDomestic, 'Domestic','Fail',true, 1,0,0,0,-1);
         map<string, List<string>> mapstr1 =  MemberAuthenticationControllerLightning.GetTabsToAchieveNextLevel(level, scoreDomestic, 'Domestic','Fail',true, 1,1,0,0,0);
         map<string, List<string>> mapstr2 =  MemberAuthenticationControllerLightning.GetTabsToAchieveNextLevel(level, scoreDomestic, 'Domestic','Pass',true, 0,1,1,0,0);
         map<string, List<string>> mapstr3 =  MemberAuthenticationControllerLightning.GetTabsToAchieveNextLevel(level, scoreDomestic, 'Domestic','Pass',true, 0,1,1,1,0);
         map<string, List<string>> mapstr4 =  MemberAuthenticationControllerLightning.GetTabsToAchieveNextLevel(level, scoreDomestic, 'Domestic','Pass',true, 1,0,1,1,0);
          map<string, List<string>> mapstr5 =  MemberAuthenticationControllerLightning.GetTabsToAchieveNextLevel(level, scoreDomestic, 'Domestic','Pass',true, 1,1,1,0,0);
         map<string, List<string>> mapstr6 =  MemberAuthenticationControllerLightning.GetTabsToAchieveNextLevel(level, scoreDomestic, 'Domestic','Pass',true, 0,1,0,0,0);
         map<string, List<string>> mapstr7 =  MemberAuthenticationControllerLightning.GetTabsToAchieveNextLevel(level, scoreDomestic, 'Domestic','Pass',true, 0,0,1,0,0);
         map<string, List<string>> mapstr8 =  MemberAuthenticationControllerLightning.GetTabsToAchieveNextLevel(level, scoreDomestic, 'Domestic','Pass',true, 0,0,0,1,0);
         map<string, List<string>> mapstr9 =  MemberAuthenticationControllerLightning.GetTabsToAchieveNextLevel(level, scoreDomestic, 'Domestic','Pass',true, 0,1,1,1,0);
        //MemberAuthenticationControllerLightning.GetTabsToAchieveNextLevel(acc.id, 'Pass','Pass','abc-12345','abc-12345');
        //GetTabsToAchieveNextLevel(List<Member_Authentication_Level_Model__c> LevelModel, List<Member_Authentication_Scoring_Model__c> ScoringModel, string MemberType, string DebitPinStatus, boolean IsPinChanged, integer IsOTPAvailable, integer IsPublicWalletAvailable,integer IsCFCUWalletAvailable,integer IsOOWAvailable, integer CurrentScore)
    }
        
}