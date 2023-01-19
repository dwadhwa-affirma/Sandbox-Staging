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
            system.debug('in...before update');
            Map<string, Opportunity> mapOldOpportunity = new Map<string, Opportunity>();
            for (Opportunity ol : oldOpportunityList){
                mapOldOpportunity.put(ol.Id, ol);
            }
        
            for (Opportunity opp : newOppList){
                Opportunity oldOpportunity = mapOldOpportunity.get(opp.Id);
                string oldStatus = oldOpportunity.StageName;
                string newStatus = opp.Stagename;
                opp.SLA_Business_Hours__c = getSLA(opp, newStatus);

                set<ID> ids = getNewOppIds(newOppList);
                
                updateSLAFieldsForUpdate(opp, oldOpportunity, stdBusinessHours);
                
                //update hours spent for all statuses - the logic will update in only one instance below
                //based on the current status of the opportunity
                // If null, this record does not need time fields updated.
                if(opp.Last_TimeStamp_Updated__c != null) {
                  if (oldStatus == 'New') {
                    updateHoursSpent('New', oldStatus, opp);
                  }
                  if (oldStatus == 'Outreach') {
                    updateHoursSpent('Outreach', oldStatus, opp);
                  }
                  if (oldStatus == 'Considering') {
                    updateHoursSpent('Considering', oldStatus, opp);
                  }
                  if (oldStatus == 'Analyzing Needs') {
                    updateHoursSpent('Analyzing Needs', oldStatus, opp);
                  }
                  if (oldStatus == 'Fulfillment') {
                    updateHoursSpent('Fulfillment', oldStatus, opp);
                  }
              }
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

    private void updateHoursSpent(String status,string oldStatus, Opportunity opp)
    {
        decimal hoursSpent;
       
        if (opp.StageName != status && oldStatus == status && getTimeStampFieldValue(status,opp) != null){
            
            DateTime valueforDifference;
            //get last timestamp from last_timestamp_updated__c instead of the history object
            DateTime timeStampFieldValue = opp.Last_TimeStamp_Updated__c;  //getTimeStampFieldValue(status,opp);
            
            valueforDifference = timeStampFieldValue;

            if(getOtherFieldsAreNull(status,opp) )
            {
                hoursSpent =  getTimeDifference(timeStampFieldValue);
                updateTimeStampOnOpp(status,opp,hoursSpent,false);
            }
            else{
                hoursSpent = getTimeDifference(valueforDifference);
                updateTimeStampOnOpp(status,opp,hoursSpent,true);
            }
        }
    }
    
@testvisible
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
                opp.Last_TimeStamp_Updated__c = DateTime.now();
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
                opp.Last_TimeStamp_Updated__c = DateTime.now();
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
                opp.Last_TimeStamp_Updated__c = DateTime.now();
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
                opp.Last_TimeStamp_Updated__c = DateTime.now();
            }
            when 'Fulfillment'
            {
                if (addPreviousValue)
                {
                    opp.Hour_Spent_Fulfillment_Status__c = opp.Hour_Spent_Fulfillment_Status__c != null ? opp.Hour_Spent_Fulfillment_Status__c + hoursSpent : hoursSpent;
                }
                else
                {
                    opp.Hour_Spent_Fulfillment_Status__c = hoursSpent;
                }
                opp.Last_TimeStamp_Updated__c = DateTime.now();
            }
        }
    }
@testvisible
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
            when 'Fulfillment'
            {
                return opp.Hour_Spent_New_Status__c == null && opp.Hour_Spent_Considering_Status__c == null && opp.Hour_Spent_Outreach_Status__c == null && opp.Hour_Spent_Analyzing_Needs_Status__c == null; 
            }
        }
        return null;

    }
