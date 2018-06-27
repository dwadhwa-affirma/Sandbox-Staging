@isTest
private class MemberCommentsControllerTest
{
	//Initial Test Data
	//Add Logic to Create data required
	
	static void SetUp(){
		test.StartTest();
         Account_Details__c  act = new Account_Details__c(Name = '0000147163', Balance__c = 0.00, Combined_Account_ID__c = '0000147163S0100P0100', ID1__c = '0100', Onboarded__c = true, RecType__c = 'ACCT', TypeTranslate__c = '1-PRIMARY SHARE');
		Insert act;
        Case caseObj =new Case(Status = 'In Process', Origin = null, Subject = 'Test', ClosedDate = null, IsEscalated = false,Account_Number__c = act.Id, Additional_Documents__c = false, Staff_Escalated__c = false, Five_Day_Flag__c = false, IsMarkDeleted__c = false, IsMarkRead__c = false, IsMarkSaved__c = false, Primary_Category__c = 'Account Maintenance', Secondary_Category__c = 'Account Services', Tertiary_Category__c = 'Extended Check Hold', MaritzCX__Response_Deleted_From_MaritzCX__c = false, SLATemp__c = false);
      	Insert caseObj;
      	Member_Comment__c mobj = new Member_Comment__c(Case__c = caseObj.Id, Draft__c = true, Member_Communication__c= 'test', Member_Email__c= 'sshah@affirma.com');
      	insert mobj;
        List<Canned_Responses__c> Canned_primary = new List<Canned_Responses__c>{new Canned_Responses__c(Primary_Lookup_Text__c = 'ABC', Active__c = true, Brand__c ='chevron',Secondary_Lookup_Text__c= 'ABC2', Tertiary_Lookup_Text__c = 'ABC4',Description__c = 'test test test',Canned_Response_Title__c= 'test title'), new Canned_Responses__c(Primary_Lookup_Text__c = 'ABC1', Active__c = true, Brand__c = 'spectrum',Secondary_Lookup_Text__c= 'ABC3', Tertiary_Lookup_Text__c = 'ABC5',Description__c = 'test test test',Canned_Response_Title__c= 'test title1')};
		//Canned_Message_Metadata__c = new Canned_Message_Metadata__c(Chevron_Footer__c = 'test test', Chevron_Header__c = 'test test',Spectrum_Footer__c = 'test test',Spectrum_Header__c = 'test test');
		Insert Canned_primary;
       Attachment objAt = new Attachment(Name ='NewFile.jpg',body = blob.valueof('TWFuIGlzIGRpc3Rpg'),parentId = caseObj.Id, ContentType = 'JPG');
        Insert objAt;
        
         ContentVersion contentVersion = new ContentVersion(
		      Title = 'Penguins',
		      PathOnClient = 'Penguins.jpg',
		      VersionData = Blob.valueOf('Test Content'),
		      IsMajorVersion = true
		    );
		    insert contentVersion;  
		        
    
        
		Approve_Attachment__c obj = new Approve_Attachment__c();
        obj.Case_ID__c = caseObj.Id;
        obj.Attachment_Id__c = objAt.Id;
        obj.Approved_By__c = UserInfo.getUserId();
        obj.Attachment_Name__c = objAt.Name;
         obj.Approved_Date_Time__c = system.now();         
        Insert obj;
        
        
		    	ContentDocumentLink cdl = new ContentDocumentLink();
			cdl.ContentDocumentId = [SELECT Id, ContentDocumentId FROM ContentVersion WHERE Id =: contentVersion.Id].ContentDocumentId;
			cdl.LinkedEntityId = mobj.Id;
			cdl.ShareType = 'V';
			insert cdl;   
        
        obj = new Approve_Attachment__c();
         obj.Case_ID__c = caseObj.Id;
          obj.Attachment_Name__c = 'Penguins';
        obj.ContentDocumentLinkId__c = cdl.id;
         obj.Approved_Date_Time__c = system.now();       
        insert obj;
        
        Canned_Message_Metadata__c cannedMessageHeader = new Canned_Message_Metadata__c(Name='Metadata' ,Chevron_Footer__c = 'test test', Chevron_Header__c= 'test test', Spectrum_Footer__c= 'test test', Spectrum_Header__c= 'test test'); 
        Insert cannedMessageHeader;
	}
	//Tear Down 
	//Add Logic to delete data that has been created
	static void TearDown(){
		test.StopTest();
	}
	
