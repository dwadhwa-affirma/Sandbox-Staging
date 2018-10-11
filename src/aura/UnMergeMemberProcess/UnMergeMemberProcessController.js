({
	doInit : function(component, event, helper) {
		var action = component.get("c.GetMemberList");		
		action.setCallback(this, function (response) {		
			 var status = response.getState();
			 
	        if (component.isValid() && status === "SUCCESS") {
	        	var result =  response.getReturnValue();	
	        	if(result[0].length > 0){            
	        		component.set("v.accounts", result[0]);  
	        		component.set("v.NoMemberAvailable", false);  
	            }   
	            else
	            {
	            	component.set("v.NoMemberAvailable", true);  
	            }      
	            
	        }
		      
	       
		 });
	  $A.enqueueAction(action);
	},
	
	unmergeAccount : function(component, evt)
		{
			var action = component.get("c.UnMergeMemberAccount");
			var mid = component.get("v.radioSelected");
			
			
				if(mid == null || mid == ''){
				  var toastEvent1 = $A.get("e.force:showToast");
						        toastEvent1.setParams({		            
						            message : 'Please select member',	                        
						            duration:' 3000',
						            key: 'info_alt',
						            type: 'Error',
						            mode: 'pester'
						        });
						        toastEvent1.fire();	
						        return;
				}
				
			  action.setParams({
			    	"mid" : mid		    	
			  });

			action.setCallback(this, function(response){
			component.set("v.loading", true);
			var state = response.getState();
	        if (state === "SUCCESS") {
	            var result =  response.getReturnValue();	            
	            component.set("v.success", true);
	             
	             var toastEvent = $A.get("e.force:showToast");
	        
		        toastEvent.setParams({		            
		            message : 'The record has been unmerged successfully.',	                        
		            duration:' 3000',
		            key: 'info_alt',
		            type: 'success',
		            mode: 'pester'
		        });
		        toastEvent.fire();	
	            var mid1 = component.get("v.radioSelected");
	            window.location.href = '/lightning/r/Account/' + result +'/view' 
               // var mid1 = component.get("v.radioSelected");
	            //window.location.href = '/lightning/r/Account/' + mid1 +'/view' 
	        
	        }	    

			});
			
			$A.enqueueAction(action);
		},
		
		onRadioClick : function(component, event, helper) {
         
		        var selected = event.target.value;		        
		        component.set("v.radioSelected", selected);   
		            
		 
	 },
})