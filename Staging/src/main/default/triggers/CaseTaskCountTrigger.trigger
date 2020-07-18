trigger CaseTaskCountTrigger on Task (after insert, after update,after delete) {
    if(!Trigger.isdelete)
    {
       /*  for(Task t:Trigger.New){
       if(t.whatId != null && t.whatId.getsObjectType() == Case.sObjectType){
             List<Case> cList2= [select id, Open_Task_Count__c from Case where id=:t.whatId]; 
                   List<Task> listTask= [select id from Task where whatId=:t.whatId and status='Open'];                          
                  
                     cList2[0].Open_Task_Count__c  = listTask.Size();
                         update cList2;
             }
            }*/
    if(Trigger.isInsert && Trigger.isAfter)
    {
    	system.debug('After Insert....');
        Set<Id> parentCase=new Set<Id>();
			Map<Id,Case> mapCase=new Map<Id,Case>();
			Map<id,integer> mapCaseActivityCount=new Map<id,integer>();
			Map<id,integer> mapCaseEventCount=new Map<id,integer>();
			
			for (task t: Trigger.new){
				if(t.whatId != null)
				parentCase.add(t.whatId);
			}	
			
			system.debug('parentCase==='+parentCase);		
			
			aggregateResult[] groupedEventResults = [select count(id)eventCount, whatId from event where whatId in: parentCase and whatId != null group by whatId];
			aggregateResult[] groupedTaskResults = [select count(id)taskCount, whatId from Task where whatId in: parentCase and whatId != null group by whatId];
			
			system.debug('groupedEventResults==='+groupedEventResults);		
			system.debug('groupedTaskResults==='+groupedTaskResults);	
				
			for(AggregateResult item : groupedEventResults){
				mapCaseEventCount.put((string)item.get('whatId'), (Integer)item.get('eventCount'));
			}
			
			system.debug('mapCaseEventCount==='+mapCaseEventCount);
			
			for(AggregateResult item : groupedTaskResults){
				integer eventcount=0;
				if(mapCaseEventCount.get((string)item.get('whatId')) != null){
					system.debug('mapCaseEventCount.get((string)item.get(\'whatId\'))==='+mapCaseEventCount.get((string)item.get('whatId')));
					eventcount = mapCaseEventCount.get((string)item.get('whatId'));
				}
				integer totalcount = eventcount + (Integer)item.get('taskCount');
    			mapCaseActivityCount.put((string)item.get('whatId'), totalcount);
			}
			
			system.debug('mapCaseActivityCount==='+mapCaseActivityCount);
			
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
			
			system.debug('lstCase==='+lstCase);
			
			update lstCase;
    }
    }
    else
    {
        /*for(Task t:Trigger.old){
              if(t.whatId != null && t.whatId.getsObjectType() == Case.sObjectType){
             List<Case> cList2= [select id, Open_Task_Count__c from Case where id=:t.whatId]; 
                   List<Task> listTask= [select id from Task where whatId=:t.whatId and status='Open'];                          
                  
                     cList2[0].Open_Task_Count__c  = listTask.Size();
                         update cList2;
              }
        }*/
        
     if(Trigger.isDelete && Trigger.isAfter)
    	{
    		
    		system.debug('After Delete....');
        Set<Id> parentCase=new Set<Id>();
			Map<Id,Case> mapCase=new Map<Id,Case>();
			Map<id,integer> mapCaseActivityCount=new Map<id,integer>();
			Map<id,integer> mapCaseEventCount=new Map<id,integer>();
			
			for (Task t: Trigger.old){
				if(t.whatId != null)
				parentCase.add(t.whatId);
			}			
			
			system.debug('parentCase==='+parentCase);		
			
			aggregateResult[] groupedEventResults = [select count(id)eventCount, whatId from event where whatId in: parentCase and whatId != null group by whatId];
			aggregateResult[] groupedTaskResults = [select count(id)taskCount, whatId from Task where whatId in: parentCase and whatId != null group by whatId];
			
			system.debug('groupedEventResults==='+groupedEventResults);		
			system.debug('groupedTaskResults==='+groupedTaskResults);
			
			for(AggregateResult item : groupedEventResults){
				mapCaseEventCount.put((string)item.get('whatId'), (Integer)item.get('eventCount'));
			}
			
			system.debug('mapCaseEventCount==='+mapCaseEventCount);
			
			for(AggregateResult item : groupedTaskResults){
				integer eventcount=0;
				if(mapCaseEventCount.get((string)item.get('whatId')) != null){
					system.debug('mapCaseEventCount.get((string)item.get(\'whatId\'))==='+mapCaseEventCount.get((string)item.get('whatId')));
					eventcount = mapCaseEventCount.get((string)item.get('whatId'));
				}
				integer totalcount = eventcount + (Integer)item.get('taskCount');
    			mapCaseActivityCount.put((string)item.get('whatId'), totalcount);
			}
			
			system.debug('mapCaseActivityCount==='+mapCaseActivityCount);
			
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
			
			system.debug('lstCase==='+lstCase);
			
			update lstCase;
    }
        
    }
}