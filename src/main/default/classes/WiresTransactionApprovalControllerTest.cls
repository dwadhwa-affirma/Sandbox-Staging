@isTest
public class WiresTransactionApprovalControllerTest{
    @testSetup
    static void setup(){

        ACH_To_Episys_API_Details__c api1 = new ACH_To_Episys_API_Details__c();
        api1.URL__c = 'test';
        api1.Name = 'ProductionURL';
        insert api1;


        Wires_DocuSign_User_Details__c wdae = new Wires_DocuSign_User_Details__c();
        wdae.Name = 'Chevron';
        wdae.AccountId__c = '2e80db6b-16cf-4202-bf90-dfa029c5949f';
        wdae.EndPoint__c = 'demo.docusign.net';
        wdae.IntegratorKey__c = '12c7957a-484f-4fec-b6b3-461ec9b666aa';
        wdae.ReplyTo__c = 'noreply@chevronfcu.org';
        wdae.TemplateId__c = '0d330f9b-9fe1-4165-a6d5-bef671134243';
        wdae.Username__c = '9c9450c4-0f40-47f7-8ee8-8292ad64f81b';
        wdae.IDVEndPoint__c = 'proof-d.docusign.net';

        insert wdae;

        Wires_DocuSign_User_Details__c wdae1 = new Wires_DocuSign_User_Details__c();
        wdae1.Name = 'Chevron-IDV';
        wdae1.AccountId__c = '2e80db6b-16cf-4202-bf90-dfa029c5949f';
        wdae1.EndPoint__c = 'demo.docusign.net';
        wdae1.IntegratorKey__c = '12c7957a-484f-4fec-b6b3-461ec9b666aa';
        wdae1.ReplyTo__c = 'noreply@chevronfcu.org';
        wdae1.TemplateId__c = '7e9a5e78-b8dd-4bde-888c-269864785110';
        wdae1.Username__c = '9c9450c4-0f40-47f7-8ee8-8292ad64f81b';
        wdae1.IDVEndPoint__c = 'proof-d.docusign.net';
        wdae1.Password__c = '!DocApi999999';
        insert wdae1;

        Profile p1 = [SELECT Id
                      FROM Profile
                      WHERE Name = 'CFCU Admin'];
        User u1 = new User(Alias = 'test1', Email = 'test1@test.com', EmailEncodingKey = 'UTF-8', LastName = 'Testing', LanguageLocaleKey = 'en_US', LocaleSidKey = 'en_US', ProfileId = p1.Id, TimeZoneSidKey = 'America/Los_Angeles', UserName = 'test1@test.com');

        Profile p2 = [SELECT Id
                      FROM Profile
                      WHERE Name = 'CFCU Admin'];
        User u2 = new User(Alias = 'test2', Email = 'test2@test.com', EmailEncodingKey = 'UTF-8', LastName = 'Testing', LanguageLocaleKey = 'en_US', LocaleSidKey = 'en_US', ProfileId = p2.Id, TimeZoneSidKey = 'America/Los_Angeles', UserName = 'test2@test.com');

        Profile p3 = [SELECT Id
                      FROM Profile
                      WHERE Name = 'CFCU Admin'];
        User u3 = new User(Alias = 'test3', Email = 'test3@test.com', EmailEncodingKey = 'UTF-8', LastName = 'Testing', LanguageLocaleKey = 'en_US', LocaleSidKey = 'en_US', ProfileId = p3.Id, TimeZoneSidKey = 'America/Los_Angeles', UserName = 'test3@test.com');

        Profile p4 = [SELECT Id
                      FROM Profile
                      WHERE Name = 'CFCU Admin'];
        User u4 = new User(Alias = 'test4', Email = 'test4@test.com', EmailEncodingKey = 'UTF-8', LastName = 'Testing', LanguageLocaleKey = 'en_US', LocaleSidKey = 'en_US', ProfileId = p4.Id, TimeZoneSidKey = 'America/Los_Angeles', UserName = 'test4@test.com');

        Profile p5 = [SELECT Id
                      FROM Profile
                      WHERE Name = 'CFCU Admin'];
        User u5 = new User(Alias = 'test5', Email = 'test5@test.com', EmailEncodingKey = 'UTF-8', LastName = 'Testing', LanguageLocaleKey = 'en_US', LocaleSidKey = 'en_US', ProfileId = p5.Id, TimeZoneSidKey = 'America/Los_Angeles', UserName = 'test5@test.com');

        Group gp1 = new Group();
        gp1.Name = 'Test Account';
        gp1.DeveloperName = 'Test_Account';
        insert gp1;

        Group gp2 = new Group();
        gp2.Name = 'Test Account';
        gp2.DeveloperName = 'Test_Account2';
        insert gp2;

        Group gp3 = new Group();
        gp3.Name = 'Test Account';
        gp3.DeveloperName = 'Test_Account3';
        insert gp3;

        Group gp4 = new Group();
        gp4.Name = 'Test Account';
        gp4.DeveloperName = 'Test_Account4';
        insert gp4;

        Group gp5 = new Group();
        gp5.Name = 'Test Account';
        gp5.DeveloperName = 'Test_Account5';
        insert gp5;


        SolarLoan_To_Episys_API_Details__c api = new SolarLoan_To_Episys_API_Details__c();
        api.URL__c = 'test';
        api.Name = 'ProductionURL';
        insert api;

        Member360_TypeTranslate__c t = new Member360_TypeTranslate__c();
        t.name = '0000/Primary';
        insert t;

        Wires_Progress_Email_Test__c wpt = new Wires_Progress_Email_Test__c();
        wpt.Name = 'Test';
        wpt.Email__c = 'test@test.com';
        insert wpt;

        Wires_Docusign_Emails__c wde = new Wires_Docusign_Emails__c();
        wde.Name = 'Email For Testing';
        wde.Emails__c = 'Testing';
        insert wde;

        Wires_Good_Fund_Limit__c goodFundLimit = new Wires_Good_Fund_Limit__c();
        goodFundLimit.Name = 'Min';
        goodFundLimit.Amount__c = 1;
        insert goodFundLimit;

        Account acc = new Account();
        acc.FirstName = 'Test FName';
        acc.LastName = 'Test LName';
        acc.Mobile_Phone__pc = '555-469-3885';
        acc.Home_Phone__pc = '555-469-3886';
        acc.Work_Phone__pc = '555-469-3887';
        acc.Email_raw__c = 'test@test.com';
        acc.PersonEmail = 'test1@test.com';
        acc.PersonID__c = 'V565138120';
        insert acc;

        acc.Mobile_Phone__pc = '555-479-3885';
        update acc;

        Account_Details__c accDetail = new Account_Details__c();
        accDetail.Name = '0000000123';
        accDetail.RecType__c = 'ACCT';
        accDetail.TypeTranslate__c = '1-PERSONAL';
        accDetail.ID1__c = '001';
        accDetail.OPEN_DATE__c = Date.newInstance(2018, 12, 10);
        insert accDetail;

        List<Person_Account__c> person_obj = new List<Person_Account__c>{ new Person_Account__c(TypeTranslate__c = '0000/Primary', Account_Number__c = accDetail.Id, PersonID__c = acc.Id) };
        Insert person_obj;

        WIRES_Transaction__c objWC = new WIRES_Transaction__c();
        objWC.Description__c = 'test';
        objWC.Fees__c = 30.0;
        objWC.Chevron_Account_Number__c = accDetail.Name;
        objWC.Share_ID__c = '001';
        objWC.FromAccount__c = accDetail.Name;
        objWC.Member_SSN__c = '565138120';
        objWC.WireAmount__c = 500;
        objWC.Approval_Status__c = 'Good Funds Review';
        objWC.FlagAccountOpenfor45Days__c = true;
        objWC.FlagEmailStablefor30Days__c = true;
        objWC.FlagHomePhoneStablefor30Days__c = true;
        objWC.FlagMobilePhoneStablefor30Days__c = true;
        objWC.FlagWorkPhoneStablefor30Days__c = false;
        insert objWC;

        WIRES_Transaction__c objWC1 = new WIRES_Transaction__c();
        objWC1.Description__c = 'test';
        objWC1.Fees__c = 30.0;
        objWC1.Chevron_Account_Number__c = accDetail.Name;
        objWC1.Share_ID__c = '001';
        objWC1.FromAccount__c = accDetail.Name;
        objWC1.Member_SSN__c = '565138120';
        objWC1.WireAmount__c = 51000;
        objWC1.Approval_Status__c = 'Good Funds Review';
        objWC1.FlagAccountOpenfor45Days__c = true;
        objWC1.FlagEmailStablefor30Days__c = true;
        objWC1.FlagHomePhoneStablefor30Days__c = true;
        objWC1.FlagMobilePhoneStablefor30Days__c = true;
        objWC1.FlagWorkPhoneStablefor30Days__c = false;
        insert objWC1;

        WIRES_Transaction__c wiretransac = new WIRES_Transaction__c();

        wiretransac.Frequency__c = 'One - Time';
        wiretransac.Source__c = 'Branch';
        wiretransac.Brand__c = 'Chevron';
        wiretransac.IsActive__c = true;
        wiretransac.FromAccount__c = '0000000123';
        wiretransac.Chevron_Account_Number__c = '0000000123';
        wiretransac.Member_SSN__c = '565138120';
        wiretransac.Share_ID__c = '0200';
        wiretransac.ToAccountName__c = '0000000123';
        wiretransac.WireAmount__c = 52000;
        wiretransac.Fees__c = 20.0;
        wiretransac.Description__c = 'Test Pending Transaction';
        wiretransac.Current_Reviewer_Modified_Date__c = DateTime.Now();
        wiretransac.Approval_Status__c = 'Pending for Second Approval';
        wiretransac.First_Reviewer__c = '005j000000FjxTKAAZ';
        insert wiretransac;

        wiretransac.Status__c = 'Completed';
        update wiretransac;


        wiretransac.FlagAccountOpenfor45Days__c = true;
        wiretransac.FlagEmailStablefor30Days__c = true;
        wiretransac.FlagHomePhoneStablefor30Days__c = true;
        wiretransac.FlagMobilePhoneStablefor30Days__c = true;
        wiretransac.FlagWorkPhoneStablefor30Days__c = true;
        wiretransac.Docusign_IDV_Failure__c = false;
        update wiretransac;

        wiretransac.Approval_Status__c = 'Pending for Approval';
        update wiretransac;
    }

