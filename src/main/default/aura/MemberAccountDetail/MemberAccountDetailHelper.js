({
	getMemberlist : function(component, Id) {    	
		var action = component.get("c.GetAccountDetails");		
		action.setParams({
		"AccountId": Id
		});			
			action.setCallback(this, function(resp) {
			var state=resp.getState();
			console.log('state ' + state);
			if(state === "SUCCESS"){
				var res = resp.getReturnValue();
				component.set('v.memberList', res);
			}
		});
		$A.enqueueAction(action);
	}
})