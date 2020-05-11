({
	myAction : function(component, event, helper) {
		
	},
	
	expand : function(component, event, helper) {
    	
		var icon = component.get("v.AddIconName");
		var container = component.find("containerCollapsable") ;
		if(icon == 'utility:add'){
			$A.util.toggleClass(container, 'hide');
			component.set('v.AddIconName','utility:dash');
		}
		else{
			$A.util.toggleClass(container, 'hide');
			component.set('v.AddIconName','utility:add');
		}
		
    }
})