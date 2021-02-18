global class SolarLoanUCCBatch implements Database.Batchable<sObject>, Database.AllowsCallouts, Database.Stateful{

    global Database.QueryLocator start(Database.BatchableContext BC){
    	
        String query = 'SELECT Id,Status__c,UCC_Id__c from Solar_loans__c where Status__c = \'UCC Pending\' OR Status__c = \'UCC Submitted\'';
        return Database.getQueryLocator(query);
    }
    
    global void execute(Database.BatchableContext BC, List<Solar_loans__c> scope){
        
        List<Solar_Loans__c> SolarLoanToUpdate = new List<Solar_Loans__c>();
        HttpRequest req0 = new HttpRequest();
        HttpResponse res0;
        Http http0 = new Http();
        string responseBody0;
        
        HttpRequest req = new HttpRequest();
        HttpResponse res;
        Http http = new Http();
        string responseBody;
        
        String token;
        String UCCId;
        String UCCStatus;
        String client_Id;
        String client_secret;
        String username;
        String password;
        String EndpointURL;
        
        List<Solar_UCC_User_Details__c> suudList = Solar_UCC_User_Details__c.getall().values();
        
        for(Solar_UCC_User_Details__c suud : suudList){ 
            
            if(suud.Name == 'Production'){
                EndpointURL = suud.URL__c;
                client_Id = suud.ClientId__c;
                client_secret = suud.Client_Secret__c;
                username = suud.Username__c;
                password = suud.password__c;           
            }
        }
        
        for(Solar_Loans__c sl : scope){
        	
            req0.setEndpoint(EndpointURL+'/FCSAuthentication/core/connect/token');
            req0.setMethod('POST');
            req0.setHeader('Accept', 'application/json');
            req0.setBody('scope=FCSAuthentication.WebAPI&grant_type=password'+'&client_id='+client_Id+ '&client_secret=' + 
                         client_secret+'&username='+username+'&password='+password);                   
            
            system.debug('Token request'+req0);
            if(!Test.isRunningTest()){
                res0 = http0.send(req0);
                responseBody0 = res0.getBody();
                System.debug('Body: '+responseBody0);
            }
            else{
                responseBody0 = '{"access_token" : "akglalehawhfnawlkrnlwhwnkwk"}';
            }
            
            if(responseBody0!=''){ 
                Map<String,Object> results = (Map<String,Object>)System.JSON.deserializeUntyped(responseBody0);
                if(results.size() > 0){                     
                    for(String key : results.keySet()){                   			
                        if(key == 'access_token'){
                            token = String.valueOf(results.get(key));
                        }
                    }
                }
            }
            System.debug('token is = ' + token);
            
            req.setEndpoint(EndpointURL+'/OnlineServices/api/File/V2/Filing/'+sl.UCC_Id__c);
            req.setMethod('GET');
            req.setHeader('Accept', 'application/json');
            req.setHeader('Authorization', 'Bearer ' + token);
            req.setHeader('Content-Type', 'application/json;charset=UTF-8'); 
            
            system.debug('test'+req);                     
            if(!Test.isRunningTest()){
                res = http.send(req);
                responseBody = res.getBody();
                System.debug('Body: '+responseBody);
            }
            else{
                responseBody = '{"Status" : "Pending"}';
            }
            if(responseBody!=''){ 
                Map<String,Object> results = (Map<String,Object>)System.JSON.deserializeUntyped(responseBody);
                if(results.size() > 0){                     
                    for(String key : results.keySet()){                   			
                        if(key == 'Status'){
                            UCCStatus = String.valueOf(results.get(key));
                        }
                    }
                }
            }
            System.debug('UCC Status is = ' + UCCStatus);
        	
            Solar_Loans__c s = new Solar_Loans__c(); 
            s.id = sl.Id;
            if(UCCStatus == 'Pending')
            	s.Status__c = 'UCC Pending';
            
            else if(UCCStatus == 'Reviewed')
            	s.Status__c = 'UCC Submitted';
            
            else if(UCCStatus == 'Recorded'){
            	s.Status__c = 'UCC Completed';
                s.Current_Solar_Loan_Stage__c = 'Stage 8';
            }
            
            
        	SolarLoanToUpdate.add(s);      
        }
        
        if(SolarLoanToUpdate.size() > 0){
            update SolarLoanToUpdate;
        }
    }
    
    global void finish(Database.BatchableContext BC){
     
    }   
}