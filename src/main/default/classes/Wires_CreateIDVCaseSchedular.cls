global class Wires_CreateIDVCaseSchedular implements Schedulable {
	global void execute(SchedulableContext obj){
     		Wires_CreateIDVCaseTransactionBatch obj1 = new Wires_CreateIDVCaseTransactionBatch();
            database.executeBatch(obj1,20);
     }
}