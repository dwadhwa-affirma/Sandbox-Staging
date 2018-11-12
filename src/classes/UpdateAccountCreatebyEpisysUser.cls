global class UpdateAccountCreatebyEpisysUser implements Database.Batchable<sObject>{

   global Database.QueryLocator start(Database.BatchableContext BC){
      String ACCT = 'ACCT';
      String Query='Select Id,Name, RecType__c, Created_By_User_Alias__c from Account_Details__c order by Name';
      return Database.getQueryLocator(Query);
      
   }

   global void execute(Database.BatchableContext BC, List<Account_Details__c> scope){
     Set<string> ids = new Set<string>();
     Map<Id,string> accountEpisysUser = new Map<Id,string>();
     
     for(Account_Details__c acc : scope)
     {
        ids.add(acc.id);
        accountEpisysUser.put(acc.id,acc.Created_By_User_Alias__c);
     }
        
    AggregateResult[] groupedResults = [SELECT PersonId__c,Account_Number__c, PersonID__r.id,Account_Number__r.RecType__c FROM Person_Account__c WHERE Account_Number__c in: ids group by PersonId__c,PersonID__r.id,Account_Number__c,Account_Number__r.RecType__c];
    
    System.debug('groupedResults' +groupedResults);
    
    Map<string,string> listEpisysUsers = new Map<string,string>();
 
    Set<string> memberFound = new Set<string>(); 
    
    for(AggregateResult item : groupedResults)
    {
        if(((string)item.get('RecType__c')) == 'ACCT'  && !memberFound.contains((string)item.get('PersonId__c')))
        {
            string episysUser = accountEpisysUser.get((string)item.get('Account_Number__c'));
            if(string.isNotBlank(episysUser) && string.isNotEmpty(episysUser))
            {
                memberFound.add((string)item.get('PersonId__c'));
                listEpisysUsers.put((string)item.get('PersonId__c'), episysUser);  
            }
        }
    }
       
    for(AggregateResult item : groupedResults)
    {
        if(((string)item.get('RecType__c')) != 'ACCT' && !memberFound.contains((string)item.get('PersonId__c')))
        {
            string episysUser = accountEpisysUser.get((string)item.get('Account_Number__c'));
            if(string.isNotBlank(episysUser) && string.isNotEmpty(episysUser))
            {
               memberFound.add((string)item.get('PersonId__c'));
            	listEpisysUsers.put((string)item.get('PersonId__c'), episysUser);    
            }
                     
        }
        
    }
    
    List<Account> listMainAccount = [select id,Created_By_Episys_User_Alias__c from Account where Id in: memberFound and Created_By_Episys_User_Alias__c = null];
    List<Episys_User__c> episysUserList = [select id,Name, Alias__c from Episys_User__c];
    Set<String> existingUsers = new Set<String>();
    
    for(Account acc: listMainAccount)
    {
        string memberUser = listEpisysUsers.get(acc.id);
        existingUsers.add(listEpisysUsers.get(acc.id));
        for(Integer i=0;i<episysUserList.size();i++)
        {
            String userAlias = episysUserList[i].Alias__c;
            if (existingUsers.contains(userAlias))
            {
                acc.Created_By_Episys_User_Alias__c = memberUser;
            }
        }
    }
    
    update listMainAccount;
    
    }

   global void finish(Database.BatchableContext BC){
   }
}