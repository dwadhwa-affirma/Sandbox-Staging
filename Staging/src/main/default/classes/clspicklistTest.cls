@isTest
public class clspicklistTest {
    
    static testMethod void getDependentOptionsImplTest(){        
    	test.StartTest();
    	
        System.Assert(clspicklist.getDependentOptionsImpl('Lead', 'status', 'Sub_Status__c') != null);
        test.StopTest();
    }
}