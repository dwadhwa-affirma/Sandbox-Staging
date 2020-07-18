({
	myAction : function(component, event, helper) {
		
	},
	
	LoadBankName : function(component, event, helper) {
	helper.showSpinner(component);
	var action = component.get("c.routingInfo");
        action.setParams({
            "RoutingNumber": component.get("v.EFTRecord.Routing_Number__c")
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (component.isValid() && state === "SUCCESS") {
                var result = response.getReturnValue();
				if(result != undefined && result != '' && result != null)
					component.set("v.EFTRecord.Bank_Name__c", result);
                
            }
            helper.hideSpinner(component,helper);
        });
 
        $A.enqueueAction(action);
    },
    
    onTypeChange : function(component, event, helper) {
        debugger;
        var evt = $A.get("e.c:EFTEvent");
        var RoutingNumber = component.get("v.EFTRecord.Routing_Number__c");
        var RoutingBankName = component.get("v.EFTRecord.Bank_Name__c");
        var AccountNumber = component.get("v.EFTRecord.Account_Number__c");
        var Type = component.get("v.EFTRecord.Type__c");//event.getSource().get('v.value');
        component.set("v.EFTRecord.Stage__c",'FI');
        
		if(Type != undefined){
            evt.setParams({ "EFTRecord": component.get("v.EFTRecord")});
            evt.fire();
        }
        
    }
})