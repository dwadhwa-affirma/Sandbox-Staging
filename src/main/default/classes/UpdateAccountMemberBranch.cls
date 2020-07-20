global class UpdateAccountMemberBranch implements Database.Batchable<sObject>{

   global Database.QueryLocator start(Database.BatchableContext BC){
      String ACCT = 'ACCT';
      String Query='Select Id,Name, RecType__c, Current_Branch1__c from Account_Details__c where RecType__c =:ACCT';
      return Database.getQueryLocator(Query);
      
   }

   global void execute(Database.BatchableContext BC, List<Account_Details__c> scope){
     Set<string> ids = new Set<string>();
     Map<Id,string> accountMemberBranch = new Map<Id,string>();
     
     for(Account_Details__c acc : scope)
     {
        ids.add(acc.id);
        accountMemberBranch.put(acc.id,acc.Current_Branch1__c);
     }
        
    AggregateResult[] groupedResults = [SELECT PersonId__c,Account_Number__c, PersonID__r.id acctId FROM Person_Account__c WHERE Account_Number__c in: ids group by PersonId__c,PersonID__r.id,Account_Number__c];
    
    System.debug('groupedResults' +groupedResults);
    
    Map<string,string> listMemberBranch = new Map<string,string>();
 
    Set<string> memberFound = new Set<string>(); 
    
    for(AggregateResult item : groupedResults)
    {
        if(!memberFound.contains((string)item.get('PersonId__c')))
        {
            string branch = accountMemberBranch.get((string)item.get('Account_Number__c'));
            memberFound.add((string)item.get('PersonId__c'));
            listMemberBranch.put((string)item.get('PersonId__c'), branch);            
        }
        
    }
    
    List<Account> listMainAccount = [select id,Member_Branch__c from Account where Id in: memberFound];
    List<Valid_Branch__c> branchList = [select id,Name from Valid_Branch__c];
    Set<String> existingBranch = new Set<String>();
    
    for(Account acc: listMainAccount)
    {
        string memberBranch = listMemberBranch.get(acc.id);
        existingBranch.add(listMemberBranch.get(acc.id));
        for(Integer i=0;i<branchList.size();i++)
        {
            String branchName = branchList[i].Name;
            if (existingBranch.contains(branchName))
            {
                acc.Member_Branch__c = memberBranch;
            }
        }
    }
    
    update listMainAccount;
    
    }

   global void finish(Database.BatchableContext BC){
   }
}