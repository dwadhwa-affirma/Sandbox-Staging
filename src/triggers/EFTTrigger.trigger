trigger EFTTrigger on EFT__c (after insert, after update, before update) {
    
    Set<Id> SLIds = new Set<Id>();
    Set<Id> SLIdsToCreateLoan = new Set<Id>();
    Set<Id> UpdateStatus = new Set<Id>();
    Set<Id> EFTdsForEFT = new Set<Id>();
    
    
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
        }   
    } 
    
    //------------------------------- Creating "EFT" record if the status = "Completed"------------------------------------------//
    if(EFTdsForEFT.size() > 0){
        
         EFTToSyimtar.insertEFTs(EFTdsForEFT);
    }
    
    
}