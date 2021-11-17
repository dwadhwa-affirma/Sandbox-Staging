public class LocationTabController {
 
    @AuraEnabled(cacheable=true)
    public static List<Account> getLocations(Id accountId ) {
        
        System.debug('AccountId:'+accountId);
        return [SELECT id, Parent.Name,Type,SEG_Status__c,Total_Employees_At_Target_Location__c,Total_Employees_At_Target_Locationtext__c,Number_of_Locations__c,Location_Phone__c,Location_State__c,Location_City__c, Location_Country__c,Name FROM Account
                where RecordType.Name='SubAccount'and ParentId =:accountId ORDER BY Name ASC];    }
}