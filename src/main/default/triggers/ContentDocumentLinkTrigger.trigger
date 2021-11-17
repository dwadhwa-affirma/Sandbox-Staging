trigger ContentDocumentLinkTrigger on ContentDocumentLink(before insert, after insert, after update ){

	if (Trigger.isInsert && Trigger.isBefore){
		for (ContentDocumentLink d : Trigger.New){
			system.debug('d ' + d);
			system.debug('LinkedEntityId - ' + d.LinkedEntityId);
			List<ContentDocument> lstContentDocument = [select Id
			                                            from ContentDocument
			                                            where id = :d.ContentDocumentId];
			system.debug('lstContentDocument - ' + lstContentDocument);
			List<lead> l = new List<lead>();
			l = [select id, Status
			     from lead
			     where id = :d.LinkedEntityId];
			system.debug('l ' + l);
			if (l.size() != 0){
				if (l[0].Status == 'Closed - Not Converted' || l[0].Status == 'Closed - Converted'){
					d.LinkedEntityId.Adderror('You can not upload files on Closed Leads');
				}
			}
		}


	}

	if (Trigger.isInsert && Trigger.isAfter){
		Set<Id> parent = new Set<Id>();
		Set<Id> CDLIds = new Set<Id>();
		Set<Id> parentDocusignStatus = new Set<Id>();
		Set<string> parentDocusignEnvelope = new Set<string>();
		Map<id, EFT__c> el = new Map<id, EFT__c>();
		for (ContentDocumentLink d : Trigger.New){
			system.debug('d1 ' + d);
			system.debug('LinkedEntityId1 - ' + d.LinkedEntityId);
			Schema.SObjectType objType = d.LinkedEntityId.getsobjecttype();
			system.debug('objType - ' + objType);
			if (objType == EFT__c.sObjectType){
				parent.add(d.LinkedEntityId);
				CDLIds.add(d.id);
			}		
        }

		system.debug('parent - ' + parent);
		if (parent.size() > 0){
			EFTToDocuSign.docusignAttachtoCase(parent);
		}

	}
}