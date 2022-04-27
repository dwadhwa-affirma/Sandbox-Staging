@RestResource(urlMapping = '/DigitalBankingAPIForBadgeCount/*')
global class DigitalBankingAPIForBadgeCount{
	
    @HttpPOST
    global static Map<String,Integer> getUnreadCaseCount() {
        
        RestRequest req = RestContext.request;
        system.debug('req'+req);
             
        String strMemberNumber = req.params.get('SSN');
        system.debug('strMemberNumber: '+strMemberNumber);
        String FinalAccNum;
        String loanAPI;
        Set<Id> parentcaseId = new Set<Id>();
        Set<string> MemberCommentAccountNumber = new Set<string>();
        
        Map<String,Integer> responseObjList = new Map<String,Integer>();
        
        ACH_To_Episys_API_Details__c api = ACH_To_Episys_API_Details__c.getValues('ProductionURL');
                
        if(api.URL__c != null){
            loanAPI = api.URL__c;
        }
        
        if(strMemberNumber.length() == 9){
           
            HttpRequest req1 = new HttpRequest();
            HttpResponse res1;
            Http http1 = new Http();
            string responseBody1;
            string AuthrorizedAccountString = '';
            
            req1.setEndpoint(loanAPI + '/MemberAuthorization/GetAuthorizedAccounts?ssn=' + strMemberNumber);
            req1.setMethod('GET');
            
            if(!Test.isRunningTest()){                       
                res1 = http1.send(req1);
                responseBody1 = res1.getBody();                
            }
            else{
                responseBody1 = '{"Accounts":"0000000123,0000000256"}';
            }
            
            system.debug('responseBody1: '+responseBody1);
            
            if(responseBody1 != ''){
                map<string, object> jsonParsed = (map<string, object>)JSON.deserializeUntyped(responseBody1);
                system.debug('jsonParsed=='+jsonParsed);
                AuthrorizedAccountString = (string)jsonParsed.get('Accounts');
            }
                
            List<String> lstAccounts = AuthrorizedAccountString.split(',');
            Set<String> setAccounts = new Set<String>(lstAccounts);
            
            system.debug('lstAccounts: '+lstAccounts);    
            
            List<Case> AllCases = [SELECT Id, Account_Number__r.Name FROM case 
                                          where IsMarkDeleted__c = false and IsMarkSaved__c = false and
                                          MemberCommentCount__c > 0 and 
                                          Account_Number__r.Name in :lstAccounts and 
                                          CreatedDate >= LAST_N_MONTHS:18];
            for(integer i =0 ; i < AllCases.size(); i ++)
			{				
				parentcaseId.Add(AllCases[i].Id);
			}
            
            List<Member_Comment__c> AllUnreadCommentsforCase = [SELECT Case__r.Id, CreatedDate,Id,Member_Comment__c,Name, IsRead__c, Member_Number__c FROM Member_Comment__c Where Case__r.Id IN : parentcaseId and draft__c != true and IsRead__c = false order by CreatedDate desc];
			system.debug('AllUnreadCommentsforCase: '+AllUnreadCommentsforCase); 
            
            for(Member_Comment__c mc: AllUnreadCommentsforCase){
                MemberCommentAccountNumber.add(mc.Member_Number__c);
            }
            for(AggregateResult aggRes : [SELECT COUNT(ID) totalunread, Account_Number__r.Name accnum FROM case 
                                          where IsMarkRead__c = false and IsMarkDeleted__c = false and IsMarkSaved__c = false and
                                          MemberCommentCount__c > 0 and 
                                          Account_Number__r.Name in :lstAccounts and 
                                          CreatedDate >= LAST_N_MONTHS:18
                                          GROUP BY Account_Number__r.Name]) {
    			
                string accnum = (string) aggRes.get('accnum');
    			Integer count = (Integer) aggRes.get('totalunread');                                             
                
                
    			responseObjList.put(accnum, count);
            }
            
           /* for(Member_Comment__c mc: AllUnreadCommentsforCase){
                Integer MCCount = 1;
                if(!responseObjList.ContainsKey(mc.Member_Number__c)){
                    responseObjList.put(mc.Member_Number__c, MCCount);
                }                
            }*/
           
        	
            system.debug('responseObjList: '+responseObjList);        	            
        }
        
        return responseObjList;
        
    }   
}