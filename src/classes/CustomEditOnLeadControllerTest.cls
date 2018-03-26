@isTest
public class CustomEditOnLeadControllerTest {
public static testmethod void testmethod1(){
       // Account acc = [Select Id from Account Where isPersonAccount = True Limit 1];
      /*  Account acc = new Account();
               acc.LastName = 'Test Last Name';
               acc.FirstName = 'Test First Name';
               acc.SSN_Last_4__pc = '1234';
             insert acc; */
    
        Lead led = new Lead();
              led.LastName = 'TestName';
              led.Brand__c = 'CFCU';
             insert led;
    
        PageReference pageRef = Page.CustomEditOnLead;
        Test.setCurrentPage(pageRef);
        ApexPages.currentPage().getParameters().put('ID', led.Id); 
        CustomEditOnLeadController controller = new CustomEditOnLeadController(new ApexPages.StandardController(led));
        controller.updateLead();
    }
    
}