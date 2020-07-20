global class UpdateCaseAttachmentCountBatch implements Database.Batchable<sObject>{
    global Database.QueryLocator start(Database.BatchableContext BC){			
    	return Database.getQueryLocator('select id, Count_Attachment__c, Case_Activity_Count__c from case');
	 }
      global void execute(Database.BatchableContext BC, List<case> caseList){
      	Set<Id> parentCase=new Set<Id>();      
		Map<id,integer> mapCaseAttachmentCount=new Map<id,integer>();
		
		Map<id,integer> mapCaseActivityCount=new Map<id,integer>();
		Map<id,integer> mapCaseEventCount=new Map<id,integer>();
		
      	for (Case t: caseList){
				parentCase.add(t.Id);
		}      
      	
      	aggregateResult[] groupedResults = [SELECT count(id)attachmentcount, parentid FROM Attachment where ParentId =: parentCase group by ParentId];
      	aggregateResult[] groupedEventResults = [select count(id)eventCount, whatId from event where whatId in: parentCase group by whatId];
			aggregateResult[] groupedTaskResults = [select count(id)taskCount, whatId from Task where whatId in: parentCase group by whatId];
			
			for(AggregateResult item : groupedResults){
				mapCaseAttachmentCount.put((string)item.get('parentid'), (Integer)item.get('attachmentcount'));
			}
			for(AggregateResult item : groupedEventResults){
				mapCaseEventCount.put((string)item.get('whatId'), (Integer)item.get('eventCount'));
			}
			
			for(AggregateResult item : groupedTaskResults){
				integer eventcount=0;
				if(mapCaseEventCount.get((string)item.get('whatId')) != null){
					system.debug('mapCaseEventCount.get((string)item.get(\'whatId\'))==='+mapCaseEventCount.get((string)item.get('whatId')));
					eventcount = mapCaseEventCount.get((string)item.get('whatId'));
				}
				integer totalcount = eventcount + (Integer)item.get('taskCount');
    			mapCaseActivityCount.put((string)item.get('whatId'), totalcount);
			}
			
			Set<String> FinalCaseIds = new Set<String>();
			 List<Case> CasetoUpdate = new List<Case>();
			 
			for(case c : caseList){       		 		
       		 		FinalCaseIds.add(c.id);       		 			 		
       		 } 
       		 	
			CasetoUpdate = [Select id, OwnerId, Status from Case where id in: FinalCaseIds];
       		List<OnBase_Document__c> pendingAttachCases = [select case__c, document_type__c from OnBase_Document__c where ((case__c in: FinalCaseIds or Member_Comment__r.Case__C in: FinalCaseIds) and document_type__c = '')];
       		 	if(pendingAttachCases.size() >= 1){
						for(OnBase_Document__c o:pendingAttachCases){
							o.document_type__c = '	Not For OnBase';
						}
						update pendingAttachCases;
					}
				
			for(case c : caseList)
			{
				if(mapCaseAttachmentCount.containskey(c.id)){
					c.Count_Attachment__c = mapCaseAttachmentCount.get(c.id);
				}
				else
				{
					c.Count_Attachment__c = 0;
				}
				if(mapCaseActivityCount.containskey(c.id)){
					c.Case_Activity_Count__c = mapCaseActivityCount.get(c.id);
				}
                else{
                    c.Case_Activity_Count__c = 0;
                }
			}
			
			update caseList;
      
      }
      
      global void finish(Database.BatchableContext BC){
      	
   	  }
}