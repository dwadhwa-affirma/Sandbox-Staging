@isTest
public class WIRESTransactionTriggerTest{
    static testMethod void test1(){
        SolarLoan_To_Episys_API_Details__c api = new SolarLoan_To_Episys_API_Details__c();
        api.URL__c = 'https://symxapi.chevronfcu.org/devclient';
        api.Name = 'ProductionURL';
        insert api;

        Member360_TypeTranslate__c t = new Member360_TypeTranslate__c();
        t.name = '0000/Primary';
        insert t;

        Profile p2 = [SELECT Id
                      FROM Profile
                      WHERE Name = 'CFCU Admin'];
        User u2 = new User(Alias = 'test122', Email = 'test1@test.com', EmailEncodingKey = 'UTF-8', LastName = 'Testing', LanguageLocaleKey = 'en_US', LocaleSidKey = 'en_US', ProfileId = p2.Id, TimeZoneSidKey = 'America/Los_Angeles', UserName = 'test122_Testing@test.com');
        insert u2;

        List<string> emails = new List<string>();
        emails.add(u2.Email);

        Wires_Progress_Email_Test__c wpt = new Wires_Progress_Email_Test__c();
        wpt.Name = 'Test';
        wpt.Email__c = 'test@test.com';
        insert wpt;

        Wires_Docusign_Emails__c wde = new Wires_Docusign_Emails__c();
        wde.Name = 'Email For Testing';
        wde.Emails__c = 'Testing';
        insert wde;


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
        accDetail.Name = '00000000123';
        accDetail.RecType__c = 'ACCT';
        accDetail.TypeTranslate__c = '1-PERSONAL';
        accDetail.ID1__c = '001';
        accDetail.OPEN_DATE__c = Date.newInstance(2018, 12, 10);
        insert accDetail;

        List<Person_Account__c> person_obj = new List<Person_Account__c>{ new Person_Account__c(TypeTranslate__c = '0000/Primary', Account_Number__c = accDetail.Id, PersonID__c = acc.Id), new Person_Account__c(TypeTranslate__c = '0000/Primary', Account_Number__c = accDetail.Id, PersonID__c = acc.Id) };
        Insert person_obj;

        WIRES_Transaction__c objWC = new WIRES_Transaction__c();
        objWC.Description__c = 'test';
        objWC.Fees__c = 30.0;
        objWC.Chevron_Account_Number__c = accDetail.Name;
        objWC.Share_ID__c = '001';
        objWC.FromAccount__c = accDetail.Name;
        objWC.Status__c = 'Pending';
        objWC.Member_SSN__c = '565138120';
        objWC.WireAmount__c = 500;
        objWC.Frequency__c = 'One - Time';
        objWC.Source__c = 'Branch';
        objWC.First_Reviewer__c = UserInfo.getUserId();
        objWC.Current_Reviewer__c = UserInfo.getUserId();
        insert objWC;
        objWC.Current_Reviewer_Modified_Date__c = DateTime.now();
        objWC.WireAmount__c = 400;
        objWC.Current_Reviewer__c = objWC.First_Reviewer__c;
        objWC.Frequency__c = 'One - Time';
        objWC.Approval_Status__c = 'Released In WireXchange';
        objWC.Status__c = 'voided';
        objWC.Source__c = 'Online Banking';
        objWC.Has_Additional_Documents__c = true;
        update objWC;

        WIRES_Transaction__c objWCc = new WIRES_Transaction__c();
        objWCc.Description__c = 'test';
        objWCc.Fees__c = 30.0;
        objWCc.Chevron_Account_Number__c = accDetail.Name;
        objWCc.Share_ID__c = '001';
        objWCc.FromAccount__c = accDetail.Name;
        objWCc.Status__c = 'Pending';
        objWCc.Member_SSN__c = '565138120';
        objWCc.WireAmount__c = 500;
        objWCc.Frequency__c = 'One - Time';
        objWCc.Source__c = 'Branch';
        objWCc.Current_Reviewer__c = UserInfo.getUserId();
        insert objWCc;
        objWCc.Current_Reviewer_Modified_Date__c = DateTime.now();
        objWCc.WireAmount__c = 400;
        objWCc.Current_Reviewer__c = objWC.First_Reviewer__c;
        objWCc.Frequency__c = 'One - Time';
        objWCc.Approval_Status__c = 'Rejected';
        objWCc.Status__c = 'Pending';
        objWCc.Source__c = 'Branch';
        objWCc.Has_Additional_Documents__c = true;
        update objWCc;

        WIRES_Transaction__c objWCc1 = new WIRES_Transaction__c();
        objWCc1.Description__c = 'test';
        objWCc1.Fees__c = 30.0;
        objWCc1.Chevron_Account_Number__c = accDetail.Name;
        objWCc1.Share_ID__c = '001';
        objWCc1.FromAccount__c = accDetail.Name;
        objWCc1.Status__c = 'Pending';
        objWCc1.Member_SSN__c = '565138120';
        objWCc1.WireAmount__c = 500;
        objWCc1.Frequency__c = 'One - Time';
        objWCc1.Source__c = 'Branch';
        objWCc1.Current_Reviewer__c = UserInfo.getUserId();
        insert objWCc1;
        objWCc1.Approval_Status__c = 'Cancelled';
        objWCc1.Status__c = 'Pending';
        objWCc1.Source__c = 'Branch';
        update objWCc1;
    }

