({
	doInit : function(component, event, helper) {
		
		var recordId = component.get("v.recordId");
		helper.doInit(component, event,helper);
		if(!window.location.hash){ 
		   	window.location = window.location + '#loaded';
		   	window.location.reload();
		}
	},
	
	MemberSolarStatusEvent : function(component, event, helper){
		
        var ProgressBarStep1 = document.getElementById('Step1');
		var ProgressBarStep2 = document.getElementById('Step2');
        var ProgressBarStep2Pt5 = document.getElementById('Step2Pt5');
		var ProgressBarStep3 = document.getElementById('Step3');
		var ProgressBarStep4 = document.getElementById('Step4');
		var ProgressBarStep5 = document.getElementById('Step5');
		var ProgressBarStep6 = document.getElementById('Step6');
		var ProgressBarStep7 = document.getElementById('Step7');
        var ProgressBarStep8 = document.getElementById('Step8');
		
		var stage = event.getParam("Stage");
		
		var buttonDisabled = event.getParam("IsSubmitButtonDisabled");
		var Stage5ACHCheck = event.getParam("Stage5ACHCheck");
		
		if(stage == 'Stage 2'){
			component.set("v.Stage1", "Review Completed");
			component.set("v.Stage2", "Needs Review");
			ProgressBarStep1.classList.remove('halFactive');
			ProgressBarStep1.classList.add('active');
			ProgressBarStep2.classList.add('halFactive');
			
		}
        if(stage == 'Stage 2.5'){
			component.set("v.Stage1", "Review Completed");
			component.set("v.Stage2", "Review Completed");
            component.set("v.Stage2Pt5", "Needs Review");
			ProgressBarStep1.classList.add('active');
			ProgressBarStep2.classList.remove('halFactive');
            ProgressBarStep2.classList.add('active');
			ProgressBarStep2Pt5.classList.add('halFactive');
			
		}
		if(stage == 'Stage 3'){
			component.set("v.Stage1", "Review Completed");
			component.set("v.Stage2", "Review Completed");
            component.set("v.Stage2Pt5", "Card Signed");
			component.set("v.Stage3", "Create Records");
            ProgressBarStep1.classList.add('active');
			ProgressBarStep2.classList.add('active');
            ProgressBarStep2Pt5.classList.remove('halFactive');
            ProgressBarStep2Pt5.classList.add('active');
			ProgressBarStep3.classList.add('halFactive');
		}
		if(stage == 'Stage 4'){
			component.set("v.Stage1", "Review Completed");
			component.set("v.Stage2", "Review Completed");
            component.set("v.Stage2Pt5", "Card Signed");
			component.set("v.Stage3", "Records Created");
			component.set("v.Stage4", "Needs Review");
         	ProgressBarStep1.classList.add('active');
			ProgressBarStep2.classList.add('active');
			ProgressBarStep3.classList.remove('halFactive');
			ProgressBarStep3.classList.add('active');
			ProgressBarStep4.classList.add('halFactive');
		}
		if(stage == 'Stage 5'){
			component.set("v.Stage1", "Review Completed");
			component.set("v.Stage2", "Review Completed");
            component.set("v.Stage2Pt5", "Card Signed");
			component.set("v.Stage3", "Records Created");
			component.set("v.Stage4", "Review Completed");
			if(Stage5ACHCheck == 'True')
				component.set("v.Stage5", "Send For Signature");
            ProgressBarStep1.classList.add('active');
			ProgressBarStep2.classList.add('active');
			ProgressBarStep3.classList.add('active');
			ProgressBarStep4.classList.remove('halFactive');
			ProgressBarStep4.classList.add('active');
			ProgressBarStep5.classList.add('halFactive');
		}
		if(stage == 'Stage 6'){
			component.set("v.Stage1", "Review Completed");
			component.set("v.Stage2", "Review Completed");
            component.set("v.Stage2Pt5", "Card Signed");
			component.set("v.Stage3", "Records Created");
			component.set("v.Stage4", "Review Completed");
			component.set("v.Stage5", "Waiting for Member");
			component.set("v.Stage6", "Create EFT Record");
            ProgressBarStep1.classList.add('active');
			ProgressBarStep2.classList.add('active');
			ProgressBarStep3.classList.add('active');
			ProgressBarStep4.classList.add('active');
			ProgressBarStep5.classList.remove('halFactive');
			ProgressBarStep5.classList.add('half');
			ProgressBarStep6.classList.add('halFactive');
		}
		if(stage == 'Stage 7'){
		
			component.set("v.Stage1", "Review Completed");
			component.set("v.Stage2", "Review Completed");
            component.set("v.Stage2Pt5", "Card Signed");
			component.set("v.Stage3", "Records Created");
	
            if(Stage5ACHCheck == 'False'){
			
				component.set("v.Stage4", "ACH Not Used");
				component.set("v.Stage5", "ACH Not Used");
				component.set("v.Stage6", "ACH EFT Not Used");
           }
			if(Stage5ACHCheck == 'True'){
				component.set("v.Stage4", "Review Completed");
				component.set("v.Stage5", "Document Signed");
				component.set("v.Stage6", "EFT Record Created");
         	}
            component.set("v.Stage7", "Submit UCC Lien Request");
			ProgressBarStep1.classList.remove('halFactive');
            ProgressBarStep1.classList.add('active');
			ProgressBarStep2.classList.add('active');
			ProgressBarStep3.classList.remove('halFactive');
			ProgressBarStep3.classList.add('active');
			ProgressBarStep4.classList.remove('halFactive');
			ProgressBarStep4.classList.add('active');
			ProgressBarStep5.classList.remove('half');
			ProgressBarStep5.classList.add('active');
			ProgressBarStep6.classList.remove('halFactive');
			ProgressBarStep6.classList.add('active');
			ProgressBarStep7.classList.add('halFactive');
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
			if(Stage5ACHCheck == 'True'){
				component.set("v.Stage4", "Review Completed");
				component.set("v.Stage5", "Document Signed");
				component.set("v.Stage6", "EFT Record Created");                
			}
            
			component.set("v.Stage7", "UCC Lien Completed");
			component.set("v.Stage8", "Ticket Closed");
			ProgressBarStep1.classList.remove('halFactive');
            ProgressBarStep1.classList.add('active');
			ProgressBarStep2.classList.add('active');
			ProgressBarStep3.classList.remove('halFactive');
			ProgressBarStep3.classList.add('active');
			ProgressBarStep4.classList.remove('halFactive');
			ProgressBarStep4.classList.add('active');
			ProgressBarStep5.classList.remove('half');
			ProgressBarStep5.classList.add('active');
			ProgressBarStep6.classList.remove('halFactive');
			ProgressBarStep6.classList.add('active');
            ProgressBarStep7.classList.remove('halFactive');
			ProgressBarStep7.classList.add('active');
            ProgressBarStep8.classList.add('active');
		}
        
		window.setTimeout(
		    $A.getCallback(function() {
		       helper.getSolarLoanData(component,helper)
		    }), 4000
		 );
        helper.getSolarLoanData(component,helper);
        $A.get('e.force:refreshView').fire();
		
	}
})