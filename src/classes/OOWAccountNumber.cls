public with sharing class OOWAccountNumber {
    
     @AuraEnabled
    public static Map<string,string> GetAccountNumber(string accdetailid, string sobjecttype)
    {
    	system.debug('sobjecttype##'+ sobjecttype);
         string AccountNumber;
         string MemberName;
         string FlowURL;
         Map<string,string> strMap = new  Map<string,string>();
         string source;
         
        OOW_Flow_URL__c oowf = OOW_Flow_URL__c.getValues('OOW Boomi Flow URL');
		
		if(oowf.URL__c != null){
			FlowURL = oowf.URL__C;
		}
		
        if(sobjecttype == 'Account_Details__c')
        {
            Account_Details__c accdetailList = [select id, Name from Account_Details__c where id=:accdetailid];
                       
            AccountNumber = accdetailList.Name ;
            
            Person_Account__c p = [SELECT Id,  PersonID__r.Name,Account_Number__c,  PersonID__r.FirstName,PersonID__r.LastName, Account_Number__r.RecType__c, TypeTranslate__c, Account_Number__r.Name
                FROM Person_Account__c where Account_Number__c =:accdetailid and Account_Number__r.RecType__c IN('ACCT','SHAR') order by Account_Number__r.RecType__c asc Limit 1];
            MemberName = p.PersonID__r.Name ;
            source = 'account';
        } 
        else
        {
            Person_Account__c p = [SELECT Id, PersonID__r.Name, Account_Number__c, PersonID__r.FirstName,PersonID__r.LastName, PersonID__c, Account_Number__r.RecType__c, TypeTranslate__c, Account_Number__r.Name
                FROM Person_Account__c where PersonID__c =:accdetailid and Account_Number__r.RecType__c IN('ACCT','SHAR')  order by Account_Number__r.RecType__c asc limit 1 ];
            AccountNumber = p.Account_Number__r.Name;
            MemberName =  p.PersonID__r.Name;
            source = 'member';
            
        }
        
        strMap.put('AccountNumber',AccountNumber);
        strMap.put('MemberName',MemberName);
        strMap.put('source',source);
        strMap.put('FlowURL',FlowURL);
        return strMap;                  
       
    }
    
    @AuraEnabled
    public static void SaveLogData(string status, string MemberNumber, string reason, string notes, string name)
    {
    	RecordType rec = [select Id,Name,SobjectType from RecordType where Name ='OOW Execution Log' and SobjectType='Authenticated_Log__c'];
    	
    	/*Person_Account__c pa = [SELECT Id, Account_Number__c,  PersonID__r.FirstName,PersonID__r.LastName, Account_Number__r.RecType__c, TypeTranslate__c, Account_Number__r.Name
                FROM Person_Account__c where Account_Number__r.Name=:MemberNumber and Account_Number__r.RecType__c IN('ACCT','SHAR') order by Account_Number__r.RecType__c asc Limit 1];*/
    	 String[] sp2 ;
    	if(name != null && name != '' ){
    		 sp2 = name.split(' ');}
    	
		
    	Authenticated_Log__c log = new Authenticated_Log__c();
    	log.RecordTypeId= rec.id;
    	log.OOW_Status__c = status;
    	log.OOW_Member_Number__c = MemberNumber;
    	log.OOW_Reason__c = reason;
    	log.OOW_Notes__c = notes;
    	if(sp2.size() > 0)log.First_Name__c = sp2[0];
    	if(sp2.size() > 2) log.Last_Name__c = sp2[2];
    	else if(sp2.size() > 0)log.Last_Name__c = sp2[1];
    	insert log;
    	
    	system.debug('log##'+ log);
    	
    }
}