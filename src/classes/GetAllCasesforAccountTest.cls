/**
 * This class contains unit tests for validating the behavior of Apex classes
 * and triggers.
 *
 * Unit tests are class methods that verify whether a particular piece
 * of code is working properly. Unit test methods take no arguments,
 * commit no data to the database, and are flagged with the testMethod
 * keyword in the method definition.
 *
 * All test methods in an organization are executed whenever Apex code is deployed
 * to a production organization to confirm correctness, ensure code
 * coverage, and prevent regressions. All Apex classes are
 * required to have at least 75% code coverage in order to be deployed
 * to a production organization. In addition, all triggers must have some code coverage.
 * 
 * The @isTest class annotation indicates this class only contains test
 * methods. Classes defined with the @isTest annotation do not count against
 * the organization size limit for all Apex scripts.
 *
 * See the Apex Language Reference for more information about Testing and Code Coverage.
 */
@isTest
private class GetAllCasesForAccountTest {

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
        
        Case case4 = new Case();
        case4.Subject = 'Test';
        case4.Description = 'test';
        case4.Accountid = acobj.Id;
        case4.Brand__c ='Spectrum';
        case4.ParentId = case1.id;
        insert case4;
        
        Case case5 = new Case();
        case5.Subject = 'Test';
        case5.Description = 'test';
        case5.Accountid = acobj.Id;
        case5.Brand__c ='Spectrum';
        case5.Parentid = case1.id; 
        insert case5;
        
      	
      	System.currentPageReference().getParameters().put('recId',case1.Id);
            
            String Caseids = case2.id + ',' + case3.id;
            
       
        Test.StartTest(); 
            
            GetAllCasesForAccount ga = new GetAllCasesForAccount();
            ga.Caseids = Caseids;
            ga.ButtonSave_Click();
             
            
        
	   		
       
       
        	List<String> caseids1 = new List<String>();
        	caseids1.Add(case3.id);
           
            GetAllCasesForAccount.GetAllCases(case1.id);
	        GetAllCasesForAccount.ButtonSave_Click1(case1.id,caseids1); 
	        RelatedCaseList.GetRelatedCases(case1.id);
        Test.StopTest();
        
    }
}