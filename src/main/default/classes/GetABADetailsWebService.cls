global class GetABADetailsWebService {
    webservice static string GetBankName(string RoutingNumber){
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
        String freeToken, bankToken;
        
        RoutingNumber = RoutingNumber.leftPad(9, '0');
        System.debug('RoutingNumber:'+RoutingNumber);
        
        Map<string, BankAbaVerifyCredentials__mdt> BankABA = BankAbaVerifyCredentials__mdt.getAll();
        String Endpoint1 = (String) BankABA.get('Token').Endpoint__c;
        String Username = (String) BankABA.get('Token').UserName__c;
        String Password = (String) BankABA.get('Token').Password__c;
        
        
        req1.setEndpoint(Endpoint1+'?username='+Username+'&password='+Password);
        req1.setMethod('POST');
        req1.setHeader('Content-Type', 'application/x-www-form-urlencoded');
        req1.setHeader('Accept', 'application/json');
        req1.setTimeout(120000);
        
        if(!Test.isRunningTest()){                       
            res1 = http1.send(req1);
            responseBody1 = res1.getBody();
            //System.debug('Response Body SolarLoan:'+res1.getBody());    
        }
        JSONParser parser = JSON.createParser(responseBody1);
        token = String.valueOf(responseBody1).substringAfter('token":"');
        token = String.valueOf(token).substringBefore('",');
        System.debug('Token: ' + token);
        
        
         
         String Endpoint2 = (String) BankABA.get('BankDetails').Endpoint__c;      
        
        req2.setEndpoint(Endpoint2 + '?countryCode=US&nationalId=' + RoutingNumber + '&token='+token);
        req2.setMethod('GET');
        req2.setHeader('Content-Type', 'application/x-www-form-urlencoded');
        req2.setHeader('Accept', 'application/json');
        req2.setTimeout(120000);
        
        if(!Test.isRunningTest()){                       
            res2 = http2.send(req2);
            responseBody2 = res2.getBody();
            System.debug('Response Body:'+res2.getBody());    
        }
        
       
                
        if(responseBody2 != ''){        
            Map<String,Object> results = (Map<String,Object>)System.JSON.deserializeUntyped(responseBody2);
            system.debug('results: '+results);
            String Status = (String)results.get('status');
            system.debug('Status: '+Status);
            if(Status == 'PASS'){               
                
                Map<String,Object> bankResponseMap = (Map<String, Object>) JSON.deserializeUntyped(responseBody2);//(Map<String,Object>)results.get('headOfficeDetails');
                system.debug('bankResponseMap: '+bankResponseMap);
                bankDetails = BankAbaVerifyExtractBankDetails.getDetails(bankResponseMap);
                freeToken   = bankDetails.FreeToken; 
                bankToken   = bankDetails.BankToken;
                Map<String, Object> bankFedResponseMap = BankAbaVerifyGetBankData.getBankFedData(token, freeToken, bankToken, 'US');
                bankDetails = BankAbaVerifyExtractBankDetails.getFedDetails(bankDetails,bankFedResponseMap);
                if(bankDetails.ClearingStatus  == 'PASS'    &&
                  bankDetails.FedAchServiceId  == 'FEDACH'  && bankDetails.FedAchParticipantId.length()  > 0 &&
                  bankDetails.FedWireServiceId == 'FEDWIRE' && bankDetails.FedWireParticipantId.length() > 0 && 
                  bankDetails.FedWireParticipantType.startsWith('F')) {
                  bankName  = bankDetails.BankName;                  
                } else {
                  bankName = 'FAIL';
                }
                //bankName = (String)results2.get('bankName');
                //system.debug('Bank: '+bankName);
            }
            else{
                bankName = 'FAIL';
            }            
        }
        return bankName;
    }
}