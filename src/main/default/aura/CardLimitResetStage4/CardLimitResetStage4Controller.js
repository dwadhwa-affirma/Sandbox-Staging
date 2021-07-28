({
	doInit : function(component, event, helper) {
	    
		var recordId = component.get("v.recordId");
		var CLRecord = component.get("v.CLRecord");
        var type = CLRecord.Type__c;
        var dynamiccardnumber = component.get("v.CLRecord.Card_Number__c");   
        component.set("v.EncryptCard", '**********'+ dynamiccardnumber.substring(10, 16));
       
	}   
  
})