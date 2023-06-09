@isTest
private class ManualMemberMergeProcessTest{
    static testMethod void MergeMemberAccountTest(){

        Create_SLA__c cl = new Create_SLA__c();
        cl.Status__c = 'Open';
        cl.Name = 'Open';
        cl.hours__c = 8;
        insert cl;

        Create_SLA__c cl1 = new Create_SLA__c();
        cl1.Status__c = 'In Process';
        cl1.Name = 'In Process';
        cl1.hours__c = 20;
        insert cl1;

        Create_SLA__c cl2 = new Create_SLA__c();
        cl2.Status__c = 'Resolution';
        cl2.Name = 'Resolution';
        cl2.hours__c = 20;
        insert cl2;

        MemberConversionSetting__c mcs = new MemberConversionSetting__c();

        mcs.Automation__c = 10;
        mcs.Manual__c = 7;
        mcs.Unmerge__c = 10;
        mcs.Name = 'PrimaryRecord';
        mcs.ManualPreMember__c = 7;
        insert mcs;

        RecordType rec = [Select Name, Id
                          From RecordType
                          where sObjectType = 'Account' and isActive = true and Name = 'Person Account'];

        RecordType rec1 = [Select Name, Id
                           From RecordType
                           where sObjectType = 'Account' and isActive = true and Name = 'Pre Member'];

        List<Account_Details__c> listaccdetail = new List<Account_Details__c>();
        List<Account> listact = new List<Account>();
        List<Person_Account__c> listperacct = new List<Person_Account__c>();
        List<Opportunity> listopp = new List<Opportunity>();
        List<Case> listcase = new List<Case>();

        Account_Details__c accDetail = new Account_Details__c();
        accDetail.Name = 'Test';
        accDetail.RecType__c = 'ACCT';
        listaccdetail.add(accDetail);


        Account act = new Account();
        act.FirstName = 'Test';
        act.LastName = 'Test1';
        act.Email_raw__c = 'test@test.com';
        act.RecordtypeId = rec.Id;
        act.Residential_Street__pc = '11';
        act.BIRTH_DATE__pc = system.Today().addyears(-20);
        listact.add(act);

        Person_Account__c pa = new Person_Account__c();
        pa.PersonID__c = act.Id;
        pa.Account_Number__c = accDetail.Id;
        listperacct.add(pa);

        Account pact = new Account();
        pact.FirstName = 'Test';
        pact.LastName = 'Test1';
        pact.Email_raw__c = 'test@test.com';
        pact.RecordtypeId = rec1.Id;
        pact.Residential_Street__pc = '11';
        pact.BIRTH_DATE__pc = system.Today().addyears(-20);
        pact.NA_Eligibility__c = true;
        pact.NA_Eligibility__c = true;
        pact.NA_LEHS_Complete__c = true;
        pact.NA_LEHS_Update__c = system.Today();
        pact.NA_LEOM_Complete__c = true;
        pact.NA_LEOM_Update__c = system.Today();
        pact.NA_Opt_Out__c = false;
        pact.NA_Opt_Out_Date__c = system.Today();
        pact.NA_Opt_Out_Updated__c = system.Today();
        pact.NA_LEAV_Complete__c = true;
        pact.NA_LECF_Complete__c = true;
        pact.NA_LECP_Complete__c = true;
        pact.NA_LEEM_Complete__c = true;
        pact.NA_LEMD_Complete__c = true;
        pact.NA_LEMP_Complete__c = true;
        pact.NA_LEMQ_Complete__c = true;
        pact.NA_LEOL_Complete__c = true;
        pact.NA_LEPT_Complete__c = true;
        pact.NA_LESB_Complete__c = true;
        pact.NA_LESF_Complete__c = true;
        pact.NA_LEWS_Complete__c = true;

        listact.add(pact);

        Account act1 = new Account();
        act1.FirstName = 'Test1';
        act1.LastName = 'Test11';
        act1.Email_raw__c = 'test1@test.com';
        act1.RecordtypeId = rec.Id;
        act1.Residential_Street__pc = '11';
        act1.Mobile_Phone__pc = '989898';
        act1.Home_Phone__pc = '010101';
        act1.Work_Phone__pc = '787878';
        act1.BIRTH_DATE__pc = system.Today().addyears(-20);

        listact.add(act1);

        Account pact1 = new Account();
        pact1.FirstName = 'Test1';
        pact1.LastName = 'Test11';
        pact1.Email_raw__c = 'test1@test.com';
        pact1.RecordtypeId = rec1.Id;
        pact1.Residential_Street__pc = '11';
        pact1.BIRTH_DATE__pc = system.Today().addyears(-20);
        //insert pact1;
        listact.add(pact1);


        Account act2 = new Account();
        act2.FirstName = 'Test2';
        act2.LastName = 'Testl2';
        act2.Email_raw__c = 'test2@test.com';
        act2.RecordtypeId = rec.Id;
        act2.Residential_Street__pc = '11';
        act2.BIRTH_DATE__pc = system.Today().addyears(-20);
        act2.Residential_Zipocde__pc = '112233';
        act2.Mobile_Phone__pc = '989898';
        act2.Home_Phone__pc = '010101';
        act2.Work_Phone__pc = '787878';
        act2.NA_Eligibility__c = true;
        act2.NA_Eligibility__c = true;
        act2.NA_LEHS_Complete__c = true;
        act2.NA_LEHS_Update__c = system.Today();
        act2.NA_LEOM_Complete__c = true;
        act2.NA_LEOM_Update__c = system.Today();
        act2.NA_Opt_Out__c = false;
        act2.NA_Opt_Out_Date__c = system.Today();
        act2.NA_Opt_Out_Updated__c = system.Today();
        act2.NA_LEAV_Complete__c = true;
        act2.NA_LECF_Complete__c = true;
        act2.NA_LECP_Complete__c = true;
        act2.NA_LEEM_Complete__c = true;
        act2.NA_LEMD_Complete__c = true;
        act2.NA_LEMP_Complete__c = true;
        act2.NA_LEMQ_Complete__c = true;
        act2.NA_LEOL_Complete__c = true;
        act2.NA_LEPT_Complete__c = true;
        act2.NA_LESB_Complete__c = true;
        act2.NA_LESF_Complete__c = true;
        act2.NA_LEWS_Complete__c = true;

        listact.add(act2);


        Account pact2 = new Account();
        pact2.FirstName = 'Test2';
        pact2.LastName = 'Test2';
        pact2.Email_raw__c = 'test2@test.com';
        pact2.RecordtypeId = rec1.Id;
        pact2.Residential_Street__pc = '11';
        pact2.BIRTH_DATE__pc = system.Today().addyears(-20);
        pact2.Residential_Zipocde__pc = '112233';

        listact.add(pact2);
        Account pact3 = new Account();
        pact3.FirstName = 'Test3';
        pact3.LastName = 'Test3';
        pact3.Email_raw__c = 'test3@test.com';
        pact3.RecordtypeId = rec1.Id;
        pact3.Residential_Street__pc = '33';
        pact3.BIRTH_DATE__pc = system.Today().addyears(-20);
        pact3.Residential_Zipocde__pc = '112233';

        listact.add(pact3);
        Account pact4 = new Account();
        pact4.FirstName = 'Test3';
        pact4.LastName = 'Test3';
        pact4.Email_raw__c = 'test3@test.com';
        pact4.RecordtypeId = rec1.Id;
        pact4.Residential_Street__pc = '33';
        pact4.BIRTH_DATE__pc = system.Today().addyears(-20);
        pact4.Residential_Zipocde__pc = '112233';
        pact4.Mobile_Phone__pc = '989898';
        pact4.Home_Phone__pc = '010101';
        pact4.Work_Phone__pc = '787878';
        pact4.NA_Eligibility__c = true;
        pact4.NA_Eligibility__c = true;
        pact4.NA_LEHS_Complete__c = true;
        pact4.NA_LEHS_Update__c = system.Today();
        pact4.NA_LEOM_Complete__c = true;
        pact4.NA_LEOM_Update__c = system.Today();
        pact4.NA_Opt_Out__c = false;
        pact4.NA_Opt_Out_Date__c = system.Today();
        pact4.NA_Opt_Out_Updated__c = system.Today();
        pact4.NA_LEAV_Complete__c = true;
        pact4.NA_LECF_Complete__c = true;
        pact4.NA_LECP_Complete__c = true;
        pact4.NA_LEEM_Complete__c = true;
        pact4.NA_LEMD_Complete__c = true;
        pact4.NA_LEMP_Complete__c = true;
        pact4.NA_LEMQ_Complete__c = true;
        pact4.NA_LEOL_Complete__c = true;
        pact4.NA_LEPT_Complete__c = true;
        pact4.NA_LESB_Complete__c = true;
        pact4.NA_LESF_Complete__c = true;
        pact4.NA_LEWS_Complete__c = true;

        listact.add(pact4);
        Account pact5 = new Account();
        pact5.FirstName = 'Test3';
        pact5.LastName = 'Test3';
        pact5.Email_raw__c = 'test3@test.com';
        pact5.RecordtypeId = rec1.Id;
        pact5.Residential_Street__pc = '33';
        pact5.BIRTH_DATE__pc = system.Today().addyears(-2);
        pact5.Residential_Zipocde__pc = '112233';
        pact5.Mobile_Phone__pc = '989898';
        pact5.Home_Phone__pc = '010101';
        pact5.Work_Phone__pc = '787878';
        pact5.NA_Eligibility__c = true;
        pact5.NA_Eligibility__c = true;
        pact5.NA_LEHS_Complete__c = true;
        pact5.NA_LEHS_Update__c = system.Today();
        pact5.NA_LEOM_Complete__c = true;
        pact5.NA_LEOM_Update__c = system.Today();
        pact5.NA_Opt_Out__c = false;
        pact5.NA_Opt_Out_Date__c = system.Today();
        pact5.NA_Opt_Out_Updated__c = system.Today();
        pact5.NA_LEAV_Complete__c = true;


        listact.add(pact5);
        Account_Details__c account_details_Obj = new Account_Details__c(Onboarded__c = false, RecType__c = 'ACCT', TypeTranslate__c = '2-TRUST');

        listaccdetail.add(account_details_Obj);
        Person_Account__c person_account_Obj = new Person_Account__c(Account_Number__c = account_details_Obj.id, PersonID__c = pact4.id, Relationship__c = null, TypeTranslate__c = '0000/Primary');

        listperacct.add(person_account_Obj);


        opportunity opp = new Opportunity();
        opp.Accountid = pact4.id;
        opp.Name = 'Name';
        opp.StageName = 'Closed Won';
        opp.CloseDate = system.today();
        opp.Is_Converted__c = true;
        opp.Opportunity_Source__c = 'Word of mouth';


        listopp.add(opp);

        opportunity opp1 = new Opportunity();
        opp1.Accountid = pact.id;
        opp1.Name = 'Name';
        opp1.StageName = 'Closed Won';
        opp1.CloseDate = system.today();
        opp1.Is_Converted__c = true;
        opp1.Opportunity_Source__c = 'Word of mouth';
        listopp.add(opp1);

        Case cas = new Case();
        cas.Accountid = pact4.id;
        cas.Brand__c = 'Chevron';

        listcase.add(cas);
        Case cas1 = new Case();
        cas1.Accountid = pact.id;
        cas1.Brand__c = 'Chevron';

        listcase.add(cas1);


        Test.startTest();
        insert listact;
        insert listaccdetail;
        insert listperacct;
        insert listopp;
        insert listcase;


        Set<ID> pactid = new Set<Id>();
        pactid.add(pact.id);
        pactid.add(pact1.id);
        pactid.add(pact2.id);
        pactid.add(pact3.id);
        pactid.add(pact4.id);
        pactid.add(pact5.id);
        List<Account> PreMemberAccount = [SELECT Id, PersonEmail, Email_raw__c, Alt_Email_Raw__c, FirstName, MiddleName, LastName, Name, Salutation, Suffix, Phone_Check__c, Mobile_Phone__pc, Residential_Street__pc, RecordType.Name, Residential_City__pc, Residential_State__pc, Residential_Zipocde__pc, Residential_Extra_Address__pc, createddate
                                          FROM Account
                                          where RecordType.Name = 'Pre Member' and IsConverted__c = false and id IN:pactid];


        ManualMemberMergeProcess.GetMemberAccountDetail(act1.id);
        ManualMemberMergeProcess.GetMemberAccountDetail(act2.id);
        ManualMemberMergeProcess.GetMemberList('My Members');
        ManualMemberMergeProcess.GetMemberList('My Team Members');
        Test.stopTest();
        ManualMemberMergeProcess.GetMemberList('All Members');

        UnmergeMemberProcess.GetMemberList();
    }

