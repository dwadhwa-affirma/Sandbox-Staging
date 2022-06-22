@SuppressWarnings('PMD.AvoidGlobalModifier')
global class Lead_Update_StatusHrs_Batch implements Database.Batchable<sObject>{
    public string query;
    @TestVisible
    global Database.QueryLocator start(Database.BatchableContext bc){
        // collect the batches of records or objects to be passed to execute

        Map<string, SLA_Status_Manager__c> leadstatus = SLA_Status_Manager__c.getAll();//get the custom setting value SLA_Status_Manager__c
        string getleadstatus = (string) leadstatus.get('Lead').Status__c;
        List<String> spltstatus = getleadstatus.split(',');

        query = 'SELECT id,Status,SLA__c,Hour_Spent_New_Status__c,Hour_Spent_Outreach_Status__c,Hour_Spent_Considering_Status__c,Hour_Spent_Analyzing_Needs_Status__c,TimeStamp_New_status__c,TimeStamp_Outreach_status__c,TimeStamp_Considering_status__c,TimeStamp_Analyzing_Needs_status__c FROM Lead WHERE   Status IN (\'' + string.join(spltstatus, '\',\'') + '\') AND SLA__c!=null Order by CreatedDate DESC LIMIT 20';


        return Database.getQueryLocator(query);
    }

    global void execute(Database.BatchableContext bc, List<Lead> leadList){
        set<string> leadIds = new set<string>();
        for (Lead o : leadList){
            leadIds.add(o.Id);
        }

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
        List<LeadHistory> hrsHistory = new list<LeadHistory>();
        hrsHistory = [Select Id, LeadId, CreatedById, CreatedDate, Field, NewValue, OldValue
                      from LeadHistory
                      where (field = 'Hour_Spent_Outreach_Status__c' or field = 'Hour_Spent_New_Status__c' or field = 'Hour_Spent_Analyzing_Needs_Status__c' or field = 'Hour_Spent_Considering_Status__c') and LeadId IN:leadIds
                      Order by CreatedDate DESC];

        //For updating the Hour spent field dynamically //
        for (lead l : LeadList){

            string currentstatus = l.Status;
            string hoursSpentFieldName = 'Hour_Spent_' + currentstatus.replace(' ', ('_')) + '_Status__c';
            string statusTimeStampFieldName = 'TimeStamp_' + currentstatus.replace(' ', ('_')) + '_status__c';
            decimal timeDiff;
            decimal timespent;
            decimal finalresult;
           

            List<String> listHoursSpentFieldNames = new List<String>();
            listHoursSpentFieldNames = ListAllHoursSpentFieldNames;
            Integer i = listHoursSpentFieldNames.size()-1;
            while (i >= 0 ){
                if (listHoursSpentFieldNames.get(i).contains(HoursSpentFieldName)){
                    listHoursSpentFieldNames.remove(i);
                } else{
                    i--;
                }
            }

            if ((l.get(statusTimeStampFieldName) != null)){
                boolean isHoursFieldsNotNull = false;
                Datetime hrsHistoryT;

                LeadHistory tempobj = findHistoryObject(l.id, hoursSpentFieldName, hrsHistory);
                DateTime valueforDifference;
                if (tempobj != null){
                    hrsHistoryT = tempobj.CreatedDate;
                    if (hrsHistoryT > (datetime) (l.get(statusTimeStampFieldName))){
                        valueforDifference = hrsHistoryT;
                    } else{
                        valueforDifference = (datetime) (l.get(statusTimeStampFieldName));
                    }
                } else{
                    valueforDifference = (datetime) (l.get(statusTimeStampFieldName));
                }


                for (string s : ListHoursSpentFieldNames){
                    if ((l.get(s) != null)){
                        isHoursFieldsNotNull = true;
                        break;
                    }
                }
                if (isHoursFieldsNotNull == false){
                    timespent = getTimeDifference((datetime) (l.get(statusTimeStampFieldName)));
                    finalresult = timespent;
                    l.put(hoursSpentFieldName, finalresult);

                } else{
                    timespent = getTimeDifference(ValueforDifference);
                    finalresult = l.get(hoursSpentFieldName) != null ? (decimal) l.get(hoursSpentFieldName) + timespent : timespent;
                    l.put(hoursSpentFieldName, finalresult);

                }
            }


        }
        update leadList;
    }

    global void finish(Database.BatchableContext bc){
       
        // execute any post-processing operations
        system.debug('Finish');
    }

    //function to get the Timedifference for Hour spent field//
    private decimal getTimeDifference(datetime startTime){
        decimal timespent;
        decimal timeDifference;

        BusinessHours stdBusinessHours = [select id
                                          from businesshours
                                          where isDefault = true];
        DateTime currentTime = Datetime.now();

        timeDifference = BusinessHours.diff(stdBusinessHours.id, startTime, currentTime);
        timespent = (timeDifference / 3600000).setScale(2);

        return timespent;
    }

    private LeadHistory findHistoryObject(id leadId, string fieldName, List<LeadHistory> hrsHistory){
        LeadHistory leadhistory = new LeadHistory();
        for (LeadHistory fldHistory : hrsHistory){
            if (fldHistory.LeadId == leadId && fldHistory.Field.toLowerCase() == fieldName.toLowerCase()){
                leadhistory = fldHistory;
                break;
            }
        }
        return leadhistory;
    }

}