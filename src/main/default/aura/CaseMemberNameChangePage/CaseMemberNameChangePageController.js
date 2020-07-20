({
	doInit : function(component, event, helper) {
		var recordid = component.get("v.recordId");
		
		
		var action = component.get("c.GetMemberNameList");
		 
		action.setParams({ "Caseid": recordid });
		action.setCallback(this, function (response) {  
		    	
            var status = response.getState(); 
            if (component.isValid() && status === "SUCCESS") {
            
            	var result = response.getReturnValue(); 
            	
            	component.set("v.IsEligible", result[0][0]);
            	if(result.length > 1)
            	{
            		component.set("v.AccountObject", result[1]);
            	}
            }           
		});
		
		 $A.enqueueAction(action);
	},
	
	closePopup: function(component, event, helper) {
	  $A.get('e.force:closeQuickAction').fire();
   }, 
   SaveMemberName : function(component, event, helper) {
	 var recordid = component.get("v.recordId");
	 var memberid = component.get("v.MemberId");
	
	// var isValid = helper.handleError(component,event,helper);
	if(memberid == undefined || memberid == null || memberid == '')
    {
        component.set("v.isError", true);
    }
	 else
	 {
		 	component.set("v.isError", false);
			 var action = component.get("c.UpdateCase");
			 action.setParams({ "Caseid": recordid, "Memberid": memberid});
			 action.setCallback(this, function (response) {
				  if (component.isValid() && status === "SUCCESS") {
				  
					  var toastEvent = $A.get("e.force:showToast");
			        
				        toastEvent.setParams({		            
				            message : 'Record Saved Successfully',	                        
				            duration:' 3000',
				            key: 'info_alt',
				            type: 'success',
				            mode: 'pester'
				        });
				        toastEvent.fire();	
				  }
				  
				  var navEvt = $A.get("e.force:navigateToSObject");
			        navEvt.setParams({
			        	"recordId": recordid
			        	
			        });
			        navEvt.fire(); 
			       
			      window.location.href = '/lightning/r/Case/' + recordid +'/view' ;
			 }); 
			 
			 
			  
			  $A.enqueueAction(action);	 
	 }
   },
    onChange : function(component, event, helper) {
    var memberid = event.getSource().get("v.value");
    component.set("v.MemberId",memberid);
    if(memberid == undefined || memberid == null || memberid == '')
    {
        component.set("v.isError", true);
    }
	 else
	 {
		  component.set("v.isError", false);
	 }
	 
   },
})