    static testMethod void MergeMemberAccountTest1(){

        SolarLoan_To_Episys_API_Details__c api = new SolarLoan_To_Episys_API_Details__c();
        api.URL__c = 'https://symxapi.chevronfcu.org/devclient';
        api.Name = 'ProductionURL';
        insert api;

        Create_SLA__c cl = new Create_SLA__c();
        cl.Status__c = 'Open';
        cl.Name = 'Open';
        cl.hours__c = 8;
        insert cl;

        Create_SLA__c cl1 = new Create_SLA__c();
        cl1.Status__c = 'In Process';
        cl1.Name = 'In Process';
        cl1.hours__c = 20;
        insert cl1;

        Create_SLA__c cl2 = new Create_SLA__c();
        cl2.Status__c = 'Resolution';
        cl2.Name = 'Resolution';
        cl2.hours__c = 20;
        insert cl2;

        List<Account> listact1 = new List<Account>();
        List<Account_Details__c> listaccdetail = new List<Account_Details__c>();
        List<Person_Account__c> listperacct = new List<Person_Account__c>();
        List<Opportunity> listopp = new List<Opportunity>();
        List<Case> listcase = new List<Case>();

        MemberConversionSetting__c mcs = new MemberConversionSetting__c();

        mcs.Automation__c = 10;
        mcs.Manual__c = 10;
        mcs.Unmerge__c = 10;
        mcs.Name = 'PrimaryRecord';
        insert mcs;

        RecordType rec = [Select Name, Id
                          From RecordType
                          where sObjectType = 'Account' and isActive = true and Name = 'Person Account'];

        RecordType rec1 = [Select Name, Id
                           From RecordType
                           where sObjectType = 'Account' and isActive = true and Name = 'Pre Member'];

        Account act = new Account();
        act.FirstName = 'Test';
        act.LastName = 'Test1';
        act.Email_raw__c = 'test@test.com';
        act.RecordtypeId = rec.Id;
        act.Residential_Street__pc = '11';
        act.BIRTH_DATE__pc = system.Today().addyears(-20);

        listact1.add(act);

        Account pact = new Account();
        pact.FirstName = 'Test';
        pact.LastName = 'Test1';
        pact.Email_raw__c = 'test@test.com';
        pact.RecordtypeId = rec1.Id;
        pact.Residential_Street__pc = '11';
        pact.BIRTH_DATE__pc = system.Today().addyears(-20);
        pact.NA_Eligibility__c = true;
        pact.NA_Eligibility__c = true;
        pact.NA_LEHS_Complete__c = true;
        pact.NA_LEHS_Update__c = system.Today();
        pact.NA_LEOM_Complete__c = true;
        pact.NA_LEOM_Update__c = system.Today();
        pact.NA_Opt_Out__c = false;
        pact.NA_Opt_Out_Date__c = system.Today();
        pact.NA_Opt_Out_Updated__c = system.Today();
        pact.NA_LEAV_Complete__c = true;
        pact.NA_LECF_Complete__c = true;
        pact.NA_LECP_Complete__c = true;
        pact.NA_LEEM_Complete__c = true;
        pact.NA_LEMD_Complete__c = true;
        pact.NA_LEMP_Complete__c = true;
        pact.NA_LEMQ_Complete__c = true;
        pact.NA_LEOL_Complete__c = true;
        pact.NA_LEPT_Complete__c = true;
        pact.NA_LESB_Complete__c = true;
        pact.NA_LESF_Complete__c = true;
        pact.NA_LEWS_Complete__c = true;

        listact1.add(pact);

        Account act1 = new Account();
        act1.FirstName = 'Test1';
        act1.LastName = 'Test11';
        act1.Email_raw__c = 'test1@test.com';
        act1.RecordtypeId = rec.Id;
        act1.Residential_Street__pc = '11';
        act1.Mobile_Phone__pc = '989898';
        act1.Home_Phone__pc = '010101';
        act1.Work_Phone__pc = '787878';
        act1.BIRTH_DATE__pc = system.Today().addyears(-20);

        listact1.add(act1);

        Account pact1 = new Account();
        pact1.FirstName = 'Test1';
        pact1.LastName = 'Test11';
        pact1.Email_raw__c = 'test1@test.com';
        pact1.RecordtypeId = rec1.Id;
        pact1.Residential_Street__pc = '11';
        pact1.BIRTH_DATE__pc = system.Today().addyears(-20);

        listact1.add(pact1);

        Account act2 = new Account();
        act2.FirstName = 'Test2';
        act2.LastName = 'Testl2';
        act2.Email_raw__c = 'test2@test.com';
        act2.RecordtypeId = rec.Id;
        act2.Residential_Street__pc = '11';
        act2.BIRTH_DATE__pc = system.Today().addyears(-20);
        act2.Residential_Zipocde__pc = '112233';
        act2.Mobile_Phone__pc = '989898';
        act2.Home_Phone__pc = '010101';
        act2.Work_Phone__pc = '787878';
        act2.NA_Eligibility__c = true;
        act2.NA_Eligibility__c = true;
        act2.NA_LEHS_Complete__c = true;
        act2.NA_LEHS_Update__c = system.Today();
        act2.NA_LEOM_Complete__c = true;
        act2.NA_LEOM_Update__c = system.Today();
        act2.NA_Opt_Out__c = false;
        act2.NA_Opt_Out_Date__c = system.Today();
        act2.NA_Opt_Out_Updated__c = system.Today();
        act2.NA_LEAV_Complete__c = true;
        act2.NA_LECF_Complete__c = true;
        act2.NA_LECP_Complete__c = true;
        act2.NA_LEEM_Complete__c = true;
        act2.NA_LEMD_Complete__c = true;
        act2.NA_LEMP_Complete__c = true;
        act2.NA_LEMQ_Complete__c = true;
        act2.NA_LEOL_Complete__c = true;
        act2.NA_LEPT_Complete__c = true;
        act2.NA_LESB_Complete__c = true;
        act2.NA_LESF_Complete__c = true;
        act2.NA_LEWS_Complete__c = true;

        listact1.add(act2);

        Account pact2 = new Account();
        pact2.FirstName = 'Test2';
        pact2.LastName = 'Test2';
        pact2.Email_raw__c = 'test2@test.com';
        pact2.RecordtypeId = rec1.Id;
        pact2.Residential_Street__pc = '11';
        pact2.BIRTH_DATE__pc = system.Today().addyears(-20);
        pact2.Residential_Zipocde__pc = '112233';

        listact1.add(pact2);
        Account pact3 = new Account();
        pact3.FirstName = 'Test3';
        pact3.LastName = 'Test3';
        pact3.Email_raw__c = 'test3@test.com';
        pact3.RecordtypeId = rec1.Id;
        pact3.Residential_Street__pc = '33';
        pact3.BIRTH_DATE__pc = system.Today().addyears(-20);
        pact3.Residential_Zipocde__pc = '112233';

        listact1.add(pact3);

        Account pact4 = new Account();
        pact4.FirstName = 'Test3';
        pact4.LastName = 'Test3';
        pact4.Email_raw__c = 'test3@test.com';
        pact4.RecordtypeId = rec1.Id;
        pact4.Residential_Street__pc = '33';
        pact4.BIRTH_DATE__pc = system.Today().addyears(-20);
        pact4.Residential_Zipocde__pc = '112233';
        pact4.Mobile_Phone__pc = '989898';
        pact4.Home_Phone__pc = '010101';
        pact4.Work_Phone__pc = '787878';
        pact4.NA_Eligibility__c = true;
        pact4.NA_Eligibility__c = true;
        pact4.NA_LEHS_Complete__c = true;
        pact4.NA_LEHS_Update__c = system.Today();
        pact4.NA_LEOM_Complete__c = true;
        pact4.NA_LEOM_Update__c = system.Today();
        pact4.NA_Opt_Out__c = false;
        pact4.NA_Opt_Out_Date__c = system.Today();
        pact4.NA_Opt_Out_Updated__c = system.Today();
        pact4.NA_LEAV_Complete__c = true;
        pact4.NA_LECF_Complete__c = true;
        pact4.NA_LECP_Complete__c = true;
        pact4.NA_LEEM_Complete__c = true;
        pact4.NA_LEMD_Complete__c = true;
        pact4.NA_LEMP_Complete__c = true;
        pact4.NA_LEMQ_Complete__c = true;
        pact4.NA_LEOL_Complete__c = true;
        pact4.NA_LEPT_Complete__c = true;
        pact4.NA_LESB_Complete__c = true;
        pact4.NA_LESF_Complete__c = true;
        pact4.NA_LEWS_Complete__c = true;

        listact1.add(pact4);

        Account pact5 = new Account();
        pact5.FirstName = 'Test3';
        pact5.LastName = 'Test3';
        pact5.Email_raw__c = 'test3@test.com';
        pact5.RecordtypeId = rec1.Id;
        pact5.Residential_Street__pc = '33';
        pact5.BIRTH_DATE__pc = system.Today().addyears(-2);
        pact5.Residential_Zipocde__pc = '112233';
        pact5.Mobile_Phone__pc = '989898';
        pact5.Home_Phone__pc = '010101';
        pact5.Work_Phone__pc = '787878';
        pact5.NA_Eligibility__c = true;
        pact5.NA_Eligibility__c = true;
        pact5.NA_LEHS_Complete__c = true;
        pact5.NA_LEHS_Update__c = system.Today();
        pact5.NA_LEOM_Complete__c = true;
        pact5.NA_LEOM_Update__c = system.Today();
        pact5.NA_Opt_Out__c = false;
        pact5.NA_Opt_Out_Date__c = system.Today();
        pact5.NA_Opt_Out_Updated__c = system.Today();
        pact5.NA_LEAV_Complete__c = true;

        listact1.add(pact5);

        Account_Details__c account_details_Obj1 = new Account_Details__c(Onboarded__c = false, RecType__c = 'ACCT', TypeTranslate__c = '2-TRUST');
        listaccdetail.add(account_details_Obj1);

        Person_Account__c person_account_Obj1 = new Person_Account__c(Account_Number__c = account_details_Obj1.id, PersonID__c = pact.id, Relationship__c = null, TypeTranslate__c = '0000/Primary');
        listperacct.add(person_account_Obj1);


        opportunity opp = new Opportunity();
        opp.Accountid = pact4.id;
        opp.Name = 'Name';
        opp.StageName = 'Closed Won';
        opp.CloseDate = system.today();
        opp.Is_Converted__c = true;
        opp.Opportunity_Source__c = 'Word of mouth';

        listopp.add(opp);

        opportunity opp1 = new Opportunity();
        opp1.Accountid = pact.id;
        opp1.Name = 'Name';
        opp1.StageName = 'Closed Won';
        opp1.CloseDate = system.today();
        opp1.Is_Converted__c = true;
        opp1.Opportunity_Source__c = 'Word of mouth';

        listopp.add(opp1);

        Case cas = new Case();
        cas.Accountid = pact4.id;
        cas.Brand__c = 'Chevron';

        listcase.add(cas);

        Case cas1 = new Case();
        cas1.Accountid = pact.id;
        cas1.Brand__c = 'Chevron';

        listcase.add(cas1);


        Test.startTest();
        insert listact1;
        insert listaccdetail;
        insert listperacct;
        insert listopp;
        insert listcase;

        ManualMemberMergeProcess.MergeMemberAccount(act.id, pact.id);
        UnmergeMemberProcess.UnMergeMemberAccount(act.id);

        Test.stopTest();
    }

