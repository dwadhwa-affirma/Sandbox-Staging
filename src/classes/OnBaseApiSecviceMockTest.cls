@isTest

  private class OnBaseApiSecviceMockTest {
   @isTest static void testCallout(){
      
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
             
       Test.setMock(HttpCalloutMock.class, new OnbaseApiMockHttpResponse());
     
          // Create a case
           Case cs = new Case();
           cs.Brand__c = 'CFCU';
           cs.Primary_Category__c = 'Shared Branch';
        insert cs;
        
       pagereference pr = page.OnbaseApiServiceVF;
       test.setCurrentPage(pr);
       ApexPages.currentPage().getParameters().put('id',cs.id);
       
       
    test.startTest();
       ApexPages.StandardController stdController = new ApexPages.StandardController(cs);
      OnbaseApiServiceController  ext = new OnbaseApiServiceController (stdController );
     OnbaseApiServiceController.wrapDocument p = new OnbaseApiServiceController.wrapDocument();
     p.caseNum = cs.CaseNumber;
     p.docName ='Test';
     p.docType ='.pdf';
     p.docNumber = '123'  ;
     p.popDocUrl = 'http'  ;
       
     test.stopTest();
    

    } 
    
    
}