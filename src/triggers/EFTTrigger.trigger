trigger EFTTrigger on EFT__c (after insert, after update, before update) {
    
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
    
  /*  if(Trigger.isInsert){
        for(Integer i=0; i<trigger.new.size(); i++){
        
            //------------------------------- Checking if the status is being changed and status = 'Completed'-----------------------------------------------//
                
            if(trigger.new[i].Status__c == 'Completed'){
                EFTdsForEFT.add(trigger.new[i].id);
                CaseIdsToUpdate.add(trigger.new[i].Case__c); 
            }   
        }        
    }*/
    		
    if(Trigger.isAfter && Trigger.isUpdate){
        
        for(Integer i=0; i<trigger.new.size(); i++){
            
             //------------------------------- Checking if the status is being changed and status = 'Completed'-----------------//
            
            if(trigger.old[i].Status__c != 'Completed' && trigger.new[i].Status__c == 'Completed'){  
               /* if(trigger.old[i].Docusign_Checking_Type__c != trigger.new[i].Docusign_Savings_Type__c){                    
                    if(trigger.new[i].Docusign_Checking_Type__c){
                        EFTsForCheckingType.add(trigger.new[i].id);
                    }
                    else if(trigger.new[i].Docusign_Savings_Type__c){
                        EFTsForSavingsType.add(trigger.new[i].id);
                    }
                }*/
                if(!trigger.new[i].Docusign_is_Additional_Amount__c){
                		EFTsForNoAlternateAmount.add(trigger.new[i].id);
                }
                else if(trigger.new[i].Docusign_is_Additional_Amount__c){
                	if(trigger.old[i].Alternate_Amount__c != trigger.new[i].Alternate_Amount__c){
                		EFTsForAlternateAmount.add(trigger.new[i].id);
                	}
                }
                EFTdsForEFT.add(trigger.new[i].id);
                CaseIdsToUpdate.add(trigger.new[i].Case__c); 
            }
            
             //------------------------------- Checking if only payment information changed-----------------//
            else if((trigger.old[i].Update_Docusign_Status__c != 'Completed' && trigger.new[i].Update_Docusign_Status__c == 'Completed')
              /* && (trigger.old[i].Routing_Number__c == trigger.new[i].Routing_Number__c
              && trigger.old[i].Account_Number__c == trigger.new[i].Account_Number__c
              && trigger.old[i].Bank_Name__c == trigger.new[i].Bank_Name__c
              && trigger.old[i].Type__c == trigger.new[i].Type__c)
              && (trigger.old[i].Payment_Amount__c != trigger.new[i].Payment_Amount__c
              || trigger.old[i].Alternate_Amount__c != trigger.new[i].Alternate_Amount__c
              || trigger.old[i].Day_of_Month__c != trigger.new[i].Day_of_Month__c
              || trigger.old[i].Frequency__c != trigger.new[i].Frequency__c
              || trigger.old[i].Effective_Date__c != trigger.new[i].Effective_Date__c)*/
              ){
                EFTIdsForUpdate.add(trigger.new[i].id);
                CaseIdsToUpdate.add(trigger.new[i].Case__c); 
            }
            
            //------------------------------- Checking if financial institution data changed-----------------//
           /*  else if((trigger.old[i].Update_Docusign_Status__c != 'Completed' && trigger.new[i].Update_Docusign_Status__c == 'Completed')
                   && (trigger.old[i].Routing_Number__c != trigger.new[i].Routing_Number__c
              || trigger.old[i].Account_Number__c != trigger.new[i].Account_Number__c
              || trigger.old[i].Bank_Name__c != trigger.new[i].Bank_Name__c
              || trigger.old[i].Type__c != trigger.new[i].Type__c)
                   ){
                EFTIdsForExpireCreate.add(trigger.new[i].id);
            }*/
            
            //------------------------------- Checking if Only Expired-----------------//
            else if((trigger.old[i].Expired__c != trigger.new[i].Expired__c
              && trigger.new[i].Expired__c == true && trigger.new[i].Expiration_Date__c == null)){
                EFTIdsForExpire.add(trigger.new[i].id);
                CaseIdsToUpdate.add(trigger.new[i].Case__c);
            }
        }   
    } 
   
    
  /*  if(EFTsForCheckingType.size() > 0){
        List<EFT__c> UpdateEFTList = [select id, type__C from EFT__c where id in: EFTsForCheckingType];
        for(EFT__c e: UpdateEFTList){
            e.type__C='Checking';            
        }   
        update UpdateEFTList;
    }
    
    if(EFTsForSavingsType.size() > 0){
        List<EFT__c> UpdateEFTList = [select id, type__C from EFT__c where id in: EFTsForSavingsType];
        for(EFT__c e: UpdateEFTList){
            e.type__C='Savings';            
        }
        
        update UpdateEFTList;
    }*/
    
    if(EFTsForNoAlternateAmount.size() > 0){
    		List<EFT__c> UpdateEFTList = [select id, Alternate_Amount__c from EFT__c where id in: EFTsForNoAlternateAmount];
	        for(EFT__c e: UpdateEFTList){
	            e.Alternate_Amount__c=0;            
	        }
	        
	        update UpdateEFTList;
    }
    
    if(EFTsForAlternateAmount.size() > 0){
    		List<EFT__c> UpdateEFTList = [select id, Alternate_Amount__c, Payment_Amount__c from EFT__c where id in: EFTsForAlternateAmount];
	        for(EFT__c e: UpdateEFTList){
	          //  e.Alternate_Amount__c=(e.Payment_Amount__c + e.Alternate_Amount__c);            
	        }
	        
	        update UpdateEFTList;
    }
    
     
    //------------------------------- Creating "EFT" record if the status = "Completed"------------------------------------------//
    if(EFTdsForEFT.size() > 0){
         EFTToSyimtar.insertEFTs(EFTdsForEFT);
    }
    
     //------------------------------- Update "EFT" record ------------------------------------------//
    if(EFTIdsForUpdate.size() > 0){        
         EFTToSyimtar.UpdateEFT(EFTIdsForUpdate, false);
         system.debug('EFTIdsForUpdate=='+EFTIdsForUpdate);
    }
    
     //------------------------------- Expire and Create EFT Record------------------------------------------//
    /*if(EFTIdsForExpireCreate.size() > 0){        
         EFTToSyimtar.UpdateEFT(EFTIdsForExpireCreate, true);
         EFTToSyimtar.insertEFTs(EFTIdsForExpireCreate);
    }*/
    
    //------------------------------- Expire EFT Record------------------------------------------//
    if(EFTIdsForExpire.size() > 0){        
         EFTToSyimtar.UpdateEFT(EFTIdsForExpire, true);         
    }
    
    if(CaseIdsToUpdate.size() > 0){  
        List<Case> UpdateCasesList = [select id, status from case where id in: CaseIdsToUpdate];
        for(Case c: UpdateCasesList){
            	c.OwnerId = '005j000000DCwXHAA1';
                c.status = 'Closed';
            }
            update UpdateCasesList;
    }
}