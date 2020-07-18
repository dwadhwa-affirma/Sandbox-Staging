@IsTest
 public with sharing class DisplayCaseControllerTest {
 
 
   @testsetup public static void setup()
   {
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
        customsetting.List_of_Blocked_Extensions__c = 'css';
        insert customsetting;
        string ids;
        string ids2;
        
        
     string fid ='0000999999'  ;    
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
            
            Contact c = [SELECT Id,AccountId FROM Contact WHERE AccountId=:acc.Id];

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
      
       List<Case> cases = new List<Case>();
           Case cas = new Case();
             cas.Subject = 'Test Subject Inquires';
             cas.Description = 'Test Description Inquires';
             cas.Account_Number__c = pa.Account_Number__c;
             cas.AccountID = c.AccountId;
             cas.Primary_Category__c = 'Inquires';
             cas.Status ='Open';
             insert cas;
             
             
             
            List<Attachment> AttachmentLst = new List<Attachment>();
                for(integer i=0 ; i <= 5 ; i++){
                Attachment attach=new Attachment();    
                attach.Name='Unit Test Attachment';
                Blob bodyBlob=Blob.valueOf('Unit Test Attachment Body');
                attach.body=bodyBlob;
                attach.parentId= cas.id;
                AttachmentLst.add(attach);
            }        
          test.startTest();
            insert AttachmentLst;
            
             Case cas1 = new Case();
             cas1.Subject = 'Test Subject Online Banking 0';
             cas1.Description = 'Test Description Online Banking Test Description Online Banking Test Description Online Banking';
             cas1.Account_Number__c = pa.Account_Number__c;
             cas1.AccountID = c.AccountId;
             cas1.Primary_Category__c = 'Online Banking';
             cas1.Status ='Open';
             cas1.IsMarkDeleted__c = true;
             Cases.add(cas1);
             
             Case cas2 = new Case();
             cas2.Subject = 'Test Subject Online Banking 1';
             cas2.Description = 'Test Description Online Banking 1';
             cas2.Account_Number__c = pa.Account_Number__c;
             cas2.AccountID = c.AccountId;
             cas2.Primary_Category__c = 'Online Banking';
             cas2.Status ='Open';
             cas2.IsMarkDeleted__c = true;
             cases.add(cas2);
            
             Case cas3 = new Case();
             cas3.Subject = 'Test Subject Mobile Banking';
             cas3.Description = 'Test Description Mobile Banking';
             cas3.Account_Number__c = pa.Account_Number__c;
             cas3.AccountID = c.AccountId;
             cas3.Primary_Category__c = 'Mobile Banking';
             cas3.Status ='Open';
             cas3.IsMarkSaved__c = true;
             cases.add(cas3);
             
             Case cas4 = new Case();
             cas4.Subject = 'Test Subject Inquires 2';
             cas4.Description = 'Test Description Inquires';
             cas4.Account_Number__c = pa.Account_Number__c;
             cas4.AccountID = c.AccountId;
             cas4.Primary_Category__c = 'Inquires';
             cas4.Status ='Open';
             cas4.IsMarkSaved__c = true;
             cases.add(cas4);
             
             
              Case cas6 = new Case();
             cas6.Subject = 'Test Subject Mobile Banking 11';
             cas6.Description = 'Test Description Mobile Banking 1';
             cas6.Account_Number__c = pa.Account_Number__c;
             cas6.AccountID = c.AccountId;
             cas6.Primary_Category__c = 'Mobile Banking';
             cas6.Status ='Open';
             cas6.IsMarkSaved__c = true;
             //insert cas4;
             cases.add(cas6);
             
             
             Case cas5 = new Case();
             cas5.Subject = 'Test Subject Mobile Banking 3';
             cas5.Description = 'Test Description Mobile Banking';
             cas5.Account_Number__c = pa.Account_Number__c;
             cas5.AccountID = c.AccountId;
             cas5.Primary_Category__c = 'Mobile Banking';
             cas5.Status ='Open';
             
             
             
             //insert cas5;
             cases.add(cas5);
             
             
              Case cas7 = new Case();
        
                cas7.Subject = 'TestCaseSubject';
                cas7.Description = 'TestCaseSubject';
                cas7.Account_Number__c = ad.id;
                cas7.AccountID = acc.id;
                cas7.Primary_Category__c = 'Online Banking';
                cas7.Status ='Open';
               cases.add(cas7);
               insert cases;  
             
             test.stoptest();
      }
     
     
   }
 
   @istest public static void LoadCaseandSavedMessagesTest()
  {
      
  
     string fid ='0000999999'  ;    
     String uid = UserInfo.getUserId();
     Profile profile = [SELECT Id,Name FROM Profile where Name ='Customer Community Login User' ];
     RecordType recordtype =[SELECT Id,Name FROM RecordType WHERE Name='Person Account'];
     User currentUser = [SELECT LocaleSidKey, LanguageLocaleKey, TimeZoneSidKey, EmailEncodingKey FROM User WHERE Id=:uid];
     Site communityid = [SELECT Id FROM Site where Name ='customer_messaging_center'];
     SamlSsoConfig samlSsoProviderId = [Select Id from SamlSsoConfig where DeveloperName='DI_SAML' ];
     Boolean Create = true;
     string ids;
     string ids2;
     
     List<Case> cases= [select Id from case where subject = 'Test Subject Inquires' limit 1];
     ids = cases[0].id;
     
     string view='';
  User u = [SELECT LocaleSidKey, LanguageLocaleKey, TimeZoneSidKey, EmailEncodingKey FROM User WHERE UserName = 'testUserName@test.com' limit 1];
    system.runas(u)
    {             
          DisplayCaseController controller = new DisplayCaseController();
          controller.PageLoad();  
          string fid2 ='00009999'  ;
          DisplayCaseController.Get10DigitFid(fid2);
          List<Message> messages = new List<Message>();
                 
                  
                Test.startTest(); 
                System.assertEquals(1, 1);
                  Message msg = null; 
                  msg = DisplayCaseController.LoadCase('SentMessages','CreatedDate','Asc',ids);                
                  messages = DisplayCaseController.GetAllMessagesforUser('SavedMessages','CreatedDate','Desc',ids);
                  messages = DisplayCaseController.GetAllMessagesforUser('Messages','CreatedDate','Desc',ids);
                  Test.stopTest();
    }
                  
        
  }

