trigger ContentDocumnetDelete on ContentDocument (before delete) {
    
	List<Approve_Attachment__c> toupdateApproveAttachment  = new List<Approve_Attachment__c>();    
    Map<id,ContentDocumentLink> attachmentDetails = new Map<id,ContentDocumentLink >();
    if(Trigger.isDelete && Trigger.isBefore){
    	system.debug('Content document link delete');
        for(ContentDocument d : Trigger.old){
            system.debug('Document ID - ' + d.Id);
            List<ContentDocumentLink> lstContentDocumentLinks = [select Id, ContentDocumentId, ContentDocument.Title, ContentDocument.FileType from ContentDocumentLink where ContentDocumentId =: d.Id];
        	if(!lstContentDocumentLinks.isEmpty())
            {
                for(ContentDocumentLink a : lstContentDocumentLinks)
                {
                    system.debug('deleted Id - ' + a.id);
            		attachmentDetails.put(a.id,a); 
                }
            }
                       
        }
        
        List<Approve_Attachment__c> ApproveAttachment = [select id,Attachment_Name__c,ContentDocumentLinkId__c  from Approve_Attachment__c where ContentDocumentLinkId__c IN : attachmentDetails.keySet()];
        system.debug('Approve Attchment size - ' + ApproveAttachment.size());
        if(!ApproveAttachment.isEmpty()){
        	if(Trigger.isDelete && Trigger.isBefore){
	            for(Approve_Attachment__c ap :  ApproveAttachment){
	            	system.debug('Approve attachment - ' + ap.Id);
	                toupdateApproveAttachment.add(ap);
	            }
	            if(!toupdateApproveAttachment.isEmpty()){
	            	system.debug('Approve attachment deleting ');
	               delete toupdateApproveAttachment;
	            }
        	}
        }
    }
}