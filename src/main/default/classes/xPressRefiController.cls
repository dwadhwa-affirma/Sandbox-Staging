public class xPressRefiController{
	public static HttpRequest httpreq = new HttpRequest();
	public static String jsonData;
	public static HttpResponse response;
	public static String responseBody;
	public static String strStatus, strBody;
	public static String loanAPI;
	//-----------------Getting Stage Details and Member Account Details-----------//
	@AuraEnabled
	public static map<string, object> getStageData(string recordId){
		map<string, object> resultMap = new map<string, object>();

		List<xPressRefi_Stages__c> xPressRefiStagesList = new List<xPressRefi_Stages__c>();
		xPressRefiStagesList = [SELECT id, name, isActive__c, Order__c, Stage_Action__c, Stage_Action_Placeholder__c, Stage_Component__c, Stage_Label__c, StepId__c
		                        from xPressRefi_Stages__c
		                        where isActive__c = true
		                        order by Order__c];
		resultMap.put('xPressRefiStages', xPressRefiStagesList);
		return resultMap;
	}

	//-----------------Getting List of Authorized Memberships-----------//
	@AuraEnabled
	public static map<string, object> getAuthorizedMemberships(string recordId){
		map<string, object> resultMap = new map<string, object>();

		Account Member = [select id, name, PersonID__c
		                  from Account
		                  where id = :recordId
		                  limit 1];

		List<MemberAuthrizationWrapperObject> resultList = new List<MemberAuthrizationWrapperObject>();
		string MemberName = Member.name.replace(' ', '%20');
		system.debug('MemberName:' + MemberName);
		xPressRefi_To_Episys_API_Details__c api = xPressRefi_To_Episys_API_Details__c.getValues('ProductionURL');

		if (api.URL__c != null){
			loanAPI = api.URL__c;
		}
		httpreq.setEndpoint(loanAPI + '/XPressRefi/GetAuthorizedNames');// + AccountNumber +'&FullNameStringList=' + primaryName +'&FullName=' + SSN);
		httpreq.setMethod('POST');
		httpreq.setHeader('Content-Type', 'application/json');
		httpreq.setHeader('Accept', 'application/json');
		httpreq.setHeader('Content-Length', '162100');
		jsonData = '{"MemberName":' + '\"' + MemberName + '\","SSN":' + '\"' + Member.PersonID__c.substring(1)+'\"' + ',"IsShareIncluded":' + '\"' + 'true' + '\"}';
		httpreq.setBody(jsonData);
		system.debug('jsonData==' + jsonData);
		Http http = new Http();

		httpreq.setTimeout(60000);
		if (!Test.isRunningTest()){
			response = http.send(httpreq);
			responseBody = response.getBody();
			System.debug('Response:' + response);
			System.debug('Response Body ACH::' + response.getBody());
			strStatus = response.getStatus();
			strBody = response.getBody();
		} else{
			strBody = '{"lstNames":[{"accountnumber":"0000000123","city":"DANVILLE","ssnnumber":"666147265","extraaddress":"EA","type":0,"extraaddress":"","state":"CA","street":"3 CAMPBELL PL","userchar2":"V353425910","zipcode":"94526-2949","name":"ALAN MANEWITZ"}]}';
		}

		System.debug('strStatus ....' + strStatus);
		System.debug('strBody ....' + strBody);


		if (strBody != ''){
			map<string, object> lstNamesObject = (map<string, object>)JSON.deserializeUntyped(strBody);
			List<Object> results = (List<Object>)lstNamesObject.get('lstNames');//(List<Object>)JSON.deserializeUntyped(strBody);
			System.debug('Service response is ....' + results);

			if (results != null){
				for (Object t : results){
					MemberAuthrizationWrapperObject temp = new MemberAuthrizationWrapperObject();
					map<string, object> localAcc = (map<string, object>)t;
					string MN = (string)localAcc.get('name');
					string AccountNumber = (string)localAcc.get('accountnumber');
					string SSN = (string)localAcc.get('ssnnumber');
					string Type = string.valueof((Integer)localAcc.get('type'));
					string MembershipAddress1 = (string)localAcc.get('street');
					string MembershipAddress2 = (string)localAcc.get('extraaddress');
					string MembershipCity = (string)localAcc.get('city');
					string MembershipState = (string)localAcc.get('state');
					string MembershipZip = (string)localAcc.get('zipcode');
					temp.AccountNumber = AccountNumber;
					temp.MembershipAddress1 = MembershipAddress1;
					temp.MembershipAddress2 = MembershipAddress2;
					temp.MembershipCity = MembershipCity;
					temp.SSN = SSN;
					temp.Type = Type;
					temp.MemberName = MN;
					temp.MembershipState = MembershipState;
					temp.MembershipZip = MembershipZip;
					temp.MembershipEmail = (string)localAcc.get('email');
					temp.MembershipPhone = (string)localAcc.get('homephone');
					System.debug('temp ....' + temp);
					resultList.add(temp);
				}
			}


		}

		resultMap.put('AuthorizedMemberships', resultList);

		return resultMap;
	}

	//-----------------Getting List of Authorized Memberships-----------//
	@AuraEnabled
	public static map<string, object> getActiveMortgages(string recordId){
		map<string, object> resultMap = new map<string, object>();
		Set<String> NameSet = new Set<String>();
		List<Account_Details__c> acList = new List<Account_Details__c>();
		set<string> AccountnoSSNType = new set<string>();
		List<xPressRefi__c> xPressrecordList = new List<xPressRefi__c>();
		Boolean isABTQualified;


		/*--------Get Authorized Membership----------*/
		List<MemberAuthrizationWrapperObject> resultList = (List<MemberAuthrizationWrapperObject>)getAuthorizedMemberships(recordId).get('AuthorizedMemberships');
		Account Member = [select id, name, PersonID__c, BIRTH_DATE__pc
		                  from Account
		                  where id = :recordId
		                  limit 1];

		string MembershipAddress1, MembershipAddress2, MembershipCity, MembershipState, MembershipZip;

		for (MemberAuthrizationWrapperObject r : resultList){
			string s = r.AccountNumber + ' ' + r.SSN + ' ' + r.Type.leftPad(4, '0');
			AccountnoSSNType.add(s);
			system.debug('AccountnoSSNType' + s);
		}

		List<Person_Account__c> prsn = [SELECT Id, Account_Number__c, PersonID__r.Mobile_Phone__pc, Account_Number__r.RecType__c, Account_Number__r.Loan_Number__c, PersonID__r.PersonEmail, TypeTranslate__c, Account_Number__r.Name, PersonID__r.PersonID__c
		                                FROM Person_Account__c
		                                WHERE PersonID__c = :recordId];
		system.debug('prsn' + prsn);
		if (prsn.size() > 0){
			for (Person_Account__c p : prsn){
				string SSN = p.PersonID__r.PersonID__c.substring(1);
				string TempAccountnoSSNType = p.Account_Number__r.Name + ' ' + SSN + ' ' + p.typetranslate__c.substring(0, 4);
				system.debug('TempAccountnoSSNType' + TempAccountnoSSNType);
				if (AccountnoSSNType.contains(TempAccountnoSSNType)){
					NameSet.add(p.Account_Number__r.Name);
				}
			}
		}
		// Associated member accounts
		acList = [SELECT Id, Name, RecType__c, Due_Date__c, County_Name__c, Home_Value__c, OPEN_DATE__c, Investor__c, TypeTranslate__c, Brand__c, Brand_Code__c, Loan_Number__c, Mortgage_Name_1__c, Mortgage_Name_2__c, Emp_Available_Balance__c, Available_Balance__c, PROPERTY_ADDRESS__c, Property_City__c, Property_State__c, Property_Zip__c, PRINCIPAL_BALANCE__c, Interest_Rate__c, Maturity_Date__c, Emp_Balance__c, PAYMENT__c, Loan_code__c, Loan_Program_Type__c, Xpress_Refi_Eligibility__c, Impermissible__c, Income__c, PMI_Flag__c, P_I_Payment__c, Remaining_Term__c, Is_Relocation_Loan__c
		          FROM Account_Details__c
		          WHERE Name IN :NameSet and TypeTranslate__c = 'MORTGAGE' and Maturity_Date__c >= TODAY and Close_Date__c = null
		          LIMIT 1];

		system.debug('acList' + acList);

		for (Account_Details__c a : acList){
			string BorrowerName = a.Mortgage_Name_1__c;
			string[] Names = BorrowerName.split(' ');
			string BorrowerFirstName = Names[0];
			string BorrowerLastName = Names[Names.size()-1];
			string zipcode;
			if (a.Property_Zip__c != null && a.Property_Zip__c.length() >= 5){
				zipcode = a.Property_Zip__c.substring(0, 5);
			}
			xPressRefi__c xpressrefiobj = new xPressRefi__c();
			xpressrefiobj.Current_Interest_Rate__c = a.Interest_Rate__c;
			xpressrefiobj.LoanId__c = a.Loan_Number__c;
			xpressrefiobj.Maturity_Date__c = a.Maturity_Date__c;
			xpressrefiobj.Member_Number__c = a.Name;
			xpressrefiobj.Principal_Balance__c = a.PRINCIPAL_BALANCE__c;
			xpressrefiobj.Property__c = a.PROPERTY_ADDRESS__c;
			xpressrefiobj.Property_City__c = a.Property_City__c;
			xpressrefiobj.Property_State__c = a.Property_State__c;
			xpressrefiobj.Property_Zip__c = zipcode;
			xpressrefiobj.Product_Type__c = getProductMapping(string.valueof(a.Loan_Program_Type__c));//15 Year Fixed';
			xpressrefiobj.P_I_Payment__c = a.P_I_Payment__c;//PIPaymentCalculation(15, xpressrefiobj.Current_Interest_Rate__c, xpressrefiobj.Principle_Balance__c);
			xpressrefiobj.Member__c = recordId;
			xpressrefiobj.Borrower_First_Name__c = BorrowerFirstName;
			xpressrefiobj.Borrower_Last_Name__c = BorrowerLastName;
			xpressrefiobj.Borrower_Birth_Date__c = Member.BIRTH_DATE__pc;
			xpressrefiobj.Property_County__c = a.County_Name__c;
			xpressrefiobj.Home_Value__c = a.Home_Value__c;
			xpressrefiobj.Start_Date_Calc__c = a.OPEN_DATE__c;
			xpressrefiobj.Brand_Code__c = a.Brand_Code__c;
			xpressrefiobj.Investor__c = a.Investor__c;
			xpressrefiobj.Rate_Expiration_Date__c = Date.today().addDays(45);
			//xpressrefiobj.Share_Account__c = '200';
			xpressrefiobj.Debit_Share_Account__c = a.Name;
			xpressrefiobj.Loan_Program_Type__c = a.Loan_Program_Type__c;
			xpressrefiobj.Borrower_Name_1__c = a.Mortgage_Name_1__c;
			xpressrefiobj.Borrower_Name_2__c = a.Mortgage_Name_2__c;
			xpressrefiobj.Income__c = a.Income__c;
			xpressrefiobj.Due_Date__c = a.Due_Date__c;
			xpressrefiobj.PMI_Flag__c = a.PMI_Flag__c;
			xpressrefiobj.Impermissible__c = a.Impermissible__c;
			xpressrefiobj.Remaining_Term__c = a.Remaining_Term__c;
			xpressrefiobj.Is_Relocation_Loan__c = a.Is_Relocation_Loan__c;
			System.debug(xpressrefiobj.P_I_Payment__c);
			xPressrecordList.add(xpressrefiobj);
		}

		for (MemberAuthrizationWrapperObject r : resultList){
			if (xPressrecordList.size() > 0 && r.AccountNumber == xPressrecordList[0].Member_Number__c && r.Type == '0'){
				MembershipAddress1 = r.MembershipAddress1;
				MembershipAddress2 = r.MembershipAddress2;
				MembershipCity = r.MembershipCity;
				MembershipState = r.MembershipState;
				MembershipZip = r.MembershipZip;
				xPressrecordList[0].Mailing_Address_1__c = MembershipAddress1;
				xPressrecordList[0].Mailing_Address_2__c = MembershipAddress2;
				xPressrecordList[0].Mailing_Address_City__c = MembershipCity;
				xPressrecordList[0].Mailing_Address_Zip__c = MembershipZip;
				xPressrecordList[0].Mailing_State__c = MembershipState;
				xPressrecordList[0].Member_Email__c = r.MembershipEmail;
				xPressrecordList[0].Member_Phone__c = r.MembershipPhone;
				system.debug('r.MembershipEmail==' + r.MembershipEmail);
				system.debug('r.MembershipPhone==' + r.MembershipPhone);
				break;
			}
		}

		XpressRefiWrapperObject xpressrefiobject = new XpressRefiWrapperObject();
		xpressrefiobject.xPressRefiList = xPressrecordList;
		xpressrefiobject.MembershipAddress1 = MembershipAddress1;
		xpressrefiobject.MembershipAddress2 = MembershipAddress2;
		xpressrefiobject.MembershipCity = MembershipCity;
		xpressrefiobject.MembershipState = MembershipState;
		xpressrefiobject.MembershipZip = MembershipZip;
		resultMap.put('ActiveMortgages', xpressrefiobject);

		/*--------Get Stage Data----------*/
		List<xPressRefi_Stages__c> xPressRefiStagesList = (List<xPressRefi_Stages__c>)getStageData(recordId).get('xPressRefiStages');
		resultMap.put('xPressRefiStages', xPressRefiStagesList);

		/*--------ABT Qualification List----------*/
		if (acList.size() > 0 && acList[0].Xpress_Refi_Eligibility__c == false){
			isABTQualified = false;
		} else{
			isABTQualified = true;
		}

		if (!isABTQualified && acList.size() > 0 && acList[0].Impermissible__c == true){
			resultMap.put('NotABTQualifiedMessage', 'Not Eligible: Impermissible');
		} else if (!isABTQualified && acList.size() > 0 && acList[0].Impermissible__c == false){
			resultMap.put('NotABTQualifiedMessage', 'Not Eligible');
		}

		resultMap.put('isABTQualified', isABTQualified);

		/*--------Address Match----------*/
		if (isABTQualified){
			Boolean isFullAddressMatch = (Boolean)isAddressMatch(xpressrefiobject).get('isFullAddressMatch');
			resultMap.put('isFullAddressMatch', isFullAddressMatch);
		}

		return resultMap;
	}

	//-----------------Address Match-----------//
	@AuraEnabled
	public static map<string, object> isAddressMatch(XpressRefiWrapperObject xpressrefiobject){
		map<string, object> resultMap = new map<string, object>();
		Boolean FullAddressMatch = false;

		string PropertyAddress1, PropertyAddress2, PropertyCity, PropertyState, PropertyZip;
		string MembershipAddress1, MembershipAddress2, MembershipCity, MembershipState, MembershipZip;
		Boolean isAddress1Match = false, isAddress2Match = false, isCityMatch = false, isStateMatch = false, isZipMatch = false;

		if (xpressrefiobject.xPressRefiList.size() > 0){
			PropertyAddress1 = xpressrefiobject.xPressRefiList[0].Property__c;
			PropertyAddress2 = xpressrefiobject.xPressRefiList[0].Property_Address_2__c;
			PropertyCity = xpressrefiobject.xPressRefiList[0].Property_City__c;
			PropertyState = xpressrefiobject.xPressRefiList[0].Property_State__c;
			PropertyZip = xpressrefiobject.xPressRefiList[0].Property_Zip__c;
		}


		MembershipAddress1 = xpressrefiobject.MembershipAddress1;
		MembershipAddress2 = xpressrefiobject.MembershipAddress2;
		MembershipCity = xpressrefiobject.MembershipCity;
		MembershipState = xpressrefiobject.MembershipState;
		MembershipZip = xpressrefiobject.MembershipZip;

		if (PropertyAddress1 == MembershipAddress1){
			isAddress1Match = true;
		}
		if (PropertyAddress2 == MembershipAddress2){
			isAddress2Match = true;
		}
		if (PropertyCity == MembershipCity){
			isCityMatch = true;
		}
		if (PropertyState == MembershipState){
			isStateMatch = true;
		}
		if (PropertyZip == MembershipZip){
			isZipMatch = true;
		}

		if (isAddress1Match && isAddress2Match && isCityMatch && isStateMatch && isZipMatch){
			FullAddressMatch = true;
		} else{
			FullAddressMatch = false;
		}
		resultMap.put('isFullAddressMatch', FullAddressMatch);
		return resultMap;
	}

	//-----------------Create Case-----------//
	@AuraEnabled
	public static string createCase(string recordId, xPressRefi__c XpressRefiRecord){

		xPressRefi_Case_Categories__c caseCategories = xPressRefi_Case_Categories__c.getValues('Categories');

		list<CaseRecordType__c> scList = [SELECT Id, Primary_Category__c, Secondary_Category__c, Teritiary_Category__c, Record_Type_Name__c, SLA__c, RecordTypeId__c
		                                  FROM CaseRecordType__c
		                                  WHERE Primary_Category__c = :caseCategories.Primary_Category__c AND Secondary_Category__c = :caseCategories.Secondary_Category__c AND Teritiary_Category__c = :caseCategories.Tertiary_Category__c
		                                  LIMIT 1];

		// Group gp = [select Id, Name
		//             from Group
		//             where Type = 'Queue' AND NAME = 'DocuSign Queue'];

		Person_Account__c pa = new Person_Account__c();
		pa = [SELECT id, name, PersonID__c, Account_Number__c, PersonID__r.name, Account_Number__r.Name
		      from Person_Account__c
		      where PersonID__c = :recordId AND typetranslate__c like '%Primary%'
		      limit 1];

		case cs = new case();
		for (CaseRecordType__c crt : scList){
			cs.RecordTypeId = scList[0].RecordTypeId__c;
			cs.Primary_Category__c = scList[0].Primary_Category__c;
			cs.Secondary_Category__c = scList[0].Secondary_Category__c;
			cs.Tertiary_Category__c = scList[0].Teritiary_Category__c;
			cs.Sla__c = scList[0].SLA__c;
		}
		cs.AccountId = recordId;
		if (pa != null)
			cs.Account_Number__c = pa.Account_Number__c;
		cs.Subject = 'xPress Refi';
		cs.ownerid = UserInfo.getUserId();
		if (pa != null){
			cs.AccountId = pa.PersonID__c;
		}
		cs.Previous_Owner__c = UserInfo.getUserId();
		string Description = '';
		Description = 'Member Account: ' + XpressRefiRecord.Member_Number__c + '\n' + 
					  'Property Address: ' + XpressRefiRecord.Property__c + ' ' + xPressRefiRecord.Property_City__c + ' ' + xPressRefiRecord.Property_State__c + ', ' + xPressRefiRecord.Property_Zip__c + '\n' + 
					  'Loan ID: ' + XpressRefiRecord.LoanId__c + '\n' + 
					  'Principal Balance: ' + '$' + XpressRefiRecord.Principal_Balance__c + '\n\n' + 
					  'Old Mortgage Type: ' + XpressRefiRecord.Product_Type__c + '\n' + 
					  'Old Interest Rate: ' + XpressRefiRecord.Current_Interest_Rate__c + '%\n\n' + 
					  'New Mortgage Type: ' + XpressRefiRecord.New_Product_Type__c + '\n' + 
					  'New Interest Rate: ' + XpressRefiRecord.New_Interest_Rate_Calc__c + '%\n\n' + 
					  'Is Relocation Loan?: ' + (XpressRefiRecord.Is_Relocation_Loan__c == true ? 'Yes' : 'No')+'\n' + 
					  'Is Chevron Employee?: ' + (XpressRefiRecord.Is_Chevron_Employee__c == true ? 'Yes' : 'No')+'\n' + 
					  'Is Primary Residence?: ' + (XpressRefiRecord.Is_Primary_Residence__c == true ? 'Yes' : 'No')+'\n\n' + 
					  'Income: ' + '$' + XpressRefiRecord.Income__c + '\n' + 
					  'Impermissible: ' + (XpressRefiRecord.Impermissible__c == true ? 'Yes' : 'No');
		cs.Description = Description;
		insert cs;
		id caseId = cs.id;
		return caseId;
	}

	//-----------------P&I Payment Calculation-----------//
	@AuraEnabled
	public static decimal PIPaymentCalculation(Integer LoanTermYears, Decimal InterestRate, Decimal PrincipalAmount){
		// Integer LoanTermYears;
		// Decimal InterestRate;
		// Decimal PrincipleAmount;

		system.debug('LoanTermYears=' + LoanTermYears);
		system.debug('InterestRate=' + InterestRate);
		system.debug('PrincipalAmount=' + PrincipalAmount);
		Decimal RatePerMonth;
		if (InterestRate != null)
			RatePerMonth = (InterestRate / 12) / 100;
		system.debug('RatePerMonth=' + RatePerMonth);
		Integer NumberOfPayments;
		if (LoanTermYears != null)
			NumberOfPayments = LoanTermYears * 12;
		system.debug('NumberOfPayments=' + NumberOfPayments);
		Decimal PIPayment;
		Decimal rplus1n = (RatePerMonth + 1).pow(NumberOfPayments);
		system.debug('rplus1n=' + rplus1n);

		PIPayment = PrincipalAmount * ((RatePerMonth * rplus1n) / ((rplus1n - 1)));

		return PIPayment;
	}

	//-----------------Create Mortgage Cadende CSV File-----------//
	@future(callout = true)
	public static void CreateMortgageCadenceCSVFile(set<Id> xPressIds){

		List<xPressRefi__c> xPressrecordList = [SELECT Case__c, Case__r.Status, Maturity_Date_Calc__c, Investor__c, Borrower_First_Name__c, Today_s_Date__c, Borrower_Last_Name__c, Borrower_Birth_Date__c, Member_Number__c, LoanId__c, Property__c, Property_County__c, New_Product_Type__c, Brand_Code__c, Principal_Balance__c, Home_Value__c, Current_Interest_Rate__c, Debit_Share_Account__c, Mailing_Address_1__c, Mailing_Address_2__c, Mailing_Address_City__c, Mailing_Address_Zip__c, Mailing_State__c, Maturity_Date__c, Member_Email__c, Member_Phone__c, New_Interest_Rate_Calc__c, New_Payment_Amount_Calc__c, PMI_Amount__c, Product_Type__c, Property_Address_2__c, Property_Balance__c, Property_City__c, Property_Full_Address__c, Property_State__c, Property_Zip__c, P_I_Payment__c, Rate_Expiration_Date__c, Share_Account__c, Start_Date_Calc__c, is_CSV_Generated__c, Is_Mortgage_Ware__c
		                                        FROM xPressRefi__c
		                                        where id IN :xPressIds
		                                        limit 1];

		// // jsonData = JSON.serialize(xPressrecordList);
		// // System.debug('JsonData-' + jsonData);
		// String dateFormatString = 'MM-dd-yyyy';
		// String dateString;

		// xPressRefi_To_Episys_API_Details__c api = xPressRefi_To_Episys_API_Details__c.getValues('ProductionCSVURL');
		// if (api.URL__c != null){
		//     loanAPI = api.URL__c;
		// }

		// httpreq = new httpRequest();
		// httpreq.setEndpoint(loanAPI + '/XPressRefi/CreateMortgageCadenceCSV');// + AccountNumber +'&FullNameStringList=' + primaryName +'&FullName=' + SSN);
		// httpreq.setMethod('POST');
		// httpreq.setHeader('Content-Type', 'application/json');
		// httpreq.setHeader('Accept', 'application/json');
		// httpreq.setHeader('Content-Length', '162100');

		// JSONGenerator gen = JSON.createGenerator(true);
		// gen.writeStartObject();
		// gen.writeStringField('Borrower_First_Name', xPressrecordList[0].Borrower_First_Name__c == null ? '' : xPressrecordList[0].Borrower_First_Name__c);
		// gen.writeStringField('Borrower_Last_Name', xPressrecordList[0].Borrower_Last_Name__c == null ? '' : xPressrecordList[0].Borrower_Last_Name__c);
		// gen.writeStringField('Borrower_Birth_Date', xPressrecordList[0].Borrower_Birth_Date__c == null ? '' : FormatDate(dateFormatString, xPressrecordList[0].Borrower_Birth_Date__c));
		// gen.writeStringField('Loan_ID', xPressrecordList[0].LoanId__c == null ? '' : xPressrecordList[0].LoanId__c);
		// gen.writeStringField('Member_Number', xPressrecordList[0].Member_Number__c == null ? '' : xPressrecordList[0].Member_Number__c);
		// gen.writeStringField('Property_Address', xPressrecordList[0].Property__c == null ? '' : xPressrecordList[0].Property__c);
		// gen.writeStringField('Property_County', xPressrecordList[0].Property_County__c == null ? '' : xPressrecordList[0].Property_County__c);
		// gen.writeStringField('New_Product_Type', xPressrecordList[0].New_Product_Type__c == null ? '' : xPressrecordList[0].New_Product_Type__c);
		// gen.writeStringField('Property_Balance', xPressrecordList[0].Principal_Balance__c == null ? '' : string.valueof(xPressrecordList[0].Principal_Balance__c));
		// gen.writeStringField('Home_Value', xPressrecordList[0].Home_Value__c == null ? '' : string.valueof(xPressrecordList[0].Home_Value__c));
		// gen.writeStringField('Current_Interest_Rate', xPressrecordList[0].Current_Interest_Rate__c == null ? '' : string.valueof(xPressrecordList[0].Current_Interest_Rate__c));
		// gen.writeStringField('Current_PandI', xPressrecordList[0].P_I_Payment__c == null ? '' : string.valueof(xPressrecordList[0].P_I_Payment__c));
		// gen.writeStringField('New_Interest_Rate', xPressrecordList[0].New_Interest_Rate_Calc__c == null ? '' : string.valueof(xPressrecordList[0].New_Interest_Rate_Calc__c));
		// gen.writeStringField('New_Payment_Amount_C', xPressrecordList[0].New_Payment_Amount_Calc__c == null ? '' : string.valueof(xPressrecordList[0].New_Payment_Amount_Calc__c));

		// gen.writeStringField('Maturity_Date_C', xPressrecordList[0].Maturity_Date_Calc__c == null ? '' : FormatDate(dateFormatString, xPressrecordList[0].Maturity_Date_Calc__c));
		// gen.writeStringField('Start_Date_C', xPressrecordList[0].Start_Date_Calc__c == null ? '' : FormatDate(dateFormatString, xPressrecordList[0].Start_Date_Calc__c));
		// gen.writeStringField('Brand_Code', xPressrecordList[0].Brand_Code__c == null ? '' : xPressrecordList[0].Brand_Code__c);
		// gen.writeStringField('Mailing_Address1', xPressrecordList[0].Mailing_Address_1__c == null ? '' : xPressrecordList[0].Mailing_Address_1__c);
		// gen.writeStringField('Mailing_Address2', xPressrecordList[0].Mailing_Address_2__c == null ? '' : xPressrecordList[0].Mailing_Address_2__c);
		// gen.writeStringField('Mailing_Address_City', xPressrecordList[0].Mailing_Address_City__c == null ? '' : xPressrecordList[0].Mailing_Address_City__c);
		// gen.writeStringField('Mailing_Address_State', xPressrecordList[0].Mailing_State__c == null ? '' : xPressrecordList[0].Mailing_State__c);
		// gen.writeStringField('Mailing_Address_Zip', xPressrecordList[0].Mailing_Address_Zip__c == null ? '' : xPressrecordList[0].Mailing_Address_Zip__c);
		// gen.writeStringField('Member_Email_Address', xPressrecordList[0].Member_Email__c == null ? '' : xPressrecordList[0].Member_Email__c);
		// gen.writeStringField('Member_Phone_Number', xPressrecordList[0].Member_Phone__c == null ? '' : xPressrecordList[0].Member_Phone__c);
		// gen.writeStringField('Current_Product_Type', xPressrecordList[0].Product_Type__c == null ? '' : xPressrecordList[0].Product_Type__c);
		// gen.writeStringField('PMI_Flag', xPressrecordList[0].PMI_Amount__c == null ? '' : string.valueof(xPressrecordList[0].PMI_Amount__c));
		// gen.writeStringField('Investor', xPressrecordList[0].Investor__c == null ? '' : string.valueof(xPressrecordList[0].Investor__c));

		// gen.writeStringField('Todays_Date', xPressrecordList[0].Today_s_Date__c == null ? '' : FormatDate(dateFormatString, xPressrecordList[0].Today_s_Date__c));
		// gen.writeStringField('Rate_Expiration_Date', xPressrecordList[0].Rate_Expiration_Date__c == null ? '' : FormatDate(dateFormatString, xPressrecordList[0].Rate_Expiration_Date__c));
		// gen.writeStringField('Debit_Share_Account', xPressrecordList[0].Debit_Share_Account__c == null ? '' : xPressrecordList[0].Debit_Share_Account__c);
		// gen.writeStringField('Share_Account', xPressrecordList[0].Share_Account__c == null ? '' : xPressrecordList[0].Share_Account__c);
		// gen.writeEndObject();

		// // Get the JSON string.
		// jsonData = gen.getAsString();
		// //jsonData = '{"AccountNumber":' + '\"' + AccountNumber + '\","FullNameStringList":' + '\"' + primaryName + '\"' + ',"FullName":' + '\"' + SSN + '\"' + ',"IsIncludeMailAddresses":' + '\"' + 'true' + '\"}';
		// httpreq.setBody(jsonData);
		// system.debug('jsonData==' + jsonData);
		// Http httpParam = new Http();

		// httpreq.setTimeout(60000);

		// if (!Test.isRunningTest()){
		//     response = httpParam.send(httpreq);
		//     responseBody = response.getBody();
		//     System.debug('Response Body::' + response.getBody());
		//     strStatus = response.getStatus();
		//     strBody = response.getBody();
		// } else{
		//     strBody = '[{"Status":"OK","city":"","country":null,"locator":"794","cardlocator":null,"cardlast4":null,"extraaddress":"","state":"","street":"","userchar2":"","zipcode":"","name":"AXEL TAKACS","email":"dbhavsar@affirma.com","DisplayOnly":"0","type":0}]';
		// }

		// string result = strBody.substringAfter('Status":"');
		// result = String.valueOf(result).substringBefore('",');
		// System.debug('Status' + result);

		if (xPressrecordList.size() > 0){
			xPressrecordList[0].Is_Mortgage_Cadence__c = true;
			update xPressrecordList;

			List<Case> CaseToUpdate = [Select Id, Status, Description
			                           from Case
			                           where Id = :xPressrecordList[0].Case__c];
			if (CaseToUpdate.size() > 0){
				CaseToUpdate[0].Description = CaseToUpdate[0].Description + '\n\nIs Mortgage Ware?: ' + (xPressrecordList[0].Is_Mortgage_Ware__c == true ? 'Yes' : 'No')+'\n' + 'Is Mortgage Cadence?: ' + (xPressrecordList[0].Is_Mortgage_Cadence__c == true ? 'Yes' : 'No');
				update CaseToUpdate;
			}

		}
	}

	//-----------------Create Mortgage Ware CSV File-----------//
	@future(callout = true)
	public static void CreateMortgageWareCSVFile(Set<Id> xPressIds){

		List<xPressRefi__c> xPressrecordList = [SELECT Maturity_Date_Calc__c, Case__c, Investor__c, Borrower_First_Name__c, Today_s_Date__c, Borrower_Last_Name__c, Borrower_Birth_Date__c, Member_Number__c, LoanId__c, Property__c, Property_County__c, New_Product_Type__c, Brand_Code__c, Principal_Balance__c, Home_Value__c, Current_Interest_Rate__c, Debit_Share_Account__c, Mailing_Address_1__c, Mailing_Address_2__c, Mailing_Address_City__c, Mailing_Address_Zip__c, Mailing_State__c, Maturity_Date__c, Member_Email__c, Member_Phone__c, New_Interest_Rate_Calc__c, New_Payment_Amount_Calc__c, PMI_Amount__c, Product_Type__c, Property_Address_2__c, Property_Balance__c, Property_City__c, Property_Full_Address__c, Property_State__c, Property_Zip__c, P_I_Payment__c, Rate_Expiration_Date__c, Share_Account__c, Start_Date_Calc__c
		                                        FROM xPressRefi__c
		                                        where id IN :xPressIds
		                                        limit 1];


		// String dateFormatString = 'MM-dd-yyyy';
		// xPressRefi_To_Episys_API_Details__c api = xPressRefi_To_Episys_API_Details__c.getValues('ProductionCSVURL');
		// if (api.URL__c != null){
		//     loanAPI = api.URL__c;
		// }

		// httpreq = new httpRequest();
		// httpreq.setEndpoint( loanAPI + '/XPressRefi/CreateMortageWareCSV');// + AccountNumber +'&FullNameStringList=' + primaryName +'&FullName=' + SSN);
		// httpreq.setMethod('POST');
		// httpreq.setHeader('Content-Type', 'application/json');
		// httpreq.setHeader('Accept', 'application/json');
		// httpreq.setHeader('Content-Length', '162100');

		// JSONGenerator gen = JSON.createGenerator(true);
		// gen.writeStartObject();
		// gen.writeStringField('LoanID', xPressrecordList[0].LoanId__c == null ? '' : xPressrecordList[0].LoanId__c);
		// gen.writeStringField('PIPmt', xPressrecordList[0].P_I_Payment__c == null ? '' : string.valueof(xPressrecordList[0].P_I_Payment__c));
		// gen.writeStringField('InterestRate', xPressrecordList[0].Current_Interest_Rate__c == null ? '' : string.valueof(xPressrecordList[0].Current_Interest_Rate__c));
		// gen.writeStringField('OriginalTerm', '');
		// gen.writeStringField('AmortizedTerm', '');
		// gen.writeStringField('ChangeNextPaymentTo1', '');
		// gen.writeStringField('FirstDueDate', '');
		// gen.writeStringField('MaturityDate', xPressrecordList[0].Maturity_Date__c == null ? '' : FormatDate(dateFormatString, xPressrecordList[0].Rate_Expiration_Date__c));
		// gen.writeStringField('ModificationDate', '');
		// gen.writeStringField('NonSaleable', '');
		// gen.writeStringField('FNMASaleable', '');
		// gen.writeStringField('ModType', '');
		// gen.writeStringField('XpressRefiBal', xPressrecordList[0].Principal_Balance__c == null ? '' : string.valueof(xPressrecordList[0].Principal_Balance__c));
		// gen.writeStringField('GLPlan', '');
		// gen.writeStringField('LoanProfile', '');
		// gen.writeStringField('ARMLoan', '');
		// gen.writeStringField('ARMPendingAdj', '');
		// gen.writeStringField('ARMNextRateChgDate', '');
		// gen.writeStringField('ARMNextPIChgDate', '');
		// gen.writeStringField('ARMTemplate', '');
		// gen.writeStringField('ARMIndex', '');
		// gen.writeStringField('ARMMargin', '');
		// gen.writeStringField('ARMPeriodRateInc', '');
		// gen.writeStringField('ARMPeriodRateDec', '');
		// gen.writeStringField('ARMFrstChgPeriodInc', '');
		// gen.writeStringField('ARMFrstChgPeriodDec', '');
		// gen.writeStringField('ARMLifeRateIncrease', '');
		// gen.writeStringField('ARMLifeRateDecrease', '');
		// gen.writeStringField('ARMFloorRate', '');
		// gen.writeStringField('ARMTeaserRate', '');
		// gen.writeStringField('ARMOriginalIntRate', '');
		// gen.writeStringField('ARMOriginalPIPmt', '');
		// gen.writeStringField('ARMFrstRateChgDate', '');
		// gen.writeStringField('ARMFrstPIChgDate', '');
		// gen.writeStringField('ARMOriginalIndex', '');
		// gen.writeStringField('ARMCurrentIndex', '');
		// gen.writeStringField('ARMTotCarryOverPercent', '');
		// gen.writeStringField('Comment', '');
		// gen.writeEndObject();

		// // Get the JSON string.
		// jsonData = gen.getAsString();
		// //jsonData = '{"AccountNumber":' + '\"' + AccountNumber + '\","FullNameStringList":' + '\"' + primaryName + '\"' + ',"FullName":' + '\"' + SSN + '\"' + ',"IsIncludeMailAddresses":' + '\"' + 'true' + '\"}';
		// httpreq.setBody(jsonData);
		// system.debug('jsonData==' + jsonData);
		// Http httpParam = new Http();

		// httpreq.setTimeout(60000);

		// if (!Test.isRunningTest()){
		//     response = httpParam.send(httpreq);
		//     responseBody = response.getBody();
		//     System.debug('Response Body ACH::' + response.getBody());
		//     strStatus = response.getStatus();
		//     strBody = response.getBody();
		// } else{
		//     strBody = '[{"Status":"OK","city":"","country":null,"locator":"794","cardlocator":null,"cardlast4":null,"extraaddress":"","state":"","street":"","userchar2":"","zipcode":"","name":"AXEL TAKACS","email":"dbhavsar@affirma.com","DisplayOnly":"0","type":0}]';
		// }

		// string result = strBody.substringAfter('Status":"');
		// result = String.valueOf(result).substringBefore('",');
		// System.debug('Status' + result);

		if (xPressrecordList.size() > 0){
			xPressrecordList[0].Is_Mortgage_Ware__c = true;
			update xPressrecordList;

			List<Case> CaseToUpdate = [Select Id, Status, Previous_Owner__c, OwnerId, Description
			                           from Case
			                           where Id = :xPressrecordList[0].Case__c];
			if (CaseToUpdate.size() > 0){
				CaseToUpdate[0].Description = CaseToUpdate[0].Description.replace('Docusign Envelope Status: Sent', 'Docusign Envelope Status: Completed');
				update CaseToUpdate;
			}

		}
	}

	@AuraEnabled
	public static string FormatDate(string dateFormatString, Date DateToFormat){
		Datetime dt = Datetime.newInstance(DateToFormat.year(), DateToFormat.month(), DateToFormat.day());
		string dateString = dt.format(dateFormatString);
		return dateString;
	}

	//-----------------Get Product Details-----------//
	@AuraEnabled
	public static map<string, object> getAllProductDetails1(xPressRefi__c xpressrefiobj, Boolean isReloDiscountApplied, Boolean isLoanPrimaryResidence){
		system.debug('isLoanPrimaryResidence==' + isLoanPrimaryResidence);
		List<CU_Rates__c> ProductsList = new List<CU_Rates__c>();
		map<string, object> resultMap = new map<string, object>();
		List<CU_Rates__c> XpressRefiProductsList = new List<CU_Rates__c>();

		CU_Rates_Configuration__c ProductRateConfig = CU_Rates_Configuration__c.getValues('CU Rate Configurations');
		decimal Rate1Limit, Rate2Limit, FinalRateLimit;
		string[] Rate2States;
		Boolean isConforming;
		double Discount;

		if (ProductRateConfig != null){
			Rate1Limit = ProductRateConfig.Rate_1_Limit__c;
			Rate2Limit = ProductRateConfig.Rate_2_Limit__c;
			Rate2States = ProductRateConfig.Rate_2_States__c.split(',');
		}

		if (Rate2States.contains(xpressrefiobj.Property_State__c)){
			FinalRateLimit = Rate2Limit;
		} else{
			FinalRateLimit = Rate1Limit;
		}

		string ProductType;
		if (xpressrefiobj != null && xpressrefiobj.Principal_Balance__c <= FinalRateLimit){
			isConforming = true;
			ProductType = 'Conforming%';
		} else{
			isConforming = false;
			ProductType = 'Jumbo%';
		}

		ProductsList = [SELECT id, name, Active__c, Product__c, Product_Code__c, Program__c, Rate__c, Type__c, Order__c
		                from CU_Rates__c
		                where Active__c = true and Type__c LIKE :ProductType
		                order by Order__c];

		XpressRefiProductsList = [SELECT id, name, Active__c, Product__c, Product_Code__c, Program__c, Rate__c, Type__c, Order__c, LastModifiedDate
		                          from CU_Rates__c
		                          where Active__c = true and Type__c LIKE :ProductType and Program__c ='xPress Refi'
		                          order by LastModifiedDate desc];

		system.debug('isReloDiscountApplied::' + isReloDiscountApplied);
		if (isReloDiscountApplied){
			Discount = getReloDiscountRates();
		}

		List<ProductsListWrapperObject> ProductWrapperList = new List<ProductsListWrapperObject>();
		for (CU_Rates__c cu : ProductsList){
			ProductsListWrapperObject pwo = new ProductsListWrapperObject();
			pwo.Product = cu.Product__c;
			pwo.ProductName = cu.name;
			if (isReloDiscountApplied && Discount != null){
				pwo.Rate = cu.Rate__c - Discount;
			} else{
				pwo.Rate = cu.Rate__c;
			}
			Integer LoanTermYears;
			if (cu.Product__c.contains('ARM')){
				string[] splitString = cu.Product__c.split(' ');
				if (splitString.size() >= 3)
					LoanTermYears = Integer.valueof(splitString[2].substring(0, 2));
			} else{
				LoanTermYears = Integer.valueof(cu.Product__c.substring(0, 2));
			}
			pwo.TotalPIPayment = PIPaymentCalculation(LoanTermYears, pwo.Rate, xpressrefiobj.Principal_Balance__c);
			//    pwo.MonthlySavings = cu.Product__c;
			if (xpressrefiobj.Product_Type__c == cu.Product__c && xpressrefiobj.Impermissible__c == false){
				pwo.IsMortgageCadence = false;
			} else{
				pwo.IsMortgageCadence = true;
			}
			system.debug('pwo.IsMortgageCadence::' + pwo.IsMortgageCadence);
			if (isLoanPrimaryResidence){
				ProductWrapperList.add(pwo);
			} else if (!isLoanPrimaryResidence && LoanTermYears <= 15){
				ProductWrapperList.add(pwo);
			}

			system.debug('pwo::' + pwo);
		}
		DateTime LastModifiedDate = XpressRefiProductsList[0].LastModifiedDate;
		Date RatesUpdatedDate = date.newinstance(LastModifiedDate.year(), LastModifiedDate.month(), LastModifiedDate.day());

		xPressRefi_Note__c Comment = xPressRefi_Note__c.getValues('Primary');
		string Note;
		if(Comment.Note__c != null){
			Note = Comment.Note__c;
		}

		resultMap.put('ProductWrapperList', ProductWrapperList);
		resultMap.put('Note', Note);
		resultMap.put('RatesUpdatedDate', FormatDate('MM/dd/yyyy', RatesUpdatedDate));
		return resultMap;
	}

	//-----------------Save xPressRefi Data-----------//
	@AuraEnabled
	public static map<string, object> saveXpressRefiData(xPressRefi__c XpressRefiRecord, string recordId){
		Id xId, caseId;
		map<string, object> resultMap = new map<string, object>();
		if (XpressRefiRecord != null){
			caseId = createCase(recordId, XpressRefiRecord);
			XpressRefiRecord.Case__c = caseId;
			List<Account_Details__c> accDetail = [SELECT Id, Name, Brand__c, Brand_Code__c
			                                      FROM Account_Details__c
			                                      WHERE Name = :XpressRefiRecord.Member_Number__c AND RecType__c = 'ACCT'
			                                      LIMIT 1];
			if (accDetail.size() > 0){
				XpressRefiRecord.Brand__c = accDetail[0].Brand__c;
				XpressRefiRecord.Brand_Code__c = accDetail[0].Brand_Code__c;
			}

			insert XpressRefiRecord;
			xId = XpressRefiRecord.id;


			List<xPressRefi__c> XpressRefiRecordList = [SELECT Borrower_Birth_Date__c, Borrower_First_Name__c, Borrower_Last_Name__c, Brand_Code__c, Brand__c, Case__c, Case__r.CaseNumber, Current_Interest_Rate_Calc__c, Current_Interest_Rate__c, Debit_Share_Account__c, DocuSignId__c, Docusign_Status__c, Home_Value__c, Id, Interest_Rate__c, Investor__c, is_CSV_Generated__c, Is_Mortgage_Ware_File_Created__c, Is_Product_Change__c, LoanId__c, Mailing_Address_1__c, Mailing_Address_2__c, Mailing_Address_City__c, Mailing_Address_Zip__c, Mailing_State__c, Maturity_Date_Calc__c, Maturity_Date__c, Member_Number__c, Member__c, New_Interest_Rate_Calc__c, New_Payment_Amount_Calc__c, New_Product_Type__c, PMI_Amount__c, Principal_Balance__c, Product_Type__c, Property_Address_2__c, Property_Balance__c, Property_City__c, Property_County__c, Property_State__c, Property_Zip__c, Property__c, P_I_Payment__c, Rate_Expiration_Date__c, Share_Account__c, Start_Date_Calc__c, Member_Phone__c, Member_Email__c, Loan_Program_Type__c, Borrower_Name_1__c, Borrower_Name_2__c, Due_Date__c, PMI_Flag__c, Is_Chevron_Employee__c, Is_Primary_Residence__c, Is_Relocation_Loan__c, Impermissible__c, New_Product_Name__c, Remaining_Term__c
			                                            FROM xPressRefi__c
			                                            where id = :xId];

			resultMap.put('xPressRefiRecord', XpressRefiRecordList[0]);
		}


		return resultMap;
	}

	@AuraEnabled
	public static string getProductMapping(string LoanCode){
		string ProductType;
		List<Mortgage_Products_Mapping__c> MortgageProductMappingList = [Select Id, Name, Description__c
		                                                                 from Mortgage_Products_Mapping__c
		                                                                 where Name = :LoanCode
		                                                                 limit 1];

		if (MortgageProductMappingList.size() > 0){
			ProductType = MortgageProductMappingList[0].Description__c;
		} else{
			ProductType = 'Unknown Product Type';
		}

		return ProductType;
	}

	@AuraEnabled
	public static double getReloDiscountRates(){
		double discount;

		Xpress_refi_relo_discount__c discountObj = Xpress_refi_relo_discount__c.getValues('Primary');
		if (discountObj.Discount__c != null){
			discount = discountObj.Discount__c;
		}
		return discount;
	}

	public class MemberAuthrizationWrapperObject{
		@AuraEnabled
		public string MemberName{ get; set; }

		@AuraEnabled
		public string AccountNumber{ get; set; }

		@AuraEnabled
		public string MembershipAddress1{ get; set; }

		@AuraEnabled
		public string MembershipAddress2{ get; set; }

		@AuraEnabled
		public string MembershipCity{ get; set; }

		@AuraEnabled
		public string MembershipState{ get; set; }

		@AuraEnabled
		public string MembershipZip{ get; set; }

		@AuraEnabled
		public string SSN{ get; set; }

		@AuraEnabled
		public string Type{ get; set; }

		@AuraEnabled
		public string MembershipEmail{ get; set; }

		@AuraEnabled
		public string MembershipPhone{ get; set; }
	}

	public class XpressRefiWrapperObject{
		@AuraEnabled
		public List<xPressRefi__c> xPressRefiList{ get; set; }

		@AuraEnabled
		public string MembershipAddress1{ get; set; }

		@AuraEnabled
		public string MembershipAddress2{ get; set; }

		@AuraEnabled
		public string MembershipCity{ get; set; }

		@AuraEnabled
		public string MembershipState{ get; set; }

		@AuraEnabled
		public string MembershipZip{ get; set; }
	}

	public class ProductsListWrapperObject{
		@AuraEnabled
		public string Product{ get; set; }

		@AuraEnabled
		public string ProductName{ get; set; }

		@AuraEnabled
		public decimal Rate{ get; set; }

		@AuraEnabled
		public decimal TotalPIPayment{ get; set; }

		@AuraEnabled
		public decimal MonthlySavings{ get; set; }

		@AuraEnabled
		public Boolean IsMortgageCadence{ get; set; }
	}
}