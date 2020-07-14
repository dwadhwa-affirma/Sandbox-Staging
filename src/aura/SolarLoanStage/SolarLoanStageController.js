({
	doInit : function(component, event, helper) {
		
		var SolarLoanRecordId = component.get("v.recordId");
		helper.doInit(component, event,helper);
	
	},
	
	waiting: function(component, event, helper) {
	
    	helper.showSpinner(component);
        var status;
        
        
	    var buttonClass = component.find('WaitingButton');
		if(component.get("v.WaitingButton") == 'Waiting'){
            component.set("v.WaitingButton", "Continue");
            $A.util.addClass(buttonClass, 'yellow');
            component.set("v.IsButtonDisabled", true);
            status = 'Waiting for Response';
        }
        else if(component.get("v.WaitingButton") == 'Continue'){
           component.set("v.WaitingButton", "Waiting");
           $A.util.removeClass(buttonClass, 'yellow');
           component.set("v.IsButtonDisabled", false);
            if(component.get("v.ButtonLabelName") == 'Mark Stage 1 Complete')
            	status = 'New';
        	if(component.get("v.ButtonLabelName") == 'Mark Stage 2 Complete')
            	status = 'New';
        	if(component.get("v.ButtonLabelName") == 'Create Loan Records')
            	status = 'New'; 
            if(component.get("v.ButtonLabelName") == 'Mark Stage 4 Complete')
                status = 'Loan Funded';
            if(component.get("v.ButtonLabelName") == 'Send ACH Document')
                status = 'Loan Funded';
            if(component.get("v.ButtonLabelName") == 'Create EFT Record')
                status = 'ACH Pending';
            if(component.get("v.ButtonLabelName") == 'Close Ticket')
                status = 'Done';
            }
		var action = component.get("c.waitingForResponse");
		var SolarLoanRecordId = component.get("v.recordId");
		action.setParams({"SolarLoanRecordId": SolarLoanRecordId,
                         "status": status});
		
		action.setCallback(this, function (response) {
        var status = response.getState();            
           if (component.isValid() && status === "SUCCESS") {
               var result = response.getReturnValue();
               
           }
            
           $A.get('e.force:refreshView').fire();
           window.setTimeout(
		 	  $A.getCallback(function() {
			   	helper.hideSpinner(component,helper)
			  }), 3000
			);
			
        });	
		
		$A.enqueueAction(action);    
                
	},
	
	submit: function(component, event, helper) {
		
        helper.showSpinner(component);
        var action = component.get("c.getMemberData");
        var checkCurrentStage;
        var buttonStatus;
        var Stage5ACHCheck;
        var Stage5ErrorCheck;
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
            if(component.get("v.ButtonLabelName") == 'Close Ticket')
                CurrentStage = 'Stage 8';    
        
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
                if(result.Stage5ACHCheck == 'False'){
		       	    Stage5ACHCheck = result.Stage5ACHCheck;
                }
                else{
                	Stage5ACHCheck = 'True';
                }
                if(result.Stage5ErrorCheck == 'True')
                	Stage5ErrorCheck = 'True';
            
            
            if(checkCurrentStage == 'Stage 2'){
                component.set("v.ButtonLabelName", "Mark Stage 2 Complete");
                component.set("v.StageName", "Stage 2: Review Documents");
            }
            if(checkCurrentStage == 'Stage 3'){
                component.set("v.ButtonLabelName", "Create Loan Records");
                component.set("v.StageName", "Stage 3: Create Loan Records");
            }
            if(checkCurrentStage == 'Stage 4'){
            	component.set("v.ButtonLabelName", "Mark Stage 4 Complete");
                component.set("v.StageName", "Stage 4: Review ACH Info");
            }
            if(checkCurrentStage == 'Stage 5'){
            	if(Stage5ACHCheck == 'True'){
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
            }
            if(checkCurrentStage == 'Stage 8'){
                component.set("v.ButtonLabelName", "Close Ticket");
                component.set("v.StageName", "Stage 7: Closed");
                component.set("v.IsButtonDisabled", true);
            } 
             var buttonDisabled = component.get("v.IsButtonDisabled");
             
             var compEvent = $A.get("e.c:SolarLoanStatusEvent"); 
             compEvent.setParams({"Stage" : checkCurrentStage,
             					  "IsSubmitButtonDisabled" : buttonDisabled,
             					  "Stage5ACHCheck" : Stage5ACHCheck});
			 compEvent.fire();
			 
			 if(Stage5ErrorCheck != 'True'){
				 window.setTimeout(
				    $A.getCallback(function() {
				       helper.hideSpinner(component,helper)
				    }), 5000
				 );
	             window.setTimeout(
				    $A.getCallback(function() {
				      helper.getSolarLoanData(component,helper)
				    }), 4000
				 ); 
	         }
	         
			 if(Stage5ErrorCheck == 'True'){
				
				helper.hideSpinner(component,helper); 
				var toastEvent = $A.get("e.force:showToast");
		        toastEvent.setParams({
		            title : 'Warning',
		            message: 'Please enter Routing Number or Retrieved Bank Name or Bank Account Numbers value before moving stage 4 to 5.',
		            duration:' 5000',
		            key: 'info_alt',
		            type: 'warning',
		            mode: 'sticky'
		        });
		        toastEvent.fire();
			 
			 } 
				 
		 }
    });	
       $A.enqueueAction(action);
		
	},

})