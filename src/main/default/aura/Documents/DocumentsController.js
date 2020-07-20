({
    doInit: function(component, event, helper) {
        /*component.set("v.loading", true);
		var action = component.get("c.GetAllData");
        var recordid = component.get("v.recordId");
        action.setParams({ "accid": recordid });

        action.setCallback(this, function (response) {
        	var status = response.getState();
        	if (component.isValid() && status === "SUCCESS") {
        		var result = response.getReturnValue();
            	component.set("v.obrListResult", result.obrListResult);
        		component.set("v.TotalRecords", result.obrListtotalrecords);
        	}
        	component.set("v.loading", false);
        });
        
         $A.enqueueAction(action);*/
        debugger;
        var action1 = component.get("c.GetAccountNumber");
        var recordid = component.get("v.recordId");
        action1.setParams({
            "accid": recordid
        });
        action1.setCallback(this, function(response) {
            var status = response.getState();
            if (component.isValid() && status === "SUCCESS") {
                var result = response.getReturnValue();
                component.set("v.AccountNumber", result);

            }

            var accnum = component.get("v.AccountNumber");
            var URL = '/apex/SendRequestToOnBase?accNum=' + accnum;
            window.open(URL);
            var dismissActionPanel = $A.get("e.force:closeQuickAction");
            dismissActionPanel.fire();

        });
        $A.enqueueAction(action1);


    }
})