@isTest
public class PersonNameControllerTest {
    static testMethod void testMethod1(){
        Account_Details__c accDetails = new Account_Details__c();
        PageReference pageRef = Page.PersonName;
        Test.setCurrentPage(pageRef);
        ApexPages.currentPage().getParameters().put('ID', accDetails.Id); 
        PersonNameController controller = new PersonNameController(new ApexPages.StandardController(accDetails));
    }
}