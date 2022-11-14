({
    doInit : function(component, event,helper, recordId) {
    	
    	var recordId = component.get("v.recordId");
    	helper.getSolarLoanData(component, event,helper,recordId);
    	
	},
    
   getSolarLoanData : function(component, event,recordId){
	
		var SolarLoanRecordId = component.get("v.recordId");
		var stage;
        var checkCurrentStatus;
		var Stage5ACHCheck;
		var OnLoadCheck;
		
		var action = component.get("c.getMemberData");
		action.setParams({"SolarLoanRecordId": SolarLoanRecordId,
                          "CurrentStage": ' ' });
	
		action.setCallback(this, function (response) {
        	var status = response.getState();            
            if (component.isValid() && status === "SUCCESS") {
            	
                var result = response.getReturnValue();
                
                //------------------------Checking Current Stage --------------------------//
                
                if(result.SolarCurrentStage != undefined){
		       	    stage = result.SolarCurrentStage;
		        }
                
                //------------------------Checking Current Status--------------------------//
                
                if(result.SolarCurrentStatus != undefined){
		       	    checkCurrentStatus = result.SolarCurrentStatus;
                }
                
		        if(result.Stage5ACHCheck == 'False'){
		       	    Stage5ACHCheck = 'False';
                }
                if(result.OnLoadCheck == 'True'){
		       	    OnLoadCheck = 'True';
                }
            component.set("v.ActiveStepIndex", stage);
            component.set("v.CurrentStatus", checkCurrentStatus);    
                
           	if(stage == 'Stage 2'){
            	component.set("v.Stage1", "Review Completed");
				component.set("v.Stage2", "Needs Review");
			}
            if(stage == 'Stage 2.5'){
            	component.set("v.Stage1", "Review Completed");
				component.set("v.Stage2", "Review Completed");
				component.set("v.Stage2Pt5", "Needs Review");
			}
			if(stage == 'Stage 3'){
				component.set("v.Stage1", "Review Completed");
				component.set("v.Stage2", "Review Completed");
                component.set("v.Stage2Pt5", "Card Signed");
				component.set("v.Stage3", "Create Records");
      		}
			if(stage == 'Stage 4'){
				component.set("v.Stage1", "Review Completed");
				component.set("v.Stage2", "Review Completed");
                component.set("v.Stage2Pt5", "Card Signed");
				component.set("v.Stage3", "Records Created");
				component.set("v.Stage4", "Needs Review");
      		}
			if(stage == 'Stage 5'){
				component.set("v.Stage1", "Review Completed");
				component.set("v.Stage2", "Review Completed");
                component.set("v.Stage2Pt5", "Card Signed");
				component.set("v.Stage3", "Records Created");
				component.set("v.Stage4", "Review Completed");
				if(Stage5ACHCheck == 'True')
					component.set("v.Stage5", "Send For Signature");
			}
			if(stage == 'Stage 6'){
				component.set("v.Stage1", "Review Completed");
				component.set("v.Stage2", "Review Completed");
                component.set("v.Stage2Pt5", "Card Signed");
				component.set("v.Stage3", "Records Created");
				component.set("v.Stage4", "Review Completed");
				component.set("v.Stage5", "Document Signed");
				component.set("v.Stage6", "Create EFT Record");
           	}
            if(stage == 'Stage 7' && (checkCurrentStatus == 'EFT Record Created' ||
                                     checkCurrentStatus == 'Completed')){
				component.set("v.Stage1", "Review Completed");
				component.set("v.Stage2", "Review Completed");
                component.set("v.Stage2Pt5", "Card Signed");
				component.set("v.Stage3", "Records Created");
				component.set("v.Stage4", "Review Completed");
				component.set("v.Stage5", "Document Signed");
				component.set("v.Stage6", "EFT Record Created");
                component.set("v.Stage7", "Submit UCC Lien Request");               
           	}
                
            if(stage == 'Stage 7' && (checkCurrentStatus == 'UCC Pending' || 
                                      checkCurrentStatus == 'Loan Funded')){
				component.set("v.Stage1", "Review Completed");
				component.set("v.Stage2", "Review Completed");
                component.set("v.Stage2Pt5", "Card Signed");
				component.set("v.Stage3", "Records Created");
				
                if(Stage5ACHCheck == 'False'){
			        component.set("v.Stage4", "ACH Not Used");
                    component.set("v.Stage5", "ACH Not Used");
                    component.set("v.Stage6", "ACH EFT Not Used");
                    component.set("v.Stage7", "UCC Lien Pending");
               }
                if(OnLoadCheck == 'True'){
                    component.set("v.Stage4", "Review Completed");
					component.set("v.Stage5", "Document Signed");
					component.set("v.Stage6", "EFT Record Created");
                	component.set("v.Stage7", "UCC Lien Pending");
                }
           	}
            
            if(stage == 'Stage 7' && checkCurrentStatus == 'UCC Rejected'){
				component.set("v.Stage1", "Review Completed");
				component.set("v.Stage2", "Review Completed");
                component.set("v.Stage2Pt5", "Card Signed");
				component.set("v.Stage3", "Records Created");
				
                if(Stage5ACHCheck == 'False'){
			        component.set("v.Stage4", "ACH Not Used");
                    component.set("v.Stage5", "ACH Not Used");
                    component.set("v.Stage6", "ACH EFT Not Used");
                    component.set("v.Stage7", "Resubmit Requested");               
               }
               if(OnLoadCheck == 'True'){
                    component.set("v.Stage4", "Review Completed");
					component.set("v.Stage5", "Document Signed");
					component.set("v.Stage6", "EFT Record Created");
                	component.set("v.Stage7", "Resubmit Requested");
                }
           	}
                
            if(stage == 'Stage 7' && checkCurrentStatus == 'UCC Submitted'){
				component.set("v.Stage1", "Review Completed");
				component.set("v.Stage2", "Review Completed");
                component.set("v.Stage2Pt5", "Card Signed");
				component.set("v.Stage3", "Records Created");
				
                if(Stage5ACHCheck == 'False'){
			        component.set("v.Stage4", "ACH Not Used");
                    component.set("v.Stage5", "ACH Not Used");
                    component.set("v.Stage6", "ACH EFT Not Used");
                    component.set("v.Stage7", "UCC Lien Submitted");
               }
                if(OnLoadCheck == 'True'){
                    component.set("v.Stage4", "Review Completed");
					component.set("v.Stage5", "Document Signed");
					component.set("v.Stage6", "EFT Record Created");
                	component.set("v.Stage7", "UCC Lien Submitted");
                }
           	}
                
            if(stage == 'Stage 7' && checkCurrentStatus == 'Done'){
				component.set("v.Stage1", "Review Completed");
				component.set("v.Stage2", "Review Completed");
                component.set("v.Stage2Pt5", "Card Signed");
				component.set("v.Stage3", "Records Created");
				component.set("v.Stage4", "Review Completed");
				component.set("v.Stage5", "Document Signed");
				component.set("v.Stage6", "EFT Record Created");
                component.set("v.Stage7", "UCC Not Used");
                component.set("v.Stage8", "Ticket Closed");
           	}    
            
			if(stage == 'Stage 8'){
				component.set("v.Stage1", "Review Completed");
				component.set("v.Stage2", "Review Completed");
                component.set("v.Stage2Pt5", "Card Signed");
				component.set("v.Stage3", "Records Created");
				if(Stage5ACHCheck == 'False'){
					component.set("v.Stage4", "ACH Not Used");
					component.set("v.Stage5", "ACH Not Used");
					component.set("v.Stage6", "ACH EFT Not Used");
                }
				if(OnLoadCheck == 'True'){
					component.set("v.Stage4", "Review Completed");
					component.set("v.Stage5", "Document Signed");
					component.set("v.Stage6", "EFT Record Created");
                    
				}
				component.set("v.Stage7", "UCC Lien Completed");
				component.set("v.Stage8", "Ticket Closed");
			}
		    $A.get('e.force:refreshView').fire();
		  
        }
    });	
    $A.enqueueAction(action);
	
	}
})