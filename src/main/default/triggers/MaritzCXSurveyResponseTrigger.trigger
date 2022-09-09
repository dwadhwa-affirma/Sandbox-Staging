trigger MaritzCXSurveyResponseTrigger on MaritzCX__Survey_Response__c (before insert,after insert) {
    
    MaritzCXSurveyResponseTriggerHandler handler = new MaritzCXSurveyResponseTriggerHandler();
    
    if (Trigger.isBefore) {
        if(Trigger.isInsert){
            handler.beforeInsert(Trigger.New); 
        }
    }
    
    if (Trigger.isAfter) 
    {
        if(Trigger.isInsert)
        {
            handler.afterInsert(Trigger.New);   
        }  
    }
}