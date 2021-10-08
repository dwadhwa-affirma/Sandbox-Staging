public class WiresTransToDocuSign{
	public static String EnvelopeId;
	public static String EmailToSend;
	public static Account Member;
	public static String EmailBody = '';
	public static String EmailSubject = 'Wire Transfer Request';
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
	public static String returnUrl = 'https://www.google.com/';
	public static String authenticationMethod = 'email';
	public static String email = 'dbhavsar@affirma.com';
	public static String clientUserId;
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
    
	@future(callout = true)
	public static void docusignAPIcall(Set<ID> ids){

		System.debug('Ids' + ids);
		//----------------------------Start - DocuSign Templates from Custom setting---------------------------------//
		Wires_Docusign_Emails__c wde = Wires_Docusign_Emails__c.getValues('Email For Testing');
		Wires_DocuSign_User_Details__c DTSpectrum = Wires_DocuSign_User_Details__c.getValues('Spectrum');
		Wires_DocuSign_User_Details__c DTSpectrumIDV = Wires_DocuSign_User_Details__c.getValues('Spectrum-IDV');
		Wires_DocuSign_User_Details__c DTChevron = Wires_DocuSign_User_Details__c.getValues('Chevron');
		Wires_DocuSign_User_Details__c DTChevronIDV = Wires_DocuSign_User_Details__c.getValues('Chevron-IDV');

		List<WIRES_Transaction__c> WireTransToUpdate = new List<WIRES_Transaction__c>();

		Wires_Progress_Email_Test__c testEmail = Wires_Progress_Email_Test__c.getValues('Test');
		String userEmail = testEmail.Email__c;

		String userName = UserInfo.getUserName();
		//User activeUser = [Select Email From User where Username = : userName limit 1];
		//String userEmail = activeUser.Email;

		if (wde.Emails__c != null){
			EmailToSend = wde.Emails__c;
		}

		System.debug('EmailToSend' + EmailToSend);

		//----------------------------End - DocuSign Templates from Custom setting------------------------------------//

		List<WIRES_Transaction__c> WiresList = new List<WIRES_Transaction__c>();
		List<WIRES_Transaction__c> WiresTrans = [SELECT AccountStableReview__c, Member__c, Approval_Status__c, Approved_by_1st_Approver__c, Available_Balance_Review__c, Description__c, EndDate__c, Chevron_Account_Number__c, CreatedById, CreatedDate, FlagAccountOpenfor45Days__c, Fees__c, DocuSignId__c, DocuSign_Status1__c, EmailStableReview__c, FlagHomePhoneStablefor30Days__c, FlagEmailStablefor30Days__c, FlagMobilePhoneStablefor30Days__c, FlagWorkPhoneStablefor30Days__c, Frequency__c, FromAccount__c, Home_Phone_Stable_Review__c, Id, Identity_Verification_Used__c, ID_Verification_Review__c, IsAccountOpenfor45Days__c, IsDeleted, IsEmailStable__c, TotalFromAccount__c, IsHomePhoneStable__c, IsMobilePhoneStable__c, IsWorkPhoneStable__c, Is_Recurrence_Day__c, Member_Address__c, Member_City_State_Zip__c, Member_Email__c, Member_Home_Phone__c, Member_Name__c, TransactionStatus__c, Mobile_Phone_Stable_Review__c, RecurrenceEndDate__c, Name, Occurences__c, OwnerId, ParentTransaction__c, ToAccoutId__c, RecurrenceRange__c, Previous_Wires_Review__c, RecurrenceDay__c, Recurrence_Pattern__c, Review_Reason__c, Second_Approval_Review_Reason__c, SendOn__c, Share_ID__c, Transaction_Status__c, Source__c, StartDate__c, Status__c, ToAccountName__c, TransferType__c, WireAmount__c, WireMoneyDeliveryByDate__c, WIRES_Wires_Transaction__c, Work_Phone_Stable_Review__c, Brand__c, Docusign_IDV_Failure__c
		                                         FROM WIRES_Transaction__c
		                                         where id = :ids];

		for (WIRES_Transaction__c wt : WiresTrans){

			EmailSubject = 'Wire Transfer Request' + ' - ' + wt.Name.replace('WIR', '').replaceFirst('^0+', '');

			if (wt.Brand__c == 'Spectrum'){

				if (wt.WireAmount__c > 50000 && wt.Docusign_IDV_Failure__c == false){
					templateID = DTSpectrumIDV.TemplateId__c;
					replyTo = DTSpectrumIDV.ReplyTo__c;
					accountID = DTSpectrumIDV.AccountId__c;
					userId = DTSpectrumIDV.Username__c;
					passWord = DTSpectrumIDV.Password__c;
					integratorKey = DTSpectrumIDV.IntegratorKey__c;
					endpoint = DTSpectrumIDV.EndPoint__c;
				} else{
					templateID = DTSpectrum.TemplateId__c;
					replyTo = DTSpectrum.ReplyTo__c;
					accountID = DTSpectrum.AccountId__c;
					userId = DTSpectrum.Username__c;
					passWord = DTSpectrum.Password__c;
					integratorKey = DTSpectrum.IntegratorKey__c;
					endpoint = DTSpectrum.EndPoint__c;
				}

				authorizationHeader = '<DocuSignCredentials><Username>' + userId + '</Username><Password>' + Password + '</Password><IntegratorKey>' + integratorKey + '</IntegratorKey></DocuSignCredentials>';
				json2 = '{"replyEmailAddressOverride":"' + replyTo + '",' + '"replyEmailNameOverride": "Spectrum Team",' + '"bccEmailAddresses": []' + '}';
			} else{

				if (wt.WireAmount__c > 50000 && wt.Docusign_IDV_Failure__c == false){
					templateID = DTChevronIDV.TemplateId__c;
					replyTo = DTChevronIDV.ReplyTo__c;
					accountID = DTChevronIDV.AccountId__c;
					userId = DTChevronIDV.Username__c;
					passWord = DTChevronIDV.Password__c;
					integratorKey = DTChevronIDV.IntegratorKey__c;
					endpoint = DTChevronIDV.EndPoint__c;
				} else{
					templateID = DTChevron.TemplateId__c;
					replyTo = DTChevron.ReplyTo__c;
					accountID = DTChevron.AccountId__c;
					userId = DTChevron.Username__c;
					passWord = DTChevron.Password__c;
					integratorKey = DTChevron.IntegratorKey__c;
					endpoint = DTChevron.EndPoint__c;
				}

				authorizationHeader = '<DocuSignCredentials><Username>' + userId + '</Username><Password>' + Password + '</Password><IntegratorKey>' + integratorKey + '</IntegratorKey></DocuSignCredentials>';
				json2 = '{"replyEmailAddressOverride": "' + replyTo + '",' + '"replyEmailNameOverride": "Chevron Team",' + '"bccEmailAddresses": []' + '}';
			}

			//authorizationHeader = '<DocuSignCredentials><Username>'+userId+'</Username><Password>'+Password+'</Password><IntegratorKey>'+integratorKey+'</IntegratorKey></DocuSignCredentials>';

			endPointURL = 'https://'+endpoint+'/restapi/v2.1/accounts/'+accountID+'/envelopes';
			req.setEndpoint(endPointURL);
			req.setMethod('POST');
			req.setHeader('X-DocuSign-Authentication', authorizationHeader);
			req.setHeader('Content-Length', '162100');
			req.setHeader('Content-Type', 'application/json');
			req.setHeader('Content-Disposition', 'form-data');
			json = '{"emailBlurb":"' + EmailBody + '",' + '"emailSubject": "' + EmailSubject + '",' + '"status": "created",' + '"compositeTemplates": [' + '{' + '"serverTemplates": [' + '{' + '"sequence": "1",' + '"templateId":"' + templateID + '"' + '}' + '],' + '"inlineTemplates": [' + '{' + '"sequence": "1", "signers" : [{  "clientUserId": "1000" }],' + '"customFields": {' + '"textCustomFields": [' + '{' + '"configurationType": "salesforce",' + '"name":"WIRES_Transaction__c",' + '"required": "true","show": "true",' + '"value":"' + wt.Id + '"' + '}' + ']' + '}' + '}' + ']' + '}' + ']' + '}';
			req.setBody(json);
			if (!Test.isRunningTest()){
				res = http.send(req);
				responseBody = res.getBody();
				system.debug('DocuSign Response' + res.getBody());
			} else{
				responseBody = '{"emailBlurb":"emailBlurb",' + '"emailSubject": "emailSubject",' + '"status": "created",' + '"compositeTemplates": [' + '{' + '"serverTemplates": [' + '{' + '"sequence": "1",' + '"templateId": "templateId"' + '}' + '],' + '"inlineTemplates": [' + '{' + '"sequence": "1",' + '"customFields": {' + '"textCustomFields": [' + '{' + '"configurationType": "salesforce",' + '"name":"WIRES_Transaction__c",' + '"required": "true","show": "true",' + '"value":"a2T19000000opfgEAA"' + '}' + ']' + '}' + '}' + ']' + '}' + ']' + '}';
			}


			//--------------------------------Saving EnvelopeId--------------------------------------------------//

			EnvelopeId = String.valueOf(responseBody).substringAfter('"envelopeId":"');
			EnvelopeId = String.valueOf(EnvelopeId).substringBefore('"');
			system.debug('EnvelopeId: ' + EnvelopeId);

			WIRES_Transaction__c w = new WIRES_Transaction__c();
			w.id = wt.Id;
			w.DocuSignId__c = EnvelopeId;
			w.Approval_Status__c = WiresConstant.ApprovalStatus_PendingForMemberReview;

			WireTransToUpdate.add(w);

			//--------------------------------Saving EnvelopeId-------------------------------------------------//

			endPointURL1 = 'https://'+endpoint+'/restapi/v2.1/accounts/'+accountID+'/envelopes/'+EnvelopeId+'/recipients';
			req1.setEndpoint(endPointURL1);
			req1.setMethod('PUT');
			req1.setHeader('X-DocuSign-Authentication', authorizationHeader);
			req1.setHeader('Content-Length', '162100');
			req1.setHeader('Content-Type', 'application/json');
			req1.setHeader('Content-Disposition', 'form-data');

			Member = [select id, name, PersonEmail
			          from account
			          where id = :wt.Member__c
			          Limit 1];
			if (EmailToSend == 'Production' || EmailToSend == 'production'){
				json1 = '{"signers": [' + '{' + '"email": "' + Member.PersonEmail + '",' + '"recipientId" : "1",' + '"roleName": "client",' + '"name": "' + Member.Name + '",' + '"signingGroupId": "signers",' + '"routingOrder" : "null"' + '}' + ']' + '}';
			}

			if (EmailToSend != 'Production' || EmailToSend != 'production'){
				EmailToSend = userEmail;
				json1 = '{"signers": [' + '{' + '"email": "' + EmailToSend + '",' + '"recipientId" : "1",' + '"roleName": "Signer 1",' + '"name": "' + Member.Name + '",' + '"signingGroupId": "signers",' + '"routingOrder" : "null"' + '}' + ']' + '}';
			}

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

			if (wt.Docusign_IDV_Failure__c){
				wt.Docusign_Re_sent__c = true;
			}
		}


		if (WireTransToUpdate.size() > 0){
			update WireTransToUpdate;
		}
	}
    
    //This method is mimic of "docusignAPIcall" of this class
    //This method has been called from batch class and unfortunately batch class limit for future call out is Max 2
    //We need to process more than 2 transactions from batch thus we mimic "docusignAPIcall" without future call out
	public static void docusignAPIcallWithoutFuture(Set<ID> ids){

		System.debug('Ids' + ids);
		//----------------------------Start - DocuSign Templates from Custom setting---------------------------------//
		Wires_Docusign_Emails__c wde = Wires_Docusign_Emails__c.getValues('Email For Testing');
		Wires_DocuSign_User_Details__c DTSpectrum = Wires_DocuSign_User_Details__c.getValues('Spectrum');
		Wires_DocuSign_User_Details__c DTSpectrumIDV = Wires_DocuSign_User_Details__c.getValues('Spectrum-IDV');
		Wires_DocuSign_User_Details__c DTChevron = Wires_DocuSign_User_Details__c.getValues('Chevron');
		Wires_DocuSign_User_Details__c DTChevronIDV = Wires_DocuSign_User_Details__c.getValues('Chevron-IDV');

		List<WIRES_Transaction__c> WireTransToUpdate = new List<WIRES_Transaction__c>();

		Wires_Progress_Email_Test__c testEmail = Wires_Progress_Email_Test__c.getValues('Test');
		String userEmail = testEmail.Email__c;

		String userName = UserInfo.getUserName();
		//User activeUser = [Select Email From User where Username = : userName limit 1];
		//String userEmail = activeUser.Email;

		if (wde.Emails__c != null){
			EmailToSend = wde.Emails__c;
		}

		System.debug('EmailToSend' + EmailToSend);

		//----------------------------End - DocuSign Templates from Custom setting------------------------------------//

		List<WIRES_Transaction__c> WiresList = new List<WIRES_Transaction__c>();
		List<WIRES_Transaction__c> WiresTrans = [SELECT AccountStableReview__c, Member__c, Approval_Status__c, Approved_by_1st_Approver__c, Available_Balance_Review__c, Description__c, EndDate__c, Chevron_Account_Number__c, CreatedById, CreatedDate, FlagAccountOpenfor45Days__c, Fees__c, DocuSignId__c, DocuSign_Status1__c, EmailStableReview__c, FlagHomePhoneStablefor30Days__c, FlagEmailStablefor30Days__c, FlagMobilePhoneStablefor30Days__c, FlagWorkPhoneStablefor30Days__c, Frequency__c, FromAccount__c, Home_Phone_Stable_Review__c, Id, Identity_Verification_Used__c, ID_Verification_Review__c, IsAccountOpenfor45Days__c, IsDeleted, IsEmailStable__c, TotalFromAccount__c, IsHomePhoneStable__c, IsMobilePhoneStable__c, IsWorkPhoneStable__c, Is_Recurrence_Day__c, Member_Address__c, Member_City_State_Zip__c, Member_Email__c, Member_Home_Phone__c, Member_Name__c, TransactionStatus__c, Mobile_Phone_Stable_Review__c, RecurrenceEndDate__c, Name, Occurences__c, OwnerId, ParentTransaction__c, ToAccoutId__c, RecurrenceRange__c, Previous_Wires_Review__c, RecurrenceDay__c, Recurrence_Pattern__c, Review_Reason__c, Second_Approval_Review_Reason__c, SendOn__c, Share_ID__c, Transaction_Status__c, Source__c, StartDate__c, Status__c, ToAccountName__c, TransferType__c, WireAmount__c, WireMoneyDeliveryByDate__c, WIRES_Wires_Transaction__c, Work_Phone_Stable_Review__c, Brand__c, Docusign_IDV_Failure__c
		                                         FROM WIRES_Transaction__c
		                                         where id = :ids];

		for (WIRES_Transaction__c wt : WiresTrans){

			EmailSubject = 'Wire Transfer Request'+' - ' + wt.Name.replace('WIR', '').replaceFirst('^0+', '');

			if (wt.Brand__c == 'Spectrum'){

				if (wt.WireAmount__c > 50000 && wt.Docusign_IDV_Failure__c == false){
					templateID = DTSpectrumIDV.TemplateId__c;
					replyTo = DTSpectrumIDV.ReplyTo__c;
					accountID = DTSpectrumIDV.AccountId__c;
					userId = DTSpectrumIDV.Username__c;
					passWord = DTSpectrumIDV.Password__c;
					integratorKey = DTSpectrumIDV.IntegratorKey__c;
					endpoint = DTSpectrumIDV.EndPoint__c;
				} else{
					templateID = DTSpectrum.TemplateId__c;
					replyTo = DTSpectrum.ReplyTo__c;
					accountID = DTSpectrum.AccountId__c;
					userId = DTSpectrum.Username__c;
					passWord = DTSpectrum.Password__c;
					integratorKey = DTSpectrum.IntegratorKey__c;
					endpoint = DTSpectrum.EndPoint__c;
				}

				authorizationHeader = '<DocuSignCredentials><Username>' + userId + '</Username><Password>' + Password + '</Password><IntegratorKey>' + integratorKey + '</IntegratorKey></DocuSignCredentials>';
				json2 = '{"replyEmailAddressOverride":"' + replyTo + '",' + '"replyEmailNameOverride": "Spectrum Team",' + '"bccEmailAddresses": []' + '}';
			} else{

				if (wt.WireAmount__c > 50000 && wt.Docusign_IDV_Failure__c == false){
					templateID = DTChevronIDV.TemplateId__c;
					replyTo = DTChevronIDV.ReplyTo__c;
					accountID = DTChevronIDV.AccountId__c;
					userId = DTChevronIDV.Username__c;
					passWord = DTChevronIDV.Password__c;
					integratorKey = DTChevronIDV.IntegratorKey__c;
					endpoint = DTChevronIDV.EndPoint__c;
				} else{
					templateID = DTChevron.TemplateId__c;
					replyTo = DTChevron.ReplyTo__c;
					accountID = DTChevron.AccountId__c;
					userId = DTChevron.Username__c;
					passWord = DTChevron.Password__c;
					integratorKey = DTChevron.IntegratorKey__c;
					endpoint = DTChevron.EndPoint__c;
				}

				authorizationHeader = '<DocuSignCredentials><Username>' + userId + '</Username><Password>' + Password + '</Password><IntegratorKey>' + integratorKey + '</IntegratorKey></DocuSignCredentials>';
				json2 = '{"replyEmailAddressOverride": "' + replyTo + '",' + '"replyEmailNameOverride": "Chevron Team",' + '"bccEmailAddresses": []' + '}';
			}

			//authorizationHeader = '<DocuSignCredentials><Username>'+userId+'</Username><Password>'+Password+'</Password><IntegratorKey>'+integratorKey+'</IntegratorKey></DocuSignCredentials>';

			endPointURL = 'https://'+endpoint+'/restapi/v2.1/accounts/'+accountID+'/envelopes';
			req.setEndpoint(endPointURL);
			req.setMethod('POST');
			req.setHeader('X-DocuSign-Authentication', authorizationHeader);
			req.setHeader('Content-Length', '162100');
			req.setHeader('Content-Type', 'application/json');
			req.setHeader('Content-Disposition', 'form-data');
			json = '{"emailBlurb":"' + EmailBody + '",' + '"emailSubject": "' + EmailSubject + '",' + '"status": "created",' + '"compositeTemplates": [' + '{' + '"serverTemplates": [' + '{' + '"sequence": "1",' + '"templateId":"' + templateID + '"' + '}' + '],' + '"inlineTemplates": [' + '{' + '"sequence": "1", "signers" : [{  "clientUserId": "1000" }],' + '"customFields": {' + '"textCustomFields": [' + '{' + '"configurationType": "salesforce",' + '"name":"WIRES_Transaction__c",' + '"required": "true","show": "true",' + '"value":"' + wt.Id + '"' + '}' + ']' + '}' + '}' + ']' + '}' + ']' + '}';
			req.setBody(json);
			if (!Test.isRunningTest()){
				res = http.send(req);
				responseBody = res.getBody();
				system.debug('DocuSign Response' + res.getBody());
			} else{
				responseBody = '{"emailBlurb":"emailBlurb",' + '"emailSubject": "emailSubject",' + '"status": "created",' + '"compositeTemplates": [' + '{' + '"serverTemplates": [' + '{' + '"sequence": "1",' + '"templateId": "templateId"' + '}' + '],' + '"inlineTemplates": [' + '{' + '"sequence": "1",' + '"customFields": {' + '"textCustomFields": [' + '{' + '"configurationType": "salesforce",' + '"name":"WIRES_Transaction__c",' + '"required": "true","show": "true",' + '"value":"a2T19000000opfgEAA"' + '}' + ']' + '}' + '}' + ']' + '}' + ']' + '}';
			}


			//--------------------------------Saving EnvelopeId--------------------------------------------------//

			EnvelopeId = String.valueOf(responseBody).substringAfter('"envelopeId":"');
			EnvelopeId = String.valueOf(EnvelopeId).substringBefore('"');
			system.debug('EnvelopeId: ' + EnvelopeId);

			WIRES_Transaction__c w = new WIRES_Transaction__c();
			w.id = wt.Id;
			w.DocuSignId__c = EnvelopeId;
			w.Approval_Status__c = WiresConstant.ApprovalStatus_PendingForMemberReview;

			WireTransToUpdate.add(w);

			//--------------------------------Saving EnvelopeId-------------------------------------------------//

			endPointURL1 = 'https://'+endpoint+'/restapi/v2.1/accounts/'+accountID+'/envelopes/'+EnvelopeId+'/recipients';
			req1.setEndpoint(endPointURL1);
			req1.setMethod('PUT');
			req1.setHeader('X-DocuSign-Authentication', authorizationHeader);
			req1.setHeader('Content-Length', '162100');
			req1.setHeader('Content-Type', 'application/json');
			req1.setHeader('Content-Disposition', 'form-data');

			Member = [select id, name, PersonEmail
			          from account
			          where id = :wt.Member__c
			          Limit 1];
			if (EmailToSend == 'Production' || EmailToSend == 'production'){
				json1 = '{"signers": [' + '{' + '"email": "' + Member.PersonEmail + '",' + '"recipientId" : "1",' + '"roleName": "client",' + '"name": "' + Member.Name + '",' + '"signingGroupId": "signers",' + '"routingOrder" : "null"' + '}' + ']' + '}';
			}

			if (EmailToSend != 'Production' || EmailToSend != 'production'){
				EmailToSend = userEmail;
				json1 = '{"signers": [' + '{' + '"email": "' + EmailToSend + '",' + '"recipientId" : "1",' + '"roleName": "Signer 1",' + '"name": "' + Member.Name + '",' + '"signingGroupId": "signers",' + '"routingOrder" : "null"' + '}' + ']' + '}';
			}

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

			if (wt.Docusign_IDV_Failure__c){
				wt.Docusign_Re_sent__c = true;
			}
		}


		if (WireTransToUpdate.size() > 0){
			update WireTransToUpdate;
		}
	}

	@future(callout = true)
	public static void createRecipientViewdocusignAPIcall(Set<ID> ids, string envId){

		System.debug('Ids' + ids);
		//----------------------------Start - DocuSign Templates from Custom setting---------------------------------//
		Wires_Docusign_Emails__c wde = Wires_Docusign_Emails__c.getValues('Email For Testing');

		Wires_DocuSign_User_Details__c DTSpectrum = Wires_DocuSign_User_Details__c.getValues('Spectrum');
		Wires_DocuSign_User_Details__c DTSpectrumIDV = Wires_DocuSign_User_Details__c.getValues('Spectrum-IDV');
		Wires_DocuSign_User_Details__c DTChevron = Wires_DocuSign_User_Details__c.getValues('Chevron');
		Wires_DocuSign_User_Details__c DTChevronIDV = Wires_DocuSign_User_Details__c.getValues('Chevron-IDV');

		List<WIRES_Transaction__c> WireTransToUpdate = new List<WIRES_Transaction__c>();

		Wires_Progress_Email_Test__c testEmail = Wires_Progress_Email_Test__c.getValues('Test');
		String userEmail = testEmail.Email__c;

		String userName = UserInfo.getUserName();
		//User activeUser = [Select Email From User where Username = : userName limit 1];
		//String userEmail = activeUser.Email;

		if (wde.Emails__c != null){
			EmailToSend = wde.Emails__c;
		}

		System.debug('EmailToSend' + EmailToSend);

		//----------------------------End - DocuSign Templates from Custom setting------------------------------------//

		List<WIRES_Transaction__c> WiresList = new List<WIRES_Transaction__c>();
		List<WIRES_Transaction__c> WiresTrans = [SELECT AccountStableReview__c, Approval_Status__c, Approved_by_1st_Approver__c, Available_Balance_Review__c, Description__c, EndDate__c, Chevron_Account_Number__c, CreatedById, CreatedDate, FlagAccountOpenfor45Days__c, Fees__c, DocuSignId__c, DocuSign_Status1__c, EmailStableReview__c, FlagHomePhoneStablefor30Days__c, FlagEmailStablefor30Days__c, FlagMobilePhoneStablefor30Days__c, FlagWorkPhoneStablefor30Days__c, Frequency__c, FromAccount__c, Home_Phone_Stable_Review__c, Id, Identity_Verification_Used__c, ID_Verification_Review__c, IsAccountOpenfor45Days__c, IsDeleted, IsEmailStable__c, TotalFromAccount__c, IsHomePhoneStable__c, IsMobilePhoneStable__c, IsWorkPhoneStable__c, Is_Recurrence_Day__c, Member_Address__c, Member_City_State_Zip__c, Member_Email__c, Member_Home_Phone__c, Member_Name__c, TransactionStatus__c, Mobile_Phone_Stable_Review__c, RecurrenceEndDate__c, Name, Occurences__c, OwnerId, ParentTransaction__c, ToAccoutId__c, RecurrenceRange__c, Previous_Wires_Review__c, RecurrenceDay__c, Recurrence_Pattern__c, Second_Approval_Review_Reason__c, SendOn__c, Share_ID__c, Transaction_Status__c, Review_Reason__c, Source__c, StartDate__c, Status__c, ToAccountName__c, TransferType__c, WireAmount__c, WireMoneyDeliveryByDate__c, WIRES_Wires_Transaction__c, Work_Phone_Stable_Review__c, Brand__c
		                                         FROM WIRES_Transaction__c
		                                         where id = :ids];

		List<WIRES_Transaction__c> wiresToUpdate = new List<WIRES_Transaction__c>();
		for (WIRES_Transaction__c wt : WiresTrans){

			if (wt.Brand__c == 'Spectrum'){

				if (wt.WireAmount__c > 50000 && wt.Docusign_IDV_Failure__c == false){
					templateID = DTSpectrumIDV.TemplateId__c;
					replyTo = DTSpectrumIDV.ReplyTo__c;
					accountID = DTSpectrumIDV.AccountId__c;
					userId = DTSpectrumIDV.Username__c;
					passWord = DTSpectrumIDV.Password__c;
					integratorKey = DTSpectrumIDV.IntegratorKey__c;
					endpoint = DTSpectrumIDV.EndPoint__c;
				} else{
					templateID = DTSpectrum.TemplateId__c;
					replyTo = DTSpectrum.ReplyTo__c;
					accountID = DTSpectrum.AccountId__c;
					userId = DTSpectrum.Username__c;
					passWord = DTSpectrum.Password__c;
					integratorKey = DTSpectrum.IntegratorKey__c;
					endpoint = DTSpectrum.EndPoint__c;
				}

				authorizationHeader = '<DocuSignCredentials><Username>' + userId + '</Username><Password>' + Password + '</Password><IntegratorKey>' + integratorKey + '</IntegratorKey></DocuSignCredentials>';

			} else{
				if (wt.WireAmount__c > 50000 && wt.Docusign_IDV_Failure__c == false){
					templateID = DTChevronIDV.TemplateId__c;
					replyTo = DTChevronIDV.ReplyTo__c;
					accountID = DTChevronIDV.AccountId__c;
					userId = DTChevronIDV.Username__c;
					passWord = DTChevronIDV.Password__c;
					integratorKey = DTChevronIDV.IntegratorKey__c;
					endpoint = DTChevronIDV.EndPoint__c;
				} else{
					templateID = DTChevron.TemplateId__c;
					replyTo = DTChevron.ReplyTo__c;
					accountID = DTChevron.AccountId__c;
					userId = DTChevron.Username__c;
					passWord = DTChevron.Password__c;
					integratorKey = DTChevron.IntegratorKey__c;
					endpoint = DTChevron.EndPoint__c;
				}

				authorizationHeader = '<DocuSignCredentials><Username>' + userId + '</Username><Password>' + Password + '</Password><IntegratorKey>' + integratorKey + '</IntegratorKey></DocuSignCredentials>';

			}

			//authorizationHeader = '<DocuSignCredentials><Username>'+userId+'</Username><Password>'+Password+'</Password><IntegratorKey>'+integratorKey+'</IntegratorKey></DocuSignCredentials>';

			endPointURL = 'https://'+endpoint+'/restapi/v2.1/accounts/'+accountID+'/envelopes/'+ envId + '/views/recipient';
			system.debug('endPointURL' + endPointURL);
			req.setEndpoint(endPointURL);
			req.setMethod('POST');
			req.setHeader('X-DocuSign-Authentication', authorizationHeader);
			req.setHeader('Content-Length', '162100');
			req.setHeader('Content-Type', 'application/json');
			req.setHeader('Content-Disposition', 'form-data');
			json = '{"returnUrl":"' + returnUrl + '",' + '"authenticationMethod": "' + authenticationMethod + '",' + '"email": "' + userEmail + '",' + '"userName": "' + userName + '"}';
			system.debug('json' + json);
			req.setBody(json);
			if (!Test.isRunningTest()){
				res = http.send(req);
				responseBody = res.getBody();
				system.debug('DocuSign Response' + res.getBody());

				//RecipientView view=JSON.deserialize(res.getBody(),RecipientView);
				wt.DocuSignURL__c = res.getBody();
				wiresToUpdate.add(wt);
			} else{
				responseBody = '{"url": "sample string 1"}';
				system.debug('responseBody' + responseBody);
			}

		}

		if (wiresToUpdate.size() > 0){
			update wiresToUpdate;
		}
	}

	@future(callout = true)
	public static void ResendFailedIDVDocsusignAPIcall(Set<ID> ids){

		System.debug('Ids' + ids);
		//----------------------------Start - DocuSign Templates from Custom setting---------------------------------//
		Wires_Docusign_Emails__c wde = Wires_Docusign_Emails__c.getValues('Email For Testing');
		Wires_DocuSign_User_Details__c DTSpectrum = Wires_DocuSign_User_Details__c.getValues('Spectrum');
		Wires_DocuSign_User_Details__c DTChevron = Wires_DocuSign_User_Details__c.getValues('Chevron');


		List<WIRES_Transaction__c> WireTransToUpdate = new List<WIRES_Transaction__c>();

		Wires_Progress_Email_Test__c testEmail = Wires_Progress_Email_Test__c.getValues('Test');
		String userEmail = testEmail.Email__c;

		String userName = UserInfo.getUserName();


		if (wde.Emails__c != null){
			EmailToSend = wde.Emails__c;
		}

		System.debug('EmailToSend' + EmailToSend);

		//----------------------------End - DocuSign Templates from Custom setting------------------------------------//

		List<WIRES_Transaction__c> WiresList = new List<WIRES_Transaction__c>();
		List<WIRES_Transaction__c> WiresTrans = [SELECT AccountStableReview__c, Member__c, Approval_Status__c, Approved_by_1st_Approver__c, Available_Balance_Review__c, Description__c, EndDate__c, Chevron_Account_Number__c, CreatedById, CreatedDate, FlagAccountOpenfor45Days__c, Fees__c, DocuSignId__c, DocuSign_Status1__c, EmailStableReview__c, FlagHomePhoneStablefor30Days__c, FlagEmailStablefor30Days__c, FlagMobilePhoneStablefor30Days__c, FlagWorkPhoneStablefor30Days__c, Frequency__c, FromAccount__c, Home_Phone_Stable_Review__c, Id, Identity_Verification_Used__c, ID_Verification_Review__c, IsAccountOpenfor45Days__c, IsDeleted, IsEmailStable__c, TotalFromAccount__c, IsHomePhoneStable__c, IsMobilePhoneStable__c, IsWorkPhoneStable__c, Is_Recurrence_Day__c, Member_Address__c, Member_City_State_Zip__c, Member_Email__c, Member_Home_Phone__c, Member_Name__c, TransactionStatus__c, Mobile_Phone_Stable_Review__c, RecurrenceEndDate__c, Name, Occurences__c, OwnerId, ParentTransaction__c, ToAccoutId__c, RecurrenceRange__c, Previous_Wires_Review__c, RecurrenceDay__c, Recurrence_Pattern__c, Review_Reason__c, Second_Approval_Review_Reason__c, SendOn__c, Share_ID__c, Transaction_Status__c, Source__c, StartDate__c, Status__c, ToAccountName__c, TransferType__c, WireAmount__c, WireMoneyDeliveryByDate__c, WIRES_Wires_Transaction__c, Work_Phone_Stable_Review__c, Brand__c, Docusign_IDV_Failure__c
		                                         FROM WIRES_Transaction__c
		                                         where id = :ids];

		for (WIRES_Transaction__c wt : WiresTrans){

			EmailSubject = EmailSubject + ' - ' + wt.Name.replace('WIR', '').replaceFirst('^0+', '');

			if (wt.Brand__c == 'Spectrum'){

				templateID = DTSpectrum.TemplateId__c;
				replyTo = DTSpectrum.ReplyTo__c;
				accountID = DTSpectrum.AccountId__c;
				userId = DTSpectrum.Username__c;
				passWord = DTSpectrum.Password__c;
				integratorKey = DTSpectrum.IntegratorKey__c;
				endpoint = DTSpectrum.EndPoint__c;
				authorizationHeader = '<DocuSignCredentials><Username>' + userId + '</Username><Password>' + Password + '</Password><IntegratorKey>' + integratorKey + '</IntegratorKey></DocuSignCredentials>';

			} else{

				templateID = DTChevron.TemplateId__c;
				replyTo = DTChevron.ReplyTo__c;
				accountID = DTChevron.AccountId__c;
				userId = DTChevron.Username__c;
				passWord = DTChevron.Password__c;
				integratorKey = DTChevron.IntegratorKey__c;
				endpoint = DTChevron.EndPoint__c;

				authorizationHeader = '<DocuSignCredentials><Username>' + userId + '</Username><Password>' + Password + '</Password><IntegratorKey>' + integratorKey + '</IntegratorKey></DocuSignCredentials>';

			}


			Member = [select id, name, PersonEmail
			          from account
			          where id = :wt.Member__c
			          Limit 1];
			if (EmailToSend == 'Production' || EmailToSend == 'production'){
				json1 = '{"signers": [' + '{' + '"email": "' + Member.PersonEmail + '",' + '"recipientId" : "1",' + '"roleName": "client",' + '"name": "' + Member.Name + '",' + '"signingGroupId": "signers",' + '"routingOrder" : "null"' + '}' + ']' + '}';
			}

			if (EmailToSend != 'Production' || EmailToSend != 'production'){
				EmailToSend = userEmail;
				json1 = '{"signers": [' + '{' + '"email": "' + EmailToSend + '",' + '"recipientId" : "1",' + '"roleName": "Signer 1",' + '"name": "' + Member.Name + '",' + '"signingGroupId": "signers",' + '"routingOrder" : "null"' + '}' + ']' + '}';
			}


			//------------------------------------------Sending Envelope -----------------------------------------//
            string EnvelopeId = wt.DocuSignId__c;
			endPointURL3 = 'https://'+endpoint+'/restapi/v2.1/accounts/' + accountID + '/envelopes/' + EnvelopeId + '/recipients?resend_envelope=true';//'https://'+endpoint+'/restapi/v2.1/accounts/'+accountID + '/identity_verification';//'https://'+endpoint+'/restapi/v2.1/accounts/'+accountID+'/envelopes/'+EnvelopeId + '?resend_envelope=true' ;//+ '/recipients';
			req3.setEndpoint(endPointURL3);
			req3.setMethod('PUT');
			req3.setHeader('X-DocuSign-Authentication', authorizationHeader);
			req3.setHeader('Content-Length', '162100');
			req3.setHeader('Content-Type', 'application/json');
			req3.setHeader('Content-Disposition', 'form-data');
			req3.setTimeout(10000);
			json3 = '{"status":"sent"' + '}';
			//req3.setBody(json3);
			if (!Test.isRunningTest()){
				res3 = http2.send(req3);
				system.debug('DocuSign Response' + res3.getBody());
			}

			if(wt.Docusign_IDV_Failure__c){
			   // wt.Docusign_Re_sent__c = true;
			}
            //WireTransToUpdate.add(wt);
		}


		if(WireTransToUpdate.size() > 0){
		    //update WireTransToUpdate;
		}
	}

	public class RecipientView{
		@AuraEnabled
		public string url{ get; set; }
	}
}