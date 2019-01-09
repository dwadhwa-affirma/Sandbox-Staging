@isTest
public  class OpportunityTriggerTest {
   
   @testSetup
   
	static void SetUp(){
		test.StartTest();
			
			string uid= UserInfo.getUserId();
		    User usr = [Select id, name, alias from User where id=:uid];
		    List<Episys_User__c> eusr = [SELECT id, alias__c, Assigned_Branch__c,Episys_ID__c, Branch_Name__c,Default__c from Episys_User__c 
		                                    where alias__c=:usr.alias order by Default__c desc];
		                                    
		    Account_Details__c accDetails = new Account_Details__c();
            accDetails.Name = 'test';
            accDetails.SecureEmailAddress__c = 'sample@sample.com';
            accDetails.Created_By_User__c = 1;
       		insert accDetails;
       		
       		 Account_Details__c accDetail = new Account_Details__c();
            accDetail.Name = 'Test';
            accDetail.RecType__c = 'ACCT';
        insert accDetail;
       		
       	    String RecTypeId= [select Id from RecordType where (Name='Person Account') and (SobjectType='Account')].Id;
       		
       		Account acc = new Account(
           RecordTypeID=RecTypeId,
           FirstName='Test FName',
           LastName='Test LName',
           PersonMailingStreet='test@yahoo.com',
           PersonMailingPostalCode='12345',
           PersonMailingCity='SFO',
           PersonEmail='test@yahoo.com',
           PersonHomePhone='1234567',
           PersonMobilePhone='12345678');
         
        insert acc;
       		
       		
       		Person_Account__c pa = new Person_Account__c();
       		pa.PersonID__c = acc.Id;
        	pa.Account_Number__c = accDetail.Id;
       		insert pa;
       		
		    Episys_User__c eu = new Episys_User__c();
            eu.Episys_ID__c = 1;
            eu.Episys_Name__c = 'testname';
            accDetails.SecureEmailAddress__c = 'sample@sample.com';
            eu.alias__c = usr.alias;
       		insert eu;
		
			Group	listQueue = [select id,Name,Email from Group where Type = 'Queue' and (Email like '%lead.com') limit 1];
			
			Account account_Obj = new Account(PersonHomePhone='', PersonHasOptedOutOfEmail = false, Name = 'MARIA BANDA');
			insert account_Obj; 
			
			
			
	    	Lead ld = new Lead (LastName = 'Test',Product_Type__c = 'Card', Product_Subtype__c = 'Credit Cards' , Brand__c = 'CFCU',FirstName = 'test',MiddleName = 'New', Description = 'New',
	    						Salutation = 'MR.',Suffix = 'MR',Status = 'New',Phone= '1234567890',Email='test@test.com',MobilePhone='1234567892',How_did_you_hear_about_us__c='Website',Event_Source__c='Event-Reston-Open House-04/20/18',
	   							 LeadSource='BDO-Realtor Referral' , Ownership__c='Queue', OwnerId = listQueue.Id, Street_Address_1__c='Address 1',State__c= 'NY',Zip_Code__c= '12345',City__c='NYC',Country__c ='USA');
	    	insert ld;
	    	
	    	Account account_Obj1 = new Account(PersonHomePhone='', PersonHasOptedOutOfEmail = false, Name = 'MARIA BANDA', Parent_Lead__c =ld.id);
			insert account_Obj1;  	
	      
	       Opportunity op = new Opportunity(Name = 'Name', StageName = 'Open',Product_Type__c = 'Misc', CloseDate = system.today(),  Is_Converted__c = true, Queue_Assigned_Id__c= listQueue.Id,  Opportunity_Source__c = 'Word of mouth', AccountId = account_Obj.id,  Ownership__c = 'Auto Assign', Episys_User_ID__c = 1);
	      
	      
	       Opportunity op1 = new Opportunity(Name = 'Name', StageName = 'Open',Product_Type__c = 'Misc', CloseDate = system.today(),  Is_Converted__c = true, Queue_Assigned_Id__c= listQueue.Id,  Opportunity_Source__c = 'Word of mouth', AccountId = account_Obj.id,  Ownership__c = 'Auto Assign', Episys_User_ID__c = 1033);
	       
		
		 Opportunity op2 = new Opportunity(Name = 'Name', StageName = 'Open',Product_Type__c = 'Misc', CloseDate = system.today(),  Is_Converted__c = false, Queue_Assigned_Id__c= listQueue.Id,  Opportunity_Source__c = 'Word of mouth', AccountId = account_Obj.id,  Ownership__c = 'Keep', Episys_User_ID__c = 1);
	      
	       
	      Opportunity op3 = new Opportunity(Name = 'Name', StageName = 'Open', Product_Type__c = 'Misc',CloseDate = system.today(),  Is_Converted__c = false, Queue_Assigned_Id__c= listQueue.Id,  Opportunity_Source__c = 'Branch Call', AccountId = account_Obj1.id,  Ownership__c = 'Auto Assign', Episys_User_ID__c = 1);
	       
	      Opportunity op4 = new Opportunity(Name = 'Name', StageName = 'Open', Product_Type__c = 'Misc', CloseDate = system.today(),  Is_Converted__c = false, Queue_Assigned_Id__c= listQueue.Id,  Opportunity_Source__c = 'Word of mouth', AccountId = account_Obj.id,  Ownership__c = 'Auto Assign', Episys_User_ID__c = 1);
	     // Opportunity op5 = new Opportunity(Name = 'Name', StageName = 'Open', Product_Type__c = 'Misc', CloseDate = system.today(),  Is_Converted__c = false, Queue_Assigned_Id__c= listQueue.Id,  Opportunity_Source__c = 'Word of mouth', AccountId = pa.id,  Ownership__c = 'Auto Assign');
	      Opportunity op6 = new Opportunity(Name = 'Name', StageName = 'Open', Product_Type__c = 'Misc', CloseDate = system.today(),  Is_Converted__c = false, Queue_Assigned_Id__c= listQueue.Id,  Opportunity_Source__c = 'Branch Call', AccountId = account_Obj.id,  Ownership__c = 'Auto Assign');
	      
        Opportunity op7 = new Opportunity(Name = 'Name', StageName = 'Open', Product_Type__c = 'Misc', CloseDate = system.today(),  Is_Converted__c = false, Queue_Assigned_Id__c= listQueue.Id,  Opportunity_Source__c = 'Event', AccountId = account_Obj.id,  Ownership__c = 'Auto Assign');
	      
	      List<Opportunity> insertopp = new List<Opportunity>();
	      insertopp.Add(op);
	       insertopp.Add(op1);
	        insertopp.Add(op2);
	         insertopp.Add(op3);
	         insertopp.Add(op4);
	      //   insertopp.Add(op5);
	         insertopp.Add(op6);
        insertopp.Add(op7);
	      
	      insert insertopp;
		
		test.stopTest();
	}
	
