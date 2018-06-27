({
	getLeadBusinessHours : function(component) {
		var action = component.get("c.GetLeadHours");
		var recordId = component.get("v.recordId");
		action.setParams({
		"LeadId": recordId
		});
		
			action.setCallback(this, function(resp) {				
			var state=resp.getState();			
			if(state === "SUCCESS"){		
				var res = resp.getReturnValue();
				console.log(res);				
				component.set("v.OpenHour", res.Open_Hours__c); 							
				      			
			}
		});
		
		$A.enqueueAction(action);
		
	}
})