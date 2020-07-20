({
	doInit : function(component, event, helper) {
		
        
        var action = component.get("c.GetAllData");
        
        action.setCallback(this, function (response) {
        
        	var status = response.getState();
            if (component.isValid() && status === "SUCCESS") {
            	
            	var result = response.getReturnValue();
            	component.set("v.CustomLinkslist", result.CustomLinkslist);
        		component.set("v.CFCULinkslist", result.CFCULinkslist);
        		//component.set("v.ShortCutslist", result.ShortCutslist); 
        		       		
            }
            else if (status === "ERROR") {
                var errors = response.getError();
                console.error(errors);
            }        	
        });
     
        $A.enqueueAction(action);

    }
})