trigger CaseTaskCountTrigger on Task (after insert, after update,after delete) {
	if(!Trigger.isdelete)
	{
		list<string> Ids = new list<string>();
		List<Case> listCaseOpen = new List<Case>();  
	     for(Task t:Trigger.New){
	     		
	     	
			   if(t.whatId != null && t.whatId.getsObjectType() == Case.sObjectType){
			   		Ids.add(t.whatId);
			   		}
				}	
	        	listCaseOpen = [select id from Case where id in: Ids and Status != 'Closed'];
	        	
	        
	               AggregateResult[] groupedResults = [select whatId,Count(Id) from Task where whatid in: Ids and status = 'Open' group by whatId /* select id from Task where whatId=:t.whatId and status='Open'*/];
	               
	               
	               List<Case> listCase = new List<Case>();                           
	              for (AggregateResult ar : groupedResults)  {
	              		Case c = new Case();
	              		c.id = (id)ar.get('whatId');
	              		c.Open_Task_Count__c = (decimal)ar.get('expr0');
	              		//found in 
	              		boolean foundInOpenCase = false;
	              		for(Case caseOpened : listCaseOpen)
	              		{
	              			if(caseOpened.Id ==c.id)
	              			{
	              				foundInOpenCase = true;
	              				
	              			}
	              			
	              		}
	              		if(foundInOpenCase)
	              		{
	              			listCase.add(c);
	              		}
	              
	              }
	                 
	                     update listCase;
	         
	}
	else
	{
		
		list<string> Ids = new list<string>();
		List<Case> listCaseOpen = new List<Case>();  
	     for(Task t:Trigger.old){
			   if(t.whatId != null && t.whatId.getsObjectType() == Case.sObjectType){
			   		Ids.add(t.whatId);
			   		}
				}	
				listCaseOpen = [select id from Case where id in: Ids and Status != 'Closed'];
	        
	               AggregateResult[] groupedResults = [select whatId,Count(Id) from Task where whatid in: Ids and status = 'Open' group by whatId /* select id from Task where whatId=:t.whatId and status='Open'*/];
	               List<Case> listCase = new List<Case>();                           
	              for (AggregateResult ar : groupedResults)  {
	              		Case c = new Case();
	              		c.id = (id)ar.get('whatId');
	              		c.Open_Task_Count__c = (decimal)ar.get('expr0');
	              		//found in 
	              		boolean foundInOpenCase = false;
	              		for(Case caseOpened : listCaseOpen)
	              		{
	              			if(caseOpened.Id ==c.id)
	              			{
	              				foundInOpenCase = true;
	              				
	              			}
	              			
	              		}
	              		if(foundInOpenCase)
	              		{
	              			listCase.add(c);
	              		}
	              
	              }
	                 
	                 
	                     update listCase;
		}
		
	
}