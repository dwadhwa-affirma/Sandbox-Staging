trigger WiresRecipientTrigger on WIRES_Recipient__c (after insert) {

    
    set<Id> Ids = new set<Id>();
				if(Trigger.new.size() > 0){
					for(WIRES_Recipient__c objWIRES: trigger.New)
					    {
					    	Ids.add(objWIRES.Id);
					    }
    
				}
				List<WIRES_Recipient__c> wiresToUpdate = [select id  from WIRES_Recipient__c where id IN: Ids];
				if(wiresToUpdate.size() > 0){
					for (WIRES_Recipient__c c : wiresToUpdate) {	       	  
			            c.ExternalID__c = c.Id;
		      		}
				}
				
	      		if(wiresToUpdate.size() > 0){
	      			update wiresToUpdate;
	      		}

    
}