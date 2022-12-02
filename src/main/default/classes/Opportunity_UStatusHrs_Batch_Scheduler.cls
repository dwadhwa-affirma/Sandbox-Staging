public class Opportunity_UStatusHrs_Batch_Scheduler implements Schedulable {
   
        public void execute(SchedulableContext obj)
        {
            Opportunity_Update_StatusHrs_Batch obj1 = new Opportunity_Update_StatusHrs_Batch();
            Database.executeBatch(obj1,10);
          
        }
       
  
}