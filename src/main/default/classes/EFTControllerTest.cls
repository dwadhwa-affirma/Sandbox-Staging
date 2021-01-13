@isTest
public class EFTControllerTest{
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
		test.stopTest();
	}

	public class SingleRequestMock implements HttpCalloutMock{
		protected Integer code;
		protected String status;
		protected String bodyAsString;
		protected Blob bodyAsBlob;
		protected Map<String, String> responseHeaders;
		public SingleRequestMock(Integer code, String status, String body, Map<String, String> responseHeaders){
			this.code = code;
			this.status = status;
			this.bodyAsString = body;
			this.bodyAsBlob = null;
			this.responseHeaders = responseHeaders;
		}

		public SingleRequestMock(Integer code, String status, Blob body, Map<String, String> responseHeaders){
			this.code = code;
			this.status = status;
			this.bodyAsBlob = body;
			this.bodyAsString = null;
			this.responseHeaders = responseHeaders;
		}

		public HTTPResponse respond(HTTPRequest req){
			HttpResponse resp = new HttpResponse();
			resp.setStatusCode(code);
			resp.setStatus(status);
			if (bodyAsBlob != null){
				resp.setBodyAsBlob(bodyAsBlob);
			} else{
				resp.setBody(bodyAsString);
			}

			if (responseHeaders != null){
				for (String key : responseHeaders.keySet()){
					resp.setHeader(key, responseHeaders.get(key));
				}
			}
			return resp;
		}
	}

	public class MultiRequestMock implements HttpCalloutMock{
		Map<String, HttpCalloutMock> requests;
		public MultiRequestMock(Map<String, HttpCalloutMock> requests){
			this.requests = requests;
		}

		public HTTPResponse respond(HTTPRequest req){
			system.debug('req==' + req.getEndpoint());
			HttpCalloutMock mock = requests.get(req.getEndpoint());
			system.debug('mock==' + mock);
			if (mock != null){
				return mock.respond(req);
			} else{
				return mock.respond(req);//throw new MyCustomException('HTTP callout not supported for test methods');
			}
		}

		public void addRequestMock(String url, HttpCalloutMock mock){
			requests.put(url, mock);
		}
	}

	static testMethod void getTypes(){
		EFTController.getTypes();
	}

	static testMethod void getStageData(){
		Account_Details__c objAccountDetails = [select id
		                                        from Account_Details__c
		                                        limit 1];

		SingleRequestMock fakeGetSharesResp = new SingleRequestMock(200, 'Complete', '[{"Order":100,"AvailableBalance":null,"Id":null,"Type":1,"AccountType":"SHARE #2800 - JOINT OWNER ","NameAndBalance":" Available Balance( $)","AccountNumber":"0000000123","Description":"PRIMARY SHARE","UserChar3":"","UserAmount2":0.00}]', null);

		SingleRequestMock fakeGetLoanResp = new SingleRequestMock(200, 'Complete', '[{"LoanId":7501,"LoanType":0,"Description":"","Payment":0.0,"AlternatePayment":0.0,"PmtBucketAmount":0.0,"UserAmount2":0.0,"DueDate":"","DueDay1":0,"DueDay2":0,"LoanCode":""}]', null);
		SingleRequestMock fakeGetEFTResp = new SingleRequestMock(200, 'Complete', '[{"EftLocator":773,"AccountNumber":"0000000123","AmountCode":27,"Amount":0.01,"FinancialInstitution":"BANK OF AMERICA, N.A.","Payee":"0322271627","Reference":"42006986568","EffectiveDate":"2019-01-02","Day1":0,"Day2":0,"Frequency":4,"ExpirationDate":"","Id":"0100"}]', null);

		Map<String, HttpCalloutMock> endpoint2TestResp = new Map<String, HttpCalloutMock>();
		endpoint2TestResp.put('https://symxapi.chevronfcu.org/devclient/EFT/GetEftRecords?accountNumber=0000000123',fakeGetEFTResp);
		endpoint2TestResp.put('https://symxapi.chevronfcu.org/devclient/PSAuto/GetSharesEFT?AccountNumber=0000000123&userchar2=abc',fakeGetSharesResp);
		endpoint2TestResp.put('https://symxapi.chevronfcu.org/devclient/PsAuto/GetLoansSelectFields?AccountNumber=0000000123',fakeGetLoanResp);


		HttpCalloutMock multiCalloutMock = new MultiRequestMock(endpoint2TestResp);

		Test.setMock(HttpCalloutMock.class, multiCalloutMock);
		Test.startTest();
		system.debug('objAccountDetails==' + objAccountDetails);
		EFTController.getStageData(objAccountDetails.id, '');
		Test.stopTest();
	}

	static testMethod void getMembers(){
		Account_Details__c objAccountDetails = [select id
		                                        from Account_Details__c
		                                        limit 1];

		SingleRequestMock fakeGetSharesResp = new SingleRequestMock(200, 'Complete', '[{"Order":100,"AvailableBalance":null,"Id":null,"Type":1,"AccountType":"SHARE #0100 - JOINT OWNER ","NameAndBalance":" Available Balance( $)","AccountNumber":"0000000123","Description":"PRIMARY SHARE","UserChar3":"","UserAmount2":0.00}]', null);

		SingleRequestMock fakeGetLoanResp = new SingleRequestMock(200, 'Complete', '[{"LoanId":0,"LoanType":0,"Description":"","Payment":0.0,"AlternatePayment":0.0,"PmtBucketAmount":0.0,"UserAmount2":0.0,"DueDate":"","DueDay1":0,"DueDay2":0,"LoanCode":""}]', null);
		SingleRequestMock fakeGetEFTResp = new SingleRequestMock(200, 'Complete', '[{"EftLocator":773,"AccountNumber":"0000000123","AmountCode":27,"Amount":0.01,"FinancialInstitution":"BANK OF AMERICA, N.A.","Payee":"0322271627","Reference":"42006986568","EffectiveDate":"2019-01-02","Day1":0,"Day2":0,"Frequency":4,"ExpirationDate":"","Id":"0100"}]', null);

		Map<String, HttpCalloutMock> endpoint2TestResp = new Map<String, HttpCalloutMock>();
		endpoint2TestResp.put('https://symxapi.chevronfcu.org/devclient/EFT/GetEftRecords?accountNumber=0000000123',fakeGetEFTResp);
		endpoint2TestResp.put('https://symxapi.chevronfcu.org/devclient/PSAuto/GetSharesEFT?AccountNumber=0000000123&userchar2=abc',fakeGetSharesResp);
		endpoint2TestResp.put('https://symxapi.chevronfcu.org/devclient/PsAuto/GetLoansSelectFields?AccountNumber=0000000123',fakeGetLoanResp);


		HttpCalloutMock multiCalloutMock = new MultiRequestMock(endpoint2TestResp);

		Test.setMock(HttpCalloutMock.class, multiCalloutMock);
		Test.startTest();
		EFTController.getMembers(objAccountDetails.id);
		Test.stopTest();
	}

	static testMethod void getEFT(){
		EFT__c objEFT = [select id
		                 from EFT__c
		                 limit 1];
		Test.startTest();
		EFTController.getEFT(objEFT);
		Test.stopTest();
	}

	static testMethod void saveStageData(){
		EFT__c objEFT = [SELECT Account_Number__c, Action_Type__c, Alternate_Amount__c, Bank_Name__c, CreatedById, CreatedDate, Day_of_Month__c, Second_Day_of_Month__c, DocuSignId__c, Effective_Date__c, Frequency__c, Id, Member_Account__c, Member_Account__r.Brand__c, Member_Account__r.Name, Case__c, Case__r.Description, Member__c, Name, OwnerId, Payment_Amount__c, Routing_Number__c, Share_Loan_Id__c, Stage__c, Status__c, Type__c, EFT_ID_Type__c, LoanCode__c, EFT_Payment_Date__c, Locators_To_Expire__c, Member_Name__c, Docusign_Member_Email__c, EftLocator__c, Expired__c, Expiration_Date__c, Next_Payment_Due_Date__c, Docusign_Checking_Type__c, Docusign_Savings_Type__c, Docusign_is_Additional_Amount__c, Existing_Alternate_Amount__c
		                 FROM EFT__c
		                 limit 1];

		Account_Details__c objAccountDetails = [select id
		                                        from Account_Details__c
		                                        limit 1];
		Test.startTest();
		EFTController.saveStageData(objEFT);
		EFT__c objEFT1 = new EFT__c();
		objEFT1.Stage__c = 'Status';
		objEFT1.Share_Loan_Id__c = '5103';
		objEFT1.Share_Loan_Type__c = 'USED AUTO';
		objEFT1.Share_Loan_Description__c = '2014 CADILLAC ATS';
		objEFT1.EFT_ID_Type__c = 'Loan';
		objEFT1.Routing_Number__c = '122105155';
		objEFT1.Bank_Name__c = 'US BANK NA';
		objEFT1.Account_Number__c = '12345678';
		objEFT1.Type__c = 'Checking';
		objEFT1.Alternate_Amount__c = 20.0;
		objEFT1.Payment_Amount__c = 200.0;
		objEFT1.Frequency__c = 'Monthly';
		objEFT1.Effective_Date__c = Date.newInstance(2020, 12, 06);
		objEFT1.Day_of_Month__c = '6';
		objEFT1.Action_Type__c = 'Create';
		objEFT1.Member_Account__c = objAccountDetails.Id;
		EFTController.saveStageData(objEFT1);
		Test.stopTest();
	}

	static testMethod void expireEFT(){
		EFT__c objEFT = [SELECT Account_Number__c, Action_Type__c, Alternate_Amount__c, Bank_Name__c, CreatedById, CreatedDate, Day_of_Month__c, Second_Day_of_Month__c, DocuSignId__c, Effective_Date__c, Frequency__c, Id, Member_Account__c, Member_Account__r.Brand__c, Member_Account__r.Name, Case__c, Case__r.Description, Member__c, Name, OwnerId, Payment_Amount__c, Routing_Number__c, Share_Loan_Id__c, Stage__c, Status__c, Type__c, EFT_ID_Type__c, LoanCode__c, EFT_Payment_Date__c, Locators_To_Expire__c, Member_Name__c, Docusign_Member_Email__c, EftLocator__c, Expired__c, Expiration_Date__c, Next_Payment_Due_Date__c, Docusign_Checking_Type__c, Docusign_Savings_Type__c, Docusign_is_Additional_Amount__c, Existing_Alternate_Amount__c
		                 FROM EFT__c
		                 limit 1];

		Account_Details__c objAccountDetails = [select id
		                                        from Account_Details__c
		                                        limit 1];
		Test.startTest();
		EFTController.expireEFT(objEFT);
		EFT__c objEFT1 = new EFT__c();
		objEFT1.Stage__c = 'Status';
		objEFT1.Share_Loan_Id__c = '5103';
		objEFT1.Share_Loan_Type__c = 'USED AUTO';
		objEFT1.Share_Loan_Description__c = '2014 CADILLAC ATS';
		objEFT1.EFT_ID_Type__c = 'Loan';
		objEFT1.Routing_Number__c = '122105155';
		objEFT1.Bank_Name__c = 'US BANK NA';
		objEFT1.Account_Number__c = '12345678';
		objEFT1.Type__c = 'Checking';
		objEFT1.Alternate_Amount__c = 20.0;
		objEFT1.Payment_Amount__c = 200.0;
		objEFT1.Frequency__c = 'Monthly';
		objEFT1.Effective_Date__c = Date.newInstance(2020, 12, 06);
		objEFT1.Day_of_Month__c = '6';
		objEFT1.Action_Type__c = 'Create';
		objEFT1.Member_Account__c = objAccountDetails.Id;
		EFTController.expireEFT(objEFT1);
		Test.stopTest();
	}

	static testMethod void createCase(){
		EFT__c objEFT = [SELECT Account_Number__c, Action_Type__c, Alternate_Amount__c, Bank_Name__c, CreatedById, CreatedDate, Day_of_Month__c, Second_Day_of_Month__c, DocuSignId__c, Effective_Date__c, Frequency__c, Id, Member_Account__c, Member_Account__r.Brand__c, Member_Account__r.Name, Case__c, Case__r.Description, Member__c, Name, OwnerId, Payment_Amount__c, Routing_Number__c, Share_Loan_Id__c, Stage__c, Status__c, Type__c, EFT_ID_Type__c, LoanCode__c, EFT_Payment_Date__c, Locators_To_Expire__c, Member_Name__c, Docusign_Member_Email__c, EftLocator__c, Expired__c, Expiration_Date__c, Next_Payment_Due_Date__c, Docusign_Checking_Type__c, Docusign_Savings_Type__c, Docusign_is_Additional_Amount__c, Existing_Alternate_Amount__c
		                 FROM EFT__c
		                 limit 1];

		Account_Details__c objAccountDetails = [select id
		                                        from Account_Details__c
		                                        limit 1];
		Test.startTest();
		EFTController.createCase(objEFT);
		EFT__c objEFT1 = new EFT__c();
		objEFT1.Stage__c = 'Status';
		objEFT1.Share_Loan_Id__c = '5103';
		objEFT1.Share_Loan_Type__c = 'USED AUTO';
		objEFT1.Share_Loan_Description__c = '2014 CADILLAC ATS';
		objEFT1.EFT_ID_Type__c = 'Loan';
		objEFT1.Routing_Number__c = '122105155';
		objEFT1.Bank_Name__c = 'US BANK NA';
		objEFT1.Account_Number__c = '12345678';
		objEFT1.Type__c = 'Checking';
		objEFT1.Alternate_Amount__c = 20.0;
		objEFT1.Payment_Amount__c = 200.0;
		objEFT1.Frequency__c = 'Monthly';
		objEFT1.Effective_Date__c = Date.newInstance(2020, 12, 06);
		objEFT1.Day_of_Month__c = '6';
		objEFT1.Action_Type__c = 'Update';
		objEFT1.Member_Account__c = objAccountDetails.Id;
		insert objEFT1;
		EFTController.createCase(objEFT1);
		Test.stopTest();
	}

	static testMethod void sendACHDocument(){
		EFT__c objEFT = [SELECT Account_Number__c, Action_Type__c, Alternate_Amount__c, Bank_Name__c, CreatedById, CreatedDate, Day_of_Month__c, Second_Day_of_Month__c, DocuSignId__c, Effective_Date__c, Frequency__c, Id, Member_Account__c, Member_Account__r.Brand__c, Member_Account__r.Name, Case__c, Case__r.Description, Member__c, Name, OwnerId, Payment_Amount__c, Routing_Number__c, Share_Loan_Id__c, Stage__c, Status__c, Type__c, EFT_ID_Type__c, LoanCode__c, EFT_Payment_Date__c, Locators_To_Expire__c, Member_Name__c, Docusign_Member_Email__c, EftLocator__c, Expired__c, Expiration_Date__c, Next_Payment_Due_Date__c, Docusign_Checking_Type__c, Docusign_Savings_Type__c, Docusign_is_Additional_Amount__c, Existing_Alternate_Amount__c
		                 FROM EFT__c
		                 limit 1];
		Test.startTest();
		EFTController.sendACHDocument(objEFT);
		Test.stopTest();
	}

	static testMethod void routingInfo(){

		Test.startTest();
		EFTController.routingInfo('322271627');
		Test.stopTest();
	}

	static testMethod void getShareAccounts(){

		Test.startTest();
		EFTController.getShareAccounts('0000000123');
		Test.stopTest();
	}

	static testMethod void getEpisysEmailAddresses(){
		Account_Details__c objAccountDetails = [select id
		                                        from Account_Details__c
		                                        limit 1];

		Test.startTest();
		EFTController.getEpisysEmailAddresses(objAccountDetails.Id);
		Test.stopTest();
	}

	static testMethod void saveSignature(){
		EFT__c objEFT = [SELECT Account_Number__c, Action_Type__c, Alternate_Amount__c, Bank_Name__c, CreatedById, CreatedDate, Day_of_Month__c, Second_Day_of_Month__c, DocuSignId__c, Effective_Date__c, Frequency__c, Id, Member_Account__c, Member_Account__r.Brand__c, Member_Account__r.Name, Case__c, Case__r.Description, Member__c, Name, OwnerId, Payment_Amount__c, Routing_Number__c, Share_Loan_Id__c, Stage__c, Status__c, Type__c, EFT_ID_Type__c, LoanCode__c, EFT_Payment_Date__c, Locators_To_Expire__c, Member_Name__c, Docusign_Member_Email__c, EftLocator__c, Expired__c, Expiration_Date__c, Next_Payment_Due_Date__c, Docusign_Checking_Type__c, Docusign_Savings_Type__c, Docusign_is_Additional_Amount__c, Existing_Alternate_Amount__c
		                 FROM EFT__c
		                 limit 1];

		Test.startTest();
        EFTController.saveSignature('Image url remove in url', objEFT.Id, objEFT);
        Id result = EFTController.saveSignature('Image url remove in url', objEFT.Id);        
		Test.stopTest();
	}

	static testMethod void getTrackingRecordforShare(){
		Account_Details__c objAccountDetails = [select id, Name
		                                        from Account_Details__c
		                                        limit 1];

		Test.startTest();
		EFTController.getTrackingRecordforShare(objAccountDetails.Name, '2800');
		Test.stopTest();
	}

	static testMethod void getDaysofMonth(){
		Test.startTest();
		EFTController.getDaysofMonth();
		Test.stopTest();
	}

	static testmethod void validateStandardController(){
		EFT__c objEFT = [SELECT Account_Number__c, Action_Type__c, Alternate_Amount__c, Bank_Name__c, CreatedById, CreatedDate, Day_of_Month__c, Second_Day_of_Month__c, DocuSignId__c, Effective_Date__c, Frequency__c, Id, Member_Account__c, Member_Account__r.Brand__c, Member_Account__r.Name, Case__c, Case__r.Description, Member__c, Name, OwnerId, Payment_Amount__c, Routing_Number__c, Share_Loan_Id__c, Stage__c, Status__c, Type__c, EFT_ID_Type__c, LoanCode__c, EFT_Payment_Date__c, Locators_To_Expire__c, Member_Name__c, Docusign_Member_Email__c, EftLocator__c, Expired__c, Expiration_Date__c, Next_Payment_Due_Date__c, Docusign_Checking_Type__c, Docusign_Savings_Type__c, Docusign_is_Additional_Amount__c, Existing_Alternate_Amount__c
		                 FROM EFT__c
		                 limit 1];
		ApexPages.StandardController sc = new ApexPages.StandardController(objEFT);
		EFTController testAccPlan = new EFTController(sc);

		PageReference pageRef = Page.ACHSigningInPerson;
		pageRef.getParameters().put('id', String.valueOf(objEFT.Id));
        Test.setCurrentPage(pageRef);       
        testAccPlan.attach();
        testAccPlan.Cancel();
	}
}