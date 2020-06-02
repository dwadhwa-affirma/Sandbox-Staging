({
	doInit : function(component, event, helper) {
		
		var SolarLoanRecordId = component.get("v.recordId");	
	},
    
    LoadBankName : function(component, event, helper) {
    var RoutingNumber = component.get("v.RoutingNumber");    
	helper.showSpinner(component);
    var action = component.get("c.routingInfo");
        action.setParams({
            "RoutingNumber": RoutingNumber
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (component.isValid() && state === "SUCCESS") {
                var result = response.getReturnValue();
				if(result != undefined && result != '' && result != null)
                    if(result != 'Bank name not found'){
                    	component.set("v.IsButtonDisabled", false);   
                    }
                    component.set("v.ABABankName", result);
                
            }
            helper.hideSpinner(component,helper);
        });
 
        $A.enqueueAction(action);
    },
    
    cancel: function(component, event, helper) {
     	
        $A.get("e.force:closeQuickAction").fire() 
    },
    
    save: function(component, event, helper) {
     	
        var SolarLoanRecordId = component.get("v.recordId");
        var RoutingNumber = component.get("v.RoutingNumber");    
        var BankName = component.get("v.ABABankName");    
        var action = component.get("c.saveRoutingInfo");
        
        action.setParams({"SolarLoanRecordId": SolarLoanRecordId,
                          "RoutingNumber": RoutingNumber,
                          "BankName": BankName});
            
        action.setCallback(this, function(a) {
            var state = a.getState();
            if (state === "SUCCESS") {
                $A.get("e.force:closeQuickAction").fire();
                $A.get('e.force:refreshView').fire();
            }
        });
        $A.enqueueAction(action);
        
    }
})