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
            let jsonObject = response.map(JSON.stringify); 
            let uniqueSet = new Set(jsonObject); 
            let uniqueArray = Array.from(uniqueSet).map(JSON.parse); 
            component.set("v.warnings",uniqueArray);
        }else{
            console.log('Error occured while getting the account data.');
        }
    }));
    $A.enqueueAction(action);
	}
})