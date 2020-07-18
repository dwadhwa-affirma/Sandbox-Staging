({
	doInit : function(component, event, helper) {
		helper.fetchPicklistFields(component);
	},
	
	onBaseSave : function(component, event, helper) {		
		var currId = component.get("v.recordId");
		helper.saveOnBasedata(component, currId);
	},	
	
    closePopup: function(component, event, helper) {
	    var updateEvent = component.getEvent("ClosePopup");
        updateEvent.fire();
   }    
})