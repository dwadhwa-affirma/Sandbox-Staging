@isTest(SeeAllData=True)
public class SendRequestToRTSControllerTest {
 
   static testMethod void testMethod1(){
        
        RecordType recTpe = [Select Id, Name from RecordType where SobjectType='Account_Details__c' AND Name = 'Membership' Limit 1];
       
        Account_Details__c accDetail = new Account_Details__c();
           accDetail.Name = '0000164414';
           accDetail.RecordTypeId = recTpe.Id;
        insert accDetail;
    
       PageReference pageRef = Page.SendRequestToRTS;
       Test.setCurrentPage(pageRef);
       ApexPages.currentPage().getParameters().put('accNum', accDetail.Name); 
   
       Test.startTest();
         Test.setMock(HttpCalloutMock.class, new MockClassAccs());
         SendRequestToRTSController controller = new SendRequestToRTSController();  
       Test.stopTest();
       
       controller.init();
    } 
}