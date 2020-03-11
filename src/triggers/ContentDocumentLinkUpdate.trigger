trigger ContentDocumentLinkUpdate on ContentDocumentLink (after update,after delete,after insert) {
	
     Map<id,ContentDocumentLink> ContentDocumentLinkDetails = new Map<id,ContentDocumentLink >();
     
     List<Member_Comment__c> MemberlsttoUpdate = new List<Member_Comment__c>();
     List<SolarLoan_Document__c> solarLoanAttachmentsList  = new List<SolarLoan_Document__c>();
     set<ID> listCD  = new set<ID>();
     Map<Id, ContentDocument> cs = new Map<Id, ContentDocument>(); 
     Map<id,Solar_Loans__c> sl = new Map<id,Solar_Loans__c >();
     Map<ID,ID> cv = new Map<ID,ID>();
     
     
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
         		parent.add(c.LinkedEntityId);
         	}
        }
        
        For(ContentDocument cd : [select id,title,CreatedDate,OwnerId from ContentDocument where id in: listCD]){
        	cs.put(cd.id,cd);
        }
        
        For(Solar_Loans__c solarLoan : [select id, Member_Number__c from Solar_Loans__c where id in: parent]){
        	sl.put(solarLoan.id, solarLoan);
        }
        
        For(ContentVersion contentVersion : [select id,ContentDocumentId from ContentVersion where ContentDocumentId in: listCD]){
        	cv.put(contentVersion.ContentDocumentId,contentVersion.id);
        }
        system.debug('test'+cv);
        
        if(Trigger.isInsert && Trigger.isAfter)
        {
            for(ContentDocumentLink c : Trigger.New){
                Schema.SObjectType objType = c.LinkedEntityId.getsobjecttype();
                ContentDocumentLinkDetails.put(c.id,c);
               
                // ----------------------------Start Adding an Attachment detail in "Solar Loan Document" object--------------------------------------------------//
                
                if(objType == Solar_Loans__c.sObjectType){
	            
		            SolarLoan_Document__c solarLoanObj = new SolarLoan_Document__c();
		            solarLoanObj.Attachment_Id__c = cv.get(c.ContentDocumentId);
		            solarLoanObj.Member_Number__c = sl.get(c.LinkedEntityId).Member_Number__c;
		            solarLoanObj.IsMovedToOnBase__c = false;
		            solarLoanObj.Document_Type__c = 'Solar Loan';
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