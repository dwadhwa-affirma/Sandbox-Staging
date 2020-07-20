({
	getCaseAccounts : function(component) {	
		var action = component.get("c.GetCaseAccounts");
		var recordId = component.get("v.recordId");	
		
		action.setParams({
		"CaseId": recordId
		});
			debugger;
			action.setCallback(this, function(resp) {				
			var state=resp.getState();			
			if(state === "SUCCESS"){	
			debugger;	
				var res = resp.getReturnValue();
				console.log(res);				
				component.set("v.Accounts", res); 	
							 			
			}
		});
		
		$A.enqueueAction(action);
	},
})