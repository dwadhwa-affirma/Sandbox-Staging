({
	doInit : function(component, event, helper) {
		
		var RecordId = component.get("v.recordId");
		helper.doInit(component, event,helper,RecordId);
	
	},
    
    ApproveTransaction: function(component, event, helper) {		
		var RecordId = component.get("v.recordId");
		helper.ApproveTransaction(component, event,helper,RecordId);	
	}
})