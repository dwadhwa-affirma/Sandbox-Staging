public with sharing class SLAStatusController {
    
    @AuraEnabled
    public static Map<string,object> getSLAStatus(String recordId)
    {
        Map<string,object> result = new map<string,object>();
        SLAStatusWrapperClass objSLAStatusWrapper = new SLAStatusWrapperClass();
        try{
            //Get prefix from record ID
            String myIdPrefix = String.valueOf(recordId).substring(0,3);
            Id businessHoursId = [SELECT Id FROM BusinessHours WHERE isDefault = true ].Id;
           
            DateTime breachTime = Datetime.Now(); 
            DateTime currentTime = Datetime.Now(); 
            
            if(myIdPrefix.startsWith('006')) // Opportunity
            {
                Opportunity opp = [SELECT StageName,SLA_New__c,SLA_Fulfillment__c,SLA_Outreach__c,SLA_Analyzing_Needs__c,SLA_Considering__c,
                                   SLA_Start_Time_Analyzing_Needs_Status__c,SLA_Start_Time_Considering_Status__c,
                                   SLA_Start_Time_Fulfillment_Status__c,SLA_Start_Time_New_Status__c,SLA_Start_Time_Outreach_Status__c,
                                   SLA_Breached_New_Status__c,SLA_Breached_Analyzing_Needs_Status__c,    SLA_Breached_Considering_Status__c,
                                   SLA_Breached_Fulfillment_Status__c,SLA_Breached_Outreach_Status__c
                                   FROM Opportunity 
                                   WHERE Id=:recordId 
                                   LIMIT 1];
                
                Switch on opp.StageName {
                    When 'New' {        
                        objSLAStatusWrapper.CurrentStageSLA= opp.SLA_New__c;
                        objSLAStatusWrapper.CurrentStageSLABreached= opp.SLA_Breached_New_Status__c;
                        breachTime=opp.SLA_Start_Time_New_Status__c;
                    }   
                    When 'Outreach' {       
                        objSLAStatusWrapper.CurrentStageSLA= opp.SLA_Outreach__c;
                        objSLAStatusWrapper.CurrentStageSLABreached= opp.SLA_Breached_Outreach_Status__c;
                        breachTime=opp.SLA_Start_Time_Outreach_Status__c;
                    }
                    when 'Analyzing Needs' {        
                        objSLAStatusWrapper.CurrentStageSLA= opp.SLA_Analyzing_Needs__c;
                        objSLAStatusWrapper.CurrentStageSLABreached= opp.SLA_Breached_Analyzing_Needs_Status__c;
                        breachTime=opp.SLA_Start_Time_Analyzing_Needs_Status__c;
                    }
                    When 'Considering' {        
                        objSLAStatusWrapper.CurrentStageSLA= opp.SLA_Considering__c;
                        objSLAStatusWrapper.CurrentStageSLABreached= opp.SLA_Breached_Considering_Status__c;
                        breachTime=opp.SLA_Start_Time_Considering_Status__c;
                    }
                    When 'Fulfillment' {        
                        objSLAStatusWrapper.CurrentStageSLA= opp.SLA_Fulfillment__c;
                        objSLAStatusWrapper.CurrentStageSLABreached= opp.SLA_Breached_Fulfillment_Status__c;
                        breachTime=opp.SLA_Start_Time_Fulfillment_Status__c;
                    }
                    When else {      
                        objSLAStatusWrapper.CurrentStageSLA= 0;
                        objSLAStatusWrapper.CurrentStageSLABreached= false;
                    }
                }
            }
            
            if(myIdPrefix.startsWith('00Q')) // Lead
            {
                Lead lead = [SELECT Status,SLA_New__c,SLA_Outreach__c,SLA_Analyzing_Needs__c,SLA_Considering__c,
                                   SLA_Start_Time_Analyzing_Needs_Status__c,SLA_Start_Time_Considering_Status__c,
                                   SLA_Start_Time_New_Status__c,SLA_Start_Time_Outreach_Status__c,
                                   SLA_Breached_New_Status__c,SLA_Breached_Analyzing_Needs_Status__c,SLA_Breached_Considering_Status__c,
                                   SLA_Breached_Outreach_Status__c
                                   FROM Lead 
                                   WHERE Id=:recordId 
                                   LIMIT 1];
                
                Switch on lead.Status {
                    When 'New' {        
                        objSLAStatusWrapper.CurrentStageSLA= lead.SLA_New__c;
                        objSLAStatusWrapper.CurrentStageSLABreached= lead.SLA_Breached_New_Status__c;
                        breachTime=lead.SLA_Start_Time_New_Status__c;
                    }   
                    When 'Outreach' {       
                        objSLAStatusWrapper.CurrentStageSLA= lead.SLA_Outreach__c;
                        objSLAStatusWrapper.CurrentStageSLABreached= lead.SLA_Breached_Outreach_Status__c;
                        breachTime=lead.SLA_Start_Time_Outreach_Status__c;
                    }
                    when 'Analyzing Needs' {        
                        objSLAStatusWrapper.CurrentStageSLA= lead.SLA_Analyzing_Needs__c;
                        objSLAStatusWrapper.CurrentStageSLABreached= lead.SLA_Breached_Analyzing_Needs_Status__c;
                        breachTime=lead.SLA_Start_Time_Analyzing_Needs_Status__c;
                    }
                    When 'Considering' {        
                        objSLAStatusWrapper.CurrentStageSLA= lead.SLA_Considering__c;
                        objSLAStatusWrapper.CurrentStageSLABreached= lead.SLA_Breached_Considering_Status__c;
                        breachTime=lead.SLA_Start_Time_Considering_Status__c;
                    }
                    When else {      
                        objSLAStatusWrapper.CurrentStageSLA= 0;
                        objSLAStatusWrapper.CurrentStageSLABreached= false;
                    }
                }
                
            }
            
            System.debug('BreachTime=='+breachTime);
            System.debug('CurrentTime='+currentTime);
            if(breachTime==null) 
            {
                breachTime=currentTime;
            }
                
            Long milliseconds =BusinessHours.diff(businessHoursId,currentTime,breachTime);
            Long mins = milliseconds / 60000;
            Long hours = mins / 60;
            Long remainingMins = mins - (hours * 60);
            string minutes=String.valueOf(remainingMins);
            if(remainingMins > 0 && remainingMins<10) {
           	  minutes='0'+String.valueOf(remainingMins);
            }
            
            String totalTime = String.valueOf(hours) +':'+ String.valueOf(minutes);
            objSLAStatusWrapper.IsSLAInRed=false;
            objSLAStatusWrapper.IsSLAInGreen=false;
            objSLAStatusWrapper.IsSLAInYellow=false;
            
            if(hours < 0 ||  remainingMins < 0)
            {
                minutes=String.valueOf(remainingMins).remove('-');
                
                if(integer.valueOf(minutes) > 0 && integer.valueOf(minutes)<10) {
           	 	   minutes='0'+String.valueOf(minutes);
           		 }
                
                totalTime = '-'+String.valueOf(hours).remove('-') +':'+ minutes;
                objSLAStatusWrapper.IsSLAInRed=true;
                objSLAStatusWrapper.IsBreached=true;
            }else{
                
                if(milliseconds > 0 && milliseconds<=3600000) {
                     objSLAStatusWrapper.IsSLAInYellow=true;
                }else {
                      objSLAStatusWrapper.IsSLAInGreen=true;
                }
                objSLAStatusWrapper.IsBreached=false;
            }
            
            System.debug('totalTime-' + totalTime); 
            objSLAStatusWrapper.CurrentStageBusinessHoursRemaining = totalTime;
        }
        catch(Exception e){
            System.debug(e);
            //throw new AuraHandledException(e.);
        }
        
        result.put('SLAStatus',objSLAStatusWrapper);
        
        return result;
    }
    
    public class SLAStatusWrapperClass
    {
        @AuraEnabled
        public Decimal CurrentStageSLA {get; set;}
        
        @AuraEnabled
        public String CurrentStageBusinessHoursRemaining {get; set;}
        
        @AuraEnabled
        public Boolean CurrentStageSLABreached {get; set;}
        
        @AuraEnabled
        public Boolean IsBreached {get; set;}
        
        @AuraEnabled
        public Boolean IsSLAInGreen {get; set;}
        
        @AuraEnabled
        public Boolean IsSLAInRed {get; set;}
        
        @AuraEnabled
        public Boolean IsSLAInYellow {get; set;}
    }
}