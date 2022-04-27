public class OpportunitySLAStatusController {
    @auraenabled
    public static Map<string,object> getData(string opportunityId){
        List<Opportunity> listOpportunities=[SELECT id, Name, SLA_Business_Hours__c, Status_SLA__c, SLA_Breach_Time__c from Opportunity where id =: opportunityId  and SLA_Business_Hours__c != null limit 1];

        Map<string,object> result = new map<string,object>();
        OpportunitySLAStatusWrapperClass OpportunitySLA = new OpportunitySLAStatusWrapperClass();
        if(listOpportunities.size()>0){
            OpportunitySLA.CurrentStageSLA = string.valueof(listOpportunities[0].SLA_Business_Hours__c);            
            OpportunitySLA.CurrentStageBreach = listOpportunities[0].Status_SLA__c;

            Id businessHoursId = [select Id from BusinessHours where isdefault = true ].id;
            DateTime BreachTime = listOpportunities[0].SLA_Breach_Time__c;
            DateTime CurrentTime = Datetime.Now(); 
            system.debug('BreachTime=='+BreachTime);
            system.debug('CurrentTime='+CurrentTime);
            //Long hours = BusinessHours.diff(businessHoursId,CurrentTime,BreachTime)/1000/60/60;
            Long milliseconds = BusinessHours.diff(businessHoursId,CurrentTime,BreachTime);
            Long mins = milliseconds / 60000;
            Long hours = mins / 60;
            Long remainingMins = mins - (hours * 60);
            String totalTime = String.valueOf(hours) + ' hrs ' +  String.valueOf(remainingMins) +' mins';
            System.debug('totalTime-' + totalTime); 
            OpportunitySLA.CurrentStageBusinessHoursRemaining = totalTime;//string.valueof(hours);
            if(hours <0 ||  remainingMins < 0){
                OpportunitySLA.isBreached = true;
            }
            else{
                OpportunitySLA.isBreached = false;
            }
        }

        result.put('OpportunitySLAStatus',OpportunitySLA);
        return result;
    }

    public class OpportunitySLAStatusWrapperClass{
        @AuraEnabled
        public string CurrentStageSLA {get; set;}

        @AuraEnabled
        public string CurrentStageBusinessHoursRemaining {get; set;}

        @AuraEnabled
        public string CurrentStageBreach {get; set;}

        @AuraEnabled
        public Boolean isBreached {get; set;}

    }
}