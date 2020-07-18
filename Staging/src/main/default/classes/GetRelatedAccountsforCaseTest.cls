@isTest
public class GetRelatedAccountsforCaseTest {
    static testMethod void testMethod1() {
	 	
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
        
        Account acobj = new Account();
        acobj.FirstName = 'U';
        acobj.LastName = 'D';
        acobj.BIRTH_DATE__pc = date.parse('04/04/1963');
        acobj.Employee_Restricted_Access__c = 1234;
        acobj.Home_Phone__pc = '9169954478';
        insert acobj;
        
	 	 Account_Details__c accDetails = new Account_Details__c();
        accDetails.Name = '0000123';
        accDetails.RecType__c = 'ACCT';
        insert accDetails;
   
        
        Account_Details__c accDetails1 = new Account_Details__c();
        accDetails1.Name = '0000456';
        accDetails1.RecType__c = 'ACCT';
        insert accDetails1;
   
        Case case1 = new Case();
        case1.Subject = 'Test';
        case1.Description = 'test';
        case1.Accountid = acobj.Id;
        case1.Brand__c ='Spectrum';
        case1.Account_Number__c = accDetails.id;
        insert case1;
        
        CaseAccountMemberDetail__c camd1 = new CaseAccountMemberDetail__c();
        camd1.Account_Name__c = accDetails1.Name;
        camd1.Case__c = case1.id;
        camd1.MemberAccountid__c = accDetails1.Id;
        
        insert camd1;
        
         CaseAccountMemberDetail__c camd2 = new CaseAccountMemberDetail__c();
        camd1.Account_Name__c = accDetails.Name;
        camd1.Case__c = case1.id;
        camd1.MemberAccountid__c = accDetails.Id;
        
        insert camd2;
        
      
         Test.StartTest();

         GetRelatedAccountsforCase.GetCaseAccounts(case1.id);	        
	      
        Test.StopTest();
	    }
    
}