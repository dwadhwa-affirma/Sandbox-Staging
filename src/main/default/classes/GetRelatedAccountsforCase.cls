public class GetRelatedAccountsforCase {
	
	@AuraEnabled 
    public static object GetCaseAccounts(string CaseId){
    	
    	 Case caseDetail = [select status, Attachments_Are_Deleted__c, Account_Number__c from Case where Id =: CaseId];
    	 set<id> accountIds = new set<id>();
    	 List<account_details__c> ListAccountsDetails = new List<account_details__c>(); 
    	 
    	 List<CaseAccountMemberDetail__c> relatedAccountsList = new List<CaseAccountMemberDetail__c>();
    	 
    	 relatedAccountsList= [select id, Case__c, Account_Name__c, MemberAccountid__c from CaseAccountMemberDetail__c where Case__c =:  CaseId and MemberAccountid__c !=: caseDetail.Account_Number__c];
    	 
    	 for(CaseAccountMemberDetail__c camd : relatedAccountsList){
    	 	accountIds.add(camd.MemberAccountid__c);
    	 }
    	 
    	 ListAccountsDetails = [select id, Name,RecordType.Name,Brand__c, TypeTranslate__c, RecType__c from account_details__c where id IN: accountIds];
    	 
    	 return ListAccountsDetails;
    
    }
    
}