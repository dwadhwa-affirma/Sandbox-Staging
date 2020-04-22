({
	doInit : function(component, event, helper) {
		
		var SolarLoanRecordId = component.get("v.recordId");
		helper.doInit(component, event,helper);
	
	},
	
	
	submit: function(component, event, helper) {
		
        helper.showSpinner(component);
        var action = component.get("c.getMemberData");
        var checkCurrentStage;
        var buttonStatus;
        var Stage4ACHCheck;
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
            if(component.get("v.ButtonLabelName") == 'Send ACH Document')
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
                if(result.Stage3LoanCheck != undefined && result.Stage3LoanCheck != null){
		       	    buttonStatus = result.Stage3LoanCheck;
                }
                if(result.Stage4ACHCheck == 'False'){
		       	    Stage4ACHCheck = result.Stage4ACHCheck;
                }
                else{
                	Stage4ACHCheck = 'True';
                }
            
            
            if(checkCurrentStage == 'Stage 2'){
                component.set("v.ButtonLabelName", "Mark Stage 2 Complete");
                component.set("v.StageName", "Stage 2: Review Documents");
            }
            if(checkCurrentStage == 'Stage 3'){
                component.set("v.ButtonLabelName", "Create Loan Records");
                component.set("v.StageName", "Stage 3: Create Loan Records");
                if(buttonStatus == 'True'){
                	component.set("v.IsButtonDisabled", true);
                }
            }
            if(checkCurrentStage == 'Stage 4'){
            	component.set("v.ButtonLabelName", "Mark Stage 4 Complete");
                component.set("v.StageName", "Stage 4: Review ACH Info");
            }
            if(checkCurrentStage == 'Stage 5'){
            	if(Stage4ACHCheck == 'True'){
            		component.set("v.ButtonLabelName", "Send ACH Document");
            	}
                component.set("v.StageName", "Stage 5: Send ACH Document");
            }
            if(checkCurrentStage == 'Stage 6'){
            	component.set("v.ButtonLabelName", "Create EFT Record");
                component.set("v.StageName", "Stage 6: Create EFT Record");
            }
            if(checkCurrentStage == 'Stage 7'){
                component.set("v.ButtonLabelName", "Close Ticket");
                component.set("v.StageName", "Stage 7: Close Ticket");
                component.set("v.IsButtonDisabled", true);
            }
             
             var buttonDisabled = component.get("v.IsButtonDisabled");
             
             var compEvent = $A.get("e.c:SolarLoanStatusEvent"); 
             compEvent.setParams({"Stage" : checkCurrentStage,
             					  "IsSubmitButtonDisabled" : buttonDisabled,
             					  "Stage4ACHCheck" : Stage4ACHCheck});
			 compEvent.fire();
			 
			 helper.hideSpinner(component);
			 $A.get('e.force:refreshView').fire();
			 
		 }
    });	
        	
        
		
        $A.enqueueAction(action);
		
	}
})