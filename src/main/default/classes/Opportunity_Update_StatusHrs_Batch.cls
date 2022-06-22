@SuppressWarnings('PMD.AvoidGlobalModifier')global class Opportunity_Update_StatusHrs_Batch implements Database.Batchable<sObject>{
    public string query;
    global Database.QueryLocator start(Database.BatchableContext bc){
        // collect the batches of records or objects to be passed to execute
        Map<string, SLA_Status_Manager__c> leadstatus = SLA_Status_Manager__c.getAll();//get the custom setting value SLA_Status_Manager__c
        string getOppStatus = (string) leadstatus.get('Opportunity').Status__c;
        List<String> spltstatus = getOppStatus.split(',');
        query = 'SELECT id,SLA_Business_Hours__c,StageName,Hour_Spent_New_Status__c,Hour_Spent_Outreach_Status__c,Hour_Spent_Considering_Status__c,Hour_Spent_Analyzing_Needs_Status__c,Hour_Spent_Fulfillment_Status__c,TimeStamp_New_status__c,TimeStamp_Outreach_status__c,TimeStamp_Considering_status__c,TimeStamp_Analyzing_Needs_status__c,TimeStamp_Fulfillment_status__c,Product_Type__c FROM Opportunity WHERE  StageName IN (\'' + string.join(spltstatus, '\',\'') + '\') AND SLA_Business_Hours__c!=null Order by CreatedDate DESC';
        return Database.getQueryLocator(query);
    }

    global void execute(Database.BatchableContext bc, List<Opportunity> oppList){

        set<string> opportunityIds = new set<string>();
        for (Opportunity o : oppList){
            opportunityIds.add(o.Id);
        }

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

        //get the hours spent field history//
        List<OpportunityFieldHistory> hrsHistory = new list<OpportunityFieldHistory>();
        hrsHistory = [Select Id, Opportunity.id, CreatedById, CreatedDate, Field, NewValue, OldValue
                      from OpportunityFieldHistory
                      where (field = 'Hour_Spent_Outreach_Status__c' or field = 'Hour_Spent_New_Status__c' or field = 'Hour_Spent_Analyzing_Needs_Status__c' or field = 'Hour_Spent_Considering_Status__c' or field = 'Hour_Spent_Fulfillment_Status__c') and Opportunity.id IN:OpportunityIds
                      Order by CreatedDate DESC];
       
        //For updating the Hour spent field dynamically //
        for (Opportunity oppL : oppList){
            id oppid = oppL.id;
            string currentstatus = oppL.StageName;
            string hoursSpentFieldName = 'Hour_Spent_' + currentstatus.replace(' ', ('_')) + '_Status__c';
            string statusTimeStampFieldName = 'TimeStamp_' + currentstatus.replace(' ', ('_')) + '_status__c';
            decimal timeDiff;
            decimal hh;
            decimal finalresult;
            Integer i = 0;
            while (i < ListAllHoursSpentFieldNames.size()){
                if (ListAllHoursSpentFieldNames.get(i).contains(HoursSpentFieldName)){
                    ListAllHoursSpentFieldNames.remove(i);
                } else{
                    i++;
                }
            }
            if ((OppL.get(statusTimeStampFieldName) != null)){
                boolean isHoursFieldsNotNull = false;
                Datetime hrsHistoryT;
                OpportunityFieldHistory tempobj = findHistoryObject(OppL.id,HoursSpentFieldName,hrsHistory);
                DateTime valueforDifference;
                if (tempobj != null){
                    hrsHistoryT = tempobj.CreatedDate;
                    if (hrsHistoryT > (datetime) (OppL.get(statusTimeStampFieldName))){
                        valueforDifference = hrsHistoryT;
                    } else{
                        valueforDifference = (datetime) (OppL.get(statusTimeStampFieldName));
                    }
                } else{
                    valueforDifference = (datetime) (OppL.get(statusTimeStampFieldName));
                }

                for (string s : ListAllHoursSpentFieldNames){
                    if ((OppL.get(s) != null)){
                        isHoursFieldsNotNull = true;
                        break;
                    }
                }

                if (isHoursFieldsNotNull == false){
                    hh = getTimeDifference((datetime) (OppL.get(statusTimeStampFieldName)));
                    finalresult = hh;
                    OppL.put(HoursSpentFieldName, finalresult);

                } else{
                    hh = getTimeDifference(valueforDifference);
                    finalresult = OppL.get(HoursSpentFieldName) != null ? (decimal) OppL.get(HoursSpentFieldName) + hh : hh;
                    OppL.put(HoursSpentFieldName, finalresult);

                }

            }

        }
        update oppList;
    }

    global void finish(Database.BatchableContext bc){
        // execute any post-processing operations
        system.debug('Finish');
    }

    //function to get the Timedifference for Hour spent field//
    private decimal getTimeDifference(datetime startTime){
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

    private OpportunityFieldHistory findHistoryObject(id opportunityID, string fieldName, List<OpportunityFieldHistory> hrsHistory){
        OpportunityFieldHistory ooph = new OpportunityFieldHistory();
        for (OpportunityFieldHistory fldHistory : hrsHistory){

            if (fldHistory.OpportunityID == opportunityID && fldHistory.Field.toLowerCase() == fieldName.toLowerCase()){
                ooph = fldHistory;
                break;
            }
        }
        return ooph;
    }
}