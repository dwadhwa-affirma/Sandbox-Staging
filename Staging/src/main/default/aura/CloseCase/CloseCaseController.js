({
	doInit : function(component, event, helper) {
		helper.getCaseDetails(component);
	},
	
	SaveCloseCase : function(component, event, helper) {
		helper.saveCaseDetails(component);
	},
	
	closePopup: function(component, event, helper) {
	  $A.get('e.force:closeQuickAction').fire();
   },    
})