    static testMethod void test2(){
        SolarLoan_To_Episys_API_Details__c api = new SolarLoan_To_Episys_API_Details__c();
        api.URL__c = 'https://symxapi.chevronfcu.org/devclient';
        api.Name = 'ProductionURL';
        insert api;

        Member360_TypeTranslate__c t = new Member360_TypeTranslate__c();
        t.name = '0000/Primary';
        insert t;
        Profile p1 = [SELECT Id
                      FROM Profile
                      WHERE Name = 'CFCU Admin'];
        User u1 = new User(Alias = 'test122', Email = 'test1testing@test.com', EmailEncodingKey = 'UTF-8', LastName = 'Testing', LanguageLocaleKey = 'en_US', LocaleSidKey = 'en_US', ProfileId = p1.Id, TimeZoneSidKey = 'America/Los_Angeles', UserName = 'test122_Testing@test.com');
        insert u1;

        List<string> email2 = new List<string>();
        email2.add(u1.Email);

        Wires_Progress_Email_Test__c wpt = new Wires_Progress_Email_Test__c();
        wpt.Name = 'Test';
        wpt.Email__c = 'test@test.com';
        insert wpt;

        Wires_Docusign_Emails__c wde = new Wires_Docusign_Emails__c();
        wde.Name = 'Email For Testing';
        wde.Emails__c = 'Testing';
        insert wde;

        Account acc = new Account();
        acc.FirstName = 'Test FName';
        acc.LastName = 'Test LName';
        acc.Mobile_Phone__pc = '555-469-3885';
        acc.Email_raw__c = 'test@test.com';
        acc.PersonEmail = 'test1@test.com';
        acc.PersonID__c = 'V565138120';
        insert acc;
        acc.Home_Phone__pc = '555-469-3886';
        acc.Work_Phone__pc = '555-469-3887';
        acc.Mobile_Phone__pc = '555-479-3885';
        update acc;

        Account_Details__c accDetail = new Account_Details__c();
        accDetail.Name = '00000000123';
        accDetail.RecType__c = 'ACCT';
        accDetail.TypeTranslate__c = '1-PERSONAL';
        accDetail.ID1__c = '001';
        accDetail.OPEN_DATE__c = Date.newInstance(2018, 12, 10);
        insert accDetail;

        List<Person_Account__c> person_obj = new List<Person_Account__c>{ new Person_Account__c(TypeTranslate__c = '0000/Primary', Account_Number__c = accDetail.Id, PersonID__c = acc.Id), new Person_Account__c(TypeTranslate__c = '0000/Primary', Account_Number__c = accDetail.Id, PersonID__c = acc.Id) };
        Insert person_obj;

        WIRES_Transaction__c objWC = new WIRES_Transaction__c();
        objWC.Description__c = 'test';
        objWC.Fees__c = 30.0;
        objWC.Chevron_Account_Number__c = accDetail.Name;
        objWC.Share_ID__c = '001';
        objWC.FromAccount__c = accDetail.Name;
        objWC.Member_SSN__c = '565138120';
        objWC.WireAmount__c = 500;
        objWC.Frequency__c = 'Recurring';
        objWC.Current_Reviewer__c = UserInfo.getUserId();
        objWC.Approval_Status__c = 'Rejected';
        objWC.Source__c = 'Branch';
        objWC.Current_Reviewer_Modified_Date__c = datetime.now();

        insert objWC;
        objWC.Current_Second_Reviewer__c = UserInfo.getUserId();
        objWC.Approval_Status__c = 'Rejected';
        objWC.WireAmount__c = 5000;
        objWC.Current_Reviewer__c = UserInfo.getUserId();
        objWC.Frequency__c = 'One - Time';
        objWC.Source__c = 'Branch';
        objWC.Current_Reviewer_Modified_Date__c = DateTime.now();
        objWC.Status__c = 'Completed';
        objWC.Source__c = 'Online Banking';
        update objWC;
    }

