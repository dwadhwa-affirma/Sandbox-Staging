@isTest
private class ContentDocumentDeleteTest {

    static testMethod void ContentDocumentDeleteTriggerTest() {
         Account_Details__c  act = new Account_Details__c(Name = '0000147163', Balance__c = 0.00, Combined_Account_ID__c = '0000147163S0100P0100', ID1__c = '0100', Onboarded__c = true, RecType__c = 'ACCT', TypeTranslate__c = '1-PRIMARY SHARE');
		Insert act;
		
		Case caseObj =new Case(Status = 'In Process', Origin = null, Subject = 'Test', ClosedDate = null, IsEscalated = false,Account_Number__c = act.Id, Additional_Documents__c = false, Staff_Escalated__c = false, Five_Day_Flag__c = false, IsMarkDeleted__c = false, IsMarkRead__c = false, IsMarkSaved__c = false, Primary_Category__c = 'Account Maintenance', Secondary_Category__c = 'Account Services', Tertiary_Category__c = 'Extended Check Hold', MaritzCX__Response_Deleted_From_MaritzCX__c = false, SLATemp__c = false);
      	Insert caseObj;
        
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
      
      List<Approve_Attachment__c> lstApprovedAttchment = new List<Approve_Attachment__c>{new Approve_Attachment__c(Case_ID__c = caseObj.Id,ContentDocumentLinkId__c = lstContentDocumentLink[0].Id,Approved_By__c=UserInfo.getUserId(),Attachment_Name__c='Test.jpg',Approved_Date_Time__c = system.now())};
     
        Insert lstApprovedAttchment;
        
        list<ContentDocument> cd = [select Id from ContentDocument where Id =: lstContent[0].ContentDocumentId or Id=: lstContent[1].ContentDocumentId];
        delete cd;
    	        
    }
    
    
    static testMethod void ContentDocumentDeleteTriggerTest2() {
        
        List<Solar_Loans__c> SolarLoan_Obj = new List<Solar_Loans__c>{
        	new Solar_Loans__c(Member_Number__c = '0000265418', Site_UUID__c = '0064M00000XWR42QAH',Status__c = 'Completed', Brand__c = 'Spectrum', Primary_First_Name__c = 'Tania', Primary_Last_Name__c = 'Cabrera')};
     	Insert SolarLoan_Obj;
        
     	List<SolarLoan_Document__c> SolarLoanDocList = new List<SolarLoan_Document__c>{
        	 new SolarLoan_Document__c(Name = 'Test Document', NewFile__c = true,Solar_Loans__c = SolarLoan_Obj[0].id)};      
        insert SolarLoanDocList;
        
        Blob beforeblob=Blob.valueOf('TWFuIGlzIGRpc3Rpg');

        List<ContentVersion> cv = new List<ContentVersion>{new ContentVersion(Title = '1. Loan Agreement Package - Jinachandran Rajeshytre  Kochath Rajan456 - 0064M00000WBhfhQAD',PathOnClient ='Test.jpg',VersionData =beforeblob), new ContentVersion(Title = 'Test1',PathOnClient ='Test1.jpg',VersionData =beforeblob)};      
        insert cv;
        
        List<ContentVersion> lstContent = [SELECT id, ContentDocumentId FROM ContentVersion where Id IN: cv];
        List<ContentDocumentLink> lstContentDocumentLink = new List<ContentDocumentLink>();
        for (ContentVersion testcontent : lstContent)
		{
        	ContentDocumentLink contentlink=new ContentDocumentLink();
        	contentlink.LinkedEntityId=SolarLoan_Obj[0].Id;
        	contentlink.ShareType= 'V';
        	contentlink.ContentDocumentId=testcontent.ContentDocumentId;
        	lstContentDocumentLink.add(contentlink);
		}
        insert lstContentDocumentLink;
 
        list<ContentDocument> cd = [select Id from ContentDocument where Id =: lstContent[0].ContentDocumentId or Id=: lstContent[1].ContentDocumentId];
        delete cd;
    	        
    }
}