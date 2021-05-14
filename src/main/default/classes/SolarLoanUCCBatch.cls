global class SolarLoanUCCBatch implements Database.Batchable<sObject>, Database.AllowsCallouts, Database.Stateful{

    global Database.QueryLocator start(Database.BatchableContext BC){
    	
        String query = 'SELECT Id,UCC_logs__c,County__c,Tracking_Record_34__c,Status__c,Member_Number__c,UCC_Id__c from Solar_loans__c where Status__c = \'UCC Pending\' OR Status__c = \'UCC Submitted\'';
        return Database.getQueryLocator(query);
    }
    
    global void execute(Database.BatchableContext BC, List<Solar_loans__c> scope){
        
        List<Solar_Loans__c> SolarLoanToUpdate = new List<Solar_Loans__c>();
        List<Attachment> SolarLoanUCCAttachment = new List<Attachment>();

        HttpRequest req0 = new HttpRequest();
        HttpResponse res0;
        Http http0 = new Http();
        string responseBody0;
        
        HttpRequest req = new HttpRequest();
        HttpResponse res;
        Http http = new Http();
        string responseBody;
        
        //----------------------------------------------------Tracking 34--------------------------------------//
        
        HttpRequest req1 = new HttpRequest();
        HttpResponse res1;
        Http http1 = new Http();
        String jsondata1;
        string responseBody1;

        //-----------------------------------------------------Document------------------------------------------//

        HttpRequest req2 = new HttpRequest();
        HttpResponse res2;
        Http http2 = new Http();
        String jsondata2;
        string responseBody2;
        String UCCFile;

        String AccountNumber;
        String UserChar1;
        String UserChar2;
        String UserChar3;
        String UserChar4;
        String LoanId;
        String UserDate1;
        String UserDate2;
        String UserDate3;
        String Type;
        String operatorid;
        String TrackingLocator;
        
        String loanAPI;
        String token;
        String UCCId;
        String UCCStatus;
        String UCCError;
        String client_Id;
        String client_secret;
        String username;
        String password;
        String EndpointURL;
        string UCClogs;
        string filenumber;
        string SubmitionDate;
        string fileDate;
        string fileLapsedDate;
        string WorkOrderID;
                
        SolarLoan_To_Episys_API_Details__c api = SolarLoan_To_Episys_API_Details__c.getValues('ProductionURL');
                        
        if(api.URL__c != null){
            loanAPI = api.URL__c;
        }
        
        String currentUserName = UserInfo.getUserName();
        User activeUser = [Select Email,Alias From User where Username = : currentUserName and Alias != null limit 1];
    
        List<Episys_User__c> epu =  [select id,Alias__c,Episys_ID__c,Episys_Name__c from Episys_User__c where Alias__c =: activeUser.Alias];
        system.debug('Episys User' + epu);
        if(epu != null){
            if(epu.size() > 1){
                for(Episys_User__c eu : epu){
                    if(eu.Alias__c != null){
                        operatorid = string.ValueOf(epu[0].Episys_ID__c);
                        system.debug('operatorid'+operatorid);
                    }
                }
            
            }
            if(epu.size() == 1){
                operatorid = string.ValueOf(epu[0].Episys_ID__c);
                system.debug('operatorid'+operatorid);
            }
        }
        
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
            
            req.setEndpoint(EndpointURL+'/OnlineServices/api/File/V2/Filing/'+sl.UCC_Id__c+'/Status');
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
                responseBody = '{"Status" :"Recorded", "Error" : "Error","FileNumber" : "234214","DateCreated" : "2016-11-11","FileDate" :"34324","LapsedDate" :"2011-11-11","WorkOrderID" :"34324"}';
            }
            
            
            
            UCClogs = responseBody;
            
            if(responseBody!=''){ 
                Map<String,Object> results = (Map<String,Object>)System.JSON.deserializeUntyped(responseBody);
                if(results.size() > 0){                     
                    for(String key : results.keySet()){    
                        system.debug('Key is....'+key);
                        system.debug('value is....'+results.get(key));
                        system.debug('-----------------------------------------');
                        if(key == 'Status'){
                            UCCStatus = String.valueOf(results.get(key));
                        }
                        if(key == 'Errors'){
                            UCCError = String.valueOf(results.get(key));
                        }
                        if(key == 'FileNumber'){
                            filenumber = String.valueOf(results.get(key));
                        }
                        if(key == 'DateCreated'){
                            SubmitionDate = String.valueOf(results.get(key));
                        }
                        if(key == 'FileDate'){
                            fileDate = String.valueOf(results.get(key));
                        }
                        if(key == 'LapsedDate'){
                            fileLapsedDate = String.valueOf(results.get(key));
                        }
                        if(key == 'WorkOrderID'){
                            WorkOrderID = String.valueOf(results.get(key));
                        }
                    }
                }
            }
            System.debug('UCC Status is ' + UCCStatus);
            System.debug('UCC Error is ' + UCCError);
            System.debug('UCC File number is ' + filenumber);
            System.debug('UCC Created Date is ' + SubmitionDate);
            System.debug('UCC File Date is ' + FileDate);
            System.debug('UCC File LapsedDate is ' + fileLapsedDate);
            System.debug('UCC WorkOrderID is ' + WorkOrderID);
            
            Solar_Loans__c s = new Solar_Loans__c(); 
            s.id = sl.Id;
            if(UCCStatus == 'Pending')
            	s.Status__c = 'UCC Pending';
            
            else if(UCCStatus == 'Reviewed')
            	s.Status__c = 'UCC Submitted';
            
            else if(UCCStatus == 'Rejected'){
            	s.Status__c = 'UCC Rejected';
            }
            
            else if(UCCStatus == 'Recorded'){
            	s.Status__c = 'UCC Completed';
                s.Current_Solar_Loan_Stage__c = 'Stage 8';

                //-------------------------------------Creating a document -------------------------------------//

                req2.setEndpoint(EndpointURL+'/OnlineServices/api/File/V2/Filing/'+sl.UCC_Id__c+'/GenerateImage');
                req2.setMethod('GET');
                req2.setHeader('Accept', 'application/json');
                req2.setHeader('Authorization', 'Bearer ' + token);
                req2.setHeader('Content-Type', 'application/json;charset=UTF-8');

                system.debug('test1'+req2);                     
                
                if(!Test.isRunningTest()){
                    res2 = http2.send(req2);
                    responseBody2 = res2.getBody();
                    System.debug('Body: '+responseBody2);
                }
                else{
                    responseBody2 = '{"FileBase64String" : "SSetewtewewtegsgw"}';
                }

                if(responseBody2!=''){ 
                    Map<String,Object> results = (Map<String,Object>)System.JSON.deserializeUntyped(responseBody2);
                    if(results.size() > 0){                     
                        for(String key : results.keySet()){                   			
                            if(key == 'FileBase64String'){
                                UCCFile = String.valueOf(results.get(key));
                            }
                        }
                    }
                }
                System.debug('UCC File is = ' + UCCFile);
                
                Attachment attach = new Attachment();
                attach.contentType = 'application/pdf';
                attach.name = 'UCC Filing document - Recorded.pdf';
                attach.parentId = sl.id;
                attach.body = EncodingUtil.base64Decode(UCCFile);
                SolarLoanUCCAttachment.add(attach);

                //------------------------------------Updating Existing Tracking 34----------------------------//
                
                Type = '34';
                if(sl.Member_number__c != null)
                	AccountNumber = sl.Member_Number__c;
                
                if(sl.Tracking_Record_34__c != null)
                    TrackingLocator = sl.Tracking_Record_34__c;
                
                LoanId = '7500';
                UserChar1 = 'Filed';
                if(sl.County__c != null)
                	UserChar2 = sl.county__c +' County';
                
                UserChar3 = filenumber;
                UserChar4 = WorkOrderID;
                
                
                UserDate1 = FileDate;
                UserDate2 = FileDate;
                if(fileLapsedDate != null)
                	UserDate3 = fileLapsedDate;
               	else
                    UserDate3 = string.ValueOf(System.today().addYears(5));
              
                System.debug('-----------------------------------Updating Tracking 34 Record------------------------------------');
                
                req1.setEndpoint(loanAPI+'/SolarLoan/UpdateLoanTracking34');
                req1.setMethod('POST');
                req1.setHeader('Content-Type', 'application/json');
                req1.setHeader('Accept', 'application/json');
                
                jsonData1='{"EpisysId":'+'\"'+operatorid+'\"'+',"LoanTrackingLocator":'+'\"'+TrackingLocator+'\"'+',"LoanId":'+'\"'+LoanId+'\"'+',"AccountNumber":'+'\"'+AccountNumber+'\"'+',"Type":' + '\"'+ Type +'\"'+',"UserChar1":' + '\"'+ UserChar1 +'\"'+',"UserChar2":' + '\"'+ UserChar2+'\"'+',"UserChar3":' + '\"'+ UserChar3+'\"'+',"UserChar4":' + '\"'+ UserChar4+'\"'+',"UserDate1":' + '\"'+ UserDate1+'\"'+',"UserDate2":' + '\"'+ UserDate2+'\"'+',"UserDate3":' + '\"'+ UserDate3 +'\"}';
                req1.setBodyAsBlob(Blob.valueof(jsondata1)); 
                system.debug('Request is ....'+jsonData1);
                
                req1.setTimeout(60000);
                if(!Test.isRunningTest()){                       
                    res1 = http1.send(req1);
                    responseBody1 = res1.getBody();
                    System.debug('Response Body Tracking 34::'+res1.getBody());    
                }else{
                    responseBody1 = '{"Type":"34","UserChar1":"Submitted","TrackingLocator":"1","UserChar2":"1","UserChar3":"100","UserChar4":"4","UserChar5":"1","UserChar10":"01-01-2019","UserChar20":"01-01-2019","UserAmount1":"100.00","UserAmount2":"322271627","UserAmount3":"42006986568","UserAmount11":"BANK OF AMERICA","UserAmount12":"123","UserAmount13" : "UserAmount13","UserCode1" : "UserCode1", "LoanId" : "LoanId", "AccountNumber" : "AccountNumber"}';
                }
                
                if(UCClogs == null)
                	UCClogs = responseBody1;
            	else
                	UCClogs = UCClogs +'\n'+ responseBody1;
               
            }
   			
            if(UCClogs != null)
                s.UCC_logs__c = UCClogs;

            if(UCCError != null)
                s.UCC_Error__c = UCCError;     
            
            SolarLoanToUpdate.add(s);      
        }
        
        if(SolarLoanUCCAttachment.size() > 0){
            insert SolarLoanUCCAttachment;
        }

        if(SolarLoanToUpdate.size() > 0){
            update SolarLoanToUpdate;
        }
        
    }
    
    global void finish(Database.BatchableContext BC){
     
    }   
}