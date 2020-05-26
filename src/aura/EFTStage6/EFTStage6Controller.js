({
	doInit : function(component, event, helper) {
        debugger;
		var action = component.get("c.createCase");
		//var recordId = component.get("v.recordId");	
		action.setParams({
		"EFTRecord": component.get("v.EFTRecord")
		});	
		action.setCallback(this, function(resp) {			
			var state=resp.getState();			
			if(state === "SUCCESS"){				
				var res = resp.getReturnValue();
                component.set("v.EFTRecord",res);
                helper.sendACHDocument(component, event, helper);
				/*var eft =[];
				eft=res;
                component.set("v.EFTRecord",eft[0]);
                component.set("v.CaseId",eft[0].Case__r.CaseNumber);
                alert(component.get("v.CaseId"));*/
				}
			});
        $A.enqueueAction(action);
	},
	
	
})