    static testMethod void test3(){

        SolarLoan_To_Episys_API_Details__c api = new SolarLoan_To_Episys_API_Details__c();
        api.URL__c = 'https://symxapi.chevronfcu.org/devclient';
        api.Name = 'ProductionURL';
        insert api;

        Member360_TypeTranslate__c t = new Member360_TypeTranslate__c();
        t.name = '0000/Primary';
        insert t;

        Profile p3 = [SELECT Id
                      FROM Profile
                      WHERE Name = 'CFCU Admin'];
        User u3 = new User(Alias = 'test122', Email = 'test1@test.com', EmailEncodingKey = 'UTF-8', LastName = 'Testing', LanguageLocaleKey = 'en_US', LocaleSidKey = 'en_US', ProfileId = p3.Id, TimeZoneSidKey = 'America/Los_Angeles', UserName = 'test122_Testing@test.com');
        insert u3;

        List<string> email3 = new List<string>();
        email3.add(u3.Email);

        Wires_Progress_Email_Test__c wpt = new Wires_Progress_Email_Test__c();
        wpt.Name = 'Test';
        wpt.Email__c = 'test@test.com';
        insert wpt;

        Wires_Docusign_Emails__c wde = new Wires_Docusign_Emails__c();
        wde.Name = 'Email For Testing';
        wde.Emails__c = 'Testing';
        insert wde;

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
        acc.PersonEmail = 'test1@test.com';
        acc.Work_Phone__pc = '555-469-3887';
        acc.Mobile_Phone__pc = '555-479-3885';
        update acc;

        Account_Details__c accDetail = new Account_Details__c();
        accDetail.Name = '00000000123';
        accDetail.RecType__c = 'ACCT';
        accDetail.TypeTranslate__c = '1-PERSONAL';
        accDetail.ID1__c = '001';
        accDetail.OPEN_DATE__c = Date.newInstance(2018, 12, 10);
        insert accDetail;

        List<Person_Account__c> person_obj = new List<Person_Account__c>{ new Person_Account__c(TypeTranslate__c = '0000/Primary', Account_Number__c = accDetail.Id, PersonID__c = acc.Id), new Person_Account__c(TypeTranslate__c = '0000/Primary', Account_Number__c = accDetail.Id, PersonID__c = acc.Id) };
        Insert person_obj;

        WIRES_Transaction__c objWC = new WIRES_Transaction__c();
        objWC.Description__c = 'test';
        objWC.Fees__c = 30.0;
        objWC.Chevron_Account_Number__c = accDetail.Name;
        objWC.Share_ID__c = '001';
        objWC.FromAccount__c = accDetail.Name;
        objWC.Member_SSN__c = '565138120';
        objWC.WireAmount__c = 100;
        objWC.Frequency__c = 'Recurring';
        objWC.Current_Reviewer__c = UserInfo.getUserId();

        insert objWC;

        objWC.Current_Reviewer_Modified_Date__c = DateTime.now();
        objWC.WireAmount__c = 10001;
        objWC.Current_Reviewer__c = UserInfo.getUserId();
        objWC.Frequency__c = 'One - Time';
        objWC.Approval_Status__c = 'Released In WireXchange';
        objWC.Status__c = 'Declined';
        objWC.Source__c = 'Online Banking';
        objWC.Has_Additional_Documents__c = true;
        update objWC;

        List<AccountHistory> histList = new List<AccountHistory>();
        AccountHistory hist = new AccountHistory(Field = acc.Home_Phone__pc, AccountId = acc.Id);
        histList.add(hist);
    }

