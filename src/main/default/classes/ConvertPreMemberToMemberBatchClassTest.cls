@isTest
public class ConvertPreMemberToMemberBatchClassTest {
	
    static testmethod void testmethod1() {
	
        RecordType objRecordType = [SELECT Id,Name FROM RecordType WHERE Name='MemberShip'];
        RecordType objRecordType1 = [SELECT Id,Name FROM RecordType WHERE Name='Person Account'];
        RecordType rec1 = [Select Name, Id From RecordType where sObjectType='Account' and isActive=true and Name='Pre Member'];
        
        MemberConversionSetting__c mcs = new MemberConversionSetting__c();
        mcs.Name = 'PrimaryRecord';
        mcs.Manual__c = 10;
        mcs.Automation__c = 8;
        mcs.Unmerge__c = 10;
        mcs.Member_Matching_Cut_off_Date__c = Date.newInstance(2018, 10, 2);
        mcs.Not_matched_Members_cut_off_window__c = 3;
        insert mcs;
            
		Account_Details__c  act = new Account_Details__c(Name = '0000147163', Balance__c = 0.00, Combined_Account_ID__c = '0000147163S0100P0100', ID1__c = '0100', Onboarded__c = true, RecType__c = 'ACCT', TypeTranslate__c = '1-PRIMARY SHARE', RecordType = objRecordType);
		Insert act;
		
		Account_Details__c  act1 = new Account_Details__c(Name = '0000147163', Balance__c = 0.00, Combined_Account_ID__c = '0000147163S0100P0100', ID1__c = '0100', Onboarded__c = true, RecType__c = 'SHAR', TypeTranslate__c = '1-PRIMARY SHARE', RecordType = objRecordType1, Parent_Account__c = act.Id);
		Insert act1;
		
		
		List<Account> account_Obj = new List<Account>{new Account(LastName = 'Test1', FirstName = 'Test', Type = 'null', Member_Verification_OTP_Invalid_Attempt__c = system.now(), Home_Phone__pc = '123456333390', Mobile_Phone__pc = '258963147852', Work_Phone__pc = '233333232323', Email_raw__c = 'test1@test.com', PersonEmail = 'test1@test.com',Alt_Email_Raw__c ='ab1c@abc.com',  Alternate_Email__pc = 'abc@abc.com')};
		      												
    	Account pact = new Account();
        pact.FirstName = 'Test';
        pact.LastName = 'Test1';
        pact.Email_raw__c = 'test@test.com';
        pact.PersonEmail = 'test1@test.com';
        pact.Home_Phone__pc = '123456333390';
        pact.Work_Phone__pc = '233336232323';
        pact.Mobile_Phone__pc = '258663147852'; 
        pact.RecordtypeId = rec1.Id;
        pact.Residential_Street__pc ='34567';
        pact.BIRTH_DATE__pc = system.Today().addyears(-20);
        pact.NA_Eligibility__c = true;
        pact.NA_Eligibility__c= true;
		pact.NA_LEHS_Complete__c= true;
		pact.NA_LEHS_Update__c= system.Today(); 
		pact.NA_LEOM_Complete__c= true;
		pact.NA_LEOM_Update__c= system.Today();
		pact.NA_Opt_Out__c= false;
		pact.NA_Opt_Out_Date__c= system.Today();
		pact.NA_Opt_Out_Updated__c= system.Today();
		pact.NA_LEAV_Complete__c= true;
		pact.NA_LECF_Complete__c= true;
		pact.NA_LECP_Complete__c= true;
		pact.NA_LEEM_Complete__c= true;
		pact.NA_LEMD_Complete__c= true;
		pact.NA_LEMP_Complete__c= true;
		pact.NA_LEMQ_Complete__c= true;
		pact.NA_LEOL_Complete__c= true;
		pact.NA_LEPT_Complete__c= true;
		pact.NA_LESB_Complete__c= true;
		pact.NA_LESF_Complete__c= true;
		pact.NA_LEWS_Complete__c= true;
        account_Obj.add(pact);
        
        Insert account_Obj;
        
        List<Person_Account__c> person_obj= new List<Person_Account__c>{new Person_Account__c(Account_Number__c = act.Id, PersonID__c = account_Obj[0].Id), new Person_Account__c(Account_Number__c = act1.Id, PersonID__c = account_Obj[1].Id)};
		     Insert person_obj;
        
        
        Test.startTest();
        ConvertPreMemberToMemberBatchClass a = new ConvertPreMemberToMemberBatchClass();
        Database.executeBatch(a);
        Test.stopTest();
      
    }
    static testmethod void testmethod2() {
	
        RecordType objRecordType = [SELECT Id,Name FROM RecordType WHERE Name='MemberShip'];
        RecordType objRecordType1 = [SELECT Id,Name FROM RecordType WHERE Name='Person Account'];
        RecordType rec1 = [Select Name, Id From RecordType where sObjectType='Account' and isActive=true and Name='Pre Member'];
        
        MemberConversionSetting__c mcs = new MemberConversionSetting__c();
        mcs.Name = 'PrimaryRecord';
        mcs.Manual__c = 10;
        mcs.Automation__c = 8;
        mcs.Unmerge__c = 10;
        mcs.Member_Matching_Cut_off_Date__c = Date.newInstance(2018, 10, 2);
        mcs.Not_matched_Members_cut_off_window__c = 3;
        insert mcs;
            
		Account_Details__c  act = new Account_Details__c(Name = '0000147163', Balance__c = 0.00, Combined_Account_ID__c = '0000147163S0100P0100', ID1__c = '0100', Onboarded__c = true, RecType__c = 'ACCT', TypeTranslate__c = '1-PRIMARY SHARE', RecordType = objRecordType);
		Insert act;
		
		Account_Details__c  act1 = new Account_Details__c(Name = '0000147163', Balance__c = 0.00, Combined_Account_ID__c = '0000147163S0100P0100', ID1__c = '0100', Onboarded__c = true, RecType__c = 'SHAR', TypeTranslate__c = '1-PRIMARY SHARE', RecordType = objRecordType1, Parent_Account__c = act.Id);
		Insert act1;
		
		
		List<Account> account_Obj = new List<Account>{new Account(LastName = 'Test', FirstName = 'Test', Type = 'null', Member_Verification_OTP_Invalid_Attempt__c = system.now(), Home_Phone__pc = '9252066277', Mobile_Phone__pc = '9252066277', Work_Phone__pc = '9252066277', Email_raw__c = 'test1@test.com', PersonEmail = 'test1@test.com',Alt_Email_Raw__c ='ab1c@abc.com',Residential_Street__pc = 'res',Residential_Zipocde__pc = '23456',  Alternate_Email__pc = 'abc@abc.com')};
		      												
    	Account pact = new Account();
        pact.FirstName = 'Test';
        pact.LastName = 'Test1';
        pact.Email_raw__c = 'test@test.com';
        pact.PersonEmail = 'test1@test.com';
        pact.Home_Phone__pc = '9252066277';
        pact.Work_Phone__pc = '9252066277';
        pact.Mobile_Phone__pc = '9252066277'; 
        pact.RecordtypeId = rec1.Id;
        pact.Residential_Street__pc ='res';
        pact.Residential_Zipocde__pc = '23567';
        pact.BIRTH_DATE__pc = system.Today().addyears(-20);
        pact.NA_Eligibility__c = true;
        pact.NA_Eligibility__c= true;
		pact.NA_LEHS_Complete__c= true;
		pact.NA_LEHS_Update__c= system.Today(); 
		pact.NA_LEOM_Complete__c= true;
		pact.NA_LEOM_Update__c= system.Today();
		pact.NA_Opt_Out__c= false;
		pact.NA_Opt_Out_Date__c= system.Today();
		pact.NA_Opt_Out_Updated__c= system.Today();
		pact.NA_LEAV_Complete__c= true;
		pact.NA_LECF_Complete__c= true;
		pact.NA_LECP_Complete__c= true;
		pact.NA_LEEM_Complete__c= true;
		pact.NA_LEMD_Complete__c= true;
		pact.NA_LEMP_Complete__c= true;
		pact.NA_LEMQ_Complete__c= true;
		pact.NA_LEOL_Complete__c= true;
		pact.NA_LEPT_Complete__c= true;
		pact.NA_LESB_Complete__c= true;
		pact.NA_LESF_Complete__c= true;
		pact.NA_LEWS_Complete__c= true;
        account_Obj.add(pact);
        
        Insert account_Obj;
        
        List<Person_Account__c> person_obj= new List<Person_Account__c>{new Person_Account__c(Account_Number__c = act.Id, PersonID__c = account_Obj[0].Id), new Person_Account__c(Account_Number__c = act1.Id, PersonID__c = account_Obj[1].Id)};
		     Insert person_obj;
        
        
        Test.startTest();
        ConvertPreMemberToMemberBatchClass a = new ConvertPreMemberToMemberBatchClass();
        Database.executeBatch(a);
        Test.stopTest();
      
    }
    static testmethod void testmethod3() {
	
        RecordType objRecordType = [SELECT Id,Name FROM RecordType WHERE Name='MemberShip'];
        RecordType objRecordType1 = [SELECT Id,Name FROM RecordType WHERE Name='Person Account'];
        RecordType rec1 = [Select Name, Id From RecordType where sObjectType='Account' and isActive=true and Name='Pre Member'];
        
        MemberConversionSetting__c mcs = new MemberConversionSetting__c();
        mcs.Name = 'PrimaryRecord';
        mcs.Manual__c = 10;
        mcs.Automation__c = 8;
        mcs.Unmerge__c = 10;
        mcs.Member_Matching_Cut_off_Date__c = Date.newInstance(2018, 10, 2);
        mcs.Not_matched_Members_cut_off_window__c = 3;
        insert mcs;
            
		Account_Details__c  act = new Account_Details__c(Name = '0000147163', Balance__c = 0.00, Combined_Account_ID__c = '0000147163S0100P0100', ID1__c = '0100', Onboarded__c = true, RecType__c = 'ACCT', TypeTranslate__c = '1-PRIMARY SHARE',TYPE__c = 2, RecordType = objRecordType);
		Insert act;
		
		Account_Details__c  act1 = new Account_Details__c(Name = '0000147163', Balance__c = 0.00, Combined_Account_ID__c = '0000147163S0100P0100', ID1__c = '0100', Onboarded__c = true, RecType__c = 'SHAR', TypeTranslate__c = '1-PRIMARY SHARE', RecordType = objRecordType1, Parent_Account__c = act.Id);
		Insert act1;
		
		
		List<Account> account_Obj = new List<Account>{new Account(LastName = 'Test1', FirstName = 'Test', Type = 'null', Member_Verification_OTP_Invalid_Attempt__c = system.now(), Home_Phone__pc = '9252066277', Mobile_Phone__pc = '9252066277', Work_Phone__pc = '9252066277',Residential_Street__pc = 'res',Residential_Zipocde__pc = '23456', Email_raw__c = 'test1@test.com', PersonEmail = 'test1@test.com',Alt_Email_Raw__c ='ab1c@abc.com',  Alternate_Email__pc = 'abc@abc.com')};
		Insert account_Obj;
        
    	Account pact = new Account();
        pact.FirstName = 'Test';
        pact.LastName = 'Test1';
        //pact.Email_raw__c = 'test@test.com';
        //pact.PersonEmail = 'test1@test.com';
        //pact.Home_Phone__pc = '9252066277';
        pact.Work_Phone__pc = '9252066277';
        pact.Mobile_Phone__pc = '9252066277'; 
        pact.RecordtypeId = rec1.Id;
        pact.Residential_Street__pc ='res';
        pact.Residential_Zipocde__pc = '23567';
        pact.BIRTH_DATE__pc = system.Today().addyears(-20);
        pact.NA_Eligibility__c = true;
        pact.NA_Eligibility__c= true;
		pact.NA_LEHS_Complete__c= true;
		pact.NA_LEHS_Update__c= system.Today(); 
		pact.NA_LEOM_Complete__c= true;
		pact.NA_LEOM_Update__c= system.Today();
		pact.NA_Opt_Out__c= false;
		pact.NA_Opt_Out_Date__c= system.Today();
		pact.NA_Opt_Out_Updated__c= system.Today();
		pact.NA_LEAV_Complete__c= true;
		pact.NA_LECF_Complete__c= true;
		pact.NA_LECP_Complete__c= true;
		pact.NA_LEEM_Complete__c= true;
		pact.NA_LEMD_Complete__c= true;
		pact.NA_LEMP_Complete__c= true;
		pact.NA_LEMQ_Complete__c= true;
		pact.NA_LEOL_Complete__c= true;
		pact.NA_LEPT_Complete__c= true;
		pact.NA_LESB_Complete__c= true;
		pact.NA_LESF_Complete__c= true;
		pact.NA_LEWS_Complete__c= true;
        insert pact;
        
        account_Obj.add(pact);
        
        
        
        List<Person_Account__c> person_obj= new List<Person_Account__c>{new Person_Account__c(Account_Number__c = act.Id, TypeTranslate__c = 'PRIMARY', PersonID__c = account_Obj[0].Id), new Person_Account__c(Account_Number__c = act1.Id, PersonID__c = account_Obj[1].Id)};
		Insert person_obj;
        
        /*Task tk = new task();
        tk.Status = 'Open';
        tk.WhoId = pact.id;
        insert tk;*/
        
        
        
        Needs_Assesment__c na = new Needs_Assesment__c();
        na.Member__c = pact.id;
        na.Rec_Comment_New__c = 'test';
        insert na;
        
        NA_Other_Existing_Loans__c nae = new NA_Other_Existing_Loans__c();
        nae.Needs_Assessment__c = na.id;
        nae.Balance__c = 10000.00;
        insert nae;
        
        NA_Membership_Referral_Questions__c nmr = new NA_Membership_Referral_Questions__c();
        nmr.Needs_Assessment__c = na.id;
        nmr.Age__c = '22';
        insert nmr;
        
        NA_Deposit__c nd = new NA_Deposit__c();
        nd.Needs_Assessment__c = na.id;
        nd.Balance__c = 10000;
        insert nd;
        
        Opportunity op = new Opportunity(Name = 'Name', StageName = 'Open',Product_Type__c = 'Misc', CloseDate = system.today(),  Is_Converted__c = true, Opportunity_Source__c = 'Word of mouth', AccountId = pact.id,  Ownership__c = 'Auto Assign', Episys_User_ID__c = 1);
        insert op;
        
        Case cs = new Case();
        cs.AccountId = pact.Id;
        cs.Brand__c = 'Spectrum';
        insert cs;
        
        Test.startTest();
        ConvertPreMemberToMemberBatchClass a = new ConvertPreMemberToMemberBatchClass();
        Database.executeBatch(a);
        ConvertPreMemberToMemberWebservice.Convert();
        ConvertPreMemberToMemberWebservice.CreateCaseForNonMatchedMember();
        Test.stopTest();
      
    }
}