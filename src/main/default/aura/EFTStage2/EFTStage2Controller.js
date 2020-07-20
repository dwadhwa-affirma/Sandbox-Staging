({
	doInit : function(component, event, helper) {
		var action = component.get("c.getShareAccounts");
		
		//var EFTRecord = component.get("v.EFTRecord");		
		
		action.setParams({
		"AccountNumber": "0000214414"
		});			
		action.setCallback(this, function(resp) {
			var state=resp.getState();			
			if(state === "SUCCESS"){
				//alert('d');
							
			}
		});
		
		$A.enqueueAction(action);
    	
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