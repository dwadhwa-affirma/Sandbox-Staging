({
	doInit : function(component, event,helper, recordId) {
    	
    	var recordId = component.get("v.recordId");
    	helper.getSolarLoanData(component, event,helper,recordId); 	
	},
    
    getSolarLoanData : function(component, event,recordId){
	
		var SolarLoanRecordId = component.get("v.recordId");
		var buttonStatus;
		var stage;
		
		var action = component.get("c.getMemberData");
		action.setParams({"SolarLoanRecordId": SolarLoanRecordId,
                          "CurrentStage": ' ' });
	
		action.setCallback(this, function (response) {
        	var status = response.getState();            
            if (component.isValid() && status === "SUCCESS") {
                var result = response.getReturnValue();
                
                if(result.SolarCurrentStage != undefined){
		       	    stage = result.SolarCurrentStage;
		        }
		        if(result.Stage3LoanCheck != undefined && result.Stage3LoanCheck != null){
		       	    buttonStatus = result.Stage3LoanCheck;
                }
            }
            
        	if(stage == 'Stage 2'){
                component.set("v.ButtonLabelName", "Mark Stage 2 Complete");
                component.set("v.StageName", "Stage 2: Loan Documents");
            }
            if(stage == 'Stage 3'){
                component.set("v.ButtonLabelName", "Create Loan Records");
                component.set("v.StageName", "Stage 3: Loan Records");
                if(buttonStatus == 'True'){
                	component.set("v.IsButtonDisabled", true);
                }
            }
            if(stage == 'Stage 4'){
            	component.set("v.ButtonLabelName", "Mark Stage 4 Complete");
                component.set("v.StageName", "Stage 4: ACH Information");
            }
            if(stage == 'Stage 5'){
                component.set("v.ButtonLabelName", "Mark Stage 5 Complete");
                component.set("v.StageName", "Stage 5: ACH Form");
            }
            if(stage == 'Stage 6'){
            	component.set("v.ButtonLabelName", "Create EFT Record");
                component.set("v.StageName", "Stage 6: EFT Record");
            }
            if(stage == 'Stage 7'){
                component.set("v.ButtonLabelName", "Close Ticket");
                component.set("v.StageName", "Stage 7: Close Ticket");
                component.set("v.IsButtonDisabled", true);
            }   
        	
        });	
       $A.enqueueAction(action);
	
	}
})