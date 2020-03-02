({
	doInit : function(component, event, helper) {
	
		var memberId = component.get("v.recordId");
		var PublicWalletStatusForDay = component.get("v.PublicWalletStatusForDay");
		var IVRGUIDFromUrl = component.get("v.IVRGUIDFromUrl");
		helper.getDLStateIdPassport(component, event, helper, memberId, IVRGUIDFromUrl);
		component.set("v.IsSubmitClicked",false);
		component.set("v.ScoreObtained",0 );
		component.set("v.QuestionAttempt",0 );
		component.set("v.FailedCount",0 );
		component.set("v.IsSubmitClicked",false);
		helper.buttonOnLoad(component, event, helper);
		var params = event.getParam('arguments');
		if (params) {
			var IsReLoadRequired =  params.param2;
			component.set("v.IsReLoadRequired", IsReLoadRequired);
			}
	},
	executeMethod : function (component, event, helper) {
        var params = event.getParam('arguments');
		if (params) {
			var IsReLoadRequired =  params.param2;
			component.set("v.IsReLoadRequired", IsReLoadRequired);
			}
        },
	
    submit: function(component, event, helper) {
		
		if(component.get("v.IsSubmitClicked") == false)
    	{
			if(component.get("v.QuestionAttempt") <=2){
				alert('Please select at least 3 questions before clicking submit.');
				//component.set("v.ScoreObtained",0 );
				//component.set("v.QuestionAttempt",0 );
				//component.set("v.FailedCount",0 );
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
					component.set("v.PublicWalletStatusForDay",false);
					
			}
			
        	
		}
	},
    
    ButtonClick : function(component, event, helper) {
    	
    	var DOBMatch;
    	var IdNumberMatch;
    	var MMNMatch;
    	var EmailMatch;
    	var AdditionalTokenOption3Match;
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
        	else
        	{
        		FailedCount = parseInt(FailedCount) - 1;
        		component.set("v.FailedCount",FailedCount);
        	}
        	component.set("v.QuestionAttempt",QuestionAttempt );
        	
        	Button.set("v.variant", "success");
        	ScoreObtained = parseInt(ScoreObtained) + 1;
        	component.set("v.ScoreObtained",ScoreObtained);
           	findOtherButton.set("v.variant", "neutral");
           	DOBMatch = 'Pass';
        	component.set("v.DOBMatch",DOBMatch);
        	
        }
        else if(ButtonId =='DobFailButton'){        
        	
        	findOtherButton = component.find('DobPassButton');
        	FailedCount = parseInt(FailedCount) + 1;
        	component.set("v.FailedCount",FailedCount);
           	if(Button.get("v.variant") ==  "neutral" && findOtherButton.get("v.variant" ) == "neutral"){
        		QuestionAttempt = parseInt(QuestionAttempt) + 1;
        	}
        	else
        	{
        		ScoreObtained = parseInt(ScoreObtained) - 1;
        		component.set("v.ScoreObtained",ScoreObtained);
        	}
        	component.set("v.QuestionAttempt",QuestionAttempt  );
        	
        	Button.set("v.variant", "destructive");
        	findOtherButton.set("v.variant", "neutral");
        	DOBMatch = 'Fail';
        	component.set("v.DOBMatch",DOBMatch);
        	
        }
        else if(ButtonId =='DLPassButton')
        {
        	
        	ScoreObtained = parseInt(ScoreObtained) + 1;
        	component.set("v.ScoreObtained",ScoreObtained);
        	findOtherButton = component.find('DLFailButton');
        	if(Button.get("v.variant") ==  "neutral"  && findOtherButton.get("v.variant" ) == "neutral"){
        		QuestionAttempt = parseInt(QuestionAttempt) + 1;
        	}
        	else
        	{
        		FailedCount = parseInt(FailedCount) - 1;
        		component.set("v.FailedCount",FailedCount);
        	}
        	component.set("v.QuestionAttempt",QuestionAttempt );
        	
        	Button.set("v.variant", "success");
        	findOtherButton.set("v.variant", "neutral");
        	IdNumberMatch = 'Pass';
        	component.set("v.IdNumberMatch",IdNumberMatch);
        	
        }
        else if(ButtonId =='DLFailButton'){        
        	
        	findOtherButton = component.find('DLPassButton');
        	FailedCount = parseInt(FailedCount) + 1;
        	component.set("v.FailedCount",FailedCount);
        	if(Button.get("v.variant") ==  "neutral"  && findOtherButton.get("v.variant" ) == "neutral"){
        		QuestionAttempt = parseInt(QuestionAttempt) + 1;
        	}
        	else
        	{
        		ScoreObtained = parseInt(ScoreObtained) - 1;
        		component.set("v.ScoreObtained",ScoreObtained);
        	}
        	component.set("v.QuestionAttempt",QuestionAttempt );
        	
        	Button.set("v.variant", "destructive");
        	findOtherButton.set("v.variant", "neutral");
        	IdNumberMatch = 'Fail';
        	component.set("v.IdNumberMatch",IdNumberMatch);
       
        }

        else if(ButtonId =='MothersMaidenNamePassButton')
        {
        	
        	ScoreObtained = parseInt(ScoreObtained) + 1;
        	component.set("v.ScoreObtained",ScoreObtained);
        	findOtherButton = component.find('MothersMaidenNameFailButton')
        	
        	if(Button.get("v.variant") ==  "neutral"  && findOtherButton.get("v.variant" ) == "neutral"){
        		QuestionAttempt = parseInt(QuestionAttempt) + 1;
        	}
        	else
        	{
        		FailedCount = parseInt(FailedCount) - 1;
        		component.set("v.FailedCount",FailedCount);
        	}
        	component.set("v.QuestionAttempt",QuestionAttempt );
        	
        	Button.set("v.variant", "success");
        	findOtherButton.set("v.variant", "neutral");
        	MMNMatch = 'Pass';
        	component.set("v.MMNMatch",MMNMatch);
        	
        }
        else if(ButtonId =='MothersMaidenNameFailButton'){        
        	
        	FailedCount = parseInt(FailedCount) + 1;
        	component.set("v.FailedCount",FailedCount);
        	findOtherButton = component.find('MothersMaidenNamePassButton');
        	if(Button.get("v.variant") ==  "neutral"  && findOtherButton.get("v.variant" ) == "neutral"){
        		QuestionAttempt = parseInt(QuestionAttempt) + 1;
        	}
        	else
        	{
        		ScoreObtained = parseInt(ScoreObtained) - 1;
        		component.set("v.ScoreObtained",ScoreObtained);
        	}
        	component.set("v.QuestionAttempt",QuestionAttempt );
        
        	Button.set("v.variant", "destructive");
        	findOtherButton.set("v.variant", "neutral");
        	MMNMatch = 'Fail';
        	component.set("v.MMNMatch",MMNMatch);
        	
        }
        
        else if(ButtonId =='EmailPassButton')
        {
        	
        	ScoreObtained = parseInt(ScoreObtained) + 1;
        	component.set("v.ScoreObtained",ScoreObtained);
        	findOtherButton = component.find('EmailFailButton');
        	if(Button.get("v.variant") ==  "neutral"  && findOtherButton.get("v.variant" ) == "neutral"){
        		QuestionAttempt = parseInt(QuestionAttempt) + 1;
        	}
        	else
        	{
        		FailedCount = parseInt(FailedCount) - 1;
        		component.set("v.FailedCount",FailedCount);
        	}
        	component.set("v.QuestionAttempt",QuestionAttempt );
        	
        	Button.set("v.variant", "success");
        	findOtherButton.set("v.variant", "neutral");
        	EmailMatch = 'Pass';
        	component.set("v.EmailMatch",EmailMatch);
        	
        }
        else if(ButtonId =='EmailFailButton'){        
        	
        	findOtherButton = component.find('EmailPassButton');
        	FailedCount = parseInt(FailedCount) + 1;
        	component.set("v.FailedCount",FailedCount);
        	if(Button.get("v.variant") ==  "neutral"  && findOtherButton.get("v.variant" ) == "neutral"){
        		QuestionAttempt = parseInt(QuestionAttempt) + 1;
        	}
        	else
        	{
        		ScoreObtained = parseInt(ScoreObtained) - 1;
        		component.set("v.ScoreObtained",ScoreObtained);
        	}
        	component.set("v.QuestionAttempt",QuestionAttempt );
        	
        	Button.set("v.variant", "destructive");
        	findOtherButton.set("v.variant", "neutral");
        	EmailMatch = 'Fail';
        	component.set("v.EmailMatch",EmailMatch);
        	
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
	        	else
	        	{
	        		FailedCount = parseInt(FailedCount) - 1;
	        		component.set("v.FailedCount",FailedCount);
	        	}
	        	component.set("v.QuestionAttempt",QuestionAttempt );
	        
	        	Button.set("v.variant", "success");
	        	findOtherButton.set("v.variant", "neutral");
	        	AdditionalTokenOption3Match = 'Pass';
	        	component.set("v.AdditionalTokenOption3Match",AdditionalTokenOption3Match);
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
        		else
	        	{
	        		ScoreObtained = parseInt(ScoreObtained) - 1;
	        		component.set("v.ScoreObtained",ScoreObtained);
	        	}
        		component.set("v.QuestionAttempt",QuestionAttempt );
        		
        		Button.set("v.variant", "destructive");
        		findOtherButton.set("v.variant", "neutral");
        		AdditionalTokenOption3Match = 'Fail';
	        	component.set("v.AdditionalTokenOption3Match",AdditionalTokenOption3Match);
	        
        	 }
        	
        }   
               
    },
})