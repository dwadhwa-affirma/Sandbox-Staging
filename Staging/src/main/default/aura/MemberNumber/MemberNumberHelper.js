({
    searchRecords : function(component, event, helper) {	
		helper.fetchrecords(component);
	},
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
            var table  = document.getElementById('tblMembernoSearch');
			if(table)
				table.style = '';
        });

        $A.enqueueAction(action);
	},
    getUrlParameter: function(name) {
        name = name.replace(/[\[]/, '\\[').replace(/[\]]/, '\\]');
        var regex = new RegExp('[\\?&]' + name + '=([^&#]*)');
        var results = regex.exec(location.search);
        return results === null ? '' : decodeURIComponent(results[1].replace(/\+/g, ' '));
	}
})