trigger TaskTrigger on Task (before delete, before insert,after insert, after update) {
    
    String ProfileId = UserInfo.getProfileId(); 
    List<Profile> profiles = [Select id from Profile where name = 'CFCU Admin'];

    if(System.Trigger.isDelete && System.Trigger.Isbefore){
        for(Task t : Trigger.old){
            if(ProfileId != profiles[0].id){
            if(t.Subject != null && t.Subject != ''){
                t.addError('You are not allowed to delete a Task. Please contact your System Administrator for assistance.');
            }
          } 
        }
      
     }
     if(System.Trigger.isInsert && System.Trigger.isbefore)
     {
     	 list<string> Ids = new list<string>();
     	 List<Case> listCaseClosed = new List<Case>();
     	 for(Task t:Trigger.new){
     	 	Ids.add(t.whatId);
     	 }
     	 listCaseClosed = [select id from Case where id in: Ids and Status = 'Closed'];
     	 
     	 for(Task t:Trigger.new){
     	 	for(Case c : listCaseClosed)
     	 	{
     	 		if(c.Id == t.whatid)
     	 		{
     	 			t.addError('You can not create a new Task on a Closed case. Please ReOpen the case to create a new one.');
     	 			
     	 		}
     	 		
     	 	}
     	 }
     
     }
     
     
     if(System.Trigger.isDelete && System.Trigger.isafter)
     {
     	 UpdateCaseTaskCount(Trigger.old);
     	
     }
     else if(!System.Trigger.isDelete && System.Trigger.isafter)
     {
     	
     	UpdateCaseTaskCount(Trigger.new);
     }
     
     
     public void UpdateCaseTaskCount(List<Task> listTasks){
     	list<string> Ids = new list<string>();
		List<Case> listCaseOpen = new List<Case>();  
	     for(Task t:listTasks){
	     		
	     	
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