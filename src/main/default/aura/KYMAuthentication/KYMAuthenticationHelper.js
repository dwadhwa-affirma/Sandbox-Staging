({
	helperMethod : function() {
		
	},
	
	saveMethod : function(component, event, reason, element, InputElement, SecureEmailInputElement) {
		
					if(component.get("v.IsSubmitClicked") == false)
					{
							var action = component.get("c.KYMSaveLogData");
						    element.classList.remove('show');
						    element.classList.add('hidden');
						    var GUID = component.get("v.GUID");
						    var IVRGUIDFromUrl = component.get("v.IVRGUIDFromUrl");
						    var memberId = component.get("v.recordId");
					        var compEvent;
						    action.setParams({"MemberId": memberId,"reason":reason,"otherReason":InputElement,"GUID":GUID, "SecureEmailCase": SecureEmailInputElement, "IVRGUIDFromUrl": IVRGUIDFromUrl });
						    action.setCallback(this, function (response) {
							var status = response.getState();            
						    if (component.isValid() && status === "SUCCESS") {
						    	var result = response.getReturnValue();
						    	compEvent = component.getEvent("statusEvent");
						    	compEvent.setParams({"KYMVarifiedStatus" : "SUCCESS","ActionType": 'KYM'});
						    	compEvent.fire();
						    }
						    else
						    {
						    	compEvent = component.getEvent("statusEvent");
						    	compEvent.setParams({"KYMVarifiedStatus" : "FAIL","ActionType": 'KYM'});
						    	compEvent.fire();
						    }
						   	});	
						   	$A.enqueueAction(action);
						   	component.set("v.IsSubmitClicked",true);
					   	}
	},
})