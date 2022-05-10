global class Opportunity_Update_StatusHrs_Batch implements Database.Batchable<sObject>{
    public string query;
    global Database.QueryLocator start(Database.BatchableContext BC) {
        // collect the batches of records or objects to be passed to execute
        Map<string, SLA_Status_Manager__c> LeadStatus = SLA_Status_Manager__c.getAll();
        string getOppStatus = (string) LeadStatus.get('Opportunity').Status__c;
        List<String> spltstatus = getOppStatus.split(',');
        system.debug('spltstatus  '+spltstatus);
       query='SELECT id,StageName,Hour_Spent_New_Status__c,Hour_Spent_Outreach_Status__c,TimeStamp_New_status__c,TimeStamp_Outreach_status__c FROM Opportunity WHERE StageName IN (\'' + string.join(spltstatus,'\',\'') +  '\') Order by CreatedDate DESC LIMIT 20';      
       return Database.getQueryLocator(query);
    }
    global void execute(Database.BatchableContext BC, List<Opportunity> OppList) {
        BusinessHours stdBusinessHours = [select id
        from businesshours
        where isDefault = true];
        DateTime currentTime = Datetime.now();
        for(Opportunity OppL: OppList){
            string status = OppL.StageName;
            string FieldName = 'Hour_Spent_'+Status.replace(' ',('_'))+'_Status__c';
            system.debug('status '+status);
            system.debug(OppL.get(FieldName));
            system.debug('FieldName- '+FieldName);
            string statusTimeStamp='TimeStamp_'+Status.replace(' ',('_'))+'_status__c';
            system.debug('statusTimeStamp- '+statusTimeStamp);
            system.debug(OppL.get(statusTimeStamp));
            decimal TimeDiff;
            decimal hh;
            decimal Finalresult;
            if(statusTimeStamp!= null){
             TimeDiff = BusinessHours.diff(stdBusinessHours.id, (datetime)(OppL.get(statusTimeStamp)), currentTime);
             hh = (TimeDiff / 3600000).setScale(2);
            Finalresult =OppL.get(FieldName) != null ?(decimal) OppL.get(FieldName) + hh : hh;
            
           OppL.put(FieldName, Finalresult);
            }
            system.debug('TimeDiff'+TimeDiff);
           system.debug('hh'+hh);
           system.debug('Finalresult'+Finalresult);
        
        }
        update OppList;
        
       
    }
    global void finish(Database.BatchableContext BC) {
    	// execute any post-processing operations
  }  
}