    @isTest
    static void ChangeOwner_ShouldChange_OwnerId(){
        Test.startTest();

        WIRES_Transaction__c wire = [SELECT id, Approval_Status__c, FromAccount__c, Share_ID__c, Source__c, TotalFromAccount__c, WireAmount__c, Description__c, IsAccountOpenfor45Days__c, Member_Name__c, OwnerId
                                     From WIRES_Transaction__c
                                     LIMIT 1];
        WiresTransactionApprovalController.ChangeOwner(wire.Id);

        Test.stopTest();
    }

    @isTest
    static void GetPastWires(){
        Test.startTest();

        WIRES_Transaction__c wire = [Select Id, Name, Approval_Status__c
                                     From WIRES_Transaction__c
                                     LIMIT 1];
        WiresTransactionApprovalController.GetPastWires(wire.Id);

        Test.stopTest();
    }

    @isTest
    static void SetWiresStatusToDSExpired(){
        Test.startTest();

        WIRES_Transaction__c wire = [Select Id, Name, Approval_Status__c
                                     From WIRES_Transaction__c
                                     LIMIT 1];

        set<Id> ids = new set<Id>();
        ids.add(wire.Id);
        WiresTransactionApprovalController.SetWiresStatusToDSExpired(ids);

        Test.stopTest();
    }

