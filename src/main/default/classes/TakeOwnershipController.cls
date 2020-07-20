public class TakeOwnershipController {	
	
	@AuraEnabled
    public static string changeCaseOwnership(string caseId)
    {
    	Id currentUserId = UserInfo.getUserId();    	
    	Id uniqueId = caseId;
    	Schema.SObjectType objType = uniqueId.getsobjecttype();
    	
    	
    	
    	if(objType == Case.sObjectType)
    	{
    		List<Case> selectedCase = new List<Case>();
    		selectedCase = [Select Id, OwnerId from Case Where Id =: caseId limit 1];
    		selectedCase[0].OwnerId = currentUserId;
    	
    		update selectedCase[0];
    		return 'true';
    	}
    	else if(Solar_Loans__c.sObjectType == objType)
    	{
    		
    	
	    	Solar_Loans__c selectedSolarLoan = new Solar_Loans__c();
	    	selectedSolarLoan = [Select Id, OwnerId from Solar_Loans__c Where Id =: caseId limit 1];
	    	system.debug('Queue##'+selectedSolarLoan);
	    	
    		selectedSolarLoan.OwnerId = currentUserId;
    		
    		update selectedSolarLoan;
    		return 'true';
	    	  	
    	
    	}    	
    	else if(Lead.sObjectType == objType)
    	{
    		
    	
	    	Lead selectedLead = new Lead();
	    	selectedLead = [Select Id, OwnerId, Status from Lead Where Id =: caseId limit 1];
	    	system.debug('Queue##'+selectedLead);
	    	if(selectedLead != null && (selectedLead.Status!='Closed - Converted' && selectedLead.Status!='Closed - Not Converted'))
	    	{
	    		selectedLead.OwnerId = currentUserId;
	    		
	    		update selectedLead;
	    		return 'true';
	    	}  
	    	else{
	    return 'Lead';}  	
    	
    	}
    	else if(Opportunity.sObjectType == objType)
    	{
    		Opportunity selectedOpportunity = new Opportunity();
	    	selectedOpportunity = [Select Id, OwnerId, StageName from Opportunity Where Id =: caseId limit 1];
	    	
	    	system.debug('selectedOpportunity!--------------------##'+selectedOpportunity);
	    	if(selectedOpportunity != null && (selectedOpportunity.StageName!='Closed Lost' && selectedOpportunity.StageName!='Closed Won'))
	    	{
	    		selectedOpportunity.User_Owner__c = currentUserId;
	    		selectedOpportunity.Queue_Owner__c = null;
	    		update selectedOpportunity;
	    		return 'true';
	    	}  
	    	else{
	    		
	    	 return 'Opportunity';
	    	}  	
    		
    	}
    	return 'true';
    }   
    
}