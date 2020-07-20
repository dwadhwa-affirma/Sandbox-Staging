@isTest
public class XpressRefiTriggerTest {
	 public static testMethod void testInsert(){
         Xpress_Refi__c xr = new Xpress_Refi__c();
         xr.Status__c ='ready';
         xr.Loan_Number__c='200';
         xr.Borrower_1_Name__c = 'test';
         xr.City__c= 'city1';
         xr.Current_Balance__c= 100;
         xr.Current_Principal_and_Interest_Payment__c= 200;
         xr.Current_Loan_Program__c= 'loan1';
         xr.Property_Address__c='a1';
         xr.Rate_Sheet_Date__c = Date.today();
         xr.State__c = 's1';
         xr.Zip_Code__c = 11.00;
         
         insert xr;
         xr.Loan_Number__c='300';
         update xr;
     }
  
    
}