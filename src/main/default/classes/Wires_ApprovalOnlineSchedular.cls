global class Wires_ApprovalOnlineSchedular implements Schedulable {
	global void execute(SchedulableContext obj){
     		Wires_ApprovalNotificationOnlineBatch obj1 = new Wires_ApprovalNotificationOnlineBatch();
            database.executeBatch(obj1,10);
     }
}