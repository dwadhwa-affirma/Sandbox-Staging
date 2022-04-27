({
    getDetails : function(component, event) {
        var recordId = component.get("v.recordId");
        var action = component.get('c.getData');	   
		action.setParams({leadId : recordId});

        action.setCallback(this, function(response){            
            var status = response.getState();
            if(component.isValid() && status === "SUCCESS"){
                var result =  response.getReturnValue(); 
                var LeadSLAStatus = result.LeadSLAStatus;
                component.set("v.CurrentStageSLA",LeadSLAStatus.CurrentStageSLA);
                component.set("v.CurrentStageBusinessHoursRemaining",LeadSLAStatus.CurrentStageBusinessHoursRemaining);
                component.set("v.CurrentStageBreach",LeadSLAStatus.CurrentStageBreach);
                component.set("v.isBreached",LeadSLAStatus.isBreached);
            }
        });
        $A.enqueueAction(action);
    }
})