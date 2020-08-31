@isTest
public class ContentDocumentLinkDeleteTest {
    public static testmethod void Test_getData(){
        ContentVersion contentVersion = new ContentVersion(
            Title = 'Penguins',
            PathOnClient = 'Penguins.jpg',
            VersionData = Blob.valueOf('Test Content'),
            IsMajorVersion = true
        );
        insert contentVersion;  
    	
        List<Account_Details__c> account_details_Obj = new List<Account_Details__c>{
            new Account_Details__c(Name = '0000147163', Balance__c = 0.00, Combined_Account_ID__c = '0000147163S0100P0100', ID1__c = '0100', Onboarded__c = true, RecType__c = 'ACCT', TypeTranslate__c = '1-PRIMARY SHARE',WARNING_01_CODE__c='ABC'),
                new Account_Details__c(Name = '0000147163', Balance__c = 0.00, Combined_Account_ID__c = '0000147163S0100P0100', ID1__c = '0100', Onboarded__c = true, RecType__c = 'SHAR', TypeTranslate__c = '1-PRIMARY SHARE',WARNING_01_CODE__c='ABC'),
                new Account_Details__c(Name = '0000147163', Balance__c = 0.00, Combined_Account_ID__c = '0000147163S0100P0100', ID1__c = '0100', Onboarded__c = true, RecType__c = 'CARD', TypeTranslate__c = '1-PRIMARY SHARE',WARNING_01_CODE__c='ABC')};
                    
                    
        Insert account_details_Obj;
		
      Lead ld = new Lead ();
      ld.LastName = 'Test';
      ld.Email = 'test@gmail.com';
      ld.Product_Type__c = 'Misc';
      ld.Brand__c = 'Chevron';
      ld.FirstName = 'test';
      ld.LastName = 'New';    
      ld.MiddleName = 'New';
      ld.Description = 'New';
      ld.Salutation = 'MR.';
      ld.Suffix = 'MR'; 
      ld.Status = 'New';
      ld.Phone= '1234567890';
      ld.Email='test@test.com';
      ld.MobilePhone='1234567892';
      ld.How_did_you_hear_about_us__c='Website';
      ld.Event_Source__c='Event-Reston-Open House-04/20/18';
      ld.LeadSource='BDO-Realtor Referral';
      ld.Product_Type__c ='Mortgage';
      ld.Product_Subtype__c='Purchase';
      ld.Street_Address_1__c='Address 1';
      ld.State__c= 'NY';
      ld.Zip_Code__c= '12345';
      ld.City__c='NYC';
      ld.Country__c ='USA';    
      insert ld;
        
      ContentVersion content=new ContentVersion(); 
      content.Title='Header_Picture1'; 
      content.PathOnClient='/' + content.Title + '.jpg'; 
      Blob bodyBlob=Blob.valueOf('Unit Test ContentVersion Body'); 
      content.VersionData=bodyBlob; 
      //content.LinkedEntityId=sub.id;
      content.origin = 'H';
      insert content;  
    
      ContentDocumentLink contentlink=new ContentDocumentLink();
      contentlink.LinkedEntityId=ld.id;
      contentlink.contentdocumentid=[select contentdocumentid from contentversion where id =: content.id].contentdocumentid;
      contentlink.ShareType = 'V';
      insert contentlink;  
      
      Test.startTest();
      ld.Status = 'Closed - Converted';  
      update ld;		
    		
      Account account_Obj = new Account(LastName = 'BANDATest', FirstName = 'MARIATest', Type = 'null', PersonHasOptedOutOfEmail = false, NA_Eligibility__c = false, NA_LEAV_Complete__c = true, NA_LECF_Complete__c = true, NA_LECP_Complete__c = true, NA_LEEM_Complete__c = true, NA_LEHS_Complete__c = true, NA_LEMD_Complete__c = false, NA_LEMP_Complete__c = false, NA_LEMQ_Complete__c = true, NA_LEOL_Complete__c = true, NA_LEOM_Complete__c = true, NA_LEPT_Complete__c = true, NA_LESB_Complete__c = false, NA_LESF_Complete__c = true, NA_LEWS_Complete__c = true, NA_Opt_Out__c = false, smagicinteract__SMSOptOut__pc = false, et4ae5__HasOptedOutOfMobile__pc = false);
      Insert account_Obj; 
    
    Account_Details__c obj = [select id from Account_Details__c limit 1];
    
    	List<Person_Account__c> person_obj= new List<Person_Account__c>{new Person_Account__c(Account_Number__c = obj.Id, PersonID__c = account_Obj.Id), new Person_Account__c(Account_Number__c = account_details_Obj[1].Id, PersonID__c = account_Obj.Id), new Person_Account__c(Account_Number__c = account_details_Obj[2].Id, PersonID__c = account_Obj.Id)};
		     Insert person_obj;
		     
		Account account_Obj1 = new Account(LastName = 'BANDATest1', FirstName = 'MARIATest1', Type = 'null', PersonHasOptedOutOfEmail = false, NA_Eligibility__c = false, NA_LEAV_Complete__c = true, NA_LECF_Complete__c = true, NA_LECP_Complete__c = true, NA_LEEM_Complete__c = true, NA_LEHS_Complete__c = true, NA_LEMD_Complete__c = false, NA_LEMP_Complete__c = false, NA_LEMQ_Complete__c = true, NA_LEOL_Complete__c = true, NA_LEOM_Complete__c = true, NA_LEPT_Complete__c = true, NA_LESB_Complete__c = false, NA_LESF_Complete__c = true, NA_LEWS_Complete__c = true, NA_Opt_Out__c = false, smagicinteract__SMSOptOut__pc = false, et4ae5__HasOptedOutOfMobile__pc = false);
    Insert account_Obj1; 
    		
		List<Case> case_Obj = new List<Case>{
		    new Case(Status = 'In Process', Origin = null, Subject = 'Test', ClosedDate = null, IsEscalated = false, AccountId = account_Obj.Id, Account_Number__c = account_details_Obj[0].Id, Additional_Documents__c = false, Staff_Escalated__c = false, Five_Day_Flag__c = false, IsMarkDeleted__c = false, IsMarkRead__c = false, IsMarkSaved__c = false, Primary_Category__c = 'Account Maintenance', Secondary_Category__c = 'Account Services', Tertiary_Category__c = 'Extended Check Hold', MaritzCX__Response_Deleted_From_MaritzCX__c = false, SLATemp__c = false)
		    
                };                
				    Insert case_Obj;
    	
    	
    Approve_Attachment__c ap = new Approve_Attachment__c();
		ap.Attachment_Name__c = 'test';
		ap.Case_ID__c = case_Obj[0].id;
		insert ap;
		
		ContentDocumentLink cdl = new ContentDocumentLink();
			cdl.ContentDocumentId = [SELECT Id, ContentDocumentId FROM ContentVersion WHERE Id =: contentVersion.Id].ContentDocumentId;
			cdl.LinkedEntityId = ap.id;
			cdl.ShareType = 'V';
			insert cdl;
			

		ap.ContentDocumentLinkId__c = cdl.id;
    	update ap;
    	
    	delete cdl;
    	test.stopTest();
    }
}