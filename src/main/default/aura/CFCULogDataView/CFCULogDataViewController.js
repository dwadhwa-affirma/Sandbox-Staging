({
	doInit : function(component, event, helper) {
		debugger;
		var LogId = component.get("v.recordId");
		helper.GetMasterLogData(component, event, helper, LogId);
		
	},
})