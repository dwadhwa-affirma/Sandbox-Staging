public class CreateAlertForNonMatchedMemberSchedular implements Schedulable {
    
    public void execute(SchedulableContext obj)
        {
            CreateCaseForNonMatchedMemberBatch obj1 = new CreateCaseForNonMatchedMemberBatch();
        	Database.executeBatch(obj1, 20);

            
        }
         	
        
        
}