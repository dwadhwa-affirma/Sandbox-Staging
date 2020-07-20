({
	cloneCase : function(component, recordId, Subject, Description, Device_Type, Status, Category,MemberComment,CaseComment,Attachment) {
		var action = component.get("c.cloneCaseInsertUpdate");	    
	    action.setParams({
	    	"recordId" : recordId,
	        "Subject": Subject,
	        "Description":Description,
	        "Device_Type":Device_Type,
	        "Status":Status,
	        "Category":Category,
	        "MemberComment":MemberComment,
	        "CaseComment":CaseComment,
	        "Attachment":Attachment
	    });	
	    
	    action.setCallback(this, function(response){
	    	    	
	        var state = response.getState();	        
	        if (state === "SUCCESS") {
	            var result =  response.getReturnValue();
	            
				var navEvt = $A.get("e.force:navigateToSObject");
		        navEvt.setParams({
		        	"recordId": result
		        });
		        navEvt.fire();
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
}
})