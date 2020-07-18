global class ImpendingDormancyCloseOpportunityBatch implements Database.Batchable<sObject>{
	
	 global Database.QueryLocator start(Database.BatchableContext BC){
	 	
    	return Database.getQueryLocator('select id,StageName,Member_Account__c,AccountId,User_Owner__c,Queue_Owner__c from Opportunity where isTriggeredOpportunity__c = true and StageName != \'Closed Lost\' ');

	 
	 }
	  global void execute(Database.BatchableContext BC, List<Opportunity> opplist){
	  	Triggered_Opportunity_Configurations__c cs = Triggered_Opportunity_Configurations__c.getValues('Primary Record');
    	Integer Inactivity_Days =0;
    	Inactivity_Days = (Integer)cs.Impending_Dormancy_Inactivity_Days__c*(-1);    	
    	date LastNDays = system.today().addDays(Inactivity_Days);
    	
	  	User MARSUser = [SELECT Id, name from user where name ='MARS System'];
	  
	  	set<id> memberIds = new set<id>();
	  	set<id> MemberAccountIds = new set<id>();
	  	map<id,boolean> DormancyOppCreated= new map<id,boolean>();
	  	
	  	 List<string> accountNumberSet = new List<string>();
	  	 
	  	for(Opportunity item : opplist)
	  	{        	

            memberIds.add(item.AccountId);           
        }  	
	  	
	  	
	  	
	  	Set<id> listParentAccounts = new Set<id>();
	  	Map<id,id> mapParentACChildAC = new Map<id,id>();
	  	Map<id,id> mapParentMember = new Map<id,id>();
	  	
	  	Map<Id,Account> MList = new Map<Id,Account>([select id, DormancyOppCreated__c, DormancyMemberAccounts__c from Account where id in: memberIds]);
	  		  
	  	
	  	for(Account_Details__c item : [select id, DormancyOppCreated__c,Parent_Account__c from Account_Details__c where (Activity_Date__c >: LastNDays or Correspondence_Date__c >: LastNDays) and DormancyOppCreated__c = true])
        {	
        	if(!listParentAccounts.contains(item.Parent_Account__c))
			{
				listParentAccounts.add(item.Parent_Account__c);
			}  
			mapParentACChildAC.put(item.id,item.Parent_Account__c);
        }
	  	
	  	for(Person_Account__c pa : [SELECT Id,Account_Number__c,PersonId__c,PersonId__r.DormancyOppCreated__c FROM Person_Account__c where Account_Number__c in: listParentAccounts and PersonId__c in: memberIds and TypeTranslate__c = '0000/Primary'])
        {
			mapParentMember.put(pa.Account_Number__c,pa.PersonId__c);	
        }
	  	
	  	
	  	List<Account_Details__c> lstMAToUpdate =[select id, DormancyOppCreated__c,Parent_Account__c from Account_Details__c where (Activity_Date__c >: LastNDays or Correspondence_Date__c >: LastNDays)
	  			and DormancyOppCreated__c = true and Parent_Account__c in: mapParentMember.keyset()];
	  	
	   		system.debug('mapParentMember###'+ mapParentMember);
	    for(Account_Details__c item : lstMAToUpdate)
        {	
	   		item.DormancyOppCreated__c = false;
	   		
	   		system.debug('item.Parent_Account__c###'+ item.Parent_Account__c);
	   		system.debug('item.id###'+ item.id);
	   		
	   		string memberid = mapParentMember.get(item.Parent_Account__c);
	   		
	   		Account acc = MList.get(memberid);
	   		
	   		string impendingAccountForMembers = acc.DormancyMemberAccounts__c;
	   		if(string.IsNotBlank(impendingAccountForMembers) && string.isNotEmpty(impendingAccountForMembers))
	   		{
	   			set<string> accounts = new Set<string>(impendingAccountForMembers.split(','));
	   			accounts.remove(item.id);
	   			List<String> accountslist = new List<String>(accounts);
	   			acc.DormancyMemberAccounts__c = string.join(accountslist,',');
	   			if(string.IsNotBlank(acc.DormancyMemberAccounts__c) && string.isNotEmpty(acc.DormancyMemberAccounts__c))
	   			{
	   				
	   			}
	   			else
	   			{
	   				acc.DormancyOppCreated__c = false;
	   			}
	   		}
	    }
	  	
	  	
	  	update lstMAToUpdate;
	  	update MList.values();
	 
	  	
	  	for(Opportunity item : opplist)
	  	{        	

            Account acc = MList.get(item.accountid);
            if(acc.DormancyOppCreated__c == false)
            {
				item.StageName = 'Closed Lost';
				 if(item.User_Owner__c == null)
	            {
	            	item.User_Owner__c = MARSUser.id;
	            	item.Queue_Owner__c = null;
	            	item.Sub_Status__c = 'No Contact';   
	            }            	
            }   
           
        } 
        update opplist;
	  	

	  }
	  
	   global void finish(Database.BatchableContext BC){
   	}
    
}