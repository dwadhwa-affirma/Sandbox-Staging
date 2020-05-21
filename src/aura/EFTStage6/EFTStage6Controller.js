({
	doInit : function(component, event, helper) {
        debugger;
		var action = component.get("c.getEFTDetails");
		var recordId = component.get("v.recordId");	
		action.setParams({
		"recordId": recordId
		});	
		action.setCallback(this, function(resp) {			
			var state=resp.getState();			
			if(state === "SUCCESS"){				
				var res = resp.getReturnValue();
				var eft =[];
				eft=res;
                component.set("v.EFT",eft[0]);
				}
			});
        $A.enqueueAction(action);
	}
})