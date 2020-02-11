global class SolarLoanDocumentDeleteAttachments implements Schedulable{
	
    global void execute(SchedulableContext SC) {
    	DeleteAttachments();
    }
    global static void DeleteAttachments(){
    
    	Map<string, SolarLoan_Document_Settings__c> SolarLoanSetting = SolarLoan_Document_Settings__c.getAll();
    	Integer daysToDeleteAttachment = (integer) SolarLoanSetting.get('DeleteAttachments').Days__c;
    	system.debug('daysToDeleteAttachment :: '+ daysToDeleteAttachment);
    	
    	Date attchDeleteDateMax = Date.today().addDays(-daysToDeleteAttachment);
    	Date attchDeleteDateMin = Date.today().addDays(-(daysToDeleteAttachment+30));
    	system.debug('attchDeleteDate :: '+ attchDeleteDateMin + ' :: ' + attchDeleteDateMax);
    	
        List<Solar_Loans__c> SolarLoanList = [Select id from Solar_Loans__c];
       	set<Id> SolarLoanIdSet = (new Map<Id, Solar_Loans__c>(SolarLoanList)).keySet();	
    	
    	List<SolarLoan_Document__c> SolarLoanAttchList = [select Attachment_Id__c from SolarLoan_Document__c where IsMovedToOnBase__c = true and DAY_ONLY(CreatedDate) <= :attchDeleteDateMax and DAY_ONLY(CreatedDate) >= :attchDeleteDateMin];
    	
    	set<string> attchIdSet = new set<string>();
    	
    	for(SolarLoan_Document__c SolarLoanObj : SolarLoanAttchList){
    		attchIdSet.add(SolarLoanObj.Attachment_Id__c);
    	}
    	
    	if(attchIdSet.size() > 0){
	    	List<Attachment> attachmentList = [select id from Attachment where Id IN: attchIdSet];
	    	system.debug('SolarLoanAttchList :: '+attachmentList);
	    	
	    	delete attachmentList;
	    	
    	}
    	for(Solar_Loans__c SolarObj : SolarLoanList){
    	//	SolarObj.Attachments_Are_Deleted__c = true;
    	}
    	update SolarLoanList;
    }
}