({
	doInit : function(component, event, helper) {
	
		var memberId = component.get("v.recordId");
		var PublicWalletStatusForDay = component.get("v.PublicWalletStatusForDay");
		helper.getDLStateIdPassport(component, event, memberId);
		
	},
	executeMethod : function (component, event, helper) {
        console.log("Inside Execute method.. ");
        var params = event.getParam('arguments');
        console.log('Param 1: '+ params.param1);
        },
	
    submit: function(component, event, helper) {
		
		if(component.get("v.IsSubmitClicked") == false)
    	{
			if(component.get("v.QuestionAttempt") <=2){
				alert('Please select at least 3 questions before clicking submit.');
				component.set("v.ScoreObtained",0 );
				component.set("v.QuestionAttempt",0 );
				component.set("v.FailedCount",0 );
			}
			else{
					var memberId = component.get("v.recordId");
					var ScoreObtained = component.get("v.ScoreObtained");
					var FailedCount = component.get("v.FailedCount");
			        var status;
					var compEvent = component.getEvent("statusEvent");
					compEvent.setParams({"PublicWalletScoreObtained" : ScoreObtained,"PublicWalletFailedCount" : FailedCount, "ActionType": 'Public Wallet'});
				  	compEvent.fire();
				    if(ScoreObtained >= 3 && FailedCount <= 1)
			            status = "passed";
			        else
			            status = "failed";
					helper.saveMethod(component, event, memberId, status);
					component.set("v.IsSubmitClicked",true);
			}
			
        	component.find('DobPassButton').set("v.variant", "neutral");
        	component.find('DobFailButton').set("v.variant", "neutral");
        	component.find('DLPassButton').set("v.variant", "neutral");
        	component.find('DLFailButton').set("v.variant", "neutral");
        	component.find('MothersMaidenNamePassButton').set("v.variant", "neutral");
        	component.find('MothersMaidenNameFailButton').set("v.variant", "neutral");
        	component.find('EmailPassButton').set("v.variant", "neutral");
        	component.find('EmailFailButton').set("v.variant", "neutral");
        	component.find('TokenPassButton1').set("v.variant", "neutral");
        	component.find('TokenFailButton1').set("v.variant", "neutral");
		}
	},
    
    ButtonClick : function(component, event, helper) {
        var ButtonId = event.getSource().getLocalId();
        var Button = event.getSource();
        var findOtherButton;
        findOtherButton = component.find('DobFailButton');
        var QuestionAttempt = component.get("v.QuestionAttempt");
        var token1 = component.find("AdditionalToken1").get("v.value");
	    var ScoreObtained = component.get("v.ScoreObtained");
	    var FailedCount = component.get("v.FailedCount");
        if(ButtonId =='DobPassButton'){
        	if(Button.get("v.variant") ==  "neutral"  && findOtherButton.get("v.variant" ) == "neutral"){
        		QuestionAttempt = parseInt(QuestionAttempt) + 1;
        	}
        	
        	component.set("v.QuestionAttempt",QuestionAttempt );
        	
        	Button.set("v.variant", "success");
        	ScoreObtained = parseInt(ScoreObtained) + 1;
        	component.set("v.ScoreObtained",ScoreObtained);
        	findOtherButton.set("v.variant", "neutral");

        }
        else if(ButtonId =='DobFailButton'){        
        	
        	findOtherButton = component.find('DobPassButton');
        	FailedCount = parseInt(FailedCount) + 1;
        	component.set("v.FailedCount",FailedCount);
        	if(Button.get("v.variant") ==  "neutral" && findOtherButton.get("v.variant" ) == "neutral"){
        		QuestionAttempt = parseInt(QuestionAttempt) + 1;
        	}
        	component.set("v.QuestionAttempt",QuestionAttempt  );
        	
        	Button.set("v.variant", "destructive");
        	findOtherButton.set("v.variant", "neutral");
        	/*if(parseInt(ScoreObtained) >= 1){        	
	        		ScoreObtained = parseInt(ScoreObtained) - 1;
	        	 	component.set("v.ScoreObtained",ScoreObtained);
        	 }
        	 else{        	 	
        	 		component.set("v.ScoreObtained",0);
        	 }
        	*/
        	
        }
        else if(ButtonId =='DLPassButton')
        {
        	
        	ScoreObtained = parseInt(ScoreObtained) + 1;
        	component.set("v.ScoreObtained",ScoreObtained);
        	findOtherButton = component.find('DLFailButton');
        	if(Button.get("v.variant") ==  "neutral"  && findOtherButton.get("v.variant" ) == "neutral"){
        		QuestionAttempt = parseInt(QuestionAttempt) + 1;
        	}
        	component.set("v.QuestionAttempt",QuestionAttempt );
        	
        	Button.set("v.variant", "success");
        	findOtherButton.set("v.variant", "neutral");
        	
        }
        else if(ButtonId =='DLFailButton'){        
        	
        	findOtherButton = component.find('DLPassButton');
        	FailedCount = parseInt(FailedCount) + 1;
        	component.set("v.FailedCount",FailedCount);
        	if(Button.get("v.variant") ==  "neutral"  && findOtherButton.get("v.variant" ) == "neutral"){
        		QuestionAttempt = parseInt(QuestionAttempt) + 1;
        	}
        	component.set("v.QuestionAttempt",QuestionAttempt );
        	
        	Button.set("v.variant", "destructive");
        	findOtherButton.set("v.variant", "neutral");
        	/*if(parseInt(ScoreObtained) >= 1){        	
	        		ScoreObtained = parseInt(ScoreObtained) - 1;
	        	 	component.set("v.ScoreObtained",ScoreObtained);
        	 }
        	 else{        	 	
        	 		component.set("v.ScoreObtained",0);
        	 }
        	*/
        	
        }

        else if(ButtonId =='MothersMaidenNamePassButton')
        {
        	
        	ScoreObtained = parseInt(ScoreObtained) + 1;
        	component.set("v.ScoreObtained",ScoreObtained);
        	findOtherButton = component.find('MothersMaidenNameFailButton')
        	
        	if(Button.get("v.variant") ==  "neutral"  && findOtherButton.get("v.variant" ) == "neutral"){
        		QuestionAttempt = parseInt(QuestionAttempt) + 1;
        	}
        	component.set("v.QuestionAttempt",QuestionAttempt );
        	
        	Button.set("v.variant", "success");
        	findOtherButton.set("v.variant", "neutral");
        	
        }
        else if(ButtonId =='MothersMaidenNameFailButton'){        
        	
        	FailedCount = parseInt(FailedCount) + 1;
        	component.set("v.FailedCount",FailedCount);
        	findOtherButton = component.find('MothersMaidenNamePassButton');
        	if(Button.get("v.variant") ==  "neutral"  && findOtherButton.get("v.variant" ) == "neutral"){
        		QuestionAttempt = parseInt(QuestionAttempt) + 1;
        	}
        	component.set("v.QuestionAttempt",QuestionAttempt );
        
        	Button.set("v.variant", "destructive");
        	findOtherButton.set("v.variant", "neutral");
        	/*if(parseInt(ScoreObtained) >= 1){        	
	        		ScoreObtained = parseInt(ScoreObtained) - 1;
	        	 	component.set("v.ScoreObtained",ScoreObtained);
        	 }
        	 else{        	 	
        	 		component.set("v.ScoreObtained",0);
        	 }
        	*/
        	
        }
        
        else if(ButtonId =='EmailPassButton')
        {
        	
        	ScoreObtained = parseInt(ScoreObtained) + 1;
        	component.set("v.ScoreObtained",ScoreObtained);
        	findOtherButton = component.find('EmailFailButton');
        	if(Button.get("v.variant") ==  "neutral"  && findOtherButton.get("v.variant" ) == "neutral"){
        		QuestionAttempt = parseInt(QuestionAttempt) + 1;
        	}
        	component.set("v.QuestionAttempt",QuestionAttempt );
        	
        	Button.set("v.variant", "success");
        	findOtherButton.set("v.variant", "neutral");
        	
        }
        else if(ButtonId =='EmailFailButton'){        
        	
        	findOtherButton = component.find('EmailPassButton');
        	FailedCount = parseInt(FailedCount) + 1;
        	component.set("v.FailedCount",FailedCount);
        	if(Button.get("v.variant") ==  "neutral"  && findOtherButton.get("v.variant" ) == "neutral"){
        		QuestionAttempt = parseInt(QuestionAttempt) + 1;
        	}
        	component.set("v.QuestionAttempt",QuestionAttempt );
        	
        	Button.set("v.variant", "destructive");
        	findOtherButton.set("v.variant", "neutral");
        	
        /*	if(parseInt(ScoreObtained) >= 1){        	
	        		ScoreObtained = parseInt(ScoreObtained) - 1;
	        	 	component.set("v.ScoreObtained",ScoreObtained);
        	 }
        	 else{        	 	
        	 		component.set("v.ScoreObtained",0);
        	 }
        	*/
        	
        }
        
       else if(ButtonId =='TokenPassButton1')
        {
        	        	
        	if(token1 == 'Select'){
        		alert('Please select Additional Token');
        	}
        	else{
	        
	        	ScoreObtained = parseInt(ScoreObtained) + 1;
	        	component.set("v.ScoreObtained",ScoreObtained);
	        	findOtherButton = component.find('TokenFailButton1');
	        	if(Button.get("v.variant") ==  "neutral"  && findOtherButton.get("v.variant" ) == "neutral"){
	        		QuestionAttempt = parseInt(QuestionAttempt) + 1;
	        	}
	        	component.set("v.QuestionAttempt",QuestionAttempt );
	        
	        	Button.set("v.variant", "success");
	        	findOtherButton.set("v.variant", "neutral");
        	}
        	
        }
        else if(ButtonId =='TokenFailButton1'){ 
        	if(token1 == 'Select'){
        		alert('Please select Additional Token');
        	}
        	else{
        		FailedCount = parseInt(FailedCount) + 1;
        		component.set("v.FailedCount",FailedCount);
	        	findOtherButton = component.find('TokenPassButton1');
	        	if(Button.get("v.variant") ==  "neutral"  && findOtherButton.get("v.variant" ) == "neutral"){
	        			QuestionAttempt = parseInt(QuestionAttempt) + 1;
	        		}
	        		component.set("v.QuestionAttempt",QuestionAttempt );
	        		
	        		Button.set("v.variant", "destructive");
	        		findOtherButton.set("v.variant", "neutral");
	        		
	        	/*if(parseInt(ScoreObtained) >= 1){        	
		        		ScoreObtained = parseInt(ScoreObtained) - 1;
		        	 	component.set("v.ScoreObtained",ScoreObtained);
	        	 }
	        	 else{        	 	
	        	 		component.set("v.ScoreObtained",0);
	        	 }*/
        	 }
        	
        	
        }   
               
    },
})