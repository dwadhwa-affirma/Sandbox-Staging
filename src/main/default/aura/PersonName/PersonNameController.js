({
	doInit : function(component, event, helper) {		
		 var action = component.get("c.getData");
		  var recordid = component.get("v.recordId");
		   var parameters = {"accoutid": recordid };
		   action.setParams(parameters);
		   action.setCallback(this, function(response){
			   var status = response.getState();
	        	if(component.isValid() && status === "SUCCESS")
	        	{
	        		var result =  response.getReturnValue();
	        		component.set('v.paList', result);
	        	}	        	
		   });
		   $A.enqueueAction(action);
	},
	click : function(component, event, helper) {			
			var id =event.target.getAttribute("id");
			var sObectEvent = $A.get("e.force:navigateToSObject");
		   					 sObectEvent .setParams({
		   					 "recordId": id,
		    				 "slideDevName": "detail"
		   					});
	    					sObectEvent.fire(); 
	}
})