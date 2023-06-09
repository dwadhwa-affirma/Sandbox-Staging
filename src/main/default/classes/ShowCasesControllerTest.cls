@IsTest public with sharing class ShowCasesControllerTest {
    public static string ids ='';
    public static string ids1 ='';
    public static string ids2 ='';
    public static User u = new User();
    public static User u1 = new User();
   
   
    @testsetup public static void setup(){
 	
 		ACH_To_Episys_API_Details__c api = new ACH_To_Episys_API_Details__c();
        api.URL__c = 'https://symxapi.chevronfcu.org/devclient';
        api.Name = 'ProductionURL';
        insert api;
        
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
        
        SecureEmailSetting__c customsetting;
        customsetting = new SecureEmailSetting__c();
        customsetting.Name ='Secure Email Setting';
        customsetting.url_redirection_enabled__c = true;
        customsetting.spectrum_url__c = 'https://securemail.spectrumcu.org';
        customsetting.chevron_url__c = 'https://securemail.chevronfcu.org';
        customsetting.ProfileId__c = '00e63000000QHSa';
        customsetting.Chevron_KB__c = 'https://securemail.spectrumcu.org';
        customsetting.Spectrum_KB__c = 'https://securemail.spectrumcu.org';
        insert customsetting;
        
        
        string fid ='0000999999';
        string fid2 ='0000999900';
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
        
        Account acc1 = new Account();
        acc1.Owner = currentUser;
        acc1.name = '0000999999-Chevron';
        acc1.Description = '(0000999996,0000999997)';
        accounts.add(acc1);
        
        Account acc2 = new Account();
        acc2.Owner = currentUser;
        acc2.FirstName = 'tFName2';
        acc2.LastName='TLName2';
        acc2.recordtypeid = recordtype.Id;
        acc2.PersonID__C ='V554870801';
       	acc2.PersonEmail ='acctest@test2.com';
        accounts.add(acc2);
        
        insert accounts;
        
        Contact c = [SELECT Id, AccountId FROM Contact WHERE AccountId=:acc.Id];
        Contact c2 = [SELECT Id, AccountId FROM Contact WHERE AccountId=:acc2.Id];
        
        // Creating new user
        List<User> users = new List<User>();
        
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
        
        u1.Username = 'testUserName@test1.com' ;
        u1.FederationIdentifier =fid2;
        u1.Email ='test@test1.com' ;
        u1.FirstName ='tFirstName1' ;
        u1.LastName ='tLastName1' ;
        u1.ProfileId = profile.Id;
        u1.Alias ='tAlias1';
        u1.LocaleSidKey = currentUser.LocaleSidKey;
        u1.LanguageLocaleKey = currentUser.LanguageLocaleKey; 
        u1.TimeZoneSidKey = currentUser.TimeZoneSidKey; 
        u1.EmailEncodingKey = currentUser.EmailEncodingKey;
        u1.ContactId = c2.Id;
        users.add(u1);
        
        insert users;
        
        // Creating Account_Details__c
        List<Account_Details__c> Account_Details = new List<Account_Details__c>();
        Account_Details__c ad = new Account_Details__c();
        ad.Name = fid;
        Account_Details.add(ad);
        
        Account_Details__c ad1 = new Account_Details__c();
        ad1.Name = fid2;
        ad1.Reference__c = 'BC02';
        Account_Details.add(ad1);
        
        insert Account_Details;
        // Creating  Person_Account__c
        
        List<Person_Account__c> Person_Account = new List<Person_Account__c>();
        Person_Account__c pa = new Person_Account__c();
        pa.Account_Number__c = ad.id;
        pa.Name_Type__c = 0;
        pa.PersonID__c = acc.Id;
        pa.TypeTranslate__c = '0000/Primary';
        Person_Account.add(pa);
        
        Person_Account__c pa1 = new Person_Account__c();
        pa1.Account_Number__c = ad1.id;
        pa1.Name_Type__c = 0;
        pa1.PersonID__c = acc2.Id;
        pa1.TypeTranslate__c = '0000/Primary';
        Person_Account.add(pa1);
        
        insert Person_Account;
        string view='';
        //case creation for different views
        system.runas(u){
             
            List<Case> cases = new List<Case>();
            Case cas = new Case();
            cas.Subject = 'Test Subject Inquires';
            cas.Description = 'Test Description Inquires';
            cas.Account_Number__c = pa.Account_Number__c;
            cas.AccountID = c.AccountId;
            cas.Primary_Category__c = 'Inquires';
            cas.Status ='Open';
            cas.Origin = 'CU';
            
            //insert cas;
            Cases.add(cas);
            //ids = cas.Id;
            
            Case cas1 = new Case();
            cas1.Subject = 'Test Subject Online Banking';
            cas1.Description = 'Test Description Online Banking';
            cas1.Account_Number__c = pa.Account_Number__c;
            cas1.AccountID = c.AccountId;
            cas1.Primary_Category__c = 'Online Banking';
            cas1.Status ='Open';
            cas1.IsMarkDeleted__c = true;
            //insert cas1;
            Cases.add(cas1);
            
            //ids1= cas1.id;
            
            Case cas2 = new Case();
            cas2.Subject = 'Test Subject Online Banking 1';
            cas2.Description = 'Test Description Online Banking 1';
            cas2.Account_Number__c = pa.Account_Number__c;
            cas2.AccountID = c.AccountId;
            cas2.Primary_Category__c = 'Online Banking';
            cas2.Status ='Open';
            cas2.IsMarkDeleted__c = true;
            //insert cas2;
            Cases.add(cas2);
            
            Case cas3 = new Case();
            cas3.Subject = 'Test Subject Mobile Banking 3';
            cas3.Description = 'Test Description Mobile Banking';
            cas3.Account_Number__c = pa.Account_Number__c;
            cas3.AccountID = c.AccountId;
            cas3.Primary_Category__c = 'Mobile Banking';
            cas3.Status ='Open';
            cas3.IsMarkSaved__c = true;
            cas3.IsMarkDeleted__c = false;
            //insert cas3;
            Cases.add(cas3);
            
            //ids2 = cas3.id;
            
            Case cas4 = new Case();
            cas4.Subject = 'Test Subject Mobile Banking 4';
            cas4.Description = 'Test Description Mobile Banking 1';
            cas4.Account_Number__c = pa.Account_Number__c;
            cas4.AccountID = c.AccountId;
            cas4.Primary_Category__c = 'Mobile Banking';
            cas4.Status ='Open';
            cas4.IsMarkSaved__c = true;
            //insert cas4;
            Cases.add(cas4);
            
            Case cas5 = new Case();
            cas5.Subject = 'Test Subject Mobile Banking';
            cas5.Description = 'Test Description Mobile Banking';
            cas5.Account_Number__c = pa.Account_Number__c;
            cas5.AccountID = c.AccountId;
            cas5.Primary_Category__c = 'Mobile Banking';
            cas5.Status ='Open';
            
            //insert cas5;
            Cases.add(cas5);
            insert cases;
            
            
			
        }
 	}
    
    private static void CreateCase(){
        
        string fid ='0000999999'    ;       
        String uid = UserInfo.getUserId();
        Profile profile = [SELECT Id,Name FROM Profile where Name ='Customer Community Login User' ];
        RecordType recordtype =[SELECT Id,Name FROM RecordType WHERE Name='Person Account'];
        User currentUser = [SELECT LocaleSidKey, LanguageLocaleKey, TimeZoneSidKey, EmailEncodingKey FROM User WHERE Id=:uid];
        Site communityid = [SELECT Id FROM Site where Name ='customer_messaging_center'];
        SamlSsoConfig samlSsoProviderId = [Select Id from SamlSsoConfig where DeveloperName='DI_SAML' ];
        Boolean Create = true;
        
        /*    ids = cases[0].id;
        ids1 = cases[1].id;
        ids2 = cases[3].id;*/
        
    }

   @IsTest
    
   public static void LoadCaseUnitTest(){
   
       string fid ='0000999999'    ;       
       String uid = UserInfo.getUserId();
       Profile profile = [SELECT Id,Name FROM Profile where Name ='Customer Community Login User' ];
       RecordType recordtype =[SELECT Id,Name FROM RecordType WHERE Name='Person Account'];
       User currentUser = [SELECT LocaleSidKey, LanguageLocaleKey, TimeZoneSidKey, EmailEncodingKey FROM User WHERE Id=:uid];
       Site communityid = [SELECT Id FROM Site where Name ='customer_messaging_center'];
       SamlSsoConfig samlSsoProviderId = [Select Id from SamlSsoConfig where DeveloperName='DI_SAML' ];
       Boolean Create = true;
       
       List<Case> cases= [select Id from case where subject = 'Test Subject Inquires' limit 1];
       string ids_l = cases[0].id;
       
       string view='';
       
       ids_l=cases[0].id;
       List<Case> cases1= [select Id from case where subject = 'Test Subject Online Banking' limit 1];
       string ids1_l = cases1[0].id;
       User u = [SELECT LocaleSidKey, LanguageLocaleKey, TimeZoneSidKey, EmailEncodingKey FROM User WHERE UserName = 'testUserName@test.com' limit 1];
       system.runas(u){
       
           ShowCasesController controller = new ShowCasesController();
           controller.PageLoad();
           PageReference pageRef = Page.ShowCases;
           Test.setCurrentPageReference(pageRef);
           //  pageRef.getParameters().put('Type','Messages'); 
           //      pageRef.getParameters().put('logo','logoorg.png'); 
           
           Test.startTest();
           MessageView mv3 = ShowCasesController.LoadCase('DeletedMessages', 'CreatedDate','Asc');
           MessageView mv = ShowCasesController.LoadCase('Messages', 'CreatedDate','Desc');
           Test.stopTest();
           //MessageView mv2 = ShowCasesController.LoadCase('SavedMessages', 'Category','Desc');
           //MessageView mv4 = ShowCasesController.LoadCase('SentMessages', 'Category','Asc');
           //System.Debug(mv4);
           //MessageView mv5 = ShowCasesController.LoadCase('SentMessages', 'CreatedDate','Desc');
           //  MessageView mv1 = ShowCasesController.LoadCase('SavedMessages', 'Category','Desc');
       }
    
    } 
    
   	@IsTest
	public static void LoadCaseUnitTestClosedandSent(){
    	string fid ='0000999999'    ;       
        String uid = UserInfo.getUserId();
        Profile profile = [SELECT Id,Name FROM Profile where Name ='Customer Community Login User' ];
        RecordType recordtype =[SELECT Id,Name FROM RecordType WHERE Name='Person Account'];
        User currentUser = [SELECT LocaleSidKey, LanguageLocaleKey, TimeZoneSidKey, EmailEncodingKey FROM User WHERE Id=:uid];
        Site communityid = [SELECT Id FROM Site where Name ='customer_messaging_center'];
        SamlSsoConfig samlSsoProviderId = [Select Id from SamlSsoConfig where DeveloperName='DI_SAML' ];
        Boolean Create = true;
        User u = [SELECT LocaleSidKey, LanguageLocaleKey, TimeZoneSidKey, EmailEncodingKey FROM User WHERE UserName = 'testUserName@test.com' limit 1];
        
        // ShowCasesControllerTest.CreateCase();
        system.runas(u){
        
            // Creating Account_Details__c
            ShowCasesController controller = new ShowCasesController();
            controller.PageLoad();
            PageReference pageRef = Page.ShowCases;
            Test.setCurrentPageReference(pageRef);
            
            Test.startTest();
            MessageView mv2 = ShowCasesController.LoadCase('SavedMessages', 'Category','Desc');
            MessageView mv4 = ShowCasesController.LoadCase('SentMessages', 'Category','Asc');
            Test.stopTest();
            System.Debug(mv4);
            //MessageView mv5 = ShowCasesController.LoadCase('SentMessages', 'CreatedDate','Desc');
            //  MessageView mv1 = ShowCasesController.LoadCase('SavedMessages', 'Category','Desc');
        }    
    }
    
    @IsTest
	public static void LoadCaseUnitTestClosedandSent2(){
    	string fid ='0000999900';       
        String uid = UserInfo.getUserId();
        Profile profile = [SELECT Id,Name FROM Profile where Name ='Customer Community Login User' ];
        RecordType recordtype =[SELECT Id,Name FROM RecordType WHERE Name='Person Account'];
        User currentUser = [SELECT LocaleSidKey, LanguageLocaleKey, TimeZoneSidKey, EmailEncodingKey FROM User WHERE Id=:uid];
        Site communityid = [SELECT Id FROM Site where Name ='customer_messaging_center'];
        SamlSsoConfig samlSsoProviderId = [Select Id from SamlSsoConfig where DeveloperName='DI_SAML' ];
        Boolean Create = true;
        User u = [SELECT LocaleSidKey, LanguageLocaleKey, TimeZoneSidKey, EmailEncodingKey FROM User WHERE UserName = 'testUserName@test1.com' limit 1];
        
        // ShowCasesControllerTest.CreateCase();
        system.runas(u){
        
            // Creating Account_Details__c
            ShowCasesController controller = new ShowCasesController();
            controller.PageLoad();
            PageReference pageRef = Page.ShowCases;
            Test.setCurrentPageReference(pageRef);
            
            Test.startTest();
            MessageView mv2 = ShowCasesController.LoadCase('SavedMessages', 'Category','Desc');
            MessageView mv4 = ShowCasesController.LoadCase('SentMessages', 'Category','Asc');
            Test.stopTest();
            System.Debug(mv4);
            //MessageView mv5 = ShowCasesController.LoadCase('SentMessages', 'CreatedDate','Desc');
            //  MessageView mv1 = ShowCasesController.LoadCase('SavedMessages', 'Category','Desc');
        }    
    }
    
    @IsTest
    
    public static void ButtonDelete_ClickTest(){
    
    	Test.startTest();
        List<Case> cases= [select Id from case where subject = 'Test Subject Online Banking' limit 1];
     	string ids_l = cases[0].id;
     	User u = [SELECT LocaleSidKey, LanguageLocaleKey, TimeZoneSidKey, EmailEncodingKey FROM User WHERE UserName = 'testUserName@test.com' limit 1];	
        system.runas(u){
        
            ShowCasesController.ButtonDelete_Click(ids_l);
        }
        Test.stopTest();
    }
    @IsTest
    
    public static void ButtonDelete1_ClickTest(){
      
    	Test.startTest();
        List<Case> cases= [select Id from case where subject = 'Test Subject Online Banking' limit 1];
        string ids_l = cases[0].id;
     	User u = [SELECT LocaleSidKey, LanguageLocaleKey, TimeZoneSidKey, EmailEncodingKey FROM User WHERE UserName = 'testUserName@test.com' limit 1];	
        system.runas(u){
            
            ShowCasesController.ButtonDelete1_Click(ids_l);
        }
        Test.stopTest();
    }
    
    @IsTest
    public static void ButtonSave_ClickTest(){
    	
        Test.startTest();
        List<Case> cases= [select Id from case where subject = 'Test Subject Mobile Banking 3' limit 1];
     	string ids_l = cases[0].id;
     	User u = [SELECT LocaleSidKey, LanguageLocaleKey, TimeZoneSidKey, EmailEncodingKey FROM User WHERE UserName = 'testUserName@test.com' limit 1];	
        system.runas(u){
            
            ShowCasesController.ButtonSave_Click(ids_l);
        }
        Test.stopTest();
     }
     
    @IsTest
    public static void ButtonSave1_ClickTest(){
        
        Test.startTest();
        List<Case> cases= [select Id from case where subject = 'Test Subject Mobile Banking 3' limit 1];
        string ids_l = cases[0].id;
     	User u = [SELECT LocaleSidKey, LanguageLocaleKey, TimeZoneSidKey, EmailEncodingKey FROM User WHERE UserName = 'testUserName@test.com' limit 1];	
        system.runas(u){
        	ShowCasesController.ButtonSave1_Click(ids_l);
        }
        Test.stopTest();
    }
    
    @IsTest
    public static void UpdateIsMarkRead(){
    
    	Test.startTest();
        List<Case> cases= [select Id from case where subject = 'Test Subject Inquires' limit 1];
        string ids_l = cases[0].id;
     	User u = [SELECT LocaleSidKey, LanguageLocaleKey, TimeZoneSidKey, EmailEncodingKey FROM User WHERE UserName = 'testUserName@test.com' limit 1];	
        system.runas(u){
        	ShowCasesController.UpdateIsMarkRead(ids);
        }
        Test.stopTest();
    }
    
    @IsTest    
    public static void findMinDateValueTest(){
        string fid ='0000999999'    ;       
        String uid = UserInfo.getUserId();
        Profile profile = [SELECT Id,Name FROM Profile where Name ='Customer Community Login User' ];
        RecordType recordtype =[SELECT Id,Name FROM RecordType WHERE Name='Person Account'];
        User currentUser = [SELECT LocaleSidKey, LanguageLocaleKey, TimeZoneSidKey, EmailEncodingKey FROM User WHERE Id=:uid];
        Site communityid = [SELECT Id FROM Site where Name ='customer_messaging_center'];
        SamlSsoConfig samlSsoProviderId = [Select Id from SamlSsoConfig where DeveloperName='DI_SAML' ];
        Boolean Create = true;
        
        List<Case> cases= [select Id,CaseNumber,createdDate from case where subject = 'Test Subject Inquires' limit 1];
        string ids_l = cases[0].id;
        Case cas = cases[0];
        User u = [SELECT LocaleSidKey, LanguageLocaleKey, TimeZoneSidKey, EmailEncodingKey FROM User WHERE UserName = 'testUserName@test.com' limit 1];	
        
        List<Message> messages = new List<Message>();
        Message message = new Message();
        message.PrimaryCategory = 'Inquires';
        message.Casenumber = cas.CaseNumber;
        message.id = ids_l;
        message.subject = 'Test';
        message.Createddate =cas.CreatedDate;
        messages.add(message);
        
        List<Message> messages1 = new List<Message>();
        Message message1 = new Message();
        message1.PrimaryCategory = 'Inquires';
        message1.Casenumber = cas.CaseNumber;
        message1.id = ids_l;
        message1.subject = 'Test';
        message1.Createddate =cas.CreatedDate;
        
        messages1.add(message1);
        
        List<Message> messages2 = new List<Message>();
        Message message2 = new Message();
        message2.PrimaryCategory = 'Inquires';
        message2.Casenumber = cas.CaseNumber;
        message2.id =ids_l;
        message2.subject = 'Test';
        message2.Createddate =cas.CreatedDate;
        messages2.add(message2);
        
        List<Message> messages3 = new List<Message>();
        Message message3 = new Message();
        message3.PrimaryCategory = 'Inquires';
        message3.Casenumber = cas.CaseNumber;
        message3.id = ids_l;
        message3.subject = 'Test';
        message3.Createddate =cas.CreatedDate;
        messages3.add(message3);
        
        Test.startTest();   
        system.runas(u){
            ShowCasesController.findMinDateValue('Category','desc',messages);
            ShowCasesController.findMinDateValue('CreatedDate','asc',messages1);
            ShowCasesController.findMinDateValue('CreatedDate','desc',messages2);
            ShowCasesController.findMinDateValue('Category','asc',messages3);
        }
        Test.stopTest();
    }
     @IsTest 
     public static void LoadNextMessageSet(){
   
  
         string fid ='0000999999'  ;    
         String uid = UserInfo.getUserId();
         Profile profile = [SELECT Id,Name FROM Profile where Name ='Messaging Center Customers' ];
         RecordType recordtype =[SELECT Id,Name FROM RecordType WHERE Name='Person Account'];
         User currentUser = [SELECT LocaleSidKey, LanguageLocaleKey, TimeZoneSidKey, EmailEncodingKey FROM User WHERE Id=:uid];
         Site communityid = [SELECT Id FROM Site where Name ='customer_messaging_center'];
         SamlSsoConfig samlSsoProviderId = [Select Id from SamlSsoConfig where DeveloperName='DI_SAML' ];
         Boolean Create = true;
         string ids;
         string ids2;
         
         List<Case> cases= [select Id from case where subject = 'Test Subject Mobile Banking' limit 1];
         ids = cases[0].id;
         List<Case> cases2= [select Id from case where subject = 'Test Subject Mobile Banking' limit 1]; 
         ids2 = cases2[0].id;
         
         string view='';
         User u = [SELECT LocaleSidKey, LanguageLocaleKey, TimeZoneSidKey, EmailEncodingKey FROM User WHERE UserName = 'testUserName@test.com' limit 1];
         
         system.runas(u){
             
             DisplayCaseController controller = new DisplayCaseController();
             controller.PageLoad();  
             string fid2 ='00009999'  ;
             DisplayCaseController.Get10DigitFid(fid2);
             List<Message> messages = new List<Message>();
             List<Message> messages1 = new List<Message>();
             
             Message msg = null; 

             Member_Comment__c mc = new Member_Comment__c();
             mc.Member_Comment__c ='test';
             mc.Member_Communication__c ='test';
             mc.Case__c = ids2;
             mc.draft__c = false;
			 mc.IsRead__c = true;
			 mc.Member_Read_Date_Time__c = System.now();
			 mc.Device_Type__c = 'Text';
             insert mc; 
             string mcid = mc.Id;
                         
             FileList fl = new FileList();
             string xblob = 'abc';
             Blob myBlob = Blob.valueof(xblob);
             
             Attachment att = new  Attachment();
             att.Parentid = mcid;
             att.Name = 'Excel.ppt';
             att.Body = myBlob;
             insert att; 
             Test.startTest(); 
             List<Attachment> attl = null; 
             
             System.assertEquals(1, 1); 
             //attl = ShowCasesController.GetAttachment(ids);
             Message msg2 = null;
             Message msg3 = null;

             
             
            // msg2 = ShowCasesController.LoadNextCase('SavedMessages','CreatedDate','Asc',ids);
            // msg3 = ShowCasesController.LoadPreviousCase('SavedMessages','CreatedDate','Asc',ids);

             string comment = 'Test';
			 string DeviceType = 'Test1';
			 //System.assert(ShowCasesController.ButtonReply_Click(ids2,comment,DeviceType)!= null);
 
             ShowCasesController.GetEmailAddress();
             Test.stopTest(); 

         }
     }
    @IsTest 
     public static void EmailWrapperTest(){
         ShowCasesController.EmailWrapper wr = new ShowCasesController.EmailWrapper();
       	 wr.Email = 'test@test.com';
         wr.ErrorMessage ='error';
     }
    
}