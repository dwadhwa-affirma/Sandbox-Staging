({
	helperMethod : function() {
		
	},
	GetLogData: function (component, event, helper, DaysParam, memberId, GUID) {
		var action = component.get("c.GetLogHistoryData");
			action.setParams({"MemberId": memberId, "Days":DaysParam,"GUID": GUID});
		    action.setCallback(this, function (response) {
			var status = response.getState();            
				if (component.isValid() && status === "SUCCESS") {
					    var result = response.getReturnValue();
					     if(result.length > 0){ 
					    					    	
					    	 component.set("v.LogData", result);
					    	 component.set("v.LastIndex", result.length);
					     }
		            
			    }
			    });	
				  
				$A.enqueueAction(action); 
	
	},
})