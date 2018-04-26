global class CaseOverdueTaskUpdate implements Schedulable {
     global void execute(SchedulableContext SC) {
       

       
       List<Case_Overdue_Task_Processing__c> listCase_Overdue_Task_Processing  = [select Case__c,Processing__c,Overdue_Task_Count__c from Case_Overdue_Task_Processing__c where Processing__c = false limit 30];
       
      
       
       
       List<Case_Overdue_Task__c> lisCaseOverdueTaskToBeInserted = new List<Case_Overdue_Task__c>();
       for (Case_Overdue_Task_Processing__c ar : listCase_Overdue_Task_Processing)  {
       		Case_Overdue_Task__c obj = new Case_Overdue_Task__c();
       		obj.Case__c = ar.Case__c;
       		obj.Overdue_Task_Count__c = ar.Overdue_Task_Count__c;
       		lisCaseOverdueTaskToBeInserted.add(obj);
       		ar.Processing__c = true;
       		 
       }
		
       insert lisCaseOverdueTaskToBeInserted;
       update listCase_Overdue_Task_Processing;
   }
}