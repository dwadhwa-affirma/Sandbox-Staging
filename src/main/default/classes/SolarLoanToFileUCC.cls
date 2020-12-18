public class SolarLoanToFileUCC {
    
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
        
        req0.setEndpoint(EndpointURL+'/FCSAuthentication/core/connect/token');
        req0.setMethod('POST');
        req0.setHeader('Accept', 'application/json');
        req0.setBody('scope=FCSAuthentication.WebAPI&grant_type=password'+'&client_id='+client_Id+ '&client_secret=' + 
                     client_secret+'&username='+username+'&password='+password);                   
        
        system.debug('test'+req0);                     
        res0 = http0.send(req0);
        responseBody0 = res0.getBody();
        System.debug('Body: '+responseBody0);
        
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
        
        
        req.setEndpoint(EndpointURL+'/OnlineServices/api/File/V1/Filing');
        req.setMethod('POST');
        req.setHeader('Accept', 'application/json');
        req.setHeader('Authorization', 'Bearer ' + token);
        req.setHeader('Content-Type', 'application/json;charset=UTF-8'); 
        json = '{"FilingJurisdiction": "370",'+'"IsXMLFile": false,'+'"FilingType": "Initial",'+'"ClientReference": "",'+'    "ResponseURL": "Http://thisisatest.com",'+'"FilerReference": "",'+'"Entities": ['+'{'+'"ObjectType": "Debtor",'+'"OrganizationName": "Test",'+'"Address": {'+'"StreetAddress": "123 Add",'+'"City": "Sac",'+'"State": "CA",'+'"PostalCode": "12345",'+'"Country": "USA"'+'}'+'},'+'{'+'"ObjectType": "SecuredParty",'+'"OrganizationName": "SP",'+'"Address": {'+'"StreetAddress": "123 Add",'+'"City": "Sac",'+'"State": "CA",'+'"PostalCode": "12345",'+'"Country": "USA"'+'}'+'}'+'],'+'"Collateral": {'+'"Description": "test"'+'}'+'}';
        req.setBody(json);	
        
        system.debug('test1'+req);                     
        res = http.send(req);
        responseBody = res.getBody();
        System.debug('Body: '+responseBody);
        
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
        
        //UCCId = '9ec739d4-67fe-443b-a06d-804679c9e184';
        System.debug('UCC ID is = ' + UCCId);
        
        req1.setEndpoint(EndpointURL+'/OnlineServices/api/File/V1/Filing/'+UCCId);
        req1.setMethod('GET');
        req1.setHeader('Accept', 'application/json');
        req1.setHeader('Authorization', 'Bearer ' + token);
        req1.setHeader('Content-Type', 'application/json;charset=UTF-8'); 
        
        
        system.debug('test1'+req1);                     
        res1 = http1.send(req1);
        responseBody1 = res1.getBody();
        System.debug('Body: '+responseBody1);
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
        System.debug('UCC Status is = ' + UCCStatus);
    }

}