public class EFTToSyimtar {
   
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
    
    public static String EftLocator;
   
    
    public static String jsonData;  
	public static String jsonData1;
	public static String UpdatejsonData;
    public static HttpRequest req = new HttpRequest();
	public static HttpRequest req1 = new HttpRequest();
	public static HttpRequest Updatereq = new HttpRequest();
    public static String result;
    public static List<EFT__c> EFTRecordsToUpdate = new List<EFT__c>();
   
    
    @future(callout=true)
    public static void insertEFTs(Set<id> ids){
    	
    List<EFT__c> EFTlist = new List<EFT__c>();         
    List<EFT__c> EFTs = [SELECT Account_Number__c,Action_Type__c,Alternate_Amount__c,Bank_Name__c,
                         CreatedById,CreatedDate,Day_of_Month__c,Second_Day_of_Month__c,DocuSignId__c,Effective_Date__c,
                         Frequency__c,Id,Member_Account__c,Member_Account__r.Brand__c,Member_Account__r.Name,Case__c, Case__r.Description,
                         Member__c,Name,
                         OwnerId,Payment_Amount__c,Routing_Number__c,Share_Loan_Id__c,Stage__c,
                         Status__c,Type__c, EFT_ID_Type__c,LoanCode__c,EFT_Payment_Date__c FROM EFT__c where id =: ids];
     map<Id, String> CaseIdsToUpdate = new Map<Id, String>();
     
    		for(EFT__c e : EFTs){
                
            	EFTType = '3';
                if(e.Type__c == 'Savings')
                	AmountCode = '37' ;
                else
                    AmountCode = '27';
               		
               	if(e.Member_Account__r.Brand__c == 'Spectrum')
                	GroupNumber = '000006' ;
               	else if(e.Member_Account__r.Brand__c == 'Chevron')
               		GroupNumber = '000001';
               	else
                    GroupNumber = ' '; 
               
              	if(e.EFT_ID_Type__c == 'Share')
              		IDType = '0';
              	else if(e.EFT_ID_Type__c == 'Loan')
              		IDType = '1';
                ID = e.Share_Loan_Id__c;
                
                if(e.Frequency__c != null){
                	if(e.Frequency__c == 'Monthly'){
                		Frequency='4';
                	}
               		else if(e.Frequency__c == 'Semi-Monthly'){
                		Frequency='5';
                	}
               	}
            	else{
            		Frequency = '0';
            	}           	
            	//Frequency = '4';
                
                if(e.Effective_Date__c != null){
               		Day1 = '0';//String.ValueOf(e.Day_of_Month__c);
               	}
            	else{
            		Day1 = '0';
            	}
            	
            	if(e.Second_Day_of_Month__c != null){
               		Day2 = '0';//String.ValueOf(e.Second_Day_of_Month__c);
               	}
            	else{
            		Day2 = '0';
            	}
               
                if(e.Effective_Date__c != null){
                	
                    //NextDate = string.valueof(e.Effective_Date__c + 1);
                	EffectiveDate = string.valueof(e.Effective_Date__c);
                }
            	else{
            		//NextDate = null;
            		EffectiveDate = null;
				}
				
				if(e.EFT_Payment_Date__c != null){                	
                    NextDate = string.valueof(e.EFT_Payment_Date__c);                	
                }
            	else{
            		NextDate = null;            		
				}
				
				
				
				system.debug('e.Alternate_Amount__c'+e.Alternate_Amount__c);   
                if(e.Alternate_Amount__c != null)
                	PostAmount = String.ValueOf(e.Alternate_Amount__c);
                else
                	PostAmount = '0.00';
				system.debug('PostAmount'+PostAmount);   
				
                if(e.Alternate_Amount__c != null && e.Alternate_Amount__c != 0.0){
                	AlternatePayment = String.ValueOf(e.Alternate_Amount__c + e.Payment_Amount__c);
				}
				else{
					AlternatePayment = String.ValueOf(e.Payment_Amount__c);
				}
				
				if(ID != null && ID.SubString(0,2) == '28'){
					PostAmount = AlternatePayment;					
				}
				else{
					PostAmount = '0.00';
				}
                
                Payee = e.Routing_Number__c.leftPad(10,'0');
				Reference = e.Account_Number__c ;
				if(e.LoanCode__c != null){
					LoanCode = e.LoanCode__c;
				}
				else{
					LoanCode = getLoanCode(AccountNumber,ID);
				}
                if(e.Bank_Name__c != null){
                        MatchID3 = e.Bank_Name__c.toUpperCase().replace('&', '&#38;');
                	if(MatchID3.length() > 22){
                		MatchID3 = MatchID3.left(21).toUpperCase().replace('&', '&#38;');
                	}
                }
                system.debug('MatchID3'+MatchID3);    
                AccountNumber = e.Member_Account__r.Name;
                
                //req.setEndpoint('https://brscsymx.ctxcu.org/dev/EFT/CreateEft');
                req.setEndpoint('https://symxapi.chevronfcu.org/devclient/EFT/CreateEft');
                req.setClientCertificateName('brscmcapi');
                req.setMethod('POST');
                req.setHeader('Content-Type', 'application/json');
                req.setHeader('Accept', 'application/json');
                
                jsonData = '{"EFTType":' + '\"'+ EFTType +'\"'+',"AmountCode":' + '\"'+ AmountCode +'\"'+',"GroupNumber":'+'\"'+ GroupNumber +'\"'+',"IdType":'+'\"' + IDType + '\"'+',"ID":'+'\"'+ID+'\"'+',"Frequency":'+'\"'+Frequency+'\"'+',"Day1":'+'\"'+Day1+'\"'+',"Day2":'+'\"'+Day2+'\"'+',"NextDate":'+'\"'+NextDate+'\"'+',"EffectiveDate":'+'\"'+EffectiveDate+'\"'+',"PostAmount":'+'\"'+PostAmount+'\"'+',"Payee":'+'\"'+Payee+'\"'+',"Reference":'+'\"'+Reference+'\"'+',"MatchId3":'+'\"'+MatchID3+'\"'+',"AccountNumber":'+'\"'+AccountNumber+'\"}';
                //jsonData = '{"EFTType": 3,"AmountCode": 27,"GroupNumber": "000001","IdType": 0, "ID": "0100", "Frequency": 4,"Day1": 0,"NextDate": "2019-01-08","EffectiveDate": "2019-01-09","PostAmount": "100.00", "Payee": "0322271627","Reference": "42006986568","MatchId3": "BANK OF AMERICA, N.A.","AccountNumber": "123"}';
                req.setBodyAsBlob(Blob.valueof(jsondata)); 
                system.debug('test'+jsonData);
                
                Http http = new Http();  
                req.setTimeout(60000);
                HttpResponse res;
                String responseBody;
                if(!Test.isRunningTest()){                       
                    res = http.send(req);
                    responseBody = res.getBody();
                    System.debug('Response Body::'+res.getBody());    
                }else{
                    responseBody = '{"EFTType":"3","AmountCode":"27","GroupNumber":"1","IdType":"1","ID":"100","Frequency":"4","Day1":"1","NextDate":"01-01-2019","EffectiveDate":"01-01-2019","PostAmount":"100.00","Payee":"322271627","Reference":"42006986568","MatchId3":"BANK OF AMERICA","AccountNumber":"123"}';
                }
                
                String result;
    
        		// JSon parse for Id                            
        		result = String.valueOf(responseBody).substringAfter('EftLocator":"');
		    	result = String.valueOf(result).substringBefore('",');
		    	System.debug('EFTLocator' + result);
		    	
		    	if(result == null || result == ''){
	            		
	        		ErrorEFTLocator = String.valueOf(responseBody).substringAfter('[MessageId=TESTING] ');
	        		ErrorEFTLocator = String.valueOf(ErrorEFTLocator).substringBefore('","ErrorDetails"');
	        		system.debug('ErrorEFTLocator' + ErrorEFTLocator);
				}

				/*-----------------------SI11042-5: Update Day1 Field----------------------------------*/
				String updateresult;
                string updateresultEFTLocator;       		
				
				if(result != null && result != ''){

					if(e.Day_of_Month__c != null){
						UpdateDay1 = String.ValueOf(e.Day_of_Month__c);
					}
					else{
						UpdateDay1 = '0';
					}

					if(ID != null && ID.SubString(0,2) == '28'){
						UpdateDay1 = '1';						
					}
					boolean isExpired = false;
					Updatereq.setEndpoint('https://symxapi.chevronfcu.org/devclient/EFT/UpdateEft');
					//req.setClientCertificateName('brscmcapi');
					Updatereq.setMethod('POST');
					Updatereq.setHeader('Content-Type', 'application/json');
					Updatereq.setHeader('Accept', 'application/json');
					
				   
					UpdatejsonData = '{"EftLocator":' + '\"'+ result +'\"'+',"AmountCode":' + '\"'+ AmountCode +'\"' +',"Frequency":'+'\"'+Frequency+'\"'+',"Day1":'+'\"'+UpdateDay1+'\"'+',"Day2":'+'\"'+Day2+'\"'+',"EffectiveDate":'+'\"'+EffectiveDate+'\"'+',"PostAmount":'+'\"'+PostAmount+'\"'+',"Payee":'+'\"'+Payee+'\"'+',"Reference":'+'\"'+Reference+'\"'+',"MatchId3":'+'\"'+MatchID3+'\"'+',"IsUpdateExpirationDate":'+'\"'+isExpired+'\"' +',"AccountNumber":'+'\"'+AccountNumber+'\"}';
					//jsonData = '{"EFTType": 3,"AmountCode": 27,"GroupNumber": "000001","IdType": 0, "ID": "0100", "Frequency": 4,"Day1": 0,"NextDate": "2019-01-08","EffectiveDate": "2019-01-09","PostAmount": "100.00", "Payee": "0322271627","Reference": "42006986568","MatchId3": "BANK OF AMERICA, N.A.","AccountNumber": "123"}';
					Updatereq.setBodyAsBlob(Blob.valueof(UpdatejsonData)); 
					system.debug('UpdatejsonData'+UpdatejsonData);
					
					Http updatehttp = new Http();  
					Updatereq.setTimeout(60000);
					HttpResponse Updateres;
					String updateresponseBody;
					if(!Test.isRunningTest()){                       
						Updateres = updatehttp.send(Updatereq);
						updateresponseBody = Updatereq.getBody();
						System.debug('Response Body::'+Updateres.getBody());    
					}else{
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
	        	
	        	if(result != null && result != ''){
                	
					PaymentMethod = '5';
					if(LoanCode == '2'){
						System.debug('LoanCode');
						req1.setEndpoint('https://symxapi.chevronfcu.org/devclient/EFT/UpdateLOCLoanbyId');
						if(AlternatePayment != ''){
							jsonData1 = '{"AccountNumber":'+'\"'+AccountNumber+'\","LoanId":' + '\"'+ ID +'\"'+',"PaymentMethod":'+'\"'+PaymentMethod+ '\"' +',"Payment":'+'\"'+e.Payment_Amount__c+ '\"' +',"AlternatePayment":'+'\"'+e.Alternate_Amount__c+'\"}';
						}
						else{
							jsonData1 = '{"AccountNumber":'+'\"'+AccountNumber+'\","LoanId":' + '\"'+ ID +'\"'+',"PaymentMethod":'+'\"'+PaymentMethod +',"Payment":'+'\"'+e.Payment_Amount__c+ '\"' + '\"}';
						}
					}	
					else if(ID != null && ID.SubString(0,2) == '28'){
						System.debug('Sweep Account');
						string uc3;
						uc3 = getUserChar3(AccountNumber,ID);
						System.debug('uc3=='+uc3);
						req1.setEndpoint('https://symxapi.chevronfcu.org/devclient/PSAuto/UpdateTracking32Records');
						jsonData1 = '{"AccountNumber":'+'\"'+AccountNumber+'\","ShareId":' + '\"'+ ID +'\"'+',"UserChar3":'+'\"'+uc3+ '\"' +',"TotalPaymentAmount":'+'\"'+e.Payment_Amount__c+ '\"' +',"AdditionalPaymentAmount":'+'\"'+e.Alternate_Amount__c+ '\"' +',"NextPaymentDueDate":' + '\"'+ EffectiveDate +'\"}';
					}					
					else{
						System.debug('LoanCode not 2');
						req1.setEndpoint('https://symxapi.chevronfcu.org/devclient/EFT/UpdateLoanById');
						if(AlternatePayment != ''){
							jsonData1 = '{"AccountNumber":'+'\"'+AccountNumber+'\","LoanId":' + '\"'+ ID +'\"'+',"PaymentMethod":'+'\"'+PaymentMethod+ '\"'+',"AlternatePayment":'+'\"'+AlternatePayment+'\"}';
						}
						else{
							jsonData1 = '{"AccountNumber":'+'\"'+AccountNumber+'\","LoanId":' + '\"'+ ID +'\"'+',"PaymentMethod":'+'\"'+PaymentMethod+ '\"}';
						}
					}						
					//system.System.debug(jsonData1);
	                req1.setClientCertificateName('brscmcapi');
	                req1.setMethod('POST');
	                req1.setHeader('Content-Type', 'application/json');
	                req1.setHeader('Accept', 'application/json');
	                
	                
	                
	                req1.setBodyAsBlob(Blob.valueof(jsondata1)); 
	                system.debug('test'+jsonData1);
	                
	                Http http1 = new Http();  
	                req1.setTimeout(60000);
	                HttpResponse res1;
	                String responseBody1;
	                if(!Test.isRunningTest()){                       
	                    res1 = http1.send(req1);
	                    responseBody1 = res1.getBody();
	                    System.debug('Response Body ACH::'+res1.getBody());    
	                }else{
	                    responseBody1 = '{"Type":"3","Branch":"27","CreatedAtBranch":"1","PurposeCode":"1","CollateralCode":"100","ApprovalCode":"4","OriginalBalance":"1","ApprovalDate":"01-01-2019","MaturityDate":"01-01-2019","DueDate":"01-01-2019","FirstPaymentDate":"01-01-2019","DueDay1":"1","Payment":"1234","CouponCode":"123", "PaymentMethod" : "PaymentMethod", "Description" : "Description", "InterestRate" : "2.00", "UserAmount1" : "200.00", "ECOACode" : "778", "CreditScore" : "15", "PaymentCount" : "12", "PaymentFrequency" : "67"}';
	                }
	                
	                
	                string casedesc = e.Case__r.Description + '\n \n ACH DocuSign Values \n Type: ' + e.Type__c 
	                					+ '\n' + 'Funding FI: ' + e.Bank_Name__c 
	                					+ '\n' + 'ABA/Routing#: ' + e.Routing_Number__c
	                					+ '\n' + 'Account Number: '+ e.Account_Number__c
										+ '\n' + 'Additional Payment Amount: ' + e.Alternate_Amount__c
										+ '\n' + '\n' +'EFT Locator: ' + result;
	                CaseIdsToUpdate.put(e.Case__c, casedesc);
                }
		    	
            	//EFT__c s = new EFT__c();         
                
                if(result != null && result != '')
                	e.EftLocator__c = result;
                
                if(ErrorEFTLocator != null && ErrorEFTLocator != '')
                	e.Error_EftLocator__c = ErrorEFTLocator;
                else
                	e.Error_EftLocator__c = '';	
               // s.id = sl.Id;                      
                EFTRecordsToUpdate.add(e);  
            	
                
            }
            update EFTRecordsToUpdate;
     		
     		if(CaseIdsToUpdate.size() > 0){  
		        List<Case> UpdateCasesList = [select id, status from case where id in: CaseIdsToUpdate.keySet()];
		        for(Case cs: UpdateCasesList){
		         	 cs.Description = CaseIdsToUpdate.get(cs.id);
		        }
		            update UpdateCasesList;
		    }
	}
    
    
     @future(callout=true)
    public static void UpdateEFT(Set<id> ids, boolean isExpired){
		system.debug('ids'+ids);
		system.debug('isExpired'+isExpired);
		List<EFT__c> EFTlist = new List<EFT__c>();         
		List<EFT__c> EFTs = [SELECT Account_Number__c,Action_Type__c,Alternate_Amount__c,Bank_Name__c,
							CreatedById,CreatedDate,Day_of_Month__c,Second_Day_of_Month__c,DocuSignId__c,Effective_Date__c,
							Frequency__c,Id,Member_Account__c,Member_Account__r.Brand__c,Member_Account__r.Name, Member__c,Name,Case__c, Case__r.Description,
							OwnerId,Payment_Amount__c,Routing_Number__c,Share_Loan_Id__c,Stage__c,EftLocator__c,Share_Loan_Description__c,Share_Loan_Type__c,Member_Name__c,
							Status__c,Type__c, EFT_ID_Type__c,LoanCode__c,EFT_Payment_Date__c FROM EFT__c where id =: ids];
        
        map<Id, String> CaseIdsToUpdate = new Map<Id, String>();
        //else{
    
    		for(EFT__c e : EFTs){
                
                EftLocator = e.EftLocator__c;
            	EFTType = '3';
                if(e.Type__c == 'Savings')
                	AmountCode = '37' ;
                else
                    AmountCode = '27';               		

              	
                ID = e.Share_Loan_Id__c;
               	 if(e.Frequency__c != null){
                	if(e.Frequency__c == 'Monthly'){
                		Frequency='4';
                	}
               		else if(e.Frequency__c == 'Semi-Monthly'){
                		Frequency='5';
                	}
               	}
            	else{
            		Frequency = '0';
            	}           	
            	//Frequency = '4';
                
                if(e.Day_of_Month__c != null){
               		Day1 = String.ValueOf(e.Day_of_Month__c);
               	}
            	else{
            		Day1 = '0';
            	}
            	
            	if(e.Second_Day_of_Month__c != null){
               		Day2 = '0';//String.ValueOf(e.Second_Day_of_Month__c);
               	}
            	else{
            		Day2 = '0';
            	}	
                if(e.Effective_Date__c != null){
                	
                    //NextDate = string.valueof(e.Effective_Date__c + 1);
                	EffectiveDate = string.valueof(e.Effective_Date__c);
                }
            	else{
            		//NextDate = null;
            		EffectiveDate = null;
				}
				
				if(e.EFT_Payment_Date__c != null){                	
                    NextDate = string.valueof(e.EFT_Payment_Date__c);                	
                }
            	else{
            		NextDate = null;            		
				}
				
            	
                if(e.Alternate_Amount__c != null)
                	PostAmount = String.ValueOf(e.Alternate_Amount__c);
                else
                	PostAmount = '0.00';
                	
                if(e.Alternate_Amount__c != null && e.Alternate_Amount__c != 0.0){
                	AlternatePayment = String.ValueOf(e.Alternate_Amount__c + e.Payment_Amount__c);
				}
				
				if(ID != null && ID.SubString(0,2) == '28'){
					PostAmount = AlternatePayment;
					Day1 = '1';
				}
				
				else{
					PostAmount = '0.00';
				}
				
                Payee = e.Routing_Number__c.leftPad(10,'0');
				Reference = e.Account_Number__c ;
				//LoanCode = e.LoanCode__c;
				if(e.LoanCode__c != null){
					LoanCode = e.LoanCode__c;
				}
				else{
					LoanCode = getLoanCode(AccountNumber,ID);
				}
                if(e.Bank_Name__c != null){
                	MatchID3 = e.Bank_Name__c.toUpperCase().replace('&', '&#38;');
                	if(MatchID3.length() > 22){
                		MatchID3 = MatchID3.left(21).toUpperCase().replace('&', '&#38;');
                	}
                }
                system.debug('Reference'+Reference);    
                AccountNumber = e.Member_Account__r.Name;
                
                //req.setEndpoint('https://brscsymx.ctxcu.org/dev/EFT/CreateEft');
                req.setEndpoint('https://symxapi.chevronfcu.org/devclient/EFT/UpdateEft');
                //req.setClientCertificateName('brscmcapi');
                req.setMethod('POST');
                req.setHeader('Content-Type', 'application/json');
                req.setHeader('Accept', 'application/json');
                
               
                jsonData = '{"EftLocator":' + '\"'+ EftLocator +'\"'+',"AmountCode":' + '\"'+ AmountCode +'\"' +',"Frequency":'+'\"'+Frequency+'\"'+',"Day1":'+'\"'+Day1+'\"'+',"Day2":'+'\"'+Day2+'\"'+',"EffectiveDate":'+'\"'+EffectiveDate+'\"'+',"PostAmount":'+'\"'+PostAmount+'\"'+',"Payee":'+'\"'+Payee+'\"'+',"Reference":'+'\"'+Reference+'\"'+',"MatchId3":'+'\"'+MatchID3+'\"'+',"IsUpdateExpirationDate":'+'\"'+isExpired+'\"' +',"AccountNumber":'+'\"'+AccountNumber+'\"}';
                //jsonData = '{"EFTType": 3,"AmountCode": 27,"GroupNumber": "000001","IdType": 0, "ID": "0100", "Frequency": 4,"Day1": 0,"NextDate": "2019-01-08","EffectiveDate": "2019-01-09","PostAmount": "100.00", "Payee": "0322271627","Reference": "42006986568","MatchId3": "BANK OF AMERICA, N.A.","AccountNumber": "123"}';
                req.setBodyAsBlob(Blob.valueof(jsondata)); 
                system.debug('test'+jsonData);
                
                Http http = new Http();  
                req.setTimeout(60000);
                HttpResponse res;
                String responseBody;
                if(!Test.isRunningTest()){                       
                    res = http.send(req);
                    responseBody = res.getBody();
                    System.debug('Response Body::'+res.getBody());    
                }else{
                    responseBody = '{"EFTType":"3","AmountCode":"27","GroupNumber":"1","IdType":"1","ID":"100","Frequency":"4","Day1":"1","NextDate":"01-01-2019","EffectiveDate":"01-01-2019","PostAmount":"100.00","Payee":"322271627","Reference":"42006986568","MatchId3":"BANK OF AMERICA","AccountNumber":"123"}';
                }
                
                String result;
                string resultEFTLocator, resultExpDate;
    
        		// JSon parse for Id                            
        		result = String.valueOf(responseBody).substringAfter('Status":"');
		    	result = String.valueOf(result).substringBefore('",');
		    	System.debug('Status' + result);
		    	
		    	resultEFTLocator = String.valueOf(responseBody).substringAfter('EftLoctorId":"');
		    	resultEFTLocator = String.valueOf(resultEFTLocator).substringBefore('",');
		    	System.debug('EFTLocator' + resultEFTLocator);
		    	
		    	resultExpDate = String.valueOf(responseBody).substringAfter('ExpirationDate":"');
		    	resultExpDate = String.valueOf(resultExpDate).substringBefore('",');
		    	System.debug('resultExpDate' + resultExpDate);
		    	
		    	if(result != 'OK'){
	            		
	        		ErrorEFTLocator = String.valueOf(responseBody).substringAfter('[MessageId=TESTING] ');
	        		ErrorEFTLocator = String.valueOf(ErrorEFTLocator).substringBefore('","ErrorDetails"');
	        		system.debug('ErrorEFTLocator' + ErrorEFTLocator);
	        	}
	        	
	        	else if(result == 'OK'){
					PaymentMethod = '5';
					if(LoanCode == '2'){
						System.debug('LoanCode');
						req1.setEndpoint('https://symxapi.chevronfcu.org/devclient/EFT/UpdateLOCLoanbyId');
						if(AlternatePayment != ''){
							jsonData1 = '{"AccountNumber":'+'\"'+AccountNumber+'\","LoanId":' + '\"'+ ID +'\"'+',"PaymentMethod":'+'\"'+PaymentMethod+ '\"' +',"Payment":'+'\"'+e.Payment_Amount__c+ '\"' +',"AlternatePayment":'+'\"'+e.Alternate_Amount__c+'\"}';
						}
						else{
							jsonData1 = '{"AccountNumber":'+'\"'+AccountNumber+'\","LoanId":' + '\"'+ ID +'\"'+',"PaymentMethod":'+'\"'+PaymentMethod+ '\"'  +',"Payment":'+'\"'+e.Payment_Amount__c+ '\"}';
						}
					}
					else if(ID != null && ID.SubString(0,2) == '28'){
						System.debug('Sweep Account');
						string uc3;
						uc3 = getUserChar3(AccountNumber,ID);
						System.debug('uc3=='+uc3);
						req1.setEndpoint('https://symxapi.chevronfcu.org/devclient/PSAuto/UpdateTracking32Records');
						jsonData1 = '{"AccountNumber":'+'\"'+AccountNumber+'\","ShareId":' + '\"'+ ID +'\"'+',"UserChar3":'+'\"'+uc3+ '\"' +',"TotalPaymentAmount":'+'\"'+e.Payment_Amount__c+ '\"' +',"AdditionalPaymentAmount":'+'\"'+e.Alternate_Amount__c +'\"'+ ',"NextPaymentDueDate":' + '\"'+ EffectiveDate +'\"}';
						//System.debug('jsonData1=='+jsonData1);
					}					
					else{
						System.debug('LoanCode not 2');
						req1.setEndpoint('https://symxapi.chevronfcu.org/devclient/EFT/UpdateLoanById');
						if(AlternatePayment != ''){
							jsonData1 = '{"AccountNumber":'+'\"'+AccountNumber+'\","LoanId":' + '\"'+ ID +'\"' +',"AlternatePayment":'+'\"'+AlternatePayment+'\"}';
						}
						else{
							jsonData1 = '{"AccountNumber":'+'\"'+AccountNumber+'\","LoanId":' + '\"'+ ID +'\"'+',"PaymentMethod":'+'\"'+PaymentMethod+ '\"}';
						}
					}
	        		
	        		system.debug('jsonData1'+jsonData1);
                	//req1.setEndpoint('https://symxapi.chevronfcu.org/devclient/EFT/UpdateLoanById');
	                req1.setClientCertificateName('brscmcapi');
	                req1.setMethod('POST');
	                req1.setHeader('Content-Type', 'application/json');
	                req1.setHeader('Accept', 'application/json');
	                
	                if(AlternatePayment != '' && !isExpired){
	                	
	                	req1.setBodyAsBlob(Blob.valueof(jsondata1)); 
		                system.debug('test'+jsonData1);
		                
		                Http http1 = new Http();  
		                req1.setTimeout(60000);
		                HttpResponse res1;
		                String responseBody1;
		                if(!Test.isRunningTest()){                       
		                    res1 = http1.send(req1);
		                    responseBody1 = res1.getBody();
		                    System.debug('Response Body ACH::'+res1.getBody());    
		                }else{
		                    responseBody1 = '{"Type":"3","Branch":"27","CreatedAtBranch":"1","PurposeCode":"1","CollateralCode":"100","ApprovalCode":"4","OriginalBalance":"1","ApprovalDate":"01-01-2019","MaturityDate":"01-01-2019","DueDate":"01-01-2019","FirstPaymentDate":"01-01-2019","DueDay1":"1","Payment":"1234","CouponCode":"123", "PaymentMethod" : "PaymentMethod", "Description" : "Description", "InterestRate" : "2.00", "UserAmount1" : "200.00", "ECOACode" : "778", "CreditScore" : "15", "PaymentCount" : "12", "PaymentFrequency" : "67"}';
		                }
	                }
	               
	                
	               
	        		if(isExpired){
                        system.debug('e.Member_Name__c==='+e.Member_Name__c);
	        			e.Expiration_Date__c = Date.valueOf(resultExpDate);
	        			 Datetime dt = datetime.newInstance(Date.valueOf(resultExpDate).year(), Date.valueOf(resultExpDate).month(),Date.valueOf(resultExpDate).day());
	        			string operation = 'ACH Record Expired' + '\n' + 'Expiration Date:' + dt.format('MM/dd/yyyy') + '\n' ;
	        			operation = operation + 'Member Name:' + e.Member_Name__c 
        							+ '\n' + 'Share/Loan:' + e.Share_Loan_Id__c 
                                    + '\n' + 'ABA/Routing#:' + e.Routing_Number__c 
                                     + '\n' +'Funding FI:' + e.Bank_Name__c
                                     + '\n' +'Account Number:' + e.Account_Number__c
                                     + '\n' +'Type:' + e.Type__c
                                     + '\n' +'Payment Amount:' + e.Payment_Amount__c	
                                     + '\n' +'Additional Payment Amount:' + (e.Alternate_Amount__c == null ? 0 :e.Alternate_Amount__c)				 
                                     + '\n' +'Effective Date:' + e.Effective_Date__c
                                     + '\n' +'Frequency:' + e.Frequency__c
									 + '\n' +'Day of Month:' + e.Day_of_Month__c
									 + '\n' +'\n' + 'EFT Locator: ' + EftLocator;
	        			CaseIdsToUpdate.put(e.Case__c, operation);
	        		}
	        		else{
	        			string casedesc = e.Case__r.Description + '\n \n ACH DocuSign Values \n Type: ' + e.Type__c 
	                					+ '\n' + 'Funding FI: ' + e.Bank_Name__c 
	                					+ '\n' + 'ABA/Routing#: ' + e.Routing_Number__c
	                					+ '\n' + 'Account Number: '+ e.Account_Number__c
										+ '\n' + 'Additional Payment Amount: ' + e.Alternate_Amount__c
										+ '\n' +'\n' + 'EFT Locator: ' + EftLocator;
	                	CaseIdsToUpdate.put(e.Case__c, casedesc);
	        		
					}
					if(resultEFTLocator != '' && resultEFTLocator != null && EftLocator != resultEFTLocator){
	        			e.expired__c = true;
	        			e.Expiration_Date__c = Date.valueOf(resultExpDate);
	        			//e.EftLocator__c = resultEFTLocator;
	        			
	        			//EFT__c newEFT = new EFT__c();
	        			EFT__c newEFT = e.clone(false);
	        			newEFT.expired__c = false;
	        			newEFT.Expiration_Date__c = null;
	        			newEFT.EftLocator__c = resultEFTLocator;
	        			newEFT.Share_Loan_Description__c = e.Share_Loan_Description__c;
	        			newEFT.Share_Loan_Type__c = e.Share_Loan_Type__c;
						newEFT.Case__c = e.Case__c;
						//newEFT.Update_Docusign_Status__c = e.Update_Docusign_Status__c;
						//newEFT.Update_DocuSignId__c = e.Update_DocuSignId__c;
						insert newEFT;
	        		}
	        	}     
	        	
	        	         
               
            	//EFT__c s = new EFT__c();         
                
               
                if(ErrorEFTLocator != null && ErrorEFTLocator != '')
                	e.Error_EftLocator__c = ErrorEFTLocator;
                else
                	e.Error_EftLocator__c = '';	
               // s.id = sl.Id;    
                 
                               
                EFTRecordsToUpdate.add(e);  
            	
                
            }
        //}
            update EFTRecordsToUpdate;
            
             if(CaseIdsToUpdate.size() > 0){  
		        List<Case> UpdateCasesList = [select id, status from case where id in: CaseIdsToUpdate.keySet()];
		        for(Case cs: UpdateCasesList){
		         	 cs.Description = CaseIdsToUpdate.get(cs.id);
		        }
		            update UpdateCasesList;
		    }
            
        
        	
        
	}
	
	public static string getLoanCode(string AccountNumber, string LoanID){
		string LoanCode;
		Map<string,List<EFTController.ShareLoanWrapperObject>> LoanMap = EFTController.getLoanAccounts(AccountNumber);
		List<EFTController.ShareLoanWrapperObject> LoanList = LoanMap.get('LoanList');
		if(LoanList != null){
				for(EFTController.ShareLoanWrapperObject sl: LoanList){
					if(sl.ShareLoanID == LoanID){
						LoanCode = sl.LoanCode;
					}
				}		
		}
		return LoanCode;
	}

	public static string getUserChar3(string AccountNumber, string ShareID){
		string userchar3;
		httpRequest requestparam = new httpRequest(); 
        //requestparam.setTimeout(10); 
	    requestparam.setEndpoint('https://symxapi.chevronfcu.org/devclient/PSAuto/GetSharesEFT?AccountNumber=' + AccountNumber + '&userchar2=abc');
		requestparam.setMethod('GET'); 
		
		try { 
	        http httpParam = new http();
	        httpResponse response = httpParam.send(requestparam);
	        
	        String strStatus = response.getStatus();
	        String strBody = response.getBody();
        	
         	System.debug('strStatus ....' + strStatus);
			System.debug('strBody ....' + strBody);

			if(strBody!=''){        
			  List<Object> results = (List<Object>) JSON.deserializeUntyped(response.getBody());      
			  System.debug('Service response is ....' + results);
			 
			if(results != null){ 
			  for(Object t : results){							
						map<string, object> localAcc = (map<string, object>)t;                       		
						string accouttype = (string)localAcc.get('AccountType');                       		
						string ShareId1 =  accouttype.split(' ')[1].replace('#','');
						
						if(ShareId1 != '0' && ShareId1 == ShareID){//&& ShareId == 2800
							userchar3 = (string)localAcc.get('UserChar3');
						}
					}
				}			
			 }
		}
		catch(System.CalloutException e){
			system.debug('Exception');
			
		}
		return userchar3;
	}

	
}