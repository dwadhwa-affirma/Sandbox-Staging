trigger DocusignTrigger on dsfs__DocuSign_Status__c(after insert, after update ){

	List<Id> docList = new List<Id>();
	Set<ID> DocusignIdList = new Set<Id>();
	Set<string> DocusignVoidedEnvelopeIdList = new Set<string>();
	Set<ID> DocusignVoidedIdList = new Set<Id>();

	Set<string> DocusignEnvelopeIdList = new Set<string>();
	Map<string, string> EFTCaseMap = new map<string, string>();
	Set<ID> DocusignIdList1 = new Set<Id>();
	Map<string, string> UpdateEFTCaseMap = new map<string, string>();

	/*---------------------------------ACH Changes for assigning CaseId to Docusign Envelop Start Here----------------------------*/
	if (Trigger.isAfter && Trigger.isInsert){
		for (dsfs__DocuSign_Status__c d : Trigger.new ){
			DocusignEnvelopeIdList.add(d.dsfs__DocuSign_Envelope_ID__c);
			DocusignIdList1.add(String.ValueOf(d.Id));
		}
		system.debug('DocusignIdList1==' + DocusignIdList1);
		system.debug('DocusignEnvelopeIdList==' + DocusignEnvelopeIdList);
		List<EFT__C> lisCreateEFT = [SELECT id, Case__c, DocuSignId__c
		                             from EFT__c
		                             where DocuSignId__c IN :DocusignEnvelopeIdList];

		List<EFT__C> listUpdateEFT = [SELECT id, Case__c, Update_DocuSignId__c
		                              from EFT__c
		                              where Update_DocuSignId__c IN :DocusignEnvelopeIdList];

		system.debug('lisCreateEFT==' + lisCreateEFT);
		system.debug('listUpdateEFT==' + listUpdateEFT);
		if (lisCreateEFT.size() > 0){
			for (EFT__c e : lisCreateEFT){
				EFTCaseMap.put(e.DocuSignId__c.toUpperCase(), e.Case__c);
			}
			system.debug('EFTCaseMap==' + EFTCaseMap);
			List<dsfs__DocuSign_Status__c> listDocusignStatus = [select id, dsfs__Case__c, dsfs__DocuSign_Envelope_ID__c
			                                                     from dsfs__DocuSign_Status__c
			                                                     where id in :DocusignIdList1];
			system.debug('listDocusignStatus==' + listDocusignStatus);
			for (dsfs__DocuSign_Status__c d : listDocusignStatus){
				d.dsfs__Case__c = EFTCaseMap.get(d.dsfs__DocuSign_Envelope_ID__c);
			}
			system.debug('listDocusignStatus==' + listDocusignStatus);
			update listDocusignStatus;
		}

		if (listUpdateEFT.size() > 0){
			for (EFT__c e : listUpdateEFT){
				UpdateEFTCaseMap.put(e.Update_DocuSignId__c.toUpperCase(), e.Case__c);
			}
			system.debug('UpdateEFTCaseMap==' + UpdateEFTCaseMap);
			List<dsfs__DocuSign_Status__c> listDocusignStatusUpdate = [select id, dsfs__Case__c, dsfs__DocuSign_Envelope_ID__c
			                                                           from dsfs__DocuSign_Status__c
			                                                           where id in :DocusignIdList1];
			system.debug('listDocusignStatusUpdate==' + listDocusignStatusUpdate);
			for (dsfs__DocuSign_Status__c d : listDocusignStatusUpdate){
				d.dsfs__Case__c = UpdateEFTCaseMap.get(d.dsfs__DocuSign_Envelope_ID__c);
			}
			system.debug('listDocusignStatusUpdate==' + listDocusignStatusUpdate);
			update listDocusignStatusUpdate;
		}
	}

	/*---------------------------------ACH Changes for assigning CaseId to Docusign Envelop End Here----------------------------*/

	Map<Id, String> docMap = new Map<Id, String>();

	List<Id> docList1 = new List<Id>();
	Map<Id, String> docMap1 = new Map<Id, String>();

	for (dsfs__DocuSign_Status__c d : Trigger.new ){

		docList.add(d.dsfs__Case__c);

		system.debug('Docusign case id  ' + d.dsfs__Case__c);
		docMap.put(d.dsfs__Case__c, d.dsfs__Envelope_Status__c);

		if (d.dsfs__Envelope_Status__c == 'Completed'){
			DocusignIdList.add(String.ValueOf(d.Id));
		}

		docList1.add(d.dsfs__Opportunity__c);
		system.debug('docusign oppty ' + d.dsfs__Opportunity__c);
		docMap1.put(d.dsfs__Opportunity__c, d.dsfs__Envelope_Status__c);


	}

	if (docMap.size() > 0){
		List<Case> cs = [Select Id, Previous_Owner__c, ownerid, status, sub_status__c
		                 from Case
		                 where Id IN :docMap.keySet()];

		Group gp = [Select ID, Name
		            from Group
		            where DeveloperName = 'DocuSign_Queue'];

		for (Case c : cs){
			//c.Docusign_Envelope_Status__c = Trigger.new[0].dsfs__Envelope_Status__c;
			if (docMap.get(c.Id) == 'Completed'){
				// c.Docusign_Envelope_Status__c = docMap.get(c.Id);
				if (c.Previous_Owner__c == null || c.Previous_Owner__c == ''){
				} else{
					c.OwnerId = Id.valueOf(c.Previous_Owner__c);
				}
				c.Docusign_Envelope_Status__c = 'Completed';
				c.status = 'DocuSign Complete';
			}
			if (docMap.get(c.Id) == 'Sent'){
				c.Docusign_Envelope_Status__c = 'Sent';
				c.status = 'Waiting for Member';
				c.Previous_Owner__c = c.ownerid;
				system.debug('previous owner is  ' + c.ownerId);
				c.ownerId = gp.id;
				c.Sub_Status__c = '1st Contact';
			}
			if (docMap.get(c.Id) == 'Voided'){
				c.Docusign_Envelope_Status__c = 'Voided';

				// c.status = 'DocuSign Complete';
				// if(c.OwnerId != null || c.ownerid != ''){
				//  c.OwnerId = c.Previous_Owner__c;}
			}
			if (docMap.get(c.Id) == 'Declined'){
				c.Docusign_Envelope_Status__c = 'Declined';
				c.status = 'DocuSign Complete';
				if (c.Previous_Owner__c == null || c.Previous_Owner__c == ''){
				} else{
					c.OwnerId = Id.valueOf(c.Previous_Owner__c);
				}
			}
			if (docMap.get(c.Id) == 'Authentication Failed'){
				c.Docusign_Envelope_Status__c = 'Authentication Failed';
				c.status = 'DocuSign Complete';
				if (c.Previous_Owner__c == null || c.Previous_Owner__c == ''){
				} else{
					c.OwnerId = Id.valueOf(c.Previous_Owner__c);
				}
			}
		}
		update cs;

	}

	/* DocuSign workflow for opportunities similar to case */
	system.debug('docmap1 size  ' + docMap1.size());
	if (docMap1.size() > 0){
		List<Opportunity> ops = [Select Id, Previous_Owner__c, User_Owner__c, Sub_Status__C, Queue_Owner__c, Previous_Owner_Queue__c
		                         from Opportunity
		                         where Id IN :docMap1.keySet()];

		Group gp = [Select ID, Name
		            from Group
		            where DeveloperName = 'DocuSign_Queue'];

		for (Opportunity o : ops){

			if (docMap1.get(o.Id) == 'Completed'){

				if (o.Previous_Owner__c == null || o.Previous_Owner__c == ''){
					if (o.Previous_Owner_Queue__c != null){
						o.Queue_Owner__c = o.Previous_Owner_Queue__c;

					}
				} else{
					o.OwnerId = Id.valueOf(o.Previous_Owner__c);
					o.User_Owner__c = Id.valueOf(o.Previous_Owner__c);
				}
				o.Docusign_Envelope_Status__c = 'Completed';
				o.StageName = 'Fulfillment';
				o.Sub_Status__c = 'DocuSign Complete';
			}

			if (docMap1.get(o.Id) == 'Sent'){
				o.Docusign_Envelope_Status__c = 'Sent';
				o.Stagename = 'Fulfillment';
				o.Sub_Status__c = 'Waiting for Member';
				system.debug('test test test');
				// o.Sub_Status__c = '1st Attempt';
				system.debug('test1 test1 test1');
				if (o.User_Owner__c != null){

					o.Previous_Owner__c = o.User_Owner__c;
					// o.Previous_Owner_Queue__c = null;

				} else{
					if (o.Queue_Owner__c != null || o.Queue_Owner__c != ''){
						o.Previous_Owner_Queue__c = o.Queue_Owner__c;
						//  o.User_Owner__c = null;
					}
				}

				o.Queue_Owner__c = String.valueOf(gp.Name);
				o.User_Owner__c = null;
				system.debug('docusign oppty owner ' + gp.id + ' quee owner  ' + o.Queue_Owner__c);
			}
			if (docMap1.get(o.Id) == 'Voided'){
				if (o.Previous_Owner__c == null || o.Previous_Owner__c == ''){
					if (o.Previous_Owner_Queue__c != null){
						o.Queue_Owner__c = o.Previous_Owner_Queue__c;
						system.debug('previous queue owner ' + o.Queue_Owner__c);
						// o.Previous_Owner_Queue__c = null;
					}
				} else{
					o.OwnerId = Id.valueOf(o.Previous_Owner__c);
					o.User_Owner__c = Id.valueOf(o.Previous_Owner__c);
				}

				o.Docusign_Envelope_Status__c = 'Voided';
				o.StageName = 'Fulfillment';
				//o.StageName = 'DocuSign Complete';
				o.Sub_Status__c = 'DocuSign Complete';
				system.debug('Document is voided  ');
			}
			if (docMap1.get(o.Id) == 'Declined'){
				if (o.Previous_Owner__c == null || o.Previous_Owner__c == ''){
					if (o.Previous_Owner_Queue__c != null){
						o.Queue_Owner__c = o.Previous_Owner_Queue__c;
						system.debug('previous queue owner ' + o.Queue_Owner__c);

						// o.Previous_Owner_Queue__c = null;
					}
				} else{
					o.OwnerId = Id.valueOf(o.Previous_Owner__c);
					o.User_Owner__c = Id.valueOf(o.Previous_Owner__c);
				}
				o.Docusign_Envelope_Status__c = 'Declined';
				o.StageName = 'Fulfillment';
				o.Sub_Status__c = 'DocuSign Complete';
				system.debug('document is declined ' + o.Queue_Owner__c);
			}
			if (docMap1.get(o.Id) == 'Authentication Failed'){
				if (o.Previous_Owner__c == null || o.Previous_Owner__c == ''){
					if (o.Previous_Owner_Queue__c != null){
						o.Queue_Owner__c = o.Previous_Owner_Queue__c;
					}
				} else{
					o.OwnerId = Id.valueOf(o.Previous_Owner__c);
					o.User_Owner__c = Id.valueOf(o.Previous_Owner__c);
				}
				o.Docusign_Envelope_Status__c = 'Authentication Failed';
				o.StageName = 'Fulfillment';
				o.Sub_Status__c = 'DocuSign Complete';
				// o.StageName = 'Authentication Failed';
			}

		}

		update ops;
		/* End of DocuSign workflow for opportunities similar to case */
	}

	if (Trigger.isAfter && Trigger.isUpdate){
		for (dsfs__DocuSign_Status__c d : Trigger.new){			
			if (d.dsfs__Envelope_Status__c == 'Voided'){
				DocusignVoidedEnvelopeIdList.add(d.dsfs__DocuSign_Envelope_ID__c);
				DocusignVoidedIdList.add(String.ValueOf(d.Id));
			}
		}

		List<WIRES_Transaction__c> listWires = [SELECT id, DocuSignId__c
		                                        from WIRES_Transaction__c
		                                        where DocuSignId__c IN :DocusignVoidedEnvelopeIdList];
		
		for(WIRES_Transaction__c w: listWires){
			w.Status__c = 'Voided';
		}

		update listWires;
	}

	/*---------------------------------Start: CRM-1929:Enable sweep of documents completed in DocuSign tab----------------------------*/
	// list<ContentDocumentLink> cls = new list<ContentDocumentLink>();
	// list<Attachment> AttachmentList = new list<Attachment>();
	// set<Id> CompletedDocIds = new set<Id>();
	// Map<Id, id> docObjectMap = new Map<Id, id>();

	// for (dsfs__DocuSign_Status__c d : Trigger.new){
	//     if (d.dsfs__Envelope_Status__c == 'Completed' && d.dsfs__Case__c != null){
	//         CompletedDocIds.add(d.Id);
	//         docObjectMap.put(d.Id, d.dsfs__Case__c);
	//     }
	// }

	// system.debug('CompletedDocIds==' + CompletedDocIds);

	// if (CompletedDocIds.size() > 0){
	//     AttachmentList = [Select Id, Name, ParentId
	//                       from Attachment
	//                       where ParentId IN :CompletedDocIds];

	//     cls = [select id, ContentDocumentId, ShareType, LinkedEntityId
	//            from ContentDocumentLink
	//            where LinkedEntityId IN :CompletedDocIds];
	// }

	// system.debug('cls==' + cls);
	// system.debug('AttachmentList==' + AttachmentList);

	// set<id> setContentDocumentLink = new set<id>();

	// Map<id, ContentDocumentLink> mapAttachment = new Map<id, ContentDocumentLink>();
	// Map<id, ContentVersion> mapContentVersion = new Map<id, ContentVersion>();

	// for (ContentDocumentLink cdl : cls){
	//     mapAttachment.put(cdl.LinkedEntityId, cdl);
	//     setContentDocumentLink.add(cdl.ContentDocumentId);
	// }

	// List<ContentVersion> theFiles = [SELECT Title, FileType, VersionData, ContentDocumentId
	//                                  FROM ContentVersion
	//                                  WHERE ContentDocumentId IN :setContentDocumentLink];
	// system.debug('theFiles==' + theFiles);

	// for (ContentVersion cv : theFiles){
	//     mapContentVersion.put(cv.ContentDocumentId, cv);
	// }

	// system.debug('mapAttachment==' + mapAttachment);

	// for (ContentDocumentLink obj : cls){
	//     id tempContentDocId = obj.ContentDocumentId;
	//     ContentVersion tempCV = mapContentVersion.get(tempContentDocId);
	//     system.debug('tempCV==' + tempCV);
	//     Attachment anAttachment = new Attachment();
	//     anAttachment.Body = tempCV.VersionData;
	//     anAttachment.ContentType = 'application/pdf';
	//     anAttachment.Name = tempCV.Title;
	//     anAttachment.ParentId = docObjectMap.get(obj.LinkedEntityId);
	//     insert anAttachment;
	// }

	/*---------------------------------End: CRM-1929:Enable sweep of documents completed in DocuSign tab----------------------------*/
}