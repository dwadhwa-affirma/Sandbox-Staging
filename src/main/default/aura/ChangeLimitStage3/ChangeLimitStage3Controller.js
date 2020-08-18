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
    
    onTypeChange: function (component, event, helper) {
        
        var type = event.getSource().get('v.value');    
    	component.set("v.CLRecord.Type__c",type);
    	
    	var evt = $A.get("e.c:ChangeLimitEvent");
        var CL = component.get("v.CLRecord");
        var isMemberSelected = component.get("v.isMemberSelected");
        
        if(CL != undefined){
            evt.setParams({ "CLRecord": CL, "isMemberSelected": isMemberSelected});
            evt.fire();
    	}
    	
    }
  
})