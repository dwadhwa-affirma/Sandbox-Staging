@isTest
public class Accounts360ViewControllerTest {

    static testMethod void testMethod1(){
      
        Account_Details__c accDetails = new Account_Details__c();
        accDetails.Name = 'Test';
        accDetails.RecType__c = 'ACCT';
        insert accDetails;
        
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
        pa.Account_Number__c = accDetails.Id;        
        insert pa;
        
         
        Case c = new Case();
        c.AccountId = acc.Id;
        c.State__c = 'Open';
        c.Brand__c = 'Chevron';
        c.Account_Number__c = accDetails.Id;
        insert c;
         test.startTest();
        CaseComment cc = new CaseComment();
        cc.ParentId = c.Id;
        insert cc;
        
        
        Task t = new Task();
        t.WhatId = c.Id;
        insert t;
        
      
        PageReference pageRef = Page.Accounts360View;
        Test.setCurrentPage(pageRef);
        ApexPages.currentPage().getParameters().put('Id', accDetails.Id);        
       Accounts360ViewController controller = new Accounts360ViewController(new ApexPages.StandardController(accDetails));
        test.stopTest();
    }
    
    static testMethod void testMethod2(){
         test.startTest();
        Account_Details__c accDetails = new Account_Details__c();
        accDetails.Name = 'Test';
        accDetails.RecType__c = 'ACCT';
        insert accDetails;
        
        map<string,Id> docMap = new map<string,Id>(); 
        
        PageReference pageRef = Page.Accounts360View;
        Test.setCurrentPage(pageRef);
        ApexPages.currentPage().getParameters().put('Id', accDetails.Id);        
        Accounts360ViewController controller = new Accounts360ViewController(new ApexPages.StandardController(accDetails));
        Accounts360ViewController.warningStringWrapper wrp = new Accounts360ViewController.warningStringWrapper(accDetails.Id,'test2', Date.newInstance(2015, 2, 1), 'test3','test4','test5', 'test6', docMap,'Warning Code');
        test.stopTest();
    }
}