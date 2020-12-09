trigger DocusignTrigger on dsfs__DocuSign_Status__c(after insert, after update ){

	List<Id> docList = new List<Id>();
	Set<ID> DocusignIdList = new Set<Id>();
	Set<string> DocusignEnvelopeIdList = new Set<string>();
	Map<string, string> EFTCaseMap = new map<string, string>();
    Set<ID> DocusignIdList1 = new Set<Id>();
    Map<string, string> UpdateEFTCaseMap = new map<string, string>();

	if (Trigger.isAfter && Trigger.isInsert){
		for (dsfs__DocuSign_Status__c d : Trigger.new){
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

	Map<Id, String> docMap = new Map<Id, String>();
	for (dsfs__DocuSign_Status__c d : Trigger.new){
		docList.add(d.dsfs__Case__c);
		docMap.put(d.dsfs__Case__c, d.dsfs__Envelope_Status__c);
		if (d.dsfs__Envelope_Status__c == 'Completed'){
			DocusignIdList.add(String.ValueOf(d.Id));
		}
	}

	List<Case> cs = [Select Id, Previous_Owner__c
	                 from Case
	                 where Id IN :docMap.keySet()];

	for (Case c : cs){
		//c.Docusign_Envelope_Status__c = Trigger.new[0].dsfs__Envelope_Status__c;
		if (docMap.get(c.Id) == 'Completed'){
			// c.Docusign_Envelope_Status__c = docMap.get(c.Id);
			if (c.Previous_Owner__c == null || c.Previous_Owner__c == ''){
			} else{
				c.OwnerId = Id.valueOf(c.Previous_Owner__c);
			}
			c.Docusign_Envelope_Status__c = 'Completed';
		}
		if (docMap.get(c.Id) == 'Sent'){
			c.Docusign_Envelope_Status__c = 'Sent';
		}
		if (docMap.get(c.Id) == 'Voided'){
			c.Docusign_Envelope_Status__c = 'Voided';
		}
		if (docMap.get(c.Id) == 'Declined'){
			c.Docusign_Envelope_Status__c = 'Declined';
			if (c.Previous_Owner__c == null || c.Previous_Owner__c == ''){
			} else{
				c.OwnerId = Id.valueOf(c.Previous_Owner__c);
			}
		}
		if (docMap.get(c.Id) == 'Authentication Failed'){
			c.Docusign_Envelope_Status__c = 'Authentication Failed';
			if (c.Previous_Owner__c == null || c.Previous_Owner__c == ''){
			} else{
				c.OwnerId = Id.valueOf(c.Previous_Owner__c);
			}
		}
	}
	update cs;
}