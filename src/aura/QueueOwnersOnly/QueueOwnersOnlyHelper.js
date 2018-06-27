({
    fetchCases: function(component) {
        component.set("v.loading", true);
        var action = component.get("c.GetuserCases");
		
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var result = response.getReturnValue();
                 for(var i = 0; i < result.length; i++)
                {
                	
                	if(result[i].CaseModel.Future_Date__c != null && result[i].CaseModel.Future_Date__c != '')
                	{
                		var date = result[i].CaseModel.Future_Date__c.split("-");
                		var newDate = date[1] +  "/" + date[2] + "/" + date[0];
                		
                		result[i].CaseModel.Future_Date__c = newDate; 
                	}
                	
                }
                component.set("v.Model", result);       
                if(result.length > 0)
                {
                	component.set("v.newCase", result[0].CaseModel);
                }
                component.set("v.newCase.OwnerId", '');
            }
            component.set("v.loading", false);
        });

        $A.enqueueAction(action);
    },
    
    selectAllCases:function(component) {
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

    updateCases: function(component) {
        component.set("v.loading", true);
        
        
        var data = component.get("v.Model");
        var Owner = component.get("v.newCase.OwnerId");
        var isSelected = false;
        for(var m=0; m < data.length; m++)
        {            
        	if(data[m].selected)
        	{
        		isSelected = true;
        	}
            delete data[m].CaseModel["Owner"];            
        }    
        
        if(isSelected && Owner != undefined && Owner != null && Owner != '')
        {
	        var action = component.get("c.saveUserCases");        
	        action.setParams({
		    	"qWrapstr" : JSON.stringify(data),
	            "OwnerId" : Owner
		    });
		    
	        action.setCallback(this, function(response) {
	            var state = response.getState();
	            if (state === "SUCCESS") {
	                var result = response.getReturnValue();
	                if(result != null && result.lenght > 0)
	                {
		                for(var i = 0; i < result.length; i++)
		                {
		                	
		                	if(result[i].Future_Date__c != null && result[i].Future_Date__c != '')
		                	{
		                		var date = result[i].Future_Date__c.split("-");
		                		var newDate = date[1] +  "/" + date[2] + "/" + date[0];
		                		
		                		result[i].Future_Date__c = newDate; 
		                	}
		                	
		                }
		            }
	                
	                component.set("v.Model", result);
	                component.set("v.selectAll", false);
	                //component.set("v.newCase.OwnerId", '');
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
		            message : 'Please select atleast one case and Owner.',	                        
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