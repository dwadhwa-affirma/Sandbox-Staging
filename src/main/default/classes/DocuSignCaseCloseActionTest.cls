@isTest
public class DocuSignCaseCloseActionTest {
    
    static testMethod void testMethod1(){
        Profile[] p1 = [select Id from Profile where Name = 'CFCU Admin' limit 1];
        
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
        
        Create_SLA__c cl3 = new Create_SLA__c();
        cl3.Status__c = 'Closed';
        cl3.Name = 'Closed';
        cl3.hours__c = 2;
        insert cl3;
        
        User user1 = new User(alias = 'u1',lastname='test999', languagelocalekey='en_US', 
                              email='User1@avfg.com', emailencodingkey='UTF-8', 
                              localesidkey='en_US', profileId = p1[0].id, timezonesidkey='America/Los_Angeles', 
                              username='test9991'+'@avfg.com');
        
        insert user1;
        list<id> lstid = new List<id>();
        Case cs = new Case();
        cs.Brand__c = 'Chevron';
        cs.Previous_Owner__c = user1.Id;
        
        insert cs;
        lstid.add(cs.id);
                
        Test.startTest();
        
        OnBase_Document__c onbaseDocObj = new OnBase_Document__c();
        onbaseDocObj.Document_Type__c = '';
        onbaseDocObj.case__c = cs.id;
        onbaseDocObj.Move_To_OnBase_Date__c = system.now();
        insert onbaseDocObj;
        
        DocuSignCaseCloseAction.CheckCondition(lstid);
        
        cs.Origin = 'Portal';
        update cs;
        
        DocuSignCaseCloseAction.CheckCondition(lstid);
        
        Test.stopTest();   
    }
    static testMethod void testMethod2(){
        Profile[] p1 = [select Id from Profile where Name = 'CFCU Admin' limit 1];
        
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
        
        Create_SLA__c cl3 = new Create_SLA__c();
        cl3.Status__c = 'Closed';
        cl3.Name = 'Closed';
        cl3.hours__c = 2;
        insert cl3;
        
        User user1 = new User(alias = 'u1',lastname='test999', languagelocalekey='en_US', 
                              email='User1@avfg.com', emailencodingkey='UTF-8', 
                              localesidkey='en_US', profileId = p1[0].id, timezonesidkey='America/Los_Angeles', 
                              username='test9991'+'@avfg.com');
        
        insert user1;
        list<id> lstid = new List<id>();
        Case cs = new Case();
        cs.Brand__c = 'Chevron';
        cs.Secondary_Category__c = 'Onboarding';
        cs.Previous_Owner__c = user1.Id;
        
        insert cs;
        
        lstid.add(cs.id);
        Test.startTest();
		
        DocuSignCaseCloseAction.CheckCondition(lstid);
        
        cs.Origin = 'Portal';
        update cs;
        
        DocuSignCaseCloseAction.CheckCondition(lstid);
        
        Test.stopTest();   
    }
    static testMethod void testMethod3(){
        Profile[] p1 = [select Id from Profile where Name = 'CFCU Admin' limit 1];
        
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
        
        Create_SLA__c cl3 = new Create_SLA__c();
        cl3.Status__c = 'Closed';
        cl3.Name = 'Closed';
        cl3.hours__c = 2;
        insert cl3;
        
        User user1 = new User(alias = 'u1',lastname='test999', languagelocalekey='en_US', 
                              email='User1@avfg.com', emailencodingkey='UTF-8', 
                              localesidkey='en_US', profileId = p1[0].id, timezonesidkey='America/Los_Angeles', 
                              username='test9991'+'@avfg.com');
        
        insert user1;
        list<id> lstid = new List<id>();
        Case cs = new Case();
        cs.Brand__c = 'Chevron';
        cs.Previous_Owner__c = user1.Id;
        
        insert cs;
        lstid.add(cs.id);
        Test.startTest();
        
        Task t = new Task();
        t.Subject = 'test';
        t.WhatId = cs.id;
        insert t;
        
        DocuSignCaseCloseAction.CheckCondition(lstid);
        
        cs.Origin = 'Portal';
        update cs;
        
        DocuSignCaseCloseAction.CheckCondition(lstid);
        
        Test.stopTest();   
    }
}