    @isTest
    static void WaitingOnMember(){
        Test.startTest();
        WIRES_Transaction__c wireTransactions = [SELECT Id, Approval_Status__c, Waiting_for_Member__c, Waiting_on_Members_Start_Time__c, Waiting_on_Members_End_Time__c, SLA_Breach_Time__c, SLA_Yellow_Start_Time__c, SLA_Business_Hours__c, Docusign_Completed_DateTime__c, Total_Time_Spent_Waiting_for_Member__c
                                                 FROM WIRES_Transaction__c
                                                 Limit 1];
        Id id1;
        string Actions = 'Waiting';

        WiresTransactionApprovalController.WaitingOnMember(id1, Actions);
        update wireTransactions;
        Test.stopTest();
    }

    @isTest
    static void CancelTransaction_ShouldChange_ApprovalStatus_To_Cancelled(){
        Test.startTest();

        WIRES_Transaction__c wire = [SELECT id, Approval_Status__c, FromAccount__c, Share_ID__c, Source__c, TotalFromAccount__c, WireAmount__c, Description__c, IsAccountOpenfor45Days__c, Member_Name__c, Identity_Verification_Used__c, IsEmailStable__c, IsHomePhoneStable__c, IsMobilePhoneStable__c, IsWorkPhoneStable__c, AccountStableReview__c, Available_Balance_Review__c, EmailStableReview__c, Review_Reason__c, Home_Phone_Stable_Review__c, ID_Verification_Review__c, Mobile_Phone_Stable_Review__c, Previous_Wires_Review__c, Work_Phone_Stable_Review__c, FlagAccountOpenfor45Days__c, member__c, member__r.personemail, FlagEmailStablefor30Days__c, FlagHomePhoneStablefor30Days__c, FlagMobilePhoneStablefor30Days__c, FlagWorkPhoneStablefor30Days__c
                                     from WIRES_Transaction__c
                                     LIMIT 1];
        WiresTransactionApprovalController.CancelTransaction(wire.Id, 'Cancelling transactiom from test method');

        Test.stopTest();
    }

    @isTest
    static void SendToFraud_ShouldChange_ApprovalStatus_To_FraudRejected(){
        Test.startTest();
        WIRES_Transaction__c wire = [Select Id, Name, Approval_Status__c, Reason_for__c
                                     From WIRES_Transaction__c
                                     LIMIT 1];
        WiresTransactionApprovalController.SendToFraud(wire.Id, wire.Reason_for__c);
        WiresTransactionApprovalController.SendSMS('1234567890');
        Test.stopTest();
    }

