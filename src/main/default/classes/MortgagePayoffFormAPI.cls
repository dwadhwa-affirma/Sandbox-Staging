@RestResource(urlMapping = 
'/MortgagePayoffFormAPI/*')
global with sharing class MortgagePayoffFormAPI{
	@HttpGet
	global static boolean ValidateAccount(){
		List<Account_Details__c> MortgagePayoffValidation = new List<Account_Details__c>();

		RestRequest req = RestContext.request;
		string PropertyZip = req.params.get('PropertyZip');
		string LoanNo = req.params.get('LoanNo');
		system.debug('PropertyZip:=' + PropertyZip);
		system.debug('LoanNo:=' + LoanNo);

		if (String.isNotBlank(PropertyZip) && String.isNotBlank(LoanNo)){
			MortgagePayoffValidation = [SELECT ID, Loan_Number__c, Property_Zip_Formatted__c, Property_Zip__c, Mailing_Street__c, Mailing_Extra_Address__c, Mailing_City__c, Mailing_State__c, Mailing_Zipcode__c, Mailing_Country__c
			                            from Account_Details__c
			                            where Property_Zip_Formatted__c = :PropertyZip and Loan_Number__c = :LoanNo];
		}
		system.debug('MortgagePayoffValidation' + MortgagePayoffValidation);

		if (MortgagePayoffValidation.size() > 0){
			return true;
		} else{
			return false;
		}
	}

	@HttpPost
	global static string CreateCase(){		
		String requestBody = RestContext.request.requestBody.toString();
		CreateCaseRequest requestJson = (CreateCaseRequest)System.JSON.deserialize(requestBody,CreateCaseRequest.class);  
		
        
		string PropertyZip, LoanNo, PayoffRequestReason, PayoffRequestReasonOther, RequestorInfo, RequestorCompany, RequestorName, RequestorPhoneNo, MethodofDelivery;
		boolean AuthorizedTitleCompany;
		Date PayoffGoodToDate;
		Id groupnameid;

		PropertyZip = string.valueof(requestJson.PropertyZip);
		LoanNo = string.valueof(requestJson.LoanNo);
		PayoffRequestReason = string.valueof(requestJson.PayoffRequestReason);
		PayoffRequestReasonOther = string.valueof(requestJson.PayoffRequestReasonOther);
		PayoffGoodToDate = Date.valueof(requestJson.PayoffGoodToDate);
		RequestorInfo = string.valueof(requestJson.RequestorInfo);
		RequestorCompany = string.valueof(requestJson.RequestorCompany);
		RequestorName = string.valueof(requestJson.RequestorName);
		RequestorPhoneNo = string.valueof(requestJson.RequestorPhoneNo);
		AuthorizedTitleCompany = requestJson.AuthorizedTitleCompany;
		MethodofDelivery = string.valueof(requestJson.MethodofDelivery);		
		
		List<Account_Details__c> AccountsList = [SELECT ID, Loan_Number__c, Property_Zip_Formatted__c, Property_Zip__c, Name, Mailing_Street__c, Mailing_Extra_Address__c, Mailing_City__c, Mailing_State__c, Mailing_Zipcode__c, Mailing_Country__c
		                                         from Account_Details__c
		                                         where Property_Zip_Formatted__c = :PropertyZip and Loan_Number__c = :LoanNo
		                                         limit 1];
		List<Group> listQueue = [select id, Name, Email
		                         from Group
		                         where Type = 'Queue' and name = 'Real Estate Servicing Queue'];
		if (listQueue.size() > 0){
			groupnameid = listQueue[0].id;
		}
		system.debug('AccountsList==' + AccountsList);
		if (AccountsList.size() > 0){
			List<Person_Account__c> paList = [SELECT id, Name, Account_Number__c, PersonID__c, PersonID__r.Residential_Street__pc, PersonID__r.Residential_Extra_Address__pc, PersonID__r.Residential_City__pc, PersonID__r.Residential_State__pc, PersonID__r.Residential_Zipocde__pc, PersonID__r.Residential_Country__pc
			                                  from Person_Account__c
			                                  where Account_Number__r.Name = :AccountsList[0].Name and TypeTranslate__c like '%Primary'
			                                  Limit 1];

			system.debug('paList==' + paList);
			Case caseObj = new Case();
			caseObj.Primary_Category__c = 'Loan Servicing';
			caseObj.Secondary_Category__c = 'Real Estate Loans';
			caseObj.Tertiary_Category__c = 'Pay Off Request';
			caseObj.Subject = 'Mortgage Loan Pay Off Request form on website';
			caseObj.Account_Number__c = AccountsList[0].Id;
			// caseObj.Street_Address_1__c = AccountsList[0].Mailing_Street__c;
			// caseObj.Street_Address_2__c = AccountsList[0].Mailing_Extra_Address__c;
			// caseObj.City__c = AccountsList[0].Mailing_City__c;
			// caseObj.State__c = AccountsList[0].Mailing_State__c;
			// caseObj.Zip_Code__c = AccountsList[0].Mailing_Zipcode__c;
			// caseObj.Country__c = AccountsList[0].Mailing_Country__c;
			if (paList.size() > 0){
				caseObj.AccountId = paList[0].PersonID__c;
				caseObj.Street_Address_1__c = paList[0].PersonID__r.Residential_Street__pc;
				caseObj.Street_Address_2__c = paList[0].PersonID__r.Residential_Extra_Address__pc;
				caseObj.City__c = paList[0].PersonID__r.Residential_City__pc;
				caseObj.State__c = paList[0].PersonID__r.Residential_State__pc;
				caseObj.Zip_Code__c = paList[0].PersonID__r.Residential_Zipocde__pc;
				caseObj.Country__c = paList[0].PersonID__r.Residential_Country__pc;
			}
			caseObj.MPO_Loan_Number__c = LoanNo;
			caseObj.MPO_ZipCode__c = PropertyZip;
			caseObj.MPO_Request_Reason__c = PayoffRequestReason;
			caseObj.MPO_Request_Other_Reason__c = PayoffRequestReasonOther;
			caseObj.MPO_Good_to_Date__c = PayoffGoodToDate;
			caseObj.MPO_Requestor_Information__c = RequestorInfo;
			caseObj.MPO_Requestor_Company__c = RequestorCompany;
			caseObj.MPO_Requestor_Name__c = RequestorName;
			caseObj.MPO_Requestor_Phone_Number__c = RequestorPhoneNo;
			caseObj.MPO_Authorized_Title_Company__c = AuthorizedTitleCompany;
			caseObj.MPO_Method_of_Delivery__c = MethodofDelivery;
			caseObj.OwnerId = groupnameid;

			insert caseObj;
			return caseObj.Id;
		} else{
			return '';
		}
	}

	global class CreateCaseRequest{
		@AuraEnabled
		global string PropertyZip;
		@AuraEnabled
		global string LoanNo;
		@AuraEnabled
		global string PayoffRequestReason;
		@AuraEnabled
		global string PayoffRequestReasonOther;
		@AuraEnabled
		global string PayoffGoodToDate;
		@AuraEnabled
		global string RequestorInfo;
		@AuraEnabled
		global string RequestorCompany;
		@AuraEnabled
		global string RequestorName;
		@AuraEnabled
		global string RequestorPhoneNo;
		@AuraEnabled
		global Boolean AuthorizedTitleCompany;
		@AuraEnabled
		global string MethodofDelivery;
	}
}
