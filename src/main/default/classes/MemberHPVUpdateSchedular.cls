global class MemberHPVUpdateSchedular implements Schedulable {
    global void execute(SchedulableContext ctx) {
        Set<string> AccountIds = new Set<string>();
        List<Account> Accounts= [Select id, name from Account limit 100];

        for(Account a: Accounts){
            AccountIds.add(a.id);
        }


        MemberHPVUpdateBatchJob obj1 = new MemberHPVUpdateBatchJob(AccountIds);
        Database.executeBatch(obj1, 20);
    }
}
