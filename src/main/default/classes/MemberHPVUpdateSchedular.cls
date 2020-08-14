global class MemberHPVUpdateSchedular implements Schedulable {
    global void execute(SchedulableContext ctx) {
        Set<string> AccountIds = new Set<string>();
        List<Person_Account__c> Accounts= [SELECT Id,Account_Number__c,Account_Number__r.RecType__c, Account_Number__r.Name, 
                                    PersonID__c, Account_Number__r.High_Value_Flag__c, 
                                    Account_Number__r.OPEN_DATE__c 
                                    FROM Person_Account__c 
                                    WHERE TypeTranslate__c in ('0001/Joint Member','0000/Primary')
                                    AND (CREATEDDATE = LAST_N_DAYS:1 OR LASTMODIFIEDDATE = LAST_N_DAYS:1) 
                                    AND  Account_Number__r.High_Value_Flag__c > 0];
        System.debug('AccountSize=='+Accounts.size());

        for(Person_Account__c a: Accounts){
            AccountIds.add(a.PersonID__c);
        }


        MemberHPVUpdateBatchJob obj1 = new MemberHPVUpdateBatchJob(AccountIds);
        Database.executeBatch(obj1, 20);
    }
}