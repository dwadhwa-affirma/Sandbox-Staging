public class SolarLoanToFileUCC {
    
    public static List<Solar_Loans__c> SolarLoanToUpdate = new List<Solar_Loans__c>(); 
    public static String token;
    public static String UCCId;
    public static String client_Id;
    public static String client_secret;
    public static String username;
    public static String password;
    public static String EndpointURL;
    public static String json;
    public static String json1;
    public static String UCCStatus;
    
    public static HttpRequest req = new HttpRequest();
    public static HttpResponse res;
    public static Http http = new Http();
    public static string responseBody;
    
    public static HttpRequest req0 = new HttpRequest();
    public static HttpResponse res0;
    public static Http http0 = new Http();
    public static string responseBody0;
    
    public static HttpRequest req1 = new HttpRequest();
    public static HttpResponse res1;
    public static Http http1 = new Http();
    public static string responseBody1;
    
    @future(callout=true)
    public static void filUCC(Set<id> ids){
        
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
        
        List<Solar_Loans__c> Solanloanlist = new List<Solar_Loans__c>();         
    	List<Solar_Loans__c> solarloans = [SELECT id,ABA_Bank_Name__c,ACH__c,Additional_Amount__c,Application_Date__c,
                Bank_Account_Number__c,Bank_Name__c,Battery__c,Brand__c,Change_Order__c,CreatedById,CreatedDate,
                Credit_Attributes__c,Credit_Exception__c,Debt_Ratio__c,DocuSignId__c,Due_Date__c,Tracking_Record_33__c,
                ECOA_Code__c,Final_Payment_Amount__c,FNI__c,Go_To_Payment__c,Initial_LT_Loan_Agreement__c,
                Installer_Number__c,Installer__c,Interest_Rate__c,Inverter__c,IsDeleted,Joint_Address_1__c,
                Joint_Address_2__c,Joint_City__c,Joint_DOB__c,Joint_FICO_Score__c,Joint_First_Name__c,Joint_Last_Name__c,
                Joint_SSN__c,Joint_State__c,Joint_Zip_Code__c,Latest_LT_Loan_Agreement__c,Legal_Description__c,Loan_Amount__c,Loan_Pmt_Amount__c,
                Loan_Type__c,Maturity_Date__c,Account_Number__r.name,Membership_Fee__c,Member_Number__c,Module__c,Mortgage_Balance__c,Name,
                Name__c,Net_Funding_Amount__c,OID_Fee__c,OwnerId,Primary_Address_1__c,Primary_Address_2__c,
                Primary_City__c,Primary_DOB__c,Primary_FICO_Score__c,Primary_First_Name__c,Primary_Last_Name__c,
                Primary_SSN__c,Primary_State__c,Primary_Zip_Code__c,Product_Loan_Type__c,Product__c,Record_ID__c,
                Routing_Number__c,Site_UUID__c,Status__c,Symitar_Called__c,SystemModstamp,System_Size_kW__c,Term_months__c,
                Valid_ABA__c, Loan_Id__c,Loan_Name_Locator__c,Loan_Tracking_Locator__c,EftLocator__c,Approval_Date__c,
                Error_EftLocator__c,Error_Loan_Locator__c,Error_Loan_Name_Locator__c,Error_Loan_Tracking_Locator__c,
                ITC_Amount__c, ITC_Rate__c,ACH_Discount__c,UCC_Id__c
                FROM Solar_Loans__c where id =: ids];
    
        for(Solar_Loans__c sl : solarloans){
            
            //------------------------------------------------Fetching Token------------------------------------//
            
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
            
            //------------------------------------------------Filling UCC------------------------------------------//
            
            req.setEndpoint(EndpointURL+'/OnlineServices/api/File/V2/Filing');
            req.setMethod('POST');
            req.setHeader('Accept', 'application/json');
            req.setHeader('Authorization', 'Bearer ' + token);
            req.setHeader('Content-Type', 'application/json;charset=UTF-8'); 
            json = '{"FilingJurisdiction": "370",'+'"IsXMLFile": false,'+'"FilingType": "Initial",'+'"ClientReference": "",'+'    "ResponseURL": "Http://thisisatest.com",'+'"FilerReference": "",'+'"Entities": ['+'{'+'"ObjectType": "Debtor",'+'"OrganizationName": "Test",'+'"Address": {'+'"StreetAddress": "123 Add",'+'"City": "Sac",'+'"State": "CA",'+'"PostalCode": "12345",'+'"Country": "USA"'+'}'+'},'+'{'+'"ObjectType": "SecuredParty",'+'"OrganizationName": "SP",'+'"Address": {'+'"StreetAddress": "123 Add",'+'"City": "Sac",'+'"State": "CA",'+'"PostalCode": "12345",'+'"Country": "USA"'+'}'+'}'+'],'+'"Collateral": {'+'"Description": "test"'+'}'+'}';
            req.setBody(json);	
            
            system.debug('Fill UCC Request: '+req);              
            if(!Test.isRunningTest()){
                res = http.send(req);
                responseBody = res.getBody();
                System.debug('Body: '+responseBody);
            }
            else{
                responseBody = '{"ID" : "9ec739d4-67fe-443b-a06d-804679c9e184"}';
            }
            
            if(responseBody!=''){ 
                Map<String,Object> results = (Map<String,Object>)System.JSON.deserializeUntyped(responseBody);
                if(results.size() > 0){                     
                    for(String key : results.keySet()){                   			
                        if(key == 'ID'){
                            UCCId = String.valueOf(results.get(key));
                        }
                    }
                }
            }
            
            System.debug('UCC ID is = ' + UCCId);
            
            /*UCCId = '9ec739d4-67fe-443b-a06d-804679c9e184';
            System.debug('UCC ID is = ' + UCCId);
            
            req1.setEndpoint(EndpointURL+'/OnlineServices/api/File/V2/Filing/'+UCCId);
            req1.setMethod('GET');
            req1.setHeader('Accept', 'application/json');
            req1.setHeader('Authorization', 'Bearer ' + token);
            req1.setHeader('Content-Type', 'application/json;charset=UTF-8'); 
            
            system.debug('test1'+req1);                     
            if(!Test.isRunningTest()){
                res1 = http1.send(req1);
                responseBody1 = res1.getBody();
                System.debug('Body: '+responseBody1);
            }
            else{
                responseBody1 = '{"Status" : "Pending"}';
            }
            if(responseBody1!=''){ 
                Map<String,Object> results = (Map<String,Object>)System.JSON.deserializeUntyped(responseBody1);
                if(results.size() > 0){                     
                    for(String key : results.keySet()){                   			
                        if(key == 'Status'){
                            UCCStatus = String.valueOf(results.get(key));
                        }
                    }
                }
            }
            System.debug('UCC Status is = ' + UCCStatus);*/
            
            Solar_Loans__c s = new Solar_Loans__c(); 
            s.id = sl.Id;
            s.UCC_Id__c = UCCId;
        	SolarLoanToUpdate.add(s);
        }
        
        if(SolarLoanToUpdate.size() > 0){
            update SolarLoanToUpdate;
        } 
    }
}