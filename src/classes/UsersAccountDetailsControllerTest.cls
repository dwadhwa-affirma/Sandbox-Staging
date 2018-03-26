@isTest
public class UsersAccountDetailsControllerTest {
    static testmethod void testmethod1(){
     //  Account acc = [Select Id from Account Where isPersonAccount = True Limit 1];
        Account_Details__c accDetail = new Account_Details__c();
        accDetail.Name = 'Test';
        accDetail.RecType__c = 'ACCT';
        insert accDetail;
        
        String RecTypeId= [select Id from RecordType where (Name='Person Account') and (SobjectType='Account')].Id;
        
        Account acc = new Account(
           RecordTypeID=RecTypeId,
           FirstName='Test FName',
           LastName='Test LName',
           PersonMailingStreet='test@yahoo.com',
           PersonMailingPostalCode='12345',
           PersonMailingCity='SFO',
           PersonEmail='test@yahoo.com',
           PersonHomePhone='1234567',
           PersonMobilePhone='12345678');
         
        insert acc;
        
        Person_Account__c pa = new Person_Account__c();
        pa.PersonID__c = acc.Id;
        pa.Account_Number__c = accDetail.Id;        
        insert pa;
        
        Case c = new Case();
        c.AccountId = acc.Id;
        c.State__c = 'Open';
        c.Brand__c = 'Chevron';
        insert c;
        
        CaseComment cc = new CaseComment();
        cc.ParentId = c.Id;
        insert cc;
        
        Task t = new Task();
        t.WhatId = c.Id;
        insert t;
            
        PageReference pageRef = Page.UsersAccountDetails;
        Test.setCurrentPage(pageRef);        
        ApexPages.currentPage().getParameters().put('ID', acc.Id);
        UsersAccountDetailsController controller = new UsersAccountDetailsController(new ApexPages.StandardController(acc));
   }
    
    static testmethod void testmethod2(){
        
        String RecTypeId= [select Id from RecordType where (Name='Person Account') and (SobjectType='Account')].Id;
        
        Account acc = new Account(
           RecordTypeID=RecTypeId,
           FirstName='Test FName',
           LastName='Test LName',
           PersonMailingStreet='test@yahoo.com',
           PersonMailingPostalCode='12345',
           PersonMailingCity='SFO',
           PersonEmail='test@yahoo.com',
           PersonHomePhone='1234567',
           PersonMobilePhone='12345678');
         
        insert acc;
        
        Account_Details__c accDetail = new Account_Details__c();
        accDetail.Name = 'Test';
        accDetail.RecType__c = 'ACCT';
        insert accDetail;
        
        PageReference pageRef = Page.UsersAccountDetails;
        Test.setCurrentPage(pageRef);
        ApexPages.currentPage().getParameters().put('ID', acc.Id);
        
        map<string,Id> docMap = new map<string,Id>();

        UsersAccountDetailsController controller = new UsersAccountDetailsController(new ApexPages.StandardController(acc));
        UsersAccountDetailsController.warningStringWrapper wrp=new UsersAccountDetailsController.warningStringWrapper(accDetail.Id,'test2', Date.newInstance(2016, 5, 3), 'test3','test4','test5', docMap,'ACCT','Warning Code');
    }
}