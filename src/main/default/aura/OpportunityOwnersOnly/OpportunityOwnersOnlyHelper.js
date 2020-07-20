({
    fetchOpportunities: function(component) {
        component.set("v.loading", true);
     
        var action = component.get("c.GetuserOpportunities");
		
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var result = response.getReturnValue();
                component.set("v.Model", result);      
                if(result.length > 0)
                {          
                	component.set("v.newOpportunity", result[0].OpportunityModel);
                	component.set("v.newOpportunity.Queue_Owner__c", result[0].OpportunityModel.Queue_Owner__c);
                	component.set("v.newOpportunity.User_Owner__c", result[0].OpportunityModel.User_Owner__c);
                	
                }
                
                
            }
            component.set("v.loading", false);
        });

        $A.enqueueAction(action);
        
        
    },
    
    selectAllOpportunities:function(component) {
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

    updateOpportunities: function(component) {
        component.set("v.loading", true);
        
        
        var data = component.get("v.Model");
       var ownertype = component.get("v.newOpportunity.Ownership__c");
       var owner = '' ; 
       if(ownertype == undefined || ownertype == null)
       {
    	   ownertype = "User";
       }
       if(ownertype == "User")
       {
    	    Owner = component.get("v.newOpportunity.User_Owner__c");
       }
       else
       {
    	   Owner = component.get("v.newOpportunity.Queue_Assigned_Id__c"); 
       }
        
        
        var isSelected = false;
        for(var m=0; m < data.length; m++)
        {            
        	if(data[m].selected)
        	{
        		isSelected = true;
        	}
            delete data[m].OpportunityModel["Owner"];            
        }    
        
        if(isSelected && Owner != undefined && Owner != null && Owner != '')
        {
	        var action = component.get("c.saveUserOpportunities");   
            var wrapperArray = new Array();
            for(var m=0; m < data.length; m++)
            {            
                if(data[m].selected)
                {
                                       data[m].selected = true;
                    var item = { OpportunityModel: { id:  data[m].OpportunityModel.Id }, selected: true };
                    wrapperArray.push(item);       		
                }
               
            }
            
	        action.setParams({
		    	"qWrapstr" : JSON.stringify(wrapperArray),
	            "OwnerId" : Owner,
	            "ownertype" : ownertype
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
		            message : 'Please select atleast one Opportunity and Owner.',	                        
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