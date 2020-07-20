global class OnBaseDocumentDeleteAttachments implements Schedulable{
   
    global void execute(SchedulableContext SC) {
    	DeleteAttachments();
    }
    global static void DeleteAttachments(){
    
    	Map<string, OnBase_Document_Settings__c> onbaseSetting = OnBase_Document_Settings__c.getAll();
    	Integer daysToDeleteAttachment = (integer) onbaseSetting.get('DeleteAttachments').Days__c;
    	system.debug('daysToDeleteAttachment :: '+ daysToDeleteAttachment);
    	
    	Date attchDeleteDateMax = Date.today().addDays(-daysToDeleteAttachment);
    	Date attchDeleteDateMin = Date.today().addDays(-(daysToDeleteAttachment+30));
    	system.debug('attchDeleteDate :: '+ attchDeleteDateMin + ' :: ' + attchDeleteDateMax);
    	List<Case> caseList = [Select id, Attachments_Are_Deleted__c from Case where Status = 'Closed' and Attachments_Are_Deleted__c = false and DAY_ONLY(ClosedDate) <= :attchDeleteDateMax and DAY_ONLY(ClosedDate) >= :attchDeleteDateMin];// //and ClosedDate = Today
       	set<Id> caseIdSet = (new Map<Id, Case>(caseList)).keySet();	
    	system.debug('caseIdSet :: '+caseIdSet);
    	
    	List<OnBase_Document__c> onbaseAttchList = [select Attachment_Id__c from OnBase_Document__c where (Case__c IN: caseIdSet  or Member_Comment__r.Case__C IN: caseIdSet) and IsMovedToOnBase__c = true];
    	
    	set<string> attchIdSet = new set<string>();
    	
    	for(OnBase_Document__c onbaseObj : onbaseAttchList){
    		attchIdSet.add(onbaseObj.Attachment_Id__c);
    	}
    	
    	if(attchIdSet.size() > 0){
	    	List<Attachment> attachmentList = [select id from Attachment where (Parent.Type = 'Case' or Parent.Type = 'Member_Comment__c') and Id IN: attchIdSet];
	    	system.debug('onbaseAttchList :: '+attachmentList);
	    	
	    	delete attachmentList;
	    	
    	}
    	for(Case caseObj : caseList){
    		caseObj.Attachments_Are_Deleted__c = true;
    	}
    	update caseList;
    }
}