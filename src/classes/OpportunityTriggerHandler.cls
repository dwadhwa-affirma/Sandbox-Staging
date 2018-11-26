public class OpportunityTriggerHandler {
	
	public static boolean hasExecuted = false;
	
	private boolean m_isExecuting = false;
	
	private integer BatchSize = 0;

	public OpportunityTriggerHandler(boolean isExecuting, integer size )
	{
		m_isExecuting =  isExecuting;
		BatchSize = size;
	}
	
	public void OnBeforeInsert(Opportunity[] newOpportunities)
	{
			system.debug('Handler Called###');
		    string uid= UserInfo.getUserId();
		    User usr = [Select id, name, alias from User where id=:uid];
		    List<Episys_User__c> eusr = [SELECT id, alias__c, Assigned_Branch__c,Episys_ID__c, Branch_Name__c,Default__c from Episys_User__c 
		                                    where alias__c=:usr.alias order by Default__c desc]; 
		    Set<ID> accountid = new Set<Id>();
		    Id LoggedinUser = UserInfo.getUserId();
		    Set<Decimal> Episys_User_ID = new Set<Decimal>(); 
		    Set<String> branchnameSet = new Set<String>(); 
		    Set<String> MemAccId = new Set<String>();
		         
		              
		    for(Opportunity opp: newOpportunities)
		     {		     	
			        accountid.Add(opp.accountid);
			        MemAccId.Add(opp.Member_Account__c);
			        
			        if((opp.StageName == 'Closed Lost' || opp.StageName == 'Closed Won'))
			          {
			             opp.closedate = system.today();
			          }
			       
		            if(opp.Member_Type__c == 'Pre Member')
		            {
		            	opp.IsCreatedAsMember__c = false;
		            }  
		            else if(opp.Member_Type__c == 'Member'){
		            	opp.IsCreatedAsMember__c = true;
		            }         
		    }
		    
		    List<Account> accName = [Select Name, Id from Account where Id IN:accountid ];
        	for(Opportunity opp: newOpportunities)
            {
            	for(Account acc: accName)
            	{
                	if(opp.AccountId == acc.id )
                	{
                		opp.Opportunity_Name_Text__c = acc.Name;
                	}
            	}
            }
		    
		   
		    Map<id,String> MemAccMap = new Map<id,string>();
		    for(Account_Details__c ad : [select Id, Created_At_Branch1__c from Account_Details__c where id =:MemAccId AND Created_At_Branch1__c != null]){
		    	MemAccMap.put(ad.Id, ad.Created_At_Branch1__c);
		    }
		    
		   
		    
		    List<Person_Account__c> pa =[select id,Account_Number__c,Account_Number__r.Brand__c,Person_Account__c.PersonID__c ,Account_Number__r.RecType__c
		                            from Person_Account__c where PersonID__c IN : accountid];
		    List<Account> listAccountBrand = [select id,Parent_Lead__c,Parent_Lead__r.Brand__C from account where id in: accountid and Parent_Lead__c != null];
		     system.debug('accountid##'+ accountid);
		    system.debug('pa##'+ pa);
		     system.debug('listAccountBrand##'+ listAccountBrand);
		    for(Opportunity opp: newOpportunities)   
		     {
		               for(Account acc : listAccountBrand)
		                 {
		                            if(acc.id == opp.accountid && acc.Parent_Lead__c != null)
		                            {
		                                if(acc.Parent_Lead__r.Brand__C == 'CFCU'){
		                                    opp.Brand__c = 'Chevron';
		                                }
		                                else{   
		                                    opp.Brand__c = acc.Parent_Lead__r.Brand__C;
		                                }
		                                
		                                break;
		                            }   
		                        
		                 }
		                        
		                        
		                 boolean found = false;
		                 string brand = '';
		                 for(Person_Account__c item : pa)
		                    {
		                             system.debug('PersonID__c##'+ item.PersonID__c);
		                            if(opp.accountid == item.PersonID__c)
		                            {
		                            	 system.debug('RecType__c##'+ item.Account_Number__r.RecType__c);
		                                if(item.Account_Number__r.RecType__c == 'ACCT')
		                                {
		                                    opp.Brand__c = item.Account_Number__r.Brand__c;
		                                    break;
		                                }
		                                else{
		                                		opp.Brand__c = item.Account_Number__r.Brand__c;
		                                		
		                                    /*if(opp.Brand__c == '')
		                                    {
		                                        opp.Brand__c = item.Account_Number__r.Brand__c;
		                                    }*/
		                                }
		                                
		                                
		                            }
		                            
		                     }
		                
		                /* if(brand != '')
		                 {
		                     opp.Brand__c = brand;
		                        
		                 }*/
		                 /* logic to get branch detail from member account detail */
		                 if(opp.Member_Account__c != null && MemAccMap.containsKey(opp.Member_Account__c)){
		                 	
		                 	opp.Member_Branch__c = MemAccMap.get(opp.Member_Account__c);
		                 }
		                 
		                 
		                 
		    
		      }
		      
		      
		      for(Opportunity opp: newOpportunities)
		      {
		      		
		      //	if(opp.Mortgage_Loan_Officer__c == null && opp.Episys_User_ID__c != null)
		      	if(opp.Episys_User_ID__c != null)
		      	{
					Episys_User_ID.Add(opp.Episys_User_ID__c);
		      	}
		                
		      }
		      		
		      system.debug('Episys_User_ID###' + Episys_User_ID);
		      
		      List<Episys_User__c> episysUsers = [SELECT id, alias__c, Assigned_Branch__c,Episys_ID__c, Branch_Name__c,Default__c from Episys_User__c 
		                                    where Episys_ID__c in: Episys_User_ID];
		      Group OppQueue = new Group();   
		      String groupName = '';           
		      List<Group> listQueue = [select id,Name,Email from Group where Type = 'Queue' and (Email like '%lead.com' or Email like '%opportunity.com')];
		          
	           
    		  for(Opportunity opp: newOpportunities)
		      {
		      		system.debug('Above Conditions###');
		      		system.debug('Ownership__c###' + opp.Ownership__c);
		      		/*if(opp.Mortgage_Loan_Officer__c != null && opp.Is_Converted__c == false)
			        {
			        	system.debug('Condition Mortgage Officer###');
			            opp.Ownerid = opp.Mortgage_Loan_Officer__c;
			            opp.User_Owner__c = opp.Mortgage_Loan_Officer__c;
			        	opp.Queue_Owner__c = null;
			        }*/
			        //else if(opp.Ownership__c == 'Auto Assign' && opp.Mortgage_Loan_Officer__c == null && (opp.Opportunity_Source__c == 'Branch Walk in' || opp.Opportunity_Source__c == 'Branch Call')  && opp.Is_Converted__c == false)
			        if(opp.Ownership__c == 'Auto Assign' && (opp.Opportunity_Source__c == 'Branch Walk in' || opp.Opportunity_Source__c == 'Branch Call')  && opp.Is_Converted__c == false)
		      		{
		      			system.debug('opp.Episys_User_ID__c###' + opp.Episys_User_ID__c);
		      			system.debug('episysUsers###' + episysUsers);
		      			groupName = '';
		      			if(episysUsers.size() > 0)
		      			{
			      			for(Episys_User__c episysItem: episysUsers)
			      			{
			      				system.debug('episysItem.Episys_ID__c###' + episysItem.Episys_ID__c);
			      				if(opp.Episys_User_ID__c == episysItem.Episys_ID__c)
			      				{
			      					system.debug('Episys user matched###');
			      					string BranchQueue = episysItem.Branch_Name__c.replace(' ', '_').replace('-','_').replace('/','_').toLowerCase();
			      					system.debug('EBranchQueue###' + BranchQueue);
			      					for(Group grp : listQueue)
					      			{
					      				
					      				if(grp.Email.containsIgnoreCase(BranchQueue))
					      				{
					      					groupName = grp.Name;
					      					break;
					      				}
					      				
					      			}
			      				 	if(groupName!=null && groupName!='')
			      				 	{
			      				 		
			      				 		opp.Queue_Owner__c = groupName;	
			      				 		opp.User_Owner__c = null;
			      				 		opp.Ownership__c ='Keep';
			      				 	}
			      				 	else
			      				 	{
                                            system.debug('Condition Product Type###');
					      				 	string ProductType = opp.Product_Type__c.replace(' ', '_').replace('-','_').replace('/','_').toLowerCase();
					      				 	system.debug('ProductType###' + ProductType);
											for(Group grp : listQueue)
							      			{
							      				
							      				if(grp.Email.containsIgnoreCase(ProductType))
							      				{
							      					groupName = grp.Name;
							      					break;
							      				}
							      				
							      				
							      			}
							      			system.debug('groupName###' + groupName);
					      				 	if(groupName!=null && groupName!='')
					      				 	{
					      				 		opp.Queue_Owner__c = groupName;	
					      				 		opp.User_Owner__c = null;
					      				 		opp.Ownership__c ='Keep';
					      				 	}
			      				 	}
			      					break;
			      					
			      				}
			      			}
		      			}
		      			else
		      			{
		      					 		   system.debug('Condition Product Type###');
					      				 	string ProductType = opp.Product_Type__c.replace(' ', '_').replace('-','_').replace('/','_').toLowerCase();
					      				 	system.debug('ProductType###' + ProductType);
											for(Group grp : listQueue)
							      			{
							      				
							      				if(grp.Email.containsIgnoreCase(ProductType))
							      				{
							      					groupName = grp.Name;
							      					break;
							      				}
							      				
							      				
							      			}
							      			system.debug('groupName###' + groupName);
					      				 	if(groupName!=null && groupName!='')
					      				 	{
					      				 		opp.Queue_Owner__c = groupName;	
					      				 		opp.User_Owner__c = null;
					      				 		opp.Ownership__c ='Keep';
					      				 	}
			      				 	
		      			}
		      			
		      			
		      			
		      		}
                  else if(opp.Ownership__c == 'Auto Assign' && opp.Opportunity_Source__c == 'Event'){
                      		
                           string BranchQueue='';
                           groupname='';
                            if(eusr.size() > 0 && eusr[0].Default__c == true)
                            {
                               BranchQueue = eusr[0].Branch_Name__c.replace(' ', '_').replace('-','_').replace('/','_').toLowerCase();
                            }
                            else if(eusr.size() > 0 && eusr[0].Default__c == false){
                                BranchQueue = eusr[0].Branch_Name__c.replace(' ', '_').replace('-','_').replace('/','_').toLowerCase();
                            }
                      system.debug('EBranchQueue###' + BranchQueue);
                      if(BranchQueue != null && BranchQueue != ''){
                          for(Group grp : listQueue)
                          { 
                              if(grp.Email.containsIgnoreCase(BranchQueue))
                              {
                                  groupname = grp.Name;
                                  break;
                              }
                              system.debug('groupName###' + groupname);
                          }
                      }
                      if(groupname != null && groupname!=''){
                          //opp.Opportunity_Owner__c = groupnameid;
                          opp.Queue_Owner__c = groupName;	
                          opp.User_Owner__c = null;
                          opp.Ownership__c ='Keep';
                          
                      }
                      else{
                          system.debug('Condition Product Type###');
                          string ProductType = opp.Product_Type__c.replace(' ', '_').replace('-','_').replace('/','_').toLowerCase();                        
                          for(Group grp : listQueue)
                          {
                              if(grp.Email.containsIgnoreCase(ProductType))
                              {
                                  groupname = grp.Name;
                                  break;
                              }
                          }
                          system.debug('groupName###' + groupname);
                          if(groupname!=null && groupname!='')
                          {
                              //Opp.Opportunity_Owner__c = groupnameid;	
                              opp.Queue_Owner__c = groupName;	
                              opp.User_Owner__c = null;
                              opp.Ownership__c ='Keep';
                          }
                      }
                  } 
		      	//	else if(opp.Ownership__c == 'Auto Assign' && opp.Mortgage_Loan_Officer__c == null && (opp.Opportunity_Source__c != 'Branch Walk in' && opp.Opportunity_Source__c != 'Branch Call')  && opp.Is_Converted__c == false)
		      		else if(opp.Ownership__c == 'Auto Assign' && (opp.Opportunity_Source__c != 'Branch Walk in' && opp.Opportunity_Source__c != 'Branch Call')  && opp.Is_Converted__c == false)
		      		{
		      					system.debug('Condition Product Type###');
		      				 	string ProductType = opp.Product_Type__c.replace(' ', '_').replace('-','_').replace('/','_').toLowerCase();
		      				 	system.debug('ProductType###' + ProductType);
								for(Group grp : listQueue)
				      			{
				      				
				      				if(grp.Email.containsIgnoreCase(ProductType))
				      				{
				      					groupName = grp.Name;
				      					break;
				      				}
				      				
				      				
				      			}
				      			system.debug('groupName###' + groupName);
		      				 	if(groupName!=null && groupName!='')
		      				 	{
		      				 		opp.Queue_Owner__c = groupName;	
		      				 		opp.User_Owner__c = null;
		      				 		opp.Ownership__c ='Keep';
		      				 	}
		      				 	
		      		}
		      		
		      }	
    		 
    				    
		    
		        	
		        	
		        	
		        	
                        
	}
	
	
	
	public void OnBeforeUpdate(Opportunity[] Opportunities, Map<ID, Opportunity> OpportunityNewMap, Map<ID, Opportunity> OpportunityOldMap)
	{
 system.debug('----------------------------Limit'+Limits.getQueries());
		string uid= UserInfo.getUserId();
		    User usr = [Select id, name, alias from User where id=:uid];
		 /*   List<Episys_User__c> eusr = [SELECT id, alias__c, Assigned_Branch__c,Episys_ID__c, Branch_Name__c,Default__c from Episys_User__c 
		                                    where alias__c=:usr.alias order by Default__c desc];*/ 
		Id LoggedinUser = UserInfo.getUserId();
		Set<Decimal> Episys_User_ID = new Set<Decimal>(); 
		Set<String> branchnameSet = new Set<String>(); 
		Group OppQueue = new Group();   
		String groupName = '';   
		List<Decimal> ListEpisysIds = new List<Decimal>();
		Set<id> QueOppId = new Set<id>();
		for(Opportunity opp: Opportunities)
	    {
	    	if(opp.Queue_Owner__c != null && opp.Queue_Owner__c !=''){
	    		QueOppId.add(opp.id);
	    	}
	    	if(opp.Episys_User_ID__c != null)
	    	{
	    	 ListEpisysIds.add(opp.Episys_User_ID__c);
	    	}
	    }
		
		List<Episys_User__c> euser = [SELECT id,alias__c, Assigned_Branch__c,Episys_ID__c, Branch_Name__c,Default__c 
						from Episys_User__c where Episys_ID__c  in: ListEpisysIds];
	      	
		for(Opportunity opp: Opportunities)
	    {
	    	opp.Branch_of_Lead_creator__c =   '';
	    	for(Episys_User__c episysid : euser)
	    	{
	    		if(episysid.Episys_ID__c == opp.Episys_User_ID__c)
	    		{
	    			 opp.Branch_of_Lead_creator__c =   episysid.Branch_Name__c;
	    			 	Episys_User_ID.Add(opp.Episys_User_ID__c);
	    			 	break;
	    		}
	    	
	    	}
	    }
	      	
	      /*	 if(euser.size() > 0){
			              opp.Branch_of_Lead_creator__c =   euser[0].Branch_Name__c;
			              //opp.Member_Branch__c =   euser[0].Branch_Name__c;
			              
			          }	
			  else
			  {
			  	opp.Branch_of_Lead_creator__c =   '';
			  	//opp.Member_Branch__c =   '';
			  }
		  //  if(opp.Mortgage_Loan_Officer__c == null && opp.Episys_User_ID__c != null)
		  	if(opp.Episys_User_ID__c != null)
		    {
					Episys_User_ID.Add(opp.Episys_User_ID__c);
		    }*/
	                
        
        List<Group> listQueue = [select id,Name,Email from Group where Type = 'Queue' and (Email like '%lead.com' or Email like '%opportunity.com')];
	     List<Episys_User__c> episysUsers = [SELECT id, alias__c, Assigned_Branch__c,Episys_ID__c, Branch_Name__c,Default__c from Episys_User__c 
		                                    where Episys_ID__c in: Episys_User_ID];
		                                    
		/* set<id> setOpp = new Set<id>();
        	  for(Opportunity Opp1 : [select id,Name from Opportunity where Owner.Type = 'Queue' and id IN :QueOppId]){
        	 	
        	 	SetOpp.add(Opp1.id);
        	  }*/
        	  
        	  system.debug('----------------'+QueOppId) ;   
		                                             
       		for(Opportunity opp: Opportunities)
        	{		
                 	Opportunity oldOpp = OpportunityOldMap.get(opp.Id);
                 	 system.debug('-----opp.StageName-----------'+opp.StageName) ;  
                 	if(QueOppId.contains(opp.id) && (opp.StageName == 'Closed Won' || opp.StageName == 'Closed Lost')){
            	 		opp.Adderror('Queue owned opportunities cannot be closed.');
            	 	}
                 	if((oldOpp.StageName == 'Closed Won' || oldOpp.StageName == 'Closed Lost') && opp.Allow_Error__c == false)
            	 	{
            	 		opp.Adderror('Opportunity fields are read only for Closed Opportunity.');
            	 		
            	 	}
            	 	else{
	                if(opp.Is_Converted__c && oldOpp.Opportunity_Source__c != opp.Opportunity_Source__c)
	                {
	                    opp.Adderror('Opportunity Source is read only for Opportunity converted from Lead.');
	                }
	                if(opp.Is_Converted__c && oldOpp.Brand__C != opp.Brand__C)
	                {
	                    opp.Adderror('Brand is read only for Opportunity converted from Lead.');
	                }
	                if(opp.Is_Converted__c && oldOpp.Product_Type__c != opp.Product_Type__c)
	                {
	                    opp.Adderror('Product Type is read only for Opportunity converted from Lead.');
	                }
	                if(opp.Is_Converted__c && oldOpp.Product_Sub__c != opp.Product_Sub__c)
	                {
	                    opp.Adderror('Product Subtype is read only for Opportunity converted from Lead.');
	                }
	                
	                if(oldOpp.How_did_you_hear_about_us__c != opp.How_did_you_hear_about_us__c)
	                {
	                    opp.Adderror('How did you hear about us is read only for Opportunity converted from Lead.');
	                }
	                
	                if(opp.Is_Converted__c && oldOpp.Event_Source__c != opp.Event_Source__c)
	                {
	                    opp.Adderror('Event Source is read only for Opportunity converted from Lead.');
	                }
	                if(oldOpp.closedate != opp.closedate)
	                {
	                     opp.Adderror('Close date is read only');
	                }
	                if(oldOpp.AccountId != opp.AccountId && ((oldOpp.IsMemberOpportunity__c == opp.IsMemberOpportunity__c) && opp.IsMemberOpportunity__c == false && opp.Allow_Error__c == false))
	                {
	                     opp.Adderror('Member name is read only');
	                }
	              
	                if(oldOpp.Name != null && oldOpp.Name !='Name' && oldOpp.Name != opp.Name)
	                {
	                     opp.Adderror('Opportunity Number is read-only');
	                }
	                if((opp.StageName == 'Closed Lost' || opp.StageName == 'Closed Won') && oldOpp.StageName != opp.StageName)
	                {
	                    opp.closedate = system.today();
	                } 

		      /*         if(opp.Is_Converted__c && oldOpp.Member_Branch__c != opp.Member_Branch__c)
		               {
		                 opp.Adderror('Member Branch is read only for Opportunity converted from Lead.');
		               }
		        */      
	              
	               if(oldOpp.Lead_Episys_User_ID__c != opp.Lead_Episys_User_ID__c)
	               {
	                 opp.Adderror('Lead Episys User Id is read only');
	               }
	               
	               if((opp.StageName != 'Closed Lost' && opp.StageName != 'Closed Won') && oldOpp.StageName != opp.StageName)
	                {
	                    opp.closedate = date.ValueOf('2048-12-31');
	                   
	                }
            	 	}
	               if(opp.Allow_Error__c == true)
	               {
	               		opp.Allow_Error__c = false;
	               }
	              
	             
	             /*  if(oldOpp.Mortgage_Loan_Officer__c != opp.Mortgage_Loan_Officer__c && opp.Mortgage_Loan_Officer__c!=null )
	               {
		                 opp.Ownerid = opp.Mortgage_Loan_Officer__c;
		                 opp.User_Owner__c = opp.Mortgage_Loan_Officer__c;
				         opp.Queue_Owner__c = null;
	               }*/	               
	             /*  else if(opp.Ownership__c == 'Auto Assign' && opp.Mortgage_Loan_Officer__c == null &&(opp.Opportunity_Source__c == 'Branch Walk in' || opp.Opportunity_Source__c == 'Branch Call'))
		      		{
		      			groupName = '';
		      			for(Episys_User__c episysItem: episysUsers)
		      			{
		      				
		      				if(opp.Episys_User_ID__c == episysItem.Episys_ID__c)
		      				{
		      					string BranchQueue = episysItem.Branch_Name__c.replace(' ', '_').replace('-','_').replace('/','_').toLowerCase();
		      					for(Group grp : listQueue)
				      			{
				      				
				      				if(grp.Email.containsIgnoreCase(BranchQueue))
				      				{
				      					groupName = grp.Name;
				      					break;
				      				}
				      				
				      			}
		      				 	if(groupName!=null || groupName!='')
		      				 	{
		      				 		opp.Queue_Owner__c = groupName;	
		      				 		opp.User_Owner__c = null;
		      				 	}
		      					break;
		      					
		      				}
		      			}
		      		}
		      		
		      		else if(opp.Ownership__c == 'Auto Assign' && opp.Mortgage_Loan_Officer__c == null && (opp.Opportunity_Source__c != 'Branch Walk in' && opp.Opportunity_Source__c != 'Branch Call'))
		      		{
		      				 	groupName = '';
				      		string ProductType = opp.Product_Type__c.replace(' ', '_').replace('-','_').replace('/','_').toLowerCase();
								for(Group grp : listQueue)
				      			{
				      				
				      				if(grp.Email.containsIgnoreCase(ProductType))
				      				{
				      					groupName = grp.Name;
				      					break;
				      				}
				      				
				      				
				      			}
		      				 	if(groupName!=null || groupName!='')
		      				 	{
		      				 		opp.Queue_Owner__c = groupName;	
		      				 		opp.User_Owner__c = null;
		      				 	}
		      		}*/
        	}
        	
 

    }
	

   
}