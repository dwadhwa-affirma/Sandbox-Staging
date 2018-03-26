@isTest
public class RealatedListControllerTest{
    static testmethod void TestMethod1(){
         string fid ='0000999999'  ;  
        Account acc = new Account();
        //acc.Owner = currentUser;
        acc.FirstName = 'tFName';
        acc.LastName='TLName';
        //acc.recordtypeid = recordtype.Id;
        acc.PersonID__C ='V554870800';
        
        acc.PersonEmail ='acctest@test.com';
        
        insert acc;  
        Contact c = [SELECT Id,AccountId FROM Contact WHERE AccountId=:acc.Id];
        
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
            attach.parentId=cas.id;
            AttachmentLst.add(attach);
        }        
        insert AttachmentLst; 
        
         List<Member_Comment__c> memberCommentList= new List<Member_Comment__c>();
         Member_Comment__c memberComment= new Member_Comment__c(Case__c = cas.Id); 
         insert memberComment;   
         
         List<Attachment> AttachmentLst2 = new List<Attachment>();
        for(integer i=0 ; i <= 5 ; i++){
            Attachment attach=new Attachment();    
            attach.Name='Unit Test Attachment';
            Blob bodyBlob=Blob.valueOf('Unit Test Attachment Body');
            attach.body=bodyBlob;
            attach.parentId=memberComment.id;
            AttachmentLst2.add(attach);
        }        
        insert AttachmentLst2;
         
         
         ApexPages.StandardController sc = new ApexPages.StandardController(memberComment);
         RealatedListController controller = new RealatedListController(sc);   
         controller.thisid = AttachmentLst2[0].id;
         controller.deleteAttachment();           
    }
}