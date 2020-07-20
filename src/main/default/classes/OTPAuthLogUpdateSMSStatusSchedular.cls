public class OTPAuthLogUpdateSMSStatusSchedular implements Schedulable {
     public void execute(SchedulableContext obj){
     		OTPAuthLogUpdateSMSStatusBatch obj1 = new OTPAuthLogUpdateSMSStatusBatch();
            database.executeBatch(obj1,20);
     }
}