@isTest
private class OpportunityOwnerAssignmentTest {

	@testSetup
	static void SetUp(){
		test.StartTest();
		
		Group	listQueue = [select id,Name,Email from Group where Type = 'Queue' and (Email like '%lead.com') limit 1];
		Account account_Obj = new Account(PersonHomePhone='', PersonHasOptedOutOfEmail = false, Name = 'MARIA BANDA');
		Insert account_Obj; 
		
    	 Lead ld = new Lead (LastName = 'Test',Product_Type__c = 'Card',Brand__c = 'CFCU',FirstName = 'test',MiddleName = 'New', Description = 'New', Ownerid = listQueue.Id,
    						Salutation = 'MR.',Suffix = 'MR',Status = 'New',Phone= '1234567890',Email='test@test.com',MobilePhone='1234567892',How_did_you_hear_about_us__c='Website',Event_Source__c='Event-Reston-Open House-04/20/18',
   							 LeadSource='BDO-Realtor Referral' , Ownership__c='Queue', Street_Address_1__c='Address 1',State__c= 'NY',Zip_Code__c= '12345',City__c='NYC',Country__c ='USA');
    	insert ld; 	
      
      Opportunity op = new Opportunity(Name = 'Name', StageName = 'Open', CloseDate = system.today(),  Is_Converted__c = true, Queue_Assigned_Id__c= listQueue.Id,  Opportunity_Source__c = 'Word of mouth', AccountId = account_Obj.id,  Ownership__c = 'Auto Assign', Episys_User_ID__c = 1);
       insert op;
      
      Opportunity op1 = new Opportunity(Name = 'Name', StageName = 'Open', CloseDate = system.today(),  Is_Converted__c = true, Queue_Assigned_Id__c= listQueue.Id,  Opportunity_Source__c = 'Word of mouth', AccountId = account_Obj.id,  Ownership__c = 'Keep', Episys_User_ID__c = 1);
      insert op1;
	
	Opportunity op2 = new Opportunity(Name = 'Name', StageName = 'Closed Lost', Sub_Status__c ='Declined' , CloseDate = system.today(),  Is_Converted__c = true, Queue_Assigned_Id__c= listQueue.Id,  Opportunity_Source__c = 'Word of mouth', AccountId = account_Obj.id,  Ownership__c = 'Keep', Episys_User_ID__c = 1);
      insert op2;
		
		test.StopTest();
	}
	
	static testMethod void changeCaseOwnershipTest() {
       
        
        Lead l = [Select id, Status,Ownership__c, LeadSource,Product_Type__c,Episys_User_ID__c from Lead limit 1];
        Opportunity o = [Select id,  Ownership__c,Queue_Owner__c,User_Owner__c,Queue_Assigned_Id__c from Opportunity where Ownership__c = 'Auto Assign' limit 1 ];
         Opportunity o1 = [Select id,  Ownership__c,Queue_Owner__c,User_Owner__c,Queue_Assigned_Id__c from Opportunity where Ownership__c = 'Keep' limit 1];
      //    Opportunity o2 = [Select id,  Ownership__c,Queue_Owner__c,User_Owner__c,Queue_Assigned_Id__c from Opportunity where Ownership__c = 'Queue' limit 1];
        
       List<Group> g = OpportunityOwnerAssignment.GetQueueName('Opportunity');
       List<Group> g1 = OpportunityOwnerAssignment.GetQueueName('Lead');
       OpportunityOwnerAssignment.OpportunityChangeOwner(o,o.Id);
       OpportunityOwnerAssignment.OpportunityChangeOwner(o1,o.Id);
       OpportunityOwnerAssignment.OpportunityChangeOwner(o1,l.Id);
        
    }
    
    static testMethod void GetStatusTest()
    {
    	 Opportunity o = [Select id,  Ownership__c,Queue_Owner__c,User_Owner__c,Queue_Assigned_Id__c from Opportunity where Ownership__c = 'Auto Assign' limit 1 ];
    	OpportunityOwnerAssignment.GetStatus('Opportunity', o.id );
    	 Opportunity o1 = [Select id,  Ownership__c,Queue_Owner__c,User_Owner__c,Queue_Assigned_Id__c from Opportunity where StageName = 'Closed Lost' limit 1 ];
    	OpportunityOwnerAssignment.GetStatus('Opportunity', o1.id );
    	
    }
    
}