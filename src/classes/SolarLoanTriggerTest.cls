@isTest
public class SolarLoanTriggerTest {
    
    @TestSetup
    public static void setup() {
    	
        User u = [SELECT Id,Email,username FROM User WHERE Email ='drana@chevronfcu.org'];
		
		System.runAs(u){        
            Solar_Loans__c sl = new Solar_Loans__c();
            sl.Status__c = 'Pending';
            sl.Primary_First_Name__c = 'Tom';
            sl.Primary_Last_Name__c = 'Jerry';
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
            Solar_Loans__c s = [select id,Status__c,DocuSignId__c from Solar_Loans__c where Status__c = 'Pending'];
            s.Status__c = 'ACH Pending';    
            update s; 
        }
    }

}