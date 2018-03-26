@isTest
public class DocusignTriggerTest {

    static testMethod void testMethod1(){
        
        Profile[] p1 = [select Id from Profile where Name = 'CFCU Admin' limit 1];
        
        User user1 = new User(alias = 'u1',lastname='test999', languagelocalekey='en_US', 
                              email='User1@avfg.com', emailencodingkey='UTF-8', 
                              localesidkey='en_US', profileId = p1[0].id, timezonesidkey='America/Los_Angeles', 
                              username='test9991'+'@avfg.com');
        
        insert user1;
        
         Case cs = new Case();
           cs.Brand__c = 'Chevron';
           cs.Previous_Owner__c = user1.Id;
           
        insert cs;
        
        dsfs__DocuSign_Status__c ds = new dsfs__DocuSign_Status__c();
            ds.dsfs__Envelope_Status__c = 'Sent';
            ds.dsfs__Case__c = cs.Id;
        insert ds;
        
        ds.dsfs__Envelope_Status__c = 'Completed';
        update ds;
       
        ds.dsfs__Envelope_Status__c = 'Voided';
        update ds;
        
        ds.dsfs__Envelope_Status__c = 'Declined';
        update ds;
        
        ds.dsfs__Envelope_Status__c = 'Authentication Failed';
        update ds;        
    }
}