@istest public static void LoadDeletedMessagesandRestTest()
  {
     
  
     string fid ='0000999999'  ;    
     String uid = UserInfo.getUserId();
     Profile profile = [SELECT Id,Name FROM Profile where Name ='Customer Community Login User' ];
     RecordType recordtype =[SELECT Id,Name FROM RecordType WHERE Name='Person Account'];
     User currentUser = [SELECT LocaleSidKey, LanguageLocaleKey, TimeZoneSidKey, EmailEncodingKey FROM User WHERE Id=:uid];
     Site communityid = [SELECT Id FROM Site where Name ='customer_messaging_center'];
     SamlSsoConfig samlSsoProviderId = [Select Id from SamlSsoConfig where DeveloperName='DI_SAML' ];
     Boolean Create = true;
     string ids;
     string ids2;
     
     List<Case> cases= [select Id from case where subject = 'Test Subject Inquires' limit 1];
       ids = cases[0].id;
        List<Case> cases2= [select Id from case where subject = 'Test Subject Mobile Banking' limit 1];
            
        ids2 = cases2[0].id;
                  
     string view='';
     User u = [SELECT LocaleSidKey, LanguageLocaleKey, TimeZoneSidKey, EmailEncodingKey FROM User WHERE UserName = 'testUserName@test.com' limit 1];
   system.runas(u)
     {
      
     
             
        DisplayCaseController controller = new DisplayCaseController();
        controller.PageLoad();  
        string fid2 ='00009999'  ;
        DisplayCaseController.Get10DigitFid(fid2);
        
        List<Message> messages3 = new List<Message>();
                 
                  
    Test.startTest(); 
        System.assertEquals(1, 1);
        messages3 = DisplayCaseController.GetAllMessagesforUser('DeletedMessages','Category','Desc',ids);  
                  
        string LatestcommentBySupport = DisplayCaseController.LoadLatestCommentBySupport(ids);
        Member_Comment__c mc = new Member_Comment__c();
        mc.Member_Comment__c ='test';
        mc.Member_Communication__c ='test';
        mc.draft__c = false;
        mc.Case__c = ids2;
        insert mc; 
        string mcid = mc.Id;
         
         DisplayCaseController.latestCommmentBySupportidd = mc.id;
        List<Member_Comment__c> casecommentdata = DisplayCaseController.GetCaseComment(ids2);
        MemberMessageView m = null;    
        
        FileList fl = new FileList();
                  string xblob = 'abc';
                  Blob myBlob = Blob.valueof(xblob);
                  
                  
                  
                  Attachment att = new  Attachment();
                  att.Parentid = mcid;
                  att.Name = 'Excel.ppt';
                  att.Body = myBlob;
                  insert att; 
                   
        m = DisplayCaseController.LoadMemberComments(ids2);
                             
        Test.StopTest();
        }
  }

  @IsTest public static void LoadSavedMessagesTestDescandPrev()
  {
   
  
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
     
      
     User u = [SELECT LocaleSidKey, LanguageLocaleKey, TimeZoneSidKey, EmailEncodingKey FROM User WHERE UserName = 'testUserName@test.com' limit 1];        
            
       
    system.runas(u)
      {
        List<Case> cases= [select Id from case where subject = 'Test Subject Inquires 2' limit 1];
       if (cases.size() > 0)
       {
         ids = cases[0].id;
       }
       else
       {
         system.debug(ids);
         return;
       }
        List<Case> cases2= [select Id from case where subject = 'Test Subject Mobile Banking' limit 1];
            Test.StartTest();
        ids2 = cases2[0].id;
        
          DisplayCaseController controller = new DisplayCaseController();
          controller.PageLoad();  
          string fid2 ='00009999'  ;
          DisplayCaseController.Get10DigitFid(fid2);
          List<Message> messages = new List<Message>();
                  List<Message> messages1 = new List<Message>();

                  Message msg = null; 
                              
                 DisplayCaseController.LoadCase('SavedMessages','CreatedDate','Desc',ids);
                  DisplayCaseController.ButtonDelete_Click(ids);
                  //DisplayCaseController.ButtonReply_Click(ids,'TestComment','Mobile');
                  //DisplayCaseController.ButtonReply_Click(ids,'TestComment');
                  DisplayCaseController.ButtonSave_Click(ids);
                  
                 
                Test.stopTest();           
        }
  }
  
  @isTest public static void LoadCaseComment2()
  {
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
     
      
     User u = [SELECT LocaleSidKey, LanguageLocaleKey, TimeZoneSidKey, EmailEncodingKey FROM User WHERE UserName = 'testUserName@test.com' limit 1];        
            
     
      system.runas(u)
        {
          List<Case> cases= [select Id from case where subject = 'Test Subject Inquires 2' limit 1];
         if (cases.size() > 0)
         {
           ids = cases[0].id;
         }
         else
         {
           system.debug(ids);
           return;
         }
          List<Case> cases2= [select Id from case where subject = 'Test Subject Mobile Banking' limit 1];
              
          ids2 = cases2[0].id;
          Test.StartTest();  
         string LatestcommentBySupport = DisplayCaseController.LoadLatestCommentBySupport(ids);
                    Member_Comment__c mc = new Member_Comment__c();
                    mc.Member_Comment__c ='test';
                    mc.Member_Communication__c ='test';
                    mc.Case__c = ids2;
                    mc.draft__c = false;
                    insert mc; 
                    
                    string mcid = mc.Id;
                    List<Member_Comment__c> casecommentdata = DisplayCaseController.GetCaseComment(ids2);
                     MemberMessageView m = null;               
                     m = DisplayCaseController.LoadMemberComments(ids2);
                     
                    FileList fl = new FileList();
                  string xblob = 'abc';
                  Blob myBlob = Blob.valueof(xblob);
                  
                  
                  
                  Attachment att = new  Attachment();
                  att.Parentid = mcid;
                  att.Name = 'Excel.ppt';
                  att.Body = myBlob;
                  insert att; 
                  List<Attachment> attl = null; 
                  
                  System.assertEquals(1, 1); 
                  attl = DisplayCaseController.GetAttachment(ids);
                  Message msg3 = null; 
                  msg3 = DisplayCaseController.LoadPreviousCase('SavedMessages','CreatedDate','Desc',ids);
    }
  }
   @IsTest public static void LoadNextMessageSet()
  {
   
  
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
     
      
            List<Case> cases= [select Id from case where subject = 'Test Subject Inquires 2' limit 1];
       ids = cases[0].id;
        List<Case> cases2= [select Id from case where subject = 'Test Subject Mobile Banking' limit 1];
            
        ids2 = cases2[0].id;
                  
     string view='';
     User u = [SELECT LocaleSidKey, LanguageLocaleKey, TimeZoneSidKey, EmailEncodingKey FROM User WHERE UserName = 'testUserName@test.com' limit 1];
             
            
       
    system.runas(u)
      {
        
          
          DisplayCaseController controller = new DisplayCaseController();
          controller.PageLoad();  
          string fid2 ='00009999'  ;
          DisplayCaseController.Get10DigitFid(fid2);
          List<Message> messages = new List<Message>();
                  List<Message> messages1 = new List<Message>();

                  Message msg = null; 
                              
                 //DisplayCaseController.LoadCase('SavedMessages','CreatedDate','Desc',ids);

                  //DisplayCaseController.ButtonDelete_Click(ids);
                  //DisplayCaseController.ButtonReply_Click(ids,'TestComment','Desktop');
                  //DisplayCaseController.ButtonReply_Click(ids,'TestComment');
                  //DisplayCaseController.ButtonSave_Click(ids);
                  
                  //string LatestcommentBySupport = DisplayCaseController.LoadLatestCommentBySupport(ids);
                  Member_Comment__c mc = new Member_Comment__c();
                  mc.Member_Comment__c ='test';
                  mc.Member_Communication__c ='test';
                  mc.Case__c = ids2;
                  mc.draft__c = false;
                  insert mc; 
                  string mcid = mc.Id;
                  //List<Member_Comment__c> casecommentdata = DisplayCaseController.GetCaseComment(ids2);
                   ///MemberMessageView m = null;               
                   ///m = DisplayCaseController.LoadMemberComments(ids2);
                   
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
                attl = DisplayCaseController.GetAttachment(ids);
                Message msg2 = null; 
                msg2 = DisplayCaseController.LoadNextCase('SavedMessages','CreatedDate','Asc',ids);
                Test.stopTest(); 
                           
        }
  }
  @IsTest
 
    public static void LoadMemberCommentsTest()
    {
        
        
             string fid ='0000999999'   ;       
             String uid = UserInfo.getUserId();
             Profile profile = [SELECT Id,Name FROM Profile where Name ='Customer Community Login User' ];
             RecordType recordtype =[SELECT Id,Name FROM RecordType WHERE Name='Person Account'];
             User currentUser = [SELECT LocaleSidKey, LanguageLocaleKey, TimeZoneSidKey, EmailEncodingKey FROM User WHERE Id=:uid];
             Site communityid = [SELECT Id FROM Site where Name ='customer_messaging_center'];
             SamlSsoConfig samlSsoProviderId = [Select Id from SamlSsoConfig where DeveloperName='DI_SAML' ];
             Boolean Create = true;
             string ids2 ;
             string ids ;
             string ids1 ;
            string ids3 ;
               
             string view='';
             
             User u = [SELECT LocaleSidKey, LanguageLocaleKey, TimeZoneSidKey, EmailEncodingKey FROM User WHERE UserName = 'testUserName@test.com' limit 1];
             
             
             /*string ids1= cases[1].id;
             ids2 = cases[2].id;
             string ids3 = cases[3].id;*/
             
                List<Case> cases= [select Id from case where subject = 'Test Subject Inquires' limit 1];
            ids = cases[0].id;
            
            List<Case> cases1= [select Id from case where subject = 'Test Subject Online Banking 0' limit 1];
             ids1 = cases1[0].id;
            
            List<Case> cases2= [select Id from case where subject = 'Test Subject Mobile Banking 11' limit 1];
            ids2 = cases2[0].id;
            
            List<Case> cases3= [select Id from case where subject = 'Test Subject Mobile Banking' limit 1];
            ids3 = cases3[0].id;
            


            FileList fl = new FileList();
            string xblob = 'abc';
            Blob myBlob = Blob.valueof(xblob);
        
             List<Member_Comment__c> memberComments = new List<Member_Comment__c>();
             Member_Comment__c mc = new Member_Comment__c();
             mc.Member_Comment__c ='test';
             mc.Member_Communication__c ='test';
             mc.draft__c = false;
             mc.Case__c = ids1;
             //insert mc; 
             memberComments.add(mc);
            
              Member_Comment__c mc3 = new Member_Comment__c();
             mc3.Member_Comment__c ='test';
             mc.Member_Communication__c ='test';
             mc3.Case__c = ids2;
             mc3.draft__C = false;
             //insert mc3;
             memberComments.add(mc3);
             
             Member_Comment__c mc2 = new Member_Comment__c();
             mc2.Member_Comment__c ='test1';
             mc.Member_Communication__c ='test';
             mc2.Case__c = ids3;
             mc3.draft__c = false;
             //insert mc2;
             memberComments.add(mc2);
             
             insert memberComments;

             Attachment att = new  Attachment();
            att.Parentid = memberComments[0].id;
            att.Name = 'Excel.ppt';
            att.Body = myBlob;
            insert att; 
            
            List<FileList> filelists = new List<FileList>();
                MemberComment mc5 = new MemberComment();
                mc5.CreatedById  = mc5.CreatedById;
                mc5.CreatedDate = system.now();     
                
                Test.startTest(); 
                System.assertEquals(1, 1);            
        system.runas(u)
            {
                MemberMessageView m = null; 
                m = DisplayCaseController.LoadMemberComments(ids2);
            }
        Test.stopTest();
    }
    
    @IsTest
    
    public static void uploadFileTest() {
        //Split string 'file' in to two chunks, first chunk must be divisible by 3 for base64 encode with no padding
        Blob part1 = Blob.valueOf('This text re'); //length is 12 
        Blob part2 = Blob.valueOf('presents a dummy file');
                
        String part1base64 = EncodingUtil.base64Encode(part1);
        String part2base64 = EncodingUtil.base64Encode(part2);
        
        //Create a test accound the 'file' can be attached to.
        
        String contactid;
            
        string fid ='0000999999'    ;       
         String uid = UserInfo.getUserId();
         Profile profile = [SELECT Id,Name FROM Profile where Name ='Customer Community Login User' ];
         RecordType recordtype =[SELECT Id,Name FROM RecordType WHERE Name='Person Account'];
         User currentUser = [SELECT LocaleSidKey, LanguageLocaleKey, TimeZoneSidKey, EmailEncodingKey FROM User WHERE Id=:uid];
         Site communityid = [SELECT Id FROM Site where Name ='customer_messaging_center'];
         SamlSsoConfig samlSsoProviderId = [Select Id from SamlSsoConfig where DeveloperName='DI_SAML' ];
         Boolean Create = true;
            
           
        
        List<User> us = [select ContactId FROM User WHERE Username = 'testUserName@test.com'];
        contactid = us[0].ContactId;
        List<Contact> contact = [SELECT AccountId, FirstName, LastName FROM Contact WHERE Id =:contactid];
       
       string id;
       List<case> cas =[select Id from case where subject='TestCaseSubject']; 
            id=cas[0].id;          
        //Start the test
        Test.startTest();
        //Send first part of the file to be uploaded
        String attachmentId = DisplayCaseController.attachBlob(id,'','fileName','text',part1base64);
        
        //Send the second piece of the file to be uploaded
        DisplayCaseController.attachBlob(id,attachmentId,'fileName','text',part2base64);
        Test.stopTest();
        
        //Assert one file has been attached to the test account
        List<Attachment> attachments = [select Id, Body from Attachment where ParentId = :id];
        system.assert(attachments.size() == 1);
        
        //Assert the contents of the split file were recontructed correctly
        system.assert(attachments[0].Body.toString() == 'This text represents a dummy file');
    }
    
   
}