    static testMethod void MergeMemberAccountTestPhone(){

     

        List<Account> listact = new List<Account>();
        List<Account_Details__c> listaccdetail = new List<Account_Details__c>();
        List<Person_Account__c> listperacct = new List<Person_Account__c>();
        List<Opportunity> listopp = new List<Opportunity>();
        List<Case> listcase = new List<Case>();

        MemberConversionSetting__c mcs = new MemberConversionSetting__c();
        mcs.Automation__c = 10;
        mcs.Manual__c = 10;
        mcs.Name = 'PrimaryRecord';
        mcs.ManualPreMember__c = 7;
        insert mcs;

        RecordType rec = [Select Name, Id
                          From RecordType
                          where sObjectType = 'Account' and isActive = true and Name = 'Person Account'];

        RecordType rec1 = [Select Name, Id
                           From RecordType
                           where sObjectType = 'Account' and isActive = true and Name = 'Pre Member'];

        Account act = new Account();
        act.FirstName = 'Test';
        act.LastName = 'Test1';
        act.Email_raw__c = 'test@test.com';
        act.RecordtypeId = rec.Id;
        act.Residential_Street__pc = '11';
        act.BIRTH_DATE__pc = system.Today().addyears(-20);

        listact.add(act);

        Account pact = new Account();
        pact.FirstName = 'Test';
        pact.LastName = 'Test1';
        pact.Email_raw__c = 'test@test.com';
        pact.RecordtypeId = rec1.Id;
        pact.Residential_Street__pc = '11';
        pact.BIRTH_DATE__pc = system.Today().addyears(-20);
        pact.NA_Eligibility__c = true;
        pact.NA_Eligibility__c = true;
        pact.NA_LEHS_Complete__c = true;
        pact.NA_LEHS_Update__c = system.Today();
        pact.NA_LEOM_Complete__c = true;
        pact.NA_LEOM_Update__c = system.Today();
        pact.NA_Opt_Out__c = false;
        pact.NA_Opt_Out_Date__c = system.Today();
        pact.NA_Opt_Out_Updated__c = system.Today();
        pact.NA_LEAV_Complete__c = true;
        pact.NA_LECF_Complete__c = true;
        pact.NA_LECP_Complete__c = true;
        pact.NA_LEEM_Complete__c = true;
        pact.NA_LEMD_Complete__c = true;
        pact.NA_LEMP_Complete__c = true;
        pact.NA_LEMQ_Complete__c = true;
        pact.NA_LEOL_Complete__c = true;
        pact.NA_LEPT_Complete__c = true;
        pact.NA_LESB_Complete__c = true;
        pact.NA_LESF_Complete__c = true;
        pact.NA_LEWS_Complete__c = true;

        listact.add(pact);

        Account act1 = new Account();
        act1.FirstName = 'Test1';
        act1.LastName = 'Test11';
        act1.Email_raw__c = 'test1@test.com';
        act1.RecordtypeId = rec.Id;
        act1.Residential_Street__pc = '11';
        act1.Mobile_Phone__pc = '989898';
        act1.Home_Phone__pc = '010101';
        act1.Work_Phone__pc = '787878';
        act1.BIRTH_DATE__pc = system.Today().addyears(-20);

        listact.add(act1);

        Account act2 = new Account();
        act2.FirstName = 'Test2';
        act2.LastName = 'Testl2';
        act2.Email_raw__c = 'test2@test.com';
        act2.RecordtypeId = rec.Id;
        act2.Residential_Street__pc = '11';
        act2.BIRTH_DATE__pc = system.Today().addyears(-20);
        act2.Residential_Zipocde__pc = '112233';
        act2.Mobile_Phone__pc = '989898';
        act2.Home_Phone__pc = '010101';
        act2.Work_Phone__pc = '787878';
        act2.NA_Eligibility__c = true;
        act2.NA_Eligibility__c = true;
        act2.NA_LEHS_Complete__c = true;
        act2.NA_LEHS_Update__c = system.Today();
        act2.NA_LEOM_Complete__c = true;
        act2.NA_LEOM_Update__c = system.Today();
        act2.NA_Opt_Out__c = false;
        act2.NA_Opt_Out_Date__c = system.Today();
        act2.NA_Opt_Out_Updated__c = system.Today();
        act2.NA_LEAV_Complete__c = true;
        act2.NA_LECF_Complete__c = true;
        act2.NA_LECP_Complete__c = true;
        act2.NA_LEEM_Complete__c = true;
        act2.NA_LEMD_Complete__c = true;
        act2.NA_LEMP_Complete__c = true;
        act2.NA_LEMQ_Complete__c = true;
        act2.NA_LEOL_Complete__c = true;
        act2.NA_LEPT_Complete__c = true;
        act2.NA_LESB_Complete__c = true;
        act2.NA_LESF_Complete__c = true;
        act2.NA_LEWS_Complete__c = true;

        listact.add(act2);

        Account pact4 = new Account();
        pact4.FirstName = 'Test3';
        pact4.LastName = 'Test3';
        pact4.Email_raw__c = 'test3@test.com';
        pact4.RecordtypeId = rec1.Id;
        pact4.Residential_Street__pc = '33';
        pact4.BIRTH_DATE__pc = system.Today().addyears(-20);
        pact4.Residential_Zipocde__pc = '112233';
        pact4.Mobile_Phone__pc = '';
        pact4.Home_Phone__pc = '989898';
        pact4.Work_Phone__pc = '';
        pact4.NA_Eligibility__c = true;
        pact4.NA_Eligibility__c = true;
        pact4.NA_LEHS_Complete__c = true;
        pact4.NA_LEHS_Update__c = system.Today();
        pact4.NA_LEOM_Complete__c = true;
        pact4.NA_LEOM_Update__c = system.Today();
        pact4.NA_Opt_Out__c = false;
        pact4.NA_Opt_Out_Date__c = system.Today();
        pact4.NA_Opt_Out_Updated__c = system.Today();
        pact4.NA_LEAV_Complete__c = true;
        pact4.NA_LECF_Complete__c = true;
        pact4.NA_LECP_Complete__c = true;
        pact4.NA_LEEM_Complete__c = true;
        pact4.NA_LEMD_Complete__c = true;
        pact4.NA_LEMP_Complete__c = true;
        pact4.NA_LEMQ_Complete__c = true;
        pact4.NA_LEOL_Complete__c = true;
        pact4.NA_LEPT_Complete__c = true;
        pact4.NA_LESB_Complete__c = true;
        pact4.NA_LESF_Complete__c = true;
        pact4.NA_LEWS_Complete__c = true;

        listact.add(pact4);

        Account pact5 = new Account();
        pact5.FirstName = 'Test3';
        pact5.LastName = 'Test3';
        pact5.Email_raw__c = 'test3@test.com';
        pact5.RecordtypeId = rec1.Id;
        pact5.Residential_Street__pc = '33';
        pact5.BIRTH_DATE__pc = system.Today().addyears(-20);
        pact5.Residential_Zipocde__pc = '112233';
        pact5.Mobile_Phone__pc = '';
        pact5.Home_Phone__pc = '';
        pact5.Work_Phone__pc = '787878';
        pact5.NA_Eligibility__c = true;
        pact5.NA_Eligibility__c = true;
        pact5.NA_LEHS_Complete__c = true;
        pact5.NA_LEHS_Update__c = system.Today();
        pact5.NA_LEOM_Complete__c = true;
        pact5.NA_LEOM_Update__c = system.Today();
        pact5.NA_Opt_Out__c = false;
        pact5.NA_Opt_Out_Date__c = system.Today();
        pact5.NA_Opt_Out_Updated__c = system.Today();
        pact5.NA_LEAV_Complete__c = true;
        listact.add(pact5);

        Account_Details__c account_details_Obj = new Account_Details__c(Onboarded__c = false, RecType__c = 'ACCT', TypeTranslate__c = 'TRUST', Created_At_Branch__c = 304);

        listaccdetail.add(account_details_Obj);

        Person_Account__c person_account_Obj = new Person_Account__c(Account_Number__c = account_details_Obj.id, PersonID__c = act.id, Relationship__c = null, TypeTranslate__c = '0000/PRIMARY');

        listperacct.add(person_account_Obj);

        Account_Details__c account_details_Obj1 = new Account_Details__c(Onboarded__c = false, RecType__c = 'ACCT', TypeTranslate__c = '2-TRUST');

        listaccdetail.add(account_details_Obj1);

        Person_Account__c person_account_Obj1 = new Person_Account__c(Account_Number__c = account_details_Obj1.id, PersonID__c = pact.id, Relationship__c = null, TypeTranslate__c = '0000/Primary');

        listperacct.add(person_account_Obj1);

        opportunity opp = new Opportunity();
        opp.Accountid = pact4.id;
        opp.Name = 'Name';
        opp.StageName = 'Closed Won';
        opp.CloseDate = system.today();
        opp.Is_Converted__c = true;
        opp.Opportunity_Source__c = 'Word of mouth';

        listopp.add(opp);

        opportunity opp1 = new Opportunity();
        opp1.Accountid = pact.id;
        opp1.Name = 'Name';
        opp1.StageName = 'Closed Won';
        opp1.CloseDate = system.today();
        opp1.Is_Converted__c = true;
        opp1.Opportunity_Source__c = 'Word of mouth';

        listopp.add(opp1);
        Test.startTest();
        insert listact;
        insert listaccdetail;
        insert listperacct;
        insert listopp;

        ManualMemberMergeProcess.MergeMemberAccount(act2.id, pact4.id);
        ManualMemberMergeProcess.MergeMemberAccount(act.id, pact.id);

        Set<ID> pactid = new Set<Id>();
        pactid.add(pact.id);
        pactid.add(pact4.id);
        pactid.add(pact5.id);
        List<Account> PreMemberAccount = [SELECT Id, PersonEmail, Email_raw__c, Alt_Email_Raw__c, FirstName, MiddleName, LastName, Name, Salutation, Suffix, Phone_Check__c, Mobile_Phone__pc, Residential_Street__pc, RecordType.Name, Residential_City__pc, Residential_State__pc, Residential_Zipocde__pc, Residential_Extra_Address__pc, createddate
                                          FROM Account
                                          where RecordType.Name = 'Pre Member' and IsConverted__c = false and id IN:pactid];


        ManualMemberMergeProcess.GetMemberAccountDetail(act1.id);
        ManualMemberMergeProcess.GetMemberAccountDetail(act2.id);
        Test.stopTest();
        ManualMemberMergeProcess.GetMemberList('My Team Members');
        ManualMemberMergeProcess.GetMemberList('All Members');
    }

}