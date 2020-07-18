({
	changeOwnership : function(component) {
		var action = component.get("c.changeCaseOwnership");
		var caseId = component.get("v.recordId");
		component.set("v.loading", true);
		action.setParams({		    	
	            "caseId" : caseId
		    });
		    
        action.setCallback(this, function(response) {        
            var state = response.getState();
           
            component.set("v.loading", false);
            if (state === "SUCCESS") {
                var result = response.getReturnValue();
                
                if(result === 'Lead' || result === 'Opportunity' )
                {
                	 var toastEvent = $A.get("e.force:showToast");                	        
                	 toastEvent.setParams({		            
	                	message : 'Take ownership is not allowed for closed '+result+'.',	                        
				        duration:' 10000',
				        key: 'error_alt',
				        type: 'error',
				        mode: 'error'
	                });
				    toastEvent.fire();
                	$A.get('e.force:closeQuickAction').fire();
                	return;
                }
                else{
	                var toastEvent = $A.get("e.force:showToast");                	        
	                toastEvent.setParams({		            
	                	message : 'Record updated Successfully',	                        
				        duration:' 3000',
				        key: 'info_alt',
				        type: 'success',
				        mode: 'pester'
	                });
				    toastEvent.fire();
	                $A.get('e.force:refreshView').fire();   
	                $A.get('e.force:closeQuickAction').fire();
                }
            }
        });
        $A.enqueueAction(action);
	}
})