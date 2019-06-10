@isTest
Public class AttachmentNameUpdateTest{

    public static testmethod void updatetestmethod()
    {
           Test.startTest();  

    Member_Comment__c   mem1 =  [select id from Member_Comment__c where Member_Email__c = 'mem1@mem1.com' limit 1];
    
    
    Member_Comment__c   mem =  [select id from Member_Comment__c where Member_Email__c = 'mem@mem.com' limit 1];
    
         
         string before = 'Testing base 64 encode';            
         Blob beforeblob = Blob.valueOf(before);
         
         ContentVersion cv = new ContentVersion();
         cv.title = 'test content trig54+-+ger';      
         cv.PathOnClient ='test';           
         cv.VersionData =beforeblob;          
         insert cv; 
         
         
          ContentVersion testContent = [SELECT id, ContentDocumentId FROM ContentVersion where Id = :cv.Id];
       
         ContentDocumentLink attach3 =new ContentDocumentLink();    
         attach3.ContentDocumentId= testContent.ContentDocumentId;
         attach3.LinkedEntityId=mem.id;
         attach3.ShareType= 'V';
        insert attach3;
        
        ContentDocumentLink attach4 =new ContentDocumentLink();    
         attach4.ContentDocumentId= testContent.ContentDocumentId;
         attach4.LinkedEntityId=mem1.id;
         attach4.ShareType= 'V';
        insert attach4;
        
       
        
        delete attach4;
        
 
        Attachment attach1=new Attachment();    
        attach1.Name='Unit Test Attachment';
        Blob bodyBlob1=Blob.valueOf('Unit Test Attachment Body');
        attach1.body=bodyBlob1;
        attach1.parentId=mem.id;
        insert attach1;
        Test.stoptest();
        
    }
    
     public static testMethod void updateAttachmentTest(){
           Test.startTest();
     Case cas = [select id from case where Subject = 'TestCaseSubject123' limit 1];
     
    
     
        Attachment attach=new Attachment();    
        attach.Name='Unit Test Attachment';
        Blob bodyBlob=Blob.valueOf('Unit Test Attachment Body');
        attach.body=bodyBlob;
        attach.parentId=cas.id;
        insert attach;
         
        
         //  test new attachment alert on case 
        Attachment attach10=new Attachment();    
        attach10.Name='Unit Test Attachment10';
        Blob bodyBlob2=Blob.valueOf('Unit Test Attachment Body 10');
        attach10.body=bodyBlob2;
        attach10.parentId=cas.id;
        insert attach10;
        list<case> cs = [Select id, isNewAttachment__c from case where id = :cas.id];
        
        System.assertEquals(cs[0].isNewAttachment__c, True);
        
        delete attach10;
        
        //  end of test new attachment alert on case 
        
        
        Approve_Attachment__c ap = new Approve_Attachment__c();
        //ap.name = 'Test123';
        ap.Attachment_Id__c = attach.id;
        ap.Case_ID__c = cas.id;
        insert ap; 
     
        attach.name = 'Test123';
        Update attach;
        //delete attach;
        Test.stoptest();
        
        
        
    }
    
    
    
    @testSetup static void mName()
    {
    
    
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
        cas.Subject = 'TestCaseSubject123';
        cas.Description = 'TestCaseSubject123';
        cas.Account_Number__c = ad.id;
        cas.AccountID = acc.id;
        cas.Primary_Category__c = 'Online Banking';
        cas.Status ='Open';
        insert cas;
        Member_Comment__c mem = new Member_Comment__c();
        mem.Case__c = cas.id;
        //mem.Name = 'test';
        mem.Member_Communication__c = '2222333';
        
mem.Member_Email__c = 'mem@mem.com';
        insert mem;
        
         Case cas1 = new Case();
        //List<Contact> contact = [SELECT AccountId, FirstName, LastName FROM Contact WHERE Id =:contactid];
        cas1.Subject = 'TestCaseSubject';
        cas1.Description = 'TestCaseSubject';
        cas1.Account_Number__c = ad.id;
        cas1.AccountID = acc.id;
        cas1.Primary_Category__c = 'Online Banking';
        cas1.Status ='Open';
        insert cas1;
         test.startTest();
        Member_Comment__c mem1 = new Member_Comment__c();
        mem1.Case__c = cas1.id;
mem1.Member_Communication__c = '123';
mem1.Member_Email__c = 'mem1@mem1.com';
        insert mem1;
        test.stopTest();

    }
    
    
    
    
}