    static testMethod void test4(){
        SolarLoan_To_Episys_API_Details__c api = new SolarLoan_To_Episys_API_Details__c();
        api.URL__c = 'https://symxapi.chevronfcu.org/devclient';
        api.Name = 'ProductionURL';
        insert api;

        Member360_TypeTranslate__c t = new Member360_TypeTranslate__c();
        t.name = '0000/Primary';
        insert t;

        Profile p3 = [SELECT Id
                      FROM Profile
                      WHERE Name = 'CFCU Admin'];
        User u3 = new User(Alias = 'test122', Email = 'test1@test.com', EmailEncodingKey = 'UTF-8', LastName = 'Testing', LanguageLocaleKey = 'en_US', LocaleSidKey = 'en_US', ProfileId = p3.Id, TimeZoneSidKey = 'America/Los_Angeles', UserName = 'test122_Testing@test.com');
        insert u3;

        List<string> email3 = new List<string>();
        email3.add(u3.Email);

        Wires_Progress_Email_Test__c wpt = new Wires_Progress_Email_Test__c();
        wpt.Name = 'Test';
        wpt.Email__c = 'test@test.com';
        insert wpt;

        Wires_Docusign_Emails__c wde = new Wires_Docusign_Emails__c();
        wde.Name = 'Email For Testing';
        wde.Emails__c = 'Testing';
        insert wde;

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
        acc.PersonEmail = 'test1@test.com';
        acc.Work_Phone__pc = '555-469-3887';
        acc.Mobile_Phone__pc = '555-479-3885';
        update acc;

        Account_Details__c accDetail = new Account_Details__c();
        accDetail.Name = '00000000123';
        accDetail.RecType__c = 'ACCT';
        accDetail.TypeTranslate__c = '1-PERSONAL';
        accDetail.ID1__c = '001';
        accDetail.OPEN_DATE__c = Date.newInstance(2018, 12, 10);
        insert accDetail;

        List<Person_Account__c> person_obj = new List<Person_Account__c>{ new Person_Account__c(TypeTranslate__c = '0000/Primary', Account_Number__c = accDetail.Id, PersonID__c = acc.Id), new Person_Account__c(TypeTranslate__c = '0000/Primary', Account_Number__c = accDetail.Id, PersonID__c = acc.Id) };
        Insert person_obj;

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

        WIRES_Transaction__c WTIds = new WIRES_Transaction__c();
        WTIds.Member__c = acc.id;
        WTIds.Source__c = 'Online Banking';
        WTIds.WireAmount__c = 4000;
        WTIds.Frequency__c = 'One - Time';
        insert WTIds;

        WIRES_Transaction__c WTIds1 = new WIRES_Transaction__c();
        WTIds1.Member__c = acc.id;
        WTIds1.Source__c = 'Online Banking';
        WTIds1.WireAmount__c = 6000;
        WTIds1.Frequency__c = 'One - Time';
        insert WTIds1;

        WIRES_Transaction__c WTIds2 = new WIRES_Transaction__c();
        WTIds2.Member__c = acc.id;
        WTIds2.Source__c = 'Online Banking';
        WTIds2.WireAmount__c = 12000;
        WTIds2.Frequency__c = 'One - Time';
        insert WTIds2;
        WIRES_Transaction__c WTIds3 = new WIRES_Transaction__c();
        WTIds3.Member__c = acc.id;
        WTIds3.Source__c = 'Branch';
        WTIds3.WireAmount__c = 12000;
        WTIds3.Frequency__c = 'One - Time';
        insert WTIds3;
    }

}