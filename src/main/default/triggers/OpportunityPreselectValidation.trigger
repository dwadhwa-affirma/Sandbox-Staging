trigger OpportunityPreselectValidation on Opportunity (after insert, after update){
    
    OpportunityTriggerHandler handler = new OpportunityTriggerHandler(Trigger.isExecuting, Trigger.size);
    
    if(Trigger.isInsert && Trigger.isAfter){

        handler.OppToCheck(Trigger.new);
    }
    if(Trigger.isUpdate && Trigger.isAfter){ 
        
        handler.OnAfterUpdate(Trigger.new, Trigger.oldMap);    
    }

}