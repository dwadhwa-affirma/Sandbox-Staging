global class Lead_Update_StatusHrs_Batch implements Database.Batchable<sObject> {
   public string query;
   
    global Database.QueryLocator start(Database.BatchableContext BC) {
        // collect the batches of records or objects to be passed to execute
        Map<string, SLA_Status_Manager__c> LeadStatus = SLA_Status_Manager__c.getAll();
        string getLeadStatus = (string) LeadStatus.get('Lead').Status__c;
        List<String> spltstatus = getLeadStatus.split(',');
        system.debug('spltstatus  '+spltstatus);
       query='SELECT id,Status,Hour_Spent_New_Status__c,Hour_Spent_Outreach_Status__c,TimeStamp_New_status__c,TimeStamp_Outreach_status__c FROM Lead WHERE   Status IN (\'' + string.join(spltstatus,'\',\'') +  '\') Order by CreatedDate DESC LIMIT 20';
       return Database.getQueryLocator(query);
    }
    
    global void execute(Database.BatchableContext BC, List<Lead> LeadList) {
        BusinessHours stdBusinessHours = [select id
        from businesshours
        where isDefault = true];
        DateTime currentTime = Datetime.now();
        for(lead l: LeadList){
            string status = l.Status;
            string FieldName = 'Hour_Spent_'+Status.replace(' ',('_'))+'_Status__c';
            system.debug('status '+status);
            system.debug(l.get(FieldName));
            system.debug('FieldName- '+FieldName);
            string statusTimeStamp='TimeStamp_'+Status.replace(' ',('_'))+'_status__c';
            system.debug('TimeStamp Lead- '+l.TimeStamp_New_status__c);
            system.debug('statusTimeStamp- '+statusTimeStamp);
            system.debug(l.get(statusTimeStamp));
            decimal TimeDiff;
            decimal hh;
            decimal Finalresult;
         if(statusTimeStamp!= null){
             TimeDiff = BusinessHours.diff(stdBusinessHours.id, (datetime)(l.get(statusTimeStamp)), currentTime);
             hh = (TimeDiff / 3600000).setScale(2);
             Finalresult =l.get(FieldName) != null ?(decimal) l.get(FieldName) + hh : hh;
            l.put(FieldName, Finalresult);
         }
           system.debug('TimeDiff'+TimeDiff);
           system.debug('hh'+hh);
           system.debug('Finalresult'+Finalresult);
        
        }
        update LeadList;
        
       
    }  

    global void finish(Database.BatchableContext BC) {
    	// execute any post-processing operations
  }
}