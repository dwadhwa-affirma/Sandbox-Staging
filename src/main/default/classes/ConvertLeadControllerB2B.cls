public with sharing class ConvertLeadControllerB2B {
   
    @AuraEnabled   
    public static Map<String,object> GetLeadInfo(Id leadId)
    {
        Map<String,object> resultMap = new Map<string,object>(); 
        Lead ld = [Select id, Company, RecordType.Name, Owner.Name, FirstName, LastName from Lead where id=:leadId]  ;
        resultMap.put('Lead', ld); 
      return resultMap;
    }    
    @AuraEnabled   
    public static Map<String,Id> ConvertLead(Id leadId)
    {
        Map<String,Id> resultMap = new Map<string,Id>();
        Lead l = new Lead();
        l.Count__C = 0;
        l.id = leadId;
        update l;
        Database.LeadConvert lc = new Database.LeadConvert();
        lc.setLeadId(leadId);
        LeadStatus convertStatus = [SELECT Id, MasterLabel FROM LeadStatus WHERE IsConverted=true LIMIT 1];
        lc.setConvertedStatus(convertStatus.MasterLabel);
        Database.LeadConvertResult lcr = Database.convertLead(lc);
        Id AccountId = lcr.getAccountId();
        Id ContactId = lcr.getContactId();
        Id OpportunityId = lcr.getOpportunityId();
        resultMap.put('AccountId',AccountId);
        resultMap.put('ContactId',ContactId);
        resultMap.put('OpportunityId',OpportunityId);
        
        if(l.Status != 'Closed - Converted'){
            l.Status = 'Closed - Converted';
        }
        update l;
        
        return resultMap;  	
    	
    	
    }
}