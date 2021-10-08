public class WiresAccountNumber {
	
     @AuraEnabled
    public static Map<string,string> GetAccountNumber(string accdetailid)
    {
        Account_Details__c accdetailList = [select id, Name from Account_Details__c where id=:accdetailid];
        Map<string,string> strMap = new  Map<string,string>();
        strMap.put('AccountNumber',accdetailList.Name);
        
        WiresBranchFlowURL__c wbfu = WiresBranchFlowURL__c.getValues('WiresBranchFlowURL');
        string FlowURL=wbfu.URL__c;
        strMap.put('FlowURL',FlowURL);
        
        
        WiresBranchFlowURL__c wofu = WiresBranchFlowURL__c.getValues('WiresOnlineFlowURL');
        string onlineFlowURL=wofu.URL__c;
        strMap.put('OnlineFlowURL',onlineFlowURL);
        
        return strMap;
    }
    
     @AuraEnabled
    public static Map<string,string> GetMemberSSN(string accId)
    {
        Account acc = [select id, Name,PersonID__c from Account where id=:accId];
        
        string personId=acc.PersonID__c;
        
        System.debug('PersonId:'+personId);
        Map<string,string> strMap = new  Map<string,string>();
        strMap.put('SSN',personId.substring(1, personId.length()));
        
        WiresBranchFlowURL__c wofu = WiresBranchFlowURL__c.getValues('WiresOnlineFlowURL');
        string onlineFlowURL=wofu.URL__c;
        strMap.put('OnlineFlowURL',onlineFlowURL);
        
        return strMap;
    }
}