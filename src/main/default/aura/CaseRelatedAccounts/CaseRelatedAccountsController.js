({
	doInit : function(component, event, helper) {		
		helper.getCaseAccounts(component);
		
	},	
	
	ClickObj: function(component, event, helper) {  
	 var id = event.target.id;
			var sObectEvent = $A.get("e.force:navigateToSObject");
		   					 sObectEvent .setParams({
		   					 "recordId": id,
		    				 "slideDevName": "view"
		   					});
	    					sObectEvent.fire(); 
	 }
})