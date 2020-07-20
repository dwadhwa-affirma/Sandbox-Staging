({
	helperMethod : function() {
		
	},
	
	GetLogData: function (component, event, helper, memberId, GUID) {
		var action = component.get("c.GetMAAPLogData");
			action.setParams({"MemberId": memberId});
		    action.setCallback(this, function (response) {
			var status = response.getState();            
				if (component.isValid() && status === "SUCCESS") {
					    var result = response.getReturnValue();
					     if(result.length > 0){ 
					    					    	
					    	 component.set("v.LogData", result);
					     }
		            
			    }
			    });	
				  
				$A.enqueueAction(action); 
	
	},
	
})