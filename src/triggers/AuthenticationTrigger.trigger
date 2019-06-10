trigger AuthenticationTrigger on Authenticated_Log__c (before insert, before update, after insert, after update) {

  public string uid= UserInfo.getUserId();

   if(trigger.isbefore){
        if(trigger.isUpdate){
        updateMember(Trigger.new);
    }
    
    if(trigger.isInsert){
        updateMember(Trigger.new);
       // updateStaff(Trigger.new);
    }
    
   }
   
     if(trigger.isafter){		
     /*  Fixed issue with Staff details   */
	    if(RecursiveHandler.isNotRecursive)
	    {
			 updateStaff(Trigger.new);	       
	    }
			  
		   
     }
   
      
   

    public void updateMember(List<Authenticated_Log__c> auth){
   //Start: CRM-1448 changes - DB
       List<Account> act = new List<Account>();
       List<Person_Account__c> prsn;
       list<Id> sfid = new list<Id>();
       map<id, Account> mapAccount = new map<id, Account>();
       map<id, Person_Account__c> mapPersonAccount = new map<id, Person_Account__c>();
      // List<Account_details__c> ActNum;
      
       for(Authenticated_Log__c au:Trigger.new){       
         if (au.SalesforceID__c != 'null' && au.SalesforceID__c != '' && au.SalesforceID__c != null)     //CRM-1490 - added null check 
           sfid.add(au.SalesforceID__c);       
       }       
    
       if(sfid.size() >0) //CRM-1490 - added null check 
        act = [Select id, Email_raw__c, FirstName, PersonID__c  from Account where id IN: sfid];
        
        //Removed Brand as quering person account is expensive
        // prsn = [Select id, Brand__c, Account_Number__c, RecType__c, PersonID__c from Person_Account__c where PersonID__c IN: sfid];
        
         //CRM-1490 - added size check 
        if(act.size() > 0){ 
          for(account a: act){
            mapAccount.put(a.id, a);
          }
        }
        
        //Removed person account as quering person account is expensive
        /*for(Person_Account__c p: prsn){
          mapPersonAccount.put(p.PersonID__c, p);
        }*/
        
         /* Updating First Name and Last Name based on Salesforce ID*/
        for(Authenticated_Log__c au:Trigger.new){ 
           //CRM-1490 - added null check 
          if (au.SalesforceID__c != 'null' && au.SalesforceID__c != '' && au.SalesforceID__c != null){
              account acct = mapAccount.get(au.SalesforceID__c);            
              if(acct != null){
                if(acct.Email_raw__c != null)
                  au.Email_New__c = acct.Email_raw__c;                
                    if(acct.FirstName != null)
                    au.First_Name__c = acct.FirstName;
                    if(acct.PersonID__c != null)
                    au.PersonId__c = acct.PersonID__c;
              }
            }
        
        }
             
      /* if (auth[0].SalesforceID__c != '')
        {
        act = [Select id, Email_raw__c, FirstName, PersonID__c  from Account where id =:auth[0].SalesforceID__c]; 
        
        }*/
       if (act.size() > 0)
       {
                      
            //prsn = [Select id, Brand__c, Account_Number__c, RecType__c from Person_Account__c where PersonID__c =:act[0].ID];
            //system.debug('prsn number of records::::' + prsn.size()); 
           // system.debug('Member Name number of records::::' + act.size());
            
                      
           /*  if(prsn.size()>0){
            for(Authenticated_Log__c au:Trigger.new){
                 
                     //Commenting for production deployment since these fields don't exist 
                              au.Email_New__c = act[0].Email_raw__c;
                              au.Brand__c = prsn[0].Brand__c;
                              au.First_Name__c = act[0].FirstName;
                              au.PersonId__c = act[0].PersonID__c;
                          
                            
                            
               } 
            
                
                
                
       }*/
       
        /*  Fixed issue with Staff details   */
      /* List<user> usr = [Select id, alias, Name from user where id=:uid];
      system.debug('current user id is :::' + uid);
      system.debug('current user alias is :::' + usr[0].alias);
     
         //Commenting for production deployment since these fields don't exist 
         List<Episys_User__c> epId = [Select id, Episys_ID__c, Branch_Name__c from Episys_User__c where alias__c = :usr[0].alias];
         //List<Episys_User__c> epId = [Select id from Episys_User__c where alias__c = :usr[0].alias];
         if(epId.size()>0){ 
            // auth[0].Staff_Episys_Id__c = epId[0].Episys_ID__c;
             system.debug('current user ep.alias is :::' + usr[0].alias);
             //system.debug('current user ep.id is :::' + epId[0].Episys_ID__c);
              for(Authenticated_Log__c au:Trigger.new){
                 au.Staff_Episys_ID__c = epId[0].Episys_ID__c;
                 au.Staff_Name__c = usr[0].Name;
              }
             
         }*/
         
     
           
       }
   }
   
     /*  Fixed issue with Staff details   */
    public void updateStaff(List<Authenticated_Log__c> auth){
    	RecursiveHandler.isNotRecursive = false;
			       
			        list<Id> uid = new list<Id>();
		    	 map<string, decimal> mapepisys = new map<string, decimal>();
		    	 map<id, string> mapalias = new map<id, string>();
		    	  set<string> setalias = new set<string>();
		    	  List<id> setauIds = new List<id>();
		    	   map<id, string> mapName = new map<id, string>();
		    	 
		    	  for(Authenticated_Log__c au:auth){ 	       
			       		uid.add(au.CreatedById);   
			       		setauIds.add(au.id);    
			       		
			       }
			       
			       List<user> usr = [Select id, alias, Name from user where id IN:uid];
			       for(User u:usr){ 	
			       		mapalias.put(u.id,u.alias);	  
			       		setalias.add(u.alias);     
			       		mapName.put(u.id, u.Name);
			       } 
			       
			       system.debug('setauIds----'+setauIds);
			       
			       List<Episys_User__c> epId = [Select id, Episys_ID__c, Branch_Name__c, alias__c from Episys_User__c where alias__c in: setalias];
			       for(Episys_User__c eu: epId){
			      			mapepisys.put(eu.alias__c, eu.Episys_ID__c);
			       
			       }
		    	 List<Authenticated_Log__c> logsToUpdate = [select id, CreatedById from Authenticated_Log__c where id in: setauIds];
		    	 
		    	 system.debug('logsToUpdate----'+logsToUpdate);
		    	 
		    	     	 
		    	  for(Authenticated_Log__c au:logsToUpdate){
		    	  		string userAlias = mapalias.get(au.CreatedById);
		    	  		decimal eid = mapepisys.get(userAlias);
		                 au.Staff_Episys_ID__c = eid;
		                 system.debug('au.createdBy.Name=='+mapName.get(au.CreatedById));
		                 system.debug('au.createdById=='+au.createdById);
		                 au.Staff_Name__c = mapName.get(au.CreatedById);
		              }
		    	update logsToUpdate;
	          RecursiveHandler.isNotRecursive = true;
    
    }
   
   
}