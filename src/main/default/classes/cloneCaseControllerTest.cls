@isTest
private class cloneCaseControllerTest
{
    @testSetup
	static void setupTestData(){
    
        String uid = UserInfo.getUserId();
        RecordType recordtype =[SELECT Id,Name FROM RecordType WHERE Name='Person Account'];
        User currentUser = [SELECT LocaleSidKey, LanguageLocaleKey, TimeZoneSidKey, EmailEncodingKey FROM User WHERE Id=:uid];    
        
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
              
        string fid ='0000999999'  ;    
      
        Account acc = new Account();
        acc.Owner = currentUser;
        acc.FirstName = 'tFName';
        acc.LastName='TLName';
        acc.recordtypeid = recordtype.Id;
        acc.PersonID__C ='V554870800';
        acc.PersonEmail ='acctest@test.com';
        insert acc;
        
        List<Account_Details__c> Account_Details = new List<Account_Details__c>();
        Account_Details__c ad = new Account_Details__c();
        ad.Name = fid;
        Account_Details.add(ad);
        insert Account_Details;
         
        Person_Account__c pa = new Person_Account__c();
        pa.Account_Number__c = ad.id;
        pa.Name_Type__c = 0;
        pa.PersonID__c = acc.Id;
        insert pa;
        
        Case cas = new Case();
        cas.Subject = 'Test Subject Inquires';
        cas.Description = 'Test Description Inquires';
        cas.Account_Number__c = pa.Account_Number__c;
        cas.AccountID = acc.ID;
        cas.Primary_Category__c = 'Account Maintenance';
        cas.Secondary_Category__c = 'Memberships';
        cas.Tertiary_Category__c = 'Loan in Progress - New Membership';
        cas.Brand__c = 'CFCU';
        cas.Status ='Open';
        cas.LTK__c = '1111';
        
        insert cas;
      
        List<Attachment> AttachmentLst = new List<Attachment>();
       
        for(integer i=0 ; i <= 0 ; i++){
            Attachment attach=new Attachment();    
            attach.Name='Unit Test Attachment';
            Blob bodyBlob=Blob.valueOf('Unit Test Attachment Body');
            attach.body=bodyBlob;
            attach.parentId=cas.id;
            AttachmentLst.add(attach);
        } 
        insert AttachmentLst;
          
 	    List<Member_Comment__c> memberComments = new List<Member_Comment__c>();
       
        for(integer i=0 ; i <= 0 ; i++){
            Member_Comment__c mcom=new Member_Comment__c();    
            mcom.Case__c = cas.id;
            mcom.Case_Creator_Email__c = 'test@test.com';
            //mcom.Status__c = 'New';
            mcom.Member_Comment__c= 'test 123';
            mcom.Member_Communication__c= 'Test asdfafadaf';
            mcom.Member_Email__c= 'test@test.com';
            mcom.IsMarkRead__c = false ;
            
            mcom.Device_Type__c = 'New';
            mcom.IsRead__c = false;
            
            
            memberComments.add(mcom);
        } 
        insert memberComments;
    
        List<CaseComment> listCaseComments = new List<CaseComment>();
        
        for(integer i=0 ; i <= 0 ; i++){
            CaseComment caseComments=new CaseComment();    
            caseComments.ParentId  = cas.id;
            caseComments.IsPublished = true;
            caseComments.CommentBody = 'ABC';
            listCaseComments.add(caseComments);
        }
        Test.startTest();
        insert listCaseComments;
       
        
        Blob beforeblob=Blob.valueOf('TWFuIGlzIGRpc3Rpg');
        List<ContentVersion> cv = new List<ContentVersion>{new ContentVersion(Title = 'Test',PathOnClient ='Test.jpg',VersionData =beforeblob), new ContentVersion(Title = 'Test1',PathOnClient ='Test1.jpg',VersionData =beforeblob)};      
        insert cv;         

        List<ContentVersion> lstContent = [SELECT id, ContentDocumentId FROM ContentVersion where Id IN: cv];
        List<ContentDocumentLink> lstContentDocumentLink = new List<ContentDocumentLink>();
        for (ContentVersion testcontent : lstContent)
		{
        	ContentDocumentLink contentlink=new ContentDocumentLink();
        	contentlink.LinkedEntityId=cas.Id;
        	contentlink.ShareType= 'V';
        	contentlink.ContentDocumentId=testcontent.ContentDocumentId;
        	lstContentDocumentLink.add(contentlink);
		} 
        
        //insert lstContentDocumentLink;
        Test.stopTest();  
        
          }
	// Test Method: cloneCaseInsertUpdate
	public static testmethod void Test_cloneCaseInsertUpdate(){
        
        Test.startTest();
		List<Case> obj = [select id from Case limit 1];
        string recordid = obj[0].id;
		boolean subject = true;
		boolean description = true;
		boolean device_type = true;
		boolean status = true;
		boolean cat = true;
		boolean membercomment = true;
		boolean casecomment = true;
		boolean attachment = false;
       
		cloneCaseController.cloneCaseInsertUpdate(recordid, subject, description, device_type, status, cat, membercomment, casecomment, attachment);
 	 	Test.stopTest();
    }
	public static testmethod void Test_cloneCaseInsertUpdate1(){
        
		List<Case> obj = [select id from Case limit 1];
        string recordid = obj[0].id;
		boolean subject = true;
		boolean description = true;
		boolean device_type = true;
		boolean status = true;
		boolean cat = true;
		boolean membercomment = true;
		boolean casecomment = true;
		boolean attachment = true;
       
        Attachment attach=new Attachment();    
        attach.Name='Unit Test Attachment';
        Blob bodyBlob=Blob.valueOf('Unit Test Attachment Body');
        attach.body=bodyBlob;
        attach.parentId=recordid;
        //insert attach;
        
        Test.startTest();
		cloneCaseController.cloneCaseInsertUpdate(recordid, subject, description, device_type, status, cat, membercomment, casecomment, attachment);
 	 	Test.stopTest();
    }	 
		
		
}