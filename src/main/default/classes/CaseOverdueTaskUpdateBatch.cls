global class CaseOverdueTaskUpdateBatch implements Database.Batchable<sObject> {
  global  map<string,decimal> listMap = new map<string,decimal> ();
  global string listCases {get;set;}

 
   global Database.QueryLocator start(Database.BatchableContext BC){
      return Database.getQueryLocator('select id from case where id in ' + listCases);
   }

   global void execute(Database.BatchableContext BC, List<sObject> scope){
   	List<Case_Overdue_Task__c> lisCaseOverdueTaskToBeInserted = new List<Case_Overdue_Task__c>();
	    for(sobject sc : scope){
	    	Case c = (Case)sc;
	    	Case_Overdue_Task__c cot = new Case_Overdue_Task__c();
			cot.Case__c = c.id;
			
	        cot.Overdue_Task_Count__c = listMap.get(c.id);
	        lisCaseOverdueTaskToBeInserted.add(cot);
	    }
	    
	    insert lisCaseOverdueTaskToBeInserted;
     
   }

   global void finish(Database.BatchableContext BC){
   }
}