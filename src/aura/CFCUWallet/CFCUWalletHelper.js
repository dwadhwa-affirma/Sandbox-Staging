({
	
	GetJointMemberDetail: function (component, event,helper, memberId, IVRGUIDFromUrl) {
	
	var action = component.get("c.GetCFCUWalletInfo");
	action.setParams({"selectedID": memberId, "IVRGUIDFromUrl": IVRGUIDFromUrl});
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
			    else{
			    	component.set("v.IsCardDetailsAvailable", false);
		    	}
		    	if(result.CFCULastSessionInfo.length > 0 && result.CFCULastSessionInfo[0].CFCU_Wallet_Status__c != undefined && component.get("v.IsUserSessionLoaded") == true){
		    		component.set("v.CFCULastSessionInfo", result.CFCULastSessionInfo);
		    		if(result.CFCULastSessionInfo[0].BeneficiaryDetailMatch__c == undefined){
		    			component.find('BeneficiaryPassButton').set("v.variant", "neutral");
		    			component.find('BeneficiaryFailButton').set("v.variant", "neutral");
		    		}		    		
		    		if(result.CFCULastSessionInfo[0].BeneficiaryDetailMatch__c == 'Pass'){
		    			component.find('BeneficiaryPassButton').set("v.variant", "success");
		    			component.find('BeneficiaryFailButton').set("v.variant", "neutral");
		    		}
		    		if(result.CFCULastSessionInfo[0].BeneficiaryDetailMatch__c == 'Fail'){
		    			component.find('BeneficiaryFailButton').set("v.variant", "destructive");
		    			component.find('BeneficiaryPassButton').set("v.variant", "neutral");
		    		}
		    		
		    		
		    		if(result.CFCULastSessionInfo[0].Joint_OwnerDetailsMatch__c == undefined){
		    			component.find('JointPassButton').set("v.variant", "neutral");
		    			component.find('JointFailButton').set("v.variant", "neutral");
		    		}
		    		if(result.CFCULastSessionInfo[0].Joint_OwnerDetailsMatch__c == 'Pass'){
		    			component.find('JointPassButton').set("v.variant", "success");
		    			component.find('JointFailButton').set("v.variant", "neutral");
		    		}
		    		if(result.CFCULastSessionInfo[0].Joint_OwnerDetailsMatch__c == 'Fail'){
		    			component.find('JointFailButton').set("v.variant", "destructive");
		    			component.find('JointPassButton').set("v.variant", "neutral");
		    		}
		    		
		    		
		    		if(result.CFCULastSessionInfo[0].Loan_Detail_Match__c == undefined){
		    			component.find('LoanPassButton').set("v.variant", "neutral");
		    			component.find('LoanFailButton').set("v.variant", "neutral");
		    		}
		    		if(result.CFCULastSessionInfo[0].Loan_Detail_Match__c == 'Pass'){
		    			component.find('LoanPassButton').set("v.variant", "success");
		    			component.find('LoanFailButton').set("v.variant", "neutral");
		    		}
		    		if(result.CFCULastSessionInfo[0].Loan_Detail_Match__c == 'Fail'){
		    			component.find('LoanFailButton').set("v.variant", "destructive");
		    			component.find('LoanPassButton').set("v.variant", "neutral");
		    		}
		    		
		    		
		    		if(component.get("v.IsCFCUSectionVisible") == true){ 
		    			if(result.CFCULastSessionInfo[0].CardNumberMatch__c == undefined){
		    			component.find('CardPassButton').set("v.variant", "neutral");
		    			component.find('CardFailButton').set("v.variant", "neutral");
		    			}
		    			if(result.CFCULastSessionInfo[0].CardNumberMatch__c == 'Pass'){
		    			component.find('CardPassButton').set("v.variant", "success");
		    			component.find('CardFailButton').set("v.variant", "neutral");
		    			}
		    			if(result.CFCULastSessionInfo[0].CardNumberMatch__c == 'Fail'){
		    			component.find('CardFailButton').set("v.variant", "destructive");
		    			component.find('CardPassButton').set("v.variant", "neutral");
		    			}
		    		}
		    		
		    		if(result.CFCULastSessionInfo[0].Additional_Token_Option1_Match__c == undefined){
		    			component.find('TokenPassButton1').set("v.variant", "neutral");
		    			component.find('TokenFailButton1').set("v.variant", "neutral");
		    		}		    		
		    		if(result.CFCULastSessionInfo[0].Additional_Token_Option1_Match__c == 'Pass'){
		    			component.find('TokenPassButton1').set("v.variant", "success");
		    			component.find('TokenFailButton1').set("v.variant", "neutral");
		    		}
		    		if(result.CFCULastSessionInfo[0].Additional_Token_Option1_Match__c == 'Fail'){
		    			component.find('TokenFailButton1').set("v.variant", "destructive");
		    			component.find('TokenPassButton1').set("v.variant", "neutral");
		    		}
		    		
		    		if(result.CFCULastSessionInfo[0].Additional_Token_Option2_Match__c == undefined){
		    			component.find('TokenPassButton2').set("v.variant", "neutral");
		    			component.find('TokenFailButton2').set("v.variant", "neutral");
		    		}
		    		if(result.CFCULastSessionInfo[0].Additional_Token_Option2_Match__c == 'Pass'){
		    			component.find('TokenPassButton2').set("v.variant", "success");
		    			component.find('TokenFailButton2').set("v.variant", "neutral");
		    		}
		    		if(result.CFCULastSessionInfo[0].Additional_Token_Option2_Match__c == 'Fail'){
		    			component.find('TokenFailButton2').set("v.variant", "destructive");
		    			component.find('TokenPassButton2').set("v.variant", "neutral");
		    		}
		    				    		
		    	}
		    	
		    	if(result.CFCULastSessionInfo.length > 0 && result.CFCULastSessionInfo[0].CFCU_Wallet_Status__c =='Fail' && component.get("v.IsUserSessionLoaded") == false){
		    		component.set("v.CFCULastSessionInfo", result.CFCULastSessionInfo);
		    		if(result.CFCULastSessionInfo[0].BeneficiaryDetailMatch__c == undefined){
		    			component.find('BeneficiaryPassButton').set("v.variant", "neutral");
		    			component.find('BeneficiaryFailButton').set("v.variant", "neutral");
		    		}		    		
		    		if(result.CFCULastSessionInfo[0].BeneficiaryDetailMatch__c == 'Pass'){
		    			component.find('BeneficiaryPassButton').set("v.variant", "success");
		    			component.find('BeneficiaryFailButton').set("v.variant", "neutral");
		    		}
		    		if(result.CFCULastSessionInfo[0].BeneficiaryDetailMatch__c == 'Fail'){
		    			component.find('BeneficiaryFailButton').set("v.variant", "destructive");
		    			component.find('BeneficiaryPassButton').set("v.variant", "neutral");
		    		}
		    		
		    		
		    		if(result.CFCULastSessionInfo[0].Joint_OwnerDetailsMatch__c == undefined){
		    			component.find('JointPassButton').set("v.variant", "neutral");
		    			component.find('JointFailButton').set("v.variant", "neutral");
		    		}
		    		if(result.CFCULastSessionInfo[0].Joint_OwnerDetailsMatch__c == 'Pass'){
		    			component.find('JointPassButton').set("v.variant", "success");
		    			component.find('JointFailButton').set("v.variant", "neutral");
		    		}
		    		if(result.CFCULastSessionInfo[0].Joint_OwnerDetailsMatch__c == 'Fail'){
		    			component.find('JointFailButton').set("v.variant", "destructive");
		    			component.find('JointPassButton').set("v.variant", "neutral");
		    		}
		    		
		    		
		    		if(result.CFCULastSessionInfo[0].Loan_Detail_Match__c == undefined){
		    			component.find('LoanPassButton').set("v.variant", "neutral");
		    			component.find('LoanFailButton').set("v.variant", "neutral");
		    		}
		    		if(result.CFCULastSessionInfo[0].Loan_Detail_Match__c == 'Pass'){
		    			component.find('LoanPassButton').set("v.variant", "success");
		    			component.find('LoanFailButton').set("v.variant", "neutral");
		    		}
		    		if(result.CFCULastSessionInfo[0].Loan_Detail_Match__c == 'Fail'){
		    			component.find('LoanFailButton').set("v.variant", "destructive");
		    			component.find('LoanPassButton').set("v.variant", "neutral");
		    		}
		    		
		    		
		    		if(component.get("v.IsCFCUSectionVisible") == true){ 
		    			if(result.CFCULastSessionInfo[0].CardNumberMatch__c == undefined){
		    			component.find('CardPassButton').set("v.variant", "neutral");
		    			component.find('CardFailButton').set("v.variant", "neutral");
		    			}
		    			if(result.CFCULastSessionInfo[0].CardNumberMatch__c == 'Pass'){
		    			component.find('CardPassButton').set("v.variant", "success");
		    			component.find('CardFailButton').set("v.variant", "neutral");
		    			}
		    			if(result.CFCULastSessionInfo[0].CardNumberMatch__c == 'Fail'){
		    			component.find('CardFailButton').set("v.variant", "destructive");
		    			component.find('CardPassButton').set("v.variant", "neutral");
		    			}
		    		}
		    		
		    		if(result.CFCULastSessionInfo[0].Additional_Token_Option1_Match__c == undefined){
		    			component.find('TokenPassButton1').set("v.variant", "neutral");
		    			component.find('TokenFailButton1').set("v.variant", "neutral");
		    		}		    		
		    		if(result.CFCULastSessionInfo[0].Additional_Token_Option1_Match__c == 'Pass'){
		    			component.find('TokenPassButton1').set("v.variant", "success");
		    			component.find('TokenFailButton1').set("v.variant", "neutral");
		    		}
		    		if(result.CFCULastSessionInfo[0].Additional_Token_Option1_Match__c == 'Fail'){
		    			component.find('TokenFailButton1').set("v.variant", "destructive");
		    			component.find('TokenPassButton1').set("v.variant", "neutral");
		    		}
		    		
		    		if(result.CFCULastSessionInfo[0].Additional_Token_Option2_Match__c == undefined){
		    			component.find('TokenPassButton2').set("v.variant", "neutral");
		    			component.find('TokenFailButton2').set("v.variant", "neutral");
		    		}
		    		if(result.CFCULastSessionInfo[0].Additional_Token_Option2_Match__c == 'Pass'){
		    			component.find('TokenPassButton2').set("v.variant", "success");
		    			component.find('TokenFailButton2').set("v.variant", "neutral");
		    		}
		    		if(result.CFCULastSessionInfo[0].Additional_Token_Option2_Match__c == 'Fail'){
		    			component.find('TokenFailButton2').set("v.variant", "destructive");
		    			component.find('TokenPassButton2').set("v.variant", "neutral");
		    		}
		    				    		
		    	}
		    	else if(result.CFCULastSessionInfo.length > 0 && result.CFCULastSessionInfo[0].CFCU_Wallet_Status__c == 'Pass' && component.get("v.IsReLoadRequired") == false && component.get("v.IsUserSessionLoaded") == false){
		    		helper.buttonOnLoad(component, event, helper);
		    	}
		    	else if(result.CFCUReloadInfo != undefined && result.CFCUReloadInfo.length > 0 && component.get("v.IsReLoadRequired") == true){
		    		
		    			if(result.CFCUReloadInfo[0].BeneficiaryDetailMatch__c == undefined){
		    			component.find('BeneficiaryPassButton').set("v.variant", "neutral");
		    			component.find('BeneficiaryFailButton').set("v.variant", "neutral");
		    		}		    		
		    		if(result.CFCUReloadInfo[0].BeneficiaryDetailMatch__c == 'Pass'){
		    			component.find('BeneficiaryPassButton').set("v.variant", "success");
		    			component.find('BeneficiaryFailButton').set("v.variant", "neutral");
		    		}
		    		if(result.CFCUReloadInfo[0].BeneficiaryDetailMatch__c == 'Fail'){
		    			component.find('BeneficiaryFailButton').set("v.variant", "destructive");
		    			component.find('BeneficiaryPassButton').set("v.variant", "neutral");
		    		}
		    		
		    		
		    		if(result.CFCUReloadInfo[0].Joint_OwnerDetailsMatch__c == undefined){
		    			component.find('JointPassButton').set("v.variant", "neutral");
		    			component.find('JointFailButton').set("v.variant", "neutral");
		    		}
		    		if(result.CFCUReloadInfo[0].Joint_OwnerDetailsMatch__c == 'Pass'){
		    			component.find('JointPassButton').set("v.variant", "success");
		    			component.find('JointFailButton').set("v.variant", "neutral");
		    		}
		    		if(result.CFCUReloadInfo[0].Joint_OwnerDetailsMatch__c == 'Fail'){
		    			component.find('JointFailButton').set("v.variant", "destructive");
		    			component.find('JointPassButton').set("v.variant", "neutral");
		    		}
		    		
		    		
		    		if(result.CFCUReloadInfo[0].Loan_Detail_Match__c == undefined){
		    			component.find('LoanPassButton').set("v.variant", "neutral");
		    			component.find('LoanFailButton').set("v.variant", "neutral");
		    		}
		    		if(result.CFCUReloadInfo[0].Loan_Detail_Match__c == 'Pass'){
		    			component.find('LoanPassButton').set("v.variant", "success");
		    			component.find('LoanFailButton').set("v.variant", "neutral");
		    		}
		    		if(result.CFCUReloadInfo[0].Loan_Detail_Match__c == 'Fail'){
		    			component.find('LoanFailButton').set("v.variant", "destructive");
		    			component.find('LoanPassButton').set("v.variant", "neutral");
		    		}
		    		
		    		
		    		if(component.get("v.IsCFCUSectionVisible") == true){ 
		    			if(result.CFCUReloadInfo[0].CardNumberMatch__c == undefined){
		    			component.find('CardPassButton').set("v.variant", "neutral");
		    			component.find('CardFailButton').set("v.variant", "neutral");
		    			}
		    			if(result.CFCUReloadInfo[0].CardNumberMatch__c == 'Pass'){
		    			component.find('CardPassButton').set("v.variant", "success");
		    			component.find('CardFailButton').set("v.variant", "neutral");
		    			}
		    			if(result.CFCUReloadInfo[0].CardNumberMatch__c == 'Fail'){
		    			component.find('CardFailButton').set("v.variant", "destructive");
		    			component.find('CardPassButton').set("v.variant", "neutral");
		    			}
		    		}
		    		
		    		if(result.CFCUReloadInfo[0].Additional_Token_Option1_Match__c == undefined){
		    			component.find('TokenPassButton1').set("v.variant", "neutral");
		    			component.find('TokenFailButton1').set("v.variant", "neutral");
		    		}		    		
		    		if(result.CFCUReloadInfo[0].Additional_Token_Option1_Match__c == 'Pass'){
		    			component.find('TokenPassButton1').set("v.variant", "success");
		    			component.find('TokenFailButton1').set("v.variant", "neutral");
		    		}
		    		if(result.CFCUReloadInfo[0].Additional_Token_Option1_Match__c == 'Fail'){
		    			component.find('TokenFailButton1').set("v.variant", "destructive");
		    			component.find('TokenPassButton1').set("v.variant", "neutral");
		    		}
		    		
		    		if(result.CFCUReloadInfo[0].Additional_Token_Option2_Match__c == undefined){
		    			component.find('TokenPassButton2').set("v.variant", "neutral");
		    			component.find('TokenFailButton2').set("v.variant", "neutral");
		    		}
		    		if(result.CFCUReloadInfo[0].Additional_Token_Option2_Match__c == 'Pass'){
		    			component.find('TokenPassButton2').set("v.variant", "success");
		    			component.find('TokenFailButton2').set("v.variant", "neutral");
		    		}
		    		if(result.CFCUReloadInfo[0].Additional_Token_Option2_Match__c == 'Fail'){
		    			component.find('TokenFailButton2').set("v.variant", "destructive");
		    			component.find('TokenPassButton2').set("v.variant", "neutral");
		    		}
		    		
		    		//component.set("v.CFCUWalletStatusForDay", false);
		    	}
		    	
		    	
		    	
		    	
	    }
	    });	
		  
		$A.enqueueAction(action); 
    	 
    	
    },
	ButtonPassFailMethod : function(component, event, helper,ButtonId,Button) {
		if(component.get("v.IsSubmitClicked") == false)
	    {	
				var BeneficiaryDetailMatch;
				var JointOwnerDetailMatch;
				var CardNumberMatch;
				var AdditionalTokenOption1Match;
				var AdditionalTokenOption2Match;
				var LoanDetailMatch;
				var findOtherButton;
				var ScoreObtained = component.get("v.ScoreObtained");
				var FailedCount = component.get("v.FailedCount");
				var token1 = component.find("AdditionalToken1").get("v.value");
				var token2 = component.find("AdditionalToken2").get("v.value");
				var QuestionAttempt = component.get("v.QuestionAttempt");
				findOtherButton = component.find('BeneficiaryFailButton');
				
		        if(ButtonId =='BeneficiaryPassButton'){
		        	
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
		        	BeneficiaryDetailMatch = 'Pass';
		        	component.set("v.BeneficiaryDetailMatch",BeneficiaryDetailMatch);
		        	if(QuestionAttempt >=3){
		        		component.set("v.IsButtonDisabled",false);
		        	}
		        }
		        else if(ButtonId =='BeneficiaryFailButton'){        
		        	        	
		        	findOtherButton = component.find('BeneficiaryPassButton')
		        	if(Button.get("v.variant") ==  "neutral"  && findOtherButton.get("v.variant" ) == "neutral"){
		        		QuestionAttempt = parseInt(QuestionAttempt) + 1;
		        	}
		        	else
		        	{
		        		ScoreObtained = parseInt(ScoreObtained) - 1;
		        		component.set("v.ScoreObtained",ScoreObtained);
		        		
		        	}
		        	FailedCount = parseInt(FailedCount) + 1;
		        	component.set("v.FailedCount",FailedCount);
		        	
		        	Button.set("v.variant", "destructive");
		        	component.set("v.QuestionAttempt",QuestionAttempt );
		        	findOtherButton.set("v.variant", "neutral");
		        	BeneficiaryDetailMatch = 'Fail';
		        	component.set("v.BeneficiaryDetailMatch",BeneficiaryDetailMatch);
		        	if(QuestionAttempt >=3){
		        		component.set("v.IsButtonDisabled",false);
		        	}
		        }
		        else if(ButtonId =='JointPassButton')
		        {
		        	
		        	findOtherButton = component.find('JointFailButton');
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
		        	JointOwnerDetailMatch = 'Pass';
		        	component.set("v.JointOwnerDetailMatch",JointOwnerDetailMatch);
		        	if(QuestionAttempt >=3){
		        		component.set("v.IsButtonDisabled",false);
		        	}
		        }
		        else if(ButtonId =='JointFailButton'){   
		        	FailedCount = parseInt(FailedCount) + 1;
		        	component.set("v.FailedCount",FailedCount);
		        	findOtherButton = component.find('JointPassButton')
		        	if(Button.get("v.variant") ==  "neutral"  && findOtherButton.get("v.variant" ) == "neutral"){
		        		QuestionAttempt = parseInt(QuestionAttempt) + 1;
		        	}
		        	else{
		        		ScoreObtained = parseInt(ScoreObtained) - 1;
		        		component.set("v.ScoreObtained",ScoreObtained);        		
		        	}
		        	component.set("v.QuestionAttempt",QuestionAttempt );
		        	Button.set("v.variant", "destructive");
		        	findOtherButton.set("v.variant", "neutral");
		        	JointOwnerDetailMatch = 'Fail';
		        	component.set("v.JointOwnerDetailMatch",JointOwnerDetailMatch);
		        	if(QuestionAttempt >=3){
		        		component.set("v.IsButtonDisabled",false);
		        	}
		        }
		        else if(ButtonId =='LoanPassButton')
		        {
		        	findOtherButton = component.find('LoanFailButton');
		        	if(Button.get("v.variant") ==  "neutral"  && findOtherButton.get("v.variant" ) == "neutral"){
		        		QuestionAttempt = parseInt(QuestionAttempt) + 1;
		        	}
		        	else{
		        		FailedCount = parseInt(FailedCount) - 1;
		        		component.set("v.FailedCount",FailedCount);
		        	}
		        	component.set("v.QuestionAttempt",QuestionAttempt );
		        	Button.set("v.variant", "success");
		        	ScoreObtained = parseInt(ScoreObtained) + 1;
		        	component.set("v.ScoreObtained",ScoreObtained);
		        	findOtherButton.set("v.variant", "neutral");
		        	LoanDetailMatch = 'Pass';
		        	component.set("v.LoanDetailMatch",LoanDetailMatch);
		        	if(QuestionAttempt >=3){
		        		component.set("v.IsButtonDisabled",false);
		        	}
		        }
		        else if(ButtonId =='LoanFailButton'){        
		        	
		        	FailedCount = parseInt(FailedCount) + 1;
		        	component.set("v.FailedCount",FailedCount);
		        	findOtherButton = component.find('LoanPassButton');
		        	if(Button.get("v.variant") ==  "neutral"  && findOtherButton.get("v.variant" ) == "neutral"){
		        		QuestionAttempt = parseInt(QuestionAttempt) + 1;
		        	}
		        	else{
		        		ScoreObtained = parseInt(ScoreObtained) - 1;
		        		component.set("v.ScoreObtained",ScoreObtained);
		        		
		        	}
		        	component.set("v.QuestionAttempt",QuestionAttempt );
		        	Button.set("v.variant", "destructive");
		        	findOtherButton.set("v.variant", "neutral");
		        	LoanDetailMatch = 'Fail';
		        	component.set("v.LoanDetailMatch",LoanDetailMatch);
		        	if(QuestionAttempt >=3){
		        		component.set("v.IsButtonDisabled",false);
		        	}
		        	
		        }
		        else if(ButtonId =='CardPassButton')
		        {
		        	findOtherButton = component.find('CardFailButton');
		        	if(Button.get("v.variant") ==  "neutral"  && findOtherButton.get("v.variant" ) == "neutral"){
		        		QuestionAttempt = parseInt(QuestionAttempt) + 1;
		        	}
		        	else{
		        		FailedCount = parseInt(FailedCount) - 1;
		        		component.set("v.FailedCount",FailedCount);
		        	}
		        	component.set("v.QuestionAttempt",QuestionAttempt );
		        	Button.set("v.variant", "success");
		        	ScoreObtained = parseInt(ScoreObtained) + 1;
		        	component.set("v.ScoreObtained",ScoreObtained);
		        	findOtherButton.set("v.variant", "neutral");
		        	CardNumberMatch = 'Pass';
		        	component.set("v.CardNumberMatch",CardNumberMatch);
		        	if(QuestionAttempt >=3){
		        		component.set("v.IsButtonDisabled",false);
		        	}
		        }
		        else if(ButtonId =='CardFailButton'){        
		        	
		        	FailedCount = parseInt(FailedCount) + 1;
		        	component.set("v.FailedCount",FailedCount);
		        	findOtherButton = component.find('CardPassButton');
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
		        	CardNumberMatch = 'Fail';
		        	component.set("v.CardNumberMatch",CardNumberMatch);
		        	if(QuestionAttempt >=3){
		        		component.set("v.IsButtonDisabled",false);
		        	}
		        	
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
			        	else{
			        		FailedCount = parseInt(FailedCount) - 1;
			        		component.set("v.FailedCount",FailedCount);
			        	}
			        	component.set("v.QuestionAttempt",QuestionAttempt );	        	
			        	Button.set("v.variant", "success");
			        	ScoreObtained = parseInt(ScoreObtained) + 1;
			        	component.set("v.ScoreObtained",ScoreObtained);
			        	findOtherButton.set("v.variant", "neutral");
			        	AdditionalTokenOption1Match = 'Pass';
			        	component.set("v.AdditionalTokenOption1Match",AdditionalTokenOption1Match);	
			        	if(QuestionAttempt >=3){
			        		component.set("v.IsButtonDisabled",false);
			        	}
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
			        	
			        	else{
			        		ScoreObtained = parseInt(ScoreObtained) - 1;
			        		component.set("v.ScoreObtained",ScoreObtained);        		
			        	}
			        	component.set("v.QuestionAttempt",QuestionAttempt );
			        	Button.set("v.variant", "destructive");
			        	findOtherButton.set("v.variant", "neutral");
			        	AdditionalTokenOption1Match = 'Fail';
			        	component.set("v.AdditionalTokenOption1Match",AdditionalTokenOption1Match);
			        	if(QuestionAttempt >=3){
			        		component.set("v.IsButtonDisabled",false);
			        	}
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
			        	else{
			        		FailedCount = parseInt(FailedCount) - 1;
			        		component.set("v.FailedCount",FailedCount);
			        	}
			        	component.set("v.QuestionAttempt",QuestionAttempt );	        	
			        	Button.set("v.variant", "success");
			        	ScoreObtained = parseInt(ScoreObtained) + 1;
			        	component.set("v.ScoreObtained",ScoreObtained);
			        	findOtherButton.set("v.variant", "neutral");
			        	AdditionalTokenOption2Match = 'Pass';
			        	component.set("v.AdditionalTokenOption2Match",AdditionalTokenOption2Match);	
			        	if(QuestionAttempt >=3){
			        		component.set("v.IsButtonDisabled",false);
			        	}
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
			        	else{
			        		ScoreObtained = parseInt(ScoreObtained) - 1;
			        		component.set("v.ScoreObtained",ScoreObtained);        		
			        	}
			        	component.set("v.QuestionAttempt",QuestionAttempt );
			        	
			        	Button.set("v.variant", "destructive");
			        	findOtherButton.set("v.variant", "neutral");
			        	AdditionalTokenOption2Match = 'Fail';
			        	component.set("v.AdditionalTokenOption2Match",AdditionalTokenOption2Match);	
			        	if(QuestionAttempt >=3){
			        		component.set("v.IsButtonDisabled",false);
			        		}
			        	}
		        	
		        	
		        }
		        else if(ButtonId == 'SubmitButton')
		        {
			        	        		
				        	if(component.get("v.QuestionAttempt") <=2){
				        		alert('Please select at least 3 questions before clicking submit.');		        		
				        	}
				        	else{
					        	var compEvent = component.getEvent("statusEvent");
					        	var memberId = component.get("v.recordId");
					        	var status;
					        	BeneficiaryDetailMatch = component.get("v.BeneficiaryDetailMatch");
					        	JointOwnerDetailMatch = component.get("v.JointOwnerDetailMatch");
					        	CardNumberMatch = component.get("v.CardNumberMatch");
					        	AdditionalTokenOption1Match = component.get("v.AdditionalTokenOption1Match");
					        	AdditionalTokenOption2Match = component.get("v.AdditionalTokenOption2Match");
					        	LoanDetailMatch = component.get("v.LoanDetailMatch");
					            compEvent.setParams({"CFCUWalletScoreObtained" : ScoreObtained,"CFCUWalletFailedCount" : FailedCount, "ActionType": 'CFCU Wallet'});
							    compEvent.fire();
							    if(ScoreObtained >= 3 && FailedCount <= 1)
						  			status = "Pass";
						        else
						            status = "Fail";
						  		var action = component.get("c.CFCUWalletSaveLogData");
						  		var GUID = component.get("v.GUID");
						  		var IVRGUIDFromUrl = component.get("v.IVRGUIDFromUrl");
						  		action.setParams({"MemberId": memberId,
						  						   "Status": status,
						  						   "GUID" : GUID,
						  						   "BeneficiaryDetailMatch": BeneficiaryDetailMatch,
						  						   "JointOwnerDetailMatch": JointOwnerDetailMatch,
						  						   "CardNumberMatch": CardNumberMatch,
						  						   "AdditionalTokenOption1Match": AdditionalTokenOption1Match,
						  						   "AdditionalTokenOption2Match":AdditionalTokenOption2Match,
						  						   "LoanDetailMatch": LoanDetailMatch,
						  						   "IVRGUIDFromUrl" : IVRGUIDFromUrl});
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
							   	component.set("v.IsButtonDisabled",true);
							   //	component.set("v.CFCUWalletStatusForDay",false);
						   	}
						   	
						  
					   	
		        }
		}
 		 
	},
	 buttonOnLoad : function(component, event, helper){
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
	 },
	
	
})