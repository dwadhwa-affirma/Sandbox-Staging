public class OpportunityTriggerHelper
{

    private Sla_Manager__mdt[] slaDefList;
    private String newOppSources;
 
    public OpportunityTriggerHelper()
    {
        slaDefList = [SELECT DeveloperName,Event_Source__c,Opportunity_Source__c,Product_Type__c,SLA__c,StageName__c FROM Sla_Manager__mdt WHERE Object_Name__c = 'Opportunity' ORDER BY DeveloperName ASC];
        NewOppSources = slaDefList[0].Opportunity_Source__c; // First Definition is used for Opportunity Source Breaches
    
    }

public void updateSLAFields(List<Opportunity> newOppList, List<Opportunity> oldOpportunityList)
{
        system.debug('in updateSLA');
        //Get Business hours
        BusinessHours stdBusinessHours = [select id
                                          from businesshours
                                          where isDefault = true];
        system.debug('check is before updateSLA');
        if (trigger.isBefore && trigger.isinsert)
        {
            for (Opportunity l : newOppList){
                updateSLAFieldsForInsert(l,stdBusinessHours);
            }
        }  
        else if (trigger.isBefore && trigger.isUpdate)
        {
            Map<string, Opportunity> mapOldOpportunity = new Map<string, Opportunity>();
            for (Opportunity ol : oldOpportunityList){
                mapOldOpportunity.put(ol.Id, ol);
            }
        
            for (Opportunity opp : newOppList){
                Opportunity oldOpportunity = mapOldOpportunity.get(opp.Id);
                string oldStatus = oldOpportunity.StageName;
                
                opp.SLA_Business_Hours__c = getSLA(opp);

                set<ID> ids = getNewOppIds(newOppList);
                
                //the history list to query later in the updatehoursSpent method
                List<OpportunityFieldHistory> hrsHoursHistory = new list<OpportunityFieldHistory>();
                hrsHoursHistory = getFieldHistory(hrsHoursHistory,ids);

                updateSLAFieldsForUpdate(opp, oldOpportunity, stdBusinessHours);
                
                //update hours spent for all statuses - the logic will update in only one instance below
                //based on the current status of the opportunity
                updateHoursSpent('New', oldStatus, opp,hrsHoursHistory);
                updateHoursSpent('Outreach', oldStatus, opp,hrsHoursHistory);
                updateHoursSpent('Considering', oldStatus, opp,hrsHoursHistory);
                updateHoursSpent('Analyzing Needs', oldStatus, opp,hrsHoursHistory);
                updateHoursSpent('Fulfilment', oldStatus, opp,hrsHoursHistory);
            }
        }
    }

    private set<id> getNewOppIds(List<Opportunity> newOpportunities)
    {
        set<id> ids=new set<id>();
        for (Opportunity ol : newOpportunities){
            ids.add(ol.id);
        }
        return ids;
    }

    private List<OpportunityFieldHistory> getFieldHistory(List<OpportunityFieldHistory> hrsHoursHistory,set<id> ids)
    {
        hrsHoursHistory=[Select Id,Opportunity.id, CreatedById, CreatedDate,Field, NewValue, OldValue from OpportunityFieldHistory where 
                            ( field = 'Hour_Spent_Outreach_Status__c' or field = 'Hour_Spent_New_Status__c' or field = 'Hour_Spent_Analyzing_Needs_Status__c' 
                            or field = 'Hour_Spent_Considering_Status__c' or field = 'Hour_Spent_Fulfillment_Status__c')  
                            and Opportunity.id IN: ids Order by CreatedDate DESC ];
        return hrsHoursHistory;
    }
    
    private void updateHoursSpent(String status,string oldStatus, Opportunity opp,List<OpportunityFieldHistory> hrsHistory)
    {
        decimal hoursSpent;
        
        if (opp.StageName != status && oldStatus == status && getTimeStampFieldValue(status,opp) != null){
            OpportunityFieldHistory oppFldHistoryobj=findHistoryObject(opp.id,'Hour_Spent_' + status.replace(' ','_') +'_Status__c',HrsHistory);
            DateTime valueforDifference;
            DateTime timeStampFieldValue = getTimeStampFieldValue(status,opp);
            
            if(oppFldHistoryobj != null){
                DateTime historyTimeStamp=oppFldHistoryobj.CreatedDate;
                if(historyTimeStamp > timeStampFieldValue){
                    valueforDifference = historyTimeStamp;
                }
                else{
                    valueforDifference = timeStampFieldValue;
                }
            }
            else{
                valueforDifference = timeStampFieldValue;
            }

            if(getOtherFieldsAreNull(status,opp) )
            {
                hoursSpent =  getTimeDifference(getTimeStampFieldValue(status,opp));
                updateTimeStampOnOpp(status,opp,hoursSpent,false);
            }
            else{
                hoursSpent = getTimeDifference(valueforDifference);
                updateTimeStampOnOpp(status,opp,hoursSpent,true);
            }
        }
    }

    private OpportunityFieldHistory findHistoryObject(id opportunityID,string fieldName,List<OpportunityFieldHistory> hrsHistory)
    {
        for(OpportunityFieldHistory fldHistory: hrsHistory)
        {
            if (fldHistory.OpportunityID == opportunityID && fldHistory.Field.toLowerCase() == fieldName.toLowerCase() )
            {
                return fldHistory;
            }
        }
        return null;
    }

    private void updateTimeStampOnOpp(String status,Opportunity opp,decimal hoursSpent,boolean addPreviousValue)
    {
        switch on status
        {
            when 'New'{
                if (addPreviousValue)
                {
                    opp.Hour_Spent_New_Status__c = opp.Hour_Spent_New_Status__c != null ? opp.Hour_Spent_New_Status__c + hoursSpent : hoursSpent;
                }
                else{
                    opp.Hour_Spent_New_Status__c = hoursSpent;
                }
            }
            when 'Outreach'
            {
                if (addPreviousValue)
                {
                    opp.Hour_Spent_Outreach_Status__c = opp.Hour_Spent_Outreach_Status__c != null ? opp.Hour_Spent_Outreach_Status__c + hoursSpent : hoursSpent;
                }
                else
                {
                    opp.Hour_Spent_Outreach_Status__c = hoursSpent;
                }
            }
            when 'Considering'
            {
                if (addPreviousValue)
                {
                    opp.Hour_Spent_Considering_Status__c = opp.Hour_Spent_Considering_Status__c != null ? opp.Hour_Spent_Considering_Status__c + hoursSpent : hoursSpent;
                }
                else
                {
                    opp.Hour_Spent_Outreach_Status__c = hoursSpent;
                }
            }
            when 'Analyzing Needs'
            {
                if (addPreviousValue)
                {
                    opp.Hour_Spent_Analyzing_Needs_Status__c = opp.Hour_Spent_Analyzing_Needs_Status__c != null ? opp.Hour_Spent_Analyzing_Needs_Status__c + hoursSpent : hoursSpent;
                }
                else
                {
                    opp.Hour_Spent_Analyzing_Needs_Status__c = hoursSpent;
                }
            }
            when 'Fulfilment'
            {
                if (addPreviousValue)
                {
                    opp.Hour_Spent_Fulfillment_Status__c = opp.Hour_Spent_Fulfillment_Status__c != null ? opp.Hour_Spent_Fulfillment_Status__c + hoursSpent : hoursSpent;
                }
                else
                {
                    opp.Hour_Spent_Fulfillment_Status__c = hoursSpent;
                }
            }
        }
    }

    private boolean getOtherFieldsAreNull(string status, Opportunity opp)
    {   
        switch on status
        {
            when  'New'
            {
                return opp.Hour_Spent_Outreach_Status__c == null && opp.Hour_Spent_Considering_Status__c == null && opp.Hour_Spent_Analyzing_Needs_Status__c == null && opp.Hour_Spent_Fulfillment_Status__c == null;
            }
            when 'Outreach'
            {
                return opp.Hour_Spent_New_Status__c == null && opp.Hour_Spent_Considering_Status__c == null && opp.Hour_Spent_Analyzing_Needs_Status__c == null && opp.Hour_Spent_Fulfillment_Status__c == null; 
            }
            when 'Considering'
            {
                return opp.Hour_Spent_New_Status__c == null && opp.Hour_Spent_Outreach_Status__c == null && opp.Hour_Spent_Analyzing_Needs_Status__c == null && opp.Hour_Spent_Fulfillment_Status__c == null; 
            }
            when 'Analyzing Needs'
            {
                return opp.Hour_Spent_New_Status__c == null && opp.Hour_Spent_Considering_Status__c == null && opp.Hour_Spent_Outreach_Status__c == null && opp.Hour_Spent_Fulfillment_Status__c == null; 
            }
            when 'Fulfilment'
            {
                return opp.Hour_Spent_New_Status__c == null && opp.Hour_Spent_Considering_Status__c == null && opp.Hour_Spent_Outreach_Status__c == null && opp.Hour_Spent_Analyzing_Needs_Status__c == null; 
            }
        }
        return null;

    }

    private DateTime getTimeStampFieldValue(String status,Opportunity opp)
    {
        switch on status
        {
            when 'New'
            {
                return opp.TimeStamp_New_status__c;
            }
            when 'Outreach'
            {
                return opp.TimeStamp_Outreach_status__c;
            }
            when 'Considering'
            {
                return opp.TimeStamp_Considering_status__c;
            }
            when 'Analyzing Needs'
            {
                return opp.TimeStamp_Analyzing_Needs_status__c;
            }
            when 'Fulfilment'
            {
                return opp.TimeStamp_Fulfillment_status__c;    
            }
        }
        return null;
    }


    private void updateSLAFieldsForInsert(Opportunity opp,BusinessHours stdBusinessHours)
    {
        string status = opp.StageName;
        opp.SLA_Business_Hours__c = getSLA(opp);
        /*--------Update TimeStamp Fields------*/
        if (status == 'New'){
            opp.TimeStamp_New_status__c = DateTime.now();
        } else if (status == 'Outreach'){
            opp.TimeStamp_Outreach_status__c = DateTime.now();
        }
        else if (status == 'Considering'){
            opp.TimeStamp_Considering_status__c = DateTime.now();
        } 
        else if (status == 'Analyzing Needs'){
            opp.TimeStamp_Analyzing_Needs_status__c = DateTime.now();
        }
        else if (status == 'Fulfillment'){
            opp.TimeStamp_Fulfillment_status__c = DateTime.now();
        }
        /*----------Update Yellow and Breach TimeStamp Fields--------*/
        if (opp.SLA_Business_Hours__c != NULL && stdBusinessHours != NULL && opp.StageName == 'New' && opp.TimeStamp_New_status__c != null){
            opp.SLA_Yellow_Start_Time__c = addBusinessHours(stdBusinessHours.id, opp.TimeStamp_New_status__c, (Long)(opp.SLA_Business_Hours__c -1) );
            opp.SLA_Breach_Time__c = addBusinessHours(stdBusinessHours.id, opp.TimeStamp_New_status__c, (Long)opp.SLA_Business_Hours__c );
        }

        else if (opp.SLA_Business_Hours__c != NULL && stdBusinessHours != NULL && opp.StageName == 'Outreach' && opp.TimeStamp_Outreach_status__c != null){
            opp.SLA_Yellow_Start_Time__c = addBusinessHours(stdBusinessHours.id, opp.TimeStamp_Outreach_status__c, (Long)(opp.SLA_Business_Hours__c - 1) );
            opp.SLA_Breach_Time__c = addBusinessHours(stdBusinessHours.id, opp.TimeStamp_Outreach_status__c, (Long)opp.SLA_Business_Hours__c );
        }
        else{
            opp.SLA_Yellow_Start_Time__c = null;
            opp.SLA_Breach_Time__c = null;
        }                        
    }

    private void updateSLAFieldsForUpdate(Opportunity opp,Opportunity oldOpportunity, BusinessHours stdBusinessHours)
    {
        string status = opp.StageName;
        string oldStatus = oldOpportunity.StageName;
        decimal oldSLAhours = oldOpportunity.SLA_Business_Hours__c;
        string oldProductType = oldOpportunity.Product_Type__c;
        string oldoppSource = oldOpportunity.Opportunity_Source__c;
        DateTime currentTime = DateTime.Now();

        if (opp.StageName == 'New' && oldStatus != 'New'){
            opp.TimeStamp_New_status__c = DateTime.now();
        } else if (opp.StageName == 'Outreach' && oldStatus != 'Outreach'){
            opp.TimeStamp_Outreach_status__c = DateTime.now();
        }
        else if (opp.StageName == 'Considering' && oldStatus != 'Considering'){
            opp.TimeStamp_Considering_status__c = DateTime.now();
        } 
        else if (opp.StageName == 'Analyzing Needs' && oldStatus != 'Analyzing Needs'){
           opp.TimeStamp_Analyzing_Needs_status__c = DateTime.now();
        }
        else if (opp.StageName == 'Fulfillment' && oldStatus != 'Fulfillment'){
            opp.TimeStamp_Fulfillment_status__c = DateTime.now();
        }
        
        if (opp.SLA_Business_Hours__c != NULL && stdBusinessHours != NULL && opp.StageName == 'New' && opp.TimeStamp_New_status__c != null && oldStatus != 'New'){
            system.debug('in new');
            opp.SLA_Yellow_Start_Time__c = addBusinessHours(stdBusinessHours.id,opp.TimeStamp_New_status__c,(Long)(opp.SLA_Business_Hours__c-1));
            opp.SLA_Breach_Time__c = addBusinessHours(stdBusinessHours.id,opp.TimeStamp_New_status__c,(Long)opp.SLA_Business_Hours__c);
            //subtract hours already spent from the new SLA timings
            if(opp.Hour_Spent_New_Status__c != null && opp.Hour_Spent_New_Status__c != 0){
                opp.SLA_Yellow_Start_Time__c = addBusinessHours(stdBusinessHours.id,opp.SLA_Breach_Time__c,-(Long)(opp.Hour_Spent_New_Status__c));
                opp.SLA_Breach_Time__c = addBusinessHours(stdBusinessHours.id,opp.SLA_Breach_Time__c,-(Long)opp.Hour_Spent_New_Status__c);
            }
        }                      
        else if (opp.SLA_Business_Hours__c != NULL && stdBusinessHours != NULL && opp.StageName == 'Outreach' && opp.TimeStamp_Outreach_status__c != null && oldStatus != 'Outreach'){
            system.debug('in out reach');
            opp.SLA_Yellow_Start_Time__c = addBusinessHours(stdBusinessHours.id,opp.TimeStamp_Outreach_status__c,(Long)(opp.SLA_Business_Hours__c-1));
            opp.SLA_Breach_Time__c = addBusinessHours(stdBusinessHours.id,opp.TimeStamp_Outreach_status__c,(Long)opp.SLA_Business_Hours__c);

            if(opp.Hour_Spent_Outreach_Status__c != null && opp.Hour_Spent_Outreach_Status__c != 0){
                opp.SLA_Yellow_Start_Time__c = addBusinessHours(stdBusinessHours.id,opp.SLA_Yellow_Start_Time__c,-(Long)(opp.Hour_Spent_Outreach_Status__c));
                opp.SLA_Breach_Time__c = addBusinessHours(stdBusinessHours.id,opp.SLA_Breach_Time__c,-(Long)opp.Hour_Spent_Outreach_Status__c);
            }
        }
        else if(opp.Product_Type__c == 'Mortgage' && oldProductType != 'Mortgage' && opp.SLA_Business_Hours__c != NULL && stdBusinessHours != NULL && opp.StageName == 'New' && opp.TimeStamp_New_status__c != null){
            system.debug('in mortgage');
            opp.SLA_Yellow_Start_Time__c = addBusinessHours(stdBusinessHours.id,opp.TimeStamp_New_status__c,(Long)(opp.SLA_Business_Hours__c-1));
            opp.SLA_Breach_Time__c = addBusinessHours(stdBusinessHours.id,opp.TimeStamp_New_status__c,(Long)opp.SLA_Business_Hours__c);
            
            if(opp.Hour_Spent_New_Status__c != null && opp.Hour_Spent_New_Status__c != 0){
                opp.SLA_Yellow_Start_Time__c = addBusinessHours(stdBusinessHours.id,opp.SLA_Yellow_Start_Time__c,-(Long)(opp.Hour_Spent_New_Status__c ));
                opp.SLA_Breach_Time__c = addBusinessHours(stdBusinessHours.id,opp.SLA_Breach_Time__c,-(Long)opp.Hour_Spent_New_Status__c);
            }
        }
        else if(opp.Product_Type__c !=null && oldoppSource!=null && newOppSources.contains(opp.Opportunity_Source__c) && !newOppSources.contains(oldoppSource) && opp.Product_Type__c == 'Mortgage' 
                        && opp.SLA_Business_Hours__c != NULL  && stdBusinessHours != NULL  && opp.StageName == 'New' && opp.TimeStamp_New_status__c != null  ){
            system.debug('in opp sources');
            opp.SLA_Yellow_Start_Time__c = addBusinessHours(stdBusinessHours.id,opp.TimeStamp_New_status__c,(Long)(opp.SLA_Business_Hours__c-1));
            opp.SLA_Breach_Time__c = addBusinessHours(stdBusinessHours.id,opp.TimeStamp_New_status__c,(Long)opp.SLA_Business_Hours__c);
            
            if(opp.Hour_Spent_New_Status__c != null && opp.Hour_Spent_New_Status__c != 0){
                opp.SLA_Yellow_Start_Time__c = addBusinessHours(stdBusinessHours.id,opp.SLA_Yellow_Start_Time__c,-(Long)(opp.Hour_Spent_New_Status__c));
                opp.SLA_Breach_Time__c = addBusinessHours(stdBusinessHours.id,opp.SLA_Breach_Time__c,-(Long)opp.Hour_Spent_New_Status__c);
            }
        }
        else if(opp.SLA_Business_Hours__c!=null && oldSLAHours!=null ){
            system.debug('in business hours');
            if(opp.SLA_Business_Hours__c!=oldSLAHours){

                opp.SLA_Yellow_Start_Time__c = addBusinessHours(stdBusinessHours.id,currentTime,(Long)(opp.SLA_Business_Hours__c - 1));                            
                opp.SLA_Breach_Time__c = addBusinessHours(stdBusinessHours.id,currentTime,(Long)opp.SLA_Business_Hours__c);                            
            }
        }   


    }

    private datetime addBusinessHours(ID standardBusinessHourId,Datetime startDate,Long interval)
    {
        return BusinessHours.addgmt(standardBusinessHourId, startDate, (Long) ((interval) * 3600000));
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

    decimal getSLA(Opportunity opp) {
        // Routine loops through all metadata for opportunities and if a match is found, returns the SLA based on Event_Source__c,Opportunity_Source__c,Product_Type__c & StageName__c combination.
        // Definitions can include single values or lists for Event_Source__c & Opportunity_Source__c.
        // Wildcard * in Event_Source__c or Opportunity_Source__c def means it only requires opp.[field] is populated.
        Boolean opportunitySourceOK;
        Boolean productTypeOK;
        Boolean eventSourceOK;
        Boolean stageOK;
        String defEventSource;
        String defOppSource;
        String defOppProductType;
        String defStage;
        Decimal sla;
        for(Sla_Manager__mdt slaDef : slaDefList) {
          opportunitySourceOK = false;
          productTypeOK       = false;
          eventSourceOK       = false;
          stageOK             = false;
          if(slaDef.Event_Source__c == '*') { // * = something has to have been chosen, but it doesn't matter what.
            if(!String.isBlank(opp.Event_Source__c)) {
              eventSourceOK = true;
            }
          } else {
            if(String.isBlank(slaDef.Event_Source__c)) {
              eventSourceOK = true;
            } else  {
              defEventSource = slaDef.Event_Source__c;
              if(String.isNotBlank(opp.Event_Source__c) && defEventSource.contains(opp.Event_Source__c)) {
                eventSourceOK = true;
              }
            }
          }
          if(slaDef.Opportunity_Source__c == '*') { // * = something has to have been chosen, but it doesn't matter what.
            if(!String.isBlank(opp.Opportunity_Source__c)) {
              opportunitySourceOK = true;
            }
          } else {
            if(String.isBlank(slaDef.Opportunity_Source__c)) {
              opportunitySourceOK = true;
            } else  {
              defOppSource = slaDef.Opportunity_Source__c;
              if(String.isNotBlank(opp.Opportunity_Source__c) && defOppSource.contains(opp.Opportunity_Source__c)) {
                opportunitySourceOK = true;
              } 
            }
          }
          if(String.isBlank(slaDef.Product_Type__c)) {
            productTypeOK = true;
          } else {
            defOppProductType = slaDef.Product_Type__c;
            // Maybe one day, list of product will be used.  Ready for that.
            if(String.isNotBlank(opp.Product_Type__c) && defOppProductType.contains(opp.Product_Type__c)) {
              productTypeOK = true;
            }
          }
          if(String.isBlank(slaDef.StageName__c)) {
            stageOK = true;
          } else {
            defStage = slaDef.StageName__c;
            if(defStage == opp.StageName) {
              stageOK = true;
            }
          }
          if(eventSourceOK && opportunitySourceOK && productTypeOK && stageOK) {
            sla = slaDef.Sla__c;
            break;
          }
          else{
            sla = null;  
          }
        }
        return sla;
      }

    }