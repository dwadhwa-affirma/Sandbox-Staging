({
	doInit : function(component, event, helper) {
	    
		var action = component.get("c.getCard");
	
		var recordId = component.get("v.recordId");
		var CLRecord = component.get("v.CLRecord");
        var cardNumber = CLRecord.Card_Number__c;
        
		action.setParams({
			"recordId": recordId,
            "cardNumber": cardNumber
		});			
		action.setCallback(this, function(resp) {
			var state=resp.getState();			
			if(state === "SUCCESS"){
				var result =  resp.getReturnValue();
                if(result != undefined){
                	//component.set("v.caList", result);    					
                }
			}
		});
		
		$A.enqueueAction(action);
		
	},
    
    onCardChange: function (component, event, helper) {
    	
    }
  
})