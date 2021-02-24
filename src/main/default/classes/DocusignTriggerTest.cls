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
    static testMethod void testMethod6(){
        
        Test.startTest();
        Profile[] p1 = [select Id from Profile where Name = 'CFCU Admin' limit 1];
        User user1 = new User(alias = 'u1',lastname='test999', languagelocalekey='en_US', 
                              email='User1@avfg.com', emailencodingkey='UTF-8', 
                              localesidkey='en_US', profileId = p1[0].id, timezonesidkey='America/Los_Angeles', 
                              username='test9991'+'@avfg.com');
        
        Solar_Loans__c sl = new Solar_Loans__c();
        sl.Joint_First_Name__c ='Tom';
        sl.Joint_Last_Name__c = 'Jerry';
        sl.Joint_DOB__c = System.today();
        sl.Joint_SSN__c =  '1715';
        sl.Joint_FICO_Score__c = 12.00;
        sl.Joint_City__c = 'city';
        sl.Joint_State__c = 'PA';
        sl.Joint_Zip_Code__c =  '12345';
        sl.Joint_Address_1__c = 'street';
        sl.Joint_Address_2__c = 'street2';
        
        sl.Primary_First_Name__c ='Tom';
        sl.Primary_Last_Name__c = 'Jerry';
        sl.Primary_DOB__c = System.today();
        sl.Primary_SSN__c =  '1715';
        sl.Primary_Address_1__c = 'Add';
        sl.Primary_FICO_Score__c = 12.00;
        sl.Primary_City__c = 'city';
        sl.Primary_State__c = 'PA';
        sl.Primary_Zip_Code__c =  '12345';
        sl.Legal_Description__c = 'test';
        sl.Product__c = 'product';
        sl.Module__c = 'module';
        sl.Installer_Number__c = '12';
        sl.Inverter__c = 'inverter';
        sl.System_Size_kW__c = 12.00;
        sl.Battery__c = 'barary';
        sl.Installer__c = 'intealer';
        sl.Application_Date__c = system.today();
        sl.Mortgage_Balance__c = 1299.00;
        sl.Final_Payment_Amount__c = 111.00;
        sl.Go_To_Payment__c = 1252.00;
        sl.Bank_Name__c = 'test & bank';
        sl.Membership_Fee__c = 126.00;
        sl.Net_Funding_Amount__c = 1213.00;
        sl.Loan_Amount__c = 1211.00;
        sl.Loan_Pmt_Amount__c = 1245.00;
        sl.Credit_Exception__c = 'cr';
        sl.ITC_Rate__c = 2.00;
        sl.ITC_Amount__c = 1245.88;
        sl.Term_months__c = 12;
        sl.OID_Fee__c = 11;
        sl.Approval_Date__c = system.today();
        sl.ECOA_Code__c = '2';
        sl.Site_UUID__c = '11';
        sl.FNI__c = '12';
        sl.Member_Number__c = '0000147163';
        sl.Status__c = 'New'; 
        sl.ACH__c = 'True';
        sl.DocuSignId__c  = '48a5846a-d3bd-4cd0-862c-39c1925b49f7';
        insert sl;
       
        dsfs__DocuSign_Status__c ds = new dsfs__DocuSign_Status__c();
        ds.dsfs__Envelope_Status__c = 'Sent';
        ds.dsfs__DocuSign_Envelope_ID__c = '48a5846a-d3bd-4cd0-862c-39c1925b49f7';
        insert ds;
        
        ContentVersion objAt = new ContentVersion(Title = 'Test Document',PathOnClient = 'TestDocument.pdf',VersionData = Blob.valueOf('Test Content'), IsMajorVersion = true);
     	Insert objAt;
        
        List<ContentDocument> cdList = [SELECT Id, Title, LatestPublishedVersionId FROM ContentDocument];
        
        List<ContentDocumentLink> ListCDL = new List<ContentDocumentLink>{
     		new ContentDocumentLink (ContentDocumentId = cdList[0].id, LinkedEntityId = ds.Id)};
     	insert ListCDL;
        
        ds.dsfs__Envelope_Status__c = 'Completed';
		update ds;
        
        Test.stopTest();   
    }
}