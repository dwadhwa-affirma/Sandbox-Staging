trigger SolarLoanTrigger on Solar_Loans__c (after insert, after update, before update) {
    
    Set<Id> SLIds = new Set<Id>();
    Set<Id> SLIdsForRouting = new Set<Id>();
    Map<Id, Solar_Loans__c> SLForBranchIds = new Map<Id, Solar_Loans__c>();
    List<Solar_Loans__c> SLToUpdates = new List<Solar_Loans__c>();
    List<Solar_Loans__c> SLToUpdatesForRouting = new List<Solar_Loans__c>();
    List<String> SLMemberNumber = new List<String>();
    
    List<Solar_Loans__c> SLForMemberName = new List<Solar_Loans__c>();
    List<String> SLMemberFirstName = new List<String>();
    List<String> SLMemberLastName = new List<String>();
    List<Solar_Loans__c> SLNameUpdate = new List<Solar_Loans__c>();
    
    if(Trigger.isInsert){
        for(Integer i=0; i<trigger.new.size(); i++){
        
            //------------------------------- Checking if the status is being changed and status = 'ACH Pending'-----------------------------------------------//
            
            if(trigger.new[i].Status__c == 'ACH Pending'){
                SLIds.add(trigger.new[i].id);
            }
            
             //------------------------------- Adding ids if the Member Number field is not null---------------------------------------------------------------//
             
            if(trigger.new[i].Member_Number__c != null){ 
            	SLForBranchIds.put(trigger.new[i].id, trigger.new[i]);
                SLMemberNumber.add(trigger.new[i].Member_Number__c);
            }
            
            //------------------------------- Link "Member" record with "Solar Loan" record -------------------------------------------//
            
             
        	SLForMemberName.add(trigger.new[i]);
            SLMemberFirstName.add(trigger.new[i].Primary_First_Name__c);
            SLMemberLastName.add(trigger.new[i].Primary_Last_Name__c );
            
        }
        
        //--------------------------Updating "Member Name" based on "Name" field from Solar Loan record ---------------------------//
    	
		if(SLMemberFirstName.size() > 0 && SLMemberLastName.size() > 0){
			
			List<Account> memberList = [select id, Name, FirstName, LastName from Account where FirstName in:SLMemberFirstName and LastName in:SLMemberLastName];
			
			for(Solar_Loans__c slName : SLForMemberName){
				
				for(Account member : memberList){
					
					if(member.FirstName == slName.Primary_First_Name__c && member.LastName == slName.Primary_Last_Name__c){
					
						Solar_Loans__c sName = new Solar_Loans__c();
			    		sName.id = slName.id;
			    		sName.Member_Name__c = member.id;
			    		SLNameUpdate.add(sName);
		    			
					}
				}
			}
			
			if(SLNameUpdate.size() > 0){
	    
	    		update SLNameUpdate;	
    		}
		}
        
         
    }
    
    
    //------------------------------- Checking if the status 'Completed' and Routing Number is 'Changed' ------------------------//
    	
    if(Trigger.isBefore && Trigger.isUpdate){
        
        for(Integer i=0; i<trigger.new.size(); i++){
			if(trigger.new[i].Routing_Number__c != trigger.old[i].Routing_Number__c && trigger.new[i].Routing_Number__c != null && trigger.new[i].Status__c == 'Completed'){
    			trigger.new[i].Review_needed__c = true;
    		}
        }
              
    }
    		
    if(Trigger.isAfter && Trigger.isUpdate){
    	
        for(Integer i=0; i<trigger.new.size(); i++){
        
            //------------------------------- Checking if the status is being changed and status = 'ACH Pending'-----------------//
            
            if(trigger.old[i].Status__c != 'ACH Pending' && trigger.new[i].Status__c == 'ACH Pending'){
                SLIds.add(trigger.new[i].id);
            }
            
            //------------------------------- Adding ids if the Member Number field is not null----------------------------------//
            
            if(trigger.old[i].Member_Number__c != trigger.new[i].Member_Number__c || trigger.new[i].Account_Number__c == null){ 
            	SLForBranchIds.put(trigger.new[i].id, trigger.new[i]);
                 SLMemberNumber.add(trigger.new[i].Member_Number__c);
            }
            
            //------------------------------- Link "Member" record with "Solar Loan" record--------------------------------------//
            
            if(trigger.old[i].Name__c != trigger.new[i].Name__c || trigger.new[i].Member_Name__c == null){ 
            	SLForMemberName.add(trigger.new[i]);
                SLMemberFirstName.add(trigger.new[i].Primary_First_Name__c);
                SLMemberLastName.add(trigger.new[i].Primary_Last_Name__c );
            }
            
            //------------------------------- Update "Four Digit share/loan type" in "Solar Loan" record------------------------//
            
            if(trigger.new[i].Four_Digit_Share_Loan_Type__c == null){ 
            	SLForBranchIds.put(trigger.new[i].id, trigger.new[i]);
                 SLMemberNumber.add(trigger.new[i].Member_Number__c);
            }
            
            
	    } 
	    	        
    	//--------------------------Updating "Member Name" based on "Name" field from Solar Loan record -----------------------//
    	
		if(SLMemberFirstName.size() > 0 && SLMemberLastName.size() > 0){
			
			List<Account> memberList = [select id, Name, FirstName, LastName from Account where FirstName in:SLMemberFirstName and LastName in:SLMemberLastName];
			
			for(Solar_Loans__c slName : SLForMemberName){
				
				for(Account member : memberList){
					
					if(member.FirstName == slName.Primary_First_Name__c && member.LastName == slName.Primary_Last_Name__c){
					
						Solar_Loans__c sName = new Solar_Loans__c();
			    		sName.id = slName.id;
			    		sName.Member_Name__c = member.id;
			    		SLNameUpdate.add(sName);
		    			
					}
				}
			}
			
			if(SLNameUpdate.size() > 0){
	    
	    		update SLNameUpdate;	
    		}
		}
		    	
	    //--------------------------Updating "Brand" and "Four Digit Share Loan Type" from "Account Details" record------------------//
	    
	    
	    List<Account_Details__c> adList = [select id, Name, Brand__c, ID1__c, TypeTranslate__c,RecType__c from Account_Details__c where Name in:SLMemberNumber and Brand__c != null and RecType__c = 'LOAN' and TypeTranslate__c = '75-SECURED SOLAR'];
	    
		for(Solar_Loans__c sl : SLForBranchIds.values()){
		
		    for(Account_Details__c a : adList){
		    	
		    	if(a.Name == sl.Member_Number__c){
		    		
		    		Solar_Loans__c s = new Solar_Loans__c();
		    		s.id = SLForBranchIds.get(sl.id).id;
		    		s.Brand__c = a.Brand__c;
		    		s.Account_Number__c = a.id;
		    		s.Four_Digit_Share_Loan_Type__c = a.ID1__c;
		    		SLToUpdates.add(s);
		    	}
		    }
		}
	     
	    if(SLToUpdates.size() > 0){
	    
	    	update SLToUpdates;	
	    }
	}
        
    if(SLIds.size() > 0){
        
        //------------------------------- Calling Batch class with list of "Solar Loans" id to send a Docusign email---------------------------------------//
       
        Database.executeBatch(new SolarLoansToDocuSignBatch(SLIds),1);
    }
}