	// Test Method: getBasicDetails
	public static testmethod void Test_getBasicDetails(){
		SetUp();
        Case caseObj = [select Id from case limit 1];
		// TODO : Change following Assert Statement
		System.Assert(MemberCommentsController.getBasicDetails(caseObj.Id) != null);
		List<publishMemberAttachments.attachmentWrapper> objAttachmentDetails = (	List<publishMemberAttachments.attachmentWrapper>)MemberCommentsController.getAttachmentDetails(caseObj.Id);
		
		for(publishMemberAttachments.attachmentWrapper ca: objAttachmentDetails){
						
			
				ca.checkvalue = true;
				
			            
        }
		MemberCommentsController.saveComment('ttest test', caseObj.Id, true, 'test@test.com', JSON.serialize(objAttachmentDetails), true);
		
		Member_Comment__c mobj = [select Id from Member_Comment__c limit 1];
		MemberCommentsController.getBasicDetails(mobj.Id);
		objAttachmentDetails = (List<publishMemberAttachments.attachmentWrapper>)MemberCommentsController.getAttachmentDetails(mobj.Id);
		system.debug('objAttachmentDetails###' + objAttachmentDetails);
		for(publishMemberAttachments.attachmentWrapper ca: objAttachmentDetails){
				ca.checkvalue = true;
        }
        MemberCommentsController.saveComment('ttest test', mobj.Id, true, 'test@test.com', JSON.serialize(objAttachmentDetails), true);
        for(publishMemberAttachments.attachmentWrapper ca: objAttachmentDetails){
				ca.checkvalue = false;
        }
        MemberCommentsController.saveComment('ttest test', mobj.Id, true, 'test@test.com', JSON.serialize(objAttachmentDetails), true);
		TearDown();
	}
	
	// Test Method: getAttachmentDetails
	public static testmethod void Test_getAttachmentDetails(){
		SetUp();
        Case caseObj = [select Id from Case limit 1];		
		// TODO : Change following Assert Statement
		System.Assert(MemberCommentsController.getAttachmentDetails(caseObj.Id) != null);
		TearDown();
	}
	

