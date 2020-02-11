@isTest
public class emailAttachmentVisibleOnParentTest {
  static testmethod void attachmentTester() {
        
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