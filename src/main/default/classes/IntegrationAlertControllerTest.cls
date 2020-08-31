@isTest
public class IntegrationAlertControllerTest {

    static testmethod void setupTestData(){
      	Test.startTest();
       	IntegrationAlertController myClass = new IntegrationAlertController();
        myclass.getshowList();
        Test.stopTest();
    }    
}