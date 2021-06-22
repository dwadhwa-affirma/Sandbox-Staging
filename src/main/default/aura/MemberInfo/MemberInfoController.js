({
	myAction : function(component, event, helper) {
		
	},
    doInit : function(component, event, helper) {
    	helper.getMemberInformation(component, event, helper);
        helper.getMemberPageMessages(component, event, helper);
	}
})