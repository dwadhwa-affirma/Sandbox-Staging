@SuppressWarnings('PMD.AvoidGlobalModifier')
global class Lead_Update_StatusHrs_Batch implements Database.Batchable<sObject>{
    public string query;
    @TestVisible
    global Database.QueryLocator start(Database.BatchableContext bc){
        // collect the batches of records or objects to be passed to execute

        Map<string, SLA_Status_Manager__c> leadstatus = SLA_Status_Manager__c.getAll();//get the custom setting value SLA_Status_Manager__c
        string getleadstatus = (string) leadstatus.get('Lead').Status__c;
        List<String> spltstatus = getleadstatus.split(',');

        //query = 'SELECT id,Event_Source__c,Product_Type__c,LeadSource,Status,SLA__c,SLA_New__c,SLA_Outreach__c,SLA_Considering__c,SLA_Analyzing_Needs__c, SLA_Breached_New_Status__c, SLA_Breached_Outreach_Status__c, SLA_Breached_Considering_Status__c,SLA_Breached_Analyzing_Needs_Status__c, Hour_Spent_New_Status__c,Hour_Spent_Outreach_Status__c,Hour_Spent_Considering_Status__c,Hour_Spent_Analyzing_Needs_Status__c,TimeStamp_New_status__c,TimeStamp_Outreach_status__c,TimeStamp_Considering_status__c,TimeStamp_Analyzing_Needs_status__c,Total_Lead_Business_Hours__c FROM Lead WHERE CreatedDate=LAST_N_DAYS:15 AND Status IN (\'' + string.join(spltstatus, '\',\'') + '\') AND SLA__c!=null AND SLA__c > 0 Order by CreatedDate DESC';
        query = 'SELECT id,Last_TimeStamp_Updated__c,Event_Source__c,Product_Type__c,LeadSource,Status,SLA__c,SLA_New__c,SLA_Outreach__c,SLA_Considering__c,SLA_Analyzing_Needs__c, SLA_Breached_New_Status__c, SLA_Breached_Outreach_Status__c, SLA_Breached_Considering_Status__c,SLA_Breached_Analyzing_Needs_Status__c, Hour_Spent_New_Status__c,Hour_Spent_Outreach_Status__c,Hour_Spent_Considering_Status__c,Hour_Spent_Analyzing_Needs_Status__c,TimeStamp_New_status__c,TimeStamp_Outreach_status__c,TimeStamp_Considering_status__c,TimeStamp_Analyzing_Needs_status__c,Total_Lead_Business_Hours__c FROM Lead WHERE Last_TimeStamp_Updated__c=LAST_N_DAYS:10 AND SLA__c!=null AND Status IN (\'' + string.join(spltstatus, '\',\'') + '\') Order by CreatedDate DESC';
		
        system.debug('query##'+ query); 

        return Database.getQueryLocator(query);
    }

    global void execute(Database.BatchableContext bc, List<Lead> leadList){
        set<string> leadIds = new set<string>();
        for (Lead o : leadList){
            leadIds.add(o.Id);
        }
        BusinessHours stdBusinessHours = [select id
                                          from businesshours
                                          where isDefault = true];
        String strObjectName = 'Lead';
        String strPicklistField = 'Status';
        List<String> listAllStatuses = new List<String>();
        List<String> listAllHoursSpentFieldNames = new List<String>();
        Map<String, String> mapPickListValues = new Map<String, String>();
        Schema.SObjectType objSobjectType = Schema.getGlobalDescribe().get(strObjectName);//Returns a map of  Lead object Status field  values
        Schema.DescribeSObjectResult objDescribeSobject = objSobjectType.getDescribe();
        Map<String, Schema.SObjectField> mapFields = objDescribeSobject.fields.getMap();
        List<Schema.PicklistEntry> lstPickListValues = mapFields.get(strPicklistField).getDescribe().getPickListValues();
        for (Schema.PicklistEntry objPickList : lstPickListValues){
            string val = objPickList.getValue();
            if (!val.contains('Closed') && !val.contains('Client/SEG') && !val.contains('Prospecting')){
                ListAllStatuses.add(val);
                ListAllHoursSpentFieldNames.add('Hour_Spent_' + val.replace(' ', ('_')) + '_Status__c');
            }
        }
        List<lead> lstLeadToUpdate=new List<lead>();
        //For updating the Hour spent field dynamically //
        for (lead l : LeadList){

            string currentstatus = l.Status;
            string hoursSpentFieldName = 'Hour_Spent_' + currentstatus.replace(' ', ('_')) + '_Status__c';
            string statusTimeStampFieldName = 'TimeStamp_' + currentstatus.replace(' ', ('_')) + '_status__c';
            string slaBreachedFieldName = 'SLA_Breached_'  + currentstatus.replace(' ', ('_')) + '_Status__c';
            String slaDurationFieldName = 'SLA_' + currentstatus.replace(' ', ('_')) + '__c';
            decimal timeDiff;
            decimal timespent;
            decimal finalresult;
            decimal slaDuration;

            List<String> listHoursSpentFieldNames = new List<String>();
            listHoursSpentFieldNames = ListAllHoursSpentFieldNames;
            Integer i = listHoursSpentFieldNames.size()-1;

            DateTime timeStampFieldValue = l.Last_TimeStamp_Updated__c;
            if ((timeStampFieldValue != null)){
                boolean isHoursFieldsNotNull = false;
                DateTime valueforDifference;
                
                //read from Last timestamp Updated field instead of history object
                valueforDifference = timeStampFieldValue;   
                
                for (string s : ListHoursSpentFieldNames){
                    if ((l.get(s) != null)){
                        isHoursFieldsNotNull = true;
                        break;
                    }
                }

                if (isHoursFieldsNotNull == false){
                    timespent = getTimeDifference(timeStampFieldValue, stdBusinessHours);
                    finalresult = timespent;
                    
                    l.put(hoursSpentFieldName, finalresult);
                    l.put('Last_TimeStamp_Updated__c',DateTime.now());
                    if((l.get(slaDurationFieldName) != null)) {
                        slaDuration = (decimal) l.get(slaDurationFieldName);
                        if(sladuration > 0 && (finalresult > slaDuration)){
                            l.put(slaBreachedFieldName, true);
                        }else{
                            l.put(slaBreachedFieldName, false);
                        }
                    }

                    lstLeadToUpdate.add(l);
                     

                } else{
                    system.debug('ValueforDifference##'+ ValueforDifference);
                    timespent = getTimeDifference(ValueforDifference, stdBusinessHours);
                    finalresult = l.get(hoursSpentFieldName) != null ? (decimal) l.get(hoursSpentFieldName) + timespent : timespent;

                    system.debug('finalresult'+ finalresult);
                    l.put(hoursSpentFieldName, finalresult);
                    l.put('Last_TimeStamp_Updated__c',DateTime.now());
                    if((l.get(slaDurationFieldName) != null)) {
                        slaDuration = (decimal) l.get(slaDurationFieldName);
                        if(slaDuration > 0 && (finalresult > slaDuration)){
                            l.put(slaBreachedFieldName, true);
                        }else{
                            l.put(slaBreachedFieldName, false);
                        }
                        
                    }

                    lstLeadToUpdate.add(l);
                }
            }
        }

        update lstLeadToUpdate;
    }

    global void finish(Database.BatchableContext bc){
       
        // execute any post-processing operations
        system.debug('Finish');
    }

    //function to get the Timedifference for Hour spent field//
    private decimal getTimeDifference(datetime startTime, BusinessHours stdBusinessHours){
        decimal timespent;
        decimal timeDifference;

        DateTime currentTime = Datetime.now();

        timeDifference = BusinessHours.diff(stdBusinessHours.id, startTime, currentTime);
        timespent = (timeDifference / 3600000).setScale(2);

        return timespent;
    }
}