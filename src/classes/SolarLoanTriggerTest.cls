@isTest
public class SolarLoanTriggerTest {
    
    @TestSetup
    public static void setup() {
    	 
        User u = [SELECT Id,Email,username FROM User WHERE Email ='drana@chevronfcu.org'];
		
        SolarLoan_Docusign_Emails__c sde = new SolarLoan_Docusign_Emails__c();
        sde.Name = 'Email For Testing';
        sde.Emails__c = 'drana@chevronfcu.org';
        insert sde;
        
		System.runAs(u){        
            Solar_Loans__c sl = new Solar_Loans__c();
            sl.Status__c = 'New';
            sl.Primary_First_Name__c = 'Tom';
            sl.Primary_Last_Name__c = 'Jerry';
            sl.Joint_SSN__c = '1715';
            sl.ACH__c = 'True';
            sl.Brand__c = 'Chevron';
            sl.Due_Date__c = System.today();
            sl.Additional_Amount__c = 10000.00;
            sl.ABA_Bank_Name__c = 'US BANK NA';
            insert sl;
        	
            System.debug('Current User: ' + UserInfo.getUserName());

            System.debug('ttt');
            System.debug('ttt1' + u);
            
            Account a = new Account();
            a.FirstName = 'Tom';
            a.LastName =   'Jerry';
            a.PersonEmail = 'jrakesh@affirma.com';
            insert a;
        }
    }
    static testMethod void testMethod1(){
     
        User u = [SELECT Id,Email FROM User WHERE Email ='drana@chevronfcu.org'];
        
        System.runAs(u){
            Solar_Loans__c s = [select id,Status__c,DocuSignId__c from Solar_Loans__c where Status__c = 'New'];
            s.Status__c = 'ACH Pending';    
            update s; 
        }
    }
	
    static testMethod void testMethod2(){
     
        User u = [SELECT Id,Email FROM User WHERE Email ='drana@chevronfcu.org'];
        
        System.runAs(u){
            Solar_Loans__c s = [select id,Status__c,DocuSignId__c from Solar_Loans__c where Status__c = 'New'];
            s.Status__c = 'Approved';    
            update s; 
        }
    }
    static testMethod void testMethod3(){
     
        User u = [SELECT Id,Email FROM User WHERE Email ='drana@chevronfcu.org'];
        
        System.runAs(u){
            Solar_Loans__c s = [select id,Status__c,DocuSignId__c from Solar_Loans__c where Status__c = 'New'];
            s.Status__c = 'Completed';
            update s; 
        }
    }
}