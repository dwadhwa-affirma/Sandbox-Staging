public class Wires_RecurrenceTransactionSchedular implements Schedulable {
     public void execute(SchedulableContext obj){
     		Wires_ProcessRecurrenceTransactionBatch obj1 = new Wires_ProcessRecurrenceTransactionBatch();
            database.executeBatch(obj1,5);
     }
}