    @isTest
    static void SendToGoodFundCheckFailed_ShouldChange_ApprovalStatus_To_PendingForApproval(){
        Test.startTest();

        WIRES_Transaction__c wire = [Select Id, Name, Approval_Status__c
                                     From WIRES_Transaction__c
                                     LIMIT 1];
        WiresTransactionApprovalController.SendToGoodFundCheckFailed(wire.Id);

        WiresTransactionApprovalController.SendSMS('1234567890');


        Test.stopTest();
    }

    @isTest
    static void SetWiresStatusToDSDeclined_ShouldChange_ApprovalStatus_To_DSDeclined(){
        Test.startTest();

        WIRES_Transaction__c wire = [SELECT Id, Name, Approval_Status__c, ToAccountName__c, ToAccoutId__c, Status__c, FromAccount__c, TotalFromAccount__c, WireAmount__c, ToAccoutId__r.Recipient_AccountNumber__c, SendOn__c, Source__c, ToAccoutId__r.BankName__c, ToAccoutId__r.RoutingNumber__c, AccountStableReview__c, EmailStableReview__c, Member_Name__c, Identity_Verification_Used__c, Home_Phone_Stable_Review__c, Mobile_Phone_Stable_Review__c, Work_Phone_Stable_Review__c, FlagAccountOpenfor45Days__c, FlagEmailStablefor30Days__c, FlagHomePhoneStablefor30Days__c, FlagMobilePhoneStablefor30Days__c, FlagWorkPhoneStablefor30Days__c, Share_ID__c
                                     FROM WIRES_Transaction__c
                                     LIMIT 1];
        Set<Id> ids = new Set<Id>();
        ids.add(wire.Id);

        WiresTransactionApprovalController.SetWiresStatusToDSDeclined(ids);

        Test.stopTest();
    }

    @isTest
    static void SetIdentityVerificationUsed_Should_SetIdentityVerification(){
        Test.startTest();
        WIRES_Transaction__c wires = [Select Id, Name, Approval_Status__c
                                      From WIRES_Transaction__c
                                      Order By CreatedDate Desc
                                      Limit 1];

        wires.WireAmount__c = 50001;
        update wires;
        Set<Id> ids = new Set<Id>();
        ids.add(wires.Id);
        WiresTransactionApprovalController.SetIdentityVerificationUsed(ids);

        Test.stopTest();
    }

    @isTest
    static void CheckRedFlgs_And_UpdateStatus(){
        Test.startTest();

        WIRES_Transaction__c wire = [Select Id, Name, Approval_Status__c
                                     From WIRES_Transaction__c
                                     LIMIT 1];

        Set<Id> ids = new Set<Id>();
        ids.add(wire.Id);

        Test.stopTest();
    }

    @isTest
    static void method1(){

        test.startTest();
        WIRES_Transaction__c objWC1 = new WIRES_Transaction__c();
        objWC1.Description__c = 'test';
        objWC1.Fees__c = 30.0;
        objWC1.Chevron_Account_Number__c = '0000000123';
        objWC1.Share_ID__c = '001';
        objWC1.FromAccount__c = '0000000123';
        objWC1.Member_SSN__c = '565138120';
        objWC1.WireAmount__c = 500;
        objWC1.Approval_Status__c = WiresConstant.ApprovalStatus_PendingForApproval;//'Fraud Review';
        objWC1.FlagAccountOpenfor45Days__c = true;
        objWC1.FlagEmailStablefor30Days__c = true;
        objWC1.FlagHomePhoneStablefor30Days__c = true;
        objWC1.FlagMobilePhoneStablefor30Days__c = true;
        objWC1.FlagWorkPhoneStablefor30Days__c = false;
        insert objWC1;

        WiresTransactionApprovalController.getWiresData(objWC1.ID);

        WIRES_Transaction__c objWC2 = new WIRES_Transaction__c();
        objWC2.Description__c = 'test';
        objWC2.Fees__c = 30.0;
        objWC2.Chevron_Account_Number__c = '0000000123';
        objWC2.Share_ID__c = '001';
        objWC2.FromAccount__c = '0000000123';
        objWC2.Member_SSN__c = '565138120';
        objWC2.WireAmount__c = 500;
        objWC2.Approval_Status__c = 'Fraud Review';
        objWC2.FlagAccountOpenfor45Days__c = true;
        objWC2.FlagEmailStablefor30Days__c = true;
        objWC2.FlagHomePhoneStablefor30Days__c = true;
        objWC2.FlagMobilePhoneStablefor30Days__c = true;
        objWC2.FlagWorkPhoneStablefor30Days__c = false;
        insert objWC2;


        WiresTransactionApprovalController.getWiresData(objWC2.ID);

        WIRES_Transaction__c wiretransac = new WIRES_Transaction__c();

        wiretransac.Frequency__c = 'One - Time';
        wiretransac.Source__c = 'Branch';
        wiretransac.Brand__c = 'Chevron';
        wiretransac.IsActive__c = true;
        wiretransac.FromAccount__c = '0000000123';
        wiretransac.Chevron_Account_Number__c = '0000000123';
        wiretransac.Member_SSN__c = '565138120';
        wiretransac.Share_ID__c = '0200';
        wiretransac.ToAccountName__c = '0000000123';
        wiretransac.WireAmount__c = 52000;
        wiretransac.Fees__c = 20.0;
        wiretransac.Description__c = 'Test recurring transaction';
        wiretransac.Current_Reviewer_Modified_Date__c = DateTime.Now();
        wiretransac.Approval_Status__c = 'Pending for Second Approval';
        wiretransac.First_Reviewer__c = '005j000000FjxTKAAZ';
        insert wiretransac;

        wiretransac.Status__c = 'Completed';
        update wiretransac;

        wiretransac.FlagAccountOpenfor45Days__c = true;
        wiretransac.FlagEmailStablefor30Days__c = true;
        wiretransac.FlagHomePhoneStablefor30Days__c = true;
        wiretransac.FlagMobilePhoneStablefor30Days__c = true;
        wiretransac.FlagWorkPhoneStablefor30Days__c = true;
        wiretransac.Docusign_IDV_Failure__c = false;
        update wiretransac;

        wiretransac.Approval_Status__c = 'Pending for Approval';
        update wiretransac;

        WiresTransactionApprovalController.getWiresData(wiretransac.id);

        wiretransac.WireAmount__c = 5000;
        update wiretransac;

        WiresTransactionApprovalController.getWiresData(wiretransac.id);

        wiretransac.WireAmount__c = 200000;
        update wiretransac;

        WiresTransactionApprovalController.getWiresData(wiretransac.id);

        wiretransac.WireAmount__c = 260000;
        update wiretransac;

        WiresTransactionApprovalController.getWiresData(wiretransac.id);

        test.stopTest();
    }

