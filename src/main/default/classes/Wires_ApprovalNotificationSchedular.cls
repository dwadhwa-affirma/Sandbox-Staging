global class Wires_ApprovalNotificationSchedular implements Schedulable {
	global void execute(SchedulableContext obj){
     		Wires_ApprovalNotificationBatch obj1 = new Wires_ApprovalNotificationBatch();
            database.executeBatch(obj1,10);
     }
}