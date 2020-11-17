({
    doInit : function(component, event, helper) {
        var action = component.get("c.GetLeadInfo");
		var recordid = component.get("v.recordId"); 
		
		action.setParams({"leadId": recordid});    
		component.set("v.loading", true);
        	  
		 action.setCallback(this, function (response) {  
		    	
            var status = response.getState();            
	       	    if (component.isValid() && status === "SUCCESS") {
                  
                    var result = response.getReturnValue(); 
	               if(result.Lead !=undefined)
	               {
                       component.set("v.LeadObject", result.Lead);
	               }
            }
            
        });  
		
		
		$A.enqueueAction(action);


    },
    convertLead : function(component, event, helper) {
        
		var action = component.get("c.ConvertLead");
		var recordid = component.get("v.recordId"); 
		
		action.setParams({"leadId": recordid});    
		component.set("v.loading", true);
        	  
		 action.setCallback(this, function (response) {  
		    	
            var status = response.getState();            
	       	    if (component.isValid() && status === "SUCCESS") {
                  
                    var result = response.getReturnValue(); 
	               if(result !=undefined && result.length == 0)
	               {
	            	   var toastEvent = $A.get("e.force:showToast");
				        toastEvent.setParams({
				            title : 'Error Message',
				            message:'You cannot convert Lead with status Closed',
				            messageTemplate: 'Error Message',
				            duration:' 5000',
				            key: 'info_alt',
				            type: 'error',
				            mode: 'pester'
				        });
				        toastEvent.fire();
				        $A.get("e.force:closeQuickAction").fire();
				       
				        
	               }
	               
	               else{
                       
				        component.set("v.accId", result.AccountId);                            
                        component.set("v.oppId", result.OpportunityId);
                        component.set("v.ContactId", result.ContactId);                                                  
                        component.set("v.success", true);    
                            
                             
	              
                    }
	                             
              
            }
            else
            {
                 component.set("v.loading", false);                
            }
        });  
		
		
		$A.enqueueAction(action);
		
		
	
		   
	},
	 closePopup: function(component, event, helper) {
	  $A.get('e.force:closeQuickAction').fire();
   }, 
   NavigateToContact: function(component, event, helper){

            var sObectEvent = $A.get("e.force:navigateToSObject");
            sObectEvent .setParams({
            "recordId": component.get("v.ContactId"),
            "slideDevName": "detail"
        });
        sObectEvent.fire(); 
   },
	
  
   
	
	
})