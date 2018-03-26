trigger OtherExistingLoanTrigger on NA_Other_Existing_Loans__c (after insert,after delete) {
	
	public list<NA_Deposit__c> otherloans;
		
		if (Trigger.isUpdate || Trigger.isInsert)
		{
			for (NA_Other_Existing_Loans__c newobj : Trigger.new)
	        {
					Needs_Assesment__c obj  = [Select id, Member__c from Needs_Assesment__c where id=: newobj.Needs_Assessment__c ];
			
		    		Account account = [select Id,BIRTH_DATE__pc, 
		                                     
		                                     NA_LEOL_Complete__c
		 
		
		                      from Account
		 
		                     where id =: obj.Member__c limit 1];
		                     account.NA_LEOL_Complete__c = true;
		                     update account;
        		
	        }
		}
        
        if (Trigger.isdelete)
        {
        	
        	for (NA_Other_Existing_Loans__c newobj : Trigger.old)
        	{
        		
        		otherloans =[Select id from NA_Deposit__c where Needs_Assessment__c =: newobj.Needs_Assessment__c];
        		
        		if (otherloans == null || otherloans.isEmpty())
        		{
        			Needs_Assesment__c obj  = [Select id, Member__c from Needs_Assesment__c where id=: newobj.Needs_Assessment__c ];
	
    				Account account = [select Id,BIRTH_DATE__pc, 
                                     
                                     NA_LEOL_Complete__c
 

                      from Account
 
                     where id =: obj.Member__c limit 1];
                     account.NA_LEOL_Complete__c = false;
                     update account;
        		}
        	
        	}
        	
        
        }
}