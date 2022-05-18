public class Lead_UStatusHrs_Batch_Schedular implements Schedulable {
   
        public void execute(SchedulableContext obj)
        {
            Lead_Update_StatusHrs_Batch obj1 = new Lead_Update_StatusHrs_Batch();
              Database.executeBatch(obj1,20);
          
        }
       
  

}