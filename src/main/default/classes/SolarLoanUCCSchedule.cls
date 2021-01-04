global class SolarLoanUCCSchedule implements Schedulable{
	
	global void execute(SchedulableContext ctx){
	   
        database.executeBatch(new SolarLoanUCCBatch(),1);
   	}
}