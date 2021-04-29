public class SolarLoanToSignCard {
	
    public List<Solar_loans__c> solarloans{get;set;}
    private ApexPages.StandardSetController standardController;
    public boolean validation {get;set;}
    public boolean morethanone {get;set;}
    public boolean signed {get;set;}
    public boolean notready {get;set;}
    
    public static string Rurl;
	public static String EnvelopeId;
	public static Account Member;
	public static String EmailBody = 'In order for the Credit Union to ensure the solar loan details are accurate, please review and sign the Signature Card form.' +'\n\n' +'If changes are needed or you would like to provide additional payments, please update the form and sign.' +'\n\n' + 'If you have any questions, please contact us at 800-782-8782 ext. 5200.';
	public static String EmailSubject = 'Signature Card';    
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
    public static String DocumentName;
	
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
    
    public static String endPointURL4;
	public static HttpRequest req4 = new HttpRequest();    
	public static String json4;
	public static Http http4 = new Http();
	public static HTTPResponse res4;
    
    public static String endPointURL5;
	public static HttpRequest req5 = new HttpRequest();    
	public static String json5;
	public static Http http5 = new Http();
	public static HTTPResponse res5;
    public static String responseBody1;

    public static String endPointURL6;
	public static HttpRequest req6 = new HttpRequest();    
	public static String json6;
	public static Http http6 = new Http();
	public static HTTPResponse res6;
	
    public SolarLoanToSignCard(ApexPages.StandardSetController standardController){
        // Returns all selected records
        solarloans = (List<Solar_Loans__c>)standardController.getSelected();
        
        If(solarloans.size() == 0){
            validation = false;
        }
        else If(solarloans.size() > 1){
            validation = true;
            morethanone = false;
        }
        else if(solarloans.size() == 1){
        	List<Solar_Loans__c> SolarLoanToProcess = [select id,name,Name__c,Member_number__c,Current_Solar_Loan_Stage__c,
                                                       Count__c,Signed__c from Solar_loans__c where id in :solarloans];    
		  List<SolarLoan_Document__c> sd = [select id,Attachment_Id__c	,name,Solar_Loans__r.id,Solar_Loans__c from SolarLoan_Document__c where Solar_Loans__r.id in: SolarLoanToProcess and Document_Name__c LIKE '%Membership Application%' order by createddate desc LIMIT 1];
            
            System.debug('SolarLoan Doc: '+sd.size());
            system.debug(SolarLoanToProcess[0].Signed__c);
            
            system.debug('Number: '+SolarLoanToProcess[0].Member_number__c);
            system.debug('Name: '+SolarLoanToProcess[0].Name__c);
            system.debug('Docs: '+SolarLoanToProcess[0].Count__c);
            system.debug('Stage: '+SolarLoanToProcess[0].Current_Solar_Loan_Stage__c);
            
            if(SolarLoanToProcess[0].Signed__c == true){
                validation = true;
                morethanone = true;
                signed = false;    
            }
            else if(sd.size() == 0 || SolarLoanToProcess[0].Member_number__c == null || SolarLoanToProcess[0].Name__c == null || 
                    SolarLoanToProcess[0].Count__c == '0' || 
                    (SolarLoanToProcess[0].Current_Solar_Loan_Stage__c != 'Stage 7' && SolarLoanToProcess[0].Current_Solar_Loan_Stage__c != 'Stage 8')){

                validation = true;
                morethanone = true;
                signed = true;
                notready = false;       
            }
            else{
                validation = true;
				morethanone = true;
            	signed = true;
            	notready = true;
            }            
        }    
        else{
			validation = true;
			morethanone = true;
            signed = true;
            notready = true;
        }
        
        this.standardController = standardController;
        system.debug('tttt'+solarloans);
        system.debug('validation'+validation);
        system.debug('morethanone'+morethanone);
    }
    
    
    //public static void SignCard(Set<ID> ids){   
    public PageReference ExecuteSignatureMethod(){
    	
        //----------------------------Start - DocuSign Templates from Custom setting---------------------------------//
        
        SetCustomFieldFalse();

        List<Solar_Loans__c> selectedsolar = (List<Solar_Loans__c>)standardController.getSelected();
        
        Set<Id> ids = new set<Id>();
        For(Solar_Loans__c sl : selectedsolar){
            ids.add(sl.id);
        }
        system.debug('ids: '+ids);
		
        /*If(ids.size() == 0){
    	 	validation = false;
	 		return null;
	 	}
        else{
            validation = true;
        }*/
        
        DocuSign_User_Details__c DTSpectrum = DocuSign_User_Details__c.getValues('Spectrum');
        
        List<Solar_Loans__c> SolarLoansToUpdate = new List<Solar_Loans__c>();
        
        String userName = UserInfo.getUserName();
		User activeUser = [Select Email,FirstName,LastName From User where Username = : userName limit 1];
		String userEmail = activeUser.Email;
		String userFullName = activeUser.FirstName +' '+activeUser.LastName;
        
        system.debug('userName'+userName);
        system.debug('userEmail'+userEmail);
        system.debug('userFullName'+userFullName);
        
        Date dt = system.today();
        String DateToday = dt.format();
        
 
        //----------------------------End - DocuSign Templates from Custom setting------------------------------------//
       
        List<Solar_Loans__c> Solanloanlist = new List<Solar_Loans__c>();         
   		List<Solar_Loans__c> solarloans = [SELECT id,ABA_Bank_Name__c,ACH__c,Additional_Amount__c,Application_Date__c,
            Bank_Account_Number__c,Bank_Name__c,Battery__c,Brand__c,Change_Order__c,CreatedById,CreatedDate,
            Credit_Attributes__c,Credit_Exception__c,Debt_Ratio__c,DocuSignId__c,Due_Date__c,Member_Name__c,
            ECOA_Code__c,Final_Payment_Amount__c,FNI__c,Go_To_Payment__c,Initial_LT_Loan_Agreement__c,
            Installer_Number__c,Installer__c,Interest_Rate__c,Inverter__c,IsDeleted,Joint_Address_1__c,
            Joint_Address_2__c,Joint_City__c,Joint_DOB__c,Joint_FICO_Score__c,Joint_First_Name__c,Joint_Last_Name__c,
            Joint_SSN__c,Joint_State__c,Joint_Zip_Code__c,Latest_LT_Loan_Agreement__c,Legal_Description__c,Loan_Amount__c,Loan_Pmt_Amount__c,
            Loan_Type__c,Maturity_Date__c,Membership_Fee__c,Member_Number__c,Module__c,Mortgage_Balance__c,Name,
            Name__c,Net_Funding_Amount__c,OID_Fee__c,OwnerId,Primary_Address_1__c,Primary_Address_2__c,
            Primary_City__c,Primary_DOB__c,Primary_FICO_Score__c,Primary_First_Name__c,Primary_Last_Name__c,
            Primary_SSN__c,Primary_State__c,Primary_Zip_Code__c,Product_Loan_Type__c,Product__c,Record_ID__c,
            Routing_Number__c,Site_UUID__c,Status__c,Symitar_Called__c,SystemModstamp,System_Size_kW__c,Term_months__c,
            Valid_ABA__c,Loan_Id__c,Account_Number__r.name,Loan_Name_Locator__c,Loan_Tracking_Locator__c, 
            Error_EftLocator__c,Error_Loan_Locator__c,Error_Loan_Name_Locator__c,Error_Loan_Tracking_Locator__c,
            EftLocator__c FROM Solar_Loans__c where id =: ids];
        	
        	//---------------------------------------Fetching "Loan Agreement Doc"---------------------------------//
        	
        	SolarLoan_Document__c sd = [select id,Attachment_Id__c	,name,Solar_Loans__r.id,Solar_Loans__c from SolarLoan_Document__c where Solar_Loans__r.id in: ids and Document_Name__c LIKE '%Membership Application%' order by createddate desc LIMIT 1];
        	system.debug('Solar Doc '+ sd.id);	
        
        	//--------------------------------------Converting Loan Agreement into base64-------------------------//
        	
        	ContentVersion cv =[select VersionData from ContentVersion where ContentDocumentId =: sd.Attachment_Id__c];
			String base64 = EncodingUtil.base64Encode(cv.versionData);
			System.debug(base64);  
        
        
        	for(Solar_Loans__c sl : solarloans){
        		
                templateID = DTSpectrum.TemplateId__c;
                replyTo = DTSpectrum.ReplyTo__c;
                accountID = DTSpectrum.AccountId__c;
                userId = DTSpectrum.Username__c;
                passWord = DTSpectrum.Password__c;
                integratorKey = DTSpectrum.IntegratorKey__c;
                endpoint = DTSpectrum.EndPoint__c;
                
                DocumentName = sl.Name__c +' - '+sl.Member_Number__c + ' - Member Application.pdf';
                
                System.debug('Member Number: '+sl.Member_Number__c);
                system.debug('DocumentName: '+DocumentName);
                authorizationHeader = '<DocuSignCredentials><Username>'+userId+'</Username><Password>'+Password+'</Password><IntegratorKey>'+integratorKey+'</IntegratorKey></DocuSignCredentials>';
                json2='{"replyEmailAddressOverride":"'+replyTo+'",'+'"replyEmailNameOverride": "Spectrum Team",'+'"bccEmailAddresses": []'+'}';
            	
            	            	
        		endPointURL = 'https://'+endpoint+'/restapi/v2.1/accounts/'+accountID+'/envelopes'; 
                req.setEndpoint(endPointURL); 
				req.setMethod('POST'); 
    			req.setHeader('X-DocuSign-Authentication', authorizationHeader); 
				req.setHeader('Content-Length','162100'); 
				req.setHeader('Content-Type','application/json'); 
				req.setHeader('Content-Disposition','form-data'); 
               
                //json = '{"emailBlurb":"'+EmailBody+'",'+'"emailSubject": "'+EmailSubject+'",'+'"status": "created",'+'"documents": ['+'{'+'"documentId": "2",'+'"name": "Loan Agreement - Signed.pdf",'+'"order": "2",'+'"documentBase64": "'+base64+'"'+'}'+'],'+' "recipients": '+'{"signers": ['+'{"email": "rakesh.joshi@alept.com",'+'"name": "Rakesh",'+'"recipientId": "1",'+'"routingOrder": "1",'+'"tabs": '+'{'+'"signHereTabs": ['+'{"anchorString": "Signature of Joint Owner",'+'"anchorUnits": "inches",'+' "anchorXOffset": "1.7",'+'"anchorYOffset": "2"'+'}'+'],'+'"dateTabs": ['+'{"anchorString": "Member #",'+'"anchorUnits": "inches",'+' "anchorXOffset": "1",'+'"anchorYOffset": "0.75",'+'"bold": "true",'+'"font": "helvetica",'+'"fontSize": "size11",'+'"locked": "true",'+'"tabId": "legal_name",'+'"tabLabel": "Legal name",'+'"value":"'+DateToday+'"'+'},'+'{"anchorString": "Member #",'+'"anchorUnits": "inches",'+' "anchorXOffset": "1",'+'"anchorYOffset": "0.38",'+'"bold": "true",'+'"font": "helvetica",'+'"fontSize": "size11",'+'"locked": "true",'+'"tabId": "legal_name",'+'"tabLabel": "Legal name",'+'"value":  "'+DateToday+'"'+'}'+'],'+'"textTabs": ['+'{'+'"anchorString":"Member #",'+'"anchorUnits": "inches",'+'"anchorXOffset": "1",'+'"anchorYOffset": "0",'+'"bold": "true",'+'"font": "helvetica",'+'"fontSize": "size11",'+'"locked": "true",'+'"tabId": "legal_name",'+'"tabLabel": "Legal name",'+'"value":  "'+sl.Member_Number__c+'"'+'},'+'{'+'"anchorString":"XA Application No.",'+'"anchorUnits": "inches",'+'"anchorXOffset": "1.10",'+'"anchorYOffset": "0.05",'+'"bold": "true",'+'"font": "helvetica",'+'"fontSize": "size11",'+'"locked": "true",'+'"tabId": "legal_name",'+'"tabLabel": "Legal name",'+'"value": "2166"'+'},'+'{'+'"anchorString":"Member Number:",'+'"anchorUnits": "inches",'+'"anchorXOffset": "0.4",'+'"anchorYOffset": "0.12",'+'"bold": "true",'+'"font": "helvetica",'+'"fontSize": "size11",'+'"locked": "true",'+'"tabId": "legal_name",'+'"tabLabel": "Legal name",'+'"value": "'+sl.Member_Number__c+'"'+'},'+'{'+'"anchorString":"Signature of Joint Owner",'+'"anchorUnits": "inches",'+'"anchorXOffset": "1.9",'+'"anchorYOffset":  "1.1",'+'"bold": "true",'+'"font": "helvetica",'+'"fontSize": "size11",'+'"locked": "true",'+'"tabId": "legal_name",'+'"tabLabel": "Legal name",'+'"value": "'+sl.Name__c+'"'+'},'+'{'+'"anchorString":"Primary Member/Owner Information",'+'"anchorUnits": "inches",'+'"anchorXOffset": "0.9",'+'"anchorYOffset":  "-0.4",'+'"bold": "true",'+'"font": "helvetica",'+'"fontSize": "size12",'+'"locked": "true",'+'"tabId": "legal_name",'+'"tabLabel": "Legal name",'+'"value": "SOLAR LOAN"'+'},'+'{'+'"anchorString":"Signature of Joint Owner",'+'"anchorUnits": "inches",'+'"anchorXOffset": "1.9",'+'"anchorYOffset":  "1.5",'+'"bold": "true",'+'"font": "helvetica",'+'"fontSize": "size12",'+'"locked": "true",'+'"tabId": "legal_name",'+'"tabLabel": "Legal name",'+'"value": "MARS System"'+'}'+']'+'}'+'}'+']'+'}'+'}';
                json = '{"emailBlurb":"'+EmailBody+'",'+'"emailSubject": "'+EmailSubject+'",'+'"status": "created",'+'"documents": ['+'{'+'"documentId": "2",'+'"name": "'+DocumentName+'",'+'"order": "2",'+'"documentBase64": "'+base64+'"'+'}'+'],'+' "recipients": '+'{"signers": ['+'{"email": "'+userEmail+'",'+'"name":  "'+userFullName+'",'+'"clientUserId" : "120",'+'"recipientId": "1",'+'"routingOrder": "1",'+'"tabs": '+'{'+'"signHereTabs": ['+'{"anchorString": "Approved By:",'+'"anchorUnits": "inches",'+' "anchorXOffset": "1",'+'"anchorYOffset": "0.2"'+'}'+'],'+'"dateTabs": ['+'{"anchorString": "Member #",'+'"anchorUnits": "inches",'+' "anchorXOffset": "1",'+'"anchorYOffset": "0.65",'+'"bold": "false",'+'"font": "helvetica",'+'"fontSize": "size11",'+'"locked": "false",'+'"tabId": "legal_name",'+'"tabLabel": "Legal name",'+'"value":"'+DateToday+'"'+'},'+'{"anchorString": "Member #",'+'"anchorUnits": "inches",'+' "anchorXOffset": "1",'+'"anchorYOffset": "0.34",'+'"bold": "false",'+'"font": "helvetica",'+'"fontSize": "size11",'+'"locked": "false",'+'"tabId": "legal_name",'+'"tabLabel": "Legal name",'+'"value":  "'+DateToday+'"'+'}'+'],'+'"textTabs": ['+'{'+'"anchorString":"Member #",'+'"anchorUnits": "inches",'+'"anchorXOffset": "1",'+'"anchorYOffset": "0",'+'"bold": "false",'+'"font": "helvetica",'+'"fontSize": "size11",'+'"locked": "false",'+'"tabId": "legal_name",'+'"tabLabel": "Legal name",'+'"value":  "'+sl.Member_Number__c+'"'+'},'+'{'+'"anchorString":"Promo Code",'+'"anchorUnits": "inches",'+'"anchorXOffset": "0.1",'+'"anchorYOffset": "0.05",'+'"bold": "false",'+'"font": "helvetica",'+'"fontSize": "size11",'+'"locked": "true",'+'"tabId": "legal_name",'+'"tabLabel": "Legal name",'+'"value": "2166"'+'},'+'{'+'"anchorString":"Member Number",'+'"anchorUnits": "inches",'+'"anchorXOffset": "0.2",'+'"anchorYOffset": "0.1",'+'"bold": "false",'+'"font": "helvetica",'+'"fontSize": "size11",'+'"locked": "false",'+'"tabId": "legal_name",'+'"tabLabel": "Legal name",'+'"value": "'+sl.Member_Number__c+'"'+'},'+'{'+'"anchorString":"Opened By:",'+'"anchorUnits": "inches",'+'"anchorXOffset": "1",'+'"anchorYOffset":  "-0.3",'+'"bold": "false",'+'"font": "helvetica",'+'"fontSize": "size11",'+'"locked": "false",'+'"tabId": "legal_name",'+'"tabLabel": "Legal name",'+'"value": "'+sl.Name__c+'"'+'},'+'{'+'"anchorString":"Primary Member/Owner Information",'+'"anchorUnits": "inches",'+'"anchorXOffset": "0.6",'+'"anchorYOffset":  "-0.5",'+'"bold": "true",'+'"font": "helvetica",'+'"fontSize": "size12",'+'"locked": "true",'+'"tabId": "legal_name",'+'"tabLabel": "Legal name",'+'"value": "SOLAR LOAN"'+'},'+'{'+'"anchorString":"Opened By:",'+'"anchorUnits": "inches",'+'"anchorXOffset": "1",'+'"anchorYOffset":  "0",'+'"bold": "false",'+'"font": "helvetica",'+'"fontSize": "size12",'+'"locked": "false",'+'"tabId": "legal_name",'+'"tabLabel": "Legal name",'+'"value": "MARS System"'+'}'+']'+'}'+'}'+']'+'}'+'}';
                
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
				
				Solar_Loans__c s = new Solar_Loans__c();
            	s.id = sl.Id;
            	s.DocuSignId__c = EnvelopeId;
            
            	//------------------------------------------------------------Saving EnvelopeId-------------------------------------------------//
				
				endPointURL1 = 'https://'+endpoint+'/restapi/v2.1/accounts/'+accountID+'/envelopes/'+EnvelopeId+'/recipients';
				req1.setEndpoint(endPointURL1); 
				req1.setMethod('PUT'); 
    			req1.setHeader('X-DocuSign-Authentication', authorizationHeader); 
				req1.setHeader('Content-Length','162100'); 
				req1.setHeader('Content-Type','application/json'); 
				req1.setHeader('Content-Disposition','form-data'); 
            
                json1 = '{"signers": ['+'{'+'"email": "'+userEmail+'",'+'"recipientId" : "1",'+'"clientUserId" : "120",'+'"roleName": "client",'+'"name": "'+userFullName+'",'+'"signingGroupId": "signers",'+'"routingOrder" : "1"'+'}'+']'+'}';
                //json1 = '{"signers": ['+'{'+'"email": "'+userEmail+'",'+'"recipientId" : "1",'+'"EmbeddedRecipientStartURL":"SIGN_AT_DOCUSIGN",'+'"clientUserId" : "120",'+'"roleName": "client",'+'"name": "Rakesh Joshi",'+'"signingGroupId": "signers",'+'"routingOrder" : "null"'+'}'+']'+'}';
        		
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
             
                endPointURL5 = 'https://'+endpoint+'/restapi/v2.1/accounts/'+accountID+'/envelopes/'+EnvelopeId+'/views/recipient';
				req5.setEndpoint(endPointURL5); 
				req5.setMethod('POST'); 
    			req5.setHeader('X-DocuSign-Authentication', authorizationHeader); 
				req5.setHeader('Content-Length','162100'); 
				req5.setHeader('Content-Type','application/json'); 
                req5.setHeader('Accept','application/json'); 
				req5.setHeader('Content-Disposition','form-data');
             	json5 = '{"clientUserId":"120",'+'"authenticationMethod":"email",'+'"returnUrl":"https://www.spectrumcu.org",'+'"userName": "'+userFullName+'",'+'"email": "'+userEmail+'"'+'}';
             	req5.setBody(json5); 
                system.debug('Request : '+ json5);
             	if(!Test.isRunningTest()){  
					res5 = http5.send(req5); 
                    responseBody1 = res5.getBody();
					system.debug('DocuSign Response'+ responseBody1);
             	}
                else{
                    responseBody1 = '{"url":"www.google.com"}';
                }
                
                
                if(responseBody1 !=''){        
                	Map<String,Object> results = (Map<String,Object>)System.JSON.deserializeUntyped(responseBody1);  
                    System.debug('URL is ....' + results);
                    if(results.size() > 0){
                        for(String key : results.keySet()){                   			
                            if(key == 'url'){
                                Rurl = String.valueOf(results.get(key));
                            }
                        }
                    }
                }

                System.debug('Rurl: '+ Rurl);
    
                s.SignatureCardURL__c = Rurl;
                SolarLoansToUpdate.add(s);
            }
            
            if(SolarLoansToUpdate.size() > 0){
        		update SolarLoansToUpdate;
        	}
        
        PageReference page = new PageReference(Rurl);
        page.setRedirect(true);
        return page;       
        
    }

    @future(callout=true)
    public static void SetCustomFieldTrue(){

        DocuSign_User_Details__c DTSpectrum = DocuSign_User_Details__c.getValues('Spectrum');
        String FieldId;

        templateID = DTSpectrum.TemplateId__c;
        replyTo = DTSpectrum.ReplyTo__c;
        accountID = DTSpectrum.AccountId__c;
        userId = DTSpectrum.Username__c;
        passWord = DTSpectrum.Password__c;
        integratorKey = DTSpectrum.IntegratorKey__c;
        endpoint = DTSpectrum.EndPoint__c;

        if(endpoint == 'www.docusign.net'){
            FieldId = '4845275';
        }
        else{
            FieldId = '145104';
        }

        authorizationHeader = '<DocuSignCredentials><Username>'+userId+'</Username><Password>'+Password+'</Password><IntegratorKey>'+integratorKey+'</IntegratorKey></DocuSignCredentials>';

        //--------------------------------------------------------------Custom field-------------------------------------------------//

        endPointURL6 = 'https://'+endpoint+'/restapi/v2.1/accounts/'+accountID+'/custom_fields/'+FieldId;
        req6.setEndpoint(endPointURL6); 
        req6.setMethod('PUT'); 
        req6.setTimeout(120000);
        req6.setHeader('X-DocuSign-Authentication', authorizationHeader); 
        req6.setHeader('Accept','application/json'); 
        req6.setHeader('Content-Type','application/json'); 
        
        json6 = '{"name": "Member Number",'+'"required":"true",'+'"show":"true"'+'}';
  
        req6.setBody(json6); 
        if(!Test.isRunningTest()){
            res6 = http6.send(req6);
            system.debug('DocuSign Response'+ res6.getBody());
        }

    }

    public static void SetCustomFieldFalse(){

        DocuSign_User_Details__c DTSpectrum = DocuSign_User_Details__c.getValues('Spectrum');
        String FieldId;

        templateID = DTSpectrum.TemplateId__c;
        replyTo = DTSpectrum.ReplyTo__c;
        accountID = DTSpectrum.AccountId__c;
        userId = DTSpectrum.Username__c;
        passWord = DTSpectrum.Password__c;
        integratorKey = DTSpectrum.IntegratorKey__c;
        endpoint = DTSpectrum.EndPoint__c;

        if(endpoint == 'www.docusign.net'){
            FieldId = '4845275';
        }
        else{
            FieldId = '145104';
        }

        authorizationHeader = '<DocuSignCredentials><Username>'+userId+'</Username><Password>'+Password+'</Password><IntegratorKey>'+integratorKey+'</IntegratorKey></DocuSignCredentials>';

        //--------------------------------------------------------------Update Custom field-------------------------------------------------//

        endPointURL6 = 'https://'+endpoint+'/restapi/v2.1/accounts/'+accountID+'/custom_fields/'+FieldId;
        req6.setEndpoint(endPointURL6); 
        req6.setMethod('PUT'); 
        req6.setTimeout(120000);
        req6.setHeader('X-DocuSign-Authentication', authorizationHeader); 
        req6.setHeader('Accept','application/json'); 
        req6.setHeader('Content-Type','application/json'); 
        
        json6 = '{"name": "Member Number",'+'"required":"false",'+'"show":"false"'+'}';
    
        req6.setBody(json6); 
        if(!Test.isRunningTest()){
            res6 = http6.send(req6);
            system.debug('DocuSign Response'+ res6.getBody());
        }

    }	
}