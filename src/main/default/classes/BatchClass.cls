global class BatchClass implements Database.Batchable<sObject> {
    global final String Query;
    global BatchClass(String q)
    {
        Query=q;
    }
    
    global Database.QueryLocator start(Database.BatchableContext BC)
    {
        return Database.getQueryLocator(query);
    }
   
    global void execute(Database.BatchableContext BC,list<Account_Details__c> scope)
    {
        System.debug('Scope list is::'+scope);
        set<String> ChildAccIds = new set<String>();
        for(Account_Details__c d: scope){
            ChildAccIds.add(d.Name);
        }
        
        list<Account_Details__c> parentList = [Select Id, Name from Account_Details__c where Name IN:ChildAccIds AND RecType__c = 'ACCT'];
        
        for(Account_Details__c d: scope){        
        for(Account_Details__c e: parentList){
        if(d.Parent_Account__c == null && d.Name == e.Name){
           d.Parent_Account__c = e.Id;
        }
        }
        }
        update scope;    
    }
 
    global void finish(Database.BatchableContext BC)
    {
     
    }

}