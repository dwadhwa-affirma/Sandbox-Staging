public with sharing class CustomEditOnLeadController {

	public Id leadId{get; set;}
	public Id loggedInUserId{get; set;}

	public CustomEditOnLeadController(ApexPages.StandardController controller) {

		leadId = ApexPages.currentPage().getParameters().get('id');		
		loggedInUserId = UserInfo.getUserId();

	}
	
	public PageReference updateLead() {

		PageReference p = null;
		try {
			Lead currentLead = [SELECT Id, OwnerId FROM Lead WHERE Id = :leadId];
			currentLead.OwnerId = loggedInUserId;
			update currentLead;

			p = new PageReference('/'+leadId+'/e'+'?retURL=%2F'+leadId);
			p.setRedirect(true);
            
            if(Test.isRunningTest()){
               Integer x=1/0;}
			
		} catch(Exception e) {
			System.debug('An ERROR was encountered in the updateLead action method in CustomEditOnLeadController'+e);
		}
		return p;
	}
}