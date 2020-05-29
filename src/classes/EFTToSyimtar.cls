public class EFTToSyimtar {
   
    public static String EFTType;
    public static String AmountCode;
    public static String GroupNumber;
    public static String IDType;
    public static String ID;
    public static String Frequency;
    public static String Day1;
    public static String NextDate;
    public static String EffectiveDate;
    public static String PostAmount;
    public static String Payee;
    public static String Reference;
    public static String MatchID3;
    public static String AccountNumber;
    public static String ErrorEFTLocator;
    
    public static String EftLocator;
   
    
    public static String jsonData;  
    public static HttpRequest req = new HttpRequest();
    public static String result;
    public static List<EFT__c> EFTRecordsToUpdate = new List<EFT__c>();
    
    @future(callout=true)
    public static void insertEFTs(Set<id> ids){
    	
    List<EFT__c> EFTlist = new List<EFT__c>();         
    List<EFT__c> EFTs = [SELECT Account_Number__c,Action_Type__c,Alternate_Amount__c,Bank_Name__c,
                         CreatedById,CreatedDate,Day_of_Month__c,DocuSignId__c,Effective_Date__c,
                         Frequency__c,Id,Member_Account__c,Member_Account__r.Brand__c,Member_Account__r.Name,
                         Member__c,Name,
                         OwnerId,Payment_Amount__c,Routing_Number__c,Share_Loan_Id__c,Stage__c,
                         Status__c,Type__c, EFT_ID_Type__c FROM EFT__c where id =: ids];
    
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
               	Frequency = '4';
               	
               	if(e.Effective_Date__c != null){
               		Day1 = '0'; //String.valueof(sl.Due_Date__c.day());
               	}
            	else{
            		Day1 = '0';
            	}	
                if(e.Effective_Date__c != null){
                	
                    NextDate = string.valueof(e.Effective_Date__c + 1);
                	EffectiveDate = string.valueof(e.Effective_Date__c + 1);
                }
            	else{
            		NextDate = null;
            		EffectiveDate = null;
            	}
            	
                if(e.Alternate_Amount__c != null)
                	PostAmount = String.ValueOf(e.Payment_Amount__c);
                else
                	PostAmount = '0.00';
                Payee = e.Routing_Number__c.leftPad(10,'0');
                Reference = e.Account_Number__c ;
                if(e.Bank_Name__c != null){
                	MatchID3 = e.Bank_Name__c;
                	if(MatchID3.length() > 22){
                		MatchID3 = MatchID3.left(21);
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
                
                jsonData = '{"EFTType":' + '\"'+ EFTType +'\"'+',"AmountCode":' + '\"'+ AmountCode +'\"'+',"GroupNumber":'+'\"'+ GroupNumber +'\"'+',"IdType":'+'\"' + IDType + '\"'+',"ID":'+'\"'+ID+'\"'+',"Frequency":'+'\"'+Frequency+'\"'+',"Day1":'+'\"'+Day1+'\"'+',"NextDate":'+'\"'+NextDate+'\"'+',"EffectiveDate":'+'\"'+EffectiveDate+'\"'+',"PostAmount":'+'\"'+PostAmount+'\"'+',"Payee":'+'\"'+Payee+'\"'+',"Reference":'+'\"'+Reference+'\"'+',"MatchId3":'+'\"'+MatchID3+'\"'+',"AccountNumber":'+'\"'+AccountNumber+'\"}';
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
     
	}
    
    
     @future(callout=true)
    public static void UpdateEFT(Set<id> ids, boolean isExpired){
        system.debug('ids'+ids);
        system.debug('isExpired'+isExpired);
        List<EFT__c> EFTlist = new List<EFT__c>();         
    List<EFT__c> EFTs = [SELECT Account_Number__c,Action_Type__c,Alternate_Amount__c,Bank_Name__c,
                         CreatedById,CreatedDate,Day_of_Month__c,DocuSignId__c,Effective_Date__c,
                         Frequency__c,Id,Member_Account__c,Member_Account__r.Brand__c,Member_Account__r.Name, Member__c,Name,
                         OwnerId,Payment_Amount__c,Routing_Number__c,Share_Loan_Id__c,Stage__c,EftLocator__c,
                         Status__c,Type__c, EFT_ID_Type__c FROM EFT__c where id =: ids];
        
        /*if(isExpired){
            
            
        }*/
        //else{
    
    		for(EFT__c e : EFTs){
                
                EftLocator = e.EftLocator__c;
            	EFTType = '3';
                if(e.Type__c == 'Savings')
                	AmountCode = '37' ;
                else
                    AmountCode = '27';               		

              	
                ID = e.Share_Loan_Id__c;
               	Frequency = '4';
               	
               	if(e.Effective_Date__c != null){
               		Day1 = '0'; //String.valueof(sl.Due_Date__c.day());
               	}
            	else{
            		Day1 = '0';
            	}	
                if(e.Effective_Date__c != null){
                	
                    NextDate = string.valueof(e.Effective_Date__c + 1);
                	EffectiveDate = string.valueof(e.Effective_Date__c + 1);
                }
            	else{
            		NextDate = null;
            		EffectiveDate = null;
            	}
            	
                if(e.Alternate_Amount__c != null)
                	PostAmount = String.ValueOf(e.Payment_Amount__c);
                else
                	PostAmount = '0.00';
                Payee = e.Routing_Number__c.leftPad(10,'0');
                Reference = e.Account_Number__c ;
                if(e.Bank_Name__c != null){
                	MatchID3 = e.Bank_Name__c;
                	if(MatchID3.length() > 22){
                		MatchID3 = MatchID3.left(21);
                	}
                }
                system.debug('MatchID3'+MatchID3);    
                AccountNumber = e.Member_Account__r.Name;
                
                //req.setEndpoint('https://brscsymx.ctxcu.org/dev/EFT/CreateEft');
                req.setEndpoint('https://symxapi.chevronfcu.org/devclient/EFT/UpdateEft');
                //req.setClientCertificateName('brscmcapi');
                req.setMethod('POST');
                req.setHeader('Content-Type', 'application/json');
                req.setHeader('Accept', 'application/json');
                
               
                jsonData = '{"EftLocator":' + '\"'+ EftLocator +'\"'+',"AmountCode":' + '\"'+ AmountCode +'\"' +',"Frequency":'+'\"'+Frequency+'\"'+',"Day1":'+'\"'+Day1+'\"'+',"EffectiveDate":'+'\"'+EffectiveDate+'\"'+',"PostAmount":'+'\"'+PostAmount+'\"'+',"Payee":'+'\"'+Payee+'\"'+',"Reference":'+'\"'+Reference+'\"'+',"MatchId3":'+'\"'+MatchID3+'\"'+',"IsUpdateExpirationDate":'+'\"'+isExpired+'\"' +',"AccountNumber":'+'\"'+AccountNumber+'\"}';
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
        
        
    }
}