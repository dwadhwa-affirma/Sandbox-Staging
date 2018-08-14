trigger PersonAccountTrigger on Person_Account__c (after insert) {
    if(Trigger.isAfter){
        if(Trigger.isInsert){
            PersonAccountTriggerHandler.createCase(trigger.newMap);
            PersonAccountTriggerHandler.UpdateAccountBranch(Trigger.new);
        }
    }
}