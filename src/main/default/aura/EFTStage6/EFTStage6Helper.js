({
	sendACHDocument : function(component, event, helper) {
		debugger;
		var action = component.get("c.sendACHDocument");
		//var recordId = component.get("v.recordId");	
		action.setParams({
		"recordId": component.get("v.EFTRecord")
		});	
		action.setCallback(this, function(resp) {			
			var state=resp.getState();			
			if(state === "SUCCESS"){				
				var res = resp.getReturnValue();
                 this.hideSpinner(component);
                
				}
			});
        $A.enqueueAction(action);
	
	},
    
    
    showSpinner: function(component) {
		var spinnerMain =  component.find("Spinner");
		$A.util.removeClass(spinnerMain, "slds-hide");
	},
 
	hideSpinner : function(component) {
		var spinnerMain =  component.find("Spinner");
		$A.util.addClass(spinnerMain, "slds-hide");
	},

	CheckValidEffectiveDate: function (component, event, EnteredEffectiveDate) {
		var action = component.get("c.CheckValidEffectiveDate");
		action.setParams({
		  EnteredEffectiveDate: EnteredEffectiveDate,
		});
		action.setCallback(this, function (result) {
		  var state = result.getState();
		  if (component.isValid() && state === "SUCCESS") {
			var resultData = result.getReturnValue();
			if (resultData.isValid == "false") {
			  component.set("v.EFTRecord.Effective_Date__c", "");
			  alert(resultData.ErrorMessage.replace("Effective","Expire"));
			}
			else{
				var evt = $A.get("e.c:EFTEvent");
				var EFT = component.get("v.EFTRecord");
				
				if(EFT != undefined){
					evt.setParams({ "EFTRecord": EFT});
					evt.fire();
				}
			}
		  }
		});
		$A.enqueueAction(action);
	  }
})