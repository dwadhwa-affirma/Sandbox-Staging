@isTest
public class CannedResponsesForCommentTest{

@testSetup static void methodName() 
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
     
          // Creating  Account  
          Account acc = new Account();
          acc.Owner = currentUser;
          acc.FirstName = 'tFName';
          acc.LastName='TLName';
          acc.recordtypeid = recordtype.Id;
          acc.PersonID__C ='V554870800';
          
          acc.PersonEmail ='acctest@test.com';
          
          insert acc;
          
          Contact c = [SELECT Id,AccountId FROM Contact WHERE AccountId=:acc.Id];

            // Creating new user
          User u = new User();
            u.Username = 'testUserName@test.com' ;
            u.FederationIdentifier =fid ;
            u.Email ='test@test.com' ;
            u.FirstName ='tFirstName' ;
            u.LastName ='tLastName' ;
            u.ProfileId = profile.Id;
            u.ContactId = c.Id;
            u.Alias ='tAlias';
           
            u.LocaleSidKey = currentUser.LocaleSidKey;
            u.LanguageLocaleKey = currentUser.LanguageLocaleKey; 
            u.TimeZoneSidKey = currentUser.TimeZoneSidKey; 
            u.EmailEncodingKey = currentUser.EmailEncodingKey;
            insert u;
            
            /*PermissionSet ps = [SELECT Id, Name, Label FROM PermissionSet where label = 'Read permission for member comment'];
            
            PermissionSetAssignment psa = new PermissionSetAssignment(PermissionSetId = ps.ID, AssigneeId = u.id);
            insert psa;   */       
            
           // Creating Account_Details__c
            List<Account_Details__c> Account_Details = new List<Account_Details__c>();
            Account_Details__c ad = new Account_Details__c();
            ad.Name = fid;
            
            Account_Details.add(ad);
            insert Account_Details;
           // Creating  Person_Account__c
            
             Person_Account__c pa = new Person_Account__c();
             pa.Account_Number__c = ad.id;
             pa.Name_Type__c = 0;
             pa.PersonID__c = acc.Id;
             insert pa;
             string view='';
             
            Canned_Message_Metadata__c cannedMessageHeader = new Canned_Message_Metadata__c();
            cannedMessageHeader.Name = 'Metadata';
            cannedMessageHeader.Chevron_Footer__c = 'Thanks, Chevron Support 999-999-9999';
            cannedMessageHeader.Spectrum_Footer__c = 'Thanks, Spectrum Support 999-999-9999';
            cannedMessageHeader.Chevron_Header__c = 'Dear Member,';
            cannedMessageHeader.Spectrum_Header__c = 'Dear Member,';
            insert cannedMessageHeader;
             test.startTest();
             Case cas = new Case();
       
        system.runas(u)
          {
             cas.Subject = 'Test Subject Inquires';
             cas.Description = 'Test Description Inquires';
             cas.Account_Number__c = pa.Account_Number__c;
             cas.AccountID = c.AccountId;
             cas.Primary_Category__c = 'Inquires';
             cas.Status ='Open';
             insert cas;
         }
    
    
   
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
    
    	
        
        

             //List<Canned_Responses__c> Canned = new List<Canned_Responses__c>{};
           
            Canned_Responses__c cr = new Canned_Responses__c();
            cr.Brand__c = 'Chevron';
            cr.Primary_Lookup_Text__c = 'CFCU Contact Information';
            cr.Secondary_Lookup_Text__c = 'Test';
            cr.Active__c = true;
            cr.Tertiary_Lookup_Text__c = 'Test';
            insert cr;
    test.stoptest();
}


    static testmethod void validateStandardController(){
        test.startTest();
		Case cas = [select id from case limit 1];
        
   List<Attachment>     AttachmentLst = [select id from Attachment where parentid =: cas.id];
        
		Canned_Responses__c cr = [select id from Canned_Responses__c limit 1];
		
		 List<Member_Comment__c> memberCommentList= new List<Member_Comment__c>();
            Member_Comment__c memberComment= new Member_Comment__c(Case__c = cas.Id);
            PageReference pageRef = Page.Canned_Responses_For_Member_Comment;
            Test.setCurrentPage(pageRef);
            apexpages.currentpage().getparameters().put('caseId' , cas.id);
            
            
            ApexPages.StandardController sc = new ApexPages.StandardController(memberComment);        
            CannedResponsesForComment crc = new CannedResponsesForComment(sc);      
                 
            List<CannedResponsesForComment.attachmentWrapper> wrapList = crc.wrapperLst;
            for(CannedResponsesForComment.attachmentWrapper obj : wrapList){
                if(obj.attachmentobj.Id==AttachmentLst[2].Id){
                 obj.checkvalue = true;
                }
                if(obj.attachmentobj.Id==AttachmentLst[0].Id){
                 obj.checkvalue = true;
                }
            }
            
           
            crc.MemberDescription = 'Test';
            crc.brand = 'Chevron';
            crc.selectedPrimary =  'CFCU Contact Information';
            crc.selectedSecondary = '0';
            crc.selectedTertiary = '0';
            crc.selectedSecondary = 'Test';
            crc.getItems();
            crc.getPrimary();
            crc.getSecondary();
            crc.getTertiary();
            crc.getTitlesBySearchText();
            crc.savenew();
            crc.selectedTertiary = 'Test';
            crc.selectedTitle = cr.id;
            crc.getSelectedDecription();
            crc.getTitlesByCategories();
            crc.save();
            crc.cancelall();
    test.stopTest();
      }
   
 }