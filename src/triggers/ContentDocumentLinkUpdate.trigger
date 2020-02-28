trigger ContentDocumentLinkUpdate on ContentDocumentLink (after update,after delete,after insert) {
	
     Map<id,ContentDocumentLink> ContentDocumentLinkDetails = new Map<id,ContentDocumentLink >();
     List<Member_Comment__c> MemberlsttoUpdate = new List<Member_Comment__c>();
     List<SolarLoan_Document__c> solarLoanAttachmentsList  = new List<SolarLoan_Document__c>();
     set<ID> listCD  = new set<ID>();
     Map<Id, ContentDocument> cs = new Map<Id, ContentDocument>(); 
     
     
     Set<id> parent = new Set<id>();
    
        if(Trigger.isUpdate && Trigger.isAfter)
        {   
            for(ContentDocumentLink c : Trigger.New){
                ContentDocumentLinkDetails.put(c.id,c);
            }
        }
        
        if(Trigger.isInsert && Trigger.isAfter)
        {
         	for(ContentDocumentLink c : Trigger.New){
         		listCD.add(c.ContentDocumentId);
         	}
        }
        
        For(ContentDocument cd : [select id,title,CreatedDate,OwnerId from ContentDocument where id in: listCD]){
        	cs.put(cd.id,cd);
        }
        
        if(Trigger.isInsert && Trigger.isAfter)
        {
            for(ContentDocumentLink c : Trigger.New){
                Schema.SObjectType objType = c.LinkedEntityId.getsobjecttype();
                ContentDocumentLinkDetails.put(c.id,c);
                parent.add(c.LinkedEntityId);
                
                // ----------------------------Start Adding an Attachment detail in "Solar Loan Document" object--------------------------------------------------//
                
                if(objType == Solar_Loans__c.sObjectType){
	            
		            SolarLoan_Document__c solarLoanObj = new SolarLoan_Document__c();
		            solarLoanObj.Attachment_Id__c = c.ContentDocumentId;
		            solarLoanObj.IsMovedToOnBase__c = false;
		            solarLoanObj.Document_Type__c = 'Solar Loan Documents';
		            solarLoanObj.Document_Name__c = cs.get(c.ContentDocumentId).title;
	                solarLoanObj.Solar_Loans__c = c.LinkedEntityId;
	                solarLoanObj.Attachment_Owner__c = cs.get(c.ContentDocumentId).OwnerId;
	                solarLoanObj.Attachment_Created_On__c = cs.get(c.ContentDocumentId).CreatedDate;
	            	
	            	solarLoanAttachmentsList.add(solarLoanObj);
	            	
	        	}
            }
    	}
    	
    	insert (solarLoanAttachmentsList);
    	
        		// ----------------------------End Adding an Attachment detail in "Solar Loan Document" object--------------------------------------------------//
        		
        if(Trigger.isDelete && Trigger.isAfter){
            for(ContentDocumentLink c : Trigger.old){
                ContentDocumentLinkDetails.put(c.id,c);
                parent.add(c.LinkedEntityId);
            }
        }
      
	for (Member_Comment__c mem : [select Id, Name,Attachment_Number__c,(SELECT Id FROM Attachments),(SELECT Id FROM ContentDocumentLinks)  from Member_Comment__c where Id IN :parent])
    {
    	system.debug('ContentDocumentLinks size=' + mem.ContentDocumentLinks.size());
        mem.Attachment_Number__c = mem.ContentDocumentLinks.size() + mem.Attachments.size();
        MemberlsttoUpdate.add(mem);
       
    }    
     update MemberlsttoUpdate;
}