trigger CaseActivityCountTrigger on Event (after delete, after insert) {
     if(Trigger.isInsert && Trigger.isAfter)
    {
        Set<Id> parentCase=new Set<Id>();
			Map<Id,Case> mapCase=new Map<Id,Case>();
			Map<id,integer> mapCaseActivityCount=new Map<id,integer>();
			Map<id,integer> mapCaseEventCount=new Map<id,integer>();
			
			for (Event e: Trigger.new){
				parentCase.add(e.whatId);
			}			
			
			aggregateResult[] groupedEventResults = [select count(id)eventCount, whatId from event where whatId in: parentCase group by whatId];
			aggregateResult[] groupedTaskResults = [select count(id)taskCount, whatId from Task where whatId in: parentCase group by whatId];
			
			for(AggregateResult item : groupedEventResults){
				mapCaseEventCount.put((string)item.get('whatId'), (Integer)item.get('eventCount'));
			}
			
			for(AggregateResult item : groupedTaskResults){
				integer eventcount=0;
				if(mapCaseEventCount.get((string)item.get('whatId')) != null){
					eventcount = mapCaseEventCount.get((string)item.get('whatId'));
				}
				integer totalcount = eventcount + (Integer)item.get('taskCount');
    			mapCaseActivityCount.put((string)item.get('whatId'), totalcount);
			}
			
			List<Case> lstCase=[Select Id,Case_Activity_Count__c from case where Id in: parentCase ];
			for(case c : lstCase)
			{
				if(mapCaseActivityCount.containskey(c.id)){
					c.Case_Activity_Count__c = mapCaseActivityCount.get(c.id);
				}
                else{
                    c.Case_Activity_Count__c = 0;
                }
			}
			
			update lstCase;
    }
    if(Trigger.isDelete)
    {
         Set<Id> parentCase=new Set<Id>();
			Map<Id,Case> mapCase=new Map<Id,Case>();
			Map<id,integer> mapCaseActivityCount=new Map<id,integer>();
			Map<id,integer> mapCaseEventCount=new Map<id,integer>();
			
			for (Event e: Trigger.old){
				parentCase.add(e.whatId);
			}			
			
			aggregateResult[] groupedEventResults = [select count(id)eventCount, whatId from event where whatId in: parentCase group by whatId];
			aggregateResult[] groupedTaskResults = [select count(id)taskCount, whatId from Task where whatId in: parentCase group by whatId];
			
			for(AggregateResult item : groupedEventResults){
				mapCaseEventCount.put((string)item.get('whatId'), (Integer)item.get('eventCount'));
			}
			
			for(AggregateResult item : groupedTaskResults){
				integer eventcount =0;
				if(mapCaseEventCount.get((string)item.get('whatId')) != null){
					eventcount = mapCaseEventCount.get((string)item.get('whatId'));
				}
				integer totalcount = eventcount + (Integer)item.get('taskCount');
    			mapCaseActivityCount.put((string)item.get('whatId'), totalcount);
			}
			
			List<Case> lstCase=[Select Id,Case_Activity_Count__c from case where Id in: parentCase ];
			for(case c : lstCase)
			{
				if(mapCaseActivityCount.containskey(c.id)){
					c.Case_Activity_Count__c = mapCaseActivityCount.get(c.id);
				}
                else{
                    c.Case_Activity_Count__c = 0;
                }
			}
			
			update lstCase;
        
    }
}