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
     	AssignOnboardingTasks(Trigger.new);
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
	 
	 
     public void AssignOnboardingTasks(List<Task> listTasks){
     	list<string> Ids = new list<string>();
		List<Case> listOnboardingCase = new List<Case>();
		List<Case> listOnboardingSolarCase = new List<Case>();		
		
		string eBranchOnboardingQueue  = [select Id, Name, DeveloperName from Group where Type = 'Queue' and DeveloperName = 'eBranch_Onboarding_Queue' Limit 1].id;
		string SolarOnboardingQueue  = [select Id, Name, DeveloperName from Group where Type = 'Queue' and DeveloperName = 'Call_Center_Solar_Onboarding_Queue' Limit 1].id;

	    for(Task t:listTasks){
	    	if(t.whatId != null && t.whatId.getsObjectType() == Case.sObjectType){
			   		Ids.add(t.whatId);
			   		}
			}	
		
		map<String,Id> eBranchUserAliasMap = new map<String,Id>();
		map<String,Id> eBranchUserMap = new map<String,Id>();
		map<decimal,Episys_User__c> episysUserMap = new map<decimal,Episys_User__c>();

		List<User> eBranchUserList = [SELECT Id, Name, Alias, IsActive FROM User where (Profile.Name ='eBranch') and (isActive = True)];
		
		for(User u: eBranchUserList){
            eBranchUserMap.put(u.Name.toupperCase(), u.Id);
            eBranchUserAliasMap.put(u.Alias.toupperCase(), u.Id);
		}
		
		List<Episys_User__c> episysUserList = [select id,Name, Alias__c, Episys_ID__c from Episys_User__c];
		for(Episys_User__c u: episysUserList){
            episysUserMap.put(u.Episys_ID__c, u);
		}
		
		listOnboardingCase = [select id, Account_Number__c, Account_Number__r.Created_By_User__c from Case where id in: Ids and Status != 'Closed' and Secondary_Category__c = 'Onboarding' and Promo_Code__c != '2166'];
		List<Case> listOnboardingEbranchCase = new List<Case>();

		for(Case c: listOnboardingCase){
			if(episysUserMap.get(c.Account_Number__r.Created_By_User__c).Alias__c != null
                            && eBranchUserAliasMap.get(episysUserMap.get(c.Account_Number__r.Created_By_User__c).Alias__c.toupperCase()) != null){
						listOnboardingEbranchCase.add(c);
					}
		}

	    listOnboardingSolarCase = [select id from Case where id in: Ids and Status != 'Closed' and Secondary_Category__c =: 'Onboarding' and Promo_Code__c	 = '2166'];   	
	 
		   for(Task t:listTasks){
	     	 	for(Case c : listOnboardingEbranchCase)
	     	 	{
	     	 		if(c.Id == t.whatid)
	     	 		{
	     	 			t.OwnerId = eBranchOnboardingQueue;
	     	 			
	     	 		}
	     	 		
	     	 	}
	     	 }
	   
     	 
     	 for(Task t:listTasks){
     	 	for(Case c : listOnboardingSolarCase)
     	 	{
     	 		if(c.Id == t.whatid)
     	 		{
     	 			t.OwnerId = SolarOnboardingQueue;
     	 			
     	 		}
     	 		
     	 	}
     	 }
	               
	               
	              
     
     }
     
  }