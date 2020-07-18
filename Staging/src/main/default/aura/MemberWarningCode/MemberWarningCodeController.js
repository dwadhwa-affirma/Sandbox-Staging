({
	doInit : function(component, event, helper) {
		component.set('v.loading',true);
		 var action = component.get("c.getData");
		  var recordid = component.get("v.recordId");
		   var parameters = {"accoutid": recordid };
		   action.setParams(parameters);
		   action.setCallback(this, function(response){
			   var status = response.getState();
	        	if(component.isValid() && status === "SUCCESS")
	        	{
	        		var result =  response.getReturnValue();
	        		component.set('v.rwcwList', result);
	        	}
	        	component.set('v.loading',false);
		   });
		   $A.enqueueAction(action);
	}
})