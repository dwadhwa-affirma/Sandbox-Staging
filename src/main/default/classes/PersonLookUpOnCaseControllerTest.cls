@isTest
public class PersonLookUpOnCaseControllerTest {
    
    static testMethod void testMethod1(){
        
        Account acc = new Account();
        
        Account_Details__c accDetails = new Account_Details__c();
            accDetails.Name = 'test';
        insert accDetails;
        
        Person_Account__c pa = new Person_Account__c();
            pa.PersonID__c = acc.Id;
            pa.Account_Number__c = accDetails.Id;
        insert pa;
        
        PageReference pageRef = Page.PersonLookUpOnCase;
        Test.setCurrentPage(pageRef);
        ApexPages.currentPage().getParameters().put('accId', accDetails.Id);        
        PersonLookUpOnCaseController controller = new PersonLookUpOnCaseController(new ApexPages.StandardController(acc)); 
    }
    
    static testMethod void PersonLookUpOnCaseSubAccsTest(){
        
        Account acc = new Account();
        
        Account_Details__c accDetails = new Account_Details__c();
            accDetails.Name = 'test';
            accDetails.RecType__c = 'ACCT';
        insert accDetails;
        
        Account_Details__c accDetails1 = new Account_Details__c();
            accDetails1.RecType__c = 'CARD';
            accDetails1.Parent_Account__c = accDetails.Id;
        insert accDetails1;
        
        Person_Account__c pa = new Person_Account__c();
            pa.PersonID__c = acc.Id;
            pa.Account_Number__c = accDetails.Id;
        insert pa;
        
        PageReference pageRef = Page.PersonLookUpOnCaseSubAccs;
        Test.setCurrentPage(pageRef);
        ApexPages.currentPage().getParameters().put('accId', accDetails1.Id);        
        PersonLookUpOnCaseSubAccsController controller = new PersonLookUpOnCaseSubAccsController(new ApexPages.StandardController(acc));        
    }
}