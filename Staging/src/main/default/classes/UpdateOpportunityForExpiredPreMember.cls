public  class UpdateOpportunityForExpiredPreMember implements Schedulable {
	
		public void execute(SchedulableContext obj)
        {
        	List<Account> acclist = [Select id from Account
                         	where RecordType.Name = 'Pre Member' and Expired__c =true and ISConverted__c = false and OpportunitiesClosed__c = false];
							Set<Id> accid = new Set<Id>();
							for(Account a: acclist )
							{
							   accid.add(a.id); 
							}
							system.debug('acclist##' + acclist);
							List<Opportunity> opplist = [Select id,StageName, Accountid, Queue_Owner__c from Opportunity
							                             	where Accountid IN:accid and (StageName !='Closed Lost' and StageName !='Closed Won')];
							                             	
							 List<Group> listQueue = [select id,Name,Email from Group where Type = 'Queue' and (Email like '%lead.com' or Email like '%opportunity.com')];
							  
							 Set<id> QueOppId = new Set<id>();
							 User MARSUser = [SELECT Id, name from user where name ='MARS System'];
							 set<Id> OpportunityIdSet = new set<Id>();
							 
							for(Opportunity opp: opplist)
						    {
						    	if(opp.Queue_Owner__c != null && opp.Queue_Owner__c !=''){
						    		QueOppId.add(opp.id);
						    	}	
						    	 OpportunityIdSet.add(opp.id);					    	
						    }
						    
						    for(Opportunity opp: opplist){
						    	if(QueOppId.contains(opp.id)){
						    		opp.User_Owner__c = MARSUser.id;
	            					opp.Queue_Owner__c = null;
						    	}
						    }
							system.debug('opplist##' + opplist);
							
							
							
							List<Task> taskList = [SELECT Id, WhatId FROM Task WHERE IsClosed=false AND WhatId IN :OpportunityIdSet]; 
							
							for(Task t :taskList ){
								t.Status = 'Completed';
							}
							
							update taskList;
							
							List<Opportunity> updateopp = new List<Opportunity>();
							for(Opportunity o :opplist )
							{
							    o.StageName ='Closed Lost';
							    o.Sub_Status__c ='Expired';
							    updateopp.add(o);
							}
							system.debug('updateopp##' + updateopp);							
							
							if(!updateopp.IsEmpty())
							update updateopp;
							
							for(Account a:acclist )
							{
							    a.OpportunitiesClosed__c = true;
							}
							
							update acclist;
        	
        }
    
}