@isTest
public class LeadOwnersOnlyControllerTest {
    
    static testMethod void testMethod1(){
        
        Lead led = new Lead();
        
        Id g = [Select Id from Group where Type = 'Role' Limit 1].Id;
        
        PageReference pageRef = Page.LeadOwnersOnly;
        Test.setCurrentPage(pageRef);        
        LeadOwnersOnlyController controller = new LeadOwnersOnlyController();
        LeadOwnersOnlyController.QueueWrapper wrp = new LeadOwnersOnlyController.QueueWrapper(led);
        controller.editSelected1();
        controller.QueueCount();
    }

}