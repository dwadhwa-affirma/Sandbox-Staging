public with sharing class OOWAccountNumber {
    
     @AuraEnabled
    public static string GetAccountNumber(string accdetailid, string sobjecttype)
    {
    	system.debug('sobjecttype##'+ sobjecttype);
         string AccountNumber;
        if(sobjecttype == 'Account_Details__c')
        {
            Account_Details__c accdetailList = [select id, Name from Account_Details__c where id=:accdetailid];
                       
            AccountNumber = accdetailList.Name ;
        } 
        else
        {
            Person_Account__c p = [SELECT Id, Account_Number__c,  PersonID__c, Account_Number__r.RecType__c, TypeTranslate__c, Account_Number__r.Name
                FROM Person_Account__c where PersonID__c =:accdetailid and Account_Number__r.RecType__c ='ACCT' limit 1];
            AccountNumber = p.Account_Number__r.Name;
        }
           return Accountnumber;                  
       
    }
    
    @AuraEnabled
    public static void SaveLogData(string status, string MemberNumber, string reason, string notes)
    {
    	RecordType rec = [select Id,Name,SobjectType from RecordType where Name ='OOW Execution Log' and SobjectType='Authenticated_Log__c'];
    	
    	Authenticated_Log__c log = new Authenticated_Log__c();
    	log.RecordTypeId= rec.id;
    	log.OOW_Status__c = status;
    	log.OOW_Member_Number__c = MemberNumber;
    	log.OOW_Reason__c = reason;
    	log.OOW_Notes__c = notes;
    	
    	insert log;
    	
    	system.debug('log##'+ log);
    	
    }
}