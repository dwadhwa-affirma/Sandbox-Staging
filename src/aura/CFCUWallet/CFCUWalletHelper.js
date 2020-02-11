({
	
	GetJointMemberDetail: function (component, event, memberId) {
	
	var action = component.get("c.GetCFCUWalletInfo");
	action.setParams({"selectedID": memberId});
    action.setCallback(this, function (response) {
	var status = response.getState();            
		if (component.isValid() && status === "SUCCESS") {
			    var result = response.getReturnValue();
			    if(result.RelationshipData.length > 0){
			    	component.set("v.JointAccount", result.RelationshipData);
			    	component.set("v.IsRelationshipDataAvailable", true);
			    }
			    else{
			    	component.set("v.IsRelationshipDataAvailable", false);
			    }
			    if(result.LoanData.length > 0){
			    	component.set("v.LoanAccount", result.LoanData);
			    	component.set("v.IsLoanDataAvailable", true);
			    }
			    else
			    	{component.set("v.IsLoanDataAvailable", false);
		    	}
		    	if(result.CardDetails.length > 0){
		        	component.set("v.Card", result.CardDetails);
			    	component.set("v.IsCardDetailsAvailable", true);
			    }
			    else
			    	{component.set("v.IsCardDetailsAvailable", false);
		    	}
            
	    }
	    });	
		  
		$A.enqueueAction(action); 
    	 
    	
    },
	ButtonPassFailMethod : function(component, event, helper,ButtonId,Button) {
		
		var findOtherButton;
		var ScoreObtained = component.get("v.ScoreObtained");
		var FailedCount = component.get("v.FailedCount");
		var token1 = component.find("AdditionalToken1").get("v.value");
		var token2 = component.find("AdditionalToken2").get("v.value");
		var QuestionAttempt = component.get("v.QuestionAttempt");
		findOtherButton = component.find('BeneficiaryFailButton')
        if(ButtonId =='BeneficiaryPassButton'){
        	
        	if(Button.get("v.variant") ==  "neutral"  && findOtherButton.get("v.variant" ) == "neutral"){
        		QuestionAttempt = parseInt(QuestionAttempt) + 1;
        	}
        	component.set("v.QuestionAttempt",QuestionAttempt );
        	
        	Button.set("v.variant", "success");
        	ScoreObtained = parseInt(ScoreObtained) + 1;
        	component.set("v.ScoreObtained",ScoreObtained);
        	findOtherButton.set("v.variant", "neutral");

        }
        else if(ButtonId =='BeneficiaryFailButton'){        
        	
        	FailedCount = parseInt(FailedCount) + 1;
        	component.set("v.FailedCount",FailedCount);
        	findOtherButton = component.find('BeneficiaryPassButton')
        	if(Button.get("v.variant") ==  "neutral"  && findOtherButton.get("v.variant" ) == "neutral"){
        		QuestionAttempt = parseInt(QuestionAttempt) + 1;
        	}
        	Button.set("v.variant", "destructive");
        	component.set("v.QuestionAttempt",QuestionAttempt );
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
        else if(ButtonId =='JointPassButton')
        {
        	
        	findOtherButton = component.find('JointFailButton');
        	if(Button.get("v.variant") ==  "neutral"  && findOtherButton.get("v.variant" ) == "neutral"){
        		QuestionAttempt = parseInt(QuestionAttempt) + 1;
        	}
        	component.set("v.QuestionAttempt",QuestionAttempt );
        	
        	Button.set("v.variant", "success");
        	ScoreObtained = parseInt(ScoreObtained) + 1;
        	component.set("v.ScoreObtained",ScoreObtained);
        	
        	findOtherButton.set("v.variant", "neutral");
        	
        }
        else if(ButtonId =='JointFailButton'){        
        	
        	
        	FailedCount = parseInt(FailedCount) + 1;
        	component.set("v.FailedCount",FailedCount);
        	findOtherButton = component.find('JointPassButton')
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

        else if(ButtonId =='LoanPassButton')
        {
        	findOtherButton = component.find('LoanFailButton');
        	if(Button.get("v.variant") ==  "neutral"  && findOtherButton.get("v.variant" ) == "neutral"){
        		QuestionAttempt = parseInt(QuestionAttempt) + 1;
        	}
        	component.set("v.QuestionAttempt",QuestionAttempt );
        	Button.set("v.variant", "success");
        	ScoreObtained = parseInt(ScoreObtained) + 1;
        	component.set("v.ScoreObtained",ScoreObtained);
        	findOtherButton.set("v.variant", "neutral");
        	
        }
        else if(ButtonId =='LoanFailButton'){        
        	
        	FailedCount = parseInt(FailedCount) + 1;
        	component.set("v.FailedCount",FailedCount);
        	findOtherButton = component.find('LoanPassButton');
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
        else if(ButtonId =='CardPassButton')
        {
        	findOtherButton = component.find('CardFailButton');
        	if(Button.get("v.variant") ==  "neutral"  && findOtherButton.get("v.variant" ) == "neutral"){
        		QuestionAttempt = parseInt(QuestionAttempt) + 1;
        	}
        	component.set("v.QuestionAttempt",QuestionAttempt );
        	Button.set("v.variant", "success");
        	ScoreObtained = parseInt(ScoreObtained) + 1;
        	component.set("v.ScoreObtained",ScoreObtained);
        	findOtherButton.set("v.variant", "neutral");
        	
        }
        else if(ButtonId =='CardFailButton'){        
        	
        	FailedCount = parseInt(FailedCount) + 1;
        	component.set("v.FailedCount",FailedCount);
        	findOtherButton = component.find('CardPassButton');
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
        else if(ButtonId =='TokenPassButton1')
        {
        	        	
        	if(token1 == 'Select'){
        		alert('Please select Additional Token');
        	}        	
        	else{
	        	
	        	findOtherButton = component.find('TokenFailButton1');
	        	if(Button.get("v.variant") ==  "neutral"  && findOtherButton.get("v.variant" ) == "neutral"){
	        		QuestionAttempt = parseInt(QuestionAttempt) + 1;
	        	}
	        	component.set("v.QuestionAttempt",QuestionAttempt );
	        	
	        	Button.set("v.variant", "success");
	        	ScoreObtained = parseInt(ScoreObtained) + 1;
	        	component.set("v.ScoreObtained",ScoreObtained);
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
        
        else if(ButtonId =='TokenPassButton2')
        {
        	if(token2 == 'Select'){
        		alert('Please select Additional Token');
        	}
        	
        	else{
	        	findOtherButton = component.find('TokenFailButton2');
	        	if(Button.get("v.variant") ==  "neutral"  && findOtherButton.get("v.variant" ) == "neutral"){
	        		QuestionAttempt = parseInt(QuestionAttempt) + 1;
	        	}
	        	component.set("v.QuestionAttempt",QuestionAttempt );
	        	
	        	Button.set("v.variant", "success");
	        	ScoreObtained = parseInt(ScoreObtained) + 1;
	        	component.set("v.ScoreObtained",ScoreObtained);
	        	findOtherButton.set("v.variant", "neutral");
        	}
        	
        }
        else if(ButtonId =='TokenFailButton2'){
        	if(token2 == 'Select'){
        		alert('Please select Additional Token');
        	}
        	
        	else{
	        	FailedCount = parseInt(FailedCount) + 1;
	        	component.set("v.FailedCount",FailedCount);
	        	findOtherButton = component.find('TokenPassButton2');
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
        else if(ButtonId == 'SubmitButton')
        {
	        	if(component.get("v.IsSubmitClicked") == false)
	        	{	        		
		        	if(component.get("v.QuestionAttempt") <=2){
		        		alert('Please select at least 3 questions before clicking submit.');
		        		component.set("v.ScoreObtained",0 );
	        			component.set("v.QuestionAttempt",0 );
	        			component.set("v.FailedCount",0 );
		        	}
		        	else{
			        	var compEvent = component.getEvent("statusEvent");
			        	var memberId = component.get("v.recordId");
			        	var status;
			            compEvent.setParams({"CFCUWalletScoreObtained" : ScoreObtained,"CFCUWalletFailedCount" : FailedCount, "ActionType": 'CFCU Wallet'});
					    compEvent.fire();
					    if(ScoreObtained >= 3 && FailedCount <= 1)
				  			status = "passed";
				        else
				            status = "failed";
				  		var action = component.get("c.CFCUWalletSaveLogData");
				  		var GUID = component.get("v.GUID");
				  		action.setParams({"MemberId": memberId, "Status": status, "GUID" : GUID});
				  		action.setCallback(this, function (response) {	    
				  		var status = response.getState();            
					    if (component.isValid() && status === "SUCCESS") {
					    	var result = response.getReturnValue();
					    }
					    else
					    {
					    	compEvent = component.getEvent("statusEvent");
					    }
					    component.set("v.IsSubmitClicked",true);
					   	});
					   	$A.enqueueAction(action);	
				   	}
				   	
				   	component.find('BeneficiaryPassButton').set("v.variant", "neutral");
                	component.find('BeneficiaryFailButton').set("v.variant", "neutral");
                	component.find('JointPassButton').set("v.variant", "neutral");
                	component.find('JointFailButton').set("v.variant", "neutral");
                	component.find('LoanPassButton').set("v.variant", "neutral");
                	component.find('LoanFailButton').set("v.variant", "neutral");
                	if(component.get("v.IsCFCUSectionVisible") == true){                	
                		component.find('CardPassButton').set("v.variant", "neutral");
                		component.find('CardFailButton').set("v.variant", "neutral");
                	}
                	component.find('TokenPassButton1').set("v.variant", "neutral");
                	component.find('TokenFailButton1').set("v.variant", "neutral");
                	component.find('TokenPassButton2').set("v.variant", "neutral");
                	component.find('TokenFailButton2').set("v.variant", "neutral");
				   	
			   	}
        }
 		 
	},
	
	
})