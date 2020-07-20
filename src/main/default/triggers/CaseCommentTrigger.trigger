trigger CaseCommentTrigger on CaseComment (after delete, after insert) {
	 if (Trigger.isInsert && Trigger.isAfter) {
		 	Set<Id> parentCase=new Set<Id>();
			Map<Id,Case> mapCase=new Map<Id,Case>();
			Map<id,integer> mapCaseCommentCount=new Map<id,integer>();
			
			for (CaseComment t: Trigger.new){
				parentCase.add(t.ParentId);
			}
			
			
			aggregateResult[] groupedResults = [select count(id)commentcount, parentid from CaseComment where ParentId in: parentCase group by ParentId];
			
			for(AggregateResult item : groupedResults){
				mapCaseCommentCount.put((string)item.get('parentid'), (Integer)item.get('commentcount'));
			}
			
			List<Case> lstCase=[Select Id,CaseCommentCount__c from case where Id in :parentCase ];
			for(case c : lstCase)
			{
				if(mapCaseCommentCount.containskey(c.id)){
					c.CaseCommentCount__c = mapCaseCommentCount.get(c.id);
				}
                else{
                    c.CaseCommentCount__c = 0;
                }
			}
			
			update lstCase;
	 	
	 }
	 
	 if (Trigger.isDelete && Trigger.isAfter) {
	 	Set<Id> parentCase=new Set<Id>();
			Map<Id,Case> mapCase=new Map<Id,Case>();
			Map<id,integer> mapCaseCommentCount=new Map<id,integer>();
			
			for (CaseComment t: Trigger.old){
				parentCase.add(t.ParentId);
			}
			
			system.debug('parentCase=='+parentCase);
			aggregateResult[] groupedResults = [select count(id)commentcount, parentid from CaseComment where ParentId in: parentCase group by ParentId];
			system.debug('groupedResults=='+groupedResults);
			for(AggregateResult item : groupedResults){
				mapCaseCommentCount.put((string)item.get('parentid'), (Integer)item.get('commentcount'));
			}
			
			List<Case> lstCase=[Select Id,CaseCommentCount__c from case where Id in :parentCase ];
			for(case c : lstCase)
			{
				if(mapCaseCommentCount.containskey(c.id)){
					c.CaseCommentCount__c = mapCaseCommentCount.get(c.id);
				}
                else{
                    c.CaseCommentCount__c = 0;
                }
			}
			
			update lstCase;
	 	
	 }
    
}