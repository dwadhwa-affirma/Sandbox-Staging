global class UpdateCaseSLABatch implements Database.Batchable<sObject>{
      global Database.QueryLocator start(Database.BatchableContext BC){			
    	return Database.getQueryLocator('Select id, Subject from case where status != \'Closed\' and isescalated = false');
	 }
      global void execute(Database.BatchableContext BC, List<case> caseList){       
			
	      	for (Case c: caseList){
					 string subject=c.Subject;
	    			 c.Subject = subject;    
			}     
			update caseList;
      
      }
      
      global void finish(Database.BatchableContext BC){
      	
   	  }
}