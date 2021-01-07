public class EFTController{
	public EFT__c ACH;

	public EFT__c ACHDetail{ get; set; }

	public id objParentId{ get; set; }

	public Id signAttachmentId{
		get{
			List<Attachment> a = new List<Attachment>();
			a = [SELECT Id
			     FROM Attachment
			     Where ParentId = :objParentId and Name = 'ESignature.png'
			     Order by CreatedDate desc
			     LIMIT 1];
			if (a.size() > 0){
				return a[0].Id;
			}
			return null;
		}

		set;
	}

	public EFTController(ApexPages.StandardController stdController){
		this.ACH = (EFT__c)stdController.getRecord();
		this.objParentId = this.ACH.Id;
		system.debug(ApexPages.currentPage().getParameters().get('id'));
		this.ACHDetail = [SELECT id, name, Member_Account__c, Stage__c, Action_Type__c, Share_Loan_Id__c, Type__c, Share_Loan_Type__c, Share_Loan_Description__c, Routing_Number__c, Bank_Name__c, Account_Number__c, Alternate_Amount__c, Effective_Date__c, Frequency__c, isAlternateAmount__c, Payment_Amount__c, Day_of_Month__c, Second_Day_of_Month__c, Member_Account__r.name, Case__c, Case__r.CaseNumber, Case__r.Status, Expired__c, Member_Name__c
		                  from EFT__c
		                  WHERE Id = :this.ACH.Id];
	}

	public List<SelectOption> getTypes(){
		Schema.sObjectType sobject_type = EFT__c.getSObjectType();
		Schema.DescribeSObjectResult sobject_describe = sobject_type.getDescribe();
		Map<String, Schema.SObjectField> field_map = sobject_describe.fields.getMap();
		System.debug('field_map==' + field_map);
		List<Schema.PicklistEntry> pick_list_values = field_map.get('Type__c').getDescribe().getPickListValues();
		List<selectOption> options = new List<selectOption>();
		for (Schema.PicklistEntry a : pick_list_values){
			options.add(new selectOption(a.getLabel(), a.getValue()));
		}
		return options;
	}

	//------------------------------- Getting Stage Details and Member Account Details-----------------------------------------------//
	@AuraEnabled
	public static map<string, object> getStageData(string recordId, string sObjectType){
		map<string, object> resultMap = new map<string, object>();

		List<EFT_Stages__c> EFTStages = new List<EFT_Stages__c>();
		EFTStages = [SELECT id, name, isActive__c, Order__c, Stage_Action__c, Stage_Action_Placeholder__c, Stage_Component__c, Stage_Label__c, StepId__c
		             from EFT_Stages__c
		             where isActive__c = true]; //where isActive__c = true;      //EFT_Stages__c.getall().values();
		resultMap.put('EFTStages', EFTStages);
		system.debug('sObjectType==' + sObjectType);

		List<EFT__c> EFTRecord = [Select id, name, Member_Account__c, Stage__c, Action_Type__c
		                          from EFT__c
		                          where Member_Account__c = :recordId
		                          limit 1];
		integer activeStageIndex = 0;
		if (EFTRecord.size() > 0){
			for (EFT_Stages__c eftstage : EFTStages){
				if (EFTRecord[0].Stage__c == eftstage.Stage_Label__c){
					activeStageIndex = (integer)eftstage.Order__c;
				}
			}

			resultMap.put('EFT', EFTRecord);

		}
		Account_Details__c MemberAccount = [select id, name
		                                    from Account_Details__c
		                                    where id = :recordId
		                                    limit 1];
		resultMap.put('MemberAccount', MemberAccount);

		Map<string, List<ShareLoanWrapperObject>> objShareLoan = getShareLoanAccounts(recordId);
		system.debug('#####' + objShareLoan.get('ShareLoanList'));
		if (objShareLoan.get('ShareLoanList').size() == 0){
			resultmap.put('ErrorMessage', 'The membership account does not contain any share or loan types that can be managed with the ACH Automation workflow.');
		} else{
			resultmap.put('ErrorMessage', '');
		}

		return resultMap;
	}

	@AuraEnabled
	public static map<string, object> getMembers(string recordId){
		list<Person_Account__c> paList = PersonNameLightningController.getData(recordId);
		system.debug('result==' + paList);
		map<string, object> resultmap = new map<string, object>();

		list<Person_Account__c> result = new List<Person_Account__c>();

		set<string> typeList = new set<string>();
		for (Member360_TypeTranslate__c t : Member360_TypeTranslate__c.getAll().values()){
			typeList.add(t.name);
		}

		for (Person_Account__c var : paList){
			if (typeList.contains(var.TypeTranslate__c)){
				result.add(var);
			}

		}
		resultmap.put('PersonList', result);
		List<EFT__C> existingEFTs = getEFTRecordsEpisys(recordId);
		if (existingEFTs.size() > 0){
			resultmap.put('EFTList', existingEFTs);
		}


		return resultmap;
	}

	@AuraEnabled
	public static EFT__c getEFT(EFT__c EFTRecord){
		system.debug('EFTRecord.id==' + EFTRecord.id);
		system.debug('EFTRecord.Id==' + EFTRecord.Id);
		if (EFTRecord.id != null){
			EFT__c ResultEFTRecord = [select id, name, Member_Account__c, Stage__c, Action_Type__c, Share_Loan_Id__c, Type__c, Share_Loan_Type__c, Share_Loan_Description__c, Routing_Number__c, Bank_Name__c, Account_Number__c, Alternate_Amount__c, Effective_Date__c, EFT_ID_Type__c, Frequency__c, Payment_Amount__c, Day_of_Month__c, Second_Day_of_Month__c, Member_Account__r.name, Case__c, Case__r.CaseNumber, Case__r.Status, Expired__c, Member_Name__c, isAlternateAmount__c
			                          from EFT__c
			                          where id = :EFTRecord.id
			                          limit 1];
			return ResultEFTRecord;
		} else{
			return EFTRecord;
		}
	}

	//------------------------------- Saving EFT data to Salesforce-----------------------------------------------//
	@AuraEnabled
	public static EFT__c saveStageData(EFT__c EFTRecord){
		system.debug('Alternate_Amount__c==' + EFTRecord.Alternate_Amount__c);
		if (EFTRecord.Second_Day_of_Month__c == '0'){
			EFTRecord.Second_Day_of_Month__c = '';
		}
		if (EFTRecord.Day_of_Month__c == '0'){
			EFTRecord.Day_of_Month__c = (string)'0';
		}
		List<EFT__c> EFTRecordList = [Select id, name, Member_Account__c, Stage__c, Action_Type__c, EftLocator__c
		                              from EFT__c
		                              where id = :EFTRecord.id
		                              limit 1];

		system.debug('EFTRecordList.size==' + EFTRecordList.size());
		system.debug('EFTRecordList.MemberAccount==' + EFTRecord.Member_Account__c);
		system.debug('EFTRecordList.MemberAccount==' + EFTRecord.Member_Account__r);


		if (EFTRecordList.size() == 0){
			string MemberAccountID = EFTRecord.Member_Account__c == null ? EFTRecord.Member_Account__r.Id : EFTRecord.Member_Account__c;
			Account_Details__c MemberAccount = [select id, name, Parent_Account__c
			                                    from Account_Details__c
			                                    where id = :MemberAccountID
			                                    limit 1];
			system.debug('EFTRecord.Member_Account__r.Parent_Account__c==' + MemberAccount.Parent_Account__c);
			Person_Account__c paPrimary = [SELECT Id, PersonID__c, Account_Number__c, Account_Number__r.RecType__c, TypeTranslate__c, Account_Number__r.Name, PersonID__r.Home_Phone__pc, PersonID__r.Residential_City__pc, PersonID__r.Residential_State__pc, PersonID__r.Residential_Street__pc, PersonID__r.Residential_Zipocde__pc, PersonID__r.Name, PersonID__r.Email_raw__c
			                               FROM Person_Account__c
			                               WHERE (Account_Number__c = :MemberAccountID OR Account_Number__c = :MemberAccount.Parent_Account__c) and TypeTranslate__c like '%Primary%'
			                               limit 1];


			if (EFTRecord.Alternate_Amount__c == null || EFTRecord.Alternate_Amount__c == 0){
				EFTRecord.Docusign_is_Additional_Amount__c = false;
			} else{
				EFTRecord.Docusign_is_Additional_Amount__c = true;
			}
			if (EFTRecord.Member_Account__c == null){
				EFTRecord.Member_Account__c = EFTRecord.Member_Account__r.Id;
			}

			insert EFTRecord;
			return EFTRecord;
		} else{
			EFTRecordList[0].Stage__c = EFTRecord.Stage__c;
			EFTRecordList[0].Share_Loan_Id__c = EFTRecord.Share_Loan_Id__c;
			EFTRecordList[0].Routing_Number__c = EFTRecord.Routing_Number__c;
			EFTRecordList[0].Bank_Name__c = EFTRecord.Bank_Name__c;
			EFTRecordList[0].Account_Number__c = EFTRecord.Account_Number__c;
			EFTRecordList[0].Type__c = EFTRecord.Type__c;
			EFTRecordList[0].Alternate_Amount__c = EFTRecord.Alternate_Amount__c;
			EFTRecordList[0].Payment_Amount__c = EFTRecord.Payment_Amount__c;
			EFTRecordList[0].Frequency__c = EFTRecord.Frequency__c;
			EFTRecordList[0].Effective_Date__c = EFTRecord.Effective_Date__c;
			EFTRecordList[0].Day_of_Month__c = EFTRecord.Day_of_Month__c;
			EFTRecordList[0].Second_Day_of_Month__c = EFTRecord.Second_Day_of_Month__c;
			EFTRecordList[0].Action_Type__c = EFTRecord.Action_Type__c;
			EFTRecordList[0].Update_DocuSignId__c = '';
			EFTRecordList[0].Update_Docusign_Status__c = '';
			EFTRecordList[0].Member_Name__c = EFTRecord.Member_Name__c;
			EFTRecordList[0].Docusign_Member_Email__c = EFTRecord.Docusign_Member_Email__c;
			EFTRecordList[0].EftLocator__c = EFTRecord.EftLocator__c;
			system.debug('Expired__c==' + EFTRecord.Expired__c);
			system.debug('Expiration_Date__c==' + EFTRecord.Expiration_Date__c);
			EFTRecordList[0].Expired__c = EFTRecord.Expired__c;
			EFTRecordList[0].Expiration_Date__c = EFTRecord.Expiration_Date__c;
			EFTRecordList[0].EFT_Payment_Date__c = EFTRecord.EFT_Payment_Date__c;
			EFTRecordList[0].Next_Payment_Due_Date__c = EFTRecord.Next_Payment_Due_Date__c;
			EFTRecordList[0].Locators_To_Expire__c = EFTRecord.Locators_To_Expire__c;
			if (EFTRecord.Type__c == 'Checking'){
				EFTRecordList[0].Docusign_Checking_Type__c = true;
				EFTRecordList[0].Docusign_Savings_Type__c = false;
			} else if (EFTRecord.Type__c == 'Savings'){
				EFTRecordList[0].Docusign_Checking_Type__c = false;
				EFTRecordList[0].Docusign_Savings_Type__c = true;
			}
			if (EFTRecord.Alternate_Amount__c == null || EFTRecord.Alternate_Amount__c == 0){
				EFTRecordList[0].Docusign_is_Additional_Amount__c = false;
			} else{
				EFTRecordList[0].Docusign_is_Additional_Amount__c = true;
			}
			EFTRecordList[0].Existing_Alternate_Amount__c = EFTRecord.Existing_Alternate_Amount__c;
			update EFTRecordList;
			return EFTRecordList[0];
		}
	}

	@AuraEnabled
	public static EFT__c expireEFT(EFT__c EFTRecord){

		// system.debug('EFTRecordString=='+EFTRecordString);
		//EFT__c EFTRecord = (EFT__c) System.JSON.deserialize(EFTRecordString, EFT__c.Class);
		system.debug('EFTRecordId==' + EFTRecord.Id);
		system.debug('Effective_Date__c==' + EFTRecord.Effective_Date__c);
		system.debug('Expired__c==' + EFTRecord.Expired__c);
		EFT__c EFTRecordList = new EFT__c();
		if (EFTRecord.Id != null){
			EFTRecordList = [Select Account_Number__c, Action_Type__c, Alternate_Amount__c, Bank_Name__c, CreatedById, CreatedDate, Day_of_Month__c, Second_Day_of_Month__c, DocuSignId__c, Effective_Date__c, Expiration_Date__c, Frequency__c, Id, Member_Account__c, Member_Account__r.Brand__c, Member_Account__r.Name, Member__c, Name, Case__c, OwnerId, Payment_Amount__c, Routing_Number__c, Share_Loan_Id__c, Stage__c, EftLocator__c, Share_Loan_Description__c, Share_Loan_Type__c, Member_Name__c, Status__c, Type__c, EFT_ID_Type__c, Expired__c
			                 from EFT__c
			                 where id = :EFTRecord.Id
			                 limit 1];
			if (EFTRecordList != null){
				EFTRecordList.Expired__c = false;
				EFTRecordList.Effective_Date__c = EFTRecord.Effective_Date__c;
				update EFTRecordList;
				EFTRecordList.Expired__c = true;
				EFTRecordList.Action_Type__c = 'Update';
				EFT__c ResultEFTRecord = createCase(EFTRecordList);
				EFTRecordList.Case__c = ResultEFTRecord.case__c;
				// update EFTRecordList;
			}
		} else{
			system.debug('Insert==' + EFTRecord.EftLocator__c);
			system.debug('Member_Account__c==' + EFTRecord.Member_Account__c);
			system.debug('Member_Account__r.Id==' + EFTRecord.Member_Account__r.Id);
			system.debug('Member_Account__r.Name==' + EFTRecord.Member_Account__r.Name);
			if (EFTRecord.Member_Account__c == null){
				EFTRecord.Member_Account__c = EFTRecord.Member_Account__r.Id;
			}
			insert EFTRecord;
			EFTRecord.Expired__c = true;
			EFTRecord.Action_Type__c = 'Update';
			EFT__c ResultEFTRecord = createCase(EFTRecord);
			EFTRecord.Case__c = ResultEFTRecord.case__c;
			EFTRecordList = EFTRecord;
		}
		update EFTRecordList;
		system.debug('EFTRecordList.size==' + EFTRecordList.id);


		// EFT__c EFTRecordList1 = [Select id, name, Member_Account__c, Stage__c, Action_Type__c, Expired__c, Expiration_Date__c from EFT__c where id =:EFTRecord.Id limit 1];

		return EFTRecordList;
	}

	//------------------------------- Createing Case-----------------------------------------------//
	@AuraEnabled
	public static EFT__c createCase(EFT__c EFTRecord){
		system.debug('EFTID===' + EFTRecord.id);
		system.debug('Member_Account__c===' + EFTRecord.Member_Account__c);
		system.debug('Member_Account__r===' + EFTRecord.Member_Account__r.Id);
		system.debug('Member_Name__c===' + EFTRecord.Member_Name__c);
		string AccountNumber;
		if (EFTRecord.Member_Account__c != null){
			AccountNumber = [Select id, name
			                 from account_details__c
			                 where id = :EFTRecord.Member_Account__c].Name;
		} else{
			AccountNumber = AccountNumber = [Select id, name
			                                 from account_details__c
			                                 where id = :EFTRecord.Member_Account__r.Id].Name;
		}
		string firstname, lastname;
		Person_Account__c pa = new Person_Account__c();
		if (EFTRecord.Member_Name__c != null){
			List<string> Names = EFTRecord.Member_Name__c.split(' ');
			if (Names.size() == 2){
				firstname = Names[0]+'%';
				lastname = '%' + Names[1]+'%';
			} else if (Names.size() >= 3){
				firstname = Names[0]+'%';
				lastname = '%' + Names[Names.size()-1]+'%';
			}

			system.debug('firstname' + firstname);
			system.debug('lastname' + lastname);
			system.debug('AccountNumber==' + AccountNumber);

			pa = [SELECT id, name, PersonID__c, Account_Number__c, PersonID__r.name
			      from Person_Account__c
			      where ((PersonID__r.firstname like :firstname AND PersonID__r.LASTNAME like :lastname) OR (PersonID__r.name = :EFTRecord.Member_Name__c)) AND Account_Number__r.name = :AccountNumber
			      limit 1];
		} else{
			system.debug('firstname' + firstname);
			system.debug('lastname' + lastname);
			system.debug('AccountNumber==' + AccountNumber);
			pa = [SELECT id, name, PersonID__c, Account_Number__c, PersonID__r.name
			      from Person_Account__c
			      where Account_Number__r.name = :AccountNumber
			      limit 1];

		}


		list<CaseRecordType__c> scList = [SELECT Id, Primary_Category__c, Secondary_Category__c, Teritiary_Category__c, Record_Type_Name__c, SLA__c, RecordTypeId__c
		                                  FROM CaseRecordType__c
		                                  WHERE Primary_Category__c = 'Account Maintenance' AND Secondary_Category__c = 'Account Services' AND Teritiary_Category__c = 'ACH - Authorization for Debit'
		                                  LIMIT 1];

		Group gp = [select Id, Name
		            from Group
		            where Type = 'Queue' AND NAME = 'DocuSign Queue'];


		case cs = new case();
		for (CaseRecordType__c crt : scList){
			cs.RecordTypeId = scList[0].RecordTypeId__c;
			cs.Primary_Category__c = scList[0].Primary_Category__c;
			cs.Secondary_Category__c = scList[0].Secondary_Category__c;
			cs.Tertiary_Category__c = scList[0].Teritiary_Category__c;
			cs.Sla__c = scList[0].SLA__c;

		}
		//cs.AccountId = EFTRecord.Member_Account__c;
		//cs.Status = 'Waiting for a member';
		cs.Docusign_Envelope_Status__c = 'Sent';
		cs.Subject = 'ACH Record';
		//system.debug('createdby==='+EFTRecord.CreatedBy.Id);
		//cs.ownerid = gp.Id;
		if (pa != null){
			cs.AccountId = pa.PersonID__c;
		}
		//cs.CaseComments__c = casecomment;
		cs.Previous_Owner__c = UserInfo.getUserId();
		string operation = '';
		if (EFTRecord.Action_Type__c == 'Create'){
			operation = 'ACH Record Created' + '\n';
			cs.Subject = 'ACH Record Created';
			cs.Description = operation + 'Member Name:' + EFTRecord.Member_Name__c + '\n' + 'Share/Loan:' + EFTRecord.Share_Loan_Id__c + '\n' + 'ABA/Routing#:' + EFTRecord.Routing_Number__c + '\n' + 'Funding FI:' + EFTRecord.Bank_Name__c + '\n' + 'Account Number:' + EFTRecord.Account_Number__c + '\n' + 'Type:' + EFTRecord.Type__c + '\n' + 'Payment Amount:' + EFTRecord.Payment_Amount__c + '\n' + 'Additional Payment Amount:' + (EFTRecord.Alternate_Amount__c == null ? 0 : EFTRecord.Alternate_Amount__c)+'\n' + 'Effective Date:' + EFTRecord.Effective_Date__c + '\n' + 'Frequency:' + EFTRecord.Frequency__c + '\n' + 'Day of Month:' + EFTRecord.Day_of_Month__c;
		} else if (EFTRecord.Action_Type__c == 'Update' && !EFTRecord.Expired__c){
			operation = 'ACH Record Updated' + '\n';
			cs.Subject = 'ACH Record Updated';
			cs.Description = operation + 'Member Name:' + EFTRecord.Member_Name__c + '\n' + 'Share/Loan:' + EFTRecord.Share_Loan_Id__c + '\n' + 'ABA/Routing#:' + EFTRecord.Routing_Number__c + '\n' + 'Funding FI:' + EFTRecord.Bank_Name__c + '\n' + 'Account Number:' + EFTRecord.Account_Number__c + '\n' + 'Type:' + EFTRecord.Type__c + '\n' + 'Payment Amount:' + EFTRecord.Payment_Amount__c + '\n' + 'Additional Payment Amount:' + (EFTRecord.Alternate_Amount__c == null ? 0 : EFTRecord.Alternate_Amount__c)+'\n' + 'Effective Date:' + EFTRecord.Effective_Date__c + '\n' + 'Frequency:' + EFTRecord.Frequency__c + '\n' + 'Day of Month:' + EFTRecord.Day_of_Month__c;
		} else if (EFTRecord.Action_Type__c == 'Update' && EFTRecord.Expired__c){
			operation = 'ACH Record Expired' + '\n' + 'Expiration Date:' + EFTRecord.Expiration_Date__c + '\n';
			cs.Subject = 'ACH Record Cancelled/Expired';
			cs.Description = operation + 'Member Name:' + EFTRecord.Member_Name__c + '\n' + 'Share/Loan:' + EFTRecord.Share_Loan_Id__c + '\n' + 'ABA/Routing#:' + EFTRecord.Routing_Number__c + '\n' + 'Funding FI:' + EFTRecord.Bank_Name__c + '\n' + 'Account Number:' + EFTRecord.Account_Number__c + '\n' + 'Type:' + EFTRecord.Type__c + '\n' + 'Payment Amount:' + EFTRecord.Payment_Amount__c + '\n' + 'Additional Payment Amount:' + (EFTRecord.Alternate_Amount__c == null ? 0 : EFTRecord.Alternate_Amount__c)+'\n' + 'Effective Date:' + EFTRecord.Effective_Date__c + '\n' + 'Frequency:' + EFTRecord.Frequency__c + '\n' + 'Day of Month:' + EFTRecord.Day_of_Month__c;
		}
		if (EFTRecord.Member_Account__c != null)
			cs.Account_Number__c = EFTRecord.Member_Account__c;
		else
			cs.Account_Number__c = EFTRecord.Member_Account__r.Id;
		insert cs;
		id caseId = cs.id;

		EFTRecord.Case__c = caseId;
		update EFTRecord;


		EFT__c ResultEFTRecord = [select id, name, Member_Account__c, Stage__c, Action_Type__c, Share_Loan_Id__c, Type__c, Share_Loan_Type__c, Share_Loan_Description__c, Routing_Number__c, Bank_Name__c, Account_Number__c, Alternate_Amount__c, Effective_Date__c, EFT_ID_Type__c, EftLocator__c, Frequency__c, Payment_Amount__c, Day_of_Month__c, Second_Day_of_Month__c, Member_Account__r.name, Case__c, Case__r.CaseNumber, Case__r.Status, Expired__c, Expiration_Date__c, Member_Name__c, Docusign_Member_Email__c
		                          from EFT__c
		                          where id = :EFTRecord.id
		                          limit 1];

		List<EFT__c> EFTToSendACHDoc = new List<EFT__c>();
		EFTToSendACHDoc.add(ResultEFTRecord);
		//sendACHDocument(EFTToSendACHDoc);

		system.debug('Member_Account__r.name===' + ResultEFTRecord.Member_Account__r.name);
		system.debug('Member_Account__c===' + ResultEFTRecord.Member_Account__c);
		return ResultEFTRecord;
	}

	//-------------------------------Send ACH Document-----------------------------------------------//
	@AuraEnabled
	public static void sendACHDocument(EFT__c recordId){
		set<Id> Ids = new Set<Id>();
		Ids.add(recordId.Id);
		EFTToDocuSign.docusignAPIcall(Ids);
	}

	//-------------------------------Getting BankName from Entered Routing No-----------------------------------------------//
	@AuraEnabled
	public static string routingInfo(String RoutingNumber){
		system.debug('RoutingNumber==' + RoutingNumber);
		String jsonData;
		HttpRequest req = new HttpRequest();
		String BankName;
		Integer Code;
		//String RoutingNum = '122105155';

		req.setEndpoint('https://www.routingnumbers.info/api/data.json?rn='+RoutingNumber);
		req.setMethod('POST');
		req.setHeader('Content-Type', 'application/json');
		req.setHeader('Accept', 'application/json');

		Http http = new Http();
		req.setTimeout(60000);
		HttpResponse res;
		String responseBody;
		if (!Test.isRunningTest()){
			res = http.send(req);
			responseBody = res.getBody();
			System.debug('Response Body::' + res.getBody());
		} else{
			responseBody = '{"office_code": "O", "telephone": "800-937-6310", "change_date": "061109", "rn": "122105155", "state": "MN", "zip": "55107-1419", "data_view_code": "1", "message": "OK", "address": "EP-MN-WN1A", "customer_name": "US BANK NA", "city": "ST. PAUL"}';
		}

		if (responseBody != ''){
			Map<String, Object> results = (Map<String, Object>)JSON.deserializeUntyped(responseBody);
			System.debug('Service response is ....' + results);


			if (results.size() > 0){

				for (String key : results.keySet()){
					if (key == 'customer_name'){
						BankName = (string)results.get(key);
					}
					if (key == 'code'){
						Code = (Integer)results.get(key);
					}
				}

			}
		}


		System.debug('Bank Name:' + BankName);
		if (Code == 404 || Code == 400){
			BankName = 'Bank name not found';
		}

		return BankName;
	}

	//-------------------------------Getting Share Accounts from Episys----------------------------------------------//
	@AuraEnabled
	public static Map<string, List<ShareLoanWrapperObject>> getShareLoanAccounts(string recordId){
		system.debug('recordId==' + recordId);
		Account_Details__c MemberAccount = [select id, name
		                                    from Account_Details__c
		                                    where id = :recordId
		                                    limit 1];
		String AccountNumber = MemberAccount.name;
		List<ShareLoanWrapperObject> resultList = new List<ShareLoanWrapperObject>();
		Map<string, List<ShareLoanWrapperObject>> resultmap = new Map<string, List<ShareLoanWrapperObject>>();

		httpRequest requestparam = new httpRequest();
		//requestparam.setTimeout(10);
		requestparam.setEndpoint('https://symxapi.chevronfcu.org/devclient/PSAuto/GetSharesEFT?AccountNumber=' + AccountNumber + '&userchar2=abc');
		requestparam.setMethod('GET');

		ACH_Loan_Share_Type_Configuration__c cs = ACH_Loan_Share_Type_Configuration__c.getValues('Share');
		string shareTypes = (string)cs.Type__c;
		//system.debug('shareTypes==' + shareTypes);
		String[] arrShareTypes = shareTypes.split(',');

		CalculateBusinessDays cbd = new CalculateBusinessDays();
		Datetime Next3BusinessDay = cbd.AddDays(DateTime.newInstance(System.today(), Time.newInstance(0, 0, 0, 0)), 3);

		try{
			http httpParam = new http();
			httpResponse response = httpParam.send(requestparam);

			String strStatus = response.getStatus();
			String strBody = response.getBody();

			System.debug('strStatus ....' + strStatus);
			System.debug('strBody ....' + strBody);

			Set<string> uniqueShareLoanIdSet = new Set<string>();
			if (strBody != ''){
				List<Object> results = (List<Object>)JSON.deserializeUntyped(response.getBody());
				System.debug('Service response is ....' + results);

				if (results != null){
					for (Object t : results){
						ShareLoanWrapperObject temp = new ShareLoanWrapperObject();
						map<string, object> localAcc = (map<string, object>)t;
						string accouttype = (string)localAcc.get('AccountType');
						string ShareId = accouttype.split(' ')[1].replace('#', '');
						//System.debug('ShareId ....' + ShareId);
						if (ShareId != '0' && arrShareTypes.contains(string.valueof(ShareId).leftPad(4, '0').substring(0, 2))){
							//&& ShareId == 2800
							temp.ShareLoanID = ShareId;
							temp.ShareLoanIDString = 'S' + ShareId;
							temp.Description = (string)localAcc.get('Description');
							temp.TypeTranslate = (string)localAcc.get('Description');
							temp.UserChar3 = (string)localAcc.get('UserChar3');
							if(uniqueShareLoanIdSet.contains(ShareId)){
								temp.isDisabled = true;
							}
							else{
								temp.isDisabled = false;
								List<EFT__c> TotalEfts = getEFTRecordsforShareLoan1(recordId,ShareId,'Create','');
								if(TotalEfts.size() > 0){
									uniqueShareLoanIdSet.add(ShareId);
								}								
							}

							temp.Type = 'Share';

							map<string, string> resultDate = getTrackingRecordforShare(AccountNumber, ShareId);
							if (resultDate != null){
								temp.NextPaymentDueDate = date.valueOf(resultDate.get('UserDate1'));
								System.debug('UserAmount2 ....' + decimal.valueOf(resultDate.get('Payment')));
								temp.Payment = decimal.valueOf(resultDate.get('Payment'));
							}

							temp.EffectiveDate = date.newinstance(Next3BusinessDay.year(), Next3BusinessDay.month(), Next3BusinessDay.day());

							if (temp.EffectiveDate != null)
								temp.EFTPaymentDate = getEFTPaymentDate(temp.EffectiveDate, 1);
							resultList.add(temp);
						}
					}
				}

				set<string> ShareIds = new set<string>();
				map<string, string> LoanIdTypeTranslateMap = new map<string, string>();
				for (ShareLoanWrapperObject obj : resultList){
					ShareIds.add(obj.ShareLoanID.substring(0, 2).replaceFirst('^0+', ''));
					// system.debug('sdsf'==string.valueof(obj.ShareLoanID).substring(0, 2));
				}
				//system.debug('LoanIds==' + ShareIds);
				List<EFT_ShareLoan_TypeTranslate__c> listTT = [select name, Code__c, RecType__c, TypeTranslate__c
				                                               from EFT_ShareLoan_TypeTranslate__c
				                                               where Code__c in :ShareIds and RecType__c = 'SHAR'];

				system.debug('listTT==' + listTT);
				for (EFT_ShareLoan_TypeTranslate__c t : listTT){
					LoanIdTypeTranslateMap.put(t.Code__c, t.TypeTranslate__c);
				}

				for (ShareLoanWrapperObject obj : resultList){
					string typetrans = LoanIdTypeTranslateMap.get(obj.ShareLoanID.substring(0, 2).replaceFirst('^0+', ''));
					obj.TypeTranslate = typetrans;
					//System.debug('typetrans ....' + typetrans);
				}
			}

			map<string,integer> ShareLoanIDEFTCountMap = new map<string,integer>();
			if(!String.isBlank(recordId)){
				List<EFT__c> ListAllEFT = getEFTRecordsEpisys(recordId);
				if (ListAllEFT.size() > 0){
					for (EFT__C e : ListAllEFT){
						if(ShareLoanIDEFTCountMap.containsKey(e.Share_Loan_Id__c)){
							ShareLoanIDEFTCountMap.put(e.Share_Loan_Id__c,ShareLoanIDEFTCountMap.get(e.Share_Loan_Id__c)+1);
						}
						else{
							ShareLoanIDEFTCountMap.put(e.Share_Loan_Id__c,1);
						}
					}
				}
			}

			Map<string, List<ShareLoanWrapperObject>> LoanList = getLoanAccounts(AccountNumber, recordId);
			if (!LoanList.ContainsKey('Exception')){
				resultList.addall(LoanList.get('LoanList'));
				for(ShareLoanWrapperObject sl: resultList){
					if(ShareLoanIDEFTCountMap.get(sl.ShareLoanID) > 1){
						sl.isDisabled = true;
					}
					else{
						sl.isDisabled = false;																
					}
				}
				resultmap.put('ShareLoanList', resultList);
				//system.debug('resultList==' + resultList);
			} else{
				resultmap.put('Exception', resultList);
			}

		} catch (System.CalloutException e){
			system.debug('Exception');
			resultmap.put('Exception', resultList);
		}
		return resultmap;
	}

	//-------------------------------Getting Loan Accounts from Episys----------------------------------------------//
	public static Map<string, List<ShareLoanWrapperObject>> getLoanAccounts(string AccountNumber, string recordId){
		//system.debug('AccountNumber==' + AccountNumber);
		List<ShareLoanWrapperObject> resultList = new List<ShareLoanWrapperObject>();
		Map<string, List<ShareLoanWrapperObject>> resultmap = new Map<string, List<ShareLoanWrapperObject>>();

		CalculateBusinessDays cbd = new CalculateBusinessDays();
		Datetime Next3BusinessDay = cbd.AddDays(DateTime.newInstance(System.today(), Time.newInstance(0, 0, 0, 0)), 3);
		System.debug('Next3BusinessDay ....' + Next3BusinessDay);
		System.debug('Next3BusinessDay.day() ....' + Next3BusinessDay.day());

		try{
			httpRequest requestparam = new httpRequest();
			//requestparam.setTimeout(10);
			requestparam.setEndpoint('https://symxapi.chevronfcu.org/devclient/PsAuto/GetLoansSelectFields?AccountNumber=' + AccountNumber);
			requestparam.setMethod('GET');

			ACH_Loan_Share_Type_Configuration__c cs = ACH_Loan_Share_Type_Configuration__c.getValues('Loan');
			string loanTypes = (string)cs.Type__c;
			String[] arrLoanTypes = loanTypes.split(',');
			system.debug('arrLoanTypes==' + arrLoanTypes);


			http httpParam = new http();
			httpResponse response = httpParam.send(requestparam);

			String strStatus = response.getStatus();
			String strBody = response.getBody();

			//System.debug('strStatus1 ....' + strStatus);
			//System.debug('strBody1 ....' + strBody);

			map<string,integer> LoanIDEFTCountMap = new map<string,integer>();
			

			if (strBody != ''){
				List<Object> results = (List<Object>)JSON.deserializeUntyped(response.getBody());
				System.debug('Service response is1 ....' + results);


				if (results.size() > 0){

					for (Object t : results){
						ShareLoanWrapperObject temp = new ShareLoanWrapperObject();
						map<string, object> localAcc = (map<string, object>)t;
						string LoanId = string.valueof(localAcc.get('LoanId'));
						System.debug('Service response is ....' + LoanId);
						if (LoanId != '0' && arrLoanTypes.contains(string.valueof(LoanId).leftPad(4, '0').substring(0, 2))){
							temp.ShareLoanID = LoanId;
							temp.ShareLoanIDString = 'L' + LoanId;
							temp.Description = (string)localAcc.get('Description');
							//temp.TypeTranslate =  (string)localAcc.get('Description');						
							
							temp.Type = 'Loan';
							temp.Payment = (decimal)localAcc.get('Payment');
							if ((string)localAcc.get('DueDate') != '')
								temp.NextPaymentDueDate = Date.ValueOf((string)localAcc.get('DueDate'));
							temp.Day2 = (integer)localAcc.get('DueDay2');
							if ((string)localAcc.get('LoanCode') != ''){
								temp.LoanCode = (string)localAcc.get('LoanCode');
							}
							if ((string)localAcc.get('DueDate') != '' && (temp.LoanCode == '0' || temp.LoanCode == '1' || temp.LoanCode == '2'))
								temp.Day1 = temp.NextPaymentDueDate.Day();
							temp.EffectiveDate = date.newinstance(Next3BusinessDay.year(), Next3BusinessDay.month(), Next3BusinessDay.day());
							System.debug('temp.EffectiveDate ....' + temp.EffectiveDate);

							if (temp.EffectiveDate != null && temp.Day1 != null)
								temp.EFTPaymentDate = getEFTPaymentDate(temp.EffectiveDate, temp.Day1);
							//(integer)localAcc.get('DueDay1');
							temp.AlternatePayment = (decimal)localAcc.get('AlternatePayment');
							resultList.add(temp);
							System.debug('temp ....' + temp);
						}
					}

					set<string> LoanIds = new set<string>();
					map<string, string> LoanIdTypeTranslateMap = new map<string, string>();
					for (ShareLoanWrapperObject obj : resultList){
						LoanIds.add(string.valueof(obj.ShareLoanID).leftPad(4, '0').substring(0, 2));
						// system.debug('sdsf'==string.valueof(obj.ShareLoanID).substring(0, 2));
					}
					system.debug('LoanIds==' + LoanIds);
					List<EFT_ShareLoan_TypeTranslate__c> listTT = [select name, Code__c, RecType__c, TypeTranslate__c
					                                               from EFT_ShareLoan_TypeTranslate__c
					                                               where Code__c in :LoanIds and RecType__c = 'LOAN'];

					system.debug('listTT==' + listTT);
					for (EFT_ShareLoan_TypeTranslate__c t : listTT){
						LoanIdTypeTranslateMap.put(t.Code__c, t.TypeTranslate__c);
					}

					for (ShareLoanWrapperObject obj : resultList){
						string typetrans = LoanIdTypeTranslateMap.get(string.valueof(obj.ShareLoanID).leftPad(4, '0').substring(0, 2));
						obj.TypeTranslate = typetrans;
						//System.debug('typetrans ....' + typetrans);
					}
				}
			}
			resultmap.put('LoanList', resultList);
		} catch (System.CalloutException e){
			resultmap.put('Exception', resultList);
		}

		return resultmap;
	}

	@AuraEnabled
	public static List<EFT__c> getEFTRecordsEpisys(string recordId){
		system.debug('recordId==' + recordId);
		Account_Details__c MemberAccount = [select id, name
		                                    from Account_Details__c
		                                    where id = :recordId
		                                    limit 1];
		String AccountNumber = MemberAccount.name;

		List<EFT__c> SFEFT = [Select id, EftLocator__c
		                      from EFT__c
		                      where Member_Account__r.Name = :AccountNumber];
		map<string, id> EFTLocatorsMap = new map<string, id>();
		set<string> EFTLocatorsset = new set<string>();
		map<string, decimal> LoanIDPaymentMap = new map<string, decimal>();
		map<string, decimal> LoanIDAlternatePaymentMap = new map<string, decimal>();
		map<string, Date> LoanIDNextPaymentDueDateMap = new map<string, Date>();
		CalculateBusinessDays cbd = new CalculateBusinessDays();
		Datetime Next3BusinessDay = cbd.AddDays(DateTime.newInstance(System.today(), Time.newInstance(0, 0, 0, 0)), 3);

		for (EFT__c e : SFEFT){
			EFTLocatorsMap.put(e.EftLocator__c, e.id);
			EFTLocatorsset.add(e.EftLocator__c);
		}

		Map<string, List<ShareLoanWrapperObject>> LoanMap = getLoanAccounts(AccountNumber,'');
		List<EFTController.ShareLoanWrapperObject> LoanList = LoanMap.get('LoanList');
		if (LoanList != null){
			for (ShareLoanWrapperObject sl : LoanList){
				LoanIDPaymentMap.put(sl.ShareLoanID.leftPad(4, '0'), sl.Payment);
				LoanIDNextPaymentDueDateMap.put(sl.ShareLoanID.leftPad(4, '0'), sl.NextPaymentDueDate);
				LoanIDAlternatePaymentMap.put(sl.ShareLoanID.leftPad(4, '0'), sl.AlternatePayment);
			}
		}

		httpRequest requestparam = new httpRequest();
		requestparam.setEndpoint('https://symxapi.chevronfcu.org/devclient/EFT/GetEftRecords?accountNumber=' + AccountNumber);
		requestparam.setMethod('GET');

		ACH_Loan_Share_Type_Configuration__c cs = ACH_Loan_Share_Type_Configuration__c.getValues('Loan');
		string loanTypes = (string)cs.Type__c;
		String[] arrLoanTypes = loanTypes.split(',');

		ACH_Loan_Share_Type_Configuration__c cs1 = ACH_Loan_Share_Type_Configuration__c.getValues('Share');
		string shareTypes = (string)cs1.Type__c;
		String[] arrShareTypes = shareTypes.split(',');

		http httpParam = new http();
		httpResponse response = httpParam.send(requestparam);

		String strStatus = response.getStatus();
		String strBody = response.getBody();

		System.debug('strStatus ....' + strStatus);
		System.debug('strBody ....' + strBody);

		//set<string> EFTLocatorsSet = new set<string>();
		set<string> MemberNumbers = new set<string>();
		List<EFT__c> EFTList = new List<EFT__c>();
		if (strBody != ''){
			List<Object> results = (List<Object>)JSON.deserializeUntyped(response.getBody());
			System.debug('Service response is ....' + results);

			for (Object t : results){
				EFTWrapperObject temp = new EFTWrapperObject();
				map<string, object> localAcc = (map<string, object>)t;
				MemberNumbers.add(String.valueOf(localAcc.get('AccountNumber')));
			}

			map<string, string> mapAccountIdName = new map<string, string>();
			List<account_details__c> MemberAccountsList = [select id, name
			                                               from account_details__c
			                                               where name in :MemberNumbers and RecType__c = 'ACCT'];
			if (MemberAccountsList.size() > 0){
				for (account_details__c s : MemberAccountsList){
					mapAccountIdName.put(s.Name, s.Id);
				}
			}

			for (Object t : results){

				map<string, object> localAcc = (map<string, object>)t;
				System.debug('localAcc' + localAcc.get('IdType'));
				if (String.valueOf(localAcc.get('ExpirationDate')) == null || String.valueOf(localAcc.get('ExpirationDate')) == ''){
					string lsId = '';
					if (localAcc.get('Id') != null && localAcc.get('Id') != ''){
						lsId = String.valueOf(localAcc.get('Id')).substring(0, 2);
						//System.debug('lsId ....' + lsId);
					}
					if ((arrShareTypes.contains(lsId) && (string)localAcc.get('IdType') == '0') || (arrLoanTypes.contains(lsId) && (string)localAcc.get('IdType') == '1')){
						EFTWrapperObject temp = new EFTWrapperObject();
						EFT__c objEFT = new EFT__c();
						if (arrShareTypes.contains(lsId) && (string)localAcc.get('IdType') == '0'){
							//System.debug('Share ....');
							objEFT.EFT_ID_Type__c = 'Share';
							map<string, string> resultAmount = getTrackingRecordforShare(AccountNumber, String.valueOf(localAcc.get('Id')));
							if (resultAmount != null){
								if (String.valueOf(resultAmount.get('Payment')) != null)
									objEFT.Payment_Amount__c = decimal.valueOf(resultAmount.get('Payment'));
								objEFT.Alternate_Amount__c = decimal.valueOf(resultAmount.get('AlternateAmount'));
								objEFT.Next_Payment_Due_Date__c = Date.valueOf(resultAmount.get('UserDate1'));
								if (String.valueOf(localAcc.get('Amount')) != null)
									objEFT.Existing_Alternate_Amount__c = Decimal.valueOf(String.valueOf(localAcc.get('Amount')));
							}

						} else if (arrLoanTypes.contains(lsId) && (string)localAcc.get('IdType') == '1'){
							// System.debug('Loan ....');
							objEFT.EFT_ID_Type__c = 'Loan';
							objEFT.Payment_Amount__c = LoanIDPaymentMap.get(String.valueOf(localAcc.get('Id')));
							objEFT.Alternate_Amount__c = Decimal.valueOf(String.valueOf(localAcc.get('Amount')));
							objEFT.Next_Payment_Due_Date__c = LoanIDNextPaymentDueDateMap.get(String.valueOf(localAcc.get('Id')));
							objEFT.Existing_Alternate_Amount__c = LoanIDAlternatePaymentMap.get(String.valueOf(localAcc.get('Id'))) - LoanIDPaymentMap.get(String.valueOf(localAcc.get('Id')));
						}
						string bankname = String.valueOf(localAcc.get('Payee'));
						System.debug('Payment_Amount__c==' + String.valueOf(localAcc.get('Payment')));
						if (bankname.length() == 10 && bankname.startsWith('0'))
							bankname = bankname.removeStart('0');
						objEFT.Routing_Number__c = bankname;
						objEFT.Account_Number__c = String.valueOf(localAcc.get('Reference'));


						objEFT.Effective_Date__c = date.newinstance(Next3BusinessDay.year(), Next3BusinessDay.month(), Next3BusinessDay.day());
						//if (String.valueOf(localAcc.get('EffectiveDate')) != '' && String.valueOf(localAcc.get('EffectiveDate')) != null)
						//objEFT.Effective_Date__c = Date.valueOf(String.valueOf(localAcc.get('EffectiveDate')));
						if (String.valueOf(localAcc.get('Frequency')) == '5')
							objEFT.Frequency__c = 'Semi-Monthly';
						else
							objEFT.Frequency__c = 'Monthly';
						objEFT.Day_of_Month__c = String.valueOf(localAcc.get('Day1'));
						objEFT.Second_Day_of_Month__c = String.valueOf(localAcc.get('Day2'));
						objEFT.Bank_Name__c = String.valueOf(localAcc.get('FinancialInstitution'));
						objEFT.Share_Loan_Id__c = String.valueOf(localAcc.get('Id'));
						//system.debug('EftLocator__c=='+String.valueOf(localAcc.get('EftLocator')));

						objEFT.EftLocator__c = String.valueOf(localAcc.get('EftLocator'));

						if (String.valueOf(localAcc.get('AmountCode')) == '37')
							objEFT.Type__c = 'Savings';
						else
							objEFT.Type__c = 'Checking';
						if (String.valueOf(localAcc.get('ExpirationDate')) != null && String.valueOf(localAcc.get('ExpirationDate')) != ''){
							Date expDate = Date.valueOf(String.valueOf(localAcc.get('ExpirationDate')));
							//if(expDate <= Date.today())
							objEFT.expired__c = true;
						}

						if (objEFT.Effective_Date__c != null && objEFT.Day_of_Month__c != null)
							objEFT.EFT_Payment_Date__c = getEFTPaymentDate(objEFT.Effective_Date__c, Integer.valueof(objEFT.Day_of_Month__c));
						//system.debug('Day1=='+String.valueOf(localAcc.get('Day1'))) ;
						//objEFT.EftLocator__c = String.valueOf(localAcc.get('EftLocator__c'));
						objEFT.Member_Account__r = new account_details__c(id = mapAccountIdName.get(String.valueOf(localAcc.get('AccountNumber'))), Name = String.valueOf(localAcc.get('AccountNumber')));//mapAccountIdName.get(String.valueOf(localAcc.get('AccountNumber')));


						if (EFTLocatorsMap.get(String.valueOf(localAcc.get('EftLocator'))) != null){
							//SFEFT.size() > 0
							objEFT.id = EFTLocatorsMap.get(String.valueOf(localAcc.get('EftLocator')));
						}


						EFTList.add(objEFT);
					}
				}
			}


		}

		return EFTList;
	}

	@AuraEnabled
	public static map<string, object> getEpisysEmailAddresses(string recordId){
		system.debug('recordId==' + recordId);
		Account_Details__c MemberAccount = [select id, name
		                                    from Account_Details__c
		                                    where id = :recordId
		                                    limit 1];
		String AccountNumber = MemberAccount.name;
		set<string> setEmailIds = new set<string>();
		set<string> setEmailNames = new set<string>();
		List<EpisysAccountDetailsWrapper> listAccounts = new List<EpisysAccountDetailsWrapper>();
		set<EpisysAccountDetailsWrapper> listResultAccounts = new set<EpisysAccountDetailsWrapper>();

		set<string> typeList = new set<string>();
		for (Member360_TypeTranslate__c t : Member360_TypeTranslate__c.getAll().values()){
			typeList.add(t.name.substring(0,4));
		}	
		
		system.debug('typeList==' + typeList);

		Person_Account__c paPrimary = [SELECT Id, PersonID__c, Account_Number__c, Account_Number__r.RecType__c, TypeTranslate__c, Account_Number__r.Name, PersonID__r.Home_Phone__pc, PersonID__r.Residential_City__pc, PersonID__r.Residential_State__pc, PersonID__r.Residential_Street__pc, PersonID__r.Residential_Zipocde__pc, PersonID__r.Name, PersonID__r.Email_raw__c, PersonID__r.PersonID__c
		                               FROM Person_Account__c
		                               WHERE (Account_Number__r.Name = :recordId OR Account_Number__r.Name = :MemberAccount.Name) and TypeTranslate__c like '%Primary%'
		                               limit 1];

		string primaryName = '', SSN;
		if (paPrimary != null){

			SSN = paPrimary.PersonID__r.PersonID__c.substring(1);
			primaryName = paPrimary.PersonID__r.Name.replace(' ', '%20')+'|' + SSN;
		}	


		system.debug('primaryName==' + primaryName);
		system.debug('AccountNumber==' + AccountNumber);
		system.debug('SSN==' + SSN);
		httpRequest requestparam = new httpRequest();
		requestparam.setEndpoint('https://symxapi.chevronfcu.org/devclient/EFT/GetAddress');// + AccountNumber +'&FullNameStringList=' + primaryName +'&FullName=' + SSN);
		requestparam.setMethod('POST');
		requestparam.setHeader('Content-Type', 'application/json');
		requestparam.setHeader('Accept', 'application/json');
		requestparam.setHeader('Content-Length', '162100');
		string jsonData = '{"AccountNumber":' + '\"' + AccountNumber + '\","FullNameStringList":' + '\"' + primaryName + '\"' + ',"FullName":' + '\"' + SSN + '\"' + ',"IsIncludeMailAddresses":' + '\"' + 'true' + '\"}';
		requestparam.setBody(jsonData);
		system.debug('jsonData==' + jsonData);
		Http httpParam = new Http();

		//requestparam.setTimeout(60000);
		HttpResponse response;
		String responseBody1;
		if (!Test.isRunningTest()){
			response = httpParam.send(requestparam);
			responseBody1 = response.getBody();
			System.debug('Response Body ACH::' + response.getBody());
		}
		//http httpParam = new http();
		//httpResponse response = httpParam.send(jsonData);

		String strStatus = response.getStatus();
		String strBody = response.getBody();

		System.debug('strStatus ....' + strStatus);
		System.debug('strBody ....' + strBody);

		set<string> EFTLocatorsSet = new set<string>();
		set<string> MemberNumbers = new set<string>();
		List<EFT__c> EFTList = new List<EFT__c>();
		if (strBody != ''){
			List<Object> results = (List<Object>)JSON.deserializeUntyped(response.getBody());
			System.debug('Service response is ....' + results);


			for (Object t : results){

				map<string, object> localAcc = (map<string, object>)t;
				string AccType= String.valueof((Integer)localAcc.get('type')).leftPad(4, '0');
				//AccType= String.valueof(AccType).leftPad(4, '0');
				System.debug('type ....' + AccType);
				System.debug('localAcc ....' + localAcc.get('email'));
				System.debug('altemail ....' + localAcc.get('altemail'));
				string emailid = (string)localAcc.get('email');
				string altemail = (string)localAcc.get('altemail');
				if (typeList.contains(AccType)){
					//!setEmailIds.contains(emailid) && emailid!= ''
					setEmailIds.add((string)localAcc.get('email'));
					if (emailid != '' && emailid.contains('@'))
						setEmailNames.add(emailid + ',' + (string)localAcc.get('fullname'));
					if ((string)localAcc.get('altemail') != '' && (string)localAcc.get('altemail') != null && altemail.contains('@'))
						setEmailNames.add((string)localAcc.get('altemail')+',' + (string)localAcc.get('fullname'));
					//     setEmailIds.add((string)localAcc.get('altemail'));
					EpisysAccountDetailsWrapper tmp = new EpisysAccountDetailsWrapper();
					tmp.EmailId = (string)localAcc.get('email');
					tmp.AccountType = (string)localAcc.get('accountTypeName');
					tmp.FullName = (string)localAcc.get('fullname');
					tmp.AltEmailId = (string)localAcc.get('altemail');
					listAccounts.add(tmp);
				}

				/*
				 if(emailid != null && emailid != ''){
				 setEmailIds.add(emailid);
				 }  */
			}
		}
		system.debug('setEmailNames==' + setEmailNames);
		for (Integer i = 0; i < listAccounts.size(); i++){
			system.debug('1==' + listAccounts[i].EmailId + ',' + listAccounts[i].fullname);
			system.debug('2==' + listAccounts[i].AltEmailId + ',' + listAccounts[i].fullname);
			if (setEmailNames.contains(listAccounts[i].EmailId + ',' + listAccounts[i].fullname)){
				EpisysAccountDetailsWrapper tmp = new EpisysAccountDetailsWrapper();
				tmp.EmailId = listAccounts[i].EmailId;
				tmp.AccountType = listAccounts[i].AccountType;
				tmp.FullName = listAccounts[i].fullname;
				listResultAccounts.add(tmp);
			}
			if (setEmailNames.contains(listAccounts[i].AltEmailId + ',' + listAccounts[i].fullname) && listAccounts[i].AltEmailId != listAccounts[i].EmailId){
				EpisysAccountDetailsWrapper tmp1 = new EpisysAccountDetailsWrapper();
				tmp1.EmailId = listAccounts[i].AltEmailId;
				tmp1.AccountType = listAccounts[i].AccountType;
				tmp1.FullName = listAccounts[i].fullname;
				listResultAccounts.add(tmp1);
			}
		}

		system.debug('listResultAccounts==' + listResultAccounts);
		map<string, object> returnmap = new map<string, object>();
		returnmap.put('EmailIds', listResultAccounts);
		return returnmap;
	}

	@AuraEnabled
	//get Account Industry Picklist Values
	public static Map<String, String> getDaysofMonth(){
		Map<String, String> options = new Map<String, String>();

		Schema.DescribeFieldResult fieldResult = EFT__c.Day_of_Month__c.getDescribe();
		List<Schema.PicklistEntry> pList = fieldResult.getPicklistValues();
		for (Schema.PicklistEntry p : pList){
			options.put(p.getValue(), p.getLabel());
		}
		return options;
	}

	@AuraEnabled
	public static Id saveSignature(String signatureBody, string EFTId, EFT__c EFTRecord){
		system.debug('EFTRecord.EftLocator__c==' + EFTRecord.EftLocator__c);
		Attachment a = new Attachment();
		a.ParentId = EFTId; // record id of object.
		a.Body = EncodingUtil.base64Decode(signatureBody);
		a.ContentType = 'image/png';
		a.Name = 'ESignature.png';
		insert a;


		saveStageData(EFTRecord);
		Set<id> ids = new Set<id>();
		ids.add(EFTId);
		if (EFTRecord.EftLocator__c == null)
			EFTToSyimtar.insertEFTs(ids);
		else
			EFTToSyimtar.UpdateEFT(ids, false);
		return a.Id;
	}

	@RemoteAction
	public static Id saveSignature(String signatureBody, id parentId){
		Attachment a = new Attachment();
		a.ParentId = parentId; // record id of object.
		a.Body = EncodingUtil.base64Decode(signatureBody);
		a.ContentType = 'image/png';
		a.Name = 'ESignature.png';
		insert a;
		return a.Id;
	}

	public PageReference attach(){
		Attachment myAttach = new Attachment();
		myAttach.ParentId = ACH.Id;//Id of the object to which the page is attached
		myAttach.name = 'ACH DIRECT PAYMENT AUTHORIZATION.pdf';
		PageReference myPdf = ApexPages.currentPage();//myPdfPage is the name of your pdf page
		myAttach.body = myPdf.getContentAsPdf();
		insert myAttach;

		List<Attachment> signatures = new List<Attachment>();
		signatures = [SELECT Id
		              FROM Attachment
		              Where ParentId = :ACH.Id and Name = 'ESignature.png'
		              Order by CreatedDate desc
		              OFFSET 1];
		if (signatures.size() > 0){
			delete signatures;
		}

		List<Attachment> eSignPdfs = new List<Attachment>();
		eSignPdfs = [SELECT Id
		             FROM Attachment
		             Where ParentId = :ACH.Id and Name = 'ACH DIRECT PAYMENT AUTHORIZATION.pdf'
		             Order by CreatedDate desc
		             OFFSET 1];
		if (eSignPdfs.size() > 0){
			delete eSignPdfs;
		}

		ApexPages.addmessage(new ApexPages.message(ApexPages.severity.CONFIRM, 'ACH Direct Payment Authorization pdf has been generated successfully.'));

		PageReference pageRef = new PageReference('/' + objParentId);
		pageRef.setRedirect(true);
		return pageRef;
	}

	public PageReference Cancel(){
		PageReference pageRef = new PageReference('/' + objParentId);
		pageRef.setRedirect(true);
		return pageRef;
	}

	@AuraEnabled
	public static map<string, string> getTrackingRecordforShare(string AccountNumber, string ShareID){
		system.debug('AccountNumber==' + AccountNumber);
		system.debug('ShareID==' + ShareID);

		map<string, string> resultAmount = new map<string, string>();
		httpRequest requestparam = new httpRequest();
		//requestparam.setTimeout(10);
		requestparam.setEndpoint('https://symxapi.chevronfcu.org/devclient/PSAuto/GetTrackingRecords?accountNumber=' + AccountNumber);
		requestparam.setMethod('GET');

		try{
			http httpParam = new http();
			httpResponse response = httpParam.send(requestparam);

			String strStatus = response.getStatus();
			String strBody = response.getBody();

			System.debug('strStatustracking ....' + strStatus);
			System.debug('strBodytracking ....' + strBody);

			if (strBody != ''){
				List<Object> results = (List<Object>)JSON.deserializeUntyped(response.getBody());
				System.debug('Service response is ....' + results);

				if (results != null){
					for (Object t : results){
						map<string, object> localAcc = (map<string, object>)t;
						integer trackingtype = (integer)localAcc.get('Type');
						string userchar1 = (string)localAcc.get('UserChar1');
						string userchar3 = EFTToSyimtar.getUserChar3(AccountNumber, ShareID);
						if (trackingtype == 32 && userchar1 == userchar3){
							//&& ShareId == 2800
							string AlternateAmount, Payment;
							string UserDate1;
							Payment = string.valueof(localAcc.get('UserAmount2'));
							AlternateAmount = string.valueof(localAcc.get('UserAmount10'));
							UserDate1 = (string)localAcc.get('UserDate1');
							System.debug('UserDate1 ....' + (string)localAcc.get('UserDate1'));
							resultAmount.put('Payment', Payment);
							resultAmount.put('AlternateAmount', AlternateAmount);
							resultAmount.put('UserDate1', UserDate1);
						}
					}
				}
			}
		} catch (System.CalloutException e){
			system.debug('Exception');

		}
		return resultAmount;
	}

	@AuraEnabled
	public static Date getEFTPaymentDate(Date EffectiveDate, Integer Day1){
		integer EffectiveDateDay = EffectiveDate.day();
		Date EFTPaymentDate;
		if (EffectiveDateDay > Day1){
			EFTPaymentDate = date.newinstance(EffectiveDate.year(), EffectiveDate.month()+1, Day1);
		} else{
			EFTPaymentDate = date.newinstance(EffectiveDate.year(), EffectiveDate.month(), Day1);
		}
		return EFTPaymentDate;
	}

	@AuraEnabled
	public static map<string, string> CheckValidEffectiveDate(Date EnteredEffectiveDate){
		CalculateBusinessDays cbd = new CalculateBusinessDays();
		Datetime Next3BusinessDay = cbd.AddDays(DateTime.newInstance(System.today(), Time.newInstance(0, 0, 0, 0)), 3);
		Date FirstAvailavleEffectiveDate = date.newinstance(Next3BusinessDay.year(), Next3BusinessDay.month(), Next3BusinessDay.day());
		map<string, string> resulMap = new map<string, string>();

		if (EnteredEffectiveDate < FirstAvailavleEffectiveDate){
			resulMap.put('isValid', 'false');
			resulMap.put('ErrorMessage', 'Effective Date can not be less than ' + string.valueof(Next3BusinessDay.format('MM/dd/yyyy'))+'.');
		} else{
			resulMap.put('isValid', 'true');
			resulMap.put('ErrorMessage', '');
		}
		return resulMap;
	}

	// @AuraEnabled
	// public static List<EFT__c> getEFTRecordsforShareLoan(string recordId, string ShareLoanID, string Operation, string EFTLocator){
	//     system.debug('Operation=='+Operation);
	//     system.debug('EFTLocator=='+EFTLocator);
	//     system.debug('ShareLoanID=='+ShareLoanID);
	//     system.debug('recordId=='+recordId);
	//     List<EFT__c> ListAllEFT = getEFTRecordsEpisys(recordId);
	//     List<EFT__c> resultEFT = new List<EFT__c>();
	//     if (ListAllEFT.size() > 0){
	//         for (EFT__C e : ListAllEFT){
	//             if (Operation == 'Create' && e.Share_Loan_Id__c == ShareLoanID){
	//                 resultEFT.add(e);
	//             }
	//             else if(Operation == 'Update' && e.Share_Loan_Id__c == ShareLoanID && e.EftLocator__c != EFTLocator){
	//                 resultEFT.add(e);
	//             }
	//         }
	//     }
	//     return resultEFT;
	// }
	@AuraEnabled
	public static List<EFT__c> getEFTRecordsforShareLoan1(string re, string sh, string op, string ef){
		system.debug('Operation==' + op);
		system.debug('EFTLocator==' + ef);
		system.debug('ShareLoanID==' + sh);
		system.debug('recordId==' + re);

		sh = sh.leftPad(4, '0');

		List<EFT__c> ListAllEFT = getEFTRecordsEpisys(re);
		List<EFT__c> resultEFT = new List<EFT__c>();

		if (ListAllEFT.size() > 0){
			for (EFT__C e : ListAllEFT){
				if (op == 'Create' && e.Share_Loan_Id__c == sh){
					resultEFT.add(e);
				} else if (op == 'Update' && e.Share_Loan_Id__c == sh && e.EftLocator__c != ef){
					resultEFT.add(e);
				}
			}
		}

		return resultEFT;
	}

	public class ShareLoanWrapperObject{
		@AuraEnabled
		public String ShareLoanID{ get; set; }

		@AuraEnabled
		public string Description{ get; set; }

		@AuraEnabled
		public string TypeTranslate{ get; set; }

		@AuraEnabled
		public string Type{ get; set; }

		@AuraEnabled
		public string ShareLoanIDString{ get; set; }

		@AuraEnabled
		public decimal Payment{ get; set; }

		@AuraEnabled
		public Date EffectiveDate{ get; set; }

		@AuraEnabled
		public integer Day1{ get; set; }

		@AuraEnabled
		public integer Day2{ get; set; }

		@AuraEnabled
		public string LoanCode{ get; set; }

		@AuraEnabled
		public string UserChar3{ get; set; }

		@AuraEnabled
		public Date NextPaymentDueDate{ get; set; }

		@AuraEnabled
		public Date EFTPaymentDate{ get; set; }

		@AuraEnabled
		public decimal AlternatePayment{ get; set; }

		@AuraEnabled
		public boolean isDisabled{ get; set; }
	}

	public class EFTWrapperObject{
		@AuraEnabled
		public Integer EftLocator{ get; set; }

		@AuraEnabled
		public string AccountNumber{ get; set; }

		@AuraEnabled
		public string AmountCode{ get; set; }

		@AuraEnabled
		public string Amount{ get; set; }

		@AuraEnabled
		public string FinancialInstitution{ get; set; }

		@AuraEnabled
		public string MatchID3{ get; set; }

		@AuraEnabled
		public string Locator{ get; set; }

		@AuraEnabled
		public string Payee{ get; set; }

		@AuraEnabled
		public string Reference{ get; set; }

		@AuraEnabled
		public string EffectiveDate{ get; set; }

		@AuraEnabled
		public string Day1{ get; set; }

		@AuraEnabled
		public string Frequency{ get; set; }

		@AuraEnabled
		public string Status{ get; set; }

		@AuraEnabled
		public string Error{ get; set; }

		@AuraEnabled
		public string ErrorDetails{ get; set; }

		@AuraEnabled
		public string ExpirationDate{ get; set; }

		@AuraEnabled
		public string Id{ get; set; }

		@AuraEnabled
		public string IdType{ get; set; }

		@AuraEnabled
		public string PostAmount{ get; set; }
	}

	public class EpisysAccountDetailsWrapper{
		@AuraEnabled
		public string EmailId{ get; set; }

		@AuraEnabled
		public string AccountType{ get; set; }

		@AuraEnabled
		public string FullName{ get; set; }

		@AuraEnabled
		public string AltEmailId{ get; set; }
	}
}