({
    getDetails : function(component, event) {
        var recordId = component.get("v.recordId");
        var action = component.get('c.getData');	   
		action.setParams({opportunityId : recordId});

        action.setCallback(this, function(response){            
            var status = response.getState();
            if(component.isValid() && status === "SUCCESS"){
                var result =  response.getReturnValue(); 
                var OpportunitySLAStatus = result.OpportunitySLAStatus;
                component.set("v.CurrentStageSLA",OpportunitySLAStatus.CurrentStageSLA);
                component.set("v.CurrentStageBusinessHoursRemaining",OpportunitySLAStatus.CurrentStageBusinessHoursRemaining);
                component.set("v.CurrentStageBreach",OpportunitySLAStatus.CurrentStageBreach);
                component.set("v.isBreached",OpportunitySLAStatus.isBreached);
            }
        });
        $A.enqueueAction(action);
    }
})