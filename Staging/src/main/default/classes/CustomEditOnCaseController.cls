public with sharing class CustomEditOnCaseController {

	public Id caseId{get; set;}
	public Id loggedInUserId{get; set;}

	public CustomEditOnCaseController(ApexPages.StandardController controller) {

		caseId = ApexPages.currentPage().getParameters().get('id');		
		loggedInUserId = UserInfo.getUserId();

	}
	
	public PageReference updateCase() {

		PageReference p = null;
		try {
			Case currentCase = [SELECT Id, OwnerId FROM Case WHERE Id = :caseId];
			currentCase.OwnerId = loggedInUserId;
			update currentCase;

			p = new PageReference('/'+caseId+'/e'+'?retURL=%2F'+caseId);
			p.setRedirect(true);
            
            if(Test.isRunningTest()){
               Integer x=1/0;}
			
		} catch(Exception e) {
			System.debug('An ERROR was encountered in the updateCase action method in CustomEditOnCaseController'+e);
		}
		return p;
	}
}