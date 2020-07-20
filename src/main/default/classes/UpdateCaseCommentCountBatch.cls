global class UpdateCaseCommentCountBatch implements Database.Batchable<sObject>{
	
	global Database.QueryLocator start(Database.BatchableContext BC){			
    	return Database.getQueryLocator('select id, CaseCommentCount__c from case');
	 }
      global void execute(Database.BatchableContext BC, List<case> caseList){
      	Set<Id> parentCase=new Set<Id>();      
		Map<id,integer> mapCaseCommentCount=new Map<id,integer>();
		
      	for (Case t: caseList){
				parentCase.add(t.Id);
		}      
      	
      	aggregateResult[] groupedResults = [select count(id)commentcount, parentid from CaseComment where ParentId in: parentCase group by ParentId];
			
			for(AggregateResult item : groupedResults){
				mapCaseCommentCount.put((string)item.get('parentid'), (Integer)item.get('commentcount'));
			}
			
			
			for(case c : caseList)
			{
				if(mapCaseCommentCount.containskey(c.id)){
					c.CaseCommentCount__c = mapCaseCommentCount.get(c.id);
				}
				else
				{
					c.CaseCommentCount__c = 0;
				}
			}
			
			update caseList;
      
      }
      
      global void finish(Database.BatchableContext BC){
      	
   	  }
}