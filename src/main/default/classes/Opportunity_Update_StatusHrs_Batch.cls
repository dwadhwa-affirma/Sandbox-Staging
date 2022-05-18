global class Opportunity_Update_StatusHrs_Batch implements Database.Batchable<sObject>{
    public string query;
    global Database.QueryLocator start(Database.BatchableContext BC) 
    {
        // collect the batches of records or objects to be passed to execute
        Map<string, SLA_Status_Manager__c> LeadStatus = SLA_Status_Manager__c.getAll();
        string getOppStatus = (string) LeadStatus.get('Opportunity').Status__c;
        List<String> spltstatus = getOppStatus.split(',');
       query='SELECT id,SLA_Business_Hours__c,StageName,Hour_Spent_New_Status__c,Hour_Spent_Outreach_Status__c,Hour_Spent_Considering_Status__c,Hour_Spent_Analyzing_Needs_Status__c,Hour_Spent_Fulfillment_Status__c,TimeStamp_New_status__c,TimeStamp_Outreach_status__c,TimeStamp_Considering_status__c,TimeStamp_Analyzing_Needs_status__c,TimeStamp_Fulfillment_status__c,Product_Type__c FROM Opportunity WHERE  StageName IN (\'' + string.join(spltstatus,'\',\'') +  '\') AND SLA_Business_Hours__c!=null Order by CreatedDate DESC LIMIT 20';      
       return Database.getQueryLocator(query);
    }
    global void execute(Database.BatchableContext BC, List<Opportunity> OppList)
    {
       
        set<string> OpportunityIds = new set<string>();
        for(Opportunity o: OppList){
            OpportunityIds.add(o.Id);
        }        
       
        String strObjectName = 'Opportunity';
        String strPicklistField = 'StageName';
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
            if(!val.contains('Closed'))
            {
            ListAllStatuses.add(val);
            ListAllHoursSpentFieldNames.add('Hour_Spent_'+val.replace(' ',('_'))+'_Status__c');
            }
            }
         
		
        List<OpportunityFieldHistory> HrsHistory=new list<OpportunityFieldHistory>();
                HrsHistory=[Select Id,Opportunity.id, CreatedById, CreatedDate,Field, NewValue, OldValue from OpportunityFieldHistory where 
                ( field = 'Hour_Spent_Outreach_Status__c' or field = 'Hour_Spent_New_Status__c' or field = 'Hour_Spent_Analyzing_Needs_Status__c' or field = 'Hour_Spent_Considering_Status__c' or field = 'Hour_Spent_Fulfillment_Status__c' ) 
               and Opportunity.id IN: OpportunityIds Order by CreatedDate DESC ];
               map<string,OpportunityFieldHistory> dd=new map<string,OpportunityFieldHistory>();
            for(OpportunityFieldHistory oo:HrsHistory){                
                if( !dd.containsKey(oo.Field))
                dd.put(oo.Field,oo);            
            }

        /*For updating the Hour spent field dynamically */
        for(Opportunity OppL: OppList)
        {  
            id oppid=OppL.id;
            string Currentstatus = OppL.StageName;
            string HoursSpentFieldName = 'Hour_Spent_'+Currentstatus.replace(' ',('_'))+'_Status__c';
            string statusTimeStampFieldName ='TimeStamp_'+Currentstatus.replace(' ',('_'))+'_status__c';
            decimal TimeDiff;
            decimal hh;
            decimal Finalresult;
            Integer i = 0;
            while (i < ListAllHoursSpentFieldNames.size())
            {
            if(ListAllHoursSpentFieldNames.get(i).contains(HoursSpentFieldName)){
            ListAllHoursSpentFieldNames.remove(i);
            } else {
            i++;
            }
        }
            if((OppL.get(statusTimeStampFieldName) != null)){
                boolean isHoursFieldsNotNull = false;
                Datetime HrsHistoryT;
                OpportunityFieldHistory tempobj=dd.get(HoursSpentFieldName);
                DateTime ValueforDifference;
                if(tempobj != null){
                    HrsHistoryT=tempobj.CreatedDate;
                    if(HrsHistoryT > (datetime)(OppL.get(statusTimeStampFieldName))){
                        ValueforDifference = HrsHistoryT;
                    }
                       else{
                           ValueforDifference = (datetime)(OppL.get(statusTimeStampFieldName));
                       }
                }
                else{
                    ValueforDifference = (datetime)(OppL.get(statusTimeStampFieldName));
                }
  
              for(string s: ListAllHoursSpentFieldNames){
               if((OppL.get(s) != null)){
                isHoursFieldsNotNull = true;
                break;
                }
               }
               
                if(isHoursFieldsNotNull == false){
                hh = getTimeDifference((datetime)(OppL.get(statusTimeStampFieldName)));
                Finalresult = hh;
                OppL.put(HoursSpentFieldName, Finalresult);
                  
                }
                else{
                hh = getTimeDifference(ValueforDifference);
                Finalresult = OppL.get(HoursSpentFieldName) != null ? (decimal)OppL.get(HoursSpentFieldName) + hh : hh;
                OppL.put(HoursSpentFieldName, Finalresult);
               
                }

       }
           update OppList;
    }
      
}    
    global void finish(Database.BatchableContext BC) 
    {
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
