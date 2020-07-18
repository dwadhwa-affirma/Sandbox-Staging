public without sharing class CaseMemberNameChange {
    
    		@AuraEnabled 				
			public static List<object> GetMemberNameList(String Caseid)
			{
				Boolean Iseligible = false;
				List<object> listObj = new List<object>(); 
				List<GroupMember> GroupMemberList = new List<GroupMember>();
				user CurrentUser = [Select Id, UserRoleId,Email,ForecastEnabled ,Alias, Managerid  from user where id = :UserInfo.getUserId() LIMIT 1];
				
				
				
				GroupMemberList = [SELECT GroupId,Id,UserOrGroupId, Group.Type FROM GroupMember where  Group.Name='CaseMemberNameChange'];
				
				for(GroupMember gm : GroupMemberList)
				{
					if(gm.UserOrGroupId == CurrentUser.id )
					{
						Iseligible = true;
					}
					
				}
				List<boolean> eligible = new List<boolean>();
				eligible.add(Iseligible);
				listObj.add(eligible);
				List<Person_Account__c> PersonAccountlist = new List<Person_Account__c>();	
				Set<Id> PersonAccountId = new Set<Id>();						
				if(Iseligible == true)
				{
					Case cs = new Case();
					cs = [SELECT AccountId,Account_Number__c, Account_Number__r.Name ,CaseNumber , id, Account_Number__r.id FROM Case where id =:Caseid];
					list<Person_Account__c> paList = new list<Person_Account__c>();
					
				    	/*Account_Details__c accDetails = [Select Parent_Account__c,RecType__c,RecordType.Name from Account_Details__c where Id=:cs.Account_Number__c Limit 1];
				    	List<string> listStringIds = new List<string>();
				    	listStringIds.add(cs.Account_Number__c);
				    	if(accDetails.Parent_Account__c != null)
				    	{
				    		listStringIds.add(accDetails.Parent_Account__c);
				    		List<Account_Details__c> accDetailsList = [Select Parent_Account__c,RecType__c,RecordType.Name from Account_Details__c where Parent_Account__c=:accDetails.Parent_Account__c];
				    		for(Account_Details__c item: accDetailsList )
				    		{
				    			
				    			listStringIds.add(item.id);
				    		}
				    	}
				    	else
					    {
					    	List<Account_Details__c> accDetailsList = [Select Parent_Account__c,RecType__c,RecordType.Name from Account_Details__c where Parent_Account__c=:accDetails.Id];
				    		for(Account_Details__c item: accDetailsList )
				    		{
				    			
				    			listStringIds.add(item.id);
				    		}
					    }*/
				    	paList = [SELECT Id,
				                          Account_Number__c,
				                          PersonId__c,
				                          PersonID__r.Name,
				                          TypeTranslate__c FROM Person_Account__c WHERE Account_Number__r.Name =: cs.Account_Number__r.Name and TypeTranslate__c !=: '0004/Beneficiary'];
				    	
				    	
				    	AggregateResult[] groupedResults
						  = [SELECT 
				                          PersonId__c,
				                          PersonID__r.Name acctName,
				                          TypeTranslate__c FROM Person_Account__c WHERE Account_Number__r.Name =: cs.Account_Number__r.Name  and TypeTranslate__c !=: '0004/Beneficiary' group by PersonId__c,PersonID__r.Name,TypeTranslate__c ];
				    	list<Person_Account__c> paList1 = new list<Person_Account__c>();
				    	for (AggregateResult ar : groupedResults)  {
				    		Person_Account__c item = new Person_Account__c();
				    		item.PersonId__c = (string)ar.get('PersonId__c');
				    		item.PersonID__r = new Account();
				    		item.PersonID__r.Name = (string)ar.get('acctName');
				    		item.TypeTranslate__c = (string)ar.get('TypeTranslate__c');
				    		paList1.add(item);
						}
				    	
				    	//return paList1;
					
					 list<Account> accList = new list<Account>();
					/*Case cs = new Case();
					cs = [SELECT AccountId,Account_Number__c, Account_Number__r.Name ,CaseNumber , id, Account_Number__r.id FROM Case where id =:Caseid];
					List<Account_Details__c> acc = [Select Id,
                      Name,
                      Brand__c,
                      RecType__c,
                      Reference__c, Parent_Account__r.Name,Parent_Account__c,RecordType.Name FROM Account_Details__c Where Id=:cs.Account_Number__c limit 1];
                       list<Person_Account__c> paList = new list<Person_Account__c>();
				         if(acc[0].RecordType.Name == 'Membership'){
				        	if(acc[0].Parent_Account__r.Name != null)
				        	{
				        		string pid;
				        		pid	= acc[0].Parent_Account__c;
				            	paList = [SELECT Id,Account_Number__c, PersonID__c, Account_Number__r.RecType__c,Account_Number__r.Name,PersonID__r.Name,TypeTranslate__c FROM Person_Account__c WHERE Account_Number__c =:acc[0].id or Account_Number__c=:pid];
				        	}
				        	else
				        	{
				        		paList = [SELECT Id,Account_Number__c, PersonID__c, Account_Number__r.RecType__c,Account_Number__r.Name,PersonID__r.Name,TypeTranslate__c FROM Person_Account__c WHERE Account_Number__c =:acc[0].id];
				        	}
				        }
				        else
				        {
				        	string accId1;
				        	if(acc[0].Parent_Account__r.Name != null){
				              accId1 = acc[0].Parent_Account__c;
				              paList = [SELECT Id,
				                             Account_Number__c, 
				                             PersonID__c,
				                             Account_Number__r.RecType__c, 
				                             Account_Number__r.Name,
				                             PersonID__r.Name,
				                             RecType__c,
				                             TypeTranslate__c FROM Person_Account__c WHERE Account_Number__c =:cs.Account_Number__c OR Account_Number__c =:accId1];
				            }else{
				            	paList = [SELECT Id,
				                             Account_Number__c, 
				                             PersonID__c,
				                             Account_Number__r.RecType__c, 
				                             Account_Number__r.Name,
				                             PersonID__r.Name,
				                             RecType__c,
				                             TypeTranslate__c FROM Person_Account__c WHERE Account_Number__c =:cs.Account_Number__c];
				            }
				        }
                    	system.debug('ABC1233##');
				        system.debug('paList##'+paList);
                    	system.debug('ABC##');*/
				         set<String> accountNumberSet = new set<String>();
				        set<Id> accIdset = new set<Id>();
				        set<String> acctypeSet = new set<String>();
				        
				        for(Person_Account__c var: paList1)
				        {
				            accountNumberSet.add(var.PersonID__r.Name);
				            acctypeSet.add(var.Account_Number__r.RecType__c);
				            accIdSet.add(var.PersonID__c);
				        }
				        
        
        			system.debug('accIdset##'+accIdset);
			           accList = [Select Id,Name FROM Account Where Id IN:accIdSet];
                        system.debug('Without Membership##'+accList);
       					   
				        if(!accList.IsEmpty())
						{    
				       	  listObj.add(accList); 	
						}
				}
			            
          			
						
					
				
				
				system.debug('List of Object'+listObj);
				
				return listObj;
									
			/*	if(Iseligible == true)
				{
					Case cs = new Case();
					cs = [SELECT AccountId,Account_Number__c, Account_Number__r.Name ,CaseNumber , id, Account_Number__r.id FROM Case where id =:Caseid];
					
					PersonAccountlist = [SELECT AccountID__c,Account_Number__c,Account_Type__c,Id,PersonAccount__c,PersonID__c, Person_ID_Number__c 
										FROM Person_Account__c where Account_Number__c =: cs.Account_Number__c];
					for(Person_Account__c pa:PersonAccountlist )
					{
						PersonAccountId.add(pa.PersonID__c);
					}
					List<Account> actname = new List<Account>();
					system.debug('PersonAccountId##'+PersonAccountId);
					actname = [Select id, Name from Account where id IN:PersonAccountId ];
					system.debug('actname##'+actname);
					if(!actname.IsEmpty())
					{
						listObj.add(actname);
					}
				}*/
			
			}
			
			@AuraEnabled 				
			public static void UpdateCase(String Caseid, String Memberid)
			{
				Case cs = new Case();
				cs = [SELECT AccountId,Account_Number__c, Account_Number__r.Name ,CaseNumber , id, Account_Number__r.id FROM Case where id =:Caseid];
				cs.AccountId = Memberid;
				update cs;
				
			}
			
}