@testvisible
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
            when 'Fulfillment'
            {
                return opp.TimeStamp_Fulfillment_status__c;    
            }
        }
        return null;
    }


    private void updateSLAFieldsForInsert(Opportunity opp,BusinessHours stdBusinessHours)
    {
        string status = opp.StageName;
        decimal sla = getSLA(opp, status);
        opp.SLA_Business_Hours__c = sla;
        /*--------Update TimeStamp Fields------*/
        if (status == 'New'){
            if(sla > 0){
            	opp.TimeStamp_New_status__c = DateTime.now();
            	opp.SLA_New__c = sla;
            	opp.Hour_Spent_New_Status__c = 0;
                opp.Last_TimeStamp_Updated__c = DateTime.now();
            }else{
                opp.TimeStamp_New_status__c = null;
            	opp.SLA_New__c = null;
            	opp.Hour_Spent_New_Status__c = null;
            }
        } else if (status == 'Outreach'){
            if(sla > 0){
            	opp.TimeStamp_Outreach_status__c = DateTime.now();
            	opp.SLA_Outreach__c = sla;
            	opp.Hour_Spent_Outreach_Status__c = 0;
                opp.Last_TimeStamp_Updated__c = DateTime.now();
            }else{
                opp.TimeStamp_Outreach_status__c = null;
            	opp.SLA_Outreach__c = null;
            	opp.Hour_Spent_Outreach_Status__c = null;
            }
        }
        else if (status == 'Considering'){
            if(sla > 0){
            	opp.TimeStamp_Considering_status__c = DateTime.now();
            	opp.SLA_Considering__c = sla;
            	opp.Hour_Spent_Considering_Status__c = 0;
                opp.Last_TimeStamp_Updated__c = DateTime.now();
            }else{
                opp.TimeStamp_Considering_status__c = null;
            	opp.SLA_Considering__c = null;
            	opp.Hour_Spent_Considering_Status__c = null;
            }
        } 
        else if (status == 'Analyzing Needs'){
            if(sla > 0){
            	opp.TimeStamp_Analyzing_Needs_status__c = DateTime.now();
            	opp.SLA_Analyzing_Needs__c = sla;
            	opp.Hour_Spent_Analyzing_Needs_Status__c = 0;
                opp.Last_TimeStamp_Updated__c = DateTime.now();
            }else{
                opp.TimeStamp_Analyzing_Needs_status__c = null;
            	opp.SLA_Analyzing_Needs__c = null;
            	opp.Hour_Spent_Analyzing_Needs_Status__c = null;
            }
        }
        else if (status == 'Fulfillment'){
            if(sla> 0){
                opp.TimeStamp_Fulfillment_status__c = DateTime.now();
            	opp.SLA_Fulfillment__c = sla;
            	opp.Hour_Spent_Fulfillment_Status__c = 0;
                opp.Last_TimeStamp_Updated__c = DateTime.now();
            }else{
                opp.TimeStamp_Fulfillment_status__c = null;
            	opp.SLA_Fulfillment__c = null;
            	opp.Hour_Spent_Fulfillment_Status__c = null;
            }
        }
        /*----------Update Yellow and Breach TimeStamp Fields--------*/
        if (sla > 0)
        {
            if (opp.SLA_Business_Hours__c != NULL && stdBusinessHours != NULL && status == 'New' && opp.TimeStamp_New_status__c != null){

                opp.Yellow_Start_Time_New_Status__c = addBusinessHours(stdBusinessHours.id, opp.TimeStamp_New_status__c, (decimal)(opp.SLA_Business_Hours__c -1) );            
                opp.SLA_Start_Time_New_Status__c = addBusinessHours(stdBusinessHours.id, opp.TimeStamp_New_status__c, (decimal)opp.SLA_Business_Hours__c );

            }else if (opp.SLA_Business_Hours__c != NULL && stdBusinessHours != NULL && status == 'Outreach' && opp.TimeStamp_Outreach_status__c != null){

                opp.Yellow_Start_Time_Outreach_Status__c = addBusinessHours(stdBusinessHours.id, opp.TimeStamp_Outreach_status__c, (decimal)(opp.SLA_Business_Hours__c - 1) );           
                opp.SLA_Start_Time_Outreach_Status__c = addBusinessHours(stdBusinessHours.id, opp.TimeStamp_Outreach_status__c, (decimal)opp.SLA_Business_Hours__c );

            }else if (opp.SLA_Business_Hours__c != NULL && stdBusinessHours != NULL && status == 'Considering' && opp.TimeStamp_Considering_status__c != null){

                opp.Yellow_Start_Time_Considering_Status__c = addBusinessHours(stdBusinessHours.id, opp.TimeStamp_Considering_status__c, (decimal)(opp.SLA_Business_Hours__c - 1) );           
            opp.SLA_Start_Time_Considering_Status__c = addBusinessHours(stdBusinessHours.id, opp.TimeStamp_Considering_status__c, (decimal)opp.SLA_Business_Hours__c );

            } else if (opp.SLA_Business_Hours__c != NULL && stdBusinessHours != NULL && status == 'Analyzing Needs' && opp.TimeStamp_Analyzing_Needs_status__c != null){

                opp.Yellow_Start_Time_Analyzing_Needs_Status__c = addBusinessHours(stdBusinessHours.id, opp.TimeStamp_Analyzing_Needs_status__c, (decimal)(opp.SLA_Business_Hours__c - 1) );           
                opp.SLA_Start_Time_Analyzing_Needs_Status__c = addBusinessHours(stdBusinessHours.id, opp.TimeStamp_Analyzing_Needs_status__c, (decimal)opp.SLA_Business_Hours__c );

            }else if (opp.SLA_Business_Hours__c != NULL && stdBusinessHours != NULL && status == 'Fulfillment' && opp.TimeStamp_Fulfillment_status__c != null){

                opp.Yellow_Start_Time_Fulfillment_Status__c = addBusinessHours(stdBusinessHours.id, opp.TimeStamp_Fulfillment_status__c, (decimal)(opp.SLA_Business_Hours__c - 1) );            
                opp.SLA_Start_Time_Fulfillment_Status__c = addBusinessHours(stdBusinessHours.id, opp.TimeStamp_Fulfillment_status__c, (decimal)opp.SLA_Business_Hours__c );
            }
        }
        else{
           
            opp.Yellow_Start_Time_New_Status__c = null;
            opp.Yellow_Start_Time_Outreach_Status__c = null;
            opp.Yellow_Start_Time_Considering_Status__c = null;
            opp.Yellow_Start_Time_Analyzing_Needs_Status__c = null;
            opp.Yellow_Start_Time_Fulfillment_Status__c = null;
            opp.SLA_Start_Time_New_Status__c = null;
            opp.SLA_Start_Time_Outreach_Status__c = null;
            opp.SLA_Start_Time_Considering_Status__c = null;
            opp.SLA_Start_Time_Analyzing_Needs_Status__c = null;
            opp.SLA_Start_Time_Fulfillment_Status__c = null;
            
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
        decimal sla = getSLA(opp, status);
        system.debug('SLA##' + sla);
        
        system.debug('in...timestamp update method');

        if (opp.StageName == 'New' && oldStatus != 'New'){
            system.debug('in...timestamp update');
            opp.TimeStamp_New_status__c = DateTime.now();
            opp.SLA_New__c = sla;
        } else if (opp.StageName == 'Outreach' && oldStatus != 'Outreach'){
            system.debug('in...timestamp update');
            opp.TimeStamp_Outreach_status__c = DateTime.now();
            opp.SLA_Outreach__c = sla;
        }
        else if (opp.StageName == 'Considering' && oldStatus != 'Considering'){
            system.debug('in...timestamp update');
            opp.TimeStamp_Considering_status__c = DateTime.now();
            opp.SLA_Considering__c = sla;
        } 
        else if (opp.StageName == 'Analyzing Needs' && oldStatus != 'Analyzing Needs'){
            system.debug('in...timestamp update');
            opp.TimeStamp_Analyzing_Needs_status__c = DateTime.now();
           opp.SLA_Analyzing_Needs__c = sla;
        }
        else if (opp.StageName == 'Fulfillment' && oldStatus != 'Fulfillment'){
            system.debug('in...timestamp update');
            opp.TimeStamp_Fulfillment_status__c = DateTime.now();
            opp.SLA_Fulfillment__c = sla;
        }
        if (sla > 0)
        {
            if (opp.SLA_Business_Hours__c != NULL && stdBusinessHours != NULL && opp.StageName == 'New' && opp.TimeStamp_New_status__c != null && oldStatus != 'New'){
                system.debug('in new');
                opp.Yellow_Start_Time_New_Status__c = addBusinessHours(stdBusinessHours.id,opp.TimeStamp_New_status__c,(decimal)(opp.SLA_Business_Hours__c-1));
                opp.SLA_Start_Time_New_Status__c = addBusinessHours(stdBusinessHours.id,opp.TimeStamp_New_status__c,(decimal)opp.SLA_Business_Hours__c);
                //subtract hours already spent from the new SLA timings
                if(opp.Hour_Spent_New_Status__c != null && opp.Hour_Spent_New_Status__c != 0){
                    opp.Yellow_Start_Time_New_Status__c = addBusinessHours(stdBusinessHours.id,opp.Yellow_Start_Time_New_Status__c,-(decimal)(opp.Hour_Spent_New_Status__c));
                    opp.SLA_Start_Time_New_Status__c = addBusinessHours(stdBusinessHours.id,opp.SLA_Start_Time_New_Status__c,-(decimal)opp.Hour_Spent_New_Status__c);
                }
            }                      
            else if (opp.SLA_Business_Hours__c != NULL && stdBusinessHours != NULL && opp.StageName == 'Outreach' && opp.TimeStamp_Outreach_status__c != null && oldStatus != 'Outreach'){
                system.debug('in outreach');
                opp.Yellow_Start_Time_Outreach_Status__c = addBusinessHours(stdBusinessHours.id,opp.TimeStamp_Outreach_status__c,(decimal)(opp.SLA_Business_Hours__c-1));
                opp.SLA_Start_Time_Outreach_Status__c = addBusinessHours(stdBusinessHours.id,opp.TimeStamp_Outreach_status__c,(decimal)opp.SLA_Business_Hours__c);

                if(opp.Hour_Spent_Outreach_Status__c != null && opp.Hour_Spent_Outreach_Status__c != 0){
                    opp.Yellow_Start_Time_Outreach_Status__c = addBusinessHours(stdBusinessHours.id,opp.Yellow_Start_Time_Outreach_Status__c,-(decimal)(opp.Hour_Spent_Outreach_Status__c));
                    opp.SLA_Start_Time_Outreach_Status__c = addBusinessHours(stdBusinessHours.id,opp.SLA_Start_Time_Outreach_Status__c,-(decimal)opp.Hour_Spent_Outreach_Status__c);
                }
            }else if (opp.SLA_Business_Hours__c != NULL && stdBusinessHours != NULL && opp.StageName == 'Considering' && opp.TimeStamp_Considering_status__c != null && oldStatus != 'Considering'){
                system.debug('in Considering');
                opp.Yellow_Start_Time_Considering_Status__c = addBusinessHours(stdBusinessHours.id,opp.TimeStamp_Considering_status__c,(decimal)(opp.SLA_Business_Hours__c-1));
                opp.SLA_Start_Time_Considering_Status__c = addBusinessHours(stdBusinessHours.id,opp.TimeStamp_Considering_status__c,(decimal)opp.SLA_Business_Hours__c);

            if(opp.Hour_Spent_Considering_Status__c != null && opp.Hour_Spent_Considering_Status__c != 0){
                    opp.Yellow_Start_Time_Considering_Status__c = addBusinessHours(stdBusinessHours.id,opp.Yellow_Start_Time_Considering_Status__c,-(decimal)(opp.Hour_Spent_Considering_Status__c));
                    opp.SLA_Start_Time_Considering_Status__c = addBusinessHours(stdBusinessHours.id,opp.SLA_Start_Time_Considering_Status__c,-(decimal)opp.Hour_Spent_Considering_Status__c);
                }
            }else if (opp.SLA_Business_Hours__c != NULL && stdBusinessHours != NULL && opp.StageName == 'Analyzing Needs' && opp.TimeStamp_Analyzing_Needs_status__c != null && oldStatus != 'Analyzing Needs'){
                system.debug('in Analyzing Needs');
                opp.Yellow_Start_Time_Analyzing_Needs_Status__c = addBusinessHours(stdBusinessHours.id,opp.TimeStamp_Analyzing_Needs_status__c,(decimal)(opp.SLA_Business_Hours__c-1));
                opp.SLA_Start_Time_Analyzing_Needs_Status__c = addBusinessHours(stdBusinessHours.id,opp.TimeStamp_Analyzing_Needs_status__c,(decimal)opp.SLA_Business_Hours__c);

                if(opp.Hour_Spent_Analyzing_Needs_Status__c != null && opp.Hour_Spent_Analyzing_Needs_Status__c != 0){
                    opp.Yellow_Start_Time_Analyzing_Needs_Status__c = addBusinessHours(stdBusinessHours.id,opp.Yellow_Start_Time_Analyzing_Needs_Status__c,-(decimal)(opp.Hour_Spent_Analyzing_Needs_Status__c));
                    opp.SLA_Start_Time_Analyzing_Needs_Status__c = addBusinessHours(stdBusinessHours.id,opp.SLA_Start_Time_Analyzing_Needs_Status__c,-(decimal)opp.Hour_Spent_Analyzing_Needs_Status__c);
                }
            }else if (opp.SLA_Business_Hours__c != NULL && stdBusinessHours != NULL && opp.StageName == 'Fulfillment' && opp.TimeStamp_Fulfillment_status__c != null && oldStatus != 'Fulfillment'){
                system.debug('in Fulfillment');
                opp.Yellow_Start_Time_Fulfillment_Status__c = addBusinessHours(stdBusinessHours.id,opp.TimeStamp_Fulfillment_status__c,(decimal)(opp.SLA_Business_Hours__c-1));
                opp.SLA_Start_Time_Fulfillment_Status__c = addBusinessHours(stdBusinessHours.id,opp.TimeStamp_Fulfillment_status__c,(decimal)opp.SLA_Business_Hours__c);
        } 
      
    }
}

    private datetime addBusinessHours(ID standardBusinessHourId,Datetime startDate,decimal interval)
    {
        return BusinessHours.addgmt(standardBusinessHourId, startDate, (Long) ((interval) * 3600000));
    }

  @testvisible  
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
    
    public decimal getSLA(Opportunity opp, string oppstatus) {
        // Routine loops through all metadata for opportunities and if a match is found, returns the SLA based on Event_Source__c,Opportunity_Source__c,Product_Type__c & StageName__c combination.
        // Definitions can include single values or lists for Event_Source__c & Opportunity_Source__c.
        // Wildcard * in Event_Source__c or Opportunity_Source__c def means it only requires opp.[field] is populated.

        Map<String, Sla_Manager__mdt> slaManagerMap = Sla_Manager__mdt.getAll();
        for(string key: slaManagerMap.keySet()){
            String eventSource = opp.Event_Source__c;
            String productType = opp.Product_Type__c;
            String oppSource = opp.Opportunity_Source__c;
            String status = oppstatus;

            if(slaManagerMap.get(key).Object_Name__c == 'Opportunity' && slaManagerMap.get(key).Event_Source__c == '*'){
                eventSource = '*';

            }
            if(slaManagerMap.get(key).Object_Name__c == 'Opportunity' && slaManagerMap.get(key).Product_Type__c == '*'){
                productType = '*';
                
            }
            if(slaManagerMap.get(key).Object_Name__c == 'Opportunity' && slaManagerMap.get(key).Opportunity_Source__c == '*'){
                oppSource = '*';
                
            }
            if(slaManagerMap.get(key).Object_Name__c == 'Opportunity' && slaManagerMap.get(key).StageName__c == '*'){
                status = '*';
                
            }
            if((eventSource != null && slaManagerMap.get(key).Event_Source__c != null && slaManagerMap.get(key).Event_Source__c.toLowerCase().contains(eventSource)) && (productType != null && slaManagerMap.get(key).Product_Type__c == productType) && (oppSource != null && slaManagerMap.get(key).Opportunity_Source__c != null && slaManagerMap.get(key).Opportunity_Source__c.toLowerCase().contains(oppSource.toLowerCase())) && slaManagerMap.get(key).StageName__c == status ){
                return (decimal)slaManagerMap.get(key).SLA__c;
            }
        }
        
        return 0.0;
      }
    }