    @isTest
    static void method2(){

        Account_Details__c accDetail1 = new Account_Details__c();
        accDetail1.Name = '0000000123';
        accDetail1.RecType__c = 'ACCT';
        accDetail1.TypeTranslate__c = '1-PERSONAL';
        accDetail1.ID1__c = '001';
        accDetail1.OPEN_DATE__c = Date.newInstance(2018, 12, 10);
        insert accDetail1;

        WIRES_Transaction__c objWC2 = new WIRES_Transaction__c();
        objWC2.Description__c = 'test';
        objWC2.Fees__c = 30.0;
        objWC2.Chevron_Account_Number__c = accDetail1.Name;
        objWC2.Share_ID__c = '001';
        objWC2.FromAccount__c = accDetail1.Name;
        objWC2.Member_SSN__c = '565138120';
        objWC2.WireAmount__c = 500;
        objWC2.Approval_Status__c = 'Good Funds Review';
        objWC2.FlagAccountOpenfor45Days__c = true;
        objWC2.FlagEmailStablefor30Days__c = true;
        objWC2.FlagHomePhoneStablefor30Days__c = true;
        objWC2.FlagMobilePhoneStablefor30Days__c = true;
        objWC2.FlagWorkPhoneStablefor30Days__c = false;
        objWC2.Source__c = 'Branch';

        insert objWC2;

        WiresTransactionApprovalController.getWiresData(objWC2.ID);
    }

    @isTest
    static void TestSendProgressNotification(){


        Account acc1 = new Account();
        acc1.FirstName = 'TestF FName';
        acc1.LastName = 'TestL LName';
        acc1.Mobile_Phone__pc = '554-469-3885';
        acc1.Home_Phone__pc = '554-469-3886';
        acc1.Work_Phone__pc = '554-469-3887';
        acc1.Email_raw__c = 'test1@test.com';
        acc1.PersonEmail = 'test12@test.com';
        acc1.PersonID__c = 'V565138121';
        insert acc1;

        Account_Details__c accDetail1 = new Account_Details__c();
        accDetail1.Name = '0000000123';
        accDetail1.RecType__c = 'ACCT';
        accDetail1.TypeTranslate__c = '1-PERSONAL';
        accDetail1.ID1__c = '001';
        accDetail1.OPEN_DATE__c = Date.newInstance(2018, 12, 10);
        insert accDetail1;

        WIRES_Transaction__c objWC3 = new WIRES_Transaction__c();
        objWC3.Description__c = 'test';
        objWC3.Fees__c = 30.0;
        objWC3.Chevron_Account_Number__c = accDetail1.Name;
        objWC3.Share_ID__c = '001';
        objWC3.FromAccount__c = accDetail1.Name;
        objWC3.Member_SSN__c = '565138120';
        objWC3.WireAmount__c = 52000;
        objWC3.Member__c = acc1.ID;
        objWC3.Approval_Status__c = 'Good Funds Review';
        objWC3.FlagAccountOpenfor45Days__c = true;
        objWC3.FlagEmailStablefor30Days__c = true;
        objWC3.FlagHomePhoneStablefor30Days__c = true;
        objWC3.FlagMobilePhoneStablefor30Days__c = true;
        objWC3.FlagWorkPhoneStablefor30Days__c = false;
        objWC3.Source__c = 'Branch';

        insert objWC3;
    }

