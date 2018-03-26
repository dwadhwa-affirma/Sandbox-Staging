@isTest
public class CustomEditOnCaseControllerTest {
    static testmethod void testmethod1(){
        //Account acc = [Select Id from Account Where isPersonAccount = True Limit 1];
      /*  Account acc = new Account();
               acc.LastName = 'Test Last Name';
               acc.FirstName = 'Test First Name';
               acc.SSN_Last_4__pc = '1234';
             insert acc; */
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