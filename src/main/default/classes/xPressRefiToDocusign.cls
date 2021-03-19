public class xPressRefiToDocusign{
	public static String EnvelopeId;
	public static String EmailToSend;
	public static Account Member;
	public static String EmailBody = 'Hello {BorrowerNames},' + '\n\n' + 'Congratulations!  Your Xpress Refinance has been approved.  Thank you very much for your patience.' + '\n\n' + 'Please carefully review the Loan Modification Agreement and ensure all signers have signed.  Please be informed if you have an Escrow Account, that is not included in your payment amount on the Loan Modification Agreement.' + '\n\n' + 'Once your documents have been signed by all parties, and received, your file will be assigned to a Closer.  If you have an ACH - Automatic Transfer set up through the Credit Union, you will receive a separate email from the Closer, so we can get that updated.' + '\n\n' + 'Please be sure to complete these documents within 5 business days of receiving the DocuSign email.  If for any reason you will not be able to meet that deadline, please contact us as soon as possible providing the reason for the delay.' + '\n\n' + 'The Xpress Refinance fee in the amount of $1,500.00, will be debited from the account indicated on the initial Request for Modification.  Please make sure funds are available in the designated account prior to completing the DocuSign.  If you are paying the Xpress Refinance fee by check, please let me know and I will provide a Overnight FedEx label for you to send this in to our Oakland Office.' + '\n\n' + 'Please let me know if you have any questions or concerns.';
	public static String EmailSubject = 'Xpress Refinance Transaction';
	public static String accountID;
	public static String userId;
	public static String passWord;
	public static String integratorKey;
	public static String replyTo;
	public static String templateID;
	public static String endPoint;
	public static String authorizationHeader;
	public static String endPointURL;
	public static HttpRequest req = new HttpRequest();
	public static String json;
	public static Http http = new Http();
	public static HTTPResponse res;
	public static String responseBody;
	public static String action;
	public static String endPointURL1;
	public static HttpRequest req1 = new HttpRequest();
	public static String json1;
	public static Http http1 = new Http();
	public static HTTPResponse res1;
	public static String endPointURL2;
	public static HttpRequest req2 = new HttpRequest();
	public static String json2;
	public static Http http2 = new Http();
	public static HTTPResponse res2;
	public static String endPointURL3;
	public static HttpRequest req3 = new HttpRequest();
	public static String json3;
	public static Http http3 = new Http();
	public static HTTPResponse res3;
	public static String Brand;
	public static String TemplateName;
	//-----------------Sending Docusign-----------//
	@future(callout = true)
	public static void docusignAPIcall(Set<ID> ids){
		system.debug('ids ==' + ids);
		//----------------------------Start - DocuSign Templates from Custom setting---------------------------------//
		xPressRefi_Docusign_Emails__c sde = xPressRefi_Docusign_Emails__c.getValues('Email For Testing');
		List<xPressRefi__c> xPressRefiRecordsToUpdate = new List<xPressRefi__c>();
		List<MortgageProductsDocuSignTemplateMapping__c> ListTemplateMapping = new List<MortgageProductsDocuSignTemplateMapping__c>();
		map<string, MortgageProductsDocuSignTemplateMapping__c> ProductBrandMap = new map<string, MortgageProductsDocuSignTemplateMapping__c>();
		map<string, xPressRefi_Docusign_API_User_Details__c> TemplateAPIDetailsMap = new map<string, xPressRefi_Docusign_API_User_Details__c>();
		set<Id> CaseIds = new set<Id>();
		map<Id, string> MapCaseDesc = new map<Id, string>();

		String userName = UserInfo.getUserName();
		User activeUser = [Select Email
		                   From User
		                   where Username = :userName
		                   limit 1];
		String userEmail = activeUser.Email;

		List<xPressRefi_Docusign_API_User_Details__c> DocusignAPIDetailsList = [Select id, Name, AccountId__c, EndPoint__c, IntegratorKey__c, Password__c, ReplyTo__c, TemplateId__c, Username__c
		                                                                        from xPressRefi_Docusign_API_User_Details__c];
		for (xPressRefi_Docusign_API_User_Details__c dt : DocusignAPIDetailsList){
			TemplateAPIDetailsMap.put(dt.Name.trim(), dt);
		}

		if (sde.Emails__c != null){
			EmailToSend = sde.Emails__c;
		}

		ListTemplateMapping = [Select Id, Name, Brand__c, Template_Name__c
		                       from MortgageProductsDocuSignTemplateMapping__c];

		For (MortgageProductsDocuSignTemplateMapping__c mpt : ListTemplateMapping){
			ProductBrandMap.put(mpt.Name, mpt);
		}


		//----------------------------End - DocuSign Templates from Custom setting------------------------------------//

		List<xPressRefi__c> xPressRefiList = [SELECT Borrowers_Names__c, Case__c, Current_Interest_Rate_Calc__c, Current_Interest_Rate__c, Id, Interest_Rate__c, is_CSV_Generated__c, Is_Product_Change__c, LoanId__c, Maturity_Date_Calc__c, Maturity_Date__c, Member_Number__c, New_Interest_Rate_Calc__c, New_Payment_Amount_Calc__c, New_Product_Type__c, Principal_Balance__c, Product_Type__c, Property_Address_2__c, Property_Balance__c, Property_City__c, Property_County__c, Property_State__c, Property_Zip__c, Property__c, P_I_Payment__c, Start_Date_Calc__c, Member__c, Brand__c, Loan_Program_Type__c, Due_Date__c, Is_Mortgage_Ware__c, Is_Mortgage_Cadence__c
		                                      FROM xPressRefi__c
		                                      where id = :ids];


		for (xPressRefi__c xp : xPressRefiList){
			system.debug('xp.Loan_Program_Type__c==' + xp.Loan_Program_Type__c);
			system.debug('ProductBrandMap.containsKey(xp.Loan_Program_Type__c)' + ProductBrandMap.containsKey(xp.Loan_Program_Type__c));
			if (ProductBrandMap.containsKey(xp.Loan_Program_Type__c)){
				MortgageProductsDocuSignTemplateMapping__c TemplateRecord = ProductBrandMap.get(xp.Loan_Program_Type__c);
				Brand = TemplateRecord.Brand__c;
				TemplateName = Brand + ' ' + TemplateRecord.Template_Name__c;
			}


			system.debug('TemplateName==' + TemplateName);
			xPressRefi_Docusign_API_User_Details__c temprecord = TemplateAPIDetailsMap.get(TemplateName.trim());
			system.debug('temprecord==' + temprecord);
			if (temprecord != null){
				templateID = temprecord.TemplateId__c;
				replyTo = temprecord.ReplyTo__c;
				accountID = temprecord.AccountId__c;
				userId = temprecord.Username__c;
				passWord = temprecord.Password__c;
				integratorKey = temprecord.IntegratorKey__c;
				endpoint = temprecord.EndPoint__c;

				if (Brand == 'Spectrum'){
					authorizationHeader = '<DocuSignCredentials><Username>' + userId + '</Username><Password>' + Password + '</Password><IntegratorKey>' + integratorKey + '</IntegratorKey></DocuSignCredentials>';
					json2 = '{"replyEmailAddressOverride":"' + replyTo + '",' + '"replyEmailNameOverride": "Spectrum Team",' + '"bccEmailAddresses": []' + '}';
				} else{
					authorizationHeader = '<DocuSignCredentials><Username>' + userId + '</Username><Password>' + Password + '</Password><IntegratorKey>' + integratorKey + '</IntegratorKey></DocuSignCredentials>';
					json2 = '{"replyEmailAddressOverride": "' + replyTo + '",' + '"replyEmailNameOverride": "Chevron Team",' + '"bccEmailAddresses": []' + '}';
				}

				authorizationHeader = '<DocuSignCredentials><Username>' + userId + '</Username><Password>' + Password + '</Password><IntegratorKey>' + integratorKey + '</IntegratorKey></DocuSignCredentials>';
				endPointURL = 'https://'+endpoint+'/restapi/v2.1/accounts/'+accountID+'/envelopes';
				req.setEndpoint(endPointURL);
				req.setMethod('POST');
				req.setHeader('X-DocuSign-Authentication', authorizationHeader);
				req.setHeader('Content-Length', '162100');
				req.setHeader('Content-Type', 'application/json');
				req.setHeader('Content-Disposition', 'form-data');
				system.debug('XpressRefi Id ==' + xp.Id);
				json = '{"emailBlurb":"' + EmailBody.replace('{BorrowerNames}', xp.Borrowers_Names__c)+'",' + '"emailSubject": "' + EmailSubject + '",' + '"status": "created",' + '"compositeTemplates": [' + '{' + '"serverTemplates": [' + '{' + '"sequence": "1",' + '"templateId":"' + templateID + '"' + '}' + '],' + '"inlineTemplates": [' + '{' + '"sequence": "1",' + '"customFields": {' + '"textCustomFields": [' + '{' + '"configurationType": "salesforce",' + '"name":"xPressRefi__c",' + '"required": "true","show": "true",' + '"value":"' + xp.Id + '"' + '}' + ']' + '}' + '}' + ']' + '}' + ']' + '}';
				
				req.setBody(json);
				if (!Test.isRunningTest()){
					res = http.send(req);
					responseBody = res.getBody();
					system.debug('DocuSign Response' + res.getBody());
				} else{
					responseBody = '{"emailBlurb":"emailBlurb",' + '"emailSubject": "emailSubject",' + '"status": "created",' + '"compositeTemplates": [' + '{' + '"serverTemplates": [' + '{' + '"sequence": "1",' + '"templateId": "templateId"' + '}' + '],' + '"inlineTemplates": [' + '{' + '"sequence": "1",' + '"customFields": {' + '"textCustomFields": [' + '{' + '"configurationType": "salesforce",' + '"name":"xPressRefi__c",' + '"required": "true","show": "true",' + '"value":"a2T19000000opfgEAA"' + '}' + ']' + '}' + '}' + ']' + '}' + ']' + '}';
				}


				//--------------------------------Saving EnvelopeId--------------------------------------------------//

				EnvelopeId = String.valueOf(responseBody).substringAfter('"envelopeId":"');
				EnvelopeId = String.valueOf(EnvelopeId).substringBefore('"');
				system.debug('EnvelopeId: ' + EnvelopeId);

				xPressRefi__c e = new xPressRefi__c();
				e.id = xp.Id;
				e.DocuSignId__c = EnvelopeId;
				xPressRefiRecordsToUpdate.add(e);

				//--------------------------------Saving EnvelopeId-------------------------------------------------//

				endPointURL1 = 'https://'+endpoint+'/restapi/v2.1/accounts/'+accountID+'/envelopes/'+EnvelopeId+'/recipients';
				req1.setEndpoint(endPointURL1);
				req1.setMethod('PUT');
				req1.setHeader('X-DocuSign-Authentication', authorizationHeader);
				req1.setHeader('Content-Length', '162100');
				req1.setHeader('Content-Type', 'application/json');
				req1.setHeader('Content-Disposition', 'form-data');

				if (EmailToSend == 'Production' || EmailToSend == 'production'){
					json1 = '{"signers": [' + '{' + '"email": "' + xp.Member_Email__c + '",' + '"recipientId" : "1",' + '"roleName": "signer 1",' + '"name": "' + xp.Member__r.Name + '",' + '"signingGroupId": "signers",' + '"routingOrder" : "null"' + '}' + ']' + '}';
				}
				//xp.Member__r.Email_raw__c
				if (EmailToSend != 'Production' || EmailToSend != 'production'){
					EmailToSend = userEmail;
					json1 = '{"signers": [' + '{' + '"email": "' + EmailToSend + '",' + '"recipientId" : "1",' + '"roleName": "Signer 1",' + '"name": "' + userName + '",' + '"signingGroupId": "signers",' + '"routingOrder" : "1"' + '},' + '{' + '"email": "' + EmailToSend + '",' + '"recipientId" : "2",' + '"roleName": "Signer 2",' + '"name": "' + 'Dhwani' + '",' + '"signingGroupId": "signers",' + '"routingOrder" : "2", "recipientType" : "signer" ' + '}' + ']' + '}';
				}
				system.debug('json1=='+json1);
				req1.setBody(json1);
				if (!Test.isRunningTest()){
					res1 = http1.send(req1);
					system.debug('DocuSign Response' + res1.getBody());
				}

				//------------------------------------------Setting Reply-To -----------------------------------------//

				endPointURL2 = 'https://'+endpoint+'/restapi/v2.1/accounts/'+accountID+'/envelopes/'+EnvelopeId+'/email_settings';
				req2.setEndpoint(endPointURL2);
				req2.setMethod('POST');
				req2.setHeader('X-DocuSign-Authentication', authorizationHeader);
				req2.setHeader('Content-Length', '162100');
				req2.setHeader('Content-Type', 'application/json');
				req2.setHeader('Content-Disposition', 'form-data');
				//json2='{"replyEmailAddressOverride": "'+replyTo+'",'+'"replyEmailNameOverride": "Chevron Team",'+'"bccEmailAddresses": []'+'}';
				req2.setBody(json2);
				if (!Test.isRunningTest()){
					res2 = http2.send(req2);
					system.debug('DocuSign Response' + res2.getBody());
				}

				//------------------------------------------Sending Envelope -----------------------------------------//

				endPointURL3 = 'https://'+endpoint+'/restapi/v2.1/accounts/'+accountID+'/envelopes/'+EnvelopeId;
				req3.setEndpoint(endPointURL3);
				req3.setMethod('PUT');
				req3.setHeader('X-DocuSign-Authentication', authorizationHeader);
				req3.setHeader('Content-Length', '162100');
				req3.setHeader('Content-Type', 'application/json');
				req3.setHeader('Content-Disposition', 'form-data');
				json3 = '{"status":"sent"' + '}';
				req3.setBody(json3);
				if (!Test.isRunningTest()){
					res3 = http2.send(req3);
					system.debug('DocuSign Response' + res3.getBody());
				}

				CaseIds.add(xp.Case__c);
				string Description = '\n\n' + 'Is Mortgage Ware?: Yes' + '\n' + 'Is Mortgage Cadence?: ' +  (xp.Is_Mortgage_Cadence__c == true ? 'Yes' : 'No');
				MapCaseDesc.put(xp.Case__c,Description);
			}

		}

		List<Case> CaseListToUpdate = [SELECT Id, Docusign_Envelope_Status__c, Description
		                               from Case
		                               where Id in :CaseIds];
		for (Case c : CaseListToUpdate){
			c.Docusign_Envelope_Status__c = 'Sent';
			 c.Description = c.Description + MapCaseDesc.get(c.id) + '\nDocusign Envelope Status: Sent';
			// 	+ '\n\nIs Mortgage Ware?: ' +  (xPressrecordList[0].Is_Mortgage_Ware__c == true ? 'Yes' : 'No') 
			// 	+ '\n' + 'Is Mortgage Cadence?: ' +  (xPressrecordList[0].Is_Mortgage_Cadence__c == true ? 'Yes' : 'No');
		}
		Update CaseListToUpdate;

		if (xPressRefiRecordsToUpdate.size() > 0){
			update xPressRefiRecordsToUpdate;
		}
	}
}