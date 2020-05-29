trigger EFTTrigger on EFT__c (after insert, after update, before update) {
    
    Set<Id> SLIds = new Set<Id>();
    Set<Id> SLIdsToCreateLoan = new Set<Id>();
    Set<Id> UpdateStatus = new Set<Id>();
    Set<Id> EFTdsForEFT = new Set<Id>();
    Set<Id> EFTIdsForUpdate = new Set<Id>();
    Set<Id> EFTIdsForExpire = new Set<Id>();
    Set<Id> EFTIdsForExpireCreate = new Set<Id>();
    
    
    if(Trigger.isInsert){
        for(Integer i=0; i<trigger.new.size(); i++){
        
            //------------------------------- Checking if the status is being changed and status = 'Completed'-----------------------------------------------//
                
            if(trigger.new[i].Status__c == 'Completed'){
                EFTdsForEFT.add(trigger.new[i].id);
            }   
        }        
    }
    		
    if(Trigger.isAfter && Trigger.isUpdate){
        
        for(Integer i=0; i<trigger.new.size(); i++){
            
             //------------------------------- Checking if the status is being changed and status = 'Completed'-----------------//
            
            if(trigger.old[i].Status__c != 'Completed' && trigger.new[i].Status__c == 'Completed'){
                EFTdsForEFT.add(trigger.new[i].id);
            }
            
             //------------------------------- Checking if only payment information changed-----------------//
            if((trigger.old[i].Routing_Number__c == trigger.new[i].Routing_Number__c
              && trigger.old[i].Account_Number__c == trigger.new[i].Account_Number__c
              && trigger.old[i].Bank_Name__c == trigger.new[i].Bank_Name__c
              && trigger.old[i].Type__c == trigger.new[i].Type__c)
              && (trigger.old[i].Payment_Amount__c != trigger.new[i].Payment_Amount__c
              || trigger.old[i].Alternate_Amount__c != trigger.new[i].Alternate_Amount__c
              || trigger.old[i].Day_of_Month__c != trigger.new[i].Day_of_Month__c
              || trigger.old[i].Frequency__c != trigger.new[i].Frequency__c
              || trigger.old[i].Effective_Date__c != trigger.new[i].Effective_Date__c)){
                EFTIdsForUpdate.add(trigger.new[i].id);
            }
            
            //------------------------------- Checking if financial institution data changed-----------------//
            else if((trigger.old[i].Routing_Number__c != trigger.new[i].Routing_Number__c
              || trigger.old[i].Account_Number__c != trigger.new[i].Account_Number__c
              || trigger.old[i].Bank_Name__c != trigger.new[i].Bank_Name__c
              || trigger.old[i].Type__c != trigger.new[i].Type__c)){
                EFTIdsForExpireCreate.add(trigger.new[i].id);
            }
            
            //------------------------------- Checking if Only Expired-----------------//
            else if((trigger.old[i].Expired__c != trigger.new[i].Expired__c
              && trigger.new[i].Expired__c == true)){
                EFTIdsForExpire.add(trigger.new[i].id);
            }
        }   
    } 
    
    //------------------------------- Creating "EFT" record if the status = "Completed"------------------------------------------//
    if(EFTdsForEFT.size() > 0){
        
         EFTToSyimtar.insertEFTs(EFTdsForEFT);
    }
    
     //------------------------------- Update "EFT" record ------------------------------------------//
    if(EFTIdsForUpdate.size() > 0){        
         EFTToSyimtar.UpdateEFT(EFTIdsForUpdate, false);
    }
    
     //------------------------------- Expire and Create EFT Record------------------------------------------//
    if(EFTIdsForExpireCreate.size() > 0){        
         EFTToSyimtar.UpdateEFT(EFTIdsForExpireCreate, true);
         EFTToSyimtar.insertEFTs(EFTIdsForExpireCreate);
    }
    
    //------------------------------- Expire EFT Record------------------------------------------//
    if(EFTIdsForExpire.size() > 0){        
         EFTToSyimtar.UpdateEFT(EFTIdsForExpire, true);         
    }
    
    
}