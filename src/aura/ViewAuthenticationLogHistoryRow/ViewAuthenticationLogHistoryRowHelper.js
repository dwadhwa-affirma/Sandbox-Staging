({
	helperMethod : function() {
		
	},
	
	GetLogData: function (component, event, helper, memberId, GUID) {
		var action = component.get("c.GetLogHistoryDetailData");
			action.setParams({"MemberId": memberId, "GUID": GUID});
		    action.setCallback(this, function (response) {
			var status = response.getState();            
				if (component.isValid() && status === "SUCCESS") {
					    var result = response.getReturnValue();
					     if(result.length > 0){ 
					    					    	
					    	 component.set("v.LogData", result);
					    	 component.set("v.LogNumber", (result[0].LogNumber));
					     }
		            
			    }
			    });	
				  
				$A.enqueueAction(action); 
	
	},
})