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
        var checkCurrentStatus;
		var Stage5ACHCheck;
        var Stage4ErrorCheck;
        var waitingCheck;
        var JurisdictionErrorCheck;
        var MultipleMembershipCheck;
        //var Stage2MemberCheck;
		var buttonClass = component.find('WaitingButton');
        
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
                if(result.SolarCurrentStatus != undefined){
		       	    checkCurrentStatus = result.SolarCurrentStatus;
                }
                
                if(result.SolarCurrentStatus != 'Waiting for Response'){
		        	component.set("v.IsWaitingDisabled", false);
		        }
		        if(result.Stage3LoanCheck != undefined && result.Stage3LoanCheck != null){
		       	    buttonStatus = result.Stage3LoanCheck;
                }

                //-------------------------validation for Stage-2 ---------------------------//
				
                if(result.JurisdictionErrorCheck == 'True'){
                	JurisdictionErrorCheck = 'True';
                }
                
                /*if(result.Stage2MemberCheck == 'True'){
                	Stage2MemberCheck = 'True';
                }

                if(result.Stage2MemberCheck == 'False'){
                	Stage2MemberCheck = 'False';
                }*/

                //---------------------Validation for Stage-4 -------------------------------//
                
                if(result.MultipleMembershipCheck == 'True'){
                    MultipleMembershipCheck = 'True';
                }
                
                if(result.Stage4ErrorCheck == 'True'){
                	Stage4ErrorCheck = 'True';
                }
                
                //---------------------Validation for Stage-5 -------------------------------//
              
                if(result.Stage5ACHCheck == 'False'){
		       	    Stage5ACHCheck = result.Stage5ACHCheck;
                }
                else{
                	Stage5ACHCheck = 'True';
                }
                
                //---------------------Waiting button check ---------------------------------//
				
				if(result.waitingCheck == 'True'){
                	component.set("v.WaitingButton", "Continue");
         		   	$A.util.addClass(buttonClass, 'yellow');
          	   		component.set("v.IsButtonDisabled", true);
                }	                
            }
            
        	if(stage == 'Stage 2'){
                component.set("v.ButtonLabelName", "Mark Stage 2 Complete");
                component.set("v.StageName", "Stage 2: Review Documents");
            }
            
            if(stage == 'Stage 3'){
                component.set("v.ButtonLabelName", "Create Account/Loan Records");
                component.set("v.StageName", "Stage 3: Create Account/Loan Records");
                component.set("v.IsWaitingDisabled", true);                
            }
            if(stage == 'Stage 4'){
            	component.set("v.ButtonLabelName", "Mark Stage 4 Complete");
                component.set("v.StageName", "Stage 4: Review ACH Info");
                component.set("v.IsWaitingDisabled", true);
            } 
            if(stage == 'Stage 5'){
                if(Stage5ACHCheck == 'True'){
            		component.set("v.ButtonLabelName", "Send ACH Document");
            	}
                component.set("v.StageName", "Stage 5: Send ACH Document");
                component.set("v.IsWaitingDisabled", true);
            }
            if(stage == 'Stage 6'){
            	component.set("v.ButtonLabelName", "Create EFT Record");
                component.set("v.StageName", "Stage 6: Create EFT Record");
                component.set("v.IsWaitingDisabled", true);
            }
            
            if(stage == 'Stage 7' && (checkCurrentStatus == 'EFT Record Created' || 
                                      checkCurrentStatus == 'Loan Funded')){
                component.set("v.ButtonLabelName", "Submit UCC Data");
                component.set("v.StageName", "Stage 7: Submit UCC Data");
                component.set("v.IsWaitingDisabled", true);
            }
            
            if(stage == 'Stage 7' && checkCurrentStatus == 'UCC Pending'){
                component.set("v.ButtonLabelName", "UCC Data Submitted");
                component.set("v.StageName", "Stage 7: UCC Data Submitted");
                component.set("v.IsButtonDisabled", true);
                component.set("v.IsWaitingDisabled", true);
            }
            
            if(stage == 'Stage 7' && checkCurrentStatus == 'UCC Submitted'){
                component.set("v.ButtonLabelName", "UCC Data Submitted");
                component.set("v.StageName", "Stage 7: UCC Data Submitted");
                component.set("v.IsButtonDisabled", true);
                component.set("v.IsWaitingDisabled", true);
            }
            
            if(stage == 'Stage 7' && checkCurrentStatus == 'UCC Rejected'){
                component.set("v.ButtonLabelName", "Resubmit UCC Data");
                component.set("v.StageName", "Stage 7: Resubmit UCC Data");
                //component.set("v.IsButtonDisabled", true);
                component.set("v.IsWaitingDisabled", true);
            }
            
            if(stage == 'Stage 7' && checkCurrentStatus == 'Done'){
                component.set("v.ButtonLabelName", "Close Ticket");
                component.set("v.StageName", "Stage 8: Close Ticket");
                component.set("v.IsButtonDisabled", true);
                component.set("v.IsWaitingDisabled", true);
            }
            
            if(stage == 'Stage 8'){
                component.set("v.ButtonLabelName", "Close Ticket");
                component.set("v.StageName", "Stage 8: Close Ticket");
                component.set("v.IsButtonDisabled", true);
                component.set("v.IsWaitingDisabled", true);
            }
            
           	//------------------------------------------Validation message for Stage-2 Member Number Update-----------------------------//
	        
            if(JurisdictionErrorCheck == 'True'){
				var toastEvent = $A.get("e.force:showToast");
		        toastEvent.setParams({
		            title : 'Warning',
		            message: 'Jurisdiction Id not found for County.',
		            duration:' 5000',
		            key: 'info_alt',
		            type: 'warning',
		            mode: 'sticky'
		        });
		        toastEvent.fire();
			 
             }
            
            /*if(Stage2MemberCheck == 'True'){
				
				var toastEvent = $A.get("e.force:showToast");
		        toastEvent.setParams({
		            title : 'Success',
		            message: 'Member Number has been updated Successfully.',
		            duration:' 1000',
		            key: 'info_alt',
		            type: 'success',
		            mode: 'pester'
		        });
		        toastEvent.fire();
			 
             }
			
			 if(Stage2MemberCheck == 'False'){
				
				var toastEvent = $A.get("e.force:showToast");
		        toastEvent.setParams({
		            title : 'Warning',
		            message: 'The Membership Account doesnt exist yet in Episys.',
		            duration:' 1000',
		            key: 'info_alt',
		            type: 'warning',
		            mode: 'pester'
		        });
		        toastEvent.fire();
			 
             }*/

            //------------------------------------------Validation message for Stage-4 -----------------------------//
	         
	         if(Stage4ErrorCheck == 'True' && MultipleMembershipCheck != 'True'){
				var toastEvent = $A.get("e.force:showToast");
		        toastEvent.setParams({
		            title : 'Warning',
		            message: 'Loan and Tracking records are not created',
		            duration:' 5000',
		            key: 'info_alt',
		            type: 'warning',
		            mode: 'sticky'
		        });
		        toastEvent.fire();
			 
             }
            
            if(MultipleMembershipCheck == 'True'){
				var toastEvent = $A.get("e.force:showToast");
		        toastEvent.setParams({
		            title : 'Warning',
		            message: 'There are multiple membership accounts',
		            duration:' 5000',
		            key: 'info_alt',
		            type: 'warning',
		            mode: 'sticky'
		        });
		        toastEvent.fire();
             }
        });	
       $A.enqueueAction(action);
	
	}
})