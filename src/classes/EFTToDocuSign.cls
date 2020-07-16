public class EFTToDocuSign {

	public static String EnvelopeId;
	public static String EmailToSend;
	public static Account Member;
	public static String EmailBody = 'In order for the Credit Union to ensure your solar loan automatic payment setup is accurate, please review and sign the ACH form.' +'\n\n' +'If changes are needed or you would like to provide additional payments, please update the form and sign.' +'\n\n' + 'If you have any questions, please contact us at 800-782-8782 ext. 5200.';
	public static String EmailSubject = 'ACH Debits';    
	public static String accountID = '2e80db6b-16cf-4202-bf90-dfa029c5949f'; 
	public static String userId = 'cc0ace2f-a6a7-44ae-852d-3c7432552ebb'; 
	public static String passWord = 'Affirm@123' ;
	public static String integratorKey = '12c7957a-484f-4fec-b6b3-461ec9b666aa' ; 
	public static String replyTo = 'noreply@chevronfcu.org';
	public static String templateID = '5658c430-8e5d-4f53-b910-4d9e939e52ee';
	public static String endPoint = 'demo.docusign.net';
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
	
    
    
    @future(callout=true)
    public static void docusignAPIcall(Set<ID> ids){   
    	system.debug('ids =='+ids);
        //----------------------------Start - DocuSign Templates from Custom setting---------------------------------//
        SolarLoan_Docusign_Emails__c sde = SolarLoan_Docusign_Emails__c.getValues('Email For Testing');
        DocuSign_User_Details__c DTSpectrum = DocuSign_User_Details__c.getValues('Spectrum');
        DocuSign_User_Details__c DTChevron = DocuSign_User_Details__c.getValues('Chevron');
        List<EFT__C> EFTToUpdate = new List<EFT__c>();
        
        String userName = UserInfo.getUserName();
		User activeUser = [Select Email From User where Username = : userName limit 1];
		String userEmail = activeUser.Email;
		
        if(sde.Emails__c != null){
            EmailToSend = sde.Emails__c;
        }
        
        
        
        //----------------------------End - DocuSign Templates from Custom setting------------------------------------//
       
        List<EFT__c> EFTList = new List<EFT__c>();         
   		List<EFT__c> EFTs = [SELECT Account_Number__c,Action_Type__c,Alternate_Amount__c,Bank_Name__c,
                             Case__c,CreatedById,CreatedDate,Day_of_Month__c,DocuSignId__c,Docusign_Checking_Type__c
                             ,Docusign_is_Additional_Amount__c,Docusign_Member_Email__c,Docusign_Savings_Type__c
                             ,Effective_Date__c,EftLocator__c,EFT_ID_Type__c,Error_EftLocator__c,Expiration_Date__c,
                             Expired__c,Expire_DocuSignId__c,Expire_Docusign_Status__c,Frequency__c,Id,
                             isAlternateAmount__c,is_Checking_Account__c,Member_Account__c,Member_Name__c,Member__c,
                             Name,OwnerId,Payment_Amount__c,Routing_Number__c,Second_Day_of_Month__c,Type__c,
                             Share_Loan_Description__c,Share_Loan_Id__c,Share_Loan_Type__c,Stage__c,Status__c,
                             Update_DocuSignId__c,Update_Docusign_Status__c FROM EFT__c where id =: ids];
        
        	for(EFT__c eft : EFTs){
        		
                action = eft.Action_Type__c;
               
            	authorizationHeader = '<DocuSignCredentials><Username>'+userId+'</Username><Password>'+Password+'</Password><IntegratorKey>'+integratorKey+'</IntegratorKey></DocuSignCredentials>';
        		endPointURL = 'https://'+endpoint+'/restapi/v2.1/accounts/'+accountID+'/envelopes'; 
                req.setEndpoint(endPointURL); 
				req.setMethod('POST'); 
    			req.setHeader('X-DocuSign-Authentication', authorizationHeader); 
				req.setHeader('Content-Length','162100'); 
				req.setHeader('Content-Type','application/json'); 
				req.setHeader('Content-Disposition','form-data'); 
                system.debug('EFTID =='+eft.Id);
                json = '{"emailBlurb":"'+EmailBody+'",'+'"emailSubject": "'+EmailSubject+'",'+'"status": "created",'+'"compositeTemplates": ['+'{'+'"serverTemplates": ['+'{'+'"sequence": "1",'+'"templateId":"'+templateID+'"'+'}'+'],'+'"inlineTemplates": ['+'{'+'"sequence": "1",'+'"customFields": {'+'"textCustomFields": ['+'{'+'"configurationType": "salesforce",'+'"name":"EFT__c",'+'"required": "true","show": "true",'+'"value":"'+eft.Id+'"'+'}'+']'+'}'+'}'+']'+'}'+']'+'}';
	            req.setBody(json); 
    			if(!Test.isRunningTest()){  
    				res = http.send(req);
    				responseBody = res.getBody();
    				system.debug('DocuSign Response'+ res.getBody()); 
    			}
    			else{
					responseBody = '{"emailBlurb":"emailBlurb",'+'"emailSubject": "emailSubject",'+'"status": "created",'+'"compositeTemplates": ['+'{'+'"serverTemplates": ['+'{'+'"sequence": "1",'+'"templateId": "templateId"'+'}'+'],'+'"inlineTemplates": ['+'{'+'"sequence": "1",'+'"customFields": {'+'"textCustomFields": ['+'{'+'"configurationType": "salesforce",'+'"name":"EFT__c",'+'"required": "true","show": "true",'+'"value":"a2T19000000opfgEAA"'+'}'+']'+'}'+'}'+']'+'}'+']'+'}';    				
    			}
                
                
                //--------------------------------Saving EnvelopeId--------------------------------------------------//
               
                EnvelopeId = String.valueOf(responseBody).substringAfter('"envelopeId":"');
				EnvelopeId = String.valueOf(EnvelopeId).substringBefore('"');
				system.debug('EnvelopeId: '+EnvelopeId);
				
				EFT__c e = new EFT__c();
            	e.id = eft.Id;
            	e.DocuSignId__c = EnvelopeId;
            
            	EFTToUpdate.add(e);
				
				//--------------------------------Saving EnvelopeId-------------------------------------------------//
				
				endPointURL1 = 'https://'+endpoint+'/restapi/v2.1/accounts/'+accountID+'/envelopes/'+EnvelopeId+'/recipients';
				req1.setEndpoint(endPointURL1); 
				req1.setMethod('PUT'); 
    			req1.setHeader('X-DocuSign-Authentication', authorizationHeader); 
				req1.setHeader('Content-Length','162100'); 
				req1.setHeader('Content-Type','application/json'); 
				req1.setHeader('Content-Disposition','form-data'); 
                
                if(EmailToSend == 'Production' || EmailToSend == 'production'){
            	
         			Member = [select id, name, PersonEmail from account where id =: eft.Member_Name__c Limit 1];
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
            
            if(EFTToUpdate.size() > 0){
        		update EFTToUpdate;
        	}
    }	
}