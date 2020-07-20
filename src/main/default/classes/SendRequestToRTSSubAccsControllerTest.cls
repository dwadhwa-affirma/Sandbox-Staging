@isTest(SeeAllData=True)
public class SendRequestToRTSSubAccsControllerTest {

     static testMethod void testMethod1() {
    
         RecordType recTpe = [Select Id, Name from RecordType where Name='Card' and sObjectType = 'Account_Details__c' Limit 1];
       
         Account_Details__c accDetail = new Account_Details__c();
             accDetail.RecordTypeId = recTpe.Id; 
             accDetail.Combined_Account_ID__c = '0000018249C9821P0061';
        insert accDetail;
           
       PageReference pageRef = Page.SendRequestToRTSSubAccs;
       Test.setCurrentPage(pageRef);
       ApexPages.currentPage().getParameters().put('accNum', accDetail.Combined_Account_ID__c);  
   
       Test.startTest();
         Test.setMock(HttpCalloutMock.class, new MockClassSubAccs());
         SendRequestToRTSSubAccsController controller = new SendRequestToRTSSubAccsController();  
       Test.stopTest();
        
       controller.init();
   
     }  
    
    static testMethod void testMethod2(){
        
        RecordType recTpe = [Select Id, Name from RecordType where Name='Loan' and sObjectType='Account_Details__c' Limit 1];
         
         Account_Details__c accDetail = new Account_Details__c();
             accDetail.RecordTypeId = recTpe.Id;  
             accDetail.Combined_Account_ID__c = '0000018249L0100P0100';
        insert accDetail;
           
       PageReference pageRef = Page.SendRequestToRTSSubAccs;
       Test.setCurrentPage(pageRef);
       ApexPages.currentPage().getParameters().put('accNum', accDetail.Combined_Account_ID__c);  
   
       Test.startTest();
         Test.setMock(HttpCalloutMock.class, new MockClassSubAccsLoan());
         SendRequestToRTSSubAccsController controller = new SendRequestToRTSSubAccsController();  
       Test.stopTest();
        
       controller.init();
        
    }
    
    static testMethod void testMethod3(){
        
        RecordType recTpe = [Select Id, Name from RecordType where Name='Share' and sObjectType='Account_Details__c' Limit 1];
         
         Account_Details__c accDetail = new Account_Details__c();
             accDetail.RecordTypeId = recTpe.Id;
             accDetail.Combined_Account_ID__c = '0000018249L0100P0100';
         insert accDetail;
           
       PageReference pageRef = Page.SendRequestToRTSSubAccs;
       Test.setCurrentPage(pageRef);
       ApexPages.currentPage().getParameters().put('accNum', accDetail.Combined_Account_ID__c);  
   
       Test.startTest();
         Test.setMock(HttpCalloutMock.class, new MockClassSubAccsShare());
         SendRequestToRTSSubAccsController controller = new SendRequestToRTSSubAccsController();  
       Test.stopTest();
        
       controller.init();
        
    }
    
}