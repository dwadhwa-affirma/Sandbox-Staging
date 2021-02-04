@isTest
public class EFTToSyimtarTest {

    @testSetup
	static void setup(){
		ACH_Loan_Share_Type_Configuration__c cs = new ACH_Loan_Share_Type_Configuration__c();
		cs.RecType__c = 'LOAN';
		cs.Name = 'Loan';
		cs.Type__c = '50,80,81,82,51,40,54,03,53,70,62,61,55,60,05,04,75,10,01';
		insert cs;

		ACH_Loan_Share_Type_Configuration__c cs1 = new ACH_Loan_Share_Type_Configuration__c();
		cs1.RecType__c = 'SHARE';
		cs1.Name = 'Share';
		cs1.Type__c = '28';
		insert cs1;

		RecordType rec = [select Id, Name, SobjectType
		                  from RecordType
		                  where SobjectType = 'Case'
		                  Limit 1];

		CaseRecordType__c crt = new CaseRecordType__c();
		crt.Name = 'Test';
		crt.Primary_Category__c = 'Account Maintenance';
		crt.Secondary_Category__c = 'Account Services';
		crt.Teritiary_Category__c = 'ACH - Authorization for Debit';
		crt.RecordTypeId__c = rec.id;
		crt.SLA__c = 10;
		insert crt;

		ACH_Docusign_Emails__c ac = new ACH_Docusign_Emails__c();
		ac.Name = 'Email For Testing';
		ac.Emails__c = 'Testing';
		insert ac;

		ACH_DocuSign_API_User_Details__c adAPIChevron = new ACH_DocuSign_API_User_Details__c();
		adAPIChevron.Name = 'Chevron';
		adAPIChevron.AccountId__c = 'Test';
		adAPIChevron.EndPoint__c = 'Test';
		adAPIChevron.IntegratorKey__c = 'Test';
		adAPIChevron.Password__c = 'Test';
		adAPIChevron.ReplyTo__c = 'Test';
		adAPIChevron.TemplateId__c = 'Test';
		adAPIChevron.Username__c = 'Test';
		insert adAPIChevron;

		ACH_DocuSign_API_User_Details__c adAPISpectrum = new ACH_DocuSign_API_User_Details__c();
		adAPISpectrum.Name = 'Spectrum';
		adAPISpectrum.AccountId__c = 'Test';
		adAPISpectrum.EndPoint__c = 'Test';
		adAPISpectrum.IntegratorKey__c = 'Test';
		adAPISpectrum.Password__c = 'Test';
		adAPISpectrum.ReplyTo__c = 'Test';
		adAPISpectrum.TemplateId__c = 'Test';
		adAPISpectrum.Username__c = 'Test';
		insert adAPISpectrum;

		Profile pf = [Select Id
		              from profile
		              where Name = 'System Administrator'];

		User uu = new User(firstname = 'Dhwani', lastName = 'Bhavsar', email = 'dbhavsar@test.com', Username = 'dbhavsar@test.com', EmailEncodingKey = 'ISO-8859-1', Alias = 'dbha', TimeZoneSidKey = 'America/Los_Angeles', LocaleSidKey = 'en_US', LanguageLocaleKey = 'en_US', ProfileId = pf.Id);


		insert uu;

		test.startTest();
		Account acc = new Account();
		//acc.RecordTypeID=rtId;
		acc.FirstName = 'Test FName';
		acc.LastName = 'Test LName';
		acc.Mobile_Phone__pc = '555-469-3885';
		acc.Email_raw__c = 'test@test.com';
		acc.PersonID__c = 'V666147265';
		insert acc;

		Account_Details__c accDetail = new Account_Details__c();
		accDetail.Name = '0000000123';
		accDetail.RecType__c = 'ACCT';
		accDetail.TypeTranslate__c = '1-PERSONAL';
		accDetail.Brand_Code__c = 'BC01';
		insert accDetail;

		List<Person_Account__c> person_obj = new List<Person_Account__c>{new Person_Account__c(TypeTranslate__c = '0000/Primary', Account_Number__c = accDetail.id, PersonID__c = acc.Id), new Person_Account__c(TypeTranslate__c = '0000/Primary', Account_Number__c = accDetail.Id, PersonID__c = acc.Id)};
		Insert person_obj;

		List<EFT_Stages__c> eft_stages = new List<EFT_Stages__c>{new EFT_Stages__c(Name = 'Stage1', isActive__c = true, Order__c = 1, Stage_Action__c = 'Waiting', Stage_Action_Placeholder__c = '{{Action}}', Stage_Component__c = 'EFTStage1', Stage_Label__c = 'Action', StepId__c = 'Step1'), new EFT_Stages__c(Name = 'Stage2', isActive__c = true, Order__c = 2, Stage_Action__c = 'Waiting', Stage_Action_Placeholder__c = '{{ShareId}}', Stage_Component__c = 'EFTStage3', Stage_Label__c = 'Share/Loan', StepId__c = 'Step2'), new EFT_Stages__c(Name = 'Stage3', isActive__c = true, Order__c = 3, Stage_Action__c = 'Waiting', Stage_Action_Placeholder__c = '{{BankName}}', Stage_Component__c = 'EFTStage4', Stage_Label__c = 'FI', StepId__c = 'Step3'), new EFT_Stages__c(Name = 'Stage4', isActive__c = true, Order__c = 4, Stage_Action__c = 'Waiting', Stage_Action_Placeholder__c = '{{Amount}}', Stage_Component__c = 'EFTStage5', Stage_Label__c = 'Payment Monthly', StepId__c = 'Step4'), new EFT_Stages__c(Name = 'Stage5', isActive__c = true, Order__c = 5, Stage_Action__c = 'Waiting', Stage_Action_Placeholder__c = '{{Status}}', Stage_Component__c = 'EFTStage6', Stage_Label__c = 'Status', StepId__c = 'Step5')};
        Insert eft_stages;
        
        ContentVersion contentVersion = new ContentVersion(Title = 'Penguins', PathOnClient = 'Penguins.jpg', VersionData = Blob.valueOf('Test Content'), IsMajorVersion = true);
		insert contentVersion;
		
		List<Case> case_Obj = new List<Case>{new Case(Status = 'In Process', Brand__c = 'Spectrum', Description = 'Orginal Desc', Origin = null, Subject = 'Test', ClosedDate = null, IsEscalated = false, AccountId = acc.Id, Account_Number__c = accDetail.Id, Additional_Documents__c = false, Staff_Escalated__c = false, Five_Day_Flag__c = false, IsMarkDeleted__c = false, IsMarkRead__c = false, IsMarkSaved__c = false, Primary_Category__c = 'Card services', Secondary_Category__c = 'ATM/Debit', Tertiary_Category__c = 'Travel notification', MaritzCX__Response_Deleted_From_MaritzCX__c = false, SLATemp__c = false), new Case(Status = 'In Process', Brand__c = 'CFCU', Description = 'Orginal Desc', Origin = null, Subject = 'Test', ClosedDate = null, IsEscalated = false, AccountId = acc.Id, Account_Number__c = accDetail.Id, Additional_Documents__c = false, Staff_Escalated__c = false, Five_Day_Flag__c = false, IsMarkDeleted__c = false, IsMarkRead__c = false, IsMarkSaved__c = false, Primary_Category__c = 'Card services', Secondary_Category__c = 'ATM/Debit', Tertiary_Category__c = 'Travel notification', MaritzCX__Response_Deleted_From_MaritzCX__c = false, SLATemp__c = false), new Case(Status = 'In Process', Brand__c = 'CFCU', Description = 'Orginal Desc', Origin = null, Subject = 'Test', ClosedDate = null, IsEscalated = false, AccountId = acc.Id, Account_Number__c = accDetail.Id, Additional_Documents__c = false, Staff_Escalated__c = false, Five_Day_Flag__c = false, IsMarkDeleted__c = false, IsMarkRead__c = false, IsMarkSaved__c = false, Primary_Category__c = 'Card services', Secondary_Category__c = 'ATM/Debit', Tertiary_Category__c = 'Travel notification', MaritzCX__Response_Deleted_From_MaritzCX__c = false, SLATemp__c = false), new Case(Status = 'In Process', Brand__c = 'Spectrum', Description = 'Orginal Desc', Origin = null, Subject = 'Test', ClosedDate = null, IsEscalated = false, AccountId = acc.Id, Account_Number__c = accDetail.Id, Additional_Documents__c = false, Staff_Escalated__c = false, Five_Day_Flag__c = false, IsMarkDeleted__c = false, IsMarkRead__c = false, IsMarkSaved__c = false, Primary_Category__c = 'Account Maintenance', Secondary_Category__c = 'Account Services', Tertiary_Category__c = 'Extended Check Hold', MaritzCX__Response_Deleted_From_MaritzCX__c = false, SLATemp__c = false)};

        Insert case_Obj;

		EFT__c objEFT = new EFT__c();
		objEFT.Stage__c = 'Status';
		objEFT.Share_Loan_Id__c = '5103';
		objEFT.Share_Loan_Type__c = 'USED AUTO';
		objEFT.Share_Loan_Description__c = '2014 CADILLAC ATS';
		objEFT.EFT_ID_Type__c = 'Loan';
		objEFT.Routing_Number__c = '122105155';
		objEFT.Bank_Name__c = 'US BANK NA';
		objEFT.Account_Number__c = '12345678';
		objEFT.Type__c = 'Checking';
		objEFT.Alternate_Amount__c = 20.0;
		objEFT.Payment_Amount__c = 200.0;
		objEFT.Frequency__c = 'Monthly';
		objEFT.Effective_Date__c = Date.newInstance(2020, 12, 06);
		objEFT.Day_of_Month__c = '6';
		objEFT.Action_Type__c = 'Create';
        objEFT.Member_Account__c = accDetail.Id;
        objEFT.Case__C = case_Obj[0].Id;    
        objEFT.Locators_To_Expire__c  ='123,456';
		insert objEFT;

		Member360_TypeTranslate__c t = new Member360_TypeTranslate__c();
		t.name = '0000/Primary';
		insert t;
		Member360_TypeTranslate__c t1 = new Member360_TypeTranslate__c();
		t1.name = '001/Beneficiary';
		insert t1;
		Member360_TypeTranslate__c t2 = new Member360_TypeTranslate__c();
		t2.name = '001/Joint Member';
		insert t2;
		Member360_TypeTranslate__c t3 = new Member360_TypeTranslate__c();
		t3.name = '001/Trustee';
		insert t3;
		Member360_TypeTranslate__c t4 = new Member360_TypeTranslate__c();
		t4.name = '001/Custodian';
		insert t4;
		Member360_TypeTranslate__c t5 = new Member360_TypeTranslate__c();
		t5.name = '001/Primary';
		insert t5;
		Member360_TypeTranslate__c t6 = new Member360_TypeTranslate__c();
		t6.name = '001/Representative Payee';
        insert t6;
        
        List<ContentDocument> documents = [SELECT Id, Title, LatestPublishedVersionId
		                                   FROM ContentDocument];

		//create ContentDocumentLink  record
		ContentDocumentLink cdl = New ContentDocumentLink();
		cdl.LinkedEntityId = objEFT.id;
		cdl.ContentDocumentId = documents[0].Id;
		cdl.shareType = 'V';
		insert cdl;

        OnBase_Document__c objOnbase = new OnBase_Document__c();
        objOnbase.Case__c = case_Obj[0].id;
        objOnbase.IsMovedToOnBase__c = false;
        objOnbase.Attachment_Id__c = documents[0].Id;
		insert objOnbase;
		
		ACH_To_Episys_API_Details__c api = new ACH_To_Episys_API_Details__c();
		api.URL__c = 'https://symxapi.chevronfcu.org/devclient';
		api.Name = 'ProductionURL';
		insert api;

		test.stopTest();
    }

