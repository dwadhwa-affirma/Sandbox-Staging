public class EFTToSyimtar{
	public static String EFTType;
	public static String AmountCode;
	public static String GroupNumber;
	public static String IDType;
	public static String ID;
	public static String Frequency;
	public static String Day1;
	public static String UpdateDay1;
	public static String Day2;
	public static String NextDate;
	public static String EffectiveDate;
	public static String PostAmount;
	public static String Payee;
	public static String Reference;
	public static String MatchID3;
	public static String AccountNumber;
	public static String ErrorEFTLocator;
	public static String PaymentMethod;
	public static String AlternatePayment = '';
	public static String LoanCode;
	public static List<string> LocatorsToExpire;
	public static String EftLocator;
	public static String jsonData;
	public static String jsonData1;
	public static String UpdatejsonData;
	public static String ExpirejsonData;
	public static HttpRequest req = new HttpRequest();
	public static HttpRequest req1 = new HttpRequest();
	public static HttpRequest Updatereq = new HttpRequest();
	public static HttpRequest ExpireReq = new HttpRequest();
	public static String result;
	public static List<EFT__c> EFTRecordsToUpdate = new List<EFT__c>();
	public static String OldPayee;
	public static String OldMatchID3;
	public static String OldReference;
	public static String OldAmountCode;
	public static String OldPostAmount;
	public static String OldAlternatePayment = '';
	public static String OldEffectiveDate;
	public static String OldFrequency;
	public static String OldDay1;
	public static List<EFTController.EFTWrapperObject> EFTExpiredList = new List<EFTController.EFTWrapperObject>();
	public static String loanAPI;
	public static String EpisysId;
	//-----------------Creating EFT in Episys-----------//
	@future(callout = true)
	public static void insertEFTs(Set<id> ids){
  
	  List<EFT__c> EFTlist = new List<EFT__c>();
	  List<EFT__c> EFTs = [SELECT Account_Number__c, Action_Type__c, Alternate_Amount__c, Bank_Name__c, CreatedById, CreatedDate, Day_of_Month__c, Second_Day_of_Month__c, DocuSignId__c, Effective_Date__c, Frequency__c, Id, Member_Account__c, Member_Account__r.Brand__c, Member_Account__r.Name, Case__c, Case__r.Description, Member__c, Name, OwnerId, Payment_Amount__c, Routing_Number__c, Share_Loan_Id__c, Stage__c, Status__c, Type__c, EFT_ID_Type__c, LoanCode__c, EFT_Payment_Date__c, Locators_To_Expire__c, case__r.Previous_Owner__c
						   FROM EFT__c
						   where id = :ids];
	  map<Id, String> CaseIdsToUpdate = new Map<Id, String>();
  
	  ACH_To_Episys_API_Details__c api = ACH_To_Episys_API_Details__c.getValues('ProductionURL');
  
	  if (api.URL__c != null){
		loanAPI = api.URL__c;
	  }
  
  
	  for (EFT__c e : EFTs){
  
		User currentUser = [SELECT id, alias
							from user
							where Id = :e.case__r.Previous_Owner__c];
		List<Episys_User__c> EpisysUser = [SELECT id, Alias__c, Episys_ID__c
										   from Episys_User__c
										   where Alias__c = :currentUser.alias
										   limit 1];
  
  
		if (EpisysUser.size() > 0){
		  EpisysId = String.Valueof(EpisysUser[0].Episys_ID__c);
		} else{
		  EpisysId = '';
		}
  
		EFTType = '3';
		if (e.Type__c == 'Savings')
		  AmountCode = '37';
		else
		  AmountCode = '27';
		if (e.Member_Account__r.Brand__c == 'Spectrum')
		  GroupNumber = '000006';
		else if (e.Member_Account__r.Brand__c == 'Chevron')
		  GroupNumber = '000001';
		else
		  GroupNumber = ' ';
		if (e.EFT_ID_Type__c == 'Share')
		  IDType = '0';
		else if (e.EFT_ID_Type__c == 'Loan')
		  IDType = '1';
		ID = e.Share_Loan_Id__c;
  
		if (e.Frequency__c != null){
		  if (e.Frequency__c == 'Monthly'){
			Frequency = '4';
		  } else if (e.Frequency__c == 'Semi-Monthly'){
			Frequency = '5';
		  }
		} else{
		  Frequency = '0';
		}
  
  
		if (e.Effective_Date__c != null){
		  Day1 = '0';//String.ValueOf(e.Day_of_Month__c);
		} else{
		  Day1 = '0';
		}
  
		if (e.Second_Day_of_Month__c != null){
		  Day2 = '0';//String.ValueOf(e.Second_Day_of_Month__c);
		} else{
		  Day2 = '0';
		}
  
		if (e.Effective_Date__c != null){
  
		  //NextDate = string.valueof(e.Effective_Date__c + 1);
		  EffectiveDate = string.valueof(e.Effective_Date__c);
		} else{
		  //NextDate = null;
		  EffectiveDate = null;
		}
  
		if (e.EFT_Payment_Date__c != null){
		  NextDate = string.valueof(e.EFT_Payment_Date__c);
		} else{
		  NextDate = null;
		}
  
		system.debug('e.Alternate_Amount__c' + e.Alternate_Amount__c);
		if (e.Alternate_Amount__c != null)
		  PostAmount = String.ValueOf(e.Alternate_Amount__c);
		else
		  PostAmount = '0.00';
		system.debug('PostAmount' + PostAmount);
  
		if (e.Alternate_Amount__c != null && e.Alternate_Amount__c != 0.0){
		  AlternatePayment = String.ValueOf(e.Alternate_Amount__c + e.Payment_Amount__c);
		} else{
		  AlternatePayment = String.ValueOf(e.Payment_Amount__c);
		}
  
		if (ID != null && ID.SubString(0, 2) == '28'){
		  PostAmount = AlternatePayment;
		} else{
		  PostAmount = '0.00';
		}
  
		Payee = e.Routing_Number__c.leftPad(10, '0');
		Reference = e.Account_Number__c;
		if (e.LoanCode__c != null){
		  LoanCode = e.LoanCode__c;
		} else{
		  LoanCode = getLoanCode(AccountNumber, ID);
		}
		if (e.Bank_Name__c != null){
		  MatchID3 = e.Bank_Name__c.toUpperCase().replace('&', '&#38;');
		  if (MatchID3.length() > 22){
			MatchID3 = MatchID3.left(22).toUpperCase().replace('&', '&#38;');
		  }
		}
		system.debug('MatchID3' + MatchID3);
		AccountNumber = e.Member_Account__r.Name;
  
  
		if (e.Locators_To_Expire__c != null && e.Locators_To_Expire__c != ''){
		  LocatorsToExpire = e.Locators_To_Expire__c.split(',');
		}
  
		/*-----------In Case of Multiple EFTs, First Expire All EFTS----------------*/
		if (LocatorsToExpire != null){
		  for (string l : LocatorsToExpire){
			ExpireReq.setEndpoint(loanAPI + '/EFT/UpdateEft');
  
			ExpireReq.setMethod('POST');
			ExpireReq.setHeader('Content-Type', 'application/json');
			ExpireReq.setHeader('Accept', 'application/json');
  
  
			ExpirejsonData = '{"EftLocator":' + '\"' + l + '\"' + ',"EffectiveDate":' + '\"' + EffectiveDate + '\"' + ',"IsUpdateExpirationDate":' + '\"' + true + '\"' + ',"isCalledFromUpdate":' + '\"' + true + '\"' + ',"AccountNumber":' + '\"' + AccountNumber + '\"' + ',"EpisysId":' + '\"' + EpisysId + '\"}';
			//jsonData = '{"EFTType": 3,"AmountCode": 27,"GroupNumber": "000001","IdType": 0, "ID": "0100", "Frequency": 4,"Day1": 0,"NextDate": "2019-01-08","EffectiveDate": "2019-01-09","PostAmount": "100.00", "Payee": "0322271627","Reference": "42006986568","MatchId3": "BANK OF AMERICA, N.A.","AccountNumber": "123"}';
			ExpireReq.setBodyAsBlob(Blob.valueof(ExpirejsonData));
			system.debug('ExpirejsonData' + ExpirejsonData);
  
			Http httpexp = new Http();
			ExpireReq.setTimeout(60000);
			HttpResponse resExp;
			String responseBodyExp;
			if (!Test.isRunningTest()){
			  resExp = httpexp.send(ExpireReq);
			  responseBodyExp = resExp.getBody();
			  System.debug('Response Body::' + resExp.getBody());
			} else{
			  responseBodyExp = '{"EFTType":"3","AmountCode":"27","GroupNumber":"1","IdType":"1","ID":"100","Frequency":"4","Day1":"1","NextDate":"01-01-2019","EffectiveDate":"01-01-2019","PostAmount":"100.00","Payee":"322271627","Reference":"42006986568","MatchId3":"BANK OF AMERICA","AccountNumber":"123"}';
			}
		  }
  
		}
  
		/*-----------Web serice call to Create EFT---------------*/
		//req.setEndpoint('https://brscsymx.ctxcu.org/dev/EFT/CreateEft');
		req.setEndpoint(loanAPI + '/EFT/CreateEft');
		//req.setClientCertificateName('brscmcapi');
		req.setMethod('POST');
		req.setHeader('Content-Type', 'application/json');
		req.setHeader('Accept', 'application/json');
  
		jsonData = '{"EFTType":' + '\"' + EFTType + '\"' + ',"AmountCode":' + '\"' + AmountCode + '\"' + ',"GroupNumber":' + '\"' + GroupNumber + '\"' + ',"IdType":' + '\"' + IDType + '\"' + ',"ID":' + '\"' + ID + '\"' + ',"Frequency":' + '\"' + Frequency + '\"' + ',"Day1":' + '\"' + Day1 + '\"' + ',"Day2":' + '\"' + Day2 + '\"' + ',"NextDate":' + '\"' + NextDate + '\"' + ',"EffectiveDate":' + '\"' + EffectiveDate + '\"' + ',"PostAmount":' + '\"' + PostAmount + '\"' + ',"Payee":' + '\"' + Payee + '\"' + ',"Reference":' + '\"' + Reference + '\"' + ',"MatchId3":' + '\"' + MatchID3 + '\"' + ',"AccountNumber":' + '\"' + AccountNumber + '\"' + ',"EpisysId":' + '\"' + EpisysId + '\"}';
		//jsonData = '{"EFTType": 3,"AmountCode": 27,"GroupNumber": "000001","IdType": 0, "ID": "0100", "Frequency": 4,"Day1": 0,"NextDate": "2019-01-08","EffectiveDate": "2019-01-09","PostAmount": "100.00", "Payee": "0322271627","Reference": "42006986568","MatchId3": "BANK OF AMERICA, N.A.","AccountNumber": "123"}';
		req.setBodyAsBlob(Blob.valueof(jsondata));
		system.debug('test' + jsonData);
  
		Http http = new Http();
		req.setTimeout(60000);
		HttpResponse res;
		String responseBody;
		if (!Test.isRunningTest()){
		  res = http.send(req);
		  responseBody = res.getBody();
		  System.debug('Response Body::' + res.getBody());
		} else{
		  responseBody = '{"EFTType":"3","AmountCode":"27","GroupNumber":"1","IdType":"1","ID":"100","Frequency":"4","Day1":"1","NextDate":"01-01-2019","EffectiveDate":"01-01-2019","PostAmount":"100.00","Payee":"322271627","Reference":"42006986568","MatchId3":"BANK OF AMERICA","AccountNumber":"123","EftLocator":"345"}';
		}
  
		String result;
  
		// JSon parse for Id
		result = String.valueOf(responseBody).substringAfter('EftLocator":"');
		result = String.valueOf(result).substringBefore('",');
		System.debug('EFTLocator' + result);
  
		if (result == null || result == ''){
  
		  ErrorEFTLocator = String.valueOf(responseBody).substringAfter('[MessageId=TESTING] ');
		  ErrorEFTLocator = String.valueOf(ErrorEFTLocator).substringBefore('","ErrorDetails"');
		  system.debug('ErrorEFTLocator' + ErrorEFTLocator);
		}
  
		/*-----------------------SI11042-5: Update Day1 Field------------------------*/
		String updateresult;
		string updateresultEFTLocator;
  
		if (result != null && result != ''){
  
		  if (e.Day_of_Month__c != null){
			UpdateDay1 = String.ValueOf(e.Day_of_Month__c);
		  } else{
			UpdateDay1 = '0';
		  }
  
		  if (ID != null && ID.SubString(0, 2) == '28'){
			UpdateDay1 = '1';
		  }
		  boolean isExpired = false;
		  Updatereq.setEndpoint(loanAPI + '/EFT/UpdateEft');
		  //req.setClientCertificateName('brscmcapi');
		  Updatereq.setMethod('POST');
		  Updatereq.setHeader('Content-Type', 'application/json');
		  Updatereq.setHeader('Accept', 'application/json');
  
  
		  UpdatejsonData = '{"EftLocator":' + '\"' + result + '\"' + ',"AmountCode":' + '\"' + AmountCode + '\"' + ',"Frequency":' + '\"' + Frequency + '\"' + ',"Day1":' + '\"' + UpdateDay1 + '\"' + ',"Day2":' + '\"' + Day2 + '\"' + ',"NextDate":' + '\"' + NextDate + '\"' + ',"EffectiveDate":' + '\"' + EffectiveDate + '\"' + ',"PostAmount":' + '\"' + PostAmount + '\"' + ',"Payee":' + '\"' + Payee + '\"' + ',"Reference":' + '\"' + Reference + '\"' + ',"MatchId3":' + '\"' + MatchID3 + '\"' + ',"IsUpdateExpirationDate":' + '\"' + isExpired + '\"' + ',"AccountNumber":' + '\"' + AccountNumber + '\"' + ',"EpisysId":' + '\"' + EpisysId + '\"}';
		  //jsonData = '{"EFTType": 3,"AmountCode": 27,"GroupNumber": "000001","IdType": 0, "ID": "0100", "Frequency": 4,"Day1": 0,"NextDate": "2019-01-08","EffectiveDate": "2019-01-09","PostAmount": "100.00", "Payee": "0322271627","Reference": "42006986568","MatchId3": "BANK OF AMERICA, N.A.","AccountNumber": "123"}';
		  Updatereq.setBodyAsBlob(Blob.valueof(UpdatejsonData));
		  system.debug('UpdatejsonData' + UpdatejsonData);
  
		  Http updatehttp = new Http();
		  Updatereq.setTimeout(60000);
		  HttpResponse Updateres;
		  String updateresponseBody;
		  if (!Test.isRunningTest()){
			Updateres = updatehttp.send(Updatereq);
			updateresponseBody = Updatereq.getBody();
			System.debug('Response Body::' + Updateres.getBody());
		  } else{
			updateresponseBody = '{"EFTType":"3","AmountCode":"27","GroupNumber":"1","IdType":"1","ID":"100","Frequency":"4","Day1":"1","NextDate":"01-01-2019","EffectiveDate":"01-01-2019","PostAmount":"100.00","Payee":"322271627","Reference":"42006986568","MatchId3":"BANK OF AMERICA","AccountNumber":"123"}';
		  }
  
		  // JSon parse for Id
		  updateresult = String.valueOf(responseBody).substringAfter('Status":"');
		  updateresult = String.valueOf(result).substringBefore('",');
		  System.debug('UpdateStatus' + updateresult);
  
		  updateresultEFTLocator = String.valueOf(updateresponseBody).substringAfter('EftLoctorId":"');
		  updateresultEFTLocator = String.valueOf(updateresultEFTLocator).substringBefore('",');
		  System.debug('updateresultEFTLocator' + updateresultEFTLocator);
		}
  
		/*-----------Update Loan/Tracking record based on Loan/Share Code---------------*/
		if (result != null && result != ''){
  
		  PaymentMethod = '5';
		  /*-----------Update LOC Loan---------------*/
		  if (LoanCode == '2'){
			System.debug('LoanCode');
			req1.setEndpoint(loanAPI + '/EFT/UpdateLOCLoanbyId');
			if (AlternatePayment != ''){
			  jsonData1 = '{"AccountNumber":' + '\"' + AccountNumber + '\","LoanId":' + '\"' + ID + '\"' + ',"PaymentMethod":' + '\"' + PaymentMethod + '\"' + ',"Payment":' + '\"' + e.Payment_Amount__c + '\"' + ',"AlternatePayment":' + '\"' + e.Alternate_Amount__c + '\"' + ',"EpisysId":' + '\"' + EpisysId + '\"}';
			} else{
			  jsonData1 = '{"AccountNumber":' + '\"' + AccountNumber + '\","LoanId":' + '\"' + ID + '\"' + ',"PaymentMethod":' + '\"' + PaymentMethod + ',"Payment":' + '\"' + e.Payment_Amount__c + '\"' + ',"EpisysId":' + '\"' + EpisysId + '\"}';
			}
		  }
		  /*-----------Update Tracking Records for Share---------------*/
		  else if (ID != null && ID.SubString(0, 2) == '28'){
			System.debug('Sweep Account');
			string uc3;
			uc3 = getUserChar3(AccountNumber, ID);
			System.debug('uc3==' + uc3);
			req1.setEndpoint(loanAPI + '/PSAuto/UpdateTracking32Records');
			jsonData1 = '{"AccountNumber":' + '\"' + AccountNumber + '\","ShareId":' + '\"' + ID + '\"' + ',"UserChar3":' + '\"' + uc3 + '\"' + ',"TotalPaymentAmount":' + '\"' + e.Payment_Amount__c + '\"' + ',"AdditionalPaymentAmount":' + '\"' + e.Alternate_Amount__c + '\"' + ',"NextPaymentDueDate":' + '\"' + EffectiveDate + '\"' + ',"EpisysId":' + '\"' + EpisysId + '\"}';
		  }
		  /*-----------Update Non-LOC Loan---------------*/
		  else{
			System.debug('LoanCode not 2');
			req1.setEndpoint(loanAPI + '/EFT/UpdateLoanById');
			if (AlternatePayment != ''){
			  jsonData1 = '{"AccountNumber":' + '\"' + AccountNumber + '\","LoanId":' + '\"' + ID + '\"' + ',"PaymentMethod":' + '\"' + PaymentMethod + '\"' + ',"AlternatePayment":' + '\"' + AlternatePayment + '\"' + ',"EpisysId":' + '\"' + EpisysId + '\"}';
			} else{
			  jsonData1 = '{"AccountNumber":' + '\"' + AccountNumber + '\","LoanId":' + '\"' + ID + '\"' + ',"PaymentMethod":' + '\"' + PaymentMethod + '\"' + ',"EpisysId":' + '\"' + EpisysId + '\"}';
			}
		  }
		  //system.System.debug(jsonData1);
		  //req1.setClientCertificateName('brscmcapi');
		  req1.setMethod('POST');
		  req1.setHeader('Content-Type', 'application/json');
		  req1.setHeader('Accept', 'application/json');
  
  
		  req1.setBodyAsBlob(Blob.valueof(jsondata1));
		  system.debug('test' + jsonData1);
  
		  Http http1 = new Http();
		  req1.setTimeout(60000);
		  HttpResponse res1;
		  String responseBody1;
		  if (!Test.isRunningTest()){
			res1 = http1.send(req1);
			responseBody1 = res1.getBody();
			System.debug('Response Body ACH::' + res1.getBody());
		  } else{
			responseBody1 = '{"Type":"3","Branch":"27","CreatedAtBranch":"1","PurposeCode":"1","CollateralCode":"100","ApprovalCode":"4","OriginalBalance":"1","ApprovalDate":"01-01-2019","MaturityDate":"01-01-2019","DueDate":"01-01-2019","FirstPaymentDate":"01-01-2019","DueDay1":"1","Payment":"1234","CouponCode":"123", "PaymentMethod" : "PaymentMethod", "Description" : "Description", "InterestRate" : "2.00", "UserAmount1" : "200.00", "ECOACode" : "778", "CreditScore" : "15", "PaymentCount" : "12", "PaymentFrequency" : "67"}';
		  }
  
  
		  string casedesc = e.Case__r.Description + '\n \n ACH DocuSign Values \n Type: ' + e.Type__c + '\n' + 'Funding FI: ' + e.Bank_Name__c + '\n' + 'ABA/Routing#: ' + e.Routing_Number__c + '\n' + 'Account Number: ' + e.Account_Number__c + '\n' + 'Additional Payment Amount: ' + e.Alternate_Amount__c + '\n' + '\n' + 'EFT Locator: ' + result;
		  CaseIdsToUpdate.put(e.Case__c, casedesc);
		}
  
		//EFT__c s = new EFT__c();
  
		if (result != null && result != '')
		  e.EftLocator__c = result;
		if (ErrorEFTLocator != null && ErrorEFTLocator != '')
		  e.Error_EftLocator__c = ErrorEFTLocator;
		else
		  e.Error_EftLocator__c = '';
		// s.id = sl.Id;
		EFTRecordsToUpdate.add(e);
  
		/*-----------Create EFT Note---------------*/
		CreateEFTFormNote(AccountNumber, IDType.leftPad(2, '0'), ID, string.valueof(e.Alternate_Amount__c + e.Payment_Amount__c), 'N', EpisysId);
  
	  }
	  update EFTRecordsToUpdate;
  
	  /*-----------Attach Docusign to Case---------------*/
	  EFTToDocuSign.docusignAttachtoCase(ids);
  
  
	  /*-----------Update Case Status and Description--------------*/
	  if (CaseIdsToUpdate.size() > 0){
		List<Case> UpdateCasesList = [select id, status
									  from case
									  where id in :CaseIdsToUpdate.keySet() and Status<>'Closed'];
  
		system.debug('UpdateCasesList==' + UpdateCasesList);
		if (UpdateCasesList.size() > 0){
		  for (Case cs : UpdateCasesList){
			cs.Description = CaseIdsToUpdate.get(cs.id);
			//cs.OwnerId = UserInfo.getUserId();
			cs.status = 'Closed';
		  }
		  update UpdateCasesList;
		}
  
	  }
	}
  
	//-----------------Updating EFT in Episys-----------//
	@future(callout = true)
	public static void UpdateEFT(Set<id> ids, boolean isExpired){
	  system.debug('ids' + ids);
	  system.debug('isExpired' + isExpired);
	  List<EFT__c> EFTlist = new List<EFT__c>();
	  List<EFT__c> EFTs = [SELECT Account_Number__c, Action_Type__c, Alternate_Amount__c, Bank_Name__c, CreatedById, CreatedDate, Day_of_Month__c, Second_Day_of_Month__c, DocuSignId__c, Effective_Date__c, Frequency__c, Id, Member_Account__c, Member_Account__r.Brand__c, Member_Account__r.Name, Member__c, Name, Case__c, Case__r.Description, OwnerId, Payment_Amount__c, Routing_Number__c, Share_Loan_Id__c, Stage__c, EftLocator__c, Share_Loan_Description__c, Share_Loan_Type__c, Member_Name__c, Status__c, Type__c, EFT_ID_Type__c, LoanCode__c, EFT_Payment_Date__c, Locators_To_Expire__c, Existing_Alternate_Amount__c, case__r.Previous_Owner__c
						   FROM EFT__c
						   where id = :ids];
  
	  map<Id, String> CaseIdsToUpdate = new Map<Id, String>();
	  //else{
  
	  ACH_To_Episys_API_Details__c api = ACH_To_Episys_API_Details__c.getValues('ProductionURL');
  
	  if (api.URL__c != null){
		loanAPI = api.URL__c;
	  }  
  
	  for (EFT__c e : EFTs){
  
		User currentUser = [SELECT id, alias
							from user
							where Id = :e.case__r.Previous_Owner__c];
		List<Episys_User__c> EpisysUser = [SELECT id, Alias__c, Episys_ID__c
										   from Episys_User__c
										   where Alias__c = :currentUser.alias
										   limit 1];
  
  
		if (EpisysUser.size() > 0){
		  EpisysId = String.Valueof(EpisysUser[0].Episys_ID__c);
		} else{
		  EpisysId = '';
		}
  
		EftLocator = e.EftLocator__c;
		EFTType = '3';
		if (e.Type__c == 'Savings')
		  AmountCode = '37';
		else
		  AmountCode = '27';
		ID = e.Share_Loan_Id__c;
		if (e.Frequency__c != null){
		  if (e.Frequency__c == 'Monthly'){
			Frequency = '4';
		  } else if (e.Frequency__c == 'Semi-Monthly'){
			Frequency = '5';
		  }
		} else{
		  Frequency = '0';
		}
		//Frequency = '4';
  
		if (e.Day_of_Month__c != null){
		  Day1 = String.ValueOf(e.Day_of_Month__c);
		} else{
		  Day1 = '0';
		}
  
		if (e.Second_Day_of_Month__c != null){
		  Day2 = '0';//String.ValueOf(e.Second_Day_of_Month__c);
		} else{
		  Day2 = '0';
		}
		if (e.Effective_Date__c != null){
  
		  //NextDate = string.valueof(e.Effective_Date__c + 1);
		  EffectiveDate = string.valueof(e.Effective_Date__c);
		} else{
		  //NextDate = null;
		  EffectiveDate = null;
		}
  
		if (e.EFT_Payment_Date__c != null){
		  NextDate = string.valueof(e.EFT_Payment_Date__c);
		} else{
		  NextDate = null;
		}
  
  
		if (e.Alternate_Amount__c != null)
		  PostAmount = String.ValueOf(e.Alternate_Amount__c);
		else
		  PostAmount = '0.00';
		if (e.Alternate_Amount__c != null && e.Alternate_Amount__c != 0.0){
		  AlternatePayment = String.ValueOf(e.Alternate_Amount__c + e.Payment_Amount__c);
		} else if (e.Existing_Alternate_Amount__c != null && e.Existing_Alternate_Amount__c != 0.0){
		  AlternatePayment = String.ValueOf(e.Existing_Alternate_Amount__c + e.Payment_Amount__c);
		} else{
		  AlternatePayment = String.ValueOf(e.Payment_Amount__c);
		}
  
		if (ID != null && ID.SubString(0, 2) == '28'){
		  PostAmount = AlternatePayment;
		  Day1 = '1';
		} else{
		  PostAmount = '0.00';
		}
  
		if (e.EFT_ID_Type__c == 'Share')
		  IDType = '0';
		else if (e.EFT_ID_Type__c == 'Loan')
		  IDType = '1';
		Payee = e.Routing_Number__c.leftPad(10, '0');
		Reference = e.Account_Number__c;
		//LoanCode = e.LoanCode__c;
		if (e.LoanCode__c != null){
		  LoanCode = e.LoanCode__c;
		} else{
		  LoanCode = getLoanCode(AccountNumber, ID);
		}
		if (e.Bank_Name__c != null){
		  MatchID3 = e.Bank_Name__c.toUpperCase().replace('&', '&#38;');
		  if (MatchID3.length() > 22){
			MatchID3 = MatchID3.left(22).toUpperCase().replace('&', '&#38;');
		  }
		}
		system.debug('Reference' + Reference);
		AccountNumber = e.Member_Account__r.Name;
  
		if (!isExpired){
		  /*-----------In Case of Multiple EFTs, First Expire All EFTS----------------*/
		  if (e.Locators_To_Expire__c != null && e.Locators_To_Expire__c != ''){
			LocatorsToExpire = e.Locators_To_Expire__c.split(',');
		  }
		  if (LocatorsToExpire != null){
			for (string l : LocatorsToExpire){
			  ExpireReq.setEndpoint(loanAPI + '/EFT/UpdateEft');
			  //req.setClientCertificateName('brscmcapi');
			  ExpireReq.setMethod('POST');
			  ExpireReq.setHeader('Content-Type', 'application/json');
			  ExpireReq.setHeader('Accept', 'application/json');
  
  
			  ExpirejsonData = '{"EftLocator":' + '\"' + l + '\"' + ',"EffectiveDate":' + '\"' + EffectiveDate + '\"' + ',"IsUpdateExpirationDate":' + '\"' + true + '\"' + ',"isCalledFromUpdate":' + '\"' + true + '\"' + ',"AccountNumber":' + '\"' + AccountNumber + '\"' + ',"EpisysId":' + '\"' + EpisysId + '\"}';
			  //jsonData = '{"EFTType": 3,"AmountCode": 27,"GroupNumber": "000001","IdType": 0, "ID": "0100", "Frequency": 4,"Day1": 0,"NextDate": "2019-01-08","EffectiveDate": "2019-01-09","PostAmount": "100.00", "Payee": "0322271627","Reference": "42006986568","MatchId3": "BANK OF AMERICA, N.A.","AccountNumber": "123"}';
			  ExpireReq.setBodyAsBlob(Blob.valueof(ExpirejsonData));
			  system.debug('ExpirejsonData' + ExpirejsonData);
  
			  Http httpexp = new Http();
			  ExpireReq.setTimeout(60000);
			  HttpResponse resExp;
			  String responseBodyExp;
			  if (!Test.isRunningTest()){
				resExp = httpexp.send(ExpireReq);
				responseBodyExp = resExp.getBody();
				System.debug('Response Body::' + resExp.getBody());
			  } else{
				responseBodyExp = '{"EFTType":"3","AmountCode":"27","GroupNumber":"1","IdType":"1","ID":"100","Frequency":"4","Day1":"1","NextDate":"01-01-2019","EffectiveDate":"01-01-2019","PostAmount":"100.00","Payee":"322271627","Reference":"42006986568","MatchId3":"BANK OF AMERICA","AccountNumber":"123"}';
			  }
  
			}
		  }
		}
  
		/*-----------Web serice call to Update EFT---------------*/
		//req.setEndpoint('https://brscsymx.ctxcu.org/dev/EFT/CreateEft');
		req.setEndpoint(loanAPI + '/EFT/UpdateEft');
		//req.setClientCertificateName('brscmcapi');
		req.setMethod('POST');
		req.setHeader('Content-Type', 'application/json');
		req.setHeader('Accept', 'application/json');
  
  
		jsonData = '{"EftLocator":' + '\"' + EftLocator + '\"' + ',"AmountCode":' + '\"' + AmountCode + '\"' + ',"Frequency":' + '\"' + Frequency + '\"' + ',"Day1":' + '\"' + Day1 + '\"' + ',"Day2":' + '\"' + Day2 + '\"' + ',"NextDate":' + '\"' + NextDate + '\"' + ',"EffectiveDate":' + '\"' + EffectiveDate + '\"' + ',"PostAmount":' + '\"' + PostAmount + '\"' + ',"Payee":' + '\"' + Payee + '\"' + ',"Reference":' + '\"' + Reference + '\"' + ',"MatchId3":' + '\"' + MatchID3 + '\"' + ',"IsUpdateExpirationDate":' + '\"' + isExpired + '\"' + ',"AccountNumber":' + '\"' + AccountNumber + '\"' + ',"EpisysId":' + '\"' + EpisysId + '\"}';
		//jsonData = '{"EFTType": 3,"AmountCode": 27,"GroupNumber": "000001","IdType": 0, "ID": "0100", "Frequency": 4,"Day1": 0,"NextDate": "2019-01-08","EffectiveDate": "2019-01-09","PostAmount": "100.00", "Payee": "0322271627","Reference": "42006986568","MatchId3": "BANK OF AMERICA, N.A.","AccountNumber": "123"}';
		req.setBodyAsBlob(Blob.valueof(jsondata));
		system.debug('test' + jsonData);
  
		Http http = new Http();
		req.setTimeout(60000);
		HttpResponse res;
		String responseBody;
		if (!Test.isRunningTest()){
		  res = http.send(req);
		  responseBody = res.getBody();
		  System.debug('Response Body::' + res.getBody());
		} else{
		  responseBody = '{"EFTType":"3","AmountCode":"27","GroupNumber":"1","IdType":1,"ID":"100","Frequency":"4","Day1":"1","NextDate":"01-01-2019","EffectiveDate":"01-01-2019","PostAmount":"100.00","Payee":"322271627","Reference":"42006986568","MatchId3":"BANK OF AMERICA","AccountNumber":"123","Status":"OK"}';
		}
  
		String result;
		string resultEFTLocator, resultExpDate;
  
		// Parse JSON response to get all the totalPrice field values.
		JSONParser parser = JSON.createParser(responseBody);
		/*-----------Get Old Values to use in Case Description field---------------*/
		while (parser.nextToken() != null){
		  //system.debug('parser.getCurrentToken()=' + parser.getCurrentToken());
		  //system.debug('JSONToken.FIELD_NAME=' + JSONToken.FIELD_NAME);
		  //system.debug('parser.getText()=' + parser.getText());
		  if ((parser.getCurrentToken() == JSONToken.FIELD_NAME) && (parser.getText() == 'OldPayee')){
			// Get the value.
			parser.nextToken();
			// Compute the grand total price for all invoices.
			OldPayee = parser.getText();
		  }
  
		  if ((parser.getCurrentToken() == JSONToken.FIELD_NAME) && (parser.getText() == 'IdType')){
			// Get the value.
			parser.nextToken();
			// Compute the grand total price for all invoices.
			IDType = string.valueof(parser.getIntegerValue());
		  }
  
		  if ((parser.getCurrentToken() == JSONToken.FIELD_NAME) && (parser.getText() == 'Id')){
			// Get the value.x``
			parser.nextToken();
			// Compute the grand total price for all invoices.
			ID = parser.getText();
		  }
  
		  if ((parser.getCurrentToken() == JSONToken.FIELD_NAME) && (parser.getText() == 'OldMatchID3')){
			// Get the value.
			parser.nextToken();
			// Compute the grand total price for all invoices.
			OldMatchID3 = parser.getText();
		  }
  
		  if ((parser.getCurrentToken() == JSONToken.FIELD_NAME) && (parser.getText() == 'OldReference')){
			// Get the value.
			parser.nextToken();
			// Compute the grand total price for all invoices.
			OldReference = parser.getText();
		  }
  
		  if ((parser.getCurrentToken() == JSONToken.FIELD_NAME) && (parser.getText() == 'OldAmountCode')){
			// Get the value.
			parser.nextToken();
			// Compute the grand total price for all invoices.
			OldAmountCode = parser.getText();
			if (OldAmountCode == '37'){
			  OldAmountCode = 'Savings';
			} else{
			  OldAmountCode = 'Checking';
			}
		  }
  
		  if ((parser.getCurrentToken() == JSONToken.FIELD_NAME) && (parser.getText() == 'OldPostAmount')){
  
			// Get the value.
			parser.nextToken();
			//system.debug('aaa='+parser.getDecimalValue());
			system.debug('bbb=' + parser.getText());
			// Compute the grand total price for all invoices.
			OldPostAmount = parser.getText();
		  }
  
		  if ((parser.getCurrentToken() == JSONToken.FIELD_NAME) && (parser.getText() == 'OldEffectiveDate')){
			// Get the value.
			parser.nextToken();
			// Compute the grand total price for all invoices.
			OldEffectiveDate = parser.getText();
		  }
  
		  if ((parser.getCurrentToken() == JSONToken.FIELD_NAME) && (parser.getText() == 'OldFrequency')){
			// Get the value.
			parser.nextToken();
			// Compute the grand total price for all invoices.
			OldFrequency = parser.getText();
			if (OldFrequency == '4'){
			  OldFrequency = 'Monthly';
			} else if (OldFrequency == '5'){
			  OldFrequency = 'Semi-Monthly';
			}
		  }
  
		  if ((parser.getCurrentToken() == JSONToken.FIELD_NAME) && (parser.getText() == 'OldDay1')){
			// Get the value.
			parser.nextToken();
			// Compute the grand total price for all invoices.
			OldDay1 = parser.getText();
		  }
  
		  if ((parser.getCurrentToken() == JSONToken.FIELD_NAME) && (parser.getText() == 'EftLoctorId')){
			// Get the value.
			parser.nextToken();
			// Compute the grand total price for all invoices.
			resultEFTLocator = parser.getText();
		  }
  
  
		  if ((parser.getCurrentToken() == JSONToken.FIELD_NAME) && (parser.getText() == 'Status')){
			// Get the value.
			parser.nextToken();
			// Compute the grand total price for all invoices.
			result = parser.getText();
		  }
  
  
		  if ((parser.getCurrentToken() == JSONToken.FIELD_NAME) && (parser.getText() == 'ExpirationDate')){
			// Get the value.
			parser.nextToken();
			// Compute the grand total price for all invoices.
			resultExpDate = parser.getText();
		  }
  
  
		}
  
  
		if (IDType == '0'){
		  map<string, string> resultAmount = EFTController.getTrackingRecordforShare(AccountNumber, ID);
		  if (resultAmount != null){
			OldPostAmount = resultAmount.get('Payment');
			OldAlternatePayment = resultAmount.get('AlternateAmount');
		  }
		} else if (IDType == '1'){
		  // if (LoanCode == '2'){
		  //     OldAlternatePayment = OldPostAmount;
		  // }
		  // else if (ID != null && ID.SubString(0, 2) == '28'){
  
		  // }
		  // else{
  
		  // }
		  OldAlternatePayment = OldPostAmount;
		  Map<string, List<EFTController.ShareLoanWrapperObject>> LoanMap = EFTController.getLoanAccounts(AccountNumber, '');
		  List<EFTController.ShareLoanWrapperObject> LoanList = LoanMap.get('LoanList');
		  if (LoanList != null){
			for (EFTController.ShareLoanWrapperObject sl : LoanList){
			  system.debug('sl.ShareLoanID=' + sl.ShareLoanID);
			  if (sl.ShareLoanID.leftPad(4, '0') == ID){
				OldPostAmount = string.valueof(sl.Payment);
				//OldAlternatePayment = resultAmount.get('AlternateAmount');
			  }
			}
		  }
		}
  
		system.debug('OldPayee=' + OldPayee);
		system.debug('OldMatchID3=' + OldMatchID3);
		system.debug('OldReference=' + OldReference);
		system.debug('OldAmountCode=' + OldAmountCode);
		system.debug('OldPostAmount=' + OldPostAmount);
		system.debug('OldAlternatePayment=' + OldAlternatePayment);
		system.debug('OldEffectiveDate=' + OldEffectiveDate);
		system.debug('OldFrequency=' + OldFrequency);
		system.debug('OldDay1=' + OldDay1);
		system.debug('IDType=' + IDType);
		system.debug('ID=' + ID);
  
		string listObject = String.valueOf(responseBody).substringAfter('updatedEFTFieldValues":');
		System.debug('listObject' + listObject);
		listObject = String.valueOf(listObject).substringBefore(',"Status"');
		System.debug('listObject' + listObject);
		if (listObject != null && listObject != '')
		  EFTExpiredList = (List<EFTController.EFTWrapperObject>)JSON.deserialize(listObject, List<EFTController.EFTWrapperObject>.class);
		System.debug('EFTExpiredList==' + EFTExpiredList);
		System.debug('Status' + result);
  
		System.debug('EFTLocator' + resultEFTLocator);
		System.debug('resultExpDate' + resultExpDate);
  
		if (result != 'OK'){
  
		  ErrorEFTLocator = String.valueOf(responseBody).substringAfter('[MessageId=TESTING] ');
		  ErrorEFTLocator = String.valueOf(ErrorEFTLocator).substringBefore('","ErrorDetails"');
		  system.debug('ErrorEFTLocator' + ErrorEFTLocator);
		} else if (result == 'OK'){
		  PaymentMethod = '5';
		  String TempAlternatePayment = '';
		  if (e.Alternate_Amount__c != null && e.Alternate_Amount__c != 0.0){
			TempAlternatePayment = String.ValueOf(e.Alternate_Amount__c);
		  } else if (e.Existing_Alternate_Amount__c != null && e.Existing_Alternate_Amount__c != 0.0){
			TempAlternatePayment = String.ValueOf(e.Existing_Alternate_Amount__c);
		  } else{
			TempAlternatePayment = '0.0';
		  }
		  /*-----------Update LOC Loan---------------*/
		  if (LoanCode == '2'){
			System.debug('LoanCode');
			req1.setEndpoint(loanAPI + '/EFT/UpdateLOCLoanbyId');
			if (AlternatePayment != ''){
			  jsonData1 = '{"AccountNumber":' + '\"' + AccountNumber + '\","LoanId":' + '\"' + ID + '\"' + ',"PaymentMethod":' + '\"' + PaymentMethod + '\"' + ',"Payment":' + '\"' + e.Payment_Amount__c + '\"' + ',"AlternatePayment":' + '\"' + TempAlternatePayment + '\"' + ',"EpisysId":' + '\"' + EpisysId + '\"}';
			} else{
			  jsonData1 = '{"AccountNumber":' + '\"' + AccountNumber + '\","LoanId":' + '\"' + ID + '\"' + ',"PaymentMethod":' + '\"' + PaymentMethod + '\"' + ',"Payment":' + '\"' + e.Payment_Amount__c + '\"' + ',"EpisysId":' + '\"' + EpisysId + '\"}';
			}
		  }
		  /*-----------Update Tracking Records for Share---------------*/
		  else if (ID != null && ID.SubString(0, 2) == '28'){
			System.debug('Sweep Account');
			string uc3;
			uc3 = getUserChar3(AccountNumber, ID);
			System.debug('uc3==' + uc3);
			req1.setEndpoint(loanAPI + '/PSAuto/UpdateTracking32Records');
			jsonData1 = '{"AccountNumber":' + '\"' + AccountNumber + '\","ShareId":' + '\"' + ID + '\"' + ',"UserChar3":' + '\"' + uc3 + '\"' + ',"TotalPaymentAmount":' + '\"' + e.Payment_Amount__c + '\"' + ',"AdditionalPaymentAmount":' + '\"' + TempAlternatePayment + '\"' + ',"NextPaymentDueDate":' + '\"' + NextDate + '\"' + ',"EpisysId":' + '\"' + EpisysId + '\"}';
			//System.debug('jsonData1=='+jsonData1);
		  }
		  /*-----------Update Non-LOC Loan---------------*/
		  else{
			System.debug('LoanCode not 2');
			req1.setEndpoint(loanAPI + '/EFT/UpdateLoanById');
			if (AlternatePayment != ''){
			  jsonData1 = '{"AccountNumber":' + '\"' + AccountNumber + '\","LoanId":' + '\"' + ID + '\"' + ',"AlternatePayment":' + '\"' + AlternatePayment + '\"' + ',"EpisysId":' + '\"' + EpisysId + '\"}';
			} else{
			  jsonData1 = '{"AccountNumber":' + '\"' + AccountNumber + '\","LoanId":' + '\"' + ID + '\"' + ',"PaymentMethod":' + '\"' + PaymentMethod + '\"' + ',"EpisysId":' + '\"' + EpisysId + '\"}';
			}
		  }
  
		  system.debug('jsonData1' + jsonData1);
		  //req1.setEndpoint('https://symxapi.chevronfcu.org/devclient/EFT/UpdateLoanById');
		  //req1.setClientCertificateName('brscmcapi');
		  req1.setMethod('POST');
		  req1.setHeader('Content-Type', 'application/json');
		  req1.setHeader('Accept', 'application/json');
		  system.debug('AlternatePayment' + AlternatePayment);
		  system.debug('isExpired' + isExpired);
  
		  if (AlternatePayment != '' && !isExpired){
  
			req1.setBodyAsBlob(Blob.valueof(jsondata1));
			system.debug('test' + jsonData1);
  
			Http http1 = new Http();
			req1.setTimeout(60000);
			HttpResponse res1;
			String responseBody1;
			if (!Test.isRunningTest()){
			  res1 = http1.send(req1);
			  responseBody1 = res1.getBody();
			  System.debug('Response Body ACH::' + res1.getBody());
			} else{
			  responseBody1 = '{"Type":"3","Branch":"27","CreatedAtBranch":"1","PurposeCode":"1","CollateralCode":"100","ApprovalCode":"4","OriginalBalance":"1","ApprovalDate":"01-01-2019","MaturityDate":"01-01-2019","DueDate":"01-01-2019","FirstPaymentDate":"01-01-2019","DueDay1":"1","Payment":"1234","CouponCode":"123", "PaymentMethod" : "PaymentMethod", "Description" : "Description", "InterestRate" : "2.00", "UserAmount1" : "200.00", "ECOACode" : "778", "CreditScore" : "15", "PaymentCount" : "12", "PaymentFrequency" : "67"}';
			}
		  }
  
  
		  if (isExpired){
			system.debug('e.Member_Name__c===' + e.Member_Name__c);
			string operation = 'ACH Record Expired' + '\n' + 'Member Name:' + e.Member_Name__c + '\n' + 'Share/Loan:' + e.Share_Loan_Id__c + '\n\n';
			for (EFTController.EFTWrapperObject ef : EFTExpiredList){
			  date expDate = Date.valueOf(ef.ExpirationDate);
			  Datetime dt = datetime.newInstance(Date.valueOf(expDate).year(), Date.valueOf(expDate).month(), Date.valueOf(expDate).day());
			  string typeexp, freqExp;
			  if (ef.AmountCode == '37')
				typeexp = 'Savings';
			  else
				typeexp = 'Checking';
			  if (ef.Frequency == '4'){
				freqExp = 'Monthly';
			  } else if (ef.Frequency == '5'){
				freqExp = 'Semi-Monthly';
			  }
			  operation = operation + 'EFT Locator: ' + ef.Locator + '\n' + 'Expiration Date:' + dt.format('MM/dd/yyyy')+'\n' + 'ABA/Routing#:' + ef.Payee + '\n' + 'Funding FI:' + ef.MatchID3 + '\n' + 'Account Number:' + ef.Reference + '\n' + 'Type:' + typeexp + '\n' + 'Effective Date:' + dt.format('MM/dd/yyyy')+'\n' + 'Frequency:' + freqExp + '\n' + 'Day of Month:' + ef.Day1 + '\n' + '\n';//'Payment Amount:' + e.Payment_Amount__c + '\n' + 'Additional Payment Amount:' + (e.Alternate_Amount__c == null ? 0 : e.Alternate_Amount__c)
			}
			CaseIdsToUpdate.put(e.Case__c, operation);
		  } else{
			string casedesc = e.Case__r.Description + '\n \n Old ACH Values \n ABA/Routing#: ' + OldPayee + '\n' + 'Funding FI: ' + OldMatchID3 + '\n' + 'Account Number: ' + OldReference + '\n' + 'Type: ' + OldAmountCode + '\n' + 'Payment Amount: ' + OldPostAmount + '\n' + 'Additional Payment Amount: ' + OldAlternatePayment + '\n' + 'Effective Date: ' + OldEffectiveDate + '\n' + 'Frequency: ' + OldFrequency + '\n' + 'Day of Month: ' + OldDay1 + '\n \n ACH DocuSign Values \n Type: ' + e.Type__c + '\n' + 'Funding FI: ' + e.Bank_Name__c + '\n' + 'ABA/Routing#: ' + e.Routing_Number__c + '\n' + 'Account Number: ' + e.Account_Number__c + '\n' + 'Additional Payment Amount: ' + e.Alternate_Amount__c + '\n' + '\n' + 'EFT Locator: ' + EftLocator;
			CaseIdsToUpdate.put(e.Case__c, casedesc);
		  }
		  /*-----------Create EFT in SF if Expire and Create EFT---------------*/
		  if (resultEFTLocator != '' && resultEFTLocator != null && EftLocator != resultEFTLocator){
			e.expired__c = true;
			e.Expiration_Date__c = Date.valueOf(resultExpDate);
			EFT__c newEFT = e.clone(false);
			newEFT.expired__c = false;
			newEFT.Expiration_Date__c = null;
			newEFT.EftLocator__c = resultEFTLocator;
			newEFT.Share_Loan_Description__c = e.Share_Loan_Description__c;
			newEFT.Share_Loan_Type__c = e.Share_Loan_Type__c;
			newEFT.Case__c = e.Case__c;
			insert newEFT;
		  }
		}
  
  
		//EFT__c s = new EFT__c();
  
  
		if (ErrorEFTLocator != null && ErrorEFTLocator != '')
		  e.Error_EftLocator__c = ErrorEFTLocator;
		else
		  e.Error_EftLocator__c = '';
		// s.id = sl.Id;
  
  
		EFTRecordsToUpdate.add(e);
		/*-----------Create EFT Note---------------*/
		if (!isExpired)
		  CreateEFTFormNote(AccountNumber, IDType.leftPad(2, '0'), ID, string.valueof(e.Alternate_Amount__c + e.Payment_Amount__c), 'N', EpisysId);
		else{
		  CreateEFTFormNote(AccountNumber, IDType.leftPad(2, '0'), ID, string.valueof(e.Alternate_Amount__c + e.Payment_Amount__c), 'Y', EpisysId);
		}
	  }
	  //}
	  update EFTRecordsToUpdate;
  
	  /*-----------Attach Docusign to Case---------------*/
	  if (!isExpired){
		EFTToDocuSign.docusignAttachtoCase(ids);
	  }
	  
  
	  /*-----------Update Case Status and Description--------------*/
	  if (CaseIdsToUpdate.size() > 0){
		List<Case> UpdateCasesList = [select id, status
									  from case
									  where id in :CaseIdsToUpdate.keySet()];
		for (Case cs : UpdateCasesList){
		  cs.Description = CaseIdsToUpdate.get(cs.id);
		  //cs.OwnerId = UserInfo.getUserId();
		  cs.Status = 'Closed';
		}
		update UpdateCasesList;
	  }
	}
  
	//-----------------Getting Loan Code-----------//
	public static string getLoanCode(string AccountNumber, string LoanID){
	  string LoanCode;
	  Map<string, List<EFTController.ShareLoanWrapperObject>> LoanMap = EFTController.getLoanAccounts(AccountNumber, '');
	  List<EFTController.ShareLoanWrapperObject> LoanList = LoanMap.get('LoanList');
	  if (LoanList != null){
		for (EFTController.ShareLoanWrapperObject sl : LoanList){
		  if (sl.ShareLoanID == LoanID){
			LoanCode = sl.LoanCode;
		  }
		}
	  }
	  return LoanCode;
	}
  
	//-----------------Getting UserChar3 value of Share Record-----------//
	public static string getUserChar3(string AccountNumber, string ShareID){
	  string userchar3;
	  httpRequest requestparam = new httpRequest();
	  //requestparam.setTimeout(10);
	  requestparam.setEndpoint(loanAPI + '/PSAuto/GetSharesEFT?AccountNumber=' + AccountNumber + '&userchar2=abc');
	  requestparam.setMethod('GET');
  
	  try{
		http httpParam = new http();
		HttpResponse response;
		String responseBody1;
		String strStatus, strBody;
		if (!Test.isRunningTest()){
		  response = httpParam.send(requestparam);
  
		  strStatus = response.getStatus();
		  strBody = response.getBody();
		} else{
		  strBody = '[{"Order":100,"AvailableBalance":null,"Id":null,"Type":1,"AccountType":"SHARE #2800 - JOINT OWNER ","NameAndBalance":" Available Balance( $)","AccountNumber":"0000000123","Description":"PRIMARY SHARE","UserChar3":"","UserAmount2":0.00}]';
		}
  
		System.debug('strStatus ....' + strStatus);
		System.debug('strBody ....' + strBody);
  
		if (strBody != ''){
		  List<Object> results = (List<Object>)JSON.deserializeUntyped(strBody);
		  System.debug('Service response is ....' + results);
  
		  if (results != null){
			for (Object t : results){
			  map<string, object> localAcc = (map<string, object>)t;
			  string accouttype = (string)localAcc.get('AccountType');
			  string ShareId1 = accouttype.split(' ')[1].replace('#', '');
  
			  if (ShareId1 != '0' && ShareId1 == ShareID){
				//&& ShareId == 2800
				userchar3 = (string)localAcc.get('UserChar3');
			  }
			}
		  }
		}
	  } catch (System.CalloutException e){
		system.debug('Exception');
  
	  }
	  return userchar3;
	}
  
	//-----------------Creating EFT Form Note from Episys-----------//
	public static void CreateEFTFormNote(string AccountNumber, string IDType, string ID, string Amount, string isExpired, string EpisysId){
	  String dateFormatString = 'MM/dd/yy';
	  String dateFormatString1 = 'MMddyy';
	  Date d = Date.today();
	  Datetime dt = Datetime.newInstance(d.year(), d.month(), d.day());
	  String dateString = dt.format(dateFormatString);
	  String dateString1 = dt.format(dateFormatString1);
	  System.debug(dateString);
	  System.debug(dateString1);
	  httpRequest requestparam = new httpRequest();
	  //requestparam.setTimeout(10);
	  requestparam.setEndpoint(loanAPI + '/EFT/CreateEFTFormNote');
	  //?RGUserChr1=' + AccountNumber + '&RGUserChr2=' + dateString +  '&RGUserChr3=' + IDType + ID + '&RGUserChr4=' + Amount + '&RGUserChr5=' + dateString1 + '|' + isExpired);
	  requestparam.setMethod('POST');
	  requestparam.setHeader('Content-Type', 'application/json');
	  requestparam.setHeader('Accept', 'application/json');
	  string EFTNotejsonData = '{"RGUserChr1":' + '\"' + AccountNumber + '\"' + ',"RGUserChr2":' + '\"' + dateString + '\"' + ',"RGUserChr3":' + '\"' + IDType + ID + '\"' + ',"RGUserChr4":' + '\"' + Amount + '\"' + ',"RGUserChr5":' + '\"' + dateString1 + '|' + isExpired + '\"' + ',"EpisysId":' + '\"' + EpisysId + '\"}';
	  system.debug('EFTNotejsonData' + EFTNotejsonData);
	  requestparam.setBody(EFTNotejsonData);
  
  
	  try{
		Http http = new Http();
		req.setTimeout(60000);
		HttpResponse res;
		String responseBody;
		if (!Test.isRunningTest()){
		  res = http.send(requestparam);
		  responseBody = res.getBody();
		  System.debug('Response Body::' + res.getBody());
		}
  
	  } catch (System.CalloutException e){
		system.debug('Exception');
  
	  }
	}
  }