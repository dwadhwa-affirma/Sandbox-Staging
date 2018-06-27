public class MemberAccountController {
	
    @AuraEnabled
    public static list<Person_Account__c>  GetAccountDetails(string AccountId)
    {
    	string accId1;
    	    	
    	list<Person_Account__c>  paList = new list<Person_Account__c>();
    	
    	Account_Details__c accDetails = [Select Parent_Account__c from Account_Details__c where Id=:AccountId Limit 1];          
            if(accDetails.Parent_Account__c != null){
              accId1 = accDetails.Parent_Account__c;
            }
            
 
         paList = [SELECT Id,
                          Account_Number__c,
                          PersonId__c,
                          PersonID__r.Name,
                          TypeTranslate__c FROM Person_Account__c WHERE Account_Number__c =:AccountId OR Account_Number__c =:accId1];
                          
        return paList;
    }
}