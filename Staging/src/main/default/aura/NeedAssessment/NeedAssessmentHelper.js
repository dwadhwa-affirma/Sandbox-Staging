({
	SaveAssessmentHelper: function(component, section, data, accountid, SubItems, deletedItems) {
	    var action = component.get("c.SaveNeedAssessmentData");	    
	    action.setParams({
	    	"objNeedsAssesment" : data,
	        "SectionName": section,
	        "accountid":accountid,
	        "SubItems":SubItems,
	        "deletedItems":deletedItems
	    });	
	    
	    action.setCallback(this, function(response){
	    	    	
	        var state = response.getState();	        
	        if (state === "SUCCESS") {
	            var result =  response.getReturnValue();
	            
				component.set("v.Model", result);
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
	},
	
	changeOptOut : function(component, optout, accountid) {	
		component.set("v.loading", true);
		var action = component.get("c.changeoptout");	    
	    action.setParams({
	    	"optout" : optout,
	    	"Accountid" : accountid	        
	    });	
	    
	    action.setCallback(this, function(response){
	    	    	
	        var state = response.getState();	        
	        if (state === "SUCCESS") {
	            var result =  response.getReturnValue();	            
				component.set("v.Model", result);
				 var toastEvent = $A.get("e.force:showToast");
	        
		        toastEvent.setParams({		            
		            message : 'Opt Out updated Successfully',	                        
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
})