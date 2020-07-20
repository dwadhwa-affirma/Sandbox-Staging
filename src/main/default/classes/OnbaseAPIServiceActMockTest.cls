@isTest
private class OnbaseAPIServiceActMockTest {
      
   @isTest static void testCallout(){
      
       Test.setMock(HttpCalloutMock.class, new OnbaseApiMockHttpResponse());
     
          // Create an acct
           Account_Details__c act = new Account_Details__c();
           act.Name = '111';
           //cs.Primary_Category__c = 'Shared Branch';
        insert act;
        
       pagereference pr = page.OnbaseApiServiceActVF;
       test.setCurrentPage(pr);
       ApexPages.currentPage().getParameters().put('id',act.id);
       
       
    test.startTest();
       ApexPages.StandardController stdController = new ApexPages.StandardController(act);
      OnbaseApiServiceActController  ext = new OnbaseApiServiceActController (stdController );
     OnbaseApiServiceActController.wrapDocument p = new OnbaseApiServiceActController.wrapDocument();
     p.actNum = act.Name;
     p.docName ='Test';
     p.docType ='.pdf';
     p.docNumber = '123'  ;
     p.popDocUrl = 'http'  ;
       
     test.stopTest();
    

        
    
}

}