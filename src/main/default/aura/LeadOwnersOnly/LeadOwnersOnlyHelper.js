({
    fetchLeads: function(component) {
        component.set("v.loading", true);
        var action = component.get("c.GetuserLeads");
		
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var result = response.getReturnValue();
                component.set("v.Model", result);      
                if(result.length > 0)
                {          
                	component.set("v.newLead", result[0].LeadModel);
                }
                component.set("v.newLead.OwnerId", '');
            }
            component.set("v.loading", false);
        });

        $A.enqueueAction(action);
    },
    
    selectAllLeads:function(component) {
    	var isselected = component.get("v.selectAll");
    	var data = component.get("v.Model");
    	        
        for(var m=0; m < data.length; m++)
        {            
        	if(!isselected)
        	{
        		data[m].selected = false;        		
        	}
        	else
        	{
        		data[m].selected = true;
        	}
        }
        component.set("v.Model", data);            
    },

    updateLeads: function(component) {
        component.set("v.loading", true);
        
        
        var data = component.get("v.Model");
        var Owner = component.get("v.newLead.OwnerId");
        var isSelected = false;
        for(var m=0; m < data.length; m++)
        {            
        	if(data[m].selected)
        	{
        		isSelected = true;
        	}
            delete data[m].LeadModel["Owner"];            
        }    
        
        if(isSelected && Owner != undefined && Owner != null && Owner != '')
        {
	        var action = component.get("c.saveUserLeads");        
	        action.setParams({
		    	"qWrapstr" : JSON.stringify(data),
	            "OwnerId" : Owner
		    });
		    
	        action.setCallback(this, function(response) {
	            var state = response.getState();
	            if (state === "SUCCESS") {
	                var result = response.getReturnValue();
	                component.set("v.Model", result);
	                component.set("v.selectAll", false);
	                var toastEvent = $A.get("e.force:showToast");
	        
			        toastEvent.setParams({		            
			            message : 'Record Saved Successfully',	                        
			            duration:' 3000',
			            key: 'info_alt',
			            type: 'success',
			            mode: 'pester'
			        });
			        toastEvent.fire();
	            }
	            component.set("v.loading", false);
	        });
	
	        $A.enqueueAction(action);
        }
        else
        {
        	var toastEvent = $A.get("e.force:showToast");
	        
		        toastEvent.setParams({		            
		            message : 'Please select atleast one Lead and Owner.',	                        
		            duration:' 3000',
		            key: 'info_alt',
		            type: 'error',
		            mode: 'pester'
		        });
		        toastEvent.fire();
		        component.set("v.loading", false);
        }
    },
})