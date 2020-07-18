@isTest
public class CannedResponseAttachmentControllerTest {
	  public static testMethod void TestCannedResponseAttachment(){
		 List<Canned_Responses__c> crLst = new List<Canned_Responses__c>();
	        Canned_Responses__c cr = new Canned_Responses__c();        
	            cr.Primary_Lookup_Text__c  = 'Test';
	            cr.Secondary_Lookup_Text__c = 'Test';
	            cr.Tertiary_Lookup_Text__c = 'Test';
	            crLst.add(cr);
	            insert crLst;
	    
	    test.startTest();
	      Attachment objAt = new Attachment(Name ='NewFile.jpg',body = blob.valueof('TWFuIGlzIGRpc3Rpg'),parentId = cr.id, ContentType = 'JPG');
        	Insert objAt;
        	
	    	CannedResponseAttachmentController.GetCaseAttachments(cr.id);
	    	CannedResponseAttachmentController.DeleteAttachment(objAt.id);
	   	 test.stopTest();
	  }
    	
    
    
}