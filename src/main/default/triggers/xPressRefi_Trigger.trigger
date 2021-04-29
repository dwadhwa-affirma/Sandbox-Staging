trigger xPressRefi_Trigger on xPressRefi__c(after insert, after update ){

	Set<Id> xPressRefiIdsforDocusign = new Set<Id>();
	Set<Id> xPressRefiIdsforMortgageCadenceCSV = new Set<Id>();
	Set<Id> xPressRefiIdsforMortgageWareCSV = new Set<Id>();
	Set<Id> xPressRefiIdsforContactDocusign = new Set<Id>();

	Set<Id> MCadenceCaseIdstoClose = new Set<Id>();
    Set<Id> MWareCaseIdstoClose = new Set<Id>();
	Set<Id> ContactCaseIdstoUpdate = new Set<Id>();
	Set<Id> MWareCaseIdstoUpdate = new Set<Id>();

	if (Trigger.isAfter && Trigger.isInsert){
		for (Integer i = 0; i < trigger.new.size(); i++){
			if(trigger.new[i].Is_Mortgage_Cadence__c == true && trigger.new[i].is_CSV_Generated__c == false){
				xPressRefiIdsforMortgageCadenceCSV.add(trigger.new[i].Id);
			}
			else if (trigger.new[i].Is_Product_Change__c == false && trigger.new[i].Is_Mortgage_Cadence__c == false){
				xPressRefiIdsforContactDocusign.add(trigger.new[i].Id);
			} 
			// else if (trigger.new[i].Is_Product_Change__c == true && trigger.new[i].is_CSV_Generated__c == false){
			// 	xPressRefiIdsforMortgageCadenceCSV.add(trigger.new[i].Id);
			// }
		}

        /*-------Send Docusign in Case of No Product Change--------*/
		if (xPressRefiIdsforContactDocusign.size() > 0){
			xPressRefiToDocusign.docusignContactInfoAPIcall(xPressRefiIdsforContactDocusign);
		}
        /*-------Create Mortgage Cadence file if Product Change--------*/
		if (xPressRefiIdsforMortgageCadenceCSV.size() > 0){
			xPressRefiController.CreateMortgageCadenceCSVFile(xPressRefiIdsforMortgageCadenceCSV);
		}
	}

	if (Trigger.isAfter && Trigger.isUpdate){
		for (Integer i = 0; i < trigger.new.size(); i++){
            /*-------Create Mortgage Ware file after Docusign Complete--------*/
			if (trigger.old[i].Contact_DocuSign_Status__c != 'Completed' && trigger.new[i].Contact_DocuSign_Status__c == 'Completed'){
				 xPressRefiIdsforDocusign.add(trigger.new[i].Id);
				 ContactCaseIdstoUpdate.add(trigger.new[i].case__c);
			}
			if (trigger.old[i].Docusign_Status__c != 'Completed' && trigger.new[i].Docusign_Status__c == 'Completed'){
				xPressRefiIdsforMortgageWareCSV.add(trigger.new[i].Id);
				MWareCaseIdstoClose.add(trigger.new[i].case__c);				
			}
			if (trigger.old[i].is_CSV_Generated__c == false && trigger.new[i].is_CSV_Generated__c == true){
				MCadenceCaseIdstoClose.add(trigger.new[i].case__c);
			}
			if (trigger.old[i].Is_Mortgage_Ware_File_Created__c == false && trigger.new[i].Is_Mortgage_Ware_File_Created__c == true){
				MWareCaseIdstoUpdate.add(trigger.new[i].case__c);
			}
		}

		if (xPressRefiIdsforMortgageWareCSV.size() > 0){
			xPressRefiController.CreateMortgageWareCSVFile(xPressRefiIdsforMortgageWareCSV);
		}

		/*-------Send Docusign in Case of No Product Change--------*/
		if (xPressRefiIdsforDocusign.size() > 0){
			xPressRefiToDocusign.docusignAPIcall(xPressRefiIdsforDocusign);
		}

        /*-------Close Case after Mortgage Ware file Created--------*/
		if (MWareCaseIdstoClose.size() > 0){
			List<Case> UpdateCasesList = [select id, status, Previous_Owner__c, OwnerId, Description
			                              from case
			                              where id in :MWareCaseIdstoClose];
			for (Case c : UpdateCasesList){
				c.OwnerId = c.Previous_Owner__c;							 
				c.status = 'Closed';
			}
			update UpdateCasesList;
		}
        /*-------Close Case after Mortgage Cadence file Created--------*/
        if (MCadenceCaseIdstoClose.size() > 0){
			List<Case> UpdateCasesList = [select id, status, Previous_Owner__c, OwnerId, Description
			                              from case
			                              where id in :MCadenceCaseIdstoClose];
			for (Case c : UpdateCasesList){			
				c.status = 'Closed';
				c.Description = c.Description + '\n\nMortgage Cadence File Created: Yes';
			}
			update UpdateCasesList;
		}

		/*-------Close Status Updatae After Contact Docusign Complete--------*/
		if (ContactCaseIdstoUpdate.size() > 0){
			List<Case> UpdateCasesList = [select id, status, Previous_Owner__c, OwnerId, Description
			                              from case
			                              where id in :ContactCaseIdstoUpdate];
			for (Case c : UpdateCasesList){							 
				c.status = 'Complete - Contact Info';
			}
			update UpdateCasesList;
		}

		if (MWareCaseIdstoUpdate.size() > 0){
			List<Case> UpdateCasesList = [select id, status, Previous_Owner__c, OwnerId, Description
			                              from case
			                              where id in :MWareCaseIdstoUpdate];
			for (Case c : UpdateCasesList){				
				c.Description = c.Description + '\n\nMortgage Ware File Created: Yes';
			}
			update UpdateCasesList;
		}

	}
}