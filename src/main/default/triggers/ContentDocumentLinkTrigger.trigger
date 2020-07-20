trigger ContentDocumentLinkTrigger on ContentDocumentLink (before insert) {
    
    if(Trigger.isInsert && Trigger.isBefore){
     for(ContentDocumentLink d : Trigger.New){
     					system.debug('d ' + d);
	                    system.debug('LinkedEntityId - ' + d.LinkedEntityId);
	                    List<ContentDocument> lstContentDocument = [select Id from ContentDocument where id =: d.ContentDocumentId];
	                    system.debug('lstContentDocument - ' + lstContentDocument);
	            		List<lead> l = new List<lead>();
	            		l = [select id, Status from lead where id =: d.LinkedEntityId];
	            		system.debug('l ' + l);
	            		if(l.size() != 0)
	            		{
	            			if(l[0].Status == 'Closed - Not Converted' || l[0].Status == 'Closed - Converted')
	            			{
	            				d.LinkedEntityId.Adderror('You can not upload files on Closed Leads');
	            			}
	            		}
	          }
    	
    }
    

}