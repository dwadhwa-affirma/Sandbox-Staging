global class SolarLoanDocumentDeleteAttachments implements Schedulable{
	
    global void execute(SchedulableContext SC) {
    	DeleteAttachments();
    }
    global static void DeleteAttachments(){
    
    	Map<string, SolarLoan_Document_Settings__c> SolarLoanSetting = SolarLoan_Document_Settings__c.getAll();
    	
    	//---------------------Getting values from custom setting and initializing it as well--------------------//
    	
    	Integer daysToDeleteAttachmentComplete = (integer) SolarLoanSetting.get('Completed').Days__c;
        Integer daysToDeleteAttachmentDecline = (integer) SolarLoanSetting.get('Declined').Days__c;
        Integer daysToDeleteAttachmentExpire = (integer) SolarLoanSetting.get('Expired').Days__c;
        
        List<Id> IdsCompletedDelete = new List<Id>();
        List<Id> IdsDeclinedDelete = new List<Id>();
        List<Id> IdsExpiredDelete = new List<Id>();
    	
        system.debug('daysToDeleteAttachmentComplete :: '+ daysToDeleteAttachmentComplete);
    	system.debug('daysToDeleteAttachmentDecline :: '+ daysToDeleteAttachmentDecline);
        system.debug('daysToDeleteAttachmentExpire :: '+ daysToDeleteAttachmentExpire);
        
        //---------------------Adding and Subtracting days from the value which we get from custom setting-------//
        
    	Date attchDeleteDateMaxComplete = Date.today().addDays(-daysToDeleteAttachmentComplete);
    	Date attchDeleteDateMinComplete = Date.today().addDays(-(daysToDeleteAttachmentComplete+30));
    	system.debug('attchDeleteDateComplete :: '+ attchDeleteDateMinComplete + ' :: ' + attchDeleteDateMaxComplete);
        
        Date attchDeleteDateMaxDecline = Date.today().addDays(-daysToDeleteAttachmentDecline);
    	Date attchDeleteDateMinDecline = Date.today().addDays(-(daysToDeleteAttachmentDecline+30));
    	system.debug('attchDeleteDateDecline :: '+ attchDeleteDateMinDecline + ' :: ' + attchDeleteDateMaxDecline);
        
        Date attchDeleteDateMaxExpire = Date.today().addDays(-daysToDeleteAttachmentExpire);
    	Date attchDeleteDateMinExpire = Date.today().addDays(-(daysToDeleteAttachmentExpire+30));
    	system.debug('attchDeleteDateExpire :: '+ attchDeleteDateMinExpire + ' :: ' + attchDeleteDateMaxExpire);
    	
    	
        List<Solar_Loans__c> SolarLoanList = [Select id from Solar_Loans__c];
       	set<Id> SolarLoanIdSet = (new Map<Id, Solar_Loans__c>(SolarLoanList)).keySet();	
    	
    	//---------------------Querying Solar Loan document based on status--------------------------------------//
    	
        List<SolarLoan_Document__c> SolarLoanAttchListComplete = [select Attachment_Id__c,Solar_Loans__c,Solar_Loans__r.Status__c from SolarLoan_Document__c where IsMovedToOnBase__c = true and Solar_Loans__r.Status__c = 'Closed' and DAY_ONLY(CreatedDate) <= :attchDeleteDateMaxComplete and DAY_ONLY(CreatedDate) >= :attchDeleteDateMinComplete];
		List<SolarLoan_Document__c> SolarLoanAttchListDecline = [select Attachment_Id__c,Solar_Loans__c,Solar_Loans__r.Status__c from SolarLoan_Document__c where IsMovedToOnBase__c = true and Solar_Loans__r.Status__c = 'Declined' and DAY_ONLY(CreatedDate) <= :attchDeleteDateMaxDecline and DAY_ONLY(CreatedDate) >= :attchDeleteDateMinDecline];
        List<SolarLoan_Document__c> SolarLoanAttchListExpire = [select Attachment_Id__c,Solar_Loans__c,Solar_Loans__r.Status__c from SolarLoan_Document__c where IsMovedToOnBase__c = true and Solar_Loans__r.Status__c = 'Expired' and DAY_ONLY(CreatedDate) <= :attchDeleteDateMaxExpire and DAY_ONLY(CreatedDate) >= :attchDeleteDateMinExpire];
        
        system.debug('SolarLoanAttchListComplete'+SolarLoanAttchListComplete);
        system.debug('SolarLoanAttchListDecline'+SolarLoanAttchListDecline);
        system.debug('SolarLoanAttchListExpire'+SolarLoanAttchListExpire);
        
    	set<string> attchIdSetComplete = new set<string>();
    	set<string> attchIdSetDecline = new set<string>();
        set<string> attchIdSetExpire = new set<string>();
        
        
        //---------------------Creating new list for AttachmentIds based on different Status ------------------//
        
    	for(SolarLoan_Document__c SolarLoanObj : SolarLoanAttchListComplete){
    		attchIdSetComplete.add(SolarLoanObj.Attachment_Id__c);
    	}
        
        for(SolarLoan_Document__c SolarLoanObj : SolarLoanAttchListDecline){
    		attchIdSetDecline.add(SolarLoanObj.Attachment_Id__c);
    	}
        
        for(SolarLoan_Document__c SolarLoanObj : SolarLoanAttchListExpire){
    		attchIdSetExpire.add(SolarLoanObj.Attachment_Id__c);
    	}
    	
    	
    	//---------------------Deleteing attachments if the list is not null....................----------------//
    	
    	if(attchIdSetComplete.size() > 0){
	    	List<ContentVersion> ContentDocumentListComp = [select id,ContentDocumentId from ContentVersion where id in: attchIdSetComplete];
	    	system.debug('SolarLoanAttchListComplete :: '+ContentDocumentListComp);
	    	
	    	for(ContentVersion cv : ContentDocumentListComp){
	    		IdsCompletedDelete.add(cv.ContentDocumentId);
	    	}
	    	
	 		List<ContentDocument> CompletedToDelete = [select id from ContentDocument where id in: IdsCompletedDelete];
	    	
	    	delete CompletedToDelete;
	    	
    	}
        
        if(attchIdSetDecline.size() > 0){
        	
	    	List<ContentVersion> ContentDocumentListDecline = [select id,ContentDocumentId from ContentVersion where id in: attchIdSetDecline];
	    	
	    	system.debug('SolarLoanAttchListDecline :: '+ContentDocumentListDecline);
	    	
	    	for(ContentVersion cv : ContentDocumentListDecline){
	    		IdsDeclinedDelete.add(cv.ContentDocumentId);
	    	}
	    	
	    	List<ContentDocument> DeclinedToDelete = [select id from ContentDocument where id in: IdsDeclinedDelete];
	    	
	    	delete DeclinedToDelete;
	    	
    	}
        
        if(attchIdSetExpire.size() > 0){
	    	List<ContentVersion> ContentDocumentListExpire = [select id,ContentDocumentId from ContentVersion where id in: attchIdSetExpire];
	    	system.debug('SolarLoanAttchListExpire :: '+ContentDocumentListExpire);
	    	
	    	for(ContentVersion cv : ContentDocumentListExpire){
	    		IdsExpiredDelete.add(cv.ContentDocumentId);
	    	}
	    	
	    	List<ContentDocument> ExpiredToDelete = [select id from ContentDocument where id in: IdsExpiredDelete];
	    	
	    	delete ExpiredToDelete;
	    	
    	}
    	/*for(Solar_Loans__c SolarObj : SolarLoanList){
    		SolarObj.Attachments_Are_Deleted__c = true;
    	}
    	update SolarLoanList; */
    }
}