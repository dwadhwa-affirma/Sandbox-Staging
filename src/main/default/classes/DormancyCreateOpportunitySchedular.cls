public class DormancyCreateOpportunitySchedular implements Schedulable {
    
    public void execute(SchedulableContext obj){
    	Triggered_Opportunity_Configurations__c cs = Triggered_Opportunity_Configurations__c.getValues('Primary Record');
    	
    	boolean isTriggered = (boolean)cs.Impending_Dormancy_isTriggered__c;
    	
    	if(isTriggered)
    	{
           
            ImpendingDormancyCreateOpportunityBatch obj1 = new ImpendingDormancyCreateOpportunityBatch();
            database.executeBatch(obj1,20);
	    	
	        ImpendingDormancyCloseOpportunityBatch obj2 = new ImpendingDormancyCloseOpportunityBatch();
            database.executeBatch(obj2,20); 
	           
	           
		}
                              
          
    
    }
}