    static testMethod void insertEFTs(){
        EFT__c objEFT = [SELECT Account_Number__c, Action_Type__c, Alternate_Amount__c, Bank_Name__c, CreatedById, CreatedDate, Day_of_Month__c, Second_Day_of_Month__c, DocuSignId__c, Effective_Date__c, Frequency__c, Id, Member_Account__c, Member_Account__r.Brand__c, Member_Account__r.Name, Case__c, Case__r.Description, Member__c, Name, OwnerId, Payment_Amount__c, Routing_Number__c, Share_Loan_Id__c, Stage__c, Status__c, Type__c, EFT_ID_Type__c, LoanCode__c, EFT_Payment_Date__c, Locators_To_Expire__c, Member_Name__c, Docusign_Member_Email__c, EftLocator__c, Expired__c, Expiration_Date__c, Next_Payment_Due_Date__c, Docusign_Checking_Type__c, Docusign_Savings_Type__c, Docusign_is_Additional_Amount__c, Existing_Alternate_Amount__c
		                 FROM EFT__c
		                 limit 1];
		set<ID> setIds = new set<ID>();
		setIds.add(objEFT.Id);
        Test.startTest();
        EFTToSyimtar.insertEFTs(setIds);
        Test.stopTest();
    }
    
    static testMethod void UpdateEFT(){
        EFT__c objEFT = [SELECT Account_Number__c, Action_Type__c, Alternate_Amount__c, Bank_Name__c, CreatedById, CreatedDate, Day_of_Month__c, Second_Day_of_Month__c, DocuSignId__c, Effective_Date__c, Frequency__c, Id, Member_Account__c, Member_Account__r.Brand__c, Member_Account__r.Name, Case__c, Case__r.Description, Member__c, Name, OwnerId, Payment_Amount__c, Routing_Number__c, Share_Loan_Id__c, Stage__c, Status__c, Type__c, EFT_ID_Type__c, LoanCode__c, EFT_Payment_Date__c, Locators_To_Expire__c, Member_Name__c, Docusign_Member_Email__c, EftLocator__c, Expired__c, Expiration_Date__c, Next_Payment_Due_Date__c, Docusign_Checking_Type__c, Docusign_Savings_Type__c, Docusign_is_Additional_Amount__c, Existing_Alternate_Amount__c
		                 FROM EFT__c
                         limit 1];
        List<Case> cases = [Select id from case limit 4];
        objEFT.Case__c = cases[2].Id;
        update objEFT;
		set<ID> setIds = new set<ID>();
		setIds.add(objEFT.Id);
        Test.startTest();
        EFTToSyimtar.UpdateEFT(setIds, false);       
        Test.stopTest();        
    }

