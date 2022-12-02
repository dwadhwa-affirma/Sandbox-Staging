@istest
public with sharing class Lead_OpptyBatchSchedulerTest {
    @isTest
    public static void testschedule() {
        SLA_Status_Manager__c sla = new SLA_Status_Manager__c();
        sla.Name = 'Opportunity';
        sla.Status__c = 'New';
        insert sla; 
        Opportunity opp = DataFactoryTestClass.createOpportunitywithMemberAccount('New');
		Test.StartTest();
		Opportunity_UStatusHrs_Batch_Scheduler testsche = new Opportunity_UStatusHrs_Batch_Scheduler();
		String sch = '0 0 23 * * ?';
		system.schedule('Test status Check', sch, testsche );
		Test.stopTest();
	}
    @isTest
    public static void testschedule1() {
        SLA_Status_Manager__c sla = new SLA_Status_Manager__c();
        sla.Name = 'Lead';
        sla.Status__c = 'New';
        insert sla; 
        Lead ld = DataFactoryTestClass.createLead('Tom','Alda','New');
		Test.StartTest();
		Lead_UStatusHrs_Batch_Scheduler testsche = new Lead_UStatusHrs_Batch_Scheduler();
		String sch = '0 0 23 * * ?';
		system.schedule('Test status Check1', sch, testsche );
		Test.stopTest();
	}
}