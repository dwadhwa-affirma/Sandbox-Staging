public class MemberNumberLightningController{
	
	@AuraEnabled   
    public static List<Person_Account__c> FetchAccounts(string searchText)
    {
    	List<Person_Account__c> accDetails = new List<Person_Account__c>();
        searchText = searchText.trim();
        
        system.debug('searchText::::'+searchText);        
       
        string genQuery = 'SELECT Id, PersonId__r.Name , Split_Type_Translate__c, Account_Number__r.TypeTranslate__c, Name_Type__c, Account_Number__r.ID1__c FROM Person_Account__c WHERE';
        string whereQuery;
        if(searchText != ''){
            if(whereQuery!=NULL){
                whereQuery = whereQuery+ 'AND Account_Number__r.Name LIKE \''+searchText+'\'';
            }else{
                integer i;
                integer membersize = searchText.length();
                for(i=membersize; i<10;i++){
                searchText = '0'+searchText;
              }
                whereQuery = ' (Account_Number__r.Name LIKE \''+searchText+'\' OR Account_Number__r.Parent_Account__r.Name LIKE \''+searchText+'\') AND Split_Type_Translate__c IN(\'Primary\',\'Joint Member\',\'Joint Owner\',\'Power of Attorney\',\'Trustee\',\'Authorized Signer\',\'Representative Payee\',\'Custodian\',\'Responsible Individual\') ORDER BY Name_Type__c ASC NULLS LAST ' ;
            }
        }
        
        if(whereQuery!=NULL){
            string totalQuery = genQuery+whereQuery+'LIMIT 100';
            system.debug('TotalQuery'+totalQuery);
            accDetails = Database.query(totalQuery);          
        }   
        System.debug('Total Query is::::'+accDetails);
        
        return accDetails;
    }
	
}