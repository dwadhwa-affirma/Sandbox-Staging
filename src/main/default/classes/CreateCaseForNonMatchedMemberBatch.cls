global class CreateCaseForNonMatchedMemberBatch implements Database.Batchable<sObject> {
    
 global Database.QueryLocator start(Database.BatchableContext BC){
     		
     		MemberConversionSetting__c mcs = MemberConversionSetting__c.getValues('PrimaryRecord');
            Integer Days_Automation =0;
            Days_Automation = (Integer)mcs.Not_matched_Members_cut_off_window__c;   
            Days_Automation = (Days_Automation) ;
          //  datetime LastNDays = system.now().addDays(Days_Automation);
           
            BusinessHours  bh = [SELECT Id, MondayEndTime, MondayStartTime FROM BusinessHours WHERE IsDefault=true];
            integer businessduration = bh.MondayEndTime.hour() - bh.MondayStartTime.hour(); 
            
            integer j = Days_Automation;
            integer hours = Days_Automation * 10 * (-1);
            
            datetime businessdays3 = BusinessHours.addGmt(bh.id, system.now(), 3600000 * hours); 
			Timezone tz = Timezone.getTimeZone('America/Los_Angeles');
			
          				
			//DateTime dt1 = system.Now().addDays(-j);
			DateTime dt1 = businessdays3.addSeconds(tz.getOffset(businessdays3) / 1000);
            
            Datetime dt = BusinessHours.add(bh.id, System.now(), -3600000 * businessduration );
      		System.debug('Start method called');
     		System.debug('Start query called' +  Database.getQueryLocator('SELECT Id, Owner.Name, FirstName,LastName, Ownerid, Is_Case_Created__c, Created_By_Episys_User_Alias__c FROM Account ' + 
                                      	' where RecordType.Name = \'Person Account\' and IsConverted__c=false and Is_Case_Created__c = false ' +
            					  ' and createddate >= ' + string.valueof(dt1).replace(' ','T') + '.000+0000 and  createddate <= ' + string.valueof(dt).replace(' ','T') + '.000+0000'));
     
			return Database.getQueryLocator('SELECT Id, Owner.Name, FirstName,LastName, Ownerid, Is_Case_Created__c, Created_By_Episys_User_Alias__c FROM Account ' + 
                                      	' where RecordType.Name = \'Person Account\' and IsConverted__c=false and Is_Case_Created__c = false ' +
            					  ' and createddate >= ' + string.valueof(dt1).replace(' ','T') + '.000+0000 and  createddate <= ' + string.valueof(dt).replace(' ','T') + '.000+0000');
    
      
   }
    global void execute(Database.BatchableContext BC, List<Account> acclist){
    	system.debug('acclist##' + acclist);
        Set<ID> accountIds = new Set<Id>();
        Set<ID> newAccountIds = new Set<Id>();
        Set<ID> newAccountIds2 = new Set<Id>();
        Set<ID> test = new Set<Id>();
        Set<String> aliaslist = new Set<String>();
        Map<Id, String> accaliasmap = new Map<Id, String>();
        List<user> listUser = new List<user>();
        Set<string> listUserAlias = new Set<string>();
        
     	for(Account s : acclist){
	     	accountIds.add(s.id);
         

	    }
    	                
        system.debug('listUser.size()##'+ listUser);
        system.debug('accountIds##'+ accountIds);
        system.debug('acclist'+ acclist.size());
        if(accountIds.size() > 0)
        {
            List<FeedItem> FeedItemlist = new List<FeedItem>(); 
            List<Account> updateacclist = new List<Account>();
            
            //--------------------------------------------- CRM-1680------------------------------------------------------------------------//
            
            //List<Person_Account__c> paList = [SELECT Id,Ownerid, PersonID__c,Account_Number__r.RecType__c, Account_Number__c,Account_Number__r.Created_By_User_Alias__c FROM Person_Account__c WHERE 
            //                                          PersonID__c =: accountIds and (TypeTranslate__c like '%PRIMARY%') and Account_Number__r.RecType__c = 'ACCT' Order by PersonID__c];
          
            
            List<AggregateResult> paList = [SELECT Count(id), PersonID__c  FROM Person_Account__c where PersonID__c =: accountIds and (TypeTranslate__c like '%PRIMARY%') 
            									and Account_Number__r.RecType__c = 'ACCT'group by PersonID__c having count(id) =  1 ];
            
            for(AggregateResult a : paList){

				newAccountIds.add(String.ValueOf(a.get('PersonID__c')));
			}
			
			system.debug('newAccountIds'+newAccountIds);
            
            List<Account> newAccList = [SELECT Id, Owner.Name, FirstName,LastName, Ownerid, Is_Case_Created__c, Created_By_Episys_User_Alias__c FROM Account where id =:newAccountIds ];
            system.debug('newAccList'+ newAccList.size());
            
            for(Account a : newAccList){
            	aliaslist.add(a.Created_By_Episys_User_Alias__c);
            }
            
            listUser =    [select id, Alias from user where alias in : aliaslist];
            
            
            //--------------------------------------------- CRM-1680------------------------------------------------------------------------//
            
            if(newAccList.size() > 0){
            	
	            for(Account acc : newAccList)
	            {
	     
	                for(user u : listUser)
	                {
	                     System.debug('insideuser');
	                    if(u.alias == acc.Created_By_Episys_User_Alias__c)
	                    {
	                        FeedItem post = new FeedItem();
				 			
				 			String fullURL = URL.getSalesforceBaseUrl().toExternalForm()+ '/lightning/n/Pre_Member_Conversion';      
				 			system.debug('fullURL==='+fullURL); 
	                        post.Body = 'Failed Pre Member Conversion for ' + acc.FirstName + ' ' + acc.LastName + ' Click here to convert Pre Member: ' + fullURL; 
	                        post.ParentId = u.id;			 			
	                        FeedItemlist.Add(post);
	                        system.debug('User Alias##'+ acc.Created_By_Episys_User_Alias__c);
	                    }
	                    
	                }
	               
	                acc.Is_Case_Created__c = true;
	                updateacclist.add(acc);
	                system.debug('updateacclist'+updateacclist.size());
	                system.debug('updateacclist'+updateacclist);
	                  
	            }
		        		
	            if(!FeedItemlist.IsEmpty()) insert FeedItemlist;
	            System.debug('FeedItemlist##' + FeedItemlist.size());
	             System.debug('FeedItemlist##' + FeedItemlist);
	            if(!updateacclist.IsEmpty()) update updateacclist;
		        	
            }  
             
        }
        
    }
    
    global void finish(Database.BatchableContext BC){
   }
}