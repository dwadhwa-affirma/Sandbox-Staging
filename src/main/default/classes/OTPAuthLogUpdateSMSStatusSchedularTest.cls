@isTest
public class OTPAuthLogUpdateSMSStatusSchedularTest {

	public static testMethod void test1(){    
    
        Test.StartTest();
        
        OTP_SMS_Status_Settings__c osss = new OTP_SMS_Status_Settings__c();
        osss.Minutes_to_Add__c = 3;
        osss.Minutes_to_sub__c = 1;
        osss.name = 'Primary Record';
        insert osss;    
          
        Authenticated_Log__c al = new Authenticated_Log__c ();
        al.OTP_Phone__c = '510-210-2519';
        insert al;
        
     	OTPAuthLogUpdateSMSStatusSchedular m = new OTPAuthLogUpdateSMSStatusSchedular();
     	String sch = '0 0 23 * * ?'; 
        system.schedule('Test', sch, m);
        
        Test.stopTest();
    }
}