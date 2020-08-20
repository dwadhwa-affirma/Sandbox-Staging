({
	myAction : function(component, event, helper) {
		
	},
	
	LoadBankName : function(component, event, helper) {
    var RoutingNumber = component.get("v.EFTRecord.Routing_Number__c");
    if(RoutingNumber != null && (RoutingNumber.length != 9 || (RoutingNumber.substring(0,1) != '0' && 
        RoutingNumber.substring(0,1) != '1' && RoutingNumber.substring(0,1) != '2' &&
        RoutingNumber.substring(0,1) != '3'))){                        
                        alert('Plese enter valid ABA/Routing Number.');
                        return;
                    }  
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
                    var a = component.get('c.onTypeChange');
                    $A.enqueueAction(a);
                
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