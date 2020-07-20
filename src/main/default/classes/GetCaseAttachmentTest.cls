/**
 * This class contains unit tests for validating the behavior of Apex classes
 * and triggers.
 *
 * Unit tests are class methods that verify whether a particular piece
 * of code is working properly. Unit test methods take no arguments,
 * commit no data to the database, and are flagged with the testMethod
 * keyword in the method definition.
 *
 * All test methods in an organization are executed whenever Apex code is deployed
 * to a production organization to confirm correctness, ensure code
 * coverage, and prevent regressions. All Apex classes are
 * required to have at least 75% code coverage in order to be deployed
 * to a production organization. In addition, all triggers must have some code coverage.
 * 
 * The @isTest class annotation indicates this class only contains test
 * methods. Classes defined with the @isTest annotation do not count against
 * the organization size limit for all Apex scripts.
 *
 * See the Apex Language Reference for more information about Testing and Code Coverage.
 */
@isTest
private class GetCaseAttachmentTest {

    static testMethod void myUnitTest() {
       Test.startTest();

           Case cs = new Case();
              cs.Brand__c = 'CFCU';
       
            insert cs;
            
            Case cs1 = new Case();
              cs1.Brand__c = 'CFCU';
           
                insert cs1;
              
              List<Attachment> AttachmentLst = new List<Attachment>();
                for(integer i=0 ; i <= 5 ; i++){
                Attachment attach=new Attachment();    
                attach.Name='Unit Test Attachment';
                Blob bodyBlob=Blob.valueOf('Unit Test Attachment Body');
                attach.body=bodyBlob;
                attach.parentId= cs1.id;
                AttachmentLst.add(attach);
            }        
            insert AttachmentLst;   
             
		
		PageReference pageRef = Page.CaseAttachmentList;
		Test.setCurrentPage(pageRef); 
		 ApexPages.currentPage().getParameters().put('ID', cs1.Id);
		  
    		GetCaseAttachments controller = new GetCaseAttachments(new ApexPages.standardController(cs1)); 
    		
    		ApexPages.currentPage().getParameters().put('ID', cs.Id);
		  
    		controller = new GetCaseAttachments(new ApexPages.standardController(cs)); 
    		
    		
          
         Test.stopTest();
        
    }
}