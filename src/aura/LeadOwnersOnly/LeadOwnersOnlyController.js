({
	doInit : function(component, event, helper) {	
		component.set("v.selectAll", false);
		helper.fetchLeads(component);
	},
	
	updateRecords : function(component, event, helper) {		
		helper.updateLeads(component);
	},
	
	selectAllchange: function(component, event, helper) {		
		helper.selectAllLeads(component);
	},
	
	selectLead: function(component, event, helper) {
		component.set("v.loading", true);		
		var currentId =  event.target.getAttribute('data-row-index');
		if(currentId != undefined && currentId != null && currentId != '')
		{
			var navEvt = $A.get("e.force:navigateToSObject");
	        navEvt.setParams({
	        	"recordId": currentId,
	        	"slideDevName": "related"
	        });
	        navEvt.fire(); 
		}
		component.set("v.loading", false);
	}
})