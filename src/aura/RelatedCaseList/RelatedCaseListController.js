({
	doInit : function(component, event, helper) {       
        var recordid = component.get("v.recordId");
        var action = component.get("c.GetRelatedCases");
		action.setParams({"caseid": recordid});
        action.setCallback(this, function (response) {
            var status = response.getState();
            if (component.isValid() && status === "SUCCESS") {
                
	               var result = response.getReturnValue(); 
	                component.set("v.CaseRecord", result);  
					   if(result.length > 0)
					   {
						   component.set("v.noRecordfound", false);
					   }
					   else
					   {                  
						   	component.set("v.noRecordfound", true);
					   }
               // alert(JSON.stringify(response.getReturnValue()));
                
                
            }
        });
      $A.enqueueAction(action);
	},
    
    handleClick : function(component, event, helper)
    {
         var recordid = event.srcElement.id;
        var navEvt = $A.get("e.force:navigateToSObject");
        navEvt.setParams({
            "recordId": recordid
        });
        navEvt.fire();

    }
})