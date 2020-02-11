({
	doInit : function(component, event, helper) {
		
		var memberId = component.get("v.recordId");
		var CFCUWalletStatusForDay = component.get("v.CFCUWalletStatusForDay");
		helper.GetJointMemberDetail(component, event, memberId);
		
	},
	
	
	ButtonClick : function(component, event, helper) {
        var ButtonId = event.getSource().getLocalId();
        var Button = event.getSource();
        helper.ButtonPassFailMethod(component, event, helper,ButtonId,Button);
       
       
    },
})