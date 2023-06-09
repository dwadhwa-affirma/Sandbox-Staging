({
	doInit : function(component, event, helper) {
	
		var action = component.get("c.ConvertLead");
		var recordid = component.get("v.recordId"); 
		
		action.setParams({"leadId": recordid});    
		component.set("v.loading", true);
		 
		  
		 action.setCallback(this, function (response) {  
		    	
            var status = response.getState();            
	       	    if (component.isValid() && status === "SUCCESS") {
	               var result = response.getReturnValue();
                    if(result.ExistingMember != undefined){
                        var toastEvent = $A.get("e.force:showToast");
				        toastEvent.setParams({
				            title : 'Error Message',
				            message:'You cannot convert Existing Member',
				            messageTemplate: 'Error Message',
				            duration:' 5000',
				            key: 'info_alt',
				            type: 'error',
				            mode: 'pester'
				        });
				        toastEvent.fire();
				        $A.get("e.force:closeQuickAction").fire();
                    } 
	               else if(result.ClosedLead != undefined)
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
				       /*  var sObectEvent = $A.get("e.force:navigateToSObject");
                                     sObectEvent .setParams({
                                     "recordId": component.get("v.recordId"),
                                        "slideDevName": "detail"
                                    });
                                    sObectEvent.fire(); */
				        
	               }
                  
	               else{
	               
				       component.set("v.accId", result.listObj[0][0]);
                            
                            component.set("v.oppId", result.listObj[0][1]);
                            component.set("v.oppNumber", result.listObj[0][2]);
                            
                            component.set("v.LeadObject", result.listObj[1]);
                          
                            
                            
                             var sObectEvent = $A.get("e.force:navigateToSObject");
                                     sObectEvent .setParams({
                                     "recordId": component.get("v.accId"),
                                        "slideDevName": "detail"
                                    });
                                    sObectEvent.fire(); 
	              
                    }
	              
	                  
                    
               //component.set("v.convertLeadButtonDisabled", isConverted);
            }
            else
            {
            	 component.set("v.loading", false);
            }
        });  
		
		
		$A.enqueueAction(action);
		
		
	/*	 var objLead = component.get("v.LeadObject");
         var action1 = component.get("c.ConvertLead");
        action1.setParams({
	    	"leadObject" : objLead
	    });
		component.set("v.loading", true);
		
			action1.setCallback(this, function(response){
    	   	
	            var status = response.getState();            
	       	    if (component.isValid() && status === "SUCCESS") {
	               var result = response.getReturnValue();  
	               component.set("v.loading", false);
	
	                
	                component.set("v.accId", result[0]);
	                
	                component.set("v.oppId", result[1]);
	                component.set("v.oppNumber", result[2]);
	              
	              
	                
	                component.set("v.success", true);
	                
	      	    }
       });
      
       $A.enqueueAction(action1);
			
		*/
		   
	},
	 closePopup: function(component, event, helper) {
	  $A.get('e.force:closeQuickAction').fire();
   }, 
	
	
   /* ConvertLead1: function (component, event, helper) {
    debugger;
   
        var objLead = component.get("v.LeadObject");
       
        var action = component.get("c.ConvertLead");
        action.setParams({
	    	"leadObject" : objLead
	    });
		component.set("v.loading", true);
		
       action.setCallback(this, function(response){
    	   	
            var status = response.getState();            
       	    if (component.isValid() && status === "SUCCESS") {
               var result = response.getReturnValue();  
               component.set("v.loading", false);

                
                component.set("v.accId", result[0]);
                
                component.set("v.oppId", result[1]);
                component.set("v.oppNumber", result[2]);
              
              
                
                component.set("v.success", true);
                
	      	    }
       });
      
       $A.enqueueAction(action);
       
    },
    */
    navigateToPremember: function (component, event, helper) {
	     var sObectEvent = $A.get("e.force:navigateToSObject");
		    sObectEvent .setParams({
		    "recordId": component.get("v.accId"),
		    "slideDevName": "detail"
		   });
	    sObectEvent.fire(); 
	},
	
	/*navigateToOpportunity: function (component, event, helper) {
	     var sObectEvent = $A.get("e.force:navigateToSObject");
		    sObectEvent .setParams({
		    "recordId": component.get("v.oppId"),
		    "slideDevName": "detail"
		   });
	    sObectEvent.fire(); 
	}*/
    
})