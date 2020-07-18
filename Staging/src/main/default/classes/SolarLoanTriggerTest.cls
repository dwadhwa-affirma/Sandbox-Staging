@isTest
public class SolarLoanTriggerTest {
    
    @TestSetup
    public static void setup() {
    	 
        User u = [SELECT Id,Email,username FROM User WHERE Email ='drana@chevronfcu.org'];
		
        Account ac = new Account();
        ac.FirstName = 'Jeff';
        ac.LastName = 'Franklin';
        insert ac;
        
        Account_Details__c ad = new Account_Details__c();
        ad.Name = '0000269355';
        ad.Reference__c = 'BC01';
        insert ad;
        
        Account_Details__c ad1 = new Account_Details__c();
        ad1.Name = '0000247286';
        ad1.Reference__c = 'BC01';
        insert ad1;
        
        Person_Account__c pa = new Person_Account__c();
        pa.account_number__c = ad.id;
        pa.PersonID__c = ac.id;
        insert pa;
        
        Person_Account__c pa1 = new Person_Account__c();
        pa1.account_number__c = ad1.id;
        pa1.PersonID__c = ac.id;
        insert pa1;
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
            sl.Member_Name__c = ac.id;
            sl.Member_Number__c = '269355';
            insert sl;
        	
            sl.Member_Number__c = '247286';
            update sl;
            
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
        
        DocuSign_Templates__c ds = new DocuSign_Templates__c();
        ds.Name = 'Chevron';
        ds.TemplateId__c = 'ad01d585-ad0a-4e68-b537-7e75293f0ef8';
        insert ds;
        
        DocuSign_Templates__c ds1 = new DocuSign_Templates__c();
        ds1.Name = 'Spectrum';
        ds1.TemplateId__c = 'dc16d8f8-571c-497e-bbf5-42d8b25d4ee1';
        insert ds1;
        
        String userName = UserInfo.getUserName();
		User activeUser = [Select Email From User where Username = : userName limit 1];
		String userEmail = activeUser.Email;
        
        System.runAs(u){
            Solar_Loans__c s = [select id,Status__c,DocuSignId__c from Solar_Loans__c where Status__c = 'New'];
            s.Status__c = 'ACH Pending';    
            update s; 
        }
    }
	
    static testMethod void testMethod3(){
     
        User u = [SELECT Id,Email FROM User WHERE Email ='drana@chevronfcu.org'];
        
        System.runAs(u){
            
            Solar_Loans__c s = [select id,Status__c,DocuSignId__c from Solar_Loans__c where Status__c = 'New'];
            s.Status__c = 'Approved';
            update s;
            
            Solar_Loans__c s1 = [select id,Status__c,DocuSignId__c from Solar_Loans__c where Status__c = 'Approved'];
            s1.Status__c = 'Completed';
            update s1; 
        }
    }
}