public class EFTController {
    
    @AuraEnabled
    public static map<string,object> getStageData(string recordId, string sObjectType){
        map<string,object> resultMap = new map<string,object>();
        
        List<EFT_Stages__c> EFTStages = new List<EFT_Stages__c>();
        EFTStages = [SELECT id, name, isActive__c, Order__c, Stage_Action__c,Stage_Action_Placeholder__c, Stage_Component__c, Stage_Label__c, StepId__c from EFT_Stages__c where isActive__c = true]; //where isActive__c = true;      //EFT_Stages__c.getall().values();
        resultMap.put('EFTStages', EFTStages);
        system.debug('sObjectType=='+sObjectType);
        //if(sObjectType == 'Account_Details__c'){
            List<EFT__c> EFTRecord = [Select id, name, Member_Account__c, Stage__c, Action_Type__c from EFT__c where Member_Account__c =:recordId limit 1];
            integer activeStageIndex = 0;
            if(EFTRecord.size() >0){               
                for(EFT_Stages__c eftstage:EFTStages){
                    if(EFTRecord[0].Stage__c == eftstage.Stage_Label__c){
                    	activeStageIndex = (integer)eftstage.Order__c;
                	}
                }
                for(EFT_Stages__c eftstage:EFTStages){
                    if(eftstage.Order__c < activeStageIndex){
                        string dynamiclabel = eftstage.Stage_Action_Placeholder__c.replace('{{Action}}',EFTRecord[0].Action_Type__c);
                		eftstage.Stage_Action__c = dynamiclabel;
                    }
                }
                
                resultMap.put('EFT', EFTRecord);
                
            }
            Account_Details__c MemberAccount = [select id,name from Account_Details__c where id=:recordId limit 1];
            resultMap.put('MemberAccount', MemberAccount);
        //}
       // if(activeStageIndex == 2){
       //     getShareAccounts(MemberAccount.name);            
        //}
        return resultMap;
    }
    
    
    @AuraEnabled
    public static void saveStageData(EFT__c EFTRecord){
        system.debug('EFTRecord=='+EFTRecord.Id	);
        if(EFTRecord.id == '' || EFTRecord.id == null){
            insert EFTRecord;
        }
    }
    
    @AuraEnabled
    public static string routingInfo(String RoutingNumber){
      
    	String jsonData;  
    	HttpRequest req = new HttpRequest();
    	String BankName;
    	String RoutingNum = '122105155';
    	
    	req.setEndpoint('https://www.routingnumbers.info/api/data.json?rn='+RoutingNum);
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
                
		BankName = String.valueOf(responseBody).substringAfter('customer_name": "');
		BankName = String.valueOf(BankName).substringBefore('",');
		System.debug('Bank Name:' + BankName);
           	                
        return BankName; 
    }
    
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
                
                //List<wrapperAccountBalance> resultList = List<wrapperAccountBalance>results;
                 for(Object t : results){
                   			ShareLoanWrapperObject temp = new ShareLoanWrapperObject();
                       		map<string, object> localAcc = (map<string, object>)t;
                       		/*string LoanId = (string)localAcc.get('LoanId');
       						System.debug('Service response is ....' + localAcc);
	                       if(LoanId != '0'){
	                               temp.ShareLoanID =  LoanId; 
	                               temp.Description =   (string)localAcc.get('Description');  
	                               temp.TypeTranslate =  (string)localAcc.get('Description'); 
	                               resultList.add(temp);  
	                       }*/
       				}
            }
            
            List<ShareLoanWrapperObject> LoanList = getLoanAccounts(AccountNumber);
            resultList.addall(LoanList);
            system.debug('resultList=='+resultList);
            return resultList;
       // return '$ '+	AvailableBalance;
    }
    
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
                
                //List<wrapperAccountBalance> resultList = List<wrapperAccountBalance>results;
                if(results.size() > 0){
                	
                   for(Object t : results){
                   			ShareLoanWrapperObject temp = new ShareLoanWrapperObject();
                       		map<string, object> localAcc = (map<string, object>)t;
                       		Integer LoanId = (Integer)localAcc.get('LoanId');
       						System.debug('Service response is ....' + localAcc);
	                       if(LoanId != 0){
	                               temp.ShareLoanID =  LoanId; 
	                               temp.Description =   (string)localAcc.get('Description');  
	                               temp.TypeTranslate =  (string)localAcc.get('Description'); 
	                               resultList.add(temp);  
	                       }
       				}
                    
                }
            }
            
        return resultList;
    }
    
    public class ShareLoanWrapperObject
    {
      @AuraEnabled
      public Integer ShareLoanID {get;set;}
      @AuraEnabled
      public string Description {get;set;}
      @AuraEnabled
      public string TypeTranslate {get;set;}
    }

}