@isTest
public class DocusignTriggerTest {
private static string Ids1;
    
    @TestSetup
    public static void setup() {

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
        
      System.debug('hello from setup');
        
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
        ids1=cs.Id;
        System.debug('ids1==' + ids1);
    }

    static testMethod void testMethod1(){
        
        Test.startTest();
        Profile[] p1 = [select Id from Profile where Name = 'CFCU Admin' limit 1];
        User user1 = new User(alias = 'u1',lastname='test999', languagelocalekey='en_US', 
                              email='User1@avfg.com', emailencodingkey='UTF-8', 
                              localesidkey='en_US', profileId = p1[0].id, timezonesidkey='America/Los_Angeles', 
                              username='test9991'+'@avfg.com');
        
        Case cs = new Case();
        cs.Brand__c = 'Chevron';
        cs.Previous_Owner__c = user1.Id;
        insert cs;
        
        dsfs__DocuSign_Status__c ds = new dsfs__DocuSign_Status__c();
        ds.dsfs__Envelope_Status__c = 'sent';
        ds.dsfs__Case__c = cs.Id;
        insert ds;

        Test.stopTest();   
    }
    static testMethod void testMethod2(){
        
        Test.startTest();
        Profile[] p1 = [select Id from Profile where Name = 'CFCU Admin' limit 1];
        User user1 = new User(alias = 'u1',lastname='test999', languagelocalekey='en_US', 
                              email='User1@avfg.com', emailencodingkey='UTF-8', 
                              localesidkey='en_US', profileId = p1[0].id, timezonesidkey='America/Los_Angeles', 
                              username='test9991'+'@avfg.com');
        
        Case cs = new Case();
        cs.Brand__c = 'Chevron';
        cs.Previous_Owner__c = user1.Id;
        insert cs;
        
        dsfs__DocuSign_Status__c ds = new dsfs__DocuSign_Status__c();
        ds.dsfs__Envelope_Status__c = 'Completed';
        ds.dsfs__Case__c = cs.Id;
        insert ds;

        Test.stopTest();   
    }
    static testMethod void testMethod3(){
        
        Test.startTest();
        Profile[] p1 = [select Id from Profile where Name = 'CFCU Admin' limit 1];
        User user1 = new User(alias = 'u1',lastname='test999', languagelocalekey='en_US', 
                              email='User1@avfg.com', emailencodingkey='UTF-8', 
                              localesidkey='en_US', profileId = p1[0].id, timezonesidkey='America/Los_Angeles', 
                              username='test9991'+'@avfg.com');
        
        Case cs = new Case();
        cs.Brand__c = 'Chevron';
        cs.Previous_Owner__c = user1.Id;
        insert cs;
        
        dsfs__DocuSign_Status__c ds = new dsfs__DocuSign_Status__c();
        ds.dsfs__Envelope_Status__c = 'Voided';
        ds.dsfs__Case__c = cs.Id;
        insert ds;

        Test.stopTest();   
    }
    static testMethod void testMethod4(){
        
        Test.startTest();
        Profile[] p1 = [select Id from Profile where Name = 'CFCU Admin' limit 1];
        User user1 = new User(alias = 'u1',lastname='test999', languagelocalekey='en_US', 
                              email='User1@avfg.com', emailencodingkey='UTF-8', 
                              localesidkey='en_US', profileId = p1[0].id, timezonesidkey='America/Los_Angeles', 
                              username='test9991'+'@avfg.com');
        
        Case cs = new Case();
        cs.Brand__c = 'Chevron';
        cs.Previous_Owner__c = user1.Id;
        insert cs;
        
        dsfs__DocuSign_Status__c ds = new dsfs__DocuSign_Status__c();
        ds.dsfs__Envelope_Status__c = 'Declined';
        ds.dsfs__Case__c = cs.Id;
        insert ds;

        Test.stopTest();   
    }
    static testMethod void testMethod5(){
        
        Test.startTest();
        Profile[] p1 = [select Id from Profile where Name = 'CFCU Admin' limit 1];
        User user1 = new User(alias = 'u1',lastname='test999', languagelocalekey='en_US', 
                              email='User1@avfg.com', emailencodingkey='UTF-8', 
                              localesidkey='en_US', profileId = p1[0].id, timezonesidkey='America/Los_Angeles', 
                              username='test9991'+'@avfg.com');
        
        Case cs = new Case();
        cs.Brand__c = 'Chevron';
        cs.Previous_Owner__c = user1.Id;
        insert cs;
       
        dsfs__DocuSign_Status__c ds = new dsfs__DocuSign_Status__c();
        ds.dsfs__Envelope_Status__c = 'Authentication Failed';
        ds.dsfs__Case__c = cs.Id;
        insert ds;

        Test.stopTest();   
    }
}