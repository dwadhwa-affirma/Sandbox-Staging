@isTest
public class emailAttachmentVisibleOnParentTest {
  static testmethod void attachmentTester() {
        
        Case cse = new Case();
            cse.Brand__c = 'Spectrum';
            cse.Status = 'Open';
        insert cse; 
        
        EmailMessage em = new EmailMessage();
            em.ParentId = cse.Id;
        insert em;
                    
        Attachment a = new Attachment();
            a.name = 'test attachment';
            a.body = blob.valueof('attachment body');
            a.parentid = em.Id;
       insert a;   

    }
}