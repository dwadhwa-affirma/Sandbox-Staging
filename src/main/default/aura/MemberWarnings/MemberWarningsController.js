({
	myAction : function(component, event, helper) {
		
	},
    doInit : function(component, event, helper) {
    var recordId=component.get('v.recordId');
    var action = component.get("c.GetMemberInfoWarnings");
    action.setParams({
        accountId : recordId
    });
    action.setCallback(this, $A.getCallback(function(response) {
        var state = response.getState();
        var response = response.getReturnValue();
        if (state == "SUCCESS") {	
            console.log(response);
            component.set("v.warnings",response);
        }else{
            console.log('Error occured while getting the account data.');
        }
    }));
    $A.enqueueAction(action);
	}
})