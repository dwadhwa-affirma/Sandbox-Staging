global without sharing class GetABADetailsWebService {
    webservice static ABABankDetails getBankName(string routingNumber){
        HttpRequest req1 = new HttpRequest();
        HttpRequest req2 = new HttpRequest();
        HttpRequest req3 = new HttpRequest();
        HttpResponse res1;
        HttpResponse res2;
        HttpResponse res3;
        Http http1 = new Http();
        Http http2 = new Http();
        Http http3 = new Http();
        string responseBody1;
        string responseBody2;
        string responseBody3;
        String token;
        String bankName;
        BankAbaDetails bankDetails;
        BankAbaDetails bankDetails1;
        String freeToken;
        string bankToken;
        String freeToken1;
        string bankToken1;
        ABABankDetails resultBankDetails = new ABABankDetails();
        
        routingNumber = routingNumber.leftPad(9, '0');        
        Map<string, BankAbaVerifyCredentials__mdt> bankABA = BankAbaVerifyCredentials__mdt.getAll();
        String endpoint1 = (String) bankABA.get('Token').Endpoint__c;
        String username = (String) bankABA.get('Token').UserName__c;
        String password = (String) bankABA.get('Token').Password__c;
        
        Bank_Verify_Message__mdt errorMessage = [SELECT Message__c FROM Bank_Verify_Message__mdt WHERE DeveloperName = 'FedWireCorrection'];
        
        
        req1.setEndpoint(endpoint1+'?username='+username+'&password='+password);
        req1.setMethod('POST');
        req1.setHeader('Content-Type', 'application/x-www-form-urlencoded');
        req1.setHeader('Accept', 'application/json');
        req1.setTimeout(120000);
        
        if(!Test.isRunningTest()){                       
            res1 = http1.send(req1);
            responseBody1 = res1.getBody();               
        }
        JSONParser parser = JSON.createParser(responseBody1);
        token = String.valueOf(responseBody1).substringAfter('token":"');
        token = String.valueOf(token).substringBefore('",'); 
        String endpoint2 = (String) bankABA.get('BankDetails').Endpoint__c;  
        req2.setEndpoint(endpoint2 + '?countryCode=US&nationalId=' + routingNumber + '&token='+token);
        req2.setMethod('GET');
        req2.setHeader('Content-Type', 'application/x-www-form-urlencoded');
        req2.setHeader('Accept', 'application/json');
        req2.setTimeout(120000);
        
        if(!Test.isRunningTest()){                       
            res2 = http2.send(req2);
            responseBody2 = res2.getBody();            
        }
        
       
                
        if(responseBody2 != ''){        
            Map<String,Object> results = (Map<String,Object>)System.JSON.deserializeUntyped(responseBody2);

            String status = (String)results.get('status');
           
            if(Status == 'PASS'){               
                
                Map<String,Object> bankResponseMap = (Map<String, Object>) JSON.deserializeUntyped(responseBody2);

                bankDetails = BankAbaVerifyExtractBankDetails.getDetails(bankResponseMap);
                freeToken   = bankDetails.FreeToken; 
                bankToken   = bankDetails.BankToken;
                Map<String, Object> bankFedResponseMap = BankAbaVerifyGetBankData.getBankFedData(token, freeToken, bankToken, 'US');
                bankDetails = BankAbaVerifyExtractBankDetails.getFedDetails(bankDetails,bankFedResponseMap);               
                system.debug('bankDetails: '+bankDetails);
                if(bankDetails.ClearingStatus  == 'PASS'    &&
                  bankDetails.FedWireServiceId == 'FEDWIRE' && bankDetails.FedWireParticipantId.length() > 0 && 
                  bankDetails.FedWireParticipantType.startsWith('F')) {
                  ResultBankDetails.bankName  = bankDetails.BankName;       
                  ResultBankDetails.errorMessage = '';
                  ResultBankDetails.correctedRoutingNumber = '';
                } 
                else {
                    if(!bankDetails.FedWireParticipantType.startsWith('F') && bankDetails.fedWireAttributeType3 == 'Fedwire Corr' && String.isNotBlank(bankDetails.fedWireAttributeValue3)){
                        Map<String, Object> bankResponseMap1 = BankAbaVerifyGetBankData.getBankData(token,'US',bankDetails.fedWireAttributeValue3);
                        String status1  = (String) bankResponseMap1.get('status');
                        String comment1 = (String) bankResponseMap1.get('comment');
                        if(status1 == 'PASS') {
                                bankDetails1 = BankAbaVerifyExtractBankDetails.getDetails(bankResponseMap1);
                                freeToken1   = bankDetails1.FreeToken; 
                                bankToken1   = bankDetails1.BankToken;
                                Map<String, Object> bankFedResponseMap1 = BankAbaVerifyGetBankData.getBankFedData(token, freeToken1, bankToken1, 'US');
                                bankDetails1 = BankAbaVerifyExtractBankDetails.getFedDetails(bankDetails1,bankFedResponseMap1);
                                if(bankDetails1.ClearingStatus  == 'PASS'    &&                                
                                  bankDetails1.FedWireServiceId == 'FEDWIRE' && bankDetails1.FedWireParticipantId.length() > 0 && 
                                  bankDetails1.FedWireParticipantType.startsWith('F')) {
                                  ResultBankDetails.bankName  = ''; 
                                  ResultBankDetails.errorMessage  = ErrorMessage.Message__c; 
                                  ResultBankDetails.correctedRoutingNumber = bankDetails.fedWireAttributeValue3;
                                } 
                            	else {
                                  ResultBankDetails.bankName  = ''; 
                                  ResultBankDetails.errorMessage  = '';    
                                    ResultBankDetails.correctedRoutingNumber = bankDetails.fedWireAttributeValue3;
                                }
                    	}
                    }
                    else{                        
                       ResultBankDetails.bankName  = 'FAIL';
                       ResultBankDetails.errorMessage  = ''; 
                        ResultBankDetails.correctedRoutingNumber = '';
                        
                    }                  
                }
               
            }
            else{
                ResultBankDetails.bankName  = 'FAIL'; 
                ResultBankDetails.errorMessage  = ''; 
                ResultBankDetails.correctedRoutingNumber = '';
            }            
        }
        system.debug('ResultBankDetails: '+ResultBankDetails);
        return ResultBankDetails;
    }
        

    global class ABABankDetails{
         @auraenabled
    	webservice String bankName { get; set; }
        
        @auraenabled
    	webservice String errorMessage { get; set; }
        
        @auraenabled
    	webservice String correctedRoutingNumber { get; set; }
    } 

    
    
        
}