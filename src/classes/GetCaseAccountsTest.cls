@isTest
public class GetCaseAccountsTest {
	
	static testMethod void testMethod1() {
		
		List<String> accountids = new List<String>();
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
        accountids.add(accDetails.Id);
        
        Account_Details__c accDetails1 = new Account_Details__c();
        accDetails1.Name = '0000456';
        accDetails1.RecType__c = 'ACCT';
        insert accDetails1;
         accountids.add(accDetails1.Id);
        
        Case case1 = new Case();
        case1.Subject = 'Test';
        case1.Description = 'test';
        case1.Accountid = acobj.Id;
        case1.Brand__c ='Spectrum';
        case1.Account_Number__c = accDetails.id;
        insert case1;
        
       CaseAccountMemberDetail__c camd = new CaseAccountMemberDetail__c();
       camd.case__c = case1.id;
       camd.Account_Name__c = accDetails.Name;
       camd.MemberAccountid__c = accDetails.Id;
       insert camd;
       
        CaseAccountMemberDetail__c camd1 = new CaseAccountMemberDetail__c();
       camd1.case__c = case1.id;
       camd1.Account_Name__c = accDetails1.Name;
       camd1.MemberAccountid__c = accDetails1.Id;
       insert camd1;
       
        Person_Account__c pa = new Person_Account__c();
        pa.PersonID__c = acobj.Id;
        pa.Account_Number__c = accDetails.Id;        
        insert pa;
        
        Person_Account__c pa1 = new Person_Account__c();
        pa1.PersonID__c = acobj.Id;
        pa1.Account_Number__c = accDetails1.Id;        
        insert pa1;
        
         Test.StartTest();

         GetCaseAccounts.GetAllAccounts(case1.id);	     
         GetCaseAccounts.AddAccountsandSave(case1.id, accountids);   
	      
        Test.StopTest();
	    }
    
}