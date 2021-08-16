@RestResource(urlMapping = 
'/DigitalBankingAPI/*')
global class DigitalBankingAPI{
	@HttpPost
	global static string CreateCase(){
		Id groupnameid;
        string Description;

		String requestBody = RestContext.request.requestBody.toString();
		CreateCaseRequest CaseRequest = (CreateCaseRequest)System.JSON.deserialize(requestBody,CreateCaseRequest.class); 
        string AccountNumber = CaseRequest.MemberNumber.leftPad(10, '0');

        List<Person_Account__c> paList = [SELECT id, Name, Account_Number__c, PersonID__c, PersonID__r.Residential_Street__pc, PersonID__r.Residential_Extra_Address__pc, PersonID__r.Residential_City__pc, PersonID__r.Residential_State__pc, PersonID__r.Residential_Zipocde__pc, PersonID__r.Residential_Country__pc
			                                  from Person_Account__c
			                                  where Account_Number__r.Name = :AccountNumber and TypeTranslate__c like '%Primary'
			                                  Limit 1];

        Description = 'Member number: ' +  AccountNumber + '\n'
                    + 'Requestor: ' +  CaseRequest.Requestor + '\n'
                    + 'User: ' +  CaseRequest.LoggedInUser + '\n'
                    + 'Qualify Strategy Code: ' +  CaseRequest.QualifyStrategyCode; 
		List<Group> listQueue = [select id, Name, Email
		                         from Group
		                         where Type = 'Queue' and name = 'Real Estate Servicing Queue'];

		if (listQueue.size() > 0){
			groupnameid = listQueue[0].id;
		}
		Case caseObj = new Case();
		caseObj.Primary_Category__c = 'Account maintenance';
		caseObj.Secondary_Category__c = 'Shares';
		caseObj.Tertiary_Category__c = 'New online share';
        if (paList.size() > 0){
            caseObj.Account_Number__c = paList[0].Account_Number__c;
        }
		else{
            caseObj.Brand__c = 'Chevron';
        }
		caseObj.OwnerId = groupnameid;
        caseObj.Description = Description;

		insert caseObj;

        return caseObj.Id;
	}
	
    @HttpGET
    global static Map<String,Integer> getUnreadCaseCount() {
        
        RestRequest req = RestContext.request;
        system.debug('req'+req);
             
        String strMemberNumber = req.params.get('AccNum');
        system.debug('strMemberNumber: '+strMemberNumber);
        String FinalAccNum;
        
        List<string> MemberNumberList = strMemberNumber.split(',');
        List<string> FinalAccNumList = new List<string>();
        
        List<Case> caseList = new List<Case>();
        Map<String,Integer> responseObjList = new Map<String,Integer>();
        
        if(MemberNumberList.size() > 0){
            
            For(String s: MemberNumberList){
                system.debug('S: '+s);
                Integer sl = s.length();        
                
                if (sl<10){
                    Integer  zerotoadd = 10-sl;
                    string prepend='';
                    for (Integer  i=0; i<zerotoadd; i++){
                        prepend = '0' + prepend;
                    }
                    FinalAccNum = prepend + s;
                    FinalAccNumList.add(FinalAccNum);
                }
                else{
                    FinalAccNumList.add(s);
                }
            }
        
            system.debug('FinalAccNumList: '+FinalAccNumList);
            
        	caseList = [SELECT Id, CaseNumber,Account_Number__r.Name,Primary_Category__c,Description,Priority,Status,
            		Subject,CreatedDate,IsMarkRead__c,contactid from Case where IsMarkRead__c = false and
                    Account_Number__r.Name in :FinalAccNumList];
        }
        
        for(AggregateResult aggRes : [SELECT COUNT(ID) totalunread, Account_Number__r.Name accnum FROM case where IsMarkRead__c = false
                                      and Account_Number__r.Name in :FinalAccNumList GROUP BY Account_Number__r.Name]) {
    		string accnum = (string) aggRes.get('accnum');
    		Integer count = (Integer) aggRes.get('totalunread');
    		responseObjList.put(accnum, count);
		}
        
        return responseObjList;
    }    
    
	global class CreateCaseRequest{
		@AuraEnabled
		global string MemberNumber;
		@AuraEnabled
		global string Requestor;
		@AuraEnabled
		global string LoggedInUser;
		@AuraEnabled
		global string QualifyStrategyCode;

	}
}