({
	getAccountServiceMenuData : function(component) {
	debugger;
		var action = component.get("c.getAccountServiceMenuData");
		var recordId = component.get("v.recordId");	
		action.setParams({
		"recordId": recordId
		});	
		action.setCallback(this, function(resp) {			
			var state=resp.getState();			
			if(state === "SUCCESS"){				
				var res = resp.getReturnValue();
				console.log(res);
				 component.set("v.Menu",res['Menu']);
				 component.set("v.SubMenu",res['SubMenu']);
				}
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