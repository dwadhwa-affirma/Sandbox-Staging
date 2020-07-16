public class WiresTransToDocuSign {

	public static String EnvelopeId;
	public static String EmailToSend;
	public static Account Member;
	public static String EmailBody = 'My Message';
	public static String EmailSubject = 'Wire Approval';    
	public static String accountID = '2e80db6b-16cf-4202-bf90-dfa029c5949f'; 
	public static String userId = 'cc0ace2f-a6a7-44ae-852d-3c7432552ebb';
	public static String passWord = 'Affirm@123';
	public static String integratorKey = '12c7957a-484f-4fec-b6b3-461ec9b666aa';
	public static String replyTo = 'noreply@chevronfcu.org';
	public static String templateID = '9f83c1b8-23e7-49bb-a05f-fc81b6d0475c';
	public static String endPoint = 'demo.docusign.net';
	public static String authorizationHeader;      
	public static String endPointURL;
	public static HttpRequest req = new HttpRequest();    
	public static String json;
	public static Http http = new Http();
	public static HTTPResponse res;
	public static String responseBody;
	
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
	
    
    
    @future(callout=true)
    public static void docusignAPIcall(Set<ID> ids){   
    	
        //----------------------------Start - DocuSign Templates from Custom setting---------------------------------//
        SolarLoan_Docusign_Emails__c sde = SolarLoan_Docusign_Emails__c.getValues('Email For Testing');
        DocuSign_User_Details__c DTSpectrum = DocuSign_User_Details__c.getValues('Spectrum');
        DocuSign_User_Details__c DTChevron = DocuSign_User_Details__c.getValues('Chevron');
        List<WIRES_Transaction__c> WireTransToUpdate = new List<WIRES_Transaction__c>();
        
        String userName = UserInfo.getUserName();
		User activeUser = [Select Email From User where Username = : userName limit 1];
		String userEmail = activeUser.Email;
		
        if(sde.Emails__c != null){
            EmailToSend = sde.Emails__c;
        }
        
        
        
        //----------------------------End - DocuSign Templates from Custom setting------------------------------------//
       
        List<WIRES_Transaction__c> WiresList = new List<WIRES_Transaction__c>();         
   		List<WIRES_Transaction__c> WiresTrans = [SELECT AccountStableReview__c,Account_Stable_2nd_Review__c,
                     Approval_Status__c,Approved_by_1st_Approver__c,Approved_by_2nd_approver__c,
                    Available_Balance_2nd_Review__c,Available_Balance_Review__c,Description__c,EndDate__c,
                    Chevron_Account_Number__c,CreatedById,CreatedDate,FlagAccountOpenfor45Days__c,Fees__c,
                    DocuSignId__c,DocuSign_Status1__c,EmailStableReview__c,Email_Stable_2nd_Review__c,FlagHomePhoneStablefor30Days__c,
                    FlagEmailStablefor30Days__c,FlagMobilePhoneStablefor30Days__c,FlagWorkPhoneStablefor30Days__c,
                    Frequency__c,FromAccount__c,Home_Phone_Stable_2nd_Review__c,Home_Phone_Stable_Review__c,Id,Identity_Verification_Used__c,
                    ID_Verification_2nd_Review__c,ID_Verification_Review__c,IsAccountOpenfor45Days__c,IsDeleted,IsEmailStable__c,TotalFromAccount__c,
                    IsHomePhoneStable__c,IsMobilePhoneStable__c,IsWorkPhoneStable__c,Is_Recurrence_Day__c,Member_Address__c,Member_City_State_Zip__c,
                    Member_Email__c,Member_Home_Phone__c,Member_Name__c,TransactionStatus__c,
                    Mobile_Phone_Stable_2nd_Review__c,Mobile_Phone_Stable_Review__c,RecurrenceEndDate__c,
                    Name,Occurences__c,OwnerId,ParentTransaction__c,ToAccoutId__c,RecurrenceRange__c,
                    Previous_Wires_2nd_Review__c,Previous_Wires_Review__c,RecurrenceDay__c,Recurrence_Pattern__c,
                    Review_Reason__c,Second_Approval_Review_Reason__c,SendOn__c,Share_ID__c,Transaction_Status__c,
                    Source__c,StartDate__c,Status__c,ToAccountName__c,TransferType__c,WireAmount__c,WireMoneyDeliveryByDate__c,
                    WIRES_Wires_Transaction__c,Work_Phone_Stable_2nd_Review__c,Work_Phone_Stable_Review__c
                    FROM WIRES_Transaction__c where id =: ids];
        
        	for(WIRES_Transaction__c wt : WiresTrans){
        		
                authorizationHeader = '<DocuSignCredentials><Username>'+userId+'</Username><Password>'+Password+'</Password><IntegratorKey>'+integratorKey+'</IntegratorKey></DocuSignCredentials>';
        		
        		endPointURL = 'https://'+endpoint+'/restapi/v2.1/accounts/'+accountID+'/envelopes'; 
                req.setEndpoint(endPointURL); 
				req.setMethod('POST'); 
    			req.setHeader('X-DocuSign-Authentication', authorizationHeader); 
				req.setHeader('Content-Length','162100'); 
				req.setHeader('Content-Type','application/json'); 
				req.setHeader('Content-Disposition','form-data'); 
                json = '{"emailBlurb":"'+EmailBody+'",'+'"emailSubject": "'+EmailSubject+'",'+'"status": "created",'+'"compositeTemplates": ['+'{'+'"serverTemplates": ['+'{'+'"sequence": "1",'+'"templateId":"'+templateID+'"'+'}'+'],'+'"inlineTemplates": ['+'{'+'"sequence": "1",'+'"customFields": {'+'"textCustomFields": ['+'{'+'"configurationType": "salesforce",'+'"name":"Solar_Loans__c",'+'"required": "true","show": "true",'+'"value":"'+wt.Id+'"'+'}'+']'+'}'+'}'+']'+'}'+']'+'}';
	            req.setBody(json); 
    			if(!Test.isRunningTest()){  
    				res = http.send(req);
    				responseBody = res.getBody();
    				system.debug('DocuSign Response'+ res.getBody()); 
    			}
    			else{
					responseBody = '{"emailBlurb":"emailBlurb",'+'"emailSubject": "emailSubject",'+'"status": "created",'+'"compositeTemplates": ['+'{'+'"serverTemplates": ['+'{'+'"sequence": "1",'+'"templateId": "templateId"'+'}'+'],'+'"inlineTemplates": ['+'{'+'"sequence": "1",'+'"customFields": {'+'"textCustomFields": ['+'{'+'"configurationType": "salesforce",'+'"name":"Solar_Loans__c",'+'"required": "true","show": "true",'+'"value":"a2T19000000opfgEAA"'+'}'+']'+'}'+'}'+']'+'}'+']'+'}';    				
    			}
                
                
                //--------------------------------Saving EnvelopeId--------------------------------------------------//
               
                EnvelopeId = String.valueOf(responseBody).substringAfter('"envelopeId":"');
				EnvelopeId = String.valueOf(EnvelopeId).substringBefore('"');
				system.debug('EnvelopeId: '+EnvelopeId);
				
				WIRES_Transaction__c w = new WIRES_Transaction__c();
            	w.id = wt.Id;
            	w.DocuSignId__c = EnvelopeId;
            
            	WireTransToUpdate.add(w);
				
				//--------------------------------Saving EnvelopeId-------------------------------------------------//
				
				endPointURL1 = 'https://'+endpoint+'/restapi/v2.1/accounts/'+accountID+'/envelopes/'+EnvelopeId+'/recipients';
				req1.setEndpoint(endPointURL1); 
				req1.setMethod('PUT'); 
    			req1.setHeader('X-DocuSign-Authentication', authorizationHeader); 
				req1.setHeader('Content-Length','162100'); 
				req1.setHeader('Content-Type','application/json'); 
				req1.setHeader('Content-Disposition','form-data'); 
                
                if(EmailToSend == 'Production' || EmailToSend == 'production'){
            	
         			Member = [select id, name, PersonEmail from account where id =: wt.Member_Name__c Limit 1];
         			json1 = '{"signers": ['+'{'+'"email": "'+Member.PersonEmail+'",'+'"recipientId" : "1",'+'"roleName": "client",'+'"name": "'+Member.Name+'",'+'"signingGroupId": "signers",'+'"routingOrder" : "null"'+'}'+']'+'}';
           		}
                
                if(EmailToSend != 'Production' || EmailToSend != 'production'){
        			EmailToSend = userEmail;
        			json1 = '{"signers": ['+'{'+'"email": "'+EmailToSend+'",'+'"recipientId" : "1",'+'"roleName": "client",'+'"name": "'+userName+'",'+'"signingGroupId": "signers",'+'"routingOrder" : "null"'+'}'+']'+'}';
        		}
                
	            req1.setBody(json1); 
	            if(!Test.isRunningTest()){
    				res1 = http1.send(req1);
    				system.debug('DocuSign Response'+ res1.getBody());
	            }
	            
                //------------------------------------------Setting Reply-To -----------------------------------------// 
                
                endPointURL2 = 'https://'+endpoint+'/restapi/v2.1/accounts/'+accountID+'/envelopes/'+EnvelopeId+'/email_settings';
                req2.setEndpoint(endPointURL2); 
				req2.setMethod('POST'); 
    			req2.setHeader('X-DocuSign-Authentication', authorizationHeader); 
				req2.setHeader('Content-Length','162100'); 
				req2.setHeader('Content-Type','application/json'); 
				req2.setHeader('Content-Disposition','form-data');
				json2='{"replyEmailAddressOverride": "'+replyTo+'",'+'"replyEmailNameOverride": "Chevron Team",'+'"bccEmailAddresses": []'+'}';
				req2.setBody(json2); 
				if(!Test.isRunningTest()){ 
					res2 = http2.send(req2);
					system.debug('DocuSign Response'+ res2.getBody());
				} 
				
				//------------------------------------------Sending Envelope -----------------------------------------//
				
				endPointURL3 = 'https://'+endpoint+'/restapi/v2.1/accounts/'+accountID+'/envelopes/'+EnvelopeId;
				req3.setEndpoint(endPointURL3); 
				req3.setMethod('PUT'); 
    			req3.setHeader('X-DocuSign-Authentication', authorizationHeader); 
				req3.setHeader('Content-Length','162100'); 
				req3.setHeader('Content-Type','application/json'); 
				req3.setHeader('Content-Disposition','form-data');
             	json3 = '{"status":"sent"'+'}';
             	req3.setBody(json3); 
             	if(!Test.isRunningTest()){  
					res3 = http2.send(req3); 
					system.debug('DocuSign Response'+ res3.getBody());
             	}   
            }
            
            if(WireTransToUpdate.size() > 0){
        		update WireTransToUpdate;
        	}
    }	
}