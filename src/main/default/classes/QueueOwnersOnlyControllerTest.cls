@isTest
public class QueueOwnersOnlyControllerTest {
    
    static testMethod void testMethod1(){
      
        Case c = new Case();

        PageReference pageRef = Page.QueueOwnersOnly;
        Test.setCurrentPage(pageRef);        
        QueueOwnersOnlyController controller = new QueueOwnersOnlyController();
        QueueOwnersOnlyController.QueueWrapper wrp = new QueueOwnersOnlyController.QueueWrapper(c);
        controller.editSelected();
        controller.getCase();
    }
}