	// Test Method: getPrimaryData
	public static testmethod void Test_getPrimaryData(){
		SetUp();
		// TODO : Change following Assert Statement
		 string brand = 'chevron';       
		System.Assert(MemberCommentsController.getPrimaryData(brand) != null);     
		TearDown();
	}
	// Test Method: getSecondaryData
	public static testmethod void Test_getSecondaryData(){
		SetUp();
		 string brand = 'chevron';        
        string primary = 'ABC';
		// TODO : Change following Assert Statement
		System.Assert(MemberCommentsController.getSecondaryData(brand, primary) != null);
		TearDown();
	}
	// Test Method: getTertioryData
	public static testmethod void Test_getTertioryData(){
		SetUp();
		 string brand = 'chevron';
        string secondary = 'ABC2';
        string primary = 'ABC';
		// TODO : Change following Assert Statement
		System.Assert(MemberCommentsController.getTertioryData(brand, primary, secondary) != null);
		TearDown();
	}
	// Test Method: getItembySearchText
	public static testmethod void Test_getItembySearchText(){
		SetUp();
		string brand = 'chevron';
		string searchtext = 'ABC';
		// TODO : Change following Assert Statement
		System.Assert(MemberCommentsController.getItembySearchText(brand, searchtext) != null);
		TearDown();
	}
	// Test Method: getItembyCategories
	public static testmethod void Test_getItembyCategories(){
		SetUp();
		string brand = 'chevron';
		string selectedprimary = 'ABC';
		string selectedsecondary = 'ABC2';
		string selectedtertiary = 'ABC4';
		// TODO : Change following Assert Statement
		System.Assert(MemberCommentsController.getItembyCategories(brand, selectedprimary, '0', '0') != null);
        System.Assert(MemberCommentsController.getItembyCategories(brand, selectedprimary, selectedsecondary, '0') != null);
        System.Assert(MemberCommentsController.getItembyCategories(brand, selectedprimary, selectedsecondary, selectedtertiary) != null);
		TearDown();
	}
	// Test Method: getSelectedDecription
	public static testmethod void Test_getSelectedDecription(){
		SetUp();
		Canned_Responses__c obj_CannedRes = [select Id, Brand__c from Canned_Responses__c limit 1];
		string categoryid = obj_CannedRes.Id;
		string brand = obj_CannedRes.Brand__c;
		// TODO : Change following Assert Statement
		MemberCommentsController.getSelectedDecription(categoryid, 'chevron');
        MemberCommentsController.getSelectedDecription(categoryid, 'spectrum');
		//System.Assert(MemberCommentsController.getSelectedDecription(categoryid, 'chevron') == '');
        //System.Assert(MemberCommentsController.getSelectedDecription(categoryid, 'spectrum') == '');
		TearDown();
	}
	// Test Method: saveComment
	public static testmethod void Test_saveComment(){
		SetUp();
		string memberdescription = 'test test';
		string caseid = [select Id from case limit 1].Id;
		boolean draft = true;
		string secureemailaddress = 'test@test.com';
		string attachments = 'TWFuIGlzIGRpc3Rpg';
        
        Attachment attachContent = [select Id,Name,ContentType from Attachment limit 1];
        publishMemberAttachments.combinedAttachments obj = new publishMemberAttachments.combinedAttachments();
            	obj.Id = attachContent.id;
            	obj.Name = attachContent.Name;
            	obj.ContentType = attachContent.ContentType;
            	obj.isContentDocument = false;
            	obj.downloadLink = '/servlet/servlet.FileDownload?file='+ string.valueOf(attachContent.Id)  +'&operationContext=S1';            	
        List<publishMemberAttachments.attachmentWrapper> lstwrapper = new List<publishMemberAttachments.attachmentWrapper>();
        publishMemberAttachments.attachmentWrapper wrapper = new publishMemberAttachments.attachmentWrapper();
      wrapper.attachmentobj = obj;
         wrapper.checkvalue = true;
        lstwrapper.add(wrapper);
		// TODO : Add extra code to validate the method call
		MemberCommentsController.saveComment(memberdescription, caseid, draft, secureemailaddress, JSON.serialize(lstwrapper), true);
		MemberCommentsController.saveComment(memberdescription, caseid, draft, secureemailaddress, JSON.serialize(lstwrapper), true);
		
		
		 Attachment attachContent1 = [select Id,Name,ContentType from Attachment limit 1];
        publishMemberAttachments.combinedAttachments obj1 = new publishMemberAttachments.combinedAttachments();
            	obj1.Id = attachContent1.id;
            	obj1.Name = attachContent1.Name;
            	obj1.ContentType = attachContent1.ContentType;
            	obj1.isContentDocument = true;
            	obj1.downloadLink = '/servlet/servlet.FileDownload?file='+ string.valueOf(attachContent1.Id)  +'&operationContext=S1';            	
        List<publishMemberAttachments.attachmentWrapper> lstwrapper1 = new List<publishMemberAttachments.attachmentWrapper>();
        publishMemberAttachments.attachmentWrapper wrapper1 = new publishMemberAttachments.attachmentWrapper();
      wrapper1.attachmentobj = obj1;
         wrapper1.checkvalue = true;
        lstwrapper1.add(wrapper1);
		MemberCommentsController.saveComment(memberdescription, caseid, draft, secureemailaddress, JSON.serialize(lstwrapper1), true);
		MemberCommentsController.saveComment(memberdescription, caseid, draft, secureemailaddress, JSON.serialize(lstwrapper1), true);
		
		 attachContent1 = [select Id,Name,ContentType from Attachment limit 1];       
            	obj1.Id = attachContent1.id;
            	obj1.Name = attachContent1.Name;
            	obj1.ContentType = attachContent1.ContentType;
            	obj1.isContentDocument = true;
            	obj1.downloadLink = '/servlet/servlet.FileDownload?file='+ string.valueOf(attachContent1.Id)  +'&operationContext=S1';            	
       
      
      wrapper1.attachmentobj = obj1;
         wrapper1.checkvalue = false;
        lstwrapper1.add(wrapper1);
		MemberCommentsController.saveComment(memberdescription, caseid, draft, secureemailaddress, JSON.serialize(lstwrapper1), true);
		MemberCommentsController.saveComment(memberdescription, caseid, draft, secureemailaddress, JSON.serialize(lstwrapper1), true);
		
		
		
		
		TearDown();
	}
	
	
}