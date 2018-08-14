global class UpdateAccountMemberBranch implements Database.Batchable<sObject>{

   global Database.QueryLocator start(Database.BatchableContext BC){
      String ACCT = 'ACCT';
      String Query='Select Id, RecType__c, Current_Branch1__c from Account_Details__c where RecType__C =:ACCT';
      return Database.getQueryLocator(Query);
   }

   global void execute(Database.BatchableContext BC, List<Account_Details__c> scope){
     List<string> ids = new List<string>();
     Map<Id,string> accountMemberBranch = new Map<Id,string>();
     
     for(Account_Details__c acc : scope)
     {
        ids.add(acc.id);
        accountMemberBranch.put(acc.id,acc.Current_Branch1__c);
     }

    List<Person_Account__C> listPA = [select id,Account_Number__c,PersonId__c from Person_Account__C where Account_Number__c in : ids];
    
    Map<string,string> listMemberBranch = new Map<string,string>();
    List<string> listMembers = new List<string>();
     
    for(Person_Account__C item : listPA)
    {
        listMembers.add(item.PersonId__c);
        
    }
    
    List<Person_Account__C> listAccMember = [select id,PersonId__c,Account_Number__c from Person_Account__C where PersonId__c in: listMembers and Account_Number__r.RecType__c = 'ACCT'];
    
    Set<string> memberFound = new Set<string>(); 
    
    for(Person_Account__C item : listAccMember)
    {
        if(!memberFound.contains(item.Id))
        {
            string branch = accountMemberBranch.get(item.Account_Number__c);
            memberFound.add(item.PersonId__c);
            listMemberBranch.put(item.PersonId__c, branch);
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