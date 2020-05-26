({
	sendACHDocument : function(component, event, helper) {
		debugger;
		var action = component.get("c.sendACHDocument");
		//var recordId = component.get("v.recordId");	
		action.setParams({
		"recordId": component.get("v.EFTRecord")
		});	
		action.setCallback(this, function(resp) {			
			var state=resp.getState();			
			if(state === "SUCCESS"){				
				var res = resp.getReturnValue();
                
                
				}
			});
        $A.enqueueAction(action);
	
	}
})