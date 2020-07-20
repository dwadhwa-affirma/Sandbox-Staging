({
	doInit : function(component, event, helper) {
	 
      var action = component.get("c.getLevel");
	  var recordid = component.get("v.recordId");
	  var parameters = {"accoutid": recordid };
	  action.setParams(parameters);
	  action.setCallback(this, function(response){
	  var status = response.getState();
          if(component.isValid() && status === "SUCCESS")
          {
                var result =  response.getReturnValue();
              	if(result.Level != null){
                    component.set("v.Level",result.Level);
                }
          }
      });
        
      $A.enqueueAction(action);
	}
})