({
	doInit : function(component, event, helper) {		
        debugger;
		helper.getMemberlist(component, component.get('v.recordId') );
	}
})