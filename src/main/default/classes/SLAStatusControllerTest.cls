@isTest
public with sharing class SLAStatusControllerTest {
    
    @istest static void getSLAStatusforOpptyNewTest()
 	{
        Opportunity opp = DataFactoryTestClass.createOpportunitywithMemberAccount('New');
        Map<string,object> strMap =  SLAStatusController.getSLAStatus(opp.id);
    }
    
    @istest static void getSLAStatusforOpptyAnalyzingNeedsTest()
     {
            Opportunity opp = DataFactoryTestClass.createOpportunitywithMemberAccount('Analyzing Needs');
            Map<string,object> strMap =  SLAStatusController.getSLAStatus(opp.id);
     }
    @istest static void getSLAStatusforOpptyOutreachTest()
     {
            Opportunity opp = DataFactoryTestClass.createOpportunitywithMemberAccount('Outreach');
            Map<string,object> strMap =  SLAStatusController.getSLAStatus(opp.id);
     }
   
    
    @istest static void getSLAStatusforOpptyConsideringTest()
     {
            Opportunity opp = DataFactoryTestClass.createOpportunitywithMemberAccount('Considering');
            Map<string,object> strMap =  SLAStatusController.getSLAStatus(opp.id);
     }
   @istest static void getSLAStatusforLeadNewTest()
 	{
        Lead ld = DataFactoryTestClass.createLead('Tom','Alda','New');
        Map<string,object> strMap =  SLAStatusController.getSLAStatus(ld.id);
    }
    @istest static void getSLAStatusforLeadConsideringTest()
 	{
        Lead ld = DataFactoryTestClass.createLead('Tom','Alda','Considering');
        Map<string,object> strMap =  SLAStatusController.getSLAStatus(ld.id);
    }
    @istest static void getSLAStatusforLeadAnalyzingNeedsTest()
 	{
        Lead ld = DataFactoryTestClass.createLead('Tom','Alda','Analyzing Needs');
        Map<string,object> strMap =  SLAStatusController.getSLAStatus(ld.id);
    }
    @istest static void getSLAStatusforLeadOutreachTest()
 	{
        Lead ld = DataFactoryTestClass.createLead('Tom','Alda','Outreach');
        Map<string,object> strMap =  SLAStatusController.getSLAStatus(ld.id);
    }
    @istest static void getSLAStatusforLeadnegativeTest()
 	{
        Lead ld = DataFactoryTestClass.createLead('Tom','Alda','Client/SEG');
        Map<string,object> strMap =  SLAStatusController.getSLAStatus(ld.id);
    }
    
    
}