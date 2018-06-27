@isTest
private class PublishMemberAttachmentsTest
{
	//Initial Test Data
	//Add Logic to Create data required
	@testSetup
	static void SetUp(){
		test.StartTest();
		 Account_Details__c  act = new Account_Details__c(Name = '0000147163', Balance__c = 0.00, Combined_Account_ID__c = '0000147163S0100P0100', ID1__c = '0100', Onboarded__c = true, RecType__c = 'ACCT', TypeTranslate__c = '1-PRIMARY SHARE');
		Insert act;
		
		Case caseObj =new Case(Status = 'In Process', Origin = null, Subject = 'Test', ClosedDate = null, IsEscalated = false,Account_Number__c = act.Id, Additional_Documents__c = false, Staff_Escalated__c = false, Five_Day_Flag__c = false, IsMarkDeleted__c = false, IsMarkRead__c = false, IsMarkSaved__c = false, Primary_Category__c = 'Account Maintenance', Secondary_Category__c = 'Account Services', Tertiary_Category__c = 'Extended Check Hold', MaritzCX__Response_Deleted_From_MaritzCX__c = false, SLATemp__c = false);
      	Insert caseObj;
      	
      	List<Attachment> lstAt = new List<Attachment>{new Attachment(Name ='NewFile.jpg',body = blob.valueof('TWFuIGlzIGRpc3Rpg'),parentId = caseObj.Id, ContentType = 'JPG'),
      												  new Attachment(Name ='NewFile1.jpg',body = blob.valueof('TWFuIGlzIGRpc3Rpg'),parentId = caseObj.Id, ContentType = 'JPG'),
      												  new Attachment(Name ='NewFile2.jpg',body = blob.valueof('TWFuIGlzIGRpc3Rpg'),parentId = caseObj.Id, ContentType = 'JPG')};
        Insert lstAt;
        
        
        Blob beforeblob=Blob.valueOf('TWFuIGlzIGRpc3Rpg');

        List<ContentVersion> cv = new List<ContentVersion>{new ContentVersion(Title = 'Test',PathOnClient ='Test.jpg',VersionData =beforeblob), new ContentVersion(Title = 'Test1',PathOnClient ='Test1.jpg',VersionData =beforeblob)};      
        insert cv;         

        List<ContentVersion> lstContent = [SELECT id, ContentDocumentId FROM ContentVersion where Id IN: cv];
        List<ContentDocumentLink> lstContentDocumentLink = new List<ContentDocumentLink>();
        for (ContentVersion testcontent : lstContent)
		{
        	ContentDocumentLink contentlink=new ContentDocumentLink();
        	contentlink.LinkedEntityId=caseObj.Id;
        	contentlink.ShareType= 'V';
        	contentlink.ContentDocumentId=testcontent.ContentDocumentId;
        	lstContentDocumentLink.add(contentlink);
		}
        insert lstContentDocumentLink;
      
      List<Approve_Attachment__c> lstApprovedAttchment = new List<Approve_Attachment__c>{new Approve_Attachment__c(Case_ID__c = caseObj.Id,Attachment_Id__c = lstAt[0].Id,Approved_By__c=UserInfo.getUserId(),Attachment_Name__c=lstAt[0].Name,Approved_Date_Time__c = system.now()),new Approve_Attachment__c(Case_ID__c = caseObj.Id,ContentDocumentLinkId__c = lstContentDocumentLink[0].Id,Approved_By__c=UserInfo.getUserId(),Attachment_Name__c=lstAt[0].Name,Approved_Date_Time__c = system.now())};
     
        Insert lstApprovedAttchment;
        
        test.StopTest();
	}
	
	// Test Method: getAttachmentData
	public static testmethod void Test_getAttachmentData(){
		Case objCase = [select Id from Case limit 1];
		// TODO : Change following Assert Statement
		System.Assert(publishMemberAttachments.getAttachmentData(objCase.Id) != null);
	}
	
	// Test Method: saveAttachments
	public static testmethod void Test_saveAttachments(){
		Case objCase = [select Id from Case limit 1];
		List<Attachment> attachContent = [select Id,Name,ContentType from Attachment limit 2];
		List<ContentDocumentLink> documentContent = [select Id,ContentDocumentId, ContentDocument.Title, ContentDocument.FileType from ContentDocumentLink where LinkedEntityId =: objCase.Id limit 2];
		List<Id> approvalids = new List<Id>();
		approvalids.add(attachContent[0].Id);
		approvalids.add(documentContent[0].Id);
		
        publishMemberAttachments.combinedAttachments obj = new publishMemberAttachments.combinedAttachments();
            	obj.Id = attachContent[1].id;
            	obj.Name = attachContent[1].Name;
            	obj.ContentType = attachContent[1].ContentType;
            	obj.isContentDocument = false;
            	obj.downloadLink = '/servlet/servlet.FileDownload?file='+ string.valueOf(attachContent[1].Id)  +'&operationContext=S1';
            	
         publishMemberAttachments.combinedAttachments obj1 = new publishMemberAttachments.combinedAttachments();
            	obj1.Id = documentContent[1].id;
            	obj1.Name = documentContent[1].ContentDocument.Title;
            	obj1.ContentType = documentContent[1].ContentDocument.FileType;
            	obj1.isContentDocument = true;
            	obj1.downloadLink = '/sfc/servlet.shepherd/document/download/'+ string.valueOf(documentContent[1].ContentDocumentId)  +'&operationContext=S1';
            	            	
        List<publishMemberAttachments.attachmentWrapper> lstwrapper = new List<publishMemberAttachments.attachmentWrapper>();
        publishMemberAttachments.attachmentWrapper wrapper = new publishMemberAttachments.attachmentWrapper();
      	wrapper.attachmentobj = obj;
         wrapper.checkvalue = true;
        lstwrapper.add(wrapper);
        
        publishMemberAttachments.attachmentWrapper wrapper1 = new publishMemberAttachments.attachmentWrapper();
      	wrapper1.attachmentobj = obj1;
        wrapper1.checkvalue = false;
        lstwrapper.add(wrapper1);
		
		string wrapperstring = JSON.serialize(lstwrapper);
			
		// TODO : Add extra code to validate the method call
		publishMemberAttachments.saveAttachments(wrapperstring, objCase.Id, approvalids);
		
	}
}