trigger ContentDocumentLinkUpdate on ContentDocumentLink (after update,after delete,after insert) {
	
     Map<id,ContentDocumentLink> ContentDocumentLinkDetails = new Map<id,ContentDocumentLink >();
     List<Member_Comment__c> MemberlsttoUpdate = new List<Member_Comment__c>();
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
                ContentDocumentLinkDetails.put(c.id,c);
                parent.add(c.LinkedEntityId);
            }
    	}
        
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