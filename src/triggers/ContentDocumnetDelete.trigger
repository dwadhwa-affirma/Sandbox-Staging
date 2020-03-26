trigger ContentDocumnetDelete on ContentDocument (before delete, before insert, after delete) {
    
	List<Approve_Attachment__c> toupdateApproveAttachment  = new List<Approve_Attachment__c>();    
    Map<id,ContentDocumentLink> attachmentDetails = new Map<id,ContentDocumentLink >();
    set<Id> attachmentIdsForSolarLoan = new set<Id>();
    set<Id> ContentVersionIds = new set<ID>();
    Set<id> parent = new Set<id>();
    List<Solar_Loans__c> slcountUpdate = new List<Solar_Loans__c>();
    
    if(Trigger.isDelete){  	
    	system.debug('Content document link delete');
        
        for(ContentDocument d : Trigger.old){
        	attachmentIdsForSolarLoan.add(d.id);
        	
        	
            system.debug('Document ID - ' + d.Id);
            system.debug('d - ' + d);
            List<ContentDocumentLink> lstContentDocumentLinks = [select Id,LinkedEntityId, ContentDocumentId, ContentDocument.Title, ContentDocument.FileType from ContentDocumentLink where ContentDocumentId =: d.Id ALL ROWS];           
        	if(!lstContentDocumentLinks.isEmpty())
            {
                for(ContentDocumentLink a : lstContentDocumentLinks)
                {
                	 Schema.SObjectType objType = a.LinkedEntityId.getsobjecttype();
                	 if(objType == Solar_Loans__c.sObjectType){
                	 	parent.add(a.LinkedEntityId);
                	 }
                	 system.debug('parent'+parent);
                	 
                	 List<lead> l = new List<lead>();
	    			 l = [select id, Status from lead where id =: a.LinkedEntityId];
	    			 if(l.size() != 0)
	            		{
	            			if(l[0].Status == 'Closed - Not Converted' || l[0].Status == 'Closed - Converted')
	            			{
	            				d.Adderror('You can not Delete files for Closed Leads');
	            			}
	            		}
	            		else
	            		{
                    		system.debug('deleted Id - ' + a.id);
            				attachmentDetails.put(a.id,a); 
	            		}
                }
            }
                       
        }
        
        
      	// ----------------------------Decreasing count of attachments under "Solar Loans" record--------------------------------//
      	
	    for (Solar_Loans__c sl : [select Id, count__c ,(SELECT Id FROM ContentDocumentLinks)  from Solar_Loans__c where Id IN :parent]){
			Solar_Loans__c s = new Solar_Loans__c();
	    	s.id = sl.id;
	    	s.count__c = String.valueof(sl.ContentDocumentLinks.size());
	    	slcountUpdate.add(s);
	    	system.debug('ttt');
	   	}
	   	system.debug('slcountUpdate'+slcountUpdate);
	    if(slcountUpdate.size() > 0)	
	 		update slcountUpdate;
       
        // ----------------------------Start Deleting an Attachment detail in "Solar Loan Document" object--------------------------------------------------//
        
       /* For(ContentVersion contentVersion : [select id,ContentDocumentId from ContentVersion where ContentDocumentId in: attachmentIdsForSolarLoan]){
        		ContentVersionIds.add(contentVersion.id);
    	}
        	
        List<SolarLoan_Document__c> solarLoanAttachmentsList = [select id from SolarLoan_Document__c where Attachment_Id__c IN : ContentVersionIds];
         if(!solarLoanAttachmentsList.isEmpty()){
            system.debug('In If :: ');
            delete solarLoanAttachmentsList;
        } */
        // ----------------------------End Deleting an Attachment detail in "Solar Loan Document" object--------------------------------------------------//
        
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