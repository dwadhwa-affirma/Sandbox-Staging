({
	doInit : function(component, event,helper, recordId) {
    	
    	var recordId = component.get("v.recordId");
    	helper.getSolarLoanData(component, event,helper,recordId); 	
	},
    
    showSpinner: function(component) {
		var spinnerMain =  component.find("Spinner");
		$A.util.removeClass(spinnerMain, "slds-hide");
	},
 
	hideSpinner : function(component) {
		var spinnerMain =  component.find("Spinner");
		$A.util.addClass(spinnerMain, "slds-hide");
	},
	
    getSolarLoanData : function(component, event,recordId){
	
		var SolarLoanRecordId = component.get("v.recordId");
		var buttonStatus;
		var stage;
		var Stage4ACHCheck;
		
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
		        if(result.SolarCurrentStatus != 'Waiting for Response'){
		        	component.set("v.IsWaitingDisabled", false);
		        }
		        if(result.Stage3LoanCheck != undefined && result.Stage3LoanCheck != null){
		       	    buttonStatus = result.Stage3LoanCheck;
                }
                if(result.Stage4ACHCheck == 'False'){
		       	    Stage4ACHCheck = result.Stage4ACHCheck;
                }
                else{
                	Stage4ACHCheck = 'True';
                }
            }
            
        	if(stage == 'Stage 2'){
                component.set("v.ButtonLabelName", "Mark Stage 2 Complete");
                component.set("v.StageName", "Stage 2: Review Documents");
            }
            if(stage == 'Stage 3'){
                component.set("v.ButtonLabelName", "Create Loan Records");
                component.set("v.StageName", "Stage 3: Create Loan Records");
            }
            if(stage == 'Stage 4'){
            	component.set("v.ButtonLabelName", "Mark Stage 4 Complete");
                component.set("v.StageName", "Stage 4: Review ACH Info");
            }
            if(stage == 'Stage 5'){
                if(Stage4ACHCheck == 'True'){
            		component.set("v.ButtonLabelName", "Send ACH Document");
            	}
                component.set("v.StageName", "Stage 5: Send ACH Document");
            }
            if(stage == 'Stage 6'){
            	component.set("v.ButtonLabelName", "Create EFT Record");
                component.set("v.StageName", "Stage 6: Create EFT Record");
            }
            if(stage == 'Stage 7'){
                component.set("v.ButtonLabelName", "Close Ticket");
                component.set("v.StageName", "Stage 7: Close Ticket");
            }
            if(stage == 'Stage 8'){
                component.set("v.ButtonLabelName", "Close Ticket");
                component.set("v.StageName", "Stage 7: Closed");
                component.set("v.IsButtonDisabled", true);
            }   
        	
        });	
       $A.enqueueAction(action);
	
	}
})