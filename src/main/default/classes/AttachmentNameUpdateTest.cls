@isTest
Public class AttachmentNameUpdateTest{

    public static testmethod void updatetestmethod(){
    	
        Member_Comment__c	mem1 =  [select id from Member_Comment__c where Member_Email__c = 'mem1@mem1.com' limit 1];
		Member_Comment__c	mem =  [select id from Member_Comment__c where Member_Email__c = 'mem@mem.com' limit 1];
		
        string before = 'Testing base 64 encode';            
        Blob beforeblob = Blob.valueOf(before);
          
        Test.startTest();
        ContentVersion cv = new ContentVersion();
        cv.title = 'test content trig54+-+ger';      
        cv.PathOnClient ='test';           
        cv.VersionData =beforeblob;          
        insert cv; 
         
        ContentVersion testContent = [SELECT id, ContentDocumentId FROM ContentVersion where Id = :cv.Id];
     
        Attachment attach1=new Attachment();    
        attach1.Name='Unit Test Attachment';
        Blob bodyBlob1=Blob.valueOf('Unit Test Attachment Body');
        attach1.body=bodyBlob1;
        attach1.parentId=mem.id;
        insert attach1;
        Test.stoptest();
    }
    
     public static testMethod void updateAttachmentTest(){
     	
     	Case cas = [select id from case where Subject = 'TestCaseSubject123' limit 1];
     
		Test.startTest();
		Attachment attach=new Attachment();    
        attach.Name='Unit Test Attachment';
        Blob bodyBlob=Blob.valueOf('Unit Test Attachment Body');
        attach.body=bodyBlob;
        attach.parentId=cas.id;
        insert attach;
        
        Approve_Attachment__c ap = new Approve_Attachment__c();
        //ap.name = 'Test123';
        ap.Attachment_Id__c = attach.id;
        ap.Case_ID__c = cas.id;
        insert ap; 
     
        attach.name = 'Test123';
        Update attach;
        delete attach;
		Test.stoptest();
	}
	
    @testSetup static void mName(){
		
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
         
        Member_Comment__c mem1 = new Member_Comment__c();
        mem1.Case__c = cas1.id;
		mem1.Member_Communication__c = '123';
		mem1.Member_Email__c = 'mem1@mem1.com';
        insert mem1;
        
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
        insert sl;
       
	}
    public static testMethod void updateAttachmentTest2(){
     	
     	Solar_Loans__c sl = [select id from Solar_Loans__c where Joint_First_Name__c = 'Tom' limit 1];
     
		Test.startTest();
		Attachment attach=new Attachment();    
        attach.Name='Unit Test Attachment';
        Blob bodyBlob=Blob.valueOf('Unit Test Attachment Body');
        attach.body=bodyBlob;
        attach.parentId=sl.id;
        insert attach;
        
        attach.name = 'Test123';
        Update attach;
        delete attach;
		Test.stoptest();
	}

}