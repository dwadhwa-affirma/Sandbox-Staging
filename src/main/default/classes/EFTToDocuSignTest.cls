@isTest
public class EFTToDocuSignTest{
	@testSetup
	static void setup(){

		Account_Details__c accDetail = new Account_Details__c();
		accDetail.Name = '0000000123';
		accDetail.RecType__c = 'ACCT';
		accDetail.TypeTranslate__c = '1-PERSONAL';
		accDetail.Brand_Code__c = 'BC01';
		insert accDetail;

		Account acc = new Account();
		//acc.RecordTypeID=rtId;
		acc.FirstName = 'Test FName';
		acc.LastName = 'Test LName';
		acc.Mobile_Phone__pc = '555-469-3885';
		acc.Email_raw__c = 'test@test.com';
		acc.PersonID__c = 'V666147265';
		insert acc;


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
        insert objEFT;
        
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
	}

	static testMethod void docusignAPIcall(){
		EFT__c objEFT = [SELECT Account_Number__c, Action_Type__c, Alternate_Amount__c, Bank_Name__c, CreatedById, CreatedDate, Day_of_Month__c, Second_Day_of_Month__c, DocuSignId__c, Effective_Date__c, Frequency__c, Id, Member_Account__c, Member_Account__r.Brand__c, Member_Account__r.Name, Case__c, Case__r.Description, Member__c, Name, OwnerId, Payment_Amount__c, Routing_Number__c, Share_Loan_Id__c, Stage__c, Status__c, Type__c, EFT_ID_Type__c, LoanCode__c, EFT_Payment_Date__c, Locators_To_Expire__c, Member_Name__c, Docusign_Member_Email__c, EftLocator__c, Expired__c, Expiration_Date__c, Next_Payment_Due_Date__c, Docusign_Checking_Type__c, Docusign_Savings_Type__c, Docusign_is_Additional_Amount__c, Existing_Alternate_Amount__c
		                 FROM EFT__c
		                 limit 1];
		set<ID> setIds = new set<ID>();
		setIds.add(objEFT.Id);
		Test.startTest();
		EFTToDocuSign.docusignAPIcall(setIds);
		Test.stopTest();
	}

	static testMethod void docusignAttachtoCase(){
		EFT__c objEFT = [SELECT Account_Number__c, Action_Type__c, Alternate_Amount__c, Bank_Name__c, CreatedById, CreatedDate, Day_of_Month__c, Second_Day_of_Month__c, DocuSignId__c, Effective_Date__c, Frequency__c, Id, Member_Account__c, Member_Account__r.Brand__c, Member_Account__r.Name, Case__c, Case__r.Description, Member__c, Name, OwnerId, Payment_Amount__c, Routing_Number__c, Share_Loan_Id__c, Stage__c, Status__c, Type__c, EFT_ID_Type__c, LoanCode__c, EFT_Payment_Date__c, Locators_To_Expire__c, Member_Name__c, Docusign_Member_Email__c, EftLocator__c, Expired__c, Expiration_Date__c, Next_Payment_Due_Date__c, Docusign_Checking_Type__c, Docusign_Savings_Type__c, Docusign_is_Additional_Amount__c, Existing_Alternate_Amount__c
		                 FROM EFT__c
		                 limit 1];
		set<ID> setIds = new set<ID>();
		setIds.add(objEFT.Id);
		Test.startTest();
		EFTToDocuSign.docusignAttachtoCase(setIds);
		Test.stopTest();
	}
}