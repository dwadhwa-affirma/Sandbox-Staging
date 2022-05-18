global class Lead_Update_StatusHrs_Batch implements Database.Batchable<sObject> {
   public string query;
   
    global Database.QueryLocator start(Database.BatchableContext BC) {
        // collect the batches of records or objects to be passed to execute
        Map<string, SLA_Status_Manager__c> LeadStatus = SLA_Status_Manager__c.getAll();
        string getLeadStatus = (string) LeadStatus.get('Lead').Status__c;
        List<String> spltstatus = getLeadStatus.split(',');
       query='SELECT id,Status,SLA__c,Hour_Spent_New_Status__c,Hour_Spent_Outreach_Status__c,Hour_Spent_Considering_Status__c,Hour_Spent_Analyzing_Needs_Status__c,TimeStamp_New_status__c,TimeStamp_Outreach_status__c,TimeStamp_Considering_status__c,TimeStamp_Analyzing_Needs_status__c FROM Lead WHERE   Status IN (\'' + string.join(spltstatus,'\',\'') +  '\') AND SLA__c!=null Order by CreatedDate DESC LIMIT 20';
       return Database.getQueryLocator(query);
    }
    
    global void execute(Database.BatchableContext BC, List<Lead> LeadList) {        
        set<string> leadIds = new set<string>();
        for(Lead o: LeadList){
            leadIds.add(o.Id);
        }    
        String strObjectName = 'Lead';
        String strPicklistField = 'Status';
        List<String> ListAllStatuses = new List<String>();
        List<String> ListAllHoursSpentFieldNames = new List<String>();
        Map<String, String> mapPickListValues = new Map<String, String>();
        Schema.SObjectType objSobjectType = Schema.getGlobalDescribe().get(strObjectName);
        Schema.DescribeSObjectResult objDescribeSobject = objSobjectType.getDescribe();
        Map<String, Schema.SObjectField> mapFields = objDescribeSobject.fields.getMap();
        List<Schema.PicklistEntry> lstPickListValues = mapFields.get(strPicklistField).getDescribe().getPickListValues();
        for (Schema.PicklistEntry objPickList : lstPickListValues) 
            {
            string val = objPickList.getValue();
            if(!val.contains('Closed') && !val.contains('Client/SEG') && !val.contains('Prospecting')  )
            {
            ListAllStatuses.add(val);
            ListAllHoursSpentFieldNames.add('Hour_Spent_'+val.replace(' ',('_'))+'_Status__c');
            }
            }
            List<LeadHistory> HrsHistory=new list<LeadHistory>();
            HrsHistory=[Select Id,LeadId, CreatedById, CreatedDate,Field, NewValue, OldValue from LeadHistory  where 
            ( field = 'Hour_Spent_Outreach_Status__c' or field = 'Hour_Spent_New_Status__c' or field = 'Hour_Spent_Analyzing_Needs_Status__c' or field = 'Hour_Spent_Considering_Status__c'  ) 
            and LeadId IN: leadIds Order by CreatedDate DESC ];
            map<string,LeadHistory> dd=new map<string,LeadHistory>();
            for(LeadHistory oo:HrsHistory){
                if( !dd.containsKey(oo.Field))
                dd.put(oo.Field,oo);

                }
                 /*For updating the Hour spent field dynamically */
        for(lead l: LeadList){
           
            string Currentstatus = l.Status;
            string HoursSpentFieldName = 'Hour_Spent_'+Currentstatus.replace(' ',('_'))+'_Status__c';
            string statusTimeStampFieldName ='TimeStamp_'+Currentstatus.replace(' ',('_'))+'_status__c';
            decimal TimeDiff;
            decimal hh;
            decimal Finalresult;
            Integer i = 0;
            while (i < ListAllHoursSpentFieldNames.size()){
            if(ListAllHoursSpentFieldNames.get(i).contains(HoursSpentFieldName)){
            ListAllHoursSpentFieldNames.remove(i);
            } else {
            i++;
            }
        }
            if((l.get(statusTimeStampFieldName) != null)){
                boolean isHoursFiledsNotNull = false;
                Datetime HrsHistoryT;
                LeadHistory tempobj=dd.get(HoursSpentFieldName);
                
                DateTime ValueforDifference;
                if(tempobj != null){
                    HrsHistoryT=tempobj.CreatedDate;
                    if(HrsHistoryT > (datetime)(l.get(statusTimeStampFieldName))){
                        ValueforDifference = HrsHistoryT;
                    }
                       else{
                           ValueforDifference = (datetime)(l.get(statusTimeStampFieldName));
                       }
                }
                else{
                    ValueforDifference = (datetime)(l.get(statusTimeStampFieldName));
                }
                
                
              for(string s: ListAllHoursSpentFieldNames){
               if((l.get(s) != null)){
               isHoursFiledsNotNull = true;
                break;
                }
               }
                if(isHoursFiledsNotNull == false){
                 hh = getTimeDifference((datetime)(l.get(statusTimeStampFieldName)));
                Finalresult = hh;
                l.put(HoursSpentFieldName, Finalresult);
                
                }
                else{
                hh = getTimeDifference(ValueforDifference);
                Finalresult = l.get(HoursSpentFieldName) != null ? (decimal)l.get(HoursSpentFieldName) + hh : hh;
                l.put(HoursSpentFieldName, Finalresult);
               
                }
                }
                update LeadList;
        
        }
       
    }
    

    global void finish(Database.BatchableContext BC) {
    	// execute any post-processing operations
  }
    //function to get the Timedifference for Hour spent field//
    private decimal getTimeDifference(datetime StartTime){
        decimal hh;
        decimal TimeDifference;
        
        BusinessHours stdBusinessHours = [select id
                                            from businesshours
                                            where isDefault = true];
        DateTime currentTime = Datetime.now();
        
        TimeDifference = BusinessHours.diff(stdBusinessHours.id,StartTime, currentTime);
        hh = (TimeDifference / 3600000).setScale(2);
        
        return hh;
    }
}