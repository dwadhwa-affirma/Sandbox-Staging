@isTest
public class AddAttachemntControllerTest {
    
        
    public static testMethod void checkAttachmentTest(){
       
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
        
        string fid ='0000999999' ;    
        String uid = UserInfo.getUserId();
        User currentUser = [SELECT LocaleSidKey, LanguageLocaleKey, TimeZoneSidKey, EmailEncodingKey FROM User WHERE Id=:uid];
        RecordType recordtype =[SELECT Id,Name FROM RecordType WHERE Name='Person Account'];
        
        
        List<Account_Details__c> Account_Details = new List<Account_Details__c>();
        Account_Details__c ad = new Account_Details__c();
        ad.Name = fid;        
        Account_Details.add(ad);
        insert Account_Details;
        
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
        
        Case cas = new Case();
        //List<Contact> contact = [SELECT AccountId, FirstName, LastName FROM Contact WHERE Id =:contactid];
        cas.Subject = 'TestCaseSubject';
        cas.Description = 'TestCaseSubject';
        cas.Account_Number__c = ad.id;
        cas.AccountID = acc.id;
        cas.Primary_Category__c = 'Online Banking';
        cas.Status ='Open';
        insert cas;
        
        List<Attachment> AttachmentLst = new List<Attachment>();
        for(integer i=0 ; i <= 5 ; i++){
            Attachment attach=new Attachment();    
            attach.Name='Unit Test Attachment';
            Blob bodyBlob=Blob.valueOf('Unit Test Attachment Body');
            attach.body=bodyBlob;
            attach.parentId=cas.id;
            AttachmentLst.add(attach);
        }        
        insert AttachmentLst;
        
        /*Approve_Attachment__c ap = new Approve_Attachment__c();
        ap.Attachment_Id__c = AttachmentLst[0].id;
        ap.Case_ID__c = cas.id;      
        insert ap;
        
        Approve_Attachment__c ap2 = new Approve_Attachment__c();
        //ap.name = 'Test123';
        ap2.Attachment_Id__c = AttachmentLst[1].id;
        ap2.Case_ID__c = cas.id;
        insert ap2;  */
        
        
        string parentId = cas.id;
        string parentType = 'SentMessages';
        string SB = 'test';
        string SD = 'test';
        string entityType = 'Case';
        
        ApexPages.currentPage().getParameters().put('parentId',parentId);
        ApexPages.currentPage().getParameters().put('parentType',parentType);
        ApexPages.currentPage().getParameters().put('SB',SB);
        ApexPages.currentPage().getParameters().put('SD',SD);        
        ApexPages.currentPage().getParameters().put('entityType',entityType);
        
        AddAttachemntController controller = new AddAttachemntController();

        controller.attachments  = AttachmentLst;
        
        controller.ConvertAttachemntToFilelist();
        
        string parentId2 = cas.id;
        string parentType2 = 'SentMessages';
        string SB2 = 'test';
        string SD2 = 'test';
        string entityType2 = '';
        ApexPages.currentPage().getParameters().put('parentId',parentId2);
        ApexPages.currentPage().getParameters().put('parentType',parentType2);
        ApexPages.currentPage().getParameters().put('SB',SB2);
        ApexPages.currentPage().getParameters().put('SD',SD2);        
        ApexPages.currentPage().getParameters().put('entityType',entityType2);
        controller.RefreshAll();
        controller.ConvertAttachemntToFilelist();

    }
    public static testMethod void checkAttachmentTest2(){
       

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
        
        Profile profile = [SELECT Id,Name FROM Profile where Name ='Customer Community Login User' ];
        //RecordType recordtype =[SELECT Id,Name FROM RecordType WHERE Name='Person Account'];
        //User currentUser = [SELECT LocaleSidKey, LanguageLocaleKey, TimeZoneSidKey, EmailEncodingKey FROM User WHERE Id=:uid];
            string fid ='0000999999' ;    
        String uid = UserInfo.getUserId();
        User currentUser = [SELECT LocaleSidKey, LanguageLocaleKey, TimeZoneSidKey, EmailEncodingKey FROM User WHERE Id=:uid];
        RecordType recordtype =[SELECT Id,Name FROM RecordType WHERE Name='Person Account'];
        
        List<Account_Details__c> Account_Details = new List<Account_Details__c>();
        Account_Details__c ad = new Account_Details__c();
        ad.Name = fid;        
        Account_Details.add(ad);
        insert Account_Details;
        

        Account acc = new Account();
        acc.Owner = currentUser;
        acc.FirstName = 'tFName';
        acc.LastName='TLName';
        acc.recordtypeid = recordtype.Id;
        acc.PersonID__C ='V554870800';       
        acc.PersonEmail ='acctest@test.com';      
        insert acc;

        Contact c = [SELECT Id, AccountId FROM Contact WHERE AccountId=:acc.Id];
            
        Case cas = new Case();
        //List<Contact> contact = [SELECT AccountId, FirstName, LastName FROM Contact WHERE Id =:contactid];
        cas.Subject = 'TestCaseSubject';
        cas.Description = 'TestCaseSubject';
        cas.Account_Number__c = ad.id;
        cas.AccountID = acc.id;
        cas.Primary_Category__c = 'Online Banking';
        cas.Status ='Open';
        insert cas;
        
        List<Attachment> AttachmentLst = new List<Attachment>();
        for(integer i=0 ; i <= 5 ; i++){
            Attachment attach=new Attachment();    
            attach.Name='Unit Test Attachment';
            Blob bodyBlob=Blob.valueOf('Unit Test Attachment Body');
            attach.body=bodyBlob;
            attach.parentId=cas.id;
            AttachmentLst.add(attach);
        }        
        insert AttachmentLst;
        
        Member_Comment__c mb = new Member_Comment__c();
        mb.Member_Communication__c = 'test';
        mb.Case__c = cas.id;
        insert mb;
        
        string parentId = mb.id;
        string parentType = 'SentMessages';
        string SB = 'test';
        string SD = 'test';
        string entityType = 'notes';
       
        ApexPages.currentPage().getParameters().put('parentId',parentId);
        ApexPages.currentPage().getParameters().put('parentType',parentType);
        ApexPages.currentPage().getParameters().put('SB',SB);
        ApexPages.currentPage().getParameters().put('SD',SD);        
        ApexPages.currentPage().getParameters().put('entityType',entityType);
        
        test.startTest();
        
        AddAttachemntController controller = new AddAttachemntController();
        controller.attachments  = AttachmentLst;
       
        
         List<User> users = new List<User>();
            user u = new user();
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
            string aid = AttachmentLst[0].id;
            
       
            ApexPages.CurrentPage().getParameters().put('id',aid+'='+aid);
            controller.RemoveFile();
            
            system.runas(u)
            {
            SecureEmailSetting__c se = new SecureEmailSetting__c();
            se.name = 'test';
            se.List_of_Allowed_Extensions__c = 'Test';
            se.ProfileId__c =  Profile.id;
            insert se;
             CFCUAccount userAccount = new CFCUAccount();
             userAccount.fedid = fid;
             controller.PageLoad();
            }
         test.stopTest();
        
    }
}