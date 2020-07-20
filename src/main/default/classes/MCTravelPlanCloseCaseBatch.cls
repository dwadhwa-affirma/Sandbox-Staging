global class MCTravelPlanCloseCaseBatch implements Database.Batchable<sObject>{
	private Set<String> FinalCaseIds;
    	
    public MCTravelPlanCloseCaseBatch(Set<String> strParam){
        	FinalCaseIds = strParam;
    	}
    global Database.QueryLocator start(Database.BatchableContext BC){
    	String query = 'Select id, OwnerId, Status from Case where id in: FinalCaseIds';
        return Database.getQueryLocator(query);    	
    }
    
     global void execute(Database.BatchableContext BC, List<case> CasetoUpdate){
     	List<OnBase_Document__c> pendingAttachCases = [select case__c, document_type__c from OnBase_Document__c where ((case__c in: FinalCaseIds or Member_Comment__r.Case__C in: FinalCaseIds) and document_type__c = '')];
       	if(pendingAttachCases.size() >= 1){
						for(OnBase_Document__c o:pendingAttachCases){
							o.document_type__c = '	Not For OnBase';
						}
						update pendingAttachCases;
					}	
       		 	for(Case c : CasetoUpdate){
       		 		   c.OwnerId = '005j000000DCwXHAA1';
       		 			c.Status = 'Closed';       		 		
       		 	}
       		 
       		  	update CasetoUpdate;
     }
     
     global void finish(Database.BatchableContext BC){
   }
}