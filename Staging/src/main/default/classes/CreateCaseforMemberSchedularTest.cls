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
private class CreateCaseforMemberSchedularTest {
 
 @testSetup static void setup() {
 	 
 	 MemberConversionSetting__c mcs = new MemberConversionSetting__c();
     mcs.Automation__c = 10;
     mcs.Manual__c = 10;
     mcs.Name = 'PrimaryRecord';
     mcs.Not_matched_Members_cut_off_window__c = 3;
     insert mcs;
     
     RecordType rec = [Select Name, Id From RecordType where sObjectType='Account' and isActive=true and Name='Person Account'];
     BusinessHours  bh = [SELECT Id, MondayEndTime, MondayStartTime FROM BusinessHours WHERE IsDefault=true];
       
        Account_Details__c accDetails = new Account_Details__c();
        accDetails.Name = 'Test';
        accDetails.RecType__c = 'ACCT';
        insert accDetails;
          
        List<Account> testAccts = new List<Account>();
        for(Integer i=0;i<5;i++)
         {
            testAccts.add(new Account(FirstName = 'FTestAcct'+i, LastName = 'LTestAcct'+i,RecordtypeId = rec.Id,Is_Case_Created__c=false, IsConverted__c = false, Created_By_Episys_User_Alias__c='dwadh'));
        }
        insert testAccts;
          List<Person_Account__c> testAccts1 = new List<Person_Account__c>();
         for(Integer i=0;i<5;i++)
         {
	        Person_Account__c pa = new Person_Account__c();
	        pa.PersonID__c = testAccts[i].Id;
	        pa.Account_Number__c = accDetails.Id;  
	         testAccts1.add(pa); 
         }    
        insert testAccts1;   
         
    }
   
    static testMethod void myUnitTest() {
    	
    	 String CRON_EXP = '0 0 0 15 3 ? *';
    	  Test.startTest();
    	  
       		    		
            String jobId = System.schedule('ScheduleApexClassTest',  CRON_EXP, new CreateAlertForNonMatchedMemberSchedular());
            CronTrigger ct = [SELECT Id, CronExpression, TimesTriggered, NextFireTime FROM CronTrigger WHERE id = :jobId];
            System.assertEquals(CRON_EXP, ct.CronExpression);
            System.assertEquals(0, ct.TimesTriggered);
           // List<Account> testAccts = new List<Account>();
          //  testAccts = [SELECT Id, Owner.Name, Ownerid, Is_Case_Created__c FROM Account where RecordType.Name = 'Person Account'];
           // CreateCaseForNonMatchedMemberSchedular.CreateCaseForNonEligibleMember(testAccts);
         //  CreateCaseForNonMatchedMemberBatch b = new CreateCaseForNonMatchedMemberBatch();
         //  DataBase.executeBatch(b);

           Test.stopTest();
    	        
    }
}