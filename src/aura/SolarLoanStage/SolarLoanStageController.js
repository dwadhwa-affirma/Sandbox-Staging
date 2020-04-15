({
	doInit : function(component, event, helper) {
		
	var SolarLoanRecordId = component.get("v.recordId");
	
	
	},
	
	
	submit: function(component, event, helper) {
		
        var action = component.get("c.getMemberData");
        var checkCurrentStage;
        var SolarLoanRecordId = component.get("v.recordId");
       	
        var CurrentStage;
        	if(component.get("v.ButtonLabelName") == 'Mark Stage 1 Complete')
                CurrentStage = 'Stage 2';
        	if(component.get("v.ButtonLabelName") == 'Mark Stage 2 Complete')
                CurrentStage = 'Stage 3';
        	if(component.get("v.ButtonLabelName") == 'Create Loan Records')
                CurrentStage = 'Stage 4';
            if(component.get("v.ButtonLabelName") == 'Mark Stage 4 Complete')
            	CurrentStage = 'Stage 5';
            if(component.get("v.ButtonLabelName") == 'Mark Stage 5 Complete')
                CurrentStage = 'Stage 6';
        	if(component.get("v.ButtonLabelName") == 'Create EFT Record')
                CurrentStage = 'Stage 7';
        
        action.setParams({"SolarLoanRecordId": SolarLoanRecordId,
                          "CurrentStage": CurrentStage });
        action.setCallback(this, function (response) {
        	var status = response.getState();            
            if (component.isValid() && status === "SUCCESS") {
                var result = response.getReturnValue();
                
                if(result.SolarCurrentStage != undefined){
		       	    checkCurrentStage = result.SolarCurrentStage;
                    component.set("v.CurrentStage",result.SolarCurrentStage);
                }
            }
            
            if(checkCurrentStage == 'Stage 2'){
                component.set("v.ButtonLabelName", "Mark Stage 2 Complete");
                component.set("v.StageName", "Stage 2: Loan Documents");
            }
            if(checkCurrentStage == 'Stage 3'){
                component.set("v.ButtonLabelName", "Create Loan Records");
                component.set("v.StageName", "Stage 3: Loan Records");
            }
            if(checkCurrentStage == 'Stage 4'){
            	component.set("v.ButtonLabelName", "Mark Stage 4 Complete");
                component.set("v.StageName", "Stage 4: ACH Information");
            }
            if(checkCurrentStage == 'Stage 5'){
                component.set("v.ButtonLabelName", "Mark Stage 5 Complete");
                component.set("v.StageName", "Stage 5: ACH Form");
            }
            if(checkCurrentStage == 'Stage 6'){
            	component.set("v.ButtonLabelName", "Create EFT Record");
                component.set("v.StageName", "Stage 6: EFT Record");
            }
            if(checkCurrentStage == 'Stage 7'){
                component.set("v.ButtonLabelName", "Close Ticket");
                component.set("v.StageName", "Stage 7: Close Ticket");
                component.set("v.IsButtonDisabled", true);
            }
             
             var compEvent = $A.get("e.c:SolarLoanStatusEvent"); 
             compEvent.setParams({"Stage" : checkCurrentStage});
			 compEvent.fire();
        });	
        	
        
		
        $A.enqueueAction(action);
		
	}
})