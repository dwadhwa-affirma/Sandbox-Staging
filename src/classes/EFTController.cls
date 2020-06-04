public class EFTController {
    
     //------------------------------- Getting Stage Details and Member Account Details-----------------------------------------------//
    @AuraEnabled
    public static map<string,object> getStageData(string recordId, string sObjectType){
        map<string,object> resultMap = new map<string,object>();
        
        List<EFT_Stages__c> EFTStages = new List<EFT_Stages__c>();
        EFTStages = [SELECT id, name, isActive__c, Order__c, Stage_Action__c,Stage_Action_Placeholder__c, Stage_Component__c, Stage_Label__c, StepId__c from EFT_Stages__c where isActive__c = true]; //where isActive__c = true;      //EFT_Stages__c.getall().values();
        resultMap.put('EFTStages', EFTStages);
        system.debug('sObjectType=='+sObjectType);
       
            List<EFT__c> EFTRecord = [Select id, name, Member_Account__c, Stage__c, Action_Type__c from EFT__c where Member_Account__c =:recordId limit 1];
            integer activeStageIndex = 0;
            if(EFTRecord.size() >0){               
                for(EFT_Stages__c eftstage:EFTStages){
                    if(EFTRecord[0].Stage__c == eftstage.Stage_Label__c){
                    	activeStageIndex = (integer)eftstage.Order__c;
                	}
                }
                              
                resultMap.put('EFT', EFTRecord);
                
            }
            Account_Details__c MemberAccount = [select id,name from Account_Details__c where id=:recordId limit 1];
            resultMap.put('MemberAccount', MemberAccount);
       
        return resultMap;
    }
    
    @AuraEnabled
    public static EFT__c getEFT(EFT__c EFTRecord){
        EFT__c ResultEFTRecord = [select id, name, Member_Account__c, Stage__c, Action_Type__c, Share_Loan_Id__c, Type__c	,Share_Loan_Type__c, Share_Loan_Description__c,
                                      Routing_Number__c, Bank_Name__c, Account_Number__c, Alternate_Amount__c,Effective_Date__c,
                                      Frequency__c, Payment_Amount__c, Day_of_Month__c, Member_Account__r.name, Case__c, Case__r.CaseNumber, Case__r.Status	
                                      from EFT__c where id =: EFTRecord.id limit 1];
        
        return ResultEFTRecord;
        
    }
   
   
    //------------------------------- Saving EFT data to Salesforce-----------------------------------------------//
    @AuraEnabled
    public static EFT__c saveStageData(EFT__c EFTRecord){
        system.debug('EFTRecord=='+EFTRecord.Id);
        List<EFT__c> EFTRecordList = [Select id, name, Member_Account__c, Stage__c, Action_Type__c from EFT__c where id =:EFTRecord.id limit 1];
        
        system.debug('EFTRecordList.size=='+EFTRecordList.size());
        if(EFTRecordList.size() == 0){
            insert EFTRecord;
            return EFTRecord;
        }
        else{
        	EFTRecordList[0].Stage__c =  EFTRecord.Stage__c;
            EFTRecordList[0].Share_Loan_Id__c =  EFTRecord.Share_Loan_Id__c;
            EFTRecordList[0].Share_Loan_Type__c =  EFTRecord.Share_Loan_Type__c;
            EFTRecordList[0].Share_Loan_Description__c =  EFTRecord.Share_Loan_Description__c;
            EFTRecordList[0].EFT_ID_Type__c =  EFTRecord.EFT_ID_Type__c;
            EFTRecordList[0].Routing_Number__c =  EFTRecord.Routing_Number__c;
            EFTRecordList[0].Bank_Name__c =  EFTRecord.Bank_Name__c;
            EFTRecordList[0].Account_Number__c =  EFTRecord.Account_Number__c;
            EFTRecordList[0].Type__c  =  EFTRecord.Type__c;
            EFTRecordList[0].Alternate_Amount__c  =  EFTRecord.Alternate_Amount__c;
            EFTRecordList[0].Payment_Amount__c  =  EFTRecord.Payment_Amount__c;
            EFTRecordList[0].Frequency__c  =  EFTRecord.Frequency__c;
            EFTRecordList[0].Effective_Date__c  =  EFTRecord.Effective_Date__c;
            EFTRecordList[0].Day_of_Month__c  =  EFTRecord.Day_of_Month__c;
            EFTRecordList[0].Action_Type__c  =  EFTRecord.Action_Type__c;
            update EFTRecordList;
            return EFTRecordList[0];
        }
          
    }
    
    @AuraEnabled
    public static EFT__c expireEFT(EFT__c EFTRecord){
       // system.debug('EFTRecordString=='+EFTRecordString);
        //EFT__c EFTRecord = (EFT__c) System.JSON.deserialize(EFTRecordString, EFT__c.Class);
        system.debug('EFTRecordId=='+EFTRecord.Action_Type__c);
        EFT__c EFTRecordList = [Select id, name, Member_Account__c, Stage__c, Action_Type__c, Expired__c from EFT__c where id =:EFTRecord.Id limit 1];
        
        system.debug('EFTRecordList.size=='+EFTRecordList);
        if(EFTRecordList != null){            
            EFTRecordList.Expired__c  =  true;
            update EFTRecordList;
        }
        
		return EFTRecordList;        
    }
    
    
     //------------------------------- Createing Case-----------------------------------------------//    
    @AuraEnabled
    public static EFT__c createCase(EFT__c EFTRecord){
        system.debug('EFTID==='+EFTRecord.id);
        list<CaseRecordType__c> scList = [SELECT Id,
                                                 Primary_Category__c,
                                                 Secondary_Category__c,
                                                 Teritiary_Category__c,
                                                 Record_Type_Name__c,
                                                 SLA__c,
                                                 RecordTypeId__c FROM CaseRecordType__c WHERE Primary_Category__c = 'Account Maintenance' AND Secondary_Category__c='Account Services' AND Teritiary_Category__c='ACH - Authorization for Debit' LIMIT 1];
       
    		Group gp = [select Id, Name from Group where  Type = 'Queue' AND NAME = 'Authentication Failed – Unusual Activity'];
			case cs = new case();
			 for(CaseRecordType__c crt : scList){
		            cs.RecordTypeId = scList[0].RecordTypeId__c;
		            cs.Primary_Category__c = scList[0].Primary_Category__c;
		            cs.Secondary_Category__c = scList[0].Secondary_Category__c;
		            cs.Tertiary_Category__c = scList[0].Teritiary_Category__c;
		            cs.Sla__c = scList[0].SLA__c;
	            
             	}    
				//cs.AccountId = EFTRecord.Member_Account__c;
				cs.Status = 'Open';
				cs.Subject = 'EFT Recorcd';
				cs.ownerid = '005j000000DCwXHAA1';
				//cs.CaseComments__c = casecomment;
				string operation='';
				if(EFTRecord.Action_Type__c == 'Create'){
					operation = 'EFT Record Created' + '\n';
				}
				else if(EFTRecord.Action_Type__c == 'Update' && !EFTRecord.Expired__c){
					operation = 'EFT Record Updated'  + '\n';
				}
				else if(EFTRecord.Action_Type__c == 'Update' && EFTRecord.Expired__c){
					operation = 'EFT Record Expired' + '\n' + 'Expiration Date:' + EFTRecord.Expiration_Date__c + '\n' ;
				}
				cs.Account_Number__c = EFTRecord.Member_Account__c;
        		cs.Description = operation + 'Share/Loan:' + EFTRecord.Share_Loan_Id__c 
                                    + '\n' + 'ABA/Routing#:' + EFTRecord.Routing_Number__c 
                                     + '\n' +'Funding FI:' + EFTRecord.Bank_Name__c
                                     + '\n' +'Account Number:' + EFTRecord.Account_Number__c
                                     + '\n' +'Type:' + EFTRecord.Type__c
                                     + '\n' +'Payment Amount:' + EFTRecord.Payment_Amount__c				 
                                     + '\n' +'Effective Date:' + EFTRecord.Effective_Date__c
                                     + '\n' +'Frequency:' + EFTRecord.Frequency__c
                                     + '\n' +'Day of Month:' + EFTRecord.Day_of_Month__c;
				insert cs;
        		id caseId = cs.id;
        		
        		EFTRecord.Case__c = caseId;
        		update EFTRecord;
        		
        		
        		
        		EFT__c ResultEFTRecord = [select id, name, Member_Account__c, Stage__c, Action_Type__c, Share_Loan_Id__c, Type__c	,Share_Loan_Type__c, Share_Loan_Description__c,
                                      Routing_Number__c, Bank_Name__c, Account_Number__c, Alternate_Amount__c,Effective_Date__c,
                                      Frequency__c, Payment_Amount__c, Day_of_Month__c, Member_Account__r.name, Case__c, Case__r.CaseNumber, Case__r.Status	, Expired__c
                                      from EFT__c where id =: EFTRecord.id limit 1];
                                      
                List<EFT__c> EFTToSendACHDoc = new List<EFT__c>();
                EFTToSendACHDoc.add(ResultEFTRecord);                      
              	//sendACHDocument(EFTToSendACHDoc);
        		
        		system.debug('case==='+ResultEFTRecord.Case__r.CaseNumber);
        		return ResultEFTRecord;
    }
    
    
     //-------------------------------Send ACH Document-----------------------------------------------//
    @AuraEnabled
    public static void sendACHDocument(EFT__c recordId){
        
        String action = recordId.Action_Type__c	;
    	
    	List<EFT__c> EFTToUpdate = new List<EFT__c>();
  		String Email;
        List<string> EmailList = new List<String>();
     
  		SolarLoan_Docusign_Emails__c sde = SolarLoan_Docusign_Emails__c.getValues('Email For Testing');
        
        if(sde.Emails__c != null){
            Email = sde.Emails__c;
        }    
        EmailList = Email.split(',');
        
       // for(Integer i=0;i<recordId.size();i++){
        	
            dfsle.Recipient myRecipient;
            dfsle.UUID myTemplateId;
            dfsle.Document myDocument;
            dfsle.CustomField Depositary;
            dfsle.Envelope myEnvelope;
            //Account MemberEmail;
			String Name;
            String DocuSignId;
            
            //if(recordId.get(i).Primary_First_Name__c != null){
            //	Name = recordId.get(i).Primary_First_Name__c +' '+recordId.get(i).Primary_Last_Name__c;
            //}
            //else if(recordId.get(i).Primary_Last_Name__c != null){
            //	Name = recordId.get(i).Primary_Last_Name__c;
            //}
            /*if(Name != null){
            	MemberEmail = [select id, name, PersonEmail from account where name =:Name Limit 1];
            }*/
            
            /*if(MemberEmail.PersonEmail != null){
            	myRecipient = dfsle.Recipient.fromSource(Name,MemberEmail.PersonEmail,null,'Signer 1',new dfsle.Entity(recordId.get(i).Id));
            }*/
            system.debug(recordId.Member_Account__c);
            Person_Account__c paPrimary = [SELECT Id,PersonID__c,
                             Account_Number__c, Account_Number__r.RecType__c,TypeTranslate__c, Account_Number__r.Name, PersonID__r.Home_Phone__pc,PersonID__r.Residential_City__pc,PersonID__r.Residential_State__pc, PersonID__r.Residential_Street__pc, PersonID__r.Residential_Zipocde__pc, PersonID__r.Name, PersonID__r.Email_raw__c FROM Person_Account__c 
                             WHERE Account_Number__c =: recordId.Member_Account__c and TypeTranslate__c  like '%Primary%' limit 1];
                             
      		Name = paPrimary.PersonID__r.Name;
            
            if(EmailList.size() > 0){
	            
	            for(String emailToSend: EmailList){
	            		
	            	myRecipient = dfsle.Recipient.fromSource(Name,emailToSend,null,'Signer 1',new dfsle.Entity(recordId.Id));
	            	
	            	//if(recordId.get(i).Brand__c == 'Spectrum'){
		            //	myTemplateId = dfsle.UUID.parse('dc16d8f8-571c-497e-bbf5-42d8b25d4ee1');  //Spectrum
		            //}
		            //else{
		            //Create EFT
                    if(action == 'Create'){
		            	myTemplateId = dfsle.UUID.parse('5658c430-8e5d-4f53-b910-4d9e939e52ee');  //Create EFT
                    	myDocument =dfsle.Document.fromTemplate(myTemplateId,'Chevron ACH Debits - EFT');
                    }
                    //Expire EFT
                    else if(action == 'Update' && recordId.Expired__c){
		            	myTemplateId = dfsle.UUID.parse('5658c430-8e5d-4f53-b910-4d9e939e52ee'); //Expire EFT
                        myDocument =dfsle.Document.fromTemplate(myTemplateId,'Chevron ACH Debits - EFT');
                    }
                    //Update EFT
                    else if(action == 'Update' && !recordId.Expired__c){
		            	myTemplateId = dfsle.UUID.parse('5658c430-8e5d-4f53-b910-4d9e939e52ee'); //Update EFT
                        myDocument =dfsle.Document.fromTemplate(myTemplateId,'Spectrum ACH Debits');
                    }
		            //}
		            
		           // myDocument =dfsle.Document.fromTemplate(myTemplateId,'Spectrum ACH Debits');
       			    Depositary = new dfsle.CustomField('text','##SFEFT__c',recordId.Id, null,true, true);
        		    myEnvelope = new dfsle.Envelope(null,null, null,null,new List<dfsle.Document> { myDocument },null,new List<dfsle.CustomField> { Depositary },null,
															'ACH Debits',
															'My Message',null,null);
					 myEnvelope = myEnvelope.withRecipients(new List<dfsle.Recipient> { myRecipient });
					 
					 if(!Test.isRunningTest()){
            			myEnvelope = dfsle.EnvelopeService.sendEnvelope(myEnvelope, true);
            		 }
	            }	         	   
            }	
            
            
            // ---------------------------- Fetching DocusignId and inserting into Solar Loan record---------------------------------//
            
            DocuSignId = String.valueOf(myEnvelope).substringAfter('docuSignId=');
            DocuSignId = String.valueOf(DocuSignId).substringBefore(',');
            system.debug('tttt1'+DocuSignId);
            
            EFT__c e = new EFT__c();        	
            e.id = recordId.Id;
        	if(action == 'Create')
            e.DocuSignId__c = DocuSignId.toUpperCase();
            else if(action == 'Update' && !recordId.Expired__c)
            e.Update_DocuSignId__c = DocuSignId.toUpperCase();
                
            EFTToUpdate.add(e);
        //}
        
        if(EFTToUpdate.size() > 0){
        	update EFTToUpdate;
        }
    
    }
    
    
     //-------------------------------Getting BankName from Entered Routing No-----------------------------------------------//
    @AuraEnabled
    public static string routingInfo(String RoutingNumber){
      	system.debug('RoutingNumber=='+RoutingNumber);
    	String jsonData;  
    	HttpRequest req = new HttpRequest();
    	String BankName;
    	//String RoutingNum = '122105155';
    	
    	req.setEndpoint('https://www.routingnumbers.info/api/data.json?rn='+RoutingNumber);
        req.setMethod('POST');
        req.setHeader('Content-Type', 'application/json');
        req.setHeader('Accept', 'application/json');
        
        Http http = new Http();  
        req.setTimeout(60000);
        HttpResponse res;
        String responseBody;
        if(!Test.isRunningTest()){                       
            res = http.send(req);
            responseBody = res.getBody();
            System.debug('Response Body::'+res.getBody());    
        }else{
            responseBody = '{"office_code": "O", "telephone": "800-937-6310", "change_date": "061109", "rn": "122105155", "state": "MN", "zip": "55107-1419", "data_view_code": "1", "message": "OK", "address": "EP-MN-WN1A", "customer_name": "US BANK NA", "city": "ST. PAUL"}';
        }
        
        if(responseBody!=''){        
       			Map<String,Object> results = (Map<String,Object>) JSON.deserializeUntyped(responseBody);      
         		System.debug('Service response is ....' + results);
                
               
                if(results.size() > 0){
                	
                   for(String key : results.keySet()){                   			
                       	if(key == 'customer_name'){
                       		BankName = (string)results.get(key);
                       	}
       				}
                    
                }
            }
        
		System.debug('Bank Name:' + BankName);
           	                
        return BankName; 
    }
    
    //-------------------------------Getting Share Accounts from Episys----------------------------------------------//
    @AuraEnabled
    public static List<ShareLoanWrapperObject> getShareLoanAccounts(string recordId){
    		system.debug('recordId=='+recordId);
        	Account_Details__c MemberAccount = [select id,name from Account_Details__c where id=:recordId limit 1];
        	String AccountNumber = MemberAccount.name;
        	List<ShareLoanWrapperObject> resultList = new List<ShareLoanWrapperObject>();
        	
        	httpRequest requestparam = new httpRequest(); 
	        requestparam.setEndpoint('https://symxapi.chevronfcu.org/devclient/PsAuto/GetShares?AccountNumber=' + AccountNumber + '&userchar2=abc');
	        requestparam.setMethod('GET');      
	          
	       
	        http httpParam = new http();
	        httpResponse response = httpParam.send(requestparam);
	        
	        String strStatus = response.getStatus();
	        String strBody = response.getBody();
        	
         	System.debug('strStatus ....' + strStatus);
        	System.debug('strBody ....' + strBody);
        
        	
        	
        	if(strBody!=''){        
       			List<Object> results = (List<Object>) JSON.deserializeUntyped(response.getBody());      
         		System.debug('Service response is ....' + results);
                
                
                 for(Object t : results){
                   			ShareLoanWrapperObject temp = new ShareLoanWrapperObject();
                       		map<string, object> localAcc = (map<string, object>)t;                       		
                       		string accouttype = (string)localAcc.get('AccountType');                       		
                       		integer ShareId =  integer.valueof(accouttype.split(' ')[1].replace('#',''));
       						System.debug('ShareId ....' + ShareId);
	                       if(ShareId != 0){
	                               temp.ShareLoanID = ShareId; 
	                               temp.Description =   (string)localAcc.get('Description');  
	                               temp.TypeTranslate =  (string)localAcc.get('Description'); 
	                               temp.Type =  'Share'; 
	                               resultList.add(temp);
	                       }
       				}
            }
            
            List<ShareLoanWrapperObject> LoanList = getLoanAccounts(AccountNumber);
            resultList.addall(LoanList);
            system.debug('resultList=='+resultList);
            return resultList;
      
    }
    
    //-------------------------------Getting Loan Accounts from Episys----------------------------------------------//
    public static List<ShareLoanWrapperObject> getLoanAccounts(string AccountNumber){
    		List<ShareLoanWrapperObject> resultList = new List<ShareLoanWrapperObject>();
    		
    		httpRequest requestparam = new httpRequest(); 
	        requestparam.setEndpoint('https://symxapi.chevronfcu.org/devclient/PsAuto/GetLoansSelectFields?AccountNumber=' + AccountNumber);
	        requestparam.setMethod('GET');      
	          
	       
	        http httpParam = new http();
	        httpResponse response = httpParam.send(requestparam);
	        
	        String strStatus = response.getStatus();
	        String strBody = response.getBody();
        	
         	System.debug('strStatus ....' + strStatus);
        	System.debug('strBody ....' + strBody);
        
        	
        	
        	if(strBody!=''){        
       			List<Object> results = (List<Object>) JSON.deserializeUntyped(response.getBody());      
         		System.debug('Service response is ....' + results);
                
              
                if(results.size() > 0){
                	
                   for(Object t : results){
                   			ShareLoanWrapperObject temp = new ShareLoanWrapperObject();
                       		map<string, object> localAcc = (map<string, object>)t;
                       		Integer LoanId = (Integer)localAcc.get('LoanId');
       						System.debug('Service response is ....' + localAcc);
	                       if(LoanId != 0){
	                               temp.ShareLoanID =  LoanId; 
	                               temp.Description =   (string)localAcc.get('Description');  
	                               //temp.TypeTranslate =  (string)localAcc.get('Description'); 
	                               temp.Type =  'Loan'; 
	                               resultList.add(temp);  
	                       }
       				}
                    
                    set<string> LoanIds = new set<string>();
                    map<string,string> LoanIdTypeTranslateMap = new map<string,string>();
                    for(ShareLoanWrapperObject obj: resultList){
                        LoanIds.add(string.valueof(obj.ShareLoanID).substring(0, 2));
                        system.debug('sdsf'==string.valueof(obj.ShareLoanID).substring(0, 2));                        
                    }
                    
                    List<EFT_ShareLoan_TypeTranslate__c> listTT = [select name, Code__c, RecType__c, TypeTranslate__c from EFT_ShareLoan_TypeTranslate__c
                                                                  where Code__c in: LoanIds and RecType__c = 'LOAN'];
                    
                    for(EFT_ShareLoan_TypeTranslate__c t:listTT){
                        LoanIdTypeTranslateMap.put(t.Code__c, t.TypeTranslate__c);                        
                    }
                    
                    for(ShareLoanWrapperObject obj: resultList){
                        string typetrans = LoanIdTypeTranslateMap.get(string.valueof(obj.ShareLoanID).substring(0, 2));
                        obj.TypeTranslate = typetrans;
                    }
                }
            }
            
        return resultList;
    }
    
    @AuraEnabled
    public static List<EFT__c> getEFTRecordsEpisys(string recordId){
    		system.debug('recordId=='+recordId);
        	Account_Details__c MemberAccount = [select id,name from Account_Details__c where id=:recordId limit 1];
        	String AccountNumber = MemberAccount.name;
        	
        	
        	httpRequest requestparam = new httpRequest(); 
	        requestparam.setEndpoint('https://symxapi.chevronfcu.org/devclient/EFT/GetEftRecords?accountNumber=' + AccountNumber);
	        requestparam.setMethod('GET');      
	          
	       
	        http httpParam = new http();
	        httpResponse response = httpParam.send(requestparam);
	        
	        String strStatus = response.getStatus();
	        String strBody = response.getBody();
        	
         	System.debug('strStatus ....' + strStatus);
        	System.debug('strBody ....' + strBody);
        
        	set<string> EFTLocatorsSet = new set<string>();
        	set<string> MemberNumbers = new set<string>();
        	//List<EFT__c> EFTList= new List<EFT__c>();
        	if(strBody!=''){        
       			List<Object> results = (List<Object>) JSON.deserializeUntyped(response.getBody());      
         		System.debug('Service response is ....' + results);
                
                 for(Object t : results){
                 	EFTWrapperObject temp = new EFTWrapperObject();
                    map<string, object> localAcc = (map<string, object>)t; 
                    MemberNumbers.add(String.valueOf(localAcc.get('AccountNumber')));  
                 }
                 
                 map<string, string> mapAccountIdName= new map<string, string>();
       				List<account_details__c> MemberAccountsList = [select id, name from account_details__c where name in: MemberNumbers and RecType__c = 'ACCT'];
       				if(MemberAccountsList.size() > 0){
       					for(account_details__c s: MemberAccountsList){
       						mapAccountIdName.put(s.Name, s.Id);
       					}
       				}
                
                 for(Object t : results){
                      		System.debug('T ....' + T);
                   			EFTWrapperObject temp = new EFTWrapperObject();
                       		map<string, object> localAcc = (map<string, object>)t;   
                       		/*EFT__c objEFT = new EFT__c();
                       		objEFT.Routing_Number__c = String.valueOf(localAcc.get('Payee')); 
                       		objEFT.Account_Number__c = String.valueOf(localAcc.get('Reference'));
                       		system.debug('Account_Number__c=='+objEFT.Account_Number__c);
                       		objEFT.Payment_Amount__c = Decimal.valueOf(String.valueOf(localAcc.get('Amount')));
                       		if(String.valueOf(localAcc.get('EffectiveDate')) != '' && String.valueOf(localAcc.get('EffectiveDate')) != null)
                       		objEFT.Effective_Date__c = Date.valueOf(String.valueOf(localAcc.get('EffectiveDate')));
                       		objEFT.Frequency__c = String.valueOf(localAcc.get('Frequency'));
                       		objEFT.Day_of_Month__c = String.valueOf(localAcc.get('Day1'));
                       		objEFT.Bank_Name__c = String.valueOf(localAcc.get('FinancialInstitution'));
                       		objEFT.Share_Loan_Id__c = String.valueOf(localAcc.get('Id'));
                       		objEFT.EftLocator__c = String.valueOf(localAcc.get('EftLocator'));
                       		//objEFT.Member_Account__c = 'a0Of100000GF8xOEAT';
                       		if(String.valueOf(localAcc.get('AmountCode')) == '37')                       		
                       			objEFT.Type__c = 'Savings'; 
                       		else
                       		    objEFT.Type__c = 'Checking';  
                       		if(String.valueOf(localAcc.get('ExpirationDate')) != null && String.valueOf(localAcc.get('ExpirationDate')) != ''){
                       			Date expDate = Date.valueOf(String.valueOf(localAcc.get('ExpirationDate')));
                       			if(expDate <= Date.today())
                       				objEFT.expired__c = true;
                       		}     
                       		//system.debug('EXPDATE=='+String.valueOf(localAcc.get('ExpirationDate'))) ;      		
                       		objEFT.EftLocator__c = String.valueOf(localAcc.get('EftLocator__c'));    
                       		objEFT.Member_Account__r = new account_details__c(id =mapAccountIdName.get(String.valueOf(localAcc.get('AccountNumber'))), Name = String.valueOf(localAcc.get('AccountNumber')));//mapAccountIdName.get(String.valueOf(localAcc.get('AccountNumber')));  
                       		system.debug('Day1=='+objEFT.Frequency__c);
                       		system.debug('Freq=='+objEFT.Day_of_Month__c);
                       		//objEFT.Member_Account__r.Name = String.valueOf(localAcc.get('AccountNumber')); */      		
                       		string locator = String.valueOf(localAcc.get('EftLocator'));                       		
                       		EFTLocatorsSet.add(locator);
                       		//EFTList.add(objEFT);
       				}
       				
       				
       			
            }
            
            //System.debug('EFTLocatorsSet ....' + EFTLocatorsSet);
            List<EFT__c> EFTList = [select id, name,EFT_ID_Type__c, Member_Account__c, Stage__c, Action_Type__c, Share_Loan_Id__c, Type__c	,Share_Loan_Type__c, 	
                                    Share_Loan_Description__c, Routing_Number__c, Bank_Name__c, Account_Number__c, Alternate_Amount__c,Effective_Date__c,
                                      Frequency__c, Payment_Amount__c, Day_of_Month__c, Member_Account__r.name, Case__c, Case__r.CaseNumber, expired__C
                                      from EFT__c where Member_Account__c =: recordId and EftLocator__c in: EFTLocatorsSet];
            
            return EFTList;       
    }
    
    public class ShareLoanWrapperObject
    {
      @AuraEnabled
      public Integer ShareLoanID {get;set;}
      @AuraEnabled
      public string Description {get;set;}
      @AuraEnabled
      public string TypeTranslate {get;set;}
      @AuraEnabled
      public string Type {get;set;}
    }
    
     public class EFTWrapperObject
    {
      @AuraEnabled
      public Integer EftLocator {get;set;}
      @AuraEnabled
      public string AccountNumber {get;set;}
      @AuraEnabled
      public string AmountCode {get;set;}
      @AuraEnabled
      public string Amount {get;set;}
        @AuraEnabled
      public string FinancialInstitution {get;set;}
        @AuraEnabled
      public string Payee {get;set;}
        @AuraEnabled
      public string Reference {get;set;}
        @AuraEnabled
      public string EffectiveDate {get;set;}
         @AuraEnabled
      public string Day1 {get;set;}
         @AuraEnabled
      public string Frequency {get;set;}
         @AuraEnabled
      public string Status {get;set;}
         @AuraEnabled
      public string Error {get;set;}
         @AuraEnabled
      public string ErrorDetails {get;set;}
      @AuraEnabled
      public string ExpirationDate {get;set;}      
      @AuraEnabled
      public string Id {get;set;}
        
    }
    
    

}