trigger SolarLoanTrigger on Solar_Loans__c (after insert, after update, before update) {
    
    Set<Id> SLIds = new Set<Id>();
    Set<Id> SLIdsToCreateLoan = new Set<Id>();
    Set<Id> UpdateStatus = new Set<Id>();
    Set<Id> SLIdsForEFT = new Set<Id>();
    Set<Id> SLIdsForABABank = new Set<Id>();
    
    Set<Id> SLIdsForRouting = new Set<Id>();
    Map<Id, Solar_Loans__c> SLForBranchIds = new Map<Id, Solar_Loans__c>();
    
    List<Solar_Loans__c> SLToUpdatesForRouting = new List<Solar_Loans__c>();
    Set<String> SLMemberNumber = new Set<String>();
    
    List<Solar_Loans__c> SLForMemberName = new List<Solar_Loans__c>();
    Set<String> SLMemberFirstName = new Set<String>();
    Set<String> SLMemberLastName = new Set<String>();
    
    Map<Id,Solar_Loans__c> SolarLoanMap =new Map<Id,Solar_Loans__c>();
    Map<Id,Solar_Loans__c> SLToUpdates = new Map<Id,Solar_Loans__c>();
    
    if(Trigger.isInsert){
        for(Integer i=0; i<trigger.new.size(); i++){
        
            //------------------------------- Checking if the status is being changed and status = 'ACH Pending'-----------------------------------------------//
            
            if(trigger.new[i].Status__c == 'ACH Pending'){
                SLIds.add(trigger.new[i].id);
            }
            
            //------------------------------- Checking if the status is being changed and status = 'Approved'-----------------------------------------------//
                
            if(trigger.new[i].Status__c == 'Approved'){
                SLIdsToCreateLoan.add(trigger.new[i].id);
            }
            
            //------------------------------- Checking if the status is being changed and status = 'Completed'-----------------------------------------------//
                
            if(trigger.new[i].Status__c == 'Completed'){
                SLIdsForEFT.add(trigger.new[i].id);
            }
            
             //------------------------------- Adding ids if the Member Number field is not null---------------------------------------------------------------//
             
            if(trigger.new[i].Member_Number__c != null){ 
            	SLForBranchIds.put(trigger.new[i].id, trigger.new[i]);
                SLMemberNumber.add(trigger.new[i].Member_Number__c);
            }
            
            //------------------------------- ABA Bank look up'----------------------------------------------------------//
                
            if(trigger.new[i].Routing_Number__c != null){
                SLIdsForABABank.add(trigger.new[i].id);
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
			    		SolarLoanMap.put(slName.id,sName);
					}
				}
			}
			if(SolarLoanMap.size() > 0){
	    
	    		update SolarLoanMap.values();	
    		}
		}
        
         
    }
    
    
    //------------------------------- Checking if the status 'Completed' and Routing Number is 'Changed' ------------------------//
    	
    if(Trigger.isBefore && Trigger.isUpdate){
        
        for(Integer i=0; i<trigger.new.size(); i++){
			if(trigger.new[i].Routing_Number__c != trigger.old[i].Routing_Number__c && trigger.new[i].Routing_Number__c != null && trigger.new[i].Status__c == 'Completed'){
    			trigger.new[i].Review_needed__c = true;
    		}
    		
    		//------------------------------- Checking if the LoanId != null ---------------------------------------------------//
            
            if((trigger.old[i].Loan_Id__c != trigger.new[i].Loan_Id__c && trigger.new[i].Loan_Id__c != null) ||
            	(trigger.old[i].Loan_Name_Locator__c != trigger.new[i].Loan_Name_Locator__c && trigger.new[i].Loan_Name_Locator__c != null) ||
            	(trigger.old[i].Loan_Tracking_Locator__c != trigger.new[i].Loan_Tracking_Locator__c && trigger.new[i].Loan_Tracking_Locator__c != null)){
            	trigger.new[i].Status__c = 'Loan Record Created';
            	trigger.new[i].Current_Solar_Loan_Stage__c = 'Stage 4';
            }
            
            if(trigger.old[i].EftLocator__c != trigger.new[i].EftLocator__c && trigger.new[i].EftLocator__c != null){
            	trigger.new[i].Status__c = 'EFT Record Created';
                trigger.new[i].Current_Solar_Loan_Stage__c = 'Stage 8';
            }
            
            if(trigger.old[i].Status__c != trigger.new[i].Status__c && trigger.new[i].Status__c ==  'Declined'){
            	trigger.new[i].Current_Solar_Loan_Stage__c = 'Stage 5';
            }
            if(trigger.old[i].Status__c != trigger.new[i].Status__c && trigger.new[i].Status__c ==  'Expired'){
            	trigger.new[i].Current_Solar_Loan_Stage__c = 'Stage 5';
            }
        }
              
    }
    		
    if(Trigger.isAfter && Trigger.isUpdate){
    	
        for(Integer i=0; i<trigger.new.size(); i++){
        
            //------------------------------- Checking if the status is being changed and status = 'ACH Pending'-----------------//
            
            if(trigger.old[i].Status__c != 'ACH Pending' && trigger.new[i].Status__c == 'ACH Pending'){
                SLIds.add(trigger.new[i].id);
            }
            
            //------------------------------- Checking if the status is being changed and status = 'Approved'-----------------//
            
            if(trigger.old[i].Status__c != 'Approved' && trigger.new[i].Status__c == 'Approved'){
                SLIdsToCreateLoan.add(trigger.new[i].id);
            }
            
            //------------------------------- Checking if the status is being changed and status = 'Completed'-----------------//
            
            if(trigger.old[i].Status__c != 'Completed' && trigger.new[i].Status__c == 'Completed'){
                SLIdsForEFT.add(trigger.new[i].id);
            }
            
            //------------------------------- Adding ids if the Member Number field is not null----------------------------------//
            
            if(trigger.old[i].Member_Number__c != trigger.new[i].Member_Number__c || trigger.new[i].Member_Number__c == null){ 
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
            
             //------------------------------- ABA Bank look up'----------------------------------------------------------//
                
           if(trigger.old[i].Routing_Number__c != trigger.new[i].Routing_Number__c && trigger.new[i].Routing_Number__c != null){             	
                SLIdsForABABank.add(trigger.new[i].id);
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
			    		//SLNameUpdateSet.add(sName);
			    		SolarLoanMap.put(slName.id,sName);
			    	}
				}
			}
			
			
			if(SolarLoanMap.size() > 0){
	    
	    		update SolarLoanMap.values();	
    		}
		}
		    	
	    //--------------------------Updating "Brand" and "Four Digit Share Loan Type" from "Account Details" record------------------//
	    
	    
	    //List<Account_Details__c> adList = [select id, Name, Brand__c, ID1__c, TypeTranslate__c,RecType__c from Account_Details__c where Name in:SLMemberNumber and Brand__c != null and RecType__c = 'LOAN' and TypeTranslate__c = '75-SECURED SOLAR'];
	    List<Account_Details__c> adList = [select id, Name, Brand__c, ID1__c, TypeTranslate__c,RecType__c from Account_Details__c where Name in:SLMemberNumber and Brand__c != null and RecType__c = 'LOAN'];
	    
		for(Solar_Loans__c sl : SLForBranchIds.values()){
		
		    for(Account_Details__c a : adList){
		    	
		    	if(a.Name == sl.Member_Number__c){
		    		
		    		Solar_Loans__c s = new Solar_Loans__c();
		    		s.id = SLForBranchIds.get(sl.id).id;
		    		s.Brand__c = a.Brand__c;
		    		s.Account_Number__c = a.id;
		    		s.Four_Digit_Share_Loan_Type__c = a.ID1__c;
		    		SLToUpdates.put(sl.id,s);
		    	}
		    }
		}
	     
	    if(SLToUpdates.size() > 0){
	    
	    	update SLToUpdates.values();	
	    }
	}
        
    //------------------------------- Calling Batch class with list of "Solar Loans" id to send a Docusign email-----------------//    
    if(SLIds.size() > 0){
        
        Database.executeBatch(new SolarLoansToDocuSignBatch(SLIds),1);
    }
    
    //------------------------------- Creating "Loan/LoanName/LoanTracking" if the status = "Approved"---------------------------//
    
    if(SLIdsToCreateLoan.size() > 0){
       
        SolarLoanToCreateLoan.createSolarLoans(SLIdsToCreateLoan);
    }
    
    //------------------------------- Creating "EFT" record if the status = "Completed"------------------------------------------//
    if(SLIdsForEFT.size() > 0){
        
         SolarLoanToSymitar.insertSolarLoans(SLIdsForEFT);
    }
    
    if(SLIdsForABABank.size() > 0){
    	SolarLoanRoutingInfo.getABABankName(SLIdsForABABank);
    }
    
    
}