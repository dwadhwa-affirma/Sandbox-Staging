({
	helperMethod : function() {
		
	},
	
	saveMethod : function(component, event, reason, element, InputElement, SecureEmailInputElement, DriverLicenseInputElement, WorkBadgeInputElement) {
		
					if(component.get("v.IsSubmitClicked") == false)
					{
							var action = component.get("c.KYMSaveLogData");
						    element.classList.remove('show');
						    element.classList.add('hidden');
						    var GUID = component.get("v.GUID");
						    var IVRGUIDFromUrl = component.get("v.IVRGUIDFromUrl");
						    var memberId = component.get("v.recordId");
					        var compEvent;
						    action.setParams({"MemberId": memberId,"reason":reason,"otherReason":InputElement,"GUID":GUID, "SecureEmailCase": SecureEmailInputElement, "IVRGUIDFromUrl": IVRGUIDFromUrl , "DriverLicenseNo" : DriverLicenseInputElement, "WorkBadgeNo" : WorkBadgeInputElement });
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
	getDataOnLoad: function (component, event, helper, memberId, IVRGUIDFromUrl){
		var action = component.get("c.getKYMInfo");
		action.setParams({"MemberId": memberId,"IVRGUIDFromUrl":IVRGUIDFromUrl});
		action.setCallback(this, function (response) {
			var status = response.getState();
			if (component.isValid() && status === "SUCCESS") {
                var result = response.getReturnValue();
				if(result.KYM_Reason__c != undefined && result.KYM_Reason__c =='Secure Email' ){
					component.set("v.selectedKYMvalue", 'Secure Email');
					
				}else{
					component.set("v.selectedKYMvalue", ' ');
				}
				if(result.KYM_Secure_Email_Case_Number__c != undefined && result.KYM_Secure_Email_Case_Number__c != '' ){
					component.find("SecureEmailCase").set("v.value",result.KYM_Secure_Email_Case_Number__c);				
					$A.util.addClass(component.find("SecureEmailCase"), "show");
				}
				else{
					component.find("SecureEmailCase").set("v.value",'');
				}

				
			}
		
		});	
        
        $A.enqueueAction(action); 

	},
})