({
	getCaseDetails : function(component) {
		var action = component.get("c.FetchCaseData");
        
        var recordid = component.get("v.recordId");        
        action.setParams({ "recordId": recordid });
        component.set("v.loading", true);
        
        action.setCallback(this, function (response) {        	
            var status = response.getState();            
            if (component.isValid() && status === "SUCCESS") {
                var result = response.getReturnValue();                
                component.set("v.Model", result);
                component.set("v.loading", false);
            }
            
            component.set("v.ErrorMessage", '');
        });  
                
        $A.enqueueAction(action);        
	},
	
	
	saveCaseDetails:function(component){
		component.set("v.loading", true);
		var recordId = component.get("v.recordId");
		var status = component.get("v.Model.Status");
		var Reason = component.get("V.Model.Reason");
		var Comments = component.get("V.Comments");
		if(status == '' || status == null || status == undefined)
		{
			component.set("v.ErrorMessage", 'Invalid Status !');
			component.set("v.loading", false);
		}
		else
		{
				component.set("v.ErrorMessage", '');
				var action = component.get("c.closeCaseSave");			
			    action.setParams({
			    	"recordId" : recordId,
			    	"status" : status,
			    	"Reason" : Reason,
			    	"Comments" : Comments
			    });	    
			    
			    action.setCallback(this, function(response){	    	    	
			        var state = response.getState();
			        
			        if (state === "SUCCESS") {
			            var result =  response.getReturnValue();
			            //component.set("v.LeadObject", result);
						var toastEvent = $A.get("e.force:showToast");
			        
				        toastEvent.setParams({		            
				            message : 'Record Saved Successfully',	                        
				            duration:' 3000',
				            key: 'info_alt',
				            type: 'success',
				            mode: 'pester'		            
				        });
				        toastEvent.fire();	
				        $A.get('e.force:closeQuickAction').fire();	
			        }
			        else
			        {
			        	component.set("v.ErrorMessage", response.getError()[0].pageErrors[0].message);		        
			        }	        
			        component.set("v.loading", false);
			    });
			    
			    $A.enqueueAction(action);
	    }
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
}	
})