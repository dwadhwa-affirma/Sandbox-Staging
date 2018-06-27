({
	getAttachmentData : function(component, uniqueId, helper) {
		component.set("v.loading", true);
		var action = component.get("c.getAttachmentData");	    
	    action.setParams({
	    	"caseId" : uniqueId
	    });
	    
	    action.setCallback(this, function(response){	    	
	        var state = response.getState();	        
	        if (state === "SUCCESS") {	        	
	            var result =  response.getReturnValue();	            
				component.set("v.Model", result);												
	        }
	        component.set("v.loading", false);
	        
			
	    });
	    
	    $A.enqueueAction(action);
	},
	
	saveAttachmentsdata : function(component, uniqueId) {
		component.set("v.loading", true);
		var action = component.get("c.saveAttachments");	 
		   
	    action.setParams({	    	
	    	"wrapperString" :  JSON.stringify( component.get("v.Model.attachments")),
	    	"caseId" : uniqueId,
	    	"approvalids" : component.get("v.Model.approvalids"),
	    });	
	    
	    action.setCallback(this, function(response){	    	
	        var state = response.getState();	        
	        if (state === "SUCCESS") {
	            var result =  response.getReturnValue();	  
	            $A.get('e.force:closeQuickAction').fire();
	                      
				var toastEvent = $A.get("e.force:showToast");
	        
		        toastEvent.setParams({		            
		            message : 'Record Saved Successfully',	                        
		            duration:' 3000',
		            key: 'info_alt',
		            type: 'success',
		            mode: 'pester'
		        });
		        toastEvent.fire();			        
		       
			/*   var sObectEvent = $A.get("e.force:navigateToSObject");
			    sObectEvent .setParams({
			    "recordId": uniqueId,
			    "slideDevName": "detail"
			   });
			    sObectEvent.fire(); */
			      var updateEvent = component.getEvent("ClosePopup");
        updateEvent.fire();
		
	        }
	        else
	        {
	        	$A.get('e.force:closeQuickAction').fire();
	                      
				var toastEvent = $A.get("e.force:showToast");
	        
		        toastEvent.setParams({		            
		            message : 'Something went wrong. Please contact administrator.',	                        
		            duration:' 3000',
		            key: 'info_alt',
		            type: 'error',
		            mode: 'pester'
		        });
		        toastEvent.fire();		
	        }
	        component.set("v.loading", false);
	    });
	    
	    $A.enqueueAction(action);
	},
	
	closest: function(el, selector) {
	    var matchesFn;
	
	    // find vendor prefix
	    ['matches','webkitMatchesSelector','mozMatchesSelector','msMatchesSelector','oMatchesSelector'].some(function(fn) {
	        if (typeof document.body[fn] == 'function') {
	            matchesFn = fn;
	            return true;
	        }
	        return false;
	    })
	
	    var parent;
	
	    // traverse parents
	    while (el) {
	        parent = el.parentElement;
	        if (parent && parent[matchesFn](selector)) {
	            return parent;
	        }
	        el = parent;
	    }
	
	    return null;
	},
   
   getParameterByName: function(name, url) {
	    if (!url) url = window.location.href;
	    name = name.replace(/[\[\]]/g, "\\$&");
	    var regex = new RegExp("[?&]" + name + "(=([^&#]*)|&|#|$)"),
	        results = regex.exec(url);
	    if (!results) return null;
	    if (!results[2]) return '';
	    return decodeURIComponent(results[2].replace(/\+/g, " "));
	}
})