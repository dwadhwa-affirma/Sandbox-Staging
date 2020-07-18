@isTest
public class CustomEditOnCaseControllerTest {
    static testmethod void testmethod1(){
        //Account acc = [Select Id from Account Where isPersonAccount = True Limit 1];
      /*  Account acc = new Account();
               acc.LastName = 'Test Last Name';
               acc.FirstName = 'Test First Name';
               acc.SSN_Last_4__pc = '1234';
             insert acc; */
        Create_SLA__c cl = new Create_SLA__c();
        cl.Status__c = 'Open';
        cl.Name = 'Open';
        cl.hours__c = 8;
        insert cl;
        
        Create_SLA__c cl1 = new Create_SLA__c();
        cl1.Status__c = 'In Process';
        cl1.Name = 'In Process';
        cl1.hours__c = 20;
        insert cl1;
        
        Create_SLA__c cl2 = new Create_SLA__c();
        cl2.Status__c = 'Resolution';
        cl2.Name = 'Resolution';
        cl2.hours__c = 20;
        insert cl2;
        
        Case cs = new Case();
           cs.Brand__c = 'CFCU';
        insert cs;
        
        PageReference pageRef = Page.CustomEditOnCase;
        Test.setCurrentPage(pageRef);
        ApexPages.currentPage().getParameters().put('ID', cs.Id); 
        CustomEditOnCaseController controller = new CustomEditOnCaseController(new ApexPages.StandardController(cs));
        controller.updateCase(); 
}
   
}