    static testMethod void ExpireEFT(){
        EFT__c objEFT = [SELECT Account_Number__c, Action_Type__c, Alternate_Amount__c, Bank_Name__c, CreatedById, CreatedDate, Day_of_Month__c, Second_Day_of_Month__c, DocuSignId__c, Effective_Date__c, Frequency__c, Id, Member_Account__c, Member_Account__r.Brand__c, Member_Account__r.Name, Case__c, Case__r.Description, Member__c, Name, OwnerId, Payment_Amount__c, Routing_Number__c, Share_Loan_Id__c, Stage__c, Status__c, Type__c, EFT_ID_Type__c, LoanCode__c, EFT_Payment_Date__c, Locators_To_Expire__c, Member_Name__c, Docusign_Member_Email__c, EftLocator__c, Expired__c, Expiration_Date__c, Next_Payment_Due_Date__c, Docusign_Checking_Type__c, Docusign_Savings_Type__c, Docusign_is_Additional_Amount__c, Existing_Alternate_Amount__c
		                 FROM EFT__c
                         limit 1];
                         List<Case> cases = [Select id from case limit 4];
        objEFT.Case__c = cases[1].Id;
        update objEFT;
		set<ID> setIds = new set<ID>();
		setIds.add(objEFT.Id);
        Test.startTest();
        EFTToSyimtar.UpdateEFT(setIds, true);      
        Test.stopTest();        
    }
    
    static testMethod void getUserChar3(){
        
        Test.startTest();
        EFTToSyimtar.getUserChar3('0000000123', '2800');       
        Test.stopTest();
        
	}
    

}
