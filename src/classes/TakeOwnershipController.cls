public class TakeOwnershipController {	
	
	@AuraEnabled
    public static void changeCaseOwnership(string caseId)
    {
    	Id currentUserId = UserInfo.getUserId();    	
    	
    	
    	
    	List<Case> selectedCase = new List<Case>();
    	selectedCase = [Select Id, OwnerId from Case Where Id =: caseId limit 1];
    	if(selectedCase != null && selectedCase.size() > 0)
    	{
    		selectedCase[0].OwnerId = currentUserId;
    	
    		update selectedCase[0];
    	}    	
    	else
    	{
    		
    	
    	Lead selectedLead = new Lead();
    	selectedLead = [Select Id, OwnerId from Lead Where Id =: caseId limit 1];
    	if(selectedLead != null)
    	{
    		selectedLead.OwnerId = currentUserId;
    		
    		update selectedLead;
    	}    	
    	
    	}
    }   
}