@RestResource(urlMapping = 
'/DigitalBankingAPI/*')
global class DigitalBankingAPI{
	@HttpPost
	global static string CreateCase(CreateCaseRequest CaseRequest){
		Id groupnameid;
        string Description;
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