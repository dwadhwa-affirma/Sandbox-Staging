trigger SolarLoanTrigger on Solar_Loans__c (after insert, after update) {
    
    Set<Id> SLIds = new Set<Id>();
    Map<Id, Solar_Loans__c> SLForBranchIds = new Map<Id, Solar_Loans__c>();
    List<Solar_Loans__c> SLToUpdates = new List<Solar_Loans__c>();
    List<String> SLMemberNumber = new List<String>();
    
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
        } 
    }
    
    if(Trigger.isUpdate){
        for(Integer i=0; i<trigger.new.size(); i++){
        
            //------------------------------- Checking if the status is being changed and status = 'ACH Pending'-----------------------------------------------//
            
            if(trigger.old[i].Status__c != 'ACH Pending' && trigger.new[i].Status__c == 'ACH Pending'){
                SLIds.add(trigger.new[i].id);
            }
            
            //------------------------------- Adding ids if the Member Number field is not null---------------------------------------------------------------//
            
            if(trigger.old[i].Member_Number__c != trigger.new[i].Member_Number__c && trigger.new[i].Member_Number__c != null){ 
            	SLForBranchIds.put(trigger.new[i].id, trigger.new[i]);
                 SLMemberNumber.add(trigger.new[i].Member_Number__c);
            }
        } 
    }
    
    
    List<Account_Details__c> adList = [select id, Name, Brand__c, TypeTranslate__c,RecType__c from Account_Details__c where Name in:SLMemberNumber and Brand__c != null and RecType__c = 'ACCT'];
    
	for(Solar_Loans__c sl : SLForBranchIds.values()){
	
	    for(Account_Details__c a : adList){
	    	
	    	if(a.Name == sl.Member_Number__c){
	    		
	    		Solar_Loans__c s = new Solar_Loans__c();
	    		s.id = SLForBranchIds.get(sl.id).id;
	    		s.Brand__c = a.Brand__c;
	    		SLToUpdates.add(s);
	    	}
	    }
	}
    
    if(SLToUpdates.size() > 0){
    
    	update SLToUpdates;	
    }
    
    if(SLIds.size() > 0){
        
        //------------------------------- Calling Batch class with list of "Solar Loans" id to send a Docusign email---------------------------------------//
       
        Database.executeBatch(new SolarLoansToDocuSignBatch(SLIds),1);
    }
}