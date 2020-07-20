public class OpenLeadBusinessHours implements Schedulable 
{ 
    public void execute(SchedulableContext sc) 
    { 
      List<OpenHours__c>  listLead = [select Id,CreatedDate,Leadid__r.CreatedDate,Leadid__r.Status 
      		from OpenHours__c where Leadid__r.Status != 'Closed' Order by CreatedDAte DESC];
      businessHours   businessHours1 = [SELECT Id FROM BusinessHours WHERE IsDefault=true];
      
      for(OpenHours__c leaditem : listLead)
      {  
          
              if(leaditem.leadid__C != null)
              {
	              string bh = businessHours1.id;
	              Long hours = BusinessHours.diff(bh,leaditem.Leadid__r.CreatedDate , system.now());  
	             
	              leaditem.Open_Hours__c = hours/3600000;
              }                     
          
      }
      update listLead;
    } 
}