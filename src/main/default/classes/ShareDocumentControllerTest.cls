@isTest
Public class ShareDocumentControllerTest{

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
         cl2.hours__c = 200;
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
        
        Approve_Attachment__c ap = new Approve_Attachment__c();
        ap.Attachment_Id__c = AttachmentLst[0].id;
        ap.Case_ID__c = cas.id;      
        insert ap;
        
        Approve_Attachment__c ap2 = new Approve_Attachment__c();
        //ap.name = 'Test123';
        ap2.Attachment_Id__c = AttachmentLst[1].id;
        ap2.Case_ID__c = cas.id;
        insert ap2;
        
        apexpages.currentpage().getparameters().put('caseId' , cas.id);
        
        ShareDocumentController controller = new ShareDocumentController();
        
         List<ShareDocumentController.attachmentWrapper> wrapList = controller.wrapperLst;
         for(ShareDocumentController.attachmentWrapper obj : wrapList){
             if(obj.attachmentobj.Id==AttachmentLst[2].Id){
                 obj.checkvalue = true;
             }
             if(obj.attachmentobj.Id==AttachmentLst[0].Id){
                 obj.checkvalue = false;
             }
         }
        controller.ShareAttchment();      
        controller.cancelall();
        
     
              
     }
     
 }