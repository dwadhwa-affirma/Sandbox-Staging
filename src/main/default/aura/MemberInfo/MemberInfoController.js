({
	myAction : function(component, event, helper) {
		
	},
    doInit : function(component, event, helper) {
    var recordId=component.get('v.recordId');
    var action = component.get("c.GetMemberInfomation");
    action.setParams({
        accoutid : recordId
    });
    action.setCallback(this, $A.getCallback(function(response) {
        var state = response.getState();
        var response = response.getReturnValue();
        if (state == "SUCCESS") {	
            component.set("v.account",response);
        }else{
            console.log('Error occured while getting the account data.');
        }
    }));
    $A.enqueueAction(action);
	}
})