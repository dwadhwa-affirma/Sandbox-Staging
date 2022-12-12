public class LeadTriggerHelper
{
    private Sla_Manager__mdt[] slaDefList;
    private String newLeadSources;
 
    public LeadTriggerHelper()
    {
        slaDefList = [SELECT DeveloperName,Event_Source__c,Opportunity_Source__c,Product_Type__c,SLA__c,StageName__c FROM Sla_Manager__mdt WHERE Object_Name__c = 'Lead' ORDER BY DeveloperName ASC];
        newLeadSources = slaDefList[0].Opportunity_Source__c; // First Definition is used for Opportunity Source Breaches
    
    }

    public void updateSLAFields(List<Lead> newLeadList, List<Lead> oldLeadList)
    {
            //Get Business hours
            BusinessHours stdBusinessHours = [select id
                                            from businesshours
                                            where isDefault = true];

            system.debug('stdBusinessHours'+stdBusinessHours);

            if (trigger.isBefore && trigger.isinsert)
            {
                for (Lead l : newleadList){
                    LeadTriggerService.updateSLAFieldsForInsert(l,stdBusinessHours);
                }
            }
            else if (trigger.isBefore && trigger.isUpdate)
            {
                Map<string, Lead> mapOldLead = getOldLeadMap(oldLeadList);
                set<ID> ids = getNewleadIds(newLeadList);

                //the history list to query later in the updatehoursSpent method
                List<LeadHistory> hrsHoursHistory=new list<LeadHistory>();
                //hrsHoursHistory = getFieldHistory(hrsHoursHistory,ids);

                for (Lead lead : newleadList){
                    Lead oldlead = mapOldLead.get(lead.Id);
                    
                    lead.SLA__c = LeadTriggerService.getSLA(lead, lead.status);
                    DateTime currentTime = Datetime.now();
                    String oldStatus = oldLead.Status;
                    
                    LeadTriggerService.updateSLAFieldsForUpdate(lead,oldLead,newLeadSources,stdBusinessHours);
                    
                    //update hours spent for all statuses - the logic will update in only one instance below
                    //based on the current status of the leadortunity
                    LeadTriggerService.updateHoursSpent('New', oldStatus, lead,hrsHoursHistory);
                    LeadTriggerService.updateHoursSpent('Outreach', oldStatus, lead,hrsHoursHistory);
                    LeadTriggerService.updateHoursSpent('Considering', oldStatus, lead,hrsHoursHistory);
                    LeadTriggerService.updateHoursSpent('Analyzing Needs', oldStatus, lead,hrsHoursHistory);
                }
            }
        }
        private Map<String,Lead> getOldLeadMap(List<Lead> OldLeadList)
        {
            Map<string, Lead> mapOldLead =  new map<string,Lead>();
            for (Lead ol : oldLeadList){
                mapOldLead.put(ol.Id, ol);
            }
            return mapOldLead;
        }

        private List<LeadHistory> getFieldHistory(List<LeadHistory> hrsHoursHistory,set<id> ids)
        {
            hrsHoursHistory=[Select Id,LeadId, CreatedById, CreatedDate,Field, NewValue, OldValue from LeadHistory  where 
                    ( field = 'Hour_Spent_Outreach_Status__c' or field = 'Hour_Spent_New_Status__c' or field = 'Hour_Spent_Analyzing_Needs_Status__c' or field = 'Hour_Spent_Considering_Status__c'  ) 
                    and LeadId IN: ids Order by CreatedDate DESC ];
            return hrsHoursHistory;
        }

        private set<id> getNewLeadIds(List<Lead> newleadList)
        {
            set<id> ids=new set<id>();
            for (Lead ol : newleadList){
                ids.add(ol.id);
            }
            return ids;
        }

        

        
    

    
    
}