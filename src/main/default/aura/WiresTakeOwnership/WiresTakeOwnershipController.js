({
	doInit : function(component, event, helper) {
        debugger;  
        var recordId = component.get("v.recordId");
        if(recordId)
        {
            var action = component.get("c.ChangeOwner");
            action.setParams({"wiresId": recordId});  
            action.setCallback(this, function (response) {
                var status = response.getState();    
                if (component.isValid() && status === "SUCCESS") {
                    var result = response.getReturnValue();     
                    var toastEvent = $A.get("e.force:showToast");
                  
	                toastEvent.setParams({		            
	                	message : 'Owner changed successfully',	                        
				        duration:' 3000',
				        key: 'info_alt',
				        type: 'success',
				        mode: 'pester'
	                });
                  
				    toastEvent.fire();
                    debugger;
                    $A.get('e.force:refreshView').fire();   
                    $A.get('e.force:closeQuickAction').fire();           
                }
            });
             
            $A.enqueueAction(action);
        }
         
    },
     isRefreshed: function(component, event, helper) {
       window.location.reload();
    }
    
})