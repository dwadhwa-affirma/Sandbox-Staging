/**
 * @description       : 
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             : 
 * @last modified on  : 06-01-2022
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
**/
trigger LevyTrigger on Levy__c (before update, after update , after insert) {
    if(trigger.isUpdate){
        List<Group> queueList = [SELECT Id FROM Group WHERE DeveloperName = 'Levy_Queue' LIMIT 1];
        Id levyQueueId = queueList[0].Id;
        Levy__c prior;
        
        for(Levy__c l : Trigger.new){ 
            prior = trigger.oldMap.get(l.Id);
            if(prior.ownerId == levyQueueId && l.ownerId != levyQueueId && l.status__c == 'Open') {
                System.debug( 'ownership changed from Queue to someone else and status was open, so status changed to In Process' );
                l.status__c = 'In Process';
            }
        }
    }
    if(trigger.isAfter && trigger.isInsert){
        Sla_Manager__mdt[] slaDefList;
        String NewLeadSources;
        slaDefList = [SELECT DeveloperName,Event_Source__c,Opportunity_Source__c,Product_Type__c,SLA__c,StageName__c FROM Sla_Manager__mdt WHERE Object_Name__c = 'Levy__c' ORDER BY DeveloperName ASC Limit 1];
        //decimal getSLA(Levy__c Lv){
        Decimal sla;
        if(slaDefList.size()>0){
            sla = slaDefList[0].SLA__c;
            updateSLAField(trigger.new,sla);
            
        }
        
        //return sla;
        
    }
    
    public void  updateSLAField(List<Levy__c> newLevyList,decimal sla){
        
        BusinessHours stdBusinessHours = [select id from businesshours where isDefault = true];
        if(trigger.isAfter){           
            if(trigger.isinsert){
                set<Id> LevyIds = new set<Id>();
                if(newLevyList.size() > 0){
                    for (Levy__c c : newLevyList) {
                        if ((stdBusinessHours != NULL) ) {    
                            LevyIds.add(c.id);
                        }              

                    }
                }
                List<Levy__c> levystoUpdate = [select id,CreatedDate,SLA__c  from Levy__c where id IN: LevyIds];
                if(levystoUpdate.size() > 0){
                    for (Levy__c c : levystoUpdate) { 
								c.SLA__c = sla;            
                        if ((c.SLA__c != NULL) && (stdBusinessHours != NULL) ) {
                            datetime FD = c.CreatedDate;                    
                            c.SLA_Yellow_Start_Time__c = BusinessHours.addgmt(stdBusinessHours.id, FD , (Long)(c.SLA__c-8) * 3600000);
                            c.SLA_Breach_Time__c = BusinessHours.addgmt(stdBusinessHours.id, FD, (Long) ((c.SLA__c) * 3600000));
                            
                        }
                        else{
                            c.SLA_Yellow_Start_Time__c = null;
                            c.SLA_Breach_Time__c = null;
                        }
                        
                    }
                    if(levystoUpdate.size() > 0){
                        update levystoUpdate;
                    }
                }
                
                
                
            }
            
        }       
    }    
}