({
	doInit : function(component, event, helper) {
		
        debugger;
        var action = component.get("c.GetAllData");     
        var recordid = component.get("v.recordId");	
		
		
		
		if(recordid == undefined)
		{
			recordid = helper.getParameterByName('c__id');
		}
		
        action.setParams({ "accid": recordid });

        action.setCallback(this, function (response) {
        
        	var status = response.getState();
            component.set("v.loading", false);
            if (component.isValid() && status === "SUCCESS") {
            	
            	var result = response.getReturnValue();
           	        		
        		
            }
            else if (status === "ERROR") {
                var errors = response.getError();
                //console.error(errors);
            } 
            
            var hostname = window.location.hostname;
    		
    		//var URL = 'https://' + hostname + '/apex/flow?flow-id=04d6f632-1d3b-4b35-a0cd-6694169978a6&object-id=' + stracc + '&fullname=' + membername;
    		//var URL = 'https://' + hostname + '/apex/flow?flow-id=32853ba9-fabc-4943-99f7-344c8e187b0d&accountid=001j000000y6s29AAA';
    		var URL = result.FlowURL + '&accountid='+recordid + '&UserId=' + result.UserId + '&MemberName=' + result.MemberName;
    		//window.location.href = URL
    		window.open(URL,'_blank');
            
            
        });
        
        component.set("v.loading", true);
        $A.enqueueAction(action);

    },
    
 
closePopup: function(component, event, helper) {
	  $A.get('e.force:closeQuickAction').fire();
   },
})