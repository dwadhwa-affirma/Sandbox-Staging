({
    getDetails : function(component, event) {
        var recordId = component.get("v.recordId");
        var action = component.get('c.getSLAStatus');	   
        action.setParams({recordId : recordId});

        action.setCallback(this, function(response){            
            var status = response.getState();
            if(component.isValid() && status === "SUCCESS"){
                var result =  response.getReturnValue(); 
                var slaStatus = result.SLAStatus;
                debugger;
                component.set("v.CurrentStageSLA",slaStatus.CurrentStageSLA);
                component.set("v.CurrentStageBusinessHoursRemaining",slaStatus.CurrentStageBusinessHoursRemaining);
                component.set("v.CurrentStageSLABreached",slaStatus.CurrentStageSLABreached);
                component.set("v.IsBreached",slaStatus.IsBreached);
                component.set("v.IsSLAInGreen",slaStatus.IsSLAInGreen);
                component.set("v.IsSLAInRed",slaStatus.IsSLAInRed);
                component.set("v.IsSLAInYellow",slaStatus.IsSLAInYellow);
            } else if(status === "ERROR"){
                console.log('Something went wrong while calling method SLAStatusController >> getSLAStatus');
            }
        });
        $A.enqueueAction(action);
    }
})