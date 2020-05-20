({
	myAction : function(component, event, helper) {
		
	},
	
	LoadBankName : function(component, event, helper) {
	var action = component.get("c.routingInfo");
        action.setParams({
            "RoutingNumber": component.get("v.RoutingNumber")
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (component.isValid() && state === "SUCCESS") {
                var result = response.getReturnValue();
				if(result != undefined && result != '' && result != null)
					component.set("v.RoutingBankName", result);
                
            }
        });
 
        $A.enqueueAction(action);
    }
})