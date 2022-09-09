public class PersonAccountSelector {
		
     public static List<Person_Account__c> getACCTPersonAccByNumber(Set<String> accNums) {
        
        return [SELECT Account_Number__r.Name, PersonId__c, PersonId__r.FirstName, 
                PersonId__r.LastName, PersonId__r.MiddleName, Account_Number__c,
                PersonId__r.Residential_Street__pc, 
                PersonId__r.Residential_Extra_Address__pc, PersonId__r.Residential_City__pc,
                PersonId__r.Residential_State__pc, 
                PersonId__r.Residential_Country__pc, PersonId__r.Residential_Zipocde__pc 
                FROM Person_Account__c 
                WHERE Account_Number__r.Name =: accNums 
                AND Account_Number__r.RecType__c = 'ACCT'
                AND Name_Type__c = 0];
    }
}