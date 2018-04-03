@isTest
private class GetAllCasesforAccountTest {

    static testMethod void myUnitTest() {
         Account acobj = new Account();
        acobj.FirstName = 'U';
        acobj.LastName = 'D';
        acobj.BIRTH_DATE__pc = date.parse('04/04/1963');
        acobj.Employee_Restricted_Access__c = 1234;
        acobj.Home_Phone__pc = '9169954478';
        insert acobj;
        
        Case case1 = new Case();
        case1.Subject = 'Test';
        case1.Description = 'test';
        case1.Accountid = acobj.Id;
        case1.Brand__c ='Spectrum';
        insert case1;
        
         Case case2 = new Case();
        case2.Subject = 'Test';
        case2.Description = 'test';
        case2.Accountid = acobj.Id;
        case2.Brand__c ='Spectrum';
        insert case2;
        
        Case case3 = new Case();
        case3.Subject = 'Test';
        case3.Description = 'test';
        case3.Accountid = acobj.Id;
        case3.Brand__c ='Spectrum';
        insert case3;
        
       
        Test.StartTest(); 
        	String Caseids = case2.id + ',' + case3.id;
	         System.currentPageReference().getParameters().put('recId',case1.Id);
	         
	         List<string> cids = new List <string>();
	         List<Case> cdataToNull = new List<Case>();
	     //   system.debug('CaseId==============' + CaseId);
	       case CaseDetail = new Case();
	        
			CaseDetail = [Select Id,AccountID from Case where Id =: case1.Id limit 1];
	     	 //List <case>  CaseList = [Select Id, AccountId,Account_Number__c,Brand__c,CaseNumber,Case_type__c, Status, Subject, Description from Case where Accountid =: CaseDetail.AccountId and id !=: case1.Id];
	        //list<Case>	ListCaseSelected = [select id from Case where ParentId =: case1.id];
	        //GetAllCasesForAccount ga = new GetAllCasesForAccount();
	        // ApexPages.currentPage().getParameters().put('recid',case1.Id);
	        //ga.ButtonSave_Click();
	        
        Test.StopTest();
        
    }
}