	static testMethod void OpportunityTriggerHandlerTest() {
       
        Test.startTest(); 
        	Account account_Obj = [Select Id from Account limit 1];
	        Lead l = [Select id, Status,Ownership__c, LeadSource,Product_Type__c,Episys_User_ID__c from Lead limit 1];
	        Opportunity op = [Select id,  Ownership__c,Queue_Owner__c,User_Owner__c,Queue_Assigned_Id__c from Opportunity where Ownership__c = 'Auto Assign' limit 1 ];
	        Opportunity op1 = [Select id,  Ownership__c,Queue_Owner__c,User_Owner__c,Queue_Assigned_Id__c from Opportunity where Ownership__c = 'Keep' limit 1];
	      	op.StageName = 'Closed Won';  
	      	op1.StageName = 'Closed Won';
	      	
	      	 update op;  
	      	 update op1; 
	      	  			try
					      {
					         op.Opportunity_Source__c = 'BDO-Realtor Referral'; 
					         update op;
					      }
					      catch(Exception error)
					         { 
					         	System.debug('###' +	error.getMessage());
								System.assert(error.getMessage().contains('Opportunity Source is read only for Opportunity converted from Lead.')); 
					            
					         }
					             
					     try
					     {
					         op1.Brand__C ='Spectrum' ;
					          update op1;
					     }
					     catch(Exception error)
					     {
					         System.assert(error.getMessage().contains('Brand is read only for Opportunity converted from Lead.')); 
					     }
					    
					         
					    try
					     {
					         op1.Product_Type__c ='Cards' ;
					          update op1;
					     }
					     catch(Exception error)
					     {
					         System.assert(error.getMessage().contains('Product Type is read only for Opportunity converted from Lead.')); 
					     }
					         
					    try
					     {
					         op1.Product_Sub__c ='Credit Cards' ;
					          update op1;
					     }
					     catch(Exception error)
					     {
					         System.assert(error.getMessage().contains('Product Subtype is read only for Opportunity converted from Lead.')); 
					     }
					      
					     try
					     {
					         op1.How_did_you_hear_about_us__c ='Employer' ;
					          update op1;
					     }
					     catch(Exception error)
					     {
					         System.assert(error.getMessage().contains('How did you hear about us is read only for Opportunity converted from Lead.')); 
					     }
					      
					     try
					     {
					         op1.Event_Source__c ='Event – San Francisco Plaza Event 03/05/18' ;
					          update op1;
					     }
					     catch(Exception error)
					     {
					         System.assert(error.getMessage().contains('Event Source is read only for Opportunity converted from Lead.')); 
					     }
					     
					     try
					     {
					         op1.closedate = system.today().adddays(1) ;
					          update op1;
					     }
					     catch(Exception error)
					     {
					         System.assert(error.getMessage().contains('Close date is read only')); 
					     }
					     try
					     {
					         op1.AccountId = account_Obj.id ;
					          update op1;
					     }
					     catch(Exception error)
					     {
					         System.assert(error.getMessage().contains('Member name is read only')); 
					     }  
					     try
					     {
					         op1.Member_Branch__c = 'Outreach' ;
					          update op1;
					     }
					     catch(Exception error)
					     {
					         System.assert(error.getMessage().contains('Member Branch is read only for Opportunity converted from Lead.')); 
					     }    
	      	 
     	 Test.stopTest();
       
        
    }
	
}
		
		
     /*  string uid= UserInfo.getUserId();
		    User usr = [Select id, name, alias from User where id=:uid];
		    List<Episys_User__c> eusr = [SELECT id, alias__c, Assigned_Branch__c,Episys_ID__c, Branch_Name__c,Default__c from Episys_User__c 
		                                    where alias__c=:usr.alias order by Default__c desc];
		                                    
		    Account_Details__c accDetails = new Account_Details__c();
            accDetails.Name = 'test';
            accDetails.SecureEmailAddress__c = 'sample@sample.com';
            accDetails.Created_By_User__c = 1;
       		insert accDetails;
		    Episys_User__c eu = new Episys_User__c();
            eu.Episys_ID__c = 1;
            eu.Episys_Name__c = 'testname';
            accDetails.SecureEmailAddress__c = 'sample@sample.com';
        insert eu;
       Lead ld = new Lead ();
    ld.LastName = 'Test';
    ld.Email = 'test@gmail.com';
    ld.Product_Type__c = 'Misc';
    ld.Brand__c = 'CFCU';
    ld.FirstName = 'test';
    ld.LastName = 'New';    
    ld.MiddleName = 'New';
    ld.Description = 'New';
    ld.Salutation = 'MR.';
    ld.Suffix = 'MR'; 
    ld.Status = 'New';
    ld.Phone= '1234567890';
    ld.Email='test@test.com';
    ld.MobilePhone='1234567892';
    ld.How_did_you_hear_about_us__c='Website';
    ld.Event_Source__c='Event-Reston-Open House-04/20/18';
    ld.LeadSource='BDO-Realtor Referral';
    ld.Product_Type__c ='Mortgage';
    ld.Product_Subtype__c='Purchase';
    ld.Street_Address_1__c='Address 1';
    ld.State__c= 'NY';
    ld.Zip_Code__c= '12345';
    ld.City__c='NYC';
    ld.Country__c ='USA';
    insert ld; 
     
      Account acc = new Account();
       acc.Name = 'Test1111';
       acc.Parent_Lead__c = ld.id;
        insert acc; 
        
       Account acc1 = new Account();
       acc1.Name = 'Test1111';
       
        insert acc1; 
         
       Opportunity op = new Opportunity();
       op.Name = 'Name';
       op.StageName = 'Open';
       op.CloseDate = system.today();
       op.Is_Converted__c = true;
       op.Opportunity_Source__c = 'Word of mouth';
       op.AccountId = acc.id;
       op.Ownership__c = 'Auto Assign';
       op.Episys_User_ID__c = 1;
       insert op;
       
       
      Opportunity optest = [select name from Opportunity where id =: op.Id limit 1];
       op.Name = optest.Name;
       Opportunity op1 = new Opportunity();
       op1.Name = 'Name';
       op1.StageName = 'Closed Won';
       op1.Is_Converted__c = true;
       op1.Opportunity_Source__c = 'Branch Call';
       op1.AccountId = acc1.id;
       op1.CloseDate = system.today();
       op1.Ownership__c ='Assign';
       op1.Episys_User_ID__c = 1;
       insert op1;
        Set<Decimal> Episys_User_ID = new Set<Decimal>();
        Episys_User_ID.add( op1.Episys_User_ID__c);
        Episys_User_ID.add( op.Episys_User_ID__c);
        
       List<Episys_User__c> episysUsers = [SELECT id, alias__c, Assigned_Branch__c,Episys_ID__c, Branch_Name__c,Default__c from Episys_User__c 
		                                    where Episys_ID__c in: Episys_User_ID];
       
            Opportunity op1test = [select name from Opportunity where id =: op1.Id limit 1];
         op1.Name = op1test.Name;
     
      
       op.StageName = 'Closed Won';  
       op1.StageName = 'Closed Won';
       Test.startTest(); 
       update op;
        //op1.Name = 'Test111';
        
       update op1; 
      Test.stopTest();
       
      try
      {
         op.Opportunity_Source__c = 'BDO-Realtor Referral'; 
         update op;
      }
      catch(Exception error)
         { 
         System.debug('###' +	error.getMessage());
			System.assert(error.getMessage().contains('Opportunity Source is read only for Opportunity converted from Lead.')); 
            
         }
             
     try
     {
         op1.Brand__C ='Spectrum' ;
          update op1;
     }
     catch(Exception error)
     {
         System.assert(error.getMessage().contains('Brand is read only for Opportunity converted from Lead.')); 
     }
    
         
    try
     {
         op1.Product_Type__c ='Cards' ;
          update op1;
     }
     catch(Exception error)
     {
         System.assert(error.getMessage().contains('Product Type is read only for Opportunity converted from Lead.')); 
     }
         
    try
     {
         op1.Product_Sub__c ='Credit Cards' ;
          update op1;
     }
     catch(Exception error)
     {
         System.assert(error.getMessage().contains('Product Subtype is read only for Opportunity converted from Lead.')); 
     }
      
     try
     {
         op1.How_did_you_hear_about_us__c ='Employer' ;
          update op1;
     }
     catch(Exception error)
     {
         System.assert(error.getMessage().contains('How did you hear about us is read only for Opportunity converted from Lead.')); 
     }
      
     try
     {
         op1.Event_Source__c ='Event – San Francisco Plaza Event 03/05/18' ;
          update op1;
     }
     catch(Exception error)
     {
         System.assert(error.getMessage().contains('Event Source is read only for Opportunity converted from Lead.')); 
     }
     
     try
     {
         op1.closedate = system.today().adddays(1) ;
          update op1;
     }
     catch(Exception error)
     {
         System.assert(error.getMessage().contains('Close date is read only')); 
     }
     try
     {
         op1.AccountId = acc.id ;
          update op1;
     }
     catch(Exception error)
     {
         System.assert(error.getMessage().contains('Member name is read only')); 
     }  
     try
     {
         op1.Member_Branch__c = 'Outreach' ;
          update op1;
     }
     catch(Exception error)
     {
         System.assert(error.getMessage().contains('Member Branch is read only for Opportunity converted from Lead.')); 
     }    
     */