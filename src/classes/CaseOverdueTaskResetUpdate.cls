global class CaseOverdueTaskResetUpdate  implements Schedulable {
    global void execute(SchedulableContext SC) {
    	List<Case_Overdue_Task_Processing__c> lisCaseOverdueTaskProcessingToDelete = [select id from Case_Overdue_Task_Processing__c];
    	delete lisCaseOverdueTaskProcessingToDelete;
    	
    	 AggregateResult[] groupedResults  = [select whatId,Count(id) from task where Status != 'Completed' and activityDate < today and What.Type = 'Case' group by whatId];
    	 List<Case_Overdue_Task_Processing__c> lisCaseOverdueTaskProcessingToInsert = new List<Case_Overdue_Task_Processing__c>(); 
		for (AggregateResult ar : groupedResults)  {
			Case_Overdue_Task_Processing__c item = new Case_Overdue_Task_Processing__c();
			item.Case__c = (string)ar.get('whatId');
			item.Processing__c = false;
			item.Overdue_Task_Count__c = (decimal)ar.get('expr0');
			lisCaseOverdueTaskProcessingToInsert.add(item);
        }
        
        insert lisCaseOverdueTaskProcessingToInsert;
        
        
        List<Case_Overdue_Task__c> listCase_Overdue_Task = [select id from Case_Overdue_Task__c];
        delete listCase_Overdue_Task;
        
    
    }
}