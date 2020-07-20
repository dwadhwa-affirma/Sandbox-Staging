({
	GetAuthenticationLevel : function(component, event, helper) {
	
		var action = component.get("c.GetMemberAuthenticationLevel");
			action.setParams({});
			action.setCallback(this, function(response){
			
				var status = response.getState();
				if(status==="SUCCESS"){
				
					var result = response.getReturnValue();
					if(result!=undefined && result.length > 0){
					
						component.set("v.LevelData", result);
					}
				}
			
			});
			$A.enqueueAction(action);
			
			
	},
})