public class WiresAccountNumber {
	
     @AuraEnabled
    public static Map<string,string> GetAccountNumber(string accdetailid)
    {
        Account_Details__c accdetailList = [select id, Name from Account_Details__c where id=:accdetailid];
        Map<string,string> strMap = new  Map<string,string>();
        strMap.put('AccountNumber',accdetailList.Name);
        return strMap;
    }
}