    @isTest
    static void TestReleasedToWireXchangeEmailNotification(){


        Account acc1 = new Account();
        acc1.FirstName = 'TestF FName';
        acc1.LastName = 'TestL LName';
        acc1.Mobile_Phone__pc = '554-469-3885';
        acc1.Home_Phone__pc = '554-469-3886';
        acc1.Work_Phone__pc = '554-469-3887';
        acc1.Email_raw__c = 'test1@test.com';
        acc1.PersonEmail = 'test12@test.com';
        acc1.PersonID__c = 'V565138121';
        insert acc1;


        Account_Details__c accDetail1 = new Account_Details__c();
        accDetail1.Name = '0000000123';
        accDetail1.RecType__c = 'ACCT';
        accDetail1.TypeTranslate__c = '1-PERSONAL';
        accDetail1.ID1__c = '001';
        accDetail1.OPEN_DATE__c = Date.newInstance(2018, 12, 10);
        insert accDetail1;


        WIRES_Transaction__c objWC4 = new WIRES_Transaction__c();
        objWC4.Description__c = 'test';
        objWC4.Fees__c = 30.0;
        objWC4.Chevron_Account_Number__c = accDetail1.Name;
        objWC4.Share_ID__c = '001';
        objWC4.FromAccount__c = accDetail1.Name;
        objWC4.Member_SSN__c = '565138120';
        objWC4.WireAmount__c = 50001;
        objWC4.Member__c = acc1.ID;
        objWC4.Approval_Status__c = 'Good Funds Review';
        objWC4.FlagAccountOpenfor45Days__c = true;
        objWC4.FlagEmailStablefor30Days__c = true;
        objWC4.FlagHomePhoneStablefor30Days__c = true;
        objWC4.FlagMobilePhoneStablefor30Days__c = true;
        objWC4.FlagWorkPhoneStablefor30Days__c = false;
        objWC4.Source__c = 'Branch';

        insert objWC4;
    }

    @isTest
    static void TestCheckRedFlgsAndUpdateStatus(){

        Account acc1 = new Account();
        acc1.FirstName = 'TestF FName';
        acc1.LastName = 'TestL LName';
        acc1.Mobile_Phone__pc = '554-469-3885';
        acc1.Home_Phone__pc = '554-469-3886';
        acc1.Work_Phone__pc = '554-469-3887';
        acc1.Email_raw__c = 'test1@test.com';
        acc1.PersonEmail = 'test12@test.com';
        acc1.PersonID__c = 'V565138121';
        insert acc1;


        Account_Details__c accDetail1 = new Account_Details__c();
        accDetail1.Name = '0000000123';
        accDetail1.RecType__c = 'ACCT';
        accDetail1.TypeTranslate__c = '1-PERSONAL';
        accDetail1.ID1__c = '001';
        accDetail1.OPEN_DATE__c = Date.newInstance(2018, 12, 10);
        insert accDetail1;


        WIRES_Transaction__c objWC4 = new WIRES_Transaction__c();
        objWC4.Description__c = 'test';
        objWC4.Fees__c = 30.0;
        objWC4.Chevron_Account_Number__c = accDetail1.Name;
        objWC4.Share_ID__c = '001';
        objWC4.FromAccount__c = accDetail1.Name;
        objWC4.Member_SSN__c = '565138120';
        objWC4.WireAmount__c = 250001;
        objWC4.Member__c = acc1.ID;
        objWC4.Approval_Status__c = 'Good Funds Review';
        objWC4.FlagAccountOpenfor45Days__c = true;
        objWC4.FlagEmailStablefor30Days__c = true;
        objWC4.FlagHomePhoneStablefor30Days__c = true;
        objWC4.FlagMobilePhoneStablefor30Days__c = true;
        objWC4.FlagWorkPhoneStablefor30Days__c = false;
        objWC4.Source__c = 'Branch';
        objWC4.SendOn__c = System.today();

        insert objWC4;

        Set<ID> setid = new Set<ID>();
        setid.add(objWC4.Id);
        WiresTransactionApprovalController.CheckRedFlgsAndUpdateStatus(setid);
    }

