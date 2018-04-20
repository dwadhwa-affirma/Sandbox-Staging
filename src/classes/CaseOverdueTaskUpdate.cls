global class CaseOverdueTaskUpdate implements Schedulable {
     global void execute(SchedulableContext SC) {
       AggregateResult[] groupedResults  = [select whatId,Count(id) from task where Status != 'Completed' and activityDate < today and What.Type = 'Case' group by whatId];
       
       List<Case_Overdue_Task__c> lisCaseOverdueTask = new List<Case_Overdue_Task__c>();
       
       lisCaseOverdueTask = [select id from Case_Overdue_Task__c];
       
       delete lisCaseOverdueTask;
       
       
       List<Case_Overdue_Task__c> lisCaseOverdueTaskToBeInserted = new List<Case_Overdue_Task__c>();
       for (AggregateResult ar : groupedResults)  {
       	
       		Case_Overdue_Task__c c = new Case_Overdue_Task__c();
			c.Case__c = (id)ar.get('whatId');
	        c.Overdue_Task_Count__c = (decimal)ar.get('expr0');
	        lisCaseOverdueTaskToBeInserted.add(c);
	        
       }
       
        insert lisCaseOverdueTaskToBeInserted;
       
   }
}