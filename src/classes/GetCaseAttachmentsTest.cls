@isTest
private class GetCaseAttachmentsTest {
	
static testMethod void testMethod1() {
	 Account acobj = new Account();
        acobj.FirstName = 'U';
        acobj.LastName = 'D';
        acobj.BIRTH_DATE__pc = date.parse('04/04/1963');
        acobj.Employee_Restricted_Access__c = 1234;
        acobj.Home_Phone__pc = '9169954478';
        insert acobj;
        
        Case case1 = new Case();
        case1.Subject = 'Test';
        case1.Description = 'test';
        case1.Accountid = acobj.Id;
        case1.Brand__c ='Spectrum';
        insert case1;
        
        Member_Comment__c mobj = new Member_Comment__c(Case__c = case1.Id, Draft__c = true, Member_Communication__c= 'test', Member_Email__c= 'sshah@affirma.com');
      	insert mobj;
        
         Attachment objAt = new Attachment(Name ='NewFile.jpg',body = blob.valueof('TWFuIGlzIGRpc3Rpg'),parentId = mobj.Id, ContentType = 'JPG');
        Insert objAt;
        
         
         ContentVersion contentVersion = new ContentVersion(
		      Title = 'Penguins',
		      PathOnClient = 'Penguins.jpg',
		      VersionData = Blob.valueOf('Test Content'),
		      IsMajorVersion = true
		    );
		    insert contentVersion;  
		    
		    	ContentDocumentLink cdl = new ContentDocumentLink();
			cdl.ContentDocumentId = [SELECT Id, ContentDocumentId FROM ContentVersion WHERE Id =: contentVersion.Id].ContentDocumentId;
			cdl.LinkedEntityId = mobj.Id;
			cdl.ShareType = 'V';
			insert cdl;  
        
         Test.StartTest();

         GetCaseAttachments.GetCaseAttachments(case1.id);	        
	      
        Test.StopTest();
	    }
    
}