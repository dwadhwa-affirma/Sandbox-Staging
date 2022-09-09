public class RecordTypeSelector {
    
    public static List<CaseRecordType__c> getCaseRecordTypeByPrimaryCat(string primaryCategory){
        return [SELECT RecordTypeId__c FROM CaseRecordType__c WHERE Primary_Category__c =:primaryCategory]; 
    }
    
    
}