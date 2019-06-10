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
        Set<String> aliaslist = new Set<String>();
        Map<Id, String> accaliasmap = new Map<Id, String>();
     	for(Account s : acclist){
	     	accountIds.add(s.id);
            aliaslist.add(s.Created_By_Episys_User_Alias__c);

	    }
    List<user> listUser =    [select id, Alias from user where alias in : aliaslist];
        
       
        
        
        system.debug('listUser.size()##'+ listUser);
         system.debug('accountIds##'+ accountIds);
        if(accountIds.size() > 0)
        {
           //  List<Case> caselist = new List<Case>(); 
             List<FeedItem> FeedItemlist = new List<FeedItem>(); 
             List<Account> updateacclist = new List<Account>();
             List<Person_Account__c> paList = [SELECT Id,Ownerid, PersonID__c, Account_Number__c,Account_Number__r.Created_By_User_Alias__c FROM Person_Account__c WHERE 
                                                      PersonID__c =: accountIds  Order by Account_Number__r.RecType__c];
            
            Set<string> listUserAlias = new Set<string>();
            
           
            
            
            for(Account acc : acclist)
            {
            	 System.debug('inside');
            	 
            	 // Changes done for MVAN-8 Begin
             /*   Case c = new Case();
                c.Primary_Category__c = 'Account Maintenance';
                c.Secondary_Category__c = 'Pre Member Conversion';
                c.Tertiary_Category__c = 'Failed';
                c.Status ='Open';
                c.accountid = acc.id;
                c.Subject = 'Failed Pre Member Conversion';
                
                for(user u : listUser)
                {
                    if(u.alias == acc.Created_By_Episys_User_Alias__c)
                    {
                        c.ownerid = u.id;
                    }
                }
                            
                */
                
          //   User MarsUser =   [select id, name from user where name ='MARS System'];
			  
                 for(user u : listUser)
                {
                     System.debug('insideuser');
                    if(u.alias == acc.Created_By_Episys_User_Alias__c)
                    {
                        FeedItem post = new FeedItem();
			 			//post.Body = 'Failed Pre Member Conversion';
			 			String fullURL = URL.getSalesforceBaseUrl().toExternalForm()+ '/lightning/n/Pre_Member_Conversion';      
			 			system.debug('fullURL==='+fullURL); 
                        //post.Body = 'Failed Pre Member Conversion. Click here to convert Pre Member: ' + fullURL; 
			 			post.Body = 'Failed Pre Member Conversion for ' + acc.FirstName + ' ' + acc.LastName + ' Click here to convert Pre Member: ' + fullURL; 
			 			post.LinkUrl = fullURL;			 			
			 			post.ParentId = u.id;			 			
                        FeedItemlist.Add(post);
                    }
                    
                }
               
               // FeedItemlist.Add(post);
                acc.Is_Case_Created__c = true;
                updateacclist.add(acc);
                  
            }
	        		
            if(!FeedItemlist.IsEmpty()) insert FeedItemlist;
            System.debug('FeedItemlist##' + FeedItemlist.size());
             System.debug('FeedItemlist##' + FeedItemlist);
            if(!updateacclist.IsEmpty()) update updateacclist;
	       
	        // Changes done for MVAN-8 Ends here		
             
             
        }
        
    }
    
    global void finish(Database.BatchableContext BC){
   }
}