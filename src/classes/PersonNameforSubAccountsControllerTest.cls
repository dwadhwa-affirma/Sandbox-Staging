@isTest
public class PersonNameforSubAccountsControllerTest {
    
    static testMethod void testMethod1(){
        
        Account_Details__c accDetails1 = new Account_Details__c();
            accDetails1.RecType__c = 'ACCT';
        insert accDetails1;
        
        Account_Details__c accDetails = new Account_Details__c();
            accDetails.Name = 'test';
            accDetails.RecType__c = 'CARD';
            accDetails.Parent_Account__c = accDetails1.Id;
        insert accDetails;
        
        PageReference pageRef = Page.PersonNameforSubAccounts;
        Test.setCurrentPage(pageRef);
        ApexPages.currentPage().getParameters().put('Id', accDetails.Id);        
        PersonNameforSubAccountsController controller = new PersonNameforSubAccountsController(new ApexPages.StandardController(accDetails));
    }

}