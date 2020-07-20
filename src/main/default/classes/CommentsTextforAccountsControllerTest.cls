@isTest
public class CommentsTextforAccountsControllerTest {
    
    static testMethod void testMethod1(){
        
        Account_Details__c accDetails = new Account_Details__c();
           accDetails.Name = 'test';
        insert accDetails;
        
        PageReference pageRef = Page.CommentsTextforAccounts;
        Test.setCurrentPage(pageRef);    
        CommentsTextforAccountsController controller = new CommentsTextforAccountsController(new ApexPages.StandardController(accDetails)); 
        controller.mainMethod();
    }

}