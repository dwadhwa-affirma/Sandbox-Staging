public class LeadBusinessHoursController {
	
		public static String LeadId {get; set;}
		public static OpenHours__c LeadHours {get; set;}
		
		
		public LeadBusinessHoursController(ApexPages.StandardController controller) {
			LeadId = ApexPages.CurrentPage().getparameters().get('id');
			LeadHours = new OpenHours__c();
			LeadHours = [select Id, Open_Hours__c from OpenHours__c where leadId__c =: LeadId limit 1];			
		}		
		
		 @AuraEnabled 
		 public static OpenHours__c GetLeadHours(string LeadId){
		 	LeadHours = new OpenHours__c();
			LeadHours = [select Id, Open_Hours__c from OpenHours__c where leadId__c =: LeadId limit 1];	
			return LeadHours;
		 }
}