@isTest
public class DormancyOpportunitySchedularTest {
	
	 static testMethod void myUnitTest() {
	 	
	 	Triggered_Opportunity_Configurations__c cs = new Triggered_Opportunity_Configurations__c();
	 	
    	
    	cs.Impending_Dormancy_Inactivity_Days__c = 270;    	 	
    	cs.Impending_Dormancy_isTriggered__c = true;
    	cs.Impending_Dormancy_Dormant_Days__c = 365;
    	cs.Name = 'Primary Record';    	
    	insert cs;
    	
    	Account act = new Account();
        act.FirstName = 'Test';
        act.LastName = 'Test1';
        act.PersonEmail = 'test@test.com';
        act.Alternate_Email__pc = 'test1@gmail.com';       
        act.Residential_Street__pc = '11';
        insert act;
        
        Episys_User__c eu = new Episys_User__c(Alias__c='GALV', Assigned_Branch__c = 24, Default__c= true,Episys_ID__c=1346, Episys_Name__c='Test Test');
        insert eu;
        
        Account_Details__c account_details_Obj2 = new Account_Details__c(Onboarded__c = false, RecType__c = 'ACCT', TypeTranslate__c = '2-TRUST');
    	Insert account_details_Obj2;
        
       Account_Details__c account_details_Obj1 = new Account_Details__c(RecType__c = 'SHAR', TypeTranslate__c = '47-2 YEAR CERTIFICATE', DormancyOppCreated__c =false , Activity_Date__c = null, Correspondence_Date__c = null, Assigned_Branch__c = 24, Parent_Account__c = account_details_Obj2.id);
    	Insert account_details_Obj1;
    	
    	Account_Details__c account_details_Obj = new Account_Details__c(RecType__c = 'SHAR', TypeTranslate__c = '47-2 YEAR CERTIFICATE', DormancyOppCreated__c =true , Activity_Date__c = system.Today().addDays(-240), Correspondence_Date__c = system.Today().addDays(-240), Assigned_Branch__c = 24, Parent_Account__c = account_details_Obj2.id);
    			Insert account_details_Obj;


    			
        Person_Account__c person_account_Obj = new Person_Account__c(Account_Number__c = account_details_Obj2.id, PersonID__c = act.id, Relationship__c = null, TypeTranslate__c = '0000/Primary');
    		Insert person_account_Obj;
    		
    	opportunity opp = new Opportunity();
        opp.Accountid = act.id;
        opp.Name = 'Name';
        opp.StageName = 'New';
        opp.Opportunity_Source__c = 'Member Intelligence';
        opp.isTriggeredOpportunity__c = true;
        opp.Member_Account__c = account_details_Obj2.id;
        opp.CloseDate = system.Today().addDays(-20);
        insert opp;
    	
    	
    		
    	
        Datetime dt = Datetime.now().addMinutes(1);
        String CRON_EXP = '0 '+ dt.minute() + ' * ' + dt.day() + ' ' + dt.month() + ' ? ' + dt.year();
       	
       	Test.startTest();
       		
            String jobId = System.schedule('ScheduleApexClassTest',  CRON_EXP, new DormancyCreateOpportunitySchedular());
            CronTrigger ct = [SELECT Id, CronExpression, TimesTriggered, NextFireTime FROM CronTrigger WHERE id = :jobId];
            System.assertEquals(CRON_EXP, ct.CronExpression);
            System.assertEquals(0, ct.TimesTriggered);
            
           Test.stopTest();
        
         
	 
	 }
    
}