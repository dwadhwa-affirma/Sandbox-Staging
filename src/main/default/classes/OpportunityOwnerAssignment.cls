public with sharing class OpportunityOwnerAssignment {

	 @AuraEnabled   
    public static string GetStatus(String ObjectName,Id recid)
    {	
    	system.debug('opp##----------------'+ObjectName);
    	if(ObjectName == 'Opportunity'){
    		Opportunity opp =[Select id, StageName from Opportunity where id =:recid];
    		system.debug('opp##----------------'+opp);
    		if(opp != null && (opp.StageName == 'Closed Lost' || opp.StageName == 'Closed Won'))
    			return 'Opportunity' ;    		
    		else
    			return 'true';
    		
    	}
    	if(ObjectName == 'Lead'){
    		lead ld =[Select id, Status from Lead where id =:recid];
    	
    		if(ld != null && (ld.Status == 'Closed - Not Converted' || ld.Status == 'Closed - Converted'))
    			return 'Lead' ;    		
    		else
    			return 'true';
    		
    	}
    	return 'true';
    }
	 @AuraEnabled   
    public static List<Group> GetQueueName(String ObjectName)
    {
    	List<Group> listQueue = new List<Group>();
    	/*if(ObjectName == 'Opportunity')
    	{
    		listQueue = [select id,Name,Email from Group where Type = 'Queue' and (Email like '%lead.com' or Email like '%opportunity.com')];
    	}
    	else
    	{
    		listQueue = [select id,Name,Email from Group where Type = 'Queue' and (Email like '%lead.com')];
    	}*/
    	
    	listQueue = [select id,Name,Email from Group where Type = 'Queue' and (Email like '%lead.com' or Email like '%opportunity.com')];
    	return listQueue;
    }
    
     @AuraEnabled 
    public static void OpportunityChangeOwner(Opportunity opportunityObject , Id recid)
    { 
    	system.debug('sObjectType##'+recid.getsobjecttype().getDescribe().getName());
    	
    	if(recid.getsobjecttype().getDescribe().getName() == 'Opportunity')
    	{
	    	Opportunity opp =[Select id,  Ownership__c,Queue_Owner__c,User_Owner__c,StageName from Opportunity where id =:recid];
	    	system.debug('opp##'+opp);
	    	system.debug('Owner##'+opportunityObject.Ownership__c);
	    	system.debug('QueueId##'+opportunityObject.Queue_Assigned_Id__c);
	    	system.debug('User_Owner__c'+ opportunityObject.User_Owner__c);
	    	
	    	if(opportunityObject.Ownership__c =='Queue' && opportunityObject.Queue_Assigned_Id__c!=null )
	    	{
	    		system.debug('Queue##'+opportunityObject.Ownership__c);
	    		system.debug('QueueId##'+opportunityObject.Queue_Assigned_Id__c);
	    		
	    		Group gp = [Select Name from Group where id =:opportunityObject.Queue_Assigned_Id__c];
	       	
	       		opp.Queue_Owner__c = gp.Name;
	       		opp.User_Owner__c = null;
	    	}
	    	else if(opportunityObject.Ownership__c =='Keep')
	    	{
	    		Id currentUserId = UserInfo.getUserId();
	    		opp.User_Owner__c = currentUserId;
	       		opp.Queue_Owner__c = null;
	    	}
	    	else 
	    	{
	    		opp.Queue_Owner__c = null;
	    		opp.User_Owner__c = opportunityObject.User_Owner__c;
	    	}
	    	
	    	update opp;
    	}
    	
    	else if(recid.getsobjecttype().getDescribe().getName()  == 'Lead')
    	{
    		Lead lead = [Select id, Status,Ownership__c,OwnerId,LeadSource,Product_Type__c,Episys_User_ID__c from Lead where id =:recid];
    		system.debug('Owner##'+opportunityObject.Ownership__c);
	    	system.debug('QueueId##'+opportunityObject.User_Owner__c);
	    	
	    	
    		if(opportunityObject.Ownership__c == 'Keep')
    		{
    			Id currentUserId = UserInfo.getUserId();
    			system.debug('currentUserId##'+currentUserId);
    			lead.OwnerId = currentUserId;
    		}
    		
    		else if(opportunityObject.Ownership__c =='Queue' && opportunityObject.Queue_Assigned_Id__c!=null )
	    	{
	    		system.debug('Queue##'+opportunityObject.Ownership__c);
	    		system.debug('QueueId##'+opportunityObject.Queue_Assigned_Id__c);
	    		
	    		Group gp = [Select ID, Name from Group where id =:opportunityObject.Queue_Assigned_Id__c];
	       	
	       		lead.OwnerId = gp.ID;
	       		
	    	}
	    	
	    	else
	    	{
	    		lead.OwnerId = opportunityObject.User_Owner__c;
	    	}
    		
    		update lead;
    		/*else if(leadObject.Ownership__c =='Queue' && leadObject.Queue_Assigned_Id__c!=null )
	    	{
	    		system.debug('Queue##'+leadObject.Ownership__c);
	    		system.debug('QueueId##'+leadObject.Queue_Assigned_Id__c);
	    		
	    		Group gp = [Select Name from Group where id =:leadObject.Queue_Assigned_Id__c];
	       	
	       		lead.OwnerId = gp.Id;
	    	}
    		*/
    		
    	}
    	
    	
    }
    
}