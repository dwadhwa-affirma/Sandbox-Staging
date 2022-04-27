public class LeadSLAStatusController{

    @auraenabled
    public static Map<string,object> getData(string leadId){
        List<Lead> listLeads=[SELECT id, Name, SLA__c, Status_SLA__c, SLA_Breach_Time__c from Lead where id =: leadId and SLA__c != null limit 1];

        Map<string,object> result = new map<string,object>();
        LeadSLAStatusWrapperClass LeadSLA = new LeadSLAStatusWrapperClass();
        if(listLeads.size()>0){
            LeadSLA.CurrentStageSLA = string.valueof(listLeads[0].SLA__c);            
            LeadSLA.CurrentStageBreach = listLeads[0].Status_SLA__c;

            Id businessHoursId = [select Id from BusinessHours where isdefault = true ].id;
            DateTime BreachTime = listLeads[0].SLA_Breach_Time__c;
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
            LeadSLA.CurrentStageBusinessHoursRemaining = totalTime;//string.valueof(hours);
            if(hours <0 ||  remainingMins < 0){
                LeadSLA.isBreached = true;
            }
            else{
                LeadSLA.isBreached = false;
            }
        }

        result.put('LeadSLAStatus',LeadSLA);
        return result;
    }

    public class LeadSLAStatusWrapperClass{
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