@SuppressWarnings('PMD.AvoidGlobalModifier')global class Opportunity_Update_StatusHrs_Batch implements Database.Batchable<sObject>{
    public string query;
    global Database.QueryLocator start(Database.BatchableContext bc){
        // collect the batches of records or objects to be passed to execute
        Map<string, SLA_Status_Manager__c> objStatus = SLA_Status_Manager__c.getAll();//get the custom setting value SLA_Status_Manager__c
        string getOppStatus = (string) objStatus.get('Opportunity').Status__c;
        List<String> spltstatus = getOppStatus.split(',');
        //query = 'SELECT id,Last_TimeStamp_Updated__c,SLA_Business_Hours__c,StageName, SLA_Breached_New_Status__c, SLA_Breached_Outreach_Status__c,SLA_Breached_Considering_Status__c, SLA_Breached_Analyzing_Needs_Status__c,SLA_Breached_Fulfillment_Status__c, SLA_New__c, SLA_Outreach__c, SLA_Considering__c, SLA_Analyzing_Needs__c,SLA_Fulfillment__c, Hour_Spent_New_Status__c,Hour_Spent_Outreach_Status__c,Hour_Spent_Considering_Status__c,Hour_Spent_Analyzing_Needs_Status__c,Hour_Spent_Fulfillment_Status__c,TimeStamp_New_status__c,TimeStamp_Outreach_status__c,TimeStamp_Considering_status__c,TimeStamp_Analyzing_Needs_status__c,TimeStamp_Fulfillment_status__c,Product_Type__c,Total_Opportunity_Business_Hours__c FROM Opportunity WHERE CreatedDate = LAST_N_DAYS:15 AND StageName IN (\'' + string.join(spltstatus, '\',\'') + '\') AND SLA_Business_Hours__c !=null and SLA_Business_Hours__c > 0 Order by CreatedDate DESC' ;
        query = 'SELECT id,Last_TimeStamp_Updated__c,SLA_Business_Hours__c,StageName, SLA_Breached_New_Status__c, SLA_Breached_Outreach_Status__c,SLA_Breached_Considering_Status__c, SLA_Breached_Analyzing_Needs_Status__c,SLA_Breached_Fulfillment_Status__c, SLA_New__c, SLA_Outreach__c, SLA_Considering__c, SLA_Analyzing_Needs__c,SLA_Fulfillment__c, Hour_Spent_New_Status__c,Hour_Spent_Outreach_Status__c,Hour_Spent_Considering_Status__c,Hour_Spent_Analyzing_Needs_Status__c,Hour_Spent_Fulfillment_Status__c,TimeStamp_New_status__c,TimeStamp_Outreach_status__c,TimeStamp_Considering_status__c,TimeStamp_Analyzing_Needs_status__c,TimeStamp_Fulfillment_status__c,Product_Type__c,Total_Opportunity_Business_Hours__c FROM Opportunity WHERE StageName IN (\'New\',\'Outreach\',\'Analyzing Needs\',\'Considering\',\'Fulfillment\') AND Last_TimeStamp_Updated__c = LAST_N_DAYS:10 AND SLA_Business_Hours__c !=null Order by CreatedDate DESC' ;
        system.debug('query##'+ query);    
        return Database.getQueryLocator(query);
    }

    global void execute(Database.BatchableContext bc, List<Opportunity> oppList){

        set<string> opportunityIds = new set<string>();
        for (Opportunity o : oppList){
            opportunityIds.add(o.Id);
        }
        BusinessHours stdBusinessHours = [select id
                                          from businesshours
                                          where isDefault = true];
        String strObjectName = 'Opportunity';
        String strPicklistField = 'StageName';
        List<String> listallstatuses = new List<String>();
        List<String> listAllHoursSpentFieldNames = new List<String>();
        Map<String, String> mapPickListValues = new Map<String, String>();
        Schema.SObjectType objSobjectType = Schema.getGlobalDescribe().get(strObjectName);//Returns a map of  Opportunity object Stagename field  values
        Schema.DescribeSObjectResult objDescribeSobject = objSobjectType.getDescribe();
        Map<String, Schema.SObjectField> mapFields = objDescribeSobject.fields.getMap();
        List<Schema.PicklistEntry> lstPickListValues = mapFields.get(strPicklistField).getDescribe().getPickListValues();

        for (Schema.PicklistEntry objPickList : lstPickListValues){
            string val = objPickList.getValue();
            if (!val.contains('Closed')){
                listallstatuses.add(val);
                listAllHoursSpentFieldNames.add('Hour_Spent_' + val.replace(' ', ('_')) + '_Status__c');
            }
        }

     
        List<Opportunity> lstOppToUpdate=new List<Opportunity>();
        //For updating the Hour spent field dynamically //
        for (Opportunity oppL : oppList){
            id oppid = oppL.id;
            string currentstatus = oppL.StageName;
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
            system.debug('size begin---' + ListAllHoursSpentFieldNames.size());
            Integer i = listHoursSpentFieldNames.size()-1;
            system.debug(listHoursSpentFieldNames);
            system.debug(HoursSpentFieldName);
            

            DateTime timeStampFieldValue = OppL.Last_TimeStamp_Updated__c;  //getTimeStampFieldValue(status,opp);
            if (timeStampFieldValue != null){
                boolean isHoursFieldsNotNull = false;
                
                DateTime valueforDifference;
                
                valueforDifference = timeStampFieldValue;
                for (string s : ListHoursSpentFieldNames){
                    if ((OppL.get(s) != null)){
                        isHoursFieldsNotNull = true;
                        break;
                    }
                }
                

                if (isHoursFieldsNotNull == false){
                    timespent = getTimeDifference(timeStampFieldValue, stdBusinessHours);
                    finalresult = timespent;
                        
                        OppL.put(HoursSpentFieldName, finalresult);
                        OppL.put('Last_TimeStamp_Updated__c',DateTime.now());
                        if((OppL.get(slaDurationFieldName) != null)) {
                            slaDuration = (decimal) OppL.get(slaDurationFieldName);
                            if(slaDuration > 0 && (finalresult > slaDuration)){
                                OppL.put(slaBreachedFieldName, true);
                            }else{
                                OppL.put(slaBreachedFieldName, false);
                            }
                        }
                        lstOppToUpdate.add(OppL);

                } else{
                    timespent = getTimeDifference(valueforDifference, stdBusinessHours);
                    system.debug(valueforDifference);
                    system.debug('TimeSpent####' + timespent);
                    system.debug('HoursSpent###' + OppL.get(HoursSpentFieldName));
                    finalresult = OppL.get(HoursSpentFieldName) != null ? (decimal) OppL.get(HoursSpentFieldName) + timespent : timespent;
                    system.debug('Final Result' + finalresult);
                    system.debug('HoursSpentFieldName#'+ HoursSpentFieldName);
                    OppL.put(HoursSpentFieldName, finalresult);
                    OppL.put('Last_TimeStamp_Updated__c',DateTime.now());
                    system.debug('slaDurationFieldName#' + slaDurationFieldName);
                    system.debug('slaDuration#'+ OppL.get(slaDurationFieldName));
                    if((OppL.get(slaDurationFieldName) != null)) {
                        slaDuration = (decimal) OppL.get(slaDurationFieldName);
                        if(slaDuration > 0 && finalresult > slaDuration){
                            OppL.put(slaBreachedFieldName, true);
                        }else{
                            OppL.put(slaBreachedFieldName, false);
                        }
                    }
                    
                    lstOppToUpdate.add(OppL);
                }
            }
        }
        
        update lstOppToUpdate;
    }

    global void finish(Database.BatchableContext bc){
        // execute any post-processing operations
        system.debug('Finish');
    }

    //function to get the Timedifference for Hour spent field//
    private decimal getTimeDifference(datetime startTime,  BusinessHours  stdBusinessHours){
        decimal timespent;
        decimal timeDifference;

       /* BusinessHours stdBusinessHours = [select id
                                          from businesshours
                                          where isDefault = true];*/
        DateTime currentTime = Datetime.now();

        timeDifference = BusinessHours.diff(stdBusinessHours.id, startTime, currentTime);
        timespent = (timeDifference / 3600000).setScale(2);

        return timespent;
    }

}