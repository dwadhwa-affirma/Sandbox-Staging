trigger CaseTaskCountTrigger on Task (after insert, after update,after delete) {
	if(!Trigger.isdelete)
	{
	     for(Task t:Trigger.New){
	   if(t.whatId != null && t.whatId.getsObjectType() == Case.sObjectType){
	         List<Case> cList2= [select id, Open_Task_Count__c from Case where id=:t.whatId]; 
	               List<Task> listTask= [select id from Task where whatId=:t.whatId and status='Open'];                          
	              
	                 cList2[0].Open_Task_Count__c  = listTask.Size();
	                     update cList2;
	         }
	        }
	}
	else
	{
		for(Task t:Trigger.old){
			  if(t.whatId != null && t.whatId.getsObjectType() == Case.sObjectType){
			 List<Case> cList2= [select id, Open_Task_Count__c from Case where id=:t.whatId]; 
	               List<Task> listTask= [select id from Task where whatId=:t.whatId and status='Open'];                          
	              
	                 cList2[0].Open_Task_Count__c  = listTask.Size();
	                     update cList2;
			  }
		}
		
	}
}