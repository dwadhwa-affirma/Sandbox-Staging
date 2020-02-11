@isTest
private class CaseOverdueTaskUpdateTest {
	
    static testMethod void myUnitTest() {
        String CRON_EXP = '0 0 0 15 3 ? *';
        
     Create_SLA__c cl = new Create_SLA__c();
        cl.Status__c = 'Open';
        cl.Name = 'Open';
        cl.hours__c = 8;
        insert cl;
        
        Create_SLA__c cl1 = new Create_SLA__c();
        cl1.Status__c = 'In Process';
        cl1.Name = 'In Process';
        cl1.hours__c = 20;
        insert cl1;
        
        Create_SLA__c cl2 = new Create_SLA__c();
        cl2.Status__c = 'Resolution';
        cl2.Name = 'Resolution';
        cl2.hours__c = 20;
        insert cl2;
        
         Case cs = new Case();
           cs.Brand__c = 'CFCU';
           cs.Primary_Category__c = 'Shared Branch';
          
        insert cs;
        
        Task tk = new task();
          tk.Status = 'Open';
         tk.activityDate = system.today().addDays(-2);	
        tk.Type = 'Case';
        tk.whatId = cs.id;
        insert tk;
    
        
        Test.startTest();
       			
       		String jobId2 = System.schedule('CaseOverdueTaskResetUpdateTest',  CRON_EXP, new CaseOverdueTaskResetUpdate());
				CronTrigger ct2 = [SELECT Id, CronExpression, TimesTriggered, NextFireTime FROM CronTrigger WHERE id = :jobId2];
		            System.assertEquals(CRON_EXP, ct2.CronExpression);
		            System.assertEquals(0, ct2.TimesTriggered); 
		           String jobId1 = System.schedule('CaseOverdueTaskUpdateTest',  CRON_EXP, new CaseOverdueTaskUpdate());
		           
		           
		            CronTrigger ct1 = [SELECT Id, CronExpression, TimesTriggered, NextFireTime FROM CronTrigger WHERE id = :jobId1];
		            System.assertEquals(CRON_EXP, ct1.CronExpression);
		            System.assertEquals(0, ct1.TimesTriggered); 
  
			

        	Test.stopTest();
    }
}