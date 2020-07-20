@isTest
public class WarningCodeforAccountDetailsCtrlTest {
    
    static testMethod void testMethod1(){
        
        Account_Details__c accDetails = new Account_Details__c();
            accDetails.Name = 'test';
        insert accDetails;
        
        PageReference pageRef = Page.WarningCodeforAccountDetails;
        Test.setCurrentPage(pageRef);   
        WarningCodeforAccountDetailsController controller = new WarningCodeforAccountDetailsController(new ApexPages.StandardController(accDetails));
        controller.mainMethod();
    }
}