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
                 this.hideSpinner(component);
                
				}
			});
        $A.enqueueAction(action);
	
	},
    
    
    showSpinner: function(component) {
		var spinnerMain =  component.find("Spinner");
		$A.util.removeClass(spinnerMain, "slds-hide");
	},
 
	hideSpinner : function(component) {
		var spinnerMain =  component.find("Spinner");
		$A.util.addClass(spinnerMain, "slds-hide");
	},
})