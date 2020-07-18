@IsTest
 public with sharing class CreateCaseTest {
	
	@IsTest 
	
	 public static void SaveCaseTest()
	{
		SecureEmailSetting__c customsetting;
    	customsetting = new SecureEmailSetting__c();
        customsetting.Name ='Secure Email Setting';
        customsetting.url_redirection_enabled__c = true;
        customsetting.spectrum_url__c = 'https://securemail.spectrumcu.org';
        customsetting.chevron_url__c = 'https://securemail.chevronfcu.org';
        customsetting.ProfileId__c = '00e63000000QHSa';
        customsetting.Chevron_KB__c = 'https://securemail.spectrumcu.org';
        customsetting.Spectrum_KB__c = 'https://securemail.spectrumcu.org';
        customsetting.List_of_Blocked_Extensions__c = 'css';
        insert customsetting;
        
        Excluded_Categories_in_Portal__c cs = new Excluded_Categories_in_Portal__c();	 	
		cs.Categories__c = 'Complaint,';	
		cs.Name = 'Primary'; 
		insert cs; 
        
		string fid ='0000999999'	;		
		 String uid = UserInfo.getUserId();
		 Profile profile = [SELECT Id,Name FROM Profile where Name ='Customer Community Login User' ];
		 RecordType recordtype =[SELECT Id,Name FROM RecordType WHERE Name='Person Account'];
		 User currentUser = [SELECT LocaleSidKey, LanguageLocaleKey, TimeZoneSidKey, EmailEncodingKey FROM User WHERE Id=:uid];
		 Site communityid = [SELECT Id FROM Site where Name ='customer_messaging_center'];
		 SamlSsoConfig samlSsoProviderId = [Select Id from SamlSsoConfig where DeveloperName='DI_SAML' ];
		 Boolean Create = true;
			
			// Creating  Account  
			List<Account> accounts = new List<Account>();
			Account acc = new Account();
			acc.Owner = currentUser;
			acc.FirstName = 'tFName';
			acc.LastName='TLName';
			acc.recordtypeid = recordtype.Id;
			acc.PersonID__C ='V554870800';
			
			acc.PersonEmail ='acctest@test.com';
			
			accounts.add(acc);
            insert accounts;
                     
            Contact c = [SELECT Id FROM Contact WHERE AccountId=:acc.Id];
          
      
           
          
        	
            // Creating new user
            List<User> users = new List<User>();
			User u = new User();
            u.Username = 'testUserName@test.com' ;
            u.FederationIdentifier =fid ;
            u.Email ='test@test.com' ;
            u.FirstName ='tFirstName' ;
            u.LastName ='tLastName' ;
            u.ProfileId = profile.Id;
            u.Alias ='tAlias';
           
          	u.LocaleSidKey = currentUser.LocaleSidKey;
            u.LanguageLocaleKey = currentUser.LanguageLocaleKey; 
            u.TimeZoneSidKey = currentUser.TimeZoneSidKey; 
            u.EmailEncodingKey = currentUser.EmailEncodingKey;
            u.ContactId = c.Id;
            users.add(u);
            insert users;
            
           // Creating Account_Details__c
            List<Account_Details__c> Account_Details = new List<Account_Details__c>();
            Account_Details__c ad = new Account_Details__c();
            ad.Name = fid;
            
            Account_Details.add(ad);
            insert Account_Details;
           // Creating  Person_Account__c
            
             List<Person_Account__c> Person_Account = new List<Person_Account__c>();
             Person_Account__c pa = new Person_Account__c();
             pa.Account_Number__c = ad.id;
             pa.Name_Type__c = 0;
             pa.PersonID__c = acc.Id;
             Person_Account.add(pa);
             insert Person_Account;
       
		system.runas(u)
			{
				CreateCaseController controller = new CreateCaseController();
 			 	controller.PageLoad();	
 			//	contactid = u.ContactId;
			//	List<Contact> contact = [SELECT AccountId, FirstName, LastName FROM Contact WHERE Id =:contactid];
			
				
				controller.csubject ='TestCaseSubject';
				controller.cdescription ='TestCaseDescription';
				controller.primaryCategory ='Online Banking';
				controller.BrandName ='Chevron';
				//controller.ImgPath ='logoorig.png';
				//controller.PageLoad();
						
				controller.SaveCase();
	    	}
	}
	
	public static testMethod void uploadFileTest() {
        //Split string 'file' in to two chunks, first chunk must be divisible by 3 for base64 encode with no padding
        
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
        
        Blob part1 = Blob.valueOf('This text re'); //length is 12 
        Blob part2 = Blob.valueOf('presents a dummy file');
                
        String part1base64 = EncodingUtil.base64Encode(part1);
        String part2base64 = EncodingUtil.base64Encode(part2);
        
        //Create a test accound the 'file' can be attached to.
       	Case cas = new Case();
		String contactid;
		
		string fid ='0000999999'	;		
		 String uid = UserInfo.getUserId();
		 Profile profile = [SELECT Id,Name FROM Profile where Name ='Customer Community Login User' ];
		 RecordType recordtype =[SELECT Id,Name FROM RecordType WHERE Name='Person Account'];
		 User currentUser = [SELECT LocaleSidKey, LanguageLocaleKey, TimeZoneSidKey, EmailEncodingKey FROM User WHERE Id=:uid];
		 Site communityid = [SELECT Id FROM Site where Name ='customer_messaging_center'];
		 SamlSsoConfig samlSsoProviderId = [Select Id from SamlSsoConfig where DeveloperName='DI_SAML' ];
		 Boolean Create = true;
			
			// Creating  Account  
			List<Account> accounts = new List<Account>();
			Account acc = new Account();
			acc.Owner = currentUser;
			acc.FirstName = 'tFName';
			acc.LastName='TLName';
			acc.recordtypeid = recordtype.Id;
			acc.PersonID__C ='V554870800';
			
			acc.PersonEmail ='acctest@test.com';
			
			accounts.add(acc);
            insert accounts;
                     
            Contact c = [SELECT Id FROM Contact WHERE AccountId=:acc.Id];
          
      
           
          
        	
            // Creating new user
            List<User> users = new List<User>();
			User u = new User();
            u.Username = 'testUserName@test.com' ;
            u.FederationIdentifier =fid ;
            u.Email ='test@test.com' ;
            u.FirstName ='tFirstName' ;
            u.LastName ='tLastName' ;
            u.ProfileId = profile.Id;
            u.Alias ='tAlias';
           
          	u.LocaleSidKey = currentUser.LocaleSidKey;
            u.LanguageLocaleKey = currentUser.LanguageLocaleKey; 
            u.TimeZoneSidKey = currentUser.TimeZoneSidKey; 
            u.EmailEncodingKey = currentUser.EmailEncodingKey;
            u.ContactId = c.Id;
            users.add(u);
            insert users;
		 	List<Account_Details__c> Account_Details = new List<Account_Details__c>();
            Account_Details__c ad = new Account_Details__c();
            ad.Name = fid;
            
            Account_Details.add(ad);
            insert Account_Details;
		
		List<User> us = [select ContactId FROM User WHERE id =:u.id];
		contactid = us[0].ContactId;
		List<Contact> contact = [SELECT AccountId, FirstName, LastName FROM Contact WHERE Id =:contactid];
		
		
				cas.Subject = 'TestCaseSubject';
				cas.Description = 'TestCaseSubject';
				cas.Account_Number__c = ad.id;
				cas.AccountID = acc.id;
				cas.Primary_Category__c = 'Online Banking';
				cas.Status ='Open';
        		cas.Device_Type__c ='Desktop';
				insert cas;
        
        //Start the test
        Test.startTest();
        //Send first part of the file to be uploaded
        String attachmentId = CreateCaseController.attachBlob(cas.Id,'','fileName','text',part1base64);
        
        //Send the second piece of the file to be uploaded
        CreateCaseController.attachBlob(cas.Id,attachmentId,'fileName','text',part2base64);
        Test.stopTest();
        
        //Assert one file has been attached to the test account
        List<Attachment> attachments = [select Id, Body from Attachment where ParentId = :cas.Id];
        system.assert(attachments.size() == 1);
        
        //Assert the contents of the split file were recontructed correctly
        system.assert(attachments[0].Body.toString() == 'This text represents a dummy file');
    }
    
}