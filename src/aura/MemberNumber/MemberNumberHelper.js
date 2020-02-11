({
	fetchrecords : function(component) {	
		component.set("v.loading", true);
        var action = component.get("c.FetchAccounts");
        var currentText = component.get("v.searchText");
        action.setParams({
		    	"searchText" : currentText	
		    });
		
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var result = response.getReturnValue();
                component.set("v.Model", result['AccountDetail']);
                var search = component.get("v.searchText");
                if(result['AccountDetail'].length > 0){
                	component.set("v.NoRecord", false);
                }
                else
                {
                	component.set("v.NoRecord", true);
                }
                if(result['UserProfile'].length > 0){
                	component.set("v.UserProfile", result['UserProfile'][0].Name);
                }
                
            }
            component.set("v.loading", false);
        });

        $A.enqueueAction(action);
	}
})