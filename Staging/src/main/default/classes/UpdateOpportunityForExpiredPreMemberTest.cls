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
private class UpdateOpportunityForExpiredPreMemberTest {

   static testMethod void myUnitTest() {
     
   

      
    
        RecordType rec1 = [Select Name, Id From RecordType where sObjectType='Account' and isActive=true and Name='Pre Member'];
       
        Datetime days120 = Datetime.now().addDays(-120);
	
        Account pact = new Account();
        pact.FirstName = 'Test';
        pact.LastName = 'Test1';
        pact.PersonEmail = 'test@test.com';
        pact.RecordtypeId = rec1.Id;
        pact.Residential_Street__pc ='11';
        pact.Home_Phone__pc ='011-11111';
       
        insert pact;
        Test.setCreatedDate(pact.Id, days120);
        
        opportunity opp = new Opportunity();
        opp.Accountid = pact.id;
        opp.Name = 'Name';
        opp.StageName = 'New';
        opp.CloseDate = system.today();
        opp.Is_Converted__c = true;
        opp.Opportunity_Source__c = 'Word of mouth';
        
        insert opp;
        
        
         String CRON_EXP = '0 0 0 15 3 ? *';
         
        Test.startTest();
       	
    		
            String jobId = System.schedule('ScheduleApexClassTest',  CRON_EXP, new UpdateOpportunityForExpiredPreMember());
            CronTrigger ct = [SELECT Id, CronExpression, TimesTriggered, NextFireTime FROM CronTrigger WHERE id = :jobId];
            System.assertEquals(CRON_EXP, ct.CronExpression);
            System.assertEquals(0, ct.TimesTriggered);
            
           Test.stopTest();
        
    }
}