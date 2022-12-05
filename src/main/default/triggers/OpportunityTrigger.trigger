trigger OpportunityTrigger on Opportunity (before insert, before update ) {

    if(OpportunityTriggerHandler.hasExecuted)// To prevent recursive re-entry
    {
         return;
    }
    
    OpportunityTriggerHandler.hasExecuted = true;
    
    OpportunityTriggerHandler handler = new OpportunityTriggerHandler(Trigger.isExecuting, Trigger.size);
    
    if(Trigger.isInsert && Trigger.isBefore)
    { 
       
        handler.OnBeforeInsert(Trigger.new);
    }
    else if(Trigger.isUpdate && Trigger.isBefore)
    {

        handler.OnBeforeUpdate(Trigger.new, Trigger.newMap, Trigger.oldMap);
    }
    
}