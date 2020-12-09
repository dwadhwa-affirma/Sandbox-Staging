trigger EFTTrigger on EFT__c(after insert, after update, before update ){

	Set<Id> SLIds = new Set<Id>();
	Set<Id> SLIdsToCreateLoan = new Set<Id>();
	Set<Id> UpdateStatus = new Set<Id>();
	Set<Id> EFTdsForEFT = new Set<Id>();
	Set<Id> EFTIdsForUpdate = new Set<Id>();
	Set<Id> EFTIdsForExpire = new Set<Id>();
	Set<Id> EFTIdsForExpireCreate = new Set<Id>();
	public static Set<Id> CaseIdsToUpdate = new Set<Id>();
	Set<Id> EFTsForCheckingType = new Set<Id>();
	Set<Id> EFTsForSavingsType = new Set<Id>();
	Set<Id> EFTsForNoAlternateAmount = new Set<Id>();
	Set<Id> EFTsForAlternateAmount = new Set<Id>();
	Set<Id> EFTIdsForUpdateOldValues = new Set<Id>();
	public static Set<Id> CaseIdsToClose = new Set<Id>();


	if (Trigger.isAfter && Trigger.isUpdate){

		for (Integer i = 0; i < trigger.new.size(); i++){

			//------------------------------- Checking if the status is being changed and status = 'Completed'-----------------//
			system.debug('trigger.new[i].Status__c==' + trigger.new[i].Status__c);
			if (trigger.old[i].Status__c != 'Completed' && trigger.new[i].Status__c == 'Completed'){
				if (!trigger.new[i].Docusign_is_Additional_Amount__c){
					EFTsForNoAlternateAmount.add(trigger.new[i].id);
				} else if (trigger.new[i].Docusign_is_Additional_Amount__c){
					if (trigger.old[i].Alternate_Amount__c != trigger.new[i].Alternate_Amount__c){
						EFTsForAlternateAmount.add(trigger.new[i].id);
					}
				}
				EFTdsForEFT.add(trigger.new[i].id);
				CaseIdsToUpdate.add(trigger.new[i].Case__c);
			}

			//------------------------------- Checking if only payment information changed-----------------//
			else if ((trigger.old[i].Update_Docusign_Status__c != 'Completed' && trigger.new[i].Update_Docusign_Status__c == 'Completed')){
				if (!trigger.new[i].Docusign_is_Additional_Amount__c){
					EFTsForNoAlternateAmount.add(trigger.new[i].id);
				} else if (trigger.new[i].Docusign_is_Additional_Amount__c){
					if (trigger.old[i].Alternate_Amount__c != trigger.new[i].Alternate_Amount__c){
						EFTsForAlternateAmount.add(trigger.new[i].id);
					}
				}

				EFTIdsForUpdate.add(trigger.new[i].id);
				CaseIdsToUpdate.add(trigger.new[i].Case__c);
			}


			//------------------------------- Checking if Only Expired-----------------//
			else if ((trigger.old[i].Expired__c != trigger.new[i].Expired__c && trigger.new[i].Expired__c == true && trigger.new[i].Expiration_Date__c == null)){
				EFTIdsForExpire.add(trigger.new[i].id);
				CaseIdsToUpdate.add(trigger.new[i].Case__c);
			} 
			

			//------------------------------- Checking if Docusign Voided-----------------//
			else if (trigger.old[i].Status__c != 'Voided' && trigger.new[i].Status__c == 'Voided'){
				CaseIdsToClose.add(trigger.new[i].Case__c);
			}

			else if (trigger.old[i].Update_Docusign_Status__c != 'Voided' && trigger.new[i].Update_Docusign_Status__c == 'Voided'){
				CaseIdsToClose.add(trigger.new[i].Case__c);
			}

			//------------------------------- Checking if Docusign Expired-----------------//
			else if (trigger.old[i].Status__c != 'Expired' && trigger.new[i].Status__c == 'Expired'){
				CaseIdsToClose.add(trigger.new[i].Case__c);
			}

			else if (trigger.old[i].Update_Docusign_Status__c != 'Expired' && trigger.new[i].Update_Docusign_Status__c == 'Expired'){
				CaseIdsToClose.add(trigger.new[i].Case__c);
			}
		}
	}


	if (EFTsForNoAlternateAmount.size() > 0){
		List<EFT__c> UpdateEFTList = [select id, Alternate_Amount__c
		                              from EFT__c
		                              where id in :EFTsForNoAlternateAmount];
		for (EFT__c e : UpdateEFTList){
			e.Alternate_Amount__c = 0;
		}

		update UpdateEFTList;
	}

	if (EFTsForAlternateAmount.size() > 0){
		List<EFT__c> UpdateEFTList = [select id, Alternate_Amount__c, Payment_Amount__c
		                              from EFT__c
		                              where id in :EFTsForAlternateAmount];
		for (EFT__c e : UpdateEFTList){
			//  e.Alternate_Amount__c=(e.Payment_Amount__c + e.Alternate_Amount__c);
		}

		update UpdateEFTList;
	}


	//------------------------------- Creating "EFT" record if the status = "Completed"------------------------------------------//
	if (EFTdsForEFT.size() > 0){
		if (!Test.isRunningTest()){
			EFTToSyimtar.insertEFTs(EFTdsForEFT);
			//EFTToDocuSign.docusignAttachtoCase(EFTdsForEFT);
		}

	}

	//------------------------------- Update "EFT" record ------------------------------------------//
	if (EFTIdsForUpdate.size() > 0){
		if (!Test.isRunningTest()){
			EFTToSyimtar.UpdateEFT(EFTIdsForUpdate, false);
			system.debug('EFTIdsForUpdate==' + EFTIdsForUpdate);
			//EFTToDocuSign.docusignAttachtoCase(EFTIdsForUpdate);
		}

	}

	//------------------------------- Expire EFT Record------------------------------------------//
	if (EFTIdsForExpire.size() > 0){
		if (!Test.isRunningTest()){
			EFTToSyimtar.UpdateEFT(EFTIdsForExpire, true);
		}
	}


	if (CaseIdsToUpdate.size() > 0){
		List<Case> UpdateCasesList = [select id, status
		                              from case
		                              where id in :CaseIdsToUpdate];
		for (Case c : UpdateCasesList){
			//c.OwnerId = UserInfo.getUserId();//'005j000000DCwXHAA1';
			//c.status = 'Closed';
		}
		update UpdateCasesList;
	}

	if (CaseIdsToClose.size() > 0){
		List<Case> UpdateCasesList = [select id, status
		                              from case
									  where id in :CaseIdsToClose];
									  
		for (Case c : UpdateCasesList){
			c.OwnerId = UserInfo.getUserId();//'005j000000DCwXHAA1';
			c.status = 'Closed';
		}
		update UpdateCasesList;
	}
}