    @isTest
    static void TestCheckRedFlgsAndUpdateStatus1(){


        Account acc1 = new Account();
        acc1.FirstName = 'TestF FName';
        acc1.LastName = 'TestL LName';
        acc1.Mobile_Phone__pc = '554-469-3885';
        acc1.Home_Phone__pc = '554-469-3886';
        acc1.Work_Phone__pc = '554-469-3887';
        acc1.Email_raw__c = 'test1@test.com';
        acc1.PersonEmail = 'test12@test.com';
        acc1.PersonID__c = 'V565138121';
        insert acc1;


        Account_Details__c accDetail1 = new Account_Details__c();
        accDetail1.Name = '0000000123';
        accDetail1.RecType__c = 'ACCT';
        accDetail1.TypeTranslate__c = '1-PERSONAL';
        accDetail1.ID1__c = '001';
        accDetail1.OPEN_DATE__c = Date.newInstance(2018, 12, 10);
        insert accDetail1;


        WIRES_Transaction__c objWC5 = new WIRES_Transaction__c();
        objWC5.Description__c = 'test';
        objWC5.Fees__c = 30.0;
        objWC5.Chevron_Account_Number__c = accDetail1.Name;
        objWC5.Share_ID__c = '001';
        objWC5.FromAccount__c = accDetail1.Name;
        objWC5.Member_SSN__c = '565138120';
        objWC5.WireAmount__c = 24999;
        objWC5.Member__c = acc1.ID;
        objWC5.Approval_Status__c = 'Fraud Review';
        objWC5.FlagAccountOpenfor45Days__c = true;
        objWC5.FlagEmailStablefor30Days__c = true;
        objWC5.FlagHomePhoneStablefor30Days__c = true;
        objWC5.FlagMobilePhoneStablefor30Days__c = true;
        objWC5.FlagWorkPhoneStablefor30Days__c = false;
        objWC5.Source__c = 'Branch';
        objWC5.SLA_Business_Hours__c = 10;
        objWC5.Docusign_Completed_DateTime__c = Date.newInstance(2018, 12, 10);
        objWC5.Total_Time_Spent_Waiting_for_Member__c = 1;
        insert objWC5;
        String str = JSON.serialize(objWC5);

        WIRES_Transaction__c Wires = [SELECT id, Approval_Status__c, FromAccount__c, Share_ID__c, Source__c, TotalFromAccount__c, WireAmount__c, Description__c, IsAccountOpenfor45Days__c, Member_Name__c, Identity_Verification_Used__c, IsEmailStable__c, IsHomePhoneStable__c, IsMobilePhoneStable__c, IsWorkPhoneStable__c, AccountStableReview__c, Available_Balance_Review__c, EmailStableReview__c, Review_Reason__c, Home_Phone_Stable_Review__c, ID_Verification_Review__c, Mobile_Phone_Stable_Review__c, Previous_Wires_Review__c, Work_Phone_Stable_Review__c, FlagAccountOpenfor45Days__c, FlagEmailStablefor30Days__c, FlagHomePhoneStablefor30Days__c, FlagMobilePhoneStablefor30Days__c, FlagWorkPhoneStablefor30Days__c, Docusign_Review__c, First_Approval_Comment__c, Second_Approval_Comment__c
                                      from WIRES_Transaction__c
                                      where Description__c = 'Test Pending Transaction'
                                      limit 1];
        test.startTest();
        WiresTransactionApprovalController.ApproveTransaction(objWC5.ID, 'Reject', str);
        WiresTransactionApprovalController.ApproveTransaction(objWC5.ID, 'Good Funds Review', str);
        WiresTransactionApprovalController.ApproveTransaction(objWC5.ID, 'Pending for Approval', str);

        Wires.WireAmount__c = 100003;
        update Wires;

        String str1 = JSON.serialize(Wires);
        WiresTransactionApprovalController.ApproveTransaction(Wires.ID, 'Approve', str1);

        Wires.Source__c = 'Online Banking';
        update Wires;

        WiresTransactionApprovalController.WaitingOnMember(Wires.ID, 'Waiting');
        WiresTransactionApprovalController.WaitingOnMember(objWC5.ID, 'Continue');

        WiresTransactionApprovalController.ApproveTransaction(Wires.ID, 'Approve', str1);

        Set<ID> WireTransactionIds = new Set<Id>();
        WireTransactionIds.add(objWC5.Id);

        WiresTransactionApprovalController.SetSLA(WireTransactionIds);


        Set<ID> set_id = new Set<Id>();
        set_id.add(objWC5.Id);

        WiresTransactionApprovalController.CheckGoodFundAndUpdateStatus(set_id);

        Wires.WireAmount__c = 24000;
        update Wires;
        Set<ID> set_id1 = new Set<Id>();
        set_id1.add(Wires.Id);
        WiresTransactionApprovalController.CheckRedFlgsAndUpdateStatus(set_id1);
        test.stopTest();
    }

    @isTest
    static void TestGetCutoffTimeIn12HourAMPMFormat(){
        string cutofftime = WiresTransactionApprovalController.getCutoffTimeIn12HourAMPMFormat('14.30');
        System.assertEquals(cutofftime, '2:30 PM');
    }

