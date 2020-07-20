@isTest(SeeAllData=True)
public class SendRequestToOnBaseControllerTest {
       
    static testMethod void testMethod1() {
        
        Account_Details__c accDetail = new Account_Details__c();
           accDetail.Name = '0000018249';
           //accDetail.Combined_Account_ID__c = 'test';
        insert accDetail;
        
      //  PageReference pageRef = Page.SendRequestToRTS;
       // Test.setCurrentPage(pageRef);
      //  ApexPages.currentPage().getParameters().put('accNum', accDetail.Name);
        
        Test.startTest();
            Test.setMock(HttpCalloutMock.class, new MockClass());
            SendRequestToOnBaseController controller = new SendRequestToOnBaseController();
        Test.stopTest();     
    } 
}