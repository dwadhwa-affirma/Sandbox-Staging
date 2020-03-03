trigger SolarLoanTrigger on Solar_Loans__c (after insert, after update) {
    
    Set<Id> SLIds = new Set<Id>();
    
    if(Trigger.isInsert){
        for(Integer i=0; i<trigger.new.size(); i++){
        
            //------------------------------- Checking if the status is being changed and status = 'ACH Pending'-----------------------------------------------//
            
            if(trigger.new[i].Status__c == 'ACH Pending'){
                SLIds.add(trigger.new[i].id);
            }
        } 
    }
    
    if(Trigger.isUpdate){
        for(Integer i=0; i<trigger.new.size(); i++){
        
            //------------------------------- Checking if the status is being changed and status = 'ACH Pending'-----------------------------------------------//
            
            if(trigger.old[i].Status__c != 'ACH Pending' && trigger.new[i].Status__c == 'ACH Pending'){
                SLIds.add(trigger.new[i].id);
            }
        } 
    }
    
    if(SLIds.size() > 0){
        
        //------------------------------- Calling Batch class with list of "Solar Loans" id to send a Docusign email---------------------------------------//
       
        Database.executeBatch(new SolarLoansToDocuSignBatch(SLIds),1);
    }
}