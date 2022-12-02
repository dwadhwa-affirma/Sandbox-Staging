public class LeadTriggerService {
    
    public static decimal getSLA(Lead objLead , string leadStatus){
        Map<String, Sla_Manager__mdt> slaManagerMap = Sla_Manager__mdt.getAll();
        for(string key: slaManagerMap.keySet()){
            String eventSource = objLead.Event_Source__c;
            String productType = objLead.Product_Type__c;
            String leadSource = objLead.LeadSource;
            String status = leadStatus;

            if(slaManagerMap.get(key).Object_Name__c == 'Lead' && slaManagerMap.get(key).Event_Source__c == '*'){
                eventSource = '*';

            }
            if(slaManagerMap.get(key).Object_Name__c == 'Lead' && slaManagerMap.get(key).Product_Type__c == '*'){
                productType = '*';
                
            }
            if(slaManagerMap.get(key).Object_Name__c == 'Lead' && slaManagerMap.get(key).Opportunity_Source__c == '*'){
                leadSource = '*';
                
            }
            if(slaManagerMap.get(key).Object_Name__c == 'Lead' && slaManagerMap.get(key).StageName__c == '*'){
                status = '*';
                
            }
            if(slaManagerMap.get(key).Event_Source__c == eventSource && slaManagerMap.get(key).Product_Type__c == productType && (leadSource !=null && slaManagerMap.get(key).Opportunity_Source__c.contains(leadSource)) && slaManagerMap.get(key).StageName__c == status ){
                return (decimal)slaManagerMap.get(key).SLA__c;
            }


        }
        
        return 0.0;
      }
    
    public static decimal getTimeDifference(datetime startTime)
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
    public static void updateHoursSpent(String status,string oldStatus, Lead lead,List<LeadHistory> hrsHistory)
    {
        decimal hoursSpent;
        
        if (lead.status != status && oldStatus == status && LeadTriggerService.getTimeStampFieldValue(status,lead) != null){
            LeadHistory leadFldHistoryobj=LeadTriggerService.findHistoryObject(lead.id,'Hour_Spent_' + status.replace(' ','_') +'_Status__c',HrsHistory);
            DateTime ValueforDifference;
            DateTime timeStampFieldValue = LeadTriggerService.getTimeStampFieldValue(status,lead);
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

            if(LeadTriggerService.getOtherFieldsAreNull(status,lead) )
            {
                hoursSpent =  LeadTriggerService.getTimeDifference(getTimeStampFieldValue(status,lead));
                LeadTriggerService.updateTimeStampOnOpp(status,lead,hoursSpent,false);
            }
            else{
                hoursSpent = LeadTriggerService.getTimeDifference(ValueforDifference);
                LeadTriggerService.updateTimeStampOnOpp(status,lead,hoursSpent,true);
            }
        }
    }
    public static void updateSLAFieldsForInsert(Lead lead,BusinessHours stdBusinessHours)
        {
            string status = lead.Status;
            decimal sla = getSLA(lead, status);
            system.debug('sla##'+ sla);
            lead.SLA__c = sla;

            /*--------Update TimeStamp Fields------*/
            if (status == 'New'){
                if(sla > 0){
                    lead.TimeStamp_New_status__c = DateTime.now();
                    lead.SLA_New__c = sla;
                    lead.Hour_Spent_New_Status__c = 0;
                }else{
                    lead.TimeStamp_New_status__c = null;
                    lead.SLA_New__c = null;
                    lead.Hour_Spent_New_Status__c = null;
                }
               
            } else if (status == 'Outreach'){
                if(sla > 0){
                    lead.TimeStamp_Outreach_status__c = DateTime.now();
                    lead.SLA_Outreach__c = sla;
                    lead.Hour_Spent_Outreach_Status__c = 0;
                }else{
                    lead.TimeStamp_Outreach_status__c = null;
                    lead.SLA_Outreach__c = null;
                    lead.Hour_Spent_Outreach_Status__c = null;
                }
            }
            else if (status == 'Considering'){
                if(sla > 0){
                    lead.TimeStamp_Considering_status__c = DateTime.now();
                    lead.SLA_Considering__c = sla;
                    lead.Hour_Spent_Considering_Status__c = 0;
                }else{
                    lead.TimeStamp_Considering_status__c = null;
                    lead.SLA_Considering__c = null;
                    lead.Hour_Spent_Considering_Status__c = null;
                }
            } 
            else if (status == 'Analyzing Needs'){
                if(sla > 0){
                    lead.TimeStamp_Analyzing_Needs_status__c = DateTime.now();
                    lead.SLA_Analyzing_Needs__c = sla;
                    lead.Hour_Spent_Analyzing_Needs_Status__c = 0;
                }else{
                    lead.TimeStamp_Analyzing_Needs_status__c = null;
                    lead.SLA_Analyzing_Needs__c = null;
                    lead.Hour_Spent_Analyzing_Needs_Status__c = null;
                }
            }
        
            /*----------Update Yellow and Breach TimeStamp Fields--------*/
            if (lead.SLA__c != NULL && stdBusinessHours != NULL && lead.Status == 'New' && lead.TimeStamp_New_status__c != null){
                lead.Yellow_Start_Time_New_Status__c = LeadTriggerService.addBusinessHours(stdBusinessHours.id, lead.TimeStamp_New_status__c, (Long)(lead.SLA__c -1 ));
                lead.SLA_Start_Time_New_Status__c = LeadTriggerService.addBusinessHours(stdBusinessHours.id, lead.TimeStamp_New_status__c, (Long)lead.SLA__c );
            }

            else if (lead.SLA__c != NULL && stdBusinessHours != NULL && lead.Status == 'Outreach' && lead.TimeStamp_Outreach_status__c != null){
                lead.Yellow_Start_Time_Outreach_Status__c = LeadTriggerService.addBusinessHours(stdBusinessHours.id, lead.TimeStamp_Outreach_status__c, (Long)(lead.SLA__c -1) );
                lead.SLA_Start_Time_Outreach_Status__c = LeadTriggerService.addBusinessHours(stdBusinessHours.id, lead.TimeStamp_Outreach_status__c, (Long)lead.SLA__c );
            }else if (lead.SLA__c != NULL && stdBusinessHours != NULL && lead.Status == 'Considering' && lead.TimeStamp_Considering_status__c != null){

                lead.Yellow_Start_Time_Considering_Status__c = LeadTriggerService.addBusinessHours(stdBusinessHours.id, lead.TimeStamp_Considering_status__c, (Long)(lead.SLA__c - 1) );           
                lead.SLA_Start_Time_Considering_Status__c = LeadTriggerService.addBusinessHours(stdBusinessHours.id, lead.TimeStamp_Considering_status__c, (Long)lead.SLA__c );
    
            } else if (lead.SLA__c != NULL && stdBusinessHours != NULL && lead.Status == 'Analyzing Needs' && lead.TimeStamp_Analyzing_Needs_status__c != null){
    
                lead.Yellow_Start_Time_Analyzing_Needs_Status__c = LeadTriggerService.addBusinessHours(stdBusinessHours.id, lead.TimeStamp_Analyzing_Needs_status__c, (Long)(lead.SLA__c - 1) );           
                lead.SLA_Start_Time_Analyzing_Needs_Status__c = LeadTriggerService.addBusinessHours(stdBusinessHours.id, lead.TimeStamp_Analyzing_Needs_status__c, (Long)lead.SLA__c );
    
            }
            else{
                lead.Yellow_Start_Time_New_Status__c = null;
                lead.Yellow_Start_Time_Outreach_Status__c = null;
                lead.Yellow_Start_Time_Considering_Status__c = null;
                lead.Yellow_Start_Time_Analyzing_Needs_Status__c = null;                
                lead.SLA_Start_Time_New_Status__c = null;
                lead.SLA_Start_Time_Outreach_Status__c = null;
                lead.SLA_Start_Time_Considering_Status__c = null;
                lead.SLA_Start_Time_Analyzing_Needs_Status__c = null;
                
            }                        
        }
        public static void updateSLAFieldsForUpdate(Lead lead,Lead oldLead,string newLeadSources, BusinessHours stdBusinessHours)
        {
            DateTime currentTime= DateTime.Now();
            string oldStatus = oldlead.Status;
            decimal oldSLAhours = oldlead.SLA__c;
            string oldProductType = oldlead.Product_Type__c;
            string oldleadSource = oldlead.LeadSource;
            decimal sla = getSLA(lead, lead.Status);

            if (lead.Status == 'New' && oldStatus != 'New'){
                lead.TimeStamp_New_status__c = DateTime.now();
                lead.SLA_New__c = sla;
            } else if (lead.Status == 'Outreach' && oldStatus != 'Outreach'){
                lead.TimeStamp_Outreach_status__c = DateTime.now();
                lead.SLA_Outreach__c = sla;
            }
            else if (lead.Status == 'Considering' && oldStatus != 'Considering'){
                lead.TimeStamp_Considering_status__c = DateTime.now();
                lead.SLA_Considering__c = sla;
            } 
            else if (lead.Status == 'Analyzing Needs' && oldStatus != 'Analyzing Needs'){
            lead.TimeStamp_Analyzing_Needs_status__c = DateTime.now();
            lead.SLA_Analyzing_Needs__c = sla;
            }
            
            if (lead.SLA__c != NULL && stdBusinessHours != NULL && lead.Status == 'New' && lead.TimeStamp_New_status__c != null && oldStatus != 'New'){
                system.debug('in new');
                lead.Yellow_Start_Time_New_Status__c = LeadTriggerService.addBusinessHours(stdBusinessHours.id, lead.TimeStamp_New_status__c, (Long) (lead.SLA__c-1));                            
                lead.SLA_Start_Time_New_Status__c = LeadTriggerService.addBusinessHours(stdBusinessHours.id, lead.TimeStamp_New_status__c, (Long) lead.SLA__c);                            
               /* if(lead.Hour_Spent_New_Status__c != null && lead.Hour_Spent_New_Status__c != 0){
                    lead.Yellow_Start_Time_New_Status__c = LeadTriggerService.addBusinessHours(stdBusinessHours.id, lead.Yellow_Start_Time_New_Status__c, -(Long)lead.Hour_Spent_New_Status__c);
                    lead.SLA_Start_Time_New_Status__c = LeadTriggerService.addBusinessHours(stdBusinessHours.id, lead.SLA_Start_Time_New_Status__c, -(Long)lead.Hour_Spent_New_Status__c);
                }*/
            } else if (lead.SLA__c != NULL && stdBusinessHours != NULL && lead.Status == 'Outreach' && lead.TimeStamp_Outreach_status__c != null && oldStatus != 'Outreach'){
                system.debug('in outreach');
                lead.Yellow_Start_Time_Outreach_Status__c = LeadTriggerService.addBusinessHours(stdBusinessHours.id, lead.TimeStamp_Outreach_status__c, (Long)(lead.SLA__c-1));
                lead.SLA_Start_Time_Outreach_Status__c = LeadTriggerService.addBusinessHours(stdBusinessHours.id, lead.TimeStamp_Outreach_status__c, (Long) lead.SLA__c); 
                
                /*if(lead.Hour_Spent_Outreach_Status__c != null && lead.Hour_Spent_Outreach_Status__c != 0){
                    lead.Yellow_Start_Time_Outreach_Status__c = LeadTriggerService.addBusinessHours(stdBusinessHours.id, lead.Yellow_Start_Time_Outreach_Status__c, -(Long)lead.Hour_Spent_Outreach_Status__c);
                    lead.SLA_Start_Time_Outreach_Status__c =LeadTriggerService.addBusinessHours(stdBusinessHours.id, lead.SLA_Start_Time_Outreach_Status__c, -(Long)lead.Hour_Spent_Outreach_Status__c);
                }*/
            } 
            else if(lead.SLA__c != NULL && stdBusinessHours != NULL && lead.Status == 'Considering' && lead.TimeStamp_Considering_status__c != null){
                system.debug('in Considering');
                lead.Yellow_Start_Time_Considering_Status__c = LeadTriggerService.addBusinessHours(stdBusinessHours.id, lead.TimeStamp_Considering_status__c, (Long) (lead.SLA__c -1));                            
                lead.SLA_Start_Time_Considering_Status__c =  LeadTriggerService.addBusinessHours(stdBusinessHours.id, lead.TimeStamp_Considering_status__c, (Long) lead.SLA__c);
               /* if(lead.Hour_Spent_Considering_Status__c != null && lead.Hour_Spent_Considering_Status__c != 0){
                    lead.Yellow_Start_Time_Considering_Status__c = LeadTriggerService.addBusinessHours(stdBusinessHours.id, lead.Yellow_Start_Time_Considering_Status__c, -(Long)lead.Hour_Spent_Considering_Status__c);
                    lead.SLA_Start_Time_Considering_Status__c = LeadTriggerService.addBusinessHours(stdBusinessHours.id, lead.SLA_Start_Time_Considering_Status__c, -(Long)lead.Hour_Spent_Considering_Status__c);
                }*/
            }
            else if(lead.SLA__c != NULL && stdBusinessHours != NULL && lead.Status == 'Analyzing Needs' && lead.TimeStamp_Analyzing_Needs_status__c != null){
                lead.Yellow_Start_Time_Analyzing_Needs_Status__c = LeadTriggerService.addBusinessHours(stdBusinessHours.id, lead.TimeStamp_Analyzing_Needs_status__c, (Long) (lead.SLA__c-1));                            
                lead.SLA_Start_Time_Analyzing_Needs_Status__c = LeadTriggerService.addBusinessHours(stdBusinessHours.id, lead.TimeStamp_Analyzing_Needs_status__c, (Long) lead.SLA__c);
                /*if(lead.Hour_Spent_Analyzing_Needs_Status__c != null && lead.Hour_Spent_Analyzing_Needs_Status__c != 0){
                    lead.Yellow_Start_Time_Analyzing_Needs_Status__c = LeadTriggerService.addBusinessHours(stdBusinessHours.id, lead.Yellow_Start_Time_Analyzing_Needs_Status__c, -(Long)lead.Hour_Spent_Analyzing_Needs_Status__c);
                    lead.SLA_Start_Time_Analyzing_Needs_Status__c = LeadTriggerService.addBusinessHours(stdBusinessHours.id, lead.SLA_Start_Time_Analyzing_Needs_Status__c, -(Long)lead.Hour_Spent_Analyzing_Needs_Status__c);
                }*/
            }
            /*else if(lead.SLA__c!=null && oldSLAhours!=null ){
                if(lead.SLA__c!=oldSLAhours){
                lead.SLA_Yellow_Start_Time__c = LeadTriggerService.addBusinessHours(stdBusinessHours.id, currentTime, (Long) lead.SLA__c - 1);                            
                lead.SLA_Breach_Time__c = LeadTriggerService.addBusinessHours(stdBusinessHours.id, currentTime, (Long) lead.SLA__c - 1);
                }  

            }*/
    }

    public static DateTime getTimeStampFieldValue(String status,Lead lead){
        
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
    
    
        public static datetime addBusinessHours(ID standardBusinessHourId,Datetime startDate,Long interval)
        {
            return BusinessHours.addgmt(standardBusinessHourId, startDate, (Long) ((interval) * 3600000));
        }
        public static datetime addBusinessHoursNegative(ID standardBusinessHourId,Datetime startDate,Long interval)
        {
            return BusinessHours.addgmt(standardBusinessHourId, startDate, -(Long) ((interval) * 3600000));
        }
        public static LeadHistory findHistoryObject(id leadID,string fieldName,List<LeadHistory> hrsHistory)
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
        public static boolean getOtherFieldsAreNull(string status, Lead lead)
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
        public static void updateTimeStampOnOpp(String status,Lead lead,decimal hoursSpent,boolean addPreviousValue)
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

}