@isTest

  private class OnBaseApiSecviceMockTest {
   @isTest static void testCallout(){
      
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