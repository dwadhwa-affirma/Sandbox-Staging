trigger UserTrigger on User (before insert, before update) {
    if (trigger.isbefore && trigger.isInsert){
           for (User u : trigger.New){       
            if(u.ManagerId != null )
                u.Backup_Manager_ID__c = u.ManagerId;
    	 }     
    }
	if (trigger.isbefore && trigger.isUpdate){
           for(Integer i=0; i<trigger.new.size(); i++){       
               if(trigger.new[i].ManagerId != null && trigger.old[i].ManagerId != trigger.new[i].ManagerId){
                   trigger.new[i].Backup_Manager_ID__c = trigger.new[i].ManagerId;
               }
               if(trigger.new[i].ManagerId == null && trigger.old[i].ManagerId != trigger.new[i].ManagerId){
                   trigger.new[i].Backup_Manager_ID__c = trigger.old[i].ManagerId;
               }
                
    	 }     
    }
}