    @isTest
    static void TestGetFailedIDVDetails(){

        test.startTest();
        Account acc1 = new Account();
        acc1.FirstName = 'TestF FName';
        acc1.LastName = 'TestL LName';
        acc1.Mobile_Phone__pc = '554-469-3885';
        acc1.Home_Phone__pc = '554-469-3886';
        acc1.Work_Phone__pc = '554-469-3887';
        acc1.Email_raw__c = 'test1@test.com';
        acc1.PersonEmail = 'test12@test.com';
        acc1.PersonID__c = 'V565138121';
        insert acc1;

        Account_Details__c accDetail1 = new Account_Details__c();
        accDetail1.Name = '0000000123';
        accDetail1.RecType__c = 'ACCT';
        accDetail1.TypeTranslate__c = '1-PERSONAL';
        accDetail1.ID1__c = '001';
        accDetail1.OPEN_DATE__c = Date.newInstance(2018, 12, 10);
        insert accDetail1;

        WIRES_Transaction__c objWC1 = new WIRES_Transaction__c();
        objWC1.Description__c = 'test';
        objWC1.Fees__c = 30.0;
        objWC1.Chevron_Account_Number__c = accDetail1.Name;
        objWC1.Share_ID__c = '001';
        objWC1.FromAccount__c = accDetail1.Name;
        objWC1.Member_SSN__c = '565138120';
        objWC1.WireAmount__c = 51000;
        objWC1.Approval_Status__c = 'Good Funds Review';
        objWC1.FlagAccountOpenfor45Days__c = true;
        objWC1.FlagEmailStablefor30Days__c = true;
        objWC1.FlagHomePhoneStablefor30Days__c = true;
        objWC1.FlagMobilePhoneStablefor30Days__c = true;
        objWC1.FlagWorkPhoneStablefor30Days__c = false;
        insert objWC1;

        Set<ID> setid = new Set<ID>();
        setid.add(objWC1.Id);

        WiresTransactionApprovalController.GetFailedIDVDetails(objWC1.Id);
        WiresTransactionApprovalController.SendDocusignEmail(objWC1.Id);
        Set<ID> setids = new Set<ID>();
        setids.add(objWC1.Id);
        WiresTransactionApprovalController.SendProgressNotification(setids);
        Set<ID> setids_s = new Set<ID>();
        setids_s.add(objWC1.Id);
        WiresTransactionApprovalController.ReleasedToWireXchangeEmailNotification(setids_s);
        WiresTransactionApprovalController.FraudReviewMARSDetailsWrapperObject obj1 = new WiresTransactionApprovalController.FraudReviewMARSDetailsWrapperObject();

        obj1.ResidentialAddress = 'Test';
        obj1.IdNumber = 'Test';
        obj1.ExpirationDate = Date.today();
        obj1.IssuanceDate = Date.today();
        obj1.IssuingCountry = 'Test';
        obj1.TypeOfId = 'Test';
        obj1.Sex = 'Test';
        obj1.DateOfBirth = Date.today();
        obj1.FirstNames = 'Test';
        obj1.MiddleNames = 'Test';
        obj1.LastNames = 'Test';
        obj1.FullName = 'Test';
        test.stopTest();
    }

    @isTest
    static void GetAuthorizedMembers(){
        WiresTransactionApprovalController.GetAuthorizedMembers('0000000123');
    }

    @isTest
    static void AddBusinessHoursTest(){
        Test.startTest();
        BusinessHours stdBusinessHours = [select id
                                          from businesshours
                                          where isDefault = true];
        WiresTransactionApprovalController.AddBusinessHours(datetime.newInstance(2014, 9, 15, 12, 30, 0), 50000L);
        WiresTransactionApprovalController.AuthorizedMember obj2 = new WiresTransactionApprovalController.AuthorizedMember();
        obj2.AccountNo = '000000001';
        obj2.AcctType = 'Primary';
        obj2.MemberName = 'Test';
        obj2.SSN = '0000';
        WiresTransactionApprovalController.PastWiresWrapper obj3 = new WiresTransactionApprovalController.PastWiresWrapper();
        obj3.WireNumber = '000000001';
        obj3.SentDate = Date.today();
        obj3.FromAccount = '000000002';
        obj3.RecipientAccount = '000000023';
        obj3.Recipient = 'Test';
        obj3.Amount = 250.00;

        Sla_Manager__mdt slaDefList = [SELECT DeveloperName, Event_Source__c, Opportunity_Source__c, Product_Type__c, SLA__c, StageName__c
                                       FROM Sla_Manager__mdt
                                       WHERE Object_Name__c = 'WIRES_Transaction__c'
                                       ORDER BY DeveloperName ASC
                                       limit 1];
        slaDefList.Sla__c = 2;
        Test.stopTest();
    }

    public class DocusignIDVAPICallMock implements HttpCalloutMock{
        public HTTPResponse respond(HTTPRequest request){
            HttpResponse response = new HttpResponse();
            response.setHeader('Content-Type', 'application/json');
            response.setBody('{"animal": {"id":2, "name":"Test"}}');
            response.setStatusCode(200);
            return response;
        }

    }

}