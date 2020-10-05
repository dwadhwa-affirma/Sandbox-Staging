({
	doInit : function(component, event, helper) {
		debugger;
		var RecordId = component.get("v.recordId");
		helper.GetData(component, event, helper, RecordId);
		
	},
})