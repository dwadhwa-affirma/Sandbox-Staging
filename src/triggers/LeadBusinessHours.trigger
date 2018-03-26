trigger LeadBusinessHours on Lead (after insert) {
   List<OpenHours__c> openHours = new List<OpenHours__c>();
    
    for(Lead lead: Trigger.new){
             if (Trigger.isInsert) {
                OpenHours__c obj = new OpenHours__c();
                obj.LeadId__c = lead.Id;
                obj.Open_Hours__c = 0;
                openHours.add(obj);
            insert openHours;  
                
             } 
        }
 }