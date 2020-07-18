({
//	GetExistingLoansData : function(component, Id) {    	
//		var action = component.get("c.getExistingLoans");
//		action.setParams({
//		"AssessmentId": Id
//		});			
//			action.setCallback(this, function(resp) {
//			var state=resp.getState();
//			console.log('state ' + state);
//			if(state === "SUCCESS"){
//				var res = resp.getReturnValue();
//				component.set('v.otherExistingLoans', res);				
//			}
//		});
//		$A.enqueueAction(action);
//	}
})