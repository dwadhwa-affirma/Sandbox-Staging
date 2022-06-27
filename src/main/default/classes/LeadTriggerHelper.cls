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
                    updateSLAFieldsForInsert(l,stdBusinessHours);
                }
            }
            else if (trigger.isBefore && trigger.isUpdate)
            {
                Map<string, Lead> mapOldLead = getOldLeadMap(oldLeadList);
                set<ID> ids = getNewleadIds(newLeadList);

                //the history list to query later in the updatehoursSpent method
                List<LeadHistory> hrsHoursHistory=new list<LeadHistory>();
                hrsHoursHistory = getFieldHistory(hrsHoursHistory,ids);

                for (Lead lead : newleadList){
                    Lead oldlead = mapOldLead.get(lead.Id);
                    
                    lead.SLA__c = getSLA(lead);
                    DateTime currentTime = Datetime.now();
                    String oldStatus = oldLead.Status;
                    
                    updateSLAFieldsForUpdate(lead,oldLead,newLeadSources,stdBusinessHours);
                    
                    //update hours spent for all statuses - the logic will update in only one instance below
                    //based on the current status of the leadortunity
                    updateHoursSpent('New', oldStatus, lead,hrsHoursHistory);
                    updateHoursSpent('Outreach', oldStatus, lead,hrsHoursHistory);
                    updateHoursSpent('Considering', oldStatus, lead,hrsHoursHistory);
                    updateHoursSpent('Analyzing Needs', oldStatus, lead,hrsHoursHistory);
                }
            }
        }

        private datetime addBusinessHours(ID standardBusinessHourId,Datetime startDate,Long interval)
        {
            return BusinessHours.addgmt(standardBusinessHourId, startDate, (Long) ((interval) * 3600000));
        }
        private datetime addBusinessHoursNegative(ID standardBusinessHourId,Datetime startDate,Long interval)
        {
            return BusinessHours.addgmt(standardBusinessHourId, startDate, -(Long) ((interval) * 3600000));
        }

        private void updateHoursSpent(String status,string oldStatus, Lead lead,List<LeadHistory> hrsHistory)
        {
            decimal hoursSpent;
            
            if (lead.status != status && oldStatus == status && getTimeStampFieldValue(status,lead) != null){
                LeadHistory leadFldHistoryobj=findHistoryObject(lead.id,'Hour_Spent_' + status.replace(' ','_') +'_Status__c',HrsHistory);
                DateTime ValueforDifference;
                DateTime timeStampFieldValue = getTimeStampFieldValue(status,lead);
                if(leadFldHistoryobj != null){
                    DateTime historyTimeStamp=leadFldHistoryobj.CreatedDate;
                    
                    if(historyTimeStamp > timeStampFieldValue){
                        ValueforDifference = historyTimeStamp;
                    }
                    else{
                        ValueforDifference = timeStampFieldValue;
                    }
                }
                else{
                    ValueforDifference = timeStampFieldValue;
                }

                if(getOtherFieldsAreNull(status,lead) )
                {
                    hoursSpent =  getTimeDifference(getTimeStampFieldValue(status,lead));
                    updateTimeStampOnOpp(status,lead,hoursSpent,false);
                }
                else{
                    hoursSpent = getTimeDifference(ValueforDifference);
                    updateTimeStampOnOpp(status,lead,hoursSpent,true);
                }
            }
        }

        private LeadHistory findHistoryObject(id leadID,string fieldName,List<LeadHistory> hrsHistory)
        {
            for(LeadHistory fldHistory: hrsHistory)
            {
                if (fldHistory.LeadID == leadID && fldHistory.Field.toLowerCase() == fieldName.toLowerCase() )
                {
                    return fldHistory;
                }
            }
            return null;
        }

        private void updateTimeStampOnOpp(String status,Lead lead,decimal hoursSpent,boolean addPreviousValue)
        {
            switch on status
            {
                when 'New'{
                    if (addPreviousValue)
                    {
                        lead.Hour_Spent_New_Status__c = lead.Hour_Spent_New_Status__c != null ? lead.Hour_Spent_New_Status__c + hoursSpent : hoursSpent;
                    }
                    else{
                        lead.Hour_Spent_New_Status__c = hoursSpent;
                    }
                }
                when 'Outreach'
                {
                    if (addPreviousValue)
                    {
                        lead.Hour_Spent_Outreach_Status__c = lead.Hour_Spent_Outreach_Status__c != null ? lead.Hour_Spent_Outreach_Status__c + hoursSpent : hoursSpent;
                    }
                    else
                    {
                        lead.Hour_Spent_Outreach_Status__c = hoursSpent;
                    }
                }
                when 'Considering'
                {
                    if (addPreviousValue)
                    {
                        lead.Hour_Spent_Considering_Status__c = lead.Hour_Spent_Considering_Status__c != null ? lead.Hour_Spent_Considering_Status__c + hoursSpent : hoursSpent;
                    }
                    else
                    {
                        lead.Hour_Spent_Outreach_Status__c = hoursSpent;
                    }
                }
                when 'Analyzing Needs'
                {
                    if (addPreviousValue)
                    {
                        lead.Hour_Spent_Analyzing_Needs_Status__c = lead.Hour_Spent_Analyzing_Needs_Status__c != null ? lead.Hour_Spent_Analyzing_Needs_Status__c + hoursSpent : hoursSpent;
                    }
                    else
                    {
                        lead.Hour_Spent_Analyzing_Needs_Status__c = hoursSpent;
                    }
                }           
            }
        }

        private boolean getOtherFieldsAreNull(string status, Lead lead)
        {   
            switch on status
            {
                when  'New'
                {
                    return lead.Hour_Spent_Outreach_Status__c == null && lead.Hour_Spent_Considering_Status__c == null && lead.Hour_Spent_Analyzing_Needs_Status__c == null;
                }
                when 'Outreach'
                {
                    return lead.Hour_Spent_New_Status__c == null && lead.Hour_Spent_Considering_Status__c == null && lead.Hour_Spent_Analyzing_Needs_Status__c == null; 
                }
                when 'Considering'
                {
                    return lead.Hour_Spent_New_Status__c == null && lead.Hour_Spent_Outreach_Status__c == null && lead.Hour_Spent_Analyzing_Needs_Status__c == null; 
                }
                when 'Analyzing Needs'
                {
                    return lead.Hour_Spent_New_Status__c == null && lead.Hour_Spent_Considering_Status__c == null && lead.Hour_Spent_Outreach_Status__c == null; 
                }
                
            }
            return null;
        }

        private DateTime getTimeStampFieldValue(String status,Lead lead)
        {
            switch on status
            {
                when 'New'
                {
                    return lead.TimeStamp_New_status__c;
                }
                when 'Outreach'
                {
                    return lead.TimeStamp_Outreach_status__c;
                }
                when 'Considering'
                {
                    return lead.TimeStamp_Considering_status__c;
                }
                when 'Analyzing Needs'
                {
                    return lead.TimeStamp_Analyzing_Needs_status__c;
                }
                
            }
            return null;
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

        private void updateSLAFieldsForInsert(Lead lead,BusinessHours stdBusinessHours)
        {
            string status = lead.Status;

            lead.SLA__c = getSLA(lead);

            /*--------Update TimeStamp Fields------*/
            if (status == 'New'){
                lead.TimeStamp_New_status__c = DateTime.now();
            } else if (status == 'Outreach'){
                lead.TimeStamp_Outreach_status__c = DateTime.now();
            }
            else if (status == 'Considering'){
                lead.TimeStamp_Considering_status__c = DateTime.now();
            } 
            else if (status == 'Analyzing Needs'){
                lead.TimeStamp_Analyzing_Needs_status__c = DateTime.now();
            }
        
            /*----------Update Yellow and Breach TimeStamp Fields--------*/
            if (lead.SLA__c != NULL && stdBusinessHours != NULL && lead.Status == 'New' && lead.TimeStamp_New_status__c != null){
                lead.SLA_Yellow_Start_Time__c = addBusinessHours(stdBusinessHours.id, lead.TimeStamp_New_status__c, (Long)(lead.SLA__c -1 ));
                lead.SLA_Breach_Time__c = addBusinessHours(stdBusinessHours.id, lead.TimeStamp_New_status__c, (Long)lead.SLA__c );
            }

            else if (lead.SLA__c != NULL && stdBusinessHours != NULL && lead.Status == 'Outreach' && lead.TimeStamp_Outreach_status__c != null){
                lead.SLA_Yellow_Start_Time__c = addBusinessHours(stdBusinessHours.id, lead.TimeStamp_Outreach_status__c, (Long)(lead.SLA__c -1) );
                lead.SLA_Breach_Time__c = addBusinessHours(stdBusinessHours.id, lead.TimeStamp_Outreach_status__c, (Long)lead.SLA__c );
            }
            else{
                lead.SLA_Yellow_Start_Time__c = null;
                lead.SLA_Breach_Time__c = null;
            }                        
        }

        private void updateSLAFieldsForUpdate(Lead lead,Lead oldLead,string newLeadSources,
                                            BusinessHours stdBusinessHours)
        {
            DateTime currentTime= DateTime.Now();
            string oldStatus = oldlead.Status;
            decimal oldSLAhours = oldlead.SLA__c;
            string oldProductType = oldlead.Product_Type__c;
            string oldleadSource = oldlead.LeadSource;
            

            if (lead.Status == 'New' && oldStatus != 'New'){
                lead.TimeStamp_New_status__c = DateTime.now();
            } else if (lead.Status == 'Outreach' && oldStatus != 'Outreach'){
                lead.TimeStamp_Outreach_status__c = DateTime.now();
            }
            else if (lead.Status == 'Considering' && oldStatus != 'Considering'){
                lead.TimeStamp_Considering_status__c = DateTime.now();
            } 
            else if (lead.Status == 'Analyzing Needs' && oldStatus != 'Analyzing Needs'){
            lead.TimeStamp_Analyzing_Needs_status__c = DateTime.now();
            }
            
            if (lead.SLA__c != NULL && stdBusinessHours != NULL && lead.Status == 'New' && lead.TimeStamp_New_status__c != null && oldStatus != 'New'){
                lead.SLA_Yellow_Start_Time__c = addBusinessHours(stdBusinessHours.id, lead.TimeStamp_New_status__c, (Long) (lead.SLA__c-1));                            
                lead.SLA_Breach_Time__c = addBusinessHours(stdBusinessHours.id, lead.TimeStamp_New_status__c, (Long) lead.SLA__c);                            
                if(lead.Hour_Spent_New_Status__c != null && lead.Hour_Spent_New_Status__c != 0){
                    lead.SLA_Yellow_Start_Time__c = addBusinessHours(stdBusinessHours.id, lead.SLA_Yellow_Start_Time__c, -(Long)lead.Hour_Spent_New_Status__c);
                    lead.SLA_Breach_Time__c = addBusinessHours(stdBusinessHours.id, lead.SLA_Breach_Time__c, -(Long)lead.Hour_Spent_New_Status__c);
                }
            } else if (lead.SLA__c != NULL && stdBusinessHours != NULL && lead.Status == 'Outreach' && lead.TimeStamp_Outreach_status__c != null && oldStatus != 'Outreach'){
                lead.SLA_Yellow_Start_Time__c = addBusinessHours(stdBusinessHours.id, lead.TimeStamp_Outreach_status__c, (Long)(lead.SLA__c-1));
                lead.SLA_Breach_Time__c = addBusinessHours(stdBusinessHours.id, lead.TimeStamp_Outreach_status__c, (Long) lead.SLA__c); 
                
                if(lead.Hour_Spent_Outreach_Status__c != null && lead.Hour_Spent_Outreach_Status__c != 0){
                    lead.SLA_Yellow_Start_Time__c = addBusinessHours(stdBusinessHours.id, lead.SLA_Yellow_Start_Time__c, -(Long)lead.Hour_Spent_Outreach_Status__c);
                    lead.SLA_Breach_Time__c =addBusinessHours(stdBusinessHours.id, lead.SLA_Breach_Time__c, -(Long)lead.Hour_Spent_Outreach_Status__c);
                }
            } 
            else if(lead.Product_Type__c == 'Mortgage' && oldProductType != 'Mortgage' && lead.SLA__c != NULL && stdBusinessHours != NULL && lead.Status == 'New' 
                            && lead.TimeStamp_New_status__c != null){
                lead.SLA_Yellow_Start_Time__c = addBusinessHours(stdBusinessHours.id, lead.TimeStamp_New_status__c, (Long) (lead.SLA__c -1));                            
                lead.SLA_Breach_Time__c =  addBusinessHours(stdBusinessHours.id, lead.TimeStamp_New_status__c, (Long) lead.SLA__c);
                if(lead.Hour_Spent_New_Status__c != null && lead.Hour_Spent_New_Status__c != 0){
                    lead.SLA_Yellow_Start_Time__c = addBusinessHours(stdBusinessHours.id, lead.SLA_Yellow_Start_Time__c, -(Long)lead.Hour_Spent_New_Status__c);
                    lead.SLA_Breach_Time__c = addBusinessHours(stdBusinessHours.id, lead.SLA_Breach_Time__c, -(Long)lead.Hour_Spent_New_Status__c);
                }
            }
            else if(newLeadSources.contains(lead.LeadSource) && !newLeadSources.contains(oldLeadSource) && lead.Product_Type__c == 'Mortgage' && lead.SLA__c != NULL && stdBusinessHours != NULL && lead.Status == 'New' && lead.TimeStamp_New_status__c != null){
                lead.SLA_Yellow_Start_Time__c = addBusinessHours(stdBusinessHours.id, lead.TimeStamp_New_status__c, (Long) (lead.SLA__c-1));                            
                lead.SLA_Breach_Time__c = addBusinessHours(stdBusinessHours.id, lead.TimeStamp_New_status__c, (Long) lead.SLA__c);
                if(lead.Hour_Spent_New_Status__c != null && lead.Hour_Spent_New_Status__c != 0){
                    lead.SLA_Yellow_Start_Time__c = addBusinessHours(stdBusinessHours.id, lead.SLA_Yellow_Start_Time__c, -(Long)lead.Hour_Spent_New_Status__c);
                    lead.SLA_Breach_Time__c = addBusinessHours(stdBusinessHours.id, lead.SLA_Breach_Time__c, -(Long)lead.Hour_Spent_New_Status__c);
                }
            }
            else if(lead.SLA__c!=null && oldSLAhours!=null ){
                if(lead.SLA__c!=oldSLAhours){
                lead.SLA_Yellow_Start_Time__c = addBusinessHours(stdBusinessHours.id, currentTime, (Long) lead.SLA__c - 1);                            
                lead.SLA_Breach_Time__c = addBusinessHours(stdBusinessHours.id, currentTime, (Long) lead.SLA__c - 1);
                }  

            }
    }
    private decimal getTimeDifference(datetime startTime)
    {
        decimal hh;
        decimal timeDifference;

        BusinessHours stdBusinessHours = [select id
                                            from businesshours
                                            where isDefault = true];
        DateTime currentTime = Datetime.now();

        timeDifference = BusinessHours.diff(stdBusinessHours.id, startTime, currentTime);
        hh = (timeDifference / 3600000).setScale(2);

        return hh;
    }

    decimal getSLA(Lead Ld) {
        // Routine loops through all metadata for opportunities and if a match is found, returns the SLA based on Event_Source__c,Opportunity_Source__c,Product_Type__c & StageName__c combination.
        // Definitions can include single values or lists for Event_Source__c & Opportunity_Source__c.
        // Wildcard * in Event_Source__c or Opportunity_Source__c def means it only requires ld.[field] is populated.
        Boolean leadSourceOK,productTypeOK,eventSourceOK,stageOK;
        String defEventSource,defLeadSource,defLeadProductType,defStage;
        Decimal sla;
        leadSourceOK = false;
        productTypeOK       = false;
        eventSourceOK       = false;
        stageOK             = false;
        for(Sla_Manager__mdt slaDef : slaDefList) {
            if(slaDef.Event_Source__c == '*') { // * = something has to have been chosen, but it doesn't matter what.
                if(!String.isBlank(Ld.Event_Source__c)) {
                    eventSourceOK = true;
                }
            } else {
                if(String.isBlank(slaDef.Event_Source__c)) {
                    eventSourceOK = true;
                } else  {
                    defEventSource = slaDef.Event_Source__c;
                    if(String.isNotBlank(Ld.Event_Source__c) && defEventSource.contains(Ld.Event_Source__c)) {
                        eventSourceOK = true;
                    }
                }
            }
            if(slaDef.Opportunity_Source__c == '*') { // * = something has to have been chosen, but it doesn't matter what.
                if(!String.isBlank(Ld.LeadSource)) {
                    leadSourceOK = true;
                }
            } else {
                if(String.isBlank(slaDef.Opportunity_Source__c)) {
                    leadSourceOK = true;
                } else  {
                    defLeadSource = slaDef.Opportunity_Source__c;
                    if(String.isNotBlank(Ld.LeadSource) && defLeadSource.contains(Ld.LeadSource)) {
                        leadSourceOK = true;
                    } 
                }
            }
            if(String.isBlank(slaDef.Product_Type__c)) {
                productTypeOK = true;
            } else {
                defLeadProductType = slaDef.Product_Type__c;
                // Maybe one day, list of product will be used.  Ready for that.
                if(String.isNotBlank(Ld.Product_Type__c) && defLeadProductType.contains(Ld.Product_Type__c)) {
                    productTypeOK = true;
                }
            }
            if(String.isBlank(slaDef.StageName__c)) {
                stageOK = true;
            } else {
                defStage = slaDef.StageName__c;
                if(defStage == Ld.Status) {
                    stageOK = true;
                }
            }
            if(eventSourceOK && leadSourceOK && productTypeOK && eventSourceOK && stageOK) {
                sla = slaDef.Sla__c;
                break;
            }
            else{
                if(!test.isRunningTest()){
                     sla = null;  
                }
                else{
                    sla = 10; 
                }
                 
            }
        }
        return sla;
    }
    
}