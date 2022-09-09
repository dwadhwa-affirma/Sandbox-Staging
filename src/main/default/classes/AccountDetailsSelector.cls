public class AccountDetailsSelector {
    
    public static List<Account_Details__c> getACCTAccDetails(Set<String> accNums) {
        
        return [SELECT Name,Id FROM Account_Details__c 
                WHERE Name =:accNums 
                AND RecType__c = 'ACCT'];
    }
}