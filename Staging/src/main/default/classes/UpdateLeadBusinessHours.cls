global class UpdateLeadBusinessHours  implements Database.Batchable<sObject>  {
	
	global datetime startdate {get;set;}
	global datetime enddate {get;set;}
	
    global Database.QueryLocator start(Database.BatchableContext BC)
    {
        return Database.getQueryLocator('select Id, status, CreatedDate, LastModifiedDate from Lead where CreatedDate >= ' + string.valueof(startdate).replace(' ','T') + '.000+0000 and  CreatedDate <= ' + string.valueof(enddate).replace(' ','T') + '.000+0000  '); 
    }
   
    global void execute(Database.BatchableContext BC,list<Lead> Leads)
    {
       List<OpenHours__c> openHours = new List<OpenHours__c>();

		businessHours bhours = [SELECT Id FROM BusinessHours WHERE IsDefault=true];
		string bh = bhours.id;
		
		for(Lead lead: Leads){
			OpenHours__c obj = new OpenHours__c();
		    obj.LeadId__c = lead.Id;
		    Long hours = 0;
		    
		    if(lead.status == 'Closed')
		    {
		        hours = BusinessHours.diff(bh,lead.CreatedDate , lead.LastModifiedDate);        
		    }   
		    else {
		         hours = BusinessHours.diff(bh,lead.CreatedDate , system.now());        
		    }
		    obj.Open_Hours__c = hours/3600000;
		    openHours.add(obj);    
		}
		insert openHours;
	/*	
		    list<string> bIds = new List<string>();
		   for(OpenLeadHours__c item : openHours ){
		   		bIds.add(item.id);
		   }
		    
		    
		List<OpenLeadHours__c> leadhours = [select Id, LeadId__c from OpenLeadHours__c where id in: bIds ];
		List<Lead> lstLeads = new List<Lead>();
		for(OpenLeadHours__c h : leadhours){
		    Lead objLead = new Lead();
		    objLead.Id = h.LeadId__c;
		    objLead.BusinessHours__c = h.Id;
		    lstLeads.add(objLead);
		}
		update lstLeads;*/ 
    }
 
    global void finish(Database.BatchableContext BC)
    {
     
    }
}