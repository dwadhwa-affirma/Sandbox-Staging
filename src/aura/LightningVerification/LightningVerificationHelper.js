({
	doInit : function(component, event,helper) {
	
		// URL Encoding........................................................................................
		
		var url= window.location.href;
		var pageReference = component.get("v.pageReference");
	
		if(pageReference.state.c__EnteredSSN == 'null'){
			component.set("v.SSNFromURL", '');
		}
		else{
			component.set("v.SSNFromURL", pageReference.state.c__EnteredSSN);
		}
		if(pageReference.state.c__EnteredMemberNumber == 'null'){
			component.set("v.MemberNumberFromURL", '');
		}
		else{
			component.set("v.MemberNumberFromURL", pageReference.state.c__EnteredMemberNumber);
		}
		if(pageReference.state.c__CallersPhoneNumber == 'null')
		{
			component.set("v.PhoneFromURL", '');
		}else{
			component.set("v.PhoneFromURL", pageReference.state.c__CallersPhoneNumber);
		}
		if(pageReference.state.c__PINMatch != undefined && pageReference.state.c__PINMatch.toLowerCase() == 'null'){
			component.set("v.DebitCardStatus", '');
		}else if(pageReference.state.c__PINMatch != undefined ){		
			component.set("v.DebitCardStatus", pageReference.state.c__PINMatch.toLowerCase());
		}
		if(pageReference.state.c__InteractionId == 'null' || pageReference.state.c__InteractionId == undefined){
		
			component.set("v.IVRGUIDFromUrl", '');
			component.set("v.IsMemberManualSearched",true);
		}else{
			component.set("v.IVRGUIDFromUrl", pageReference.state.c__InteractionId);
			component.set("v.IsMemberManualSearched",false);
		}
		if(pageReference.state.c__Reason == 'null' || pageReference.state.c__Reason == undefined || pageReference.state.c__Reason == '')
		{
			component.set("v.ReasonCodeFromURL", 'Unknown');
		}else{
			component.set("v.ReasonCodeFromURL", pageReference.state.c__Reason);
		}
		if(pageReference.state.c__HighValueFlag == 'null' || pageReference.state.c__HighValueFlag == undefined)
		{
			component.set("v.HighFlagFromUrl", '');
			
		}else if(pageReference.state.c__HighValueFlag == '1'){
		
			component.set("v.HighFlagFromUrl", 'HV');
			
		}else if(pageReference.state.c__HighValueFlag == '2'){
		
			component.set("v.HighFlagFromUrl", 'HP');
		}
		if(pageReference.state.c__PINMatch != undefined){
			var PINMatchFromURL = pageReference.state.c__PINMatch.toLowerCase();
		}
		var SSNFromURL = component.get("v.SSNFromURL");
		var MemberNumberFromURL =  component.get("v.AccountNumberFromURL");
		var PhoneFromURL =  component.get("v.PhoneFromURL");
		var IVRGUIDFromUrl =  component.get("v.IVRGUIDFromUrl");
		
		if(SSNFromURL != undefined || MemberNumberFromURL != undefined || PhoneFromURL != undefined){
			component.set("v.PageURL", url);
		}
		 if(SSNFromURL != undefined || MemberNumberFromURL != undefined || PhoneFromURL != undefined){
			component.set("v.PageURL", url);
		}
		if(SSNFromURL!= undefined && (SSNFromURL == "" || SSNFromURL == null || SSNFromURL == 'null'))
		{
			component.set("v.IsOOWTabVisible", false);
			component.set("v.IsOOWAvailableOnLoad", false);
		}
		else
		{
			component.set("v.IsOOWTabVisible", true);
		}
		
		if(PINMatchFromURL!= undefined &&(PINMatchFromURL == "" || PINMatchFromURL == null || PINMatchFromURL == 'null' ))
		{
			component.set("v.IsDebitTabVisible", false);
		}
		else if(PINMatchFromURL== undefined){
			component.set("v.IsDebitTabVisible", false);			
		}
		else
		{
			component.set("v.IsDebitTabVisible", true);
		}
		if(pageReference.state.c__IsUserSessionLoaded != undefined && pageReference.state.c__IsUserSessionLoaded =='true')
		{
			component.set("v.IsUserSessionLoaded", true );
			
		}else{
			component.set("v.IsUserSessionLoaded", false );
		}
	    component.set("v.EnteredCardNumber", pageReference.state.c__EnteredCardNumber);
	    component.set("v.CardNumberMatch", pageReference.state.c__CardNumberMatch);
		component.set("v.PhoneNumberMatch", pageReference.state.c__PhoneNumberMatch);
		component.set("v.MemberNumberMatch", pageReference.state.c__MemberNumberMatch);       
		component.set("v.SSNnumberMatch", pageReference.state.c__SSNnumberMatch); 
		component.set("v.PINMatch", pageReference.state.c__PINMatch);   
		 
		// URL Encoding........................................................................................
		
		component.set("v.IsRightDivVisible", false);
		var MemberIdFromHomePage = component.get("v.MemberIdFromHomePage");
		var IspageOpenFromHomePage = component.get("v.IspageOpenFromHomePage");
		var AccountNumberFromHomePage = component.get("v.AccountNumberFromHomePage");
	
		
		if(IspageOpenFromHomePage){
				var len = AccountNumberFromHomePage.length;
				var MemberNumber = AccountNumberFromHomePage;
				
				if(AccountNumberFromHomePage.length < 10)
				{
					for(var i=0;i<10-parseInt(len); i++)
	                     {
	                         MemberNumber = '0'+MemberNumber;
	                         
	                     } 
					
				}
				component.set("v.AccountNumberFromHomePage", MemberNumber);
				
				helper.getMemberSearch(component, event,'',MemberNumber,'',IVRGUIDFromUrl );
		}
		
		
		    var DebitCardStatus = component.get("v.DebitCardStatus");
		
			if(DebitCardStatus == 'true' || DebitCardStatus == 'false'){
				component.set("v.IsCFCUSectionVisible",false);
				
			}
			else{
				component.set("v.IsCFCUSectionVisible",true);
				
			}
			
			
			
			
					
	},
	
	LastAcheivableLogs : function(component, event, memberid, GUID, LastLevel, IVRGUIDFromUrl)
	{
		var PhoneFromURL = component.get("v.PhoneFromURL");
		var MemberNumberFromURL = component.get("v.MemberNumberFromURL");
		var EnteredCardNumber = component.get("v.EnteredCardNumber");
		var CardNumberMatch = component.get("v.CardNumberMatch");
		var PhoneNumberMatch = component.get("v.PhoneNumberMatch");
		var MemberNumberMatch = component.get("v.MemberNumberMatch"); 
		var SSNnumberMatch = component.get("v.SSNnumberMatch");   
		var HighFlagFromUrl = component.get("v.HighFlagFromUrl");
		var ReasonCodeFromURL = component.get("v.ReasonCodeFromURL");
		var PINMatch = component.get("v.PINMatch"); 
		var SSNFromURL = component.get("v.SSNFromURL");
		var DebitCardStatus = component.get("v.DebitCardStatus");
		
		var action = component.get("c.SaveLastAchievableLevelLogs");
		action.setParams({"MemberId": memberid, "GUID" : GUID, "LastLevel": LastLevel,"IVRGUIDFromUrl":IVRGUIDFromUrl, 
						"PhoneFromURL": PhoneFromURL, "MemberNumberFromURL" : MemberNumberFromURL, "EnteredCardNumber": EnteredCardNumber,"CardNumberMatch":CardNumberMatch,
						"PhoneNumberMatch": PhoneNumberMatch, "MemberNumberMatch" : MemberNumberMatch, "SSNnumberMatch": SSNnumberMatch,"HighFlagFromUrl":HighFlagFromUrl,
						"ReasonCodeFromURL": ReasonCodeFromURL, "PINMatch" : PINMatch, "SSNFromURL": SSNFromURL,"DebitCardStatus":DebitCardStatus});
						
		action.setCallback(this, function (response) {
  		 var status = response.getState();            
               if (component.isValid() && status === "SUCCESS") {
                   var result = response.getReturnValue();
                 }	
			});
   
    	$A.enqueueAction(action);
	},
	
	MemberVerificationAttemptCheck : function(component, event, helper, memberid, DebitCardStatus,ReLoadRequired, PointsObtained)
	{
		
		var GUID = component.get("v.GUID");
		var IVRGUIDFromUrl = component.get("v.IVRGUIDFromUrl");
		if(IVRGUIDFromUrl =='' || IVRGUIDFromUrl == undefined )
		{
			component.set("v.IVRGUIDFromUrl",GUID);
			IVRGUIDFromUrl = GUID;
		}
		var action = component.get("c.MemberVerificationAttemptsCheck");
		
		if(ReLoadRequired == undefined){
			ReLoadRequired = false;
		}
		
		var SSNFromURL = component.get("v.SSNFromURL");
		var MemberNumberFromURL = component.get("v.MemberNumberFromURL");
		var PhoneFromURL = component.get("v.PhoneFromURL");
		var PageURL = component.get("v.PageURL");
		var DebitCardStatus = component.get("v.DebitCardStatus");
		var ReasonCodeFromURL = component.get("v.ReasonCodeFromURL");
		var HighFlagFromUrl = component.get("v.HighFlagFromUrl");
		var EnteredCardNumber = component.get("v.EnteredCardNumber");
	    var CardNumberMatch = component.get("v.CardNumberMatch");
		var PhoneNumberMatch = component.get("v.PhoneNumberMatch");
		var MemberNumberMatch = component.get("v.MemberNumberMatch");       
		var SSNnumberMatch = component.get("v.SSNnumberMatch");   
		var PINMatch = component.get("v.PINMatch"); 
		var SSNSearched = component.get("v.SSNEntered");
		var PhoneSearched = component.get("v.PhoneNumberEntered");
		var MemberSearched = component.get("v.MemberNumberEntered");
		if(PageURL == undefined){
			component.set("v.IsDebitTabVisible", false);
			action.setParams({"MemberId": memberid,"GUID": GUID,"DebitCardStatus": DebitCardStatus,"SSNFromURL": SSNSearched,"MemberNumberFromURL": MemberSearched,"PhoneFromURL": PhoneSearched, "PageURL" : ' ', "IVRGUIDFromUrl": IVRGUIDFromUrl,
								"ReLoadRequired": ReLoadRequired, "ReasonCodeFromURL": ReasonCodeFromURL,"HighFlagFromUrl":HighFlagFromUrl, "PointsObtained":PointsObtained, 
								"IsOOWTabVisible": component.get("v.IsOOWTabVisible"), "IsUserSessionLoaded": component.get("v.IsUserSessionLoaded"),
								"EnteredCardNumber": ' ', "CardNumberMatch": ' ', "PhoneNumberMatch": ' ', "MemberNumberMatch" : ' ', "SSNnumberMatch" : ' ', "PINMatch" : ' '});
		}
		else{
			action.setParams({"MemberId": memberid,"GUID": GUID,"DebitCardStatus": DebitCardStatus,"SSNFromURL": SSNFromURL,"MemberNumberFromURL":MemberNumberFromURL,
								"PhoneFromURL":PhoneFromURL,"PageURL":PageURL, "IVRGUIDFromUrl": IVRGUIDFromUrl,"ReLoadRequired":ReLoadRequired,"ReasonCodeFromURL": ReasonCodeFromURL,
								"HighFlagFromUrl":HighFlagFromUrl, "PointsObtained":PointsObtained,  "IsOOWTabVisible": component.get("v.IsOOWTabVisible"), "IsUserSessionLoaded": component.get("v.IsUserSessionLoaded"),
								"EnteredCardNumber": EnteredCardNumber, "CardNumberMatch":CardNumberMatch, "PhoneNumberMatch": PhoneNumberMatch, "MemberNumberMatch" : MemberNumberMatch, "SSNnumberMatch" : SSNnumberMatch,"PINMatch":PINMatch
								 });
    	}
    	action.setCallback(this, function (response) {
  		 var status = response.getState();            
               if (component.isValid() && status === "SUCCESS") {
                   var result = response.getReturnValue();
                        var ScoringModelLength = result['ScoringModel'].length;	
                    	component.set("v.Visible", result['Visible']);
                    	component.set("v.Attempts", result['Attempts']);
                    	component.set("v.CFCUWalletStatusForDay",result['CFCUWalletStatusForDay']);
                    	component.set("v.PublicWalletStatusForDay",result['PublicWalletStatusForDay']);
                    	component.set("v.OTPStatusForDay",result.IsOTPAvailable);
                    	component.set("v.OOWStatusForDay",result['OOWStatusForDay']);
                    	component.set("v.ShowFailedDesiredLevel",true);
                    	component.set("v.ShowFailedDesiredLevelCount",result['Show Failed Desired Level']);
                    	component.set("v.AccountNumber", result['AccountNumber']);
                    	component.set("v.OTPCancellAttept",result.OTPAttemptCount);
                    	component.set("v.ToGetHighestLevel",result.ToGetHighestLevel);
                    	component.set("v.MaximumPointsAvailable",result.MaximumPointsAvailable);	                    	
                    	component.set("v.HighestAchievableLevel", result.HighestAchievableLevel);
                    	component.set("v.IsKYMAvailableOnLoad",result.IsKYMAvailable);
					    //component.set("v.IsOTPAvailableOnLoad",result.IsOTPAvailable);
					    component.set("v.IsDebitPinAvailable",result.IsDebitPinAvailable);
					   // component.set("v.IsOOWAvailableOnLoad",result.IsOOWAvailable);
					   // component.set("v.IsPublicWalletAvailableOnLoad",result.IsPublicWalletAvailable);
					   // component.set("v.IsCFCUWalletAvailableOnLoad",result.IsCFCUWalletAvailable);
					    component.set("v.IsOTPAvailableOnLoad",result['OTPStatusForDay']);
					   // component.set("v.IsOOWAvailableOnLoad",result['OOWStatusForDay']);
					    component.set("v.IsPublicWalletAvailableOnLoad",result['PublicWalletStatusForDay']);
					    component.set("v.IsCFCUWalletAvailableOnLoad",result['CFCUWalletStatusForDay']);
					    component.set("v.LastAchievable30day",result.LastAchievableLevel);
					    component.set("v.Membertype",result.MemberType);
					    component.set("v.isPINChange",result.PINChange);
					    component.set("v.isFDLogPreviousDay",result.FDLogPreviousDay);
					    component.set("v.PublicWalletColor", result.PWColor);
					    component.set("v.CFCUWalletColor", result.CWColor);
					    component.set("v.OOWColor", result.OOWColor);
					    component.set("v.OTPColor", result.OTPColor);
					    //component.set("v.CurrentAuthenticationLevel", result.LastAchievableLevel);
					    component.set("v.NextTabLevel2", result.NextTabLevel2);
					    component.set("v.NextTabLevel3", result.NextTabLevel3);
					    component.set("v.IsLevel1Achieved", result.IsLevel1Achieved); 
	                    component.set("v.IsLevel2Achieved", result.IsLevel2Achieved); 
	                    component.set("v.IsLevel3Achieved", result.IsLevel3Achieved); 
	                    component.set("v.MultipleMemberNumberAlert",result.MultipleMemberNumberAlert);
					    if(result['OOWStatusForDay'] == false)
					    {
					    	component.set("v.Likedisable", true);
					    }
					    else{
					    	component.set("v.Likedisable", false);
					    }
					    					    
					    if(result.MemberType == 'Foreign')
					    {
					    	component.set("v.IsOOWTabVisible", false);
					    }
					    else
					    {
					    	component.set("v.IsOOWTabVisible", true);
					    }
					   if(component.get("v.IsOOWTabVisible") == true)
					   {
						  //  if(SSNFromURL!= undefined && SSNFromURL != "" && SSNFromURL != null && SSNFromURL != 'null' )
						  //  {
						    	 if(result.MemberType == 'Foreign'){
						    		 component.set("v.IsOOWAvailableOnLoad", false);
						    	 }
						    	 else if(result.MemberType == 'Domestic')
						    	 {
						    		 component.set("v.IsOOWAvailableOnLoad", true);
						    	 }
						   // }
					    }
					    else{
					    	component.set("v.IsOOWAvailableOnLoad", false);
					    }
					    
					    var ProgressBarStep2 = document.getElementById('Step2');
                        var Level2IndicatorLabel =  document.getElementById('Level2IndicatorLabel');
                        
                        if(result.IsLevel2Achieved == true && result.NextTabLevel2 == 'Level Reached')
                        {
                        	ProgressBarStep2.classList.add('active');
                        	Level2IndicatorLabel.classList.add('hidden');
                        	Level2IndicatorLabel.classList.remove('show');
                        	component.set("v.CurrentAuthenticationLevel", 'Level 2');
                        }
                        else if(result.IsLevel2Achieved == false && result.NextTabLevel2 == 'Not Achievable' )
                        {
                        	ProgressBarStep2.classList.add('three');
                        	Level2IndicatorLabel.classList.add('hidden');
                        	Level2IndicatorLabel.classList.remove('show');
                        }
                       
                        else 
                        {
                        	ProgressBarStep2.classList.remove('three');
                        	ProgressBarStep2.classList.remove('active');
                        	ProgressBarStep2.classList.add('two');
                        	
                        }
                      
                        var ProgressBarStep3 = document.getElementById('Step3');
                        var Level3IndicatorLabel =  document.getElementById('Level3IndicatorLabel');
                        if(result.IsLevel3Achieved == true && result.NextTabLevel3 == 'Level Reached')
                        {
                        	ProgressBarStep3.classList.add('active');
                        	Level3IndicatorLabel.classList.add('hidden');
                        	Level3IndicatorLabel.classList.remove('show');
                        	component.set("v.CurrentAuthenticationLevel", 'Level 3');
                        }
                        else if(result.IsLevel3Achieved == false && result.NextTabLevel3 == 'Not Achievable')
                        {
                        	ProgressBarStep3.classList.add('three');
                        	Level3IndicatorLabel.classList.add('hidden');
                        	Level3IndicatorLabel.classList.remove('show');
                        }
                        
                        else 
                        {
                        	ProgressBarStep3.classList.remove('three');
                        	ProgressBarStep3.classList.remove('active');
                        	ProgressBarStep3.classList.add('two');
                        	
                        }
					    
		     		    if(result.OTPAttemptCount > 0){
                		}
                		
                		if(ScoringModelLength > 0){
					    		component.set("v.ScoringModel", result['ScoringModel']);
							}
							else{
									component.set("v.ScoringModel",null);						
							}
							
							if(result['LevelModel'].length > 0){
								component.set("v.LevelModel", result['LevelModel']);
							}
							else{
								component.set("v.LevelModel",null);	
							}
						
						document.getElementById('frmMemberNumber').value = result['AccountNumber']; 
						component.set("v.isDoneRendering",true);
	              	
                  }
                	
			});	
   
    	$A.enqueueAction(action); 	
    	
    },
	
    GetFailedDesiredLevelLog : function(component, event, memberid)
	{
		
		var action = component.get("c.GetFailedDesiredLevelLog");
		action.setParams({"MemberId": memberid});
    	action.setCallback(this, function (response) {
  		 var status = response.getState();            
               if (component.isValid() && status === "SUCCESS") {
                   var result = response.getReturnValue();
                    	
	                    	component.set("v.ShowFailedDesiredLevel",result.Visible);
	                    	
                    	component.set("v.ShowFailedDesiredLevelCount",result.Count);
	             }	
			   
			        		
                  
                	
			});
   
    	$A.enqueueAction(action); 
    	
    },
 
	getMemberSearch : function(component, event,PhoneNumber,MemberNumber,SSNNumber,IVRGUIDFromUrl)
	{
		  
		   var action = component.get("c.getMemberSearchData");
		   var parameters = {"PhoneNumber": PhoneNumber,"MemberNumber" : MemberNumber,"SSNNumber" : SSNNumber,"IVRGUIDFromUrl":IVRGUIDFromUrl, "IsUserSessionLoaded": component.get("v.IsUserSessionLoaded")};
		
		   action.setParams(parameters);
		   action.setCallback(this, function(response){
		   		var status = response.getState();
		    	if(component.isValid() && status === "SUCCESS"){
		    	
						var result =  response.getReturnValue();
				         component.set("v.GUID",result.GUID);
					    if(result.Account.length > 0){
						    
						    component.set("v.accounts", result['Account']);
					        component.set("v.IsMatchingMemberFound", true);
					    	
					    	}
						
						else{						
								component.set("v.IsMatchingMemberFound", false);
								component.set("v.PhoneNumberEntered","");
							    component.set("v.MemberNumberEntered","");
							    component.set("v.SSNEntered","");
							    component.set("v.accounts", null);
						}
						
						if(result.Profile.Name =='Branch'){
							component.set("v.IsKYMTabVisible", true);
						}
						else{
							
							component.set("v.IsKYMTabVisible", false);
						}
						
						   var IsMatchingMemberFound; 
						   IsMatchingMemberFound = component.get("v.IsMatchingMemberFound");
            		
	            	   if((MemberNumber !=undefined && MemberNumber !='') && IsMatchingMemberFound == false) {						   
	            			 	component.set("v.IsMemberNumberValid",false);
						    	var MemberNumberDiv = document.getElementById('MemberNoDiv');
						    	//MemberNumberDiv.className.replace("hidden"," ");
						    	MemberNumberDiv.firstChild.removeAttribute('class');
						  }
						  else if((MemberNumber !=undefined && MemberNumber !='') && IsMatchingMemberFound == true){						    
						    		component.set("v.IsMemberNumberValid",true);
						  		}
						 
						
                    	if((SSNNumber !=undefined && SSNNumber !='') && IsMatchingMemberFound == false) {						   
	            			 	component.set("v.IsMemberNumberValid",false);
						    	var MemberNumberDiv = document.getElementById('MemberNoDiv');
						    	//MemberNumberDiv.className.replace("hidden"," ");
						    	MemberNumberDiv.firstChild.removeAttribute('class');
						  }
						  else if((SSNNumber !=undefined && SSNNumber !='') && IsMatchingMemberFound == true){						    
						    		component.set("v.IsMemberNumberValid",true);
						  }
						
						component.set("v.ReLoadRequired", result.ReLoadRequired);
						if(result.ReLoadRequired == true){
							component.set("v.ReMemberId",result.AuthLog[0].SalesforceID__c);
						}
						if(result.ReLoadRequired == false && component.get("v.IsUserSessionLoaded")== true){
							component.set("v.ReMemberId",result.AuthLog[0].SalesforceID__c);
						}
						
						
		    	}            	
		});
		$A.enqueueAction(action);
		
		
		
    },
	
	GetActiveTabId: function (component, event) {
        var tab = event.getSource();
        var tabid = tab.get('v.id');
        var memberid = component.get("v.SelectedmemberId");
        component.set("v.ActiveTabId", tabid);
        component.set("v.ActiveTab", tab);
        var attribute1 = component.get('v.SelectedmemberId');
        var ReLoadRequired = component.get("v.ReLoadRequired");
        var IsUserSessionLoaded = component.get("v.IsUserSessionLoaded");
        var CFCUWalletComponent = component.find('CFCUWallet');
        var IsMemberManualSearched = component.get("v.IsMemberManualSearched");
        /*if(ReLoadRequired == undefined){
			ReLoadRequired = false;
		}*/
        if(tabid == 'CFCUWalletTab'){
        	//if(CFCUWalletComponent!=undefined)CFCUWalletComponent.CFCUWalletMethod(attribute1,ReLoadRequired, IsUserSessionLoaded, IsMemberManualSearched);
        }
        if(tabid == 'OTPTab'){
        var OTPComponent = component.find('OTPAuthentication');
        //if(OTPComponent!=undefined)OTPComponent.OTPMethod(attribute1,ReLoadRequired,IsUserSessionLoaded);
        }
    },
    
    GetAccountNumber : function (component, event, helper, memberid)
    {
    	var action = component.get("c.GetAccountNumber");
    		action.setParams({"accdetailid": memberid});  
		
    			action.setCallback(this, function (response) {
    			var status = response.getState();            
	       	    if (component.isValid() && status === "SUCCESS") {
	       	    	var result = response.getReturnValue(); 
                    
		               if(result.AccountNumber != undefined && result.AccountNumber.length > 0)
		               {
	                       var MemberName = result.MemberName;
                               component.set("v.AccountNumber",result.AccountNumber);
                               component.set("v.AccountId",result.AccountId);
                               
                       }
                 }
                 });
                 
            $A.enqueueAction(action); 
    },
    
    LoadOOWComponent: function (component, event, helper, memberid, GUID, IVRGUIDFromUrl) {
    	var win; 
    	var activetabid = component.get("v.ActiveTabId");
    	var tab =  component.get("v.ActiveTab");
    	var MaximumPointsAvailable = component.get("v.MaximumPointsAvailable");
		var IsKYMAvailable = component.get("v.IsKYMAvailableOnLoad");
	    var IsOTPAvailable = component.get("v.IsOTPAvailableOnLoad");
	    //var IsDebitPinAvailable = component.get("v.IsDebitPinAvailableOnLoad");
	    var DebitCardStatus = component.get("v.DebitCardStatus");
	    var IsOOWAvailable = component.get("v.OOWStatusForDay");
	    var IsPublicWalletAvailable = component.get("v.IsPublicWalletAvailableOnLoad");
	    var IsCFCUWalletAvailable =   component.get("v.IsCFCUWalletAvailableOnLoad");
		var MemberType = component.get("v.Membertype");
    	var scoringModel = component.get("v.ScoringModel");
    	var LevelModel = component.get("v.LevelModel");
    	var PointsObtained = component.get("v.PointObtained");
    	var CurrentAuthenticationLevel = component.get("v.CurrentAuthenticationLevel");
    	if(IVRGUIDFromUrl != undefined && IVRGUIDFromUrl !='')
    	{
    		//helper.GetScoreDataForReload (component, event, helper,memberid,IVRGUIDFromUrl );
    		MaximumPointsAvailable = component.get("v.MaximumPointsAvailable");
    		PointsObtained = component.get("v.PointObtained");
    		CurrentAuthenticationLevel= component.get("v.CurrentAuthenticationLevel");
    	}
    	
    	for(var i=0; i< LevelModel.length; i++)
    	{
	    	if(LevelModel[i].Tiers__c == component.get("v.HighestAchievableLevel")){
	    		
	    		 component.set("v.RangeStart",LevelModel[i].Range_Start__c	);
	             component.set("v.RangeEnd",scoringModel[i].Range_End__c);
	    	}
    	}
    	
    	for(var i=0; i< scoringModel.length; i++)
    	{
	    	if(scoringModel[i].Authentication_Type__c == 'OOW'){
	    		
	    		 component.set("v.ScoreModelNegativeScore",scoringModel[i].Negative_Point_Value__c);
	             component.set("v.ScoreModelPositiveScore",scoringModel[i].Positive_Point_Value__c);
	    	}
    	}
    	var ScoreModelNegativeScore = component.get("v.ScoreModelNegativeScore");
    	var ScoreModelPositiveScore = component.get("v.ScoreModelPositiveScore");
    	
		
    	if(activetabid == 'OOWTab'){
    		
    		var Error;
    		var element = document.getElementById('oowComponentdiv');
    		element.removeAttribute('class');
    		
    		var IsMemberNumberValid = component.get("v.IsMemberNumberValid");
    	
    		var action = component.get("c.GetAccountNumber");
    		action.setParams({"accdetailid": memberid});  
		
    			action.setCallback(this, function (response) {
    			var status = response.getState(); 
    			          
	       	    if (component.isValid() && status === "SUCCESS") {
	       	    	var result = response.getReturnValue(); 
                    
		               if(result.AccountNumber !=undefined)
		               {
			               if(result.AccountNumber.length > 0)
			               {
		                       var MemberName = result.MemberName;
		                       var AccountNumber = result.AccountNumber;
		                       var Source = '';
		                       
		                       if(IsMemberNumberValid == true){
		                    	   AccountNumber = component.get("v.MemberNumberEntered");
                                   if(AccountNumber == undefined){
                                       AccountNumber = component.get("v.MemberNumberFromURL");
                                   }
		                    	   	Source = "&source=member";
		                       }
    		
	                           component.set("v.AccountNumber",result.AccountNumber);
	                                                          
	                           win = window.open(result.FlowURL+"&accountnumber=" + AccountNumber + "&firstname=allow" + MemberName + Source);
		                       window.onmessage = function (e) {
							
		                      	 var output;
	                                                                   
	                               		if(e.origin == 'https://flow.boomi.com' )
	                                    {
	                                        output = e.data;
	                                        var match = output.split(';')
	                                        var status = match[0];
	                                        var reason = match[1];
	                                        var notes = match[2];
	                                        var name = match[3];
	                                        Error = match[4];
	                                    }
		                       
		                        if(notes == 'null')  
		                        {
		                            notes = '';
		                        }
		                        var action1 = component.get("c.SaveOOWLogData");
		  		   					
		   	      				 var membernumber = result.AccountNumber;
		                          action1.setParams({"status": status, "MemberNumber": membernumber,"MemberId":memberid, "reason":reason,"notes":notes, "GUID": GUID,"name": name,"Error":Error, "IVRGUIDFromUrl":IVRGUIDFromUrl});
		          				 action1.setCallback(this, function (response) {
			       	      		 var status1 = response.getState();            
		                               if (component.isValid() && status1 === "SUCCESS") {
		                            
		                                   var result1 = response.getReturnValue();
		                            
		                            
		                                }
		   	       				});	
		   	       
		   	      					 $A.enqueueAction(action1);  
		                          
		                          
		  						component.set("v.status", status);
		  						component.set("v.reason", reason);
		  						component.set("v.notes", notes);
		  						
		  						if(status == 'passed'){
		  						
		  							MaximumPointsAvailable = parseInt(MaximumPointsAvailable) - parseInt(ScoreModelPositiveScore);
		  							PointsObtained = parseInt(PointsObtained) + parseInt(ScoreModelPositiveScore);
		  							IsOOWAvailable = false;
		  							component.set("v.OOWStatusForDay", false);
									component.set("v.MaximumPointsAvailable",MaximumPointsAvailable);
		  							component.set("v.PointObtained", PointsObtained);
		  							helper.GetNextAuthenticationType(component, event, helper, memberid, MemberType, MaximumPointsAvailable, PointsObtained, IsKYMAvailable, IsOTPAvailable, DebitCardStatus, IsOOWAvailable, IsPublicWalletAvailable, IsCFCUWalletAvailable);
		  							component.set("v.Likedisable",true);
		  							
		  						}
		  						else if(status == 'failed'){
		  						
		  							MaximumPointsAvailable = parseInt(MaximumPointsAvailable) - parseInt(ScoreModelNegativeScore);
		  							IsOOWAvailable = false;
		  							component.set("v.OOWStatusForDay", false);
									component.set("v.MaximumPointsAvailable",MaximumPointsAvailable);
		  							component.set("v.PointObtained", PointsObtained);
		  							helper.GetNextAuthenticationType(component, event, helper, memberid, MemberType, MaximumPointsAvailable, PointsObtained, IsKYMAvailable, IsOTPAvailable, DebitCardStatus, IsOOWAvailable, IsPublicWalletAvailable, IsCFCUWalletAvailable);
		  							component.set("v.Likedisable",true);
		  						}
		  						
		  						component.set("v.MaximumPointsAvailable",MaximumPointsAvailable );
		  						component.set("v.PointsObtained",PointsObtained);
		  						 
		  						var element = document.getElementsByClassName('demo-only slds-box rightBox');
		  						var aElement;
		  						var liElement = element[2].getElementsByClassName("slds-tabs_default__item");
		  						
		  						
		  						for(var i=0 ; i < liElement.length; i++){
		  							aElement = liElement[i].firstElementChild;
				 
		  							
		  							if(status =='failed' && aElement.id =='OOWTab__item'){
		  								liElement[i].classList.add("red");
		  								liElement[i].classList.remove("slds-is-active");
		  								component.set('v.OOWIconName','utility:close');
		  							}
		  							
		  							if(status =='passed' && aElement.id =='OOWTab__item'){
		  								liElement[i].classList.add("green");
		  								liElement[i].classList.remove("slds-is-active");
		  								component.set('v.OOWIconName','utility:check');
		  							}
				
		  						}
		  						
								};  
	                       
	                        
	                      /*  setTimeout(function () { 
	                        			if(win.closed){
	                        				//if(component.get("v.status") == 'passed' && component.get("v.status") != 'failed' && (component.get("v.status") == 'Cancelled' && Error !=null))
	                        				if(component.get("v.status") == 'In Process')
	                        				{
	                        				
		                        				component.set("v.Likedisable", false);
		                        				component.set("v.status", 'Cancelled');
		                        				component.set("v.reason", 'Time out');
	                        				}
	                        			}
	                        			
	                        	}, 
	                        	
	                        	45000
	                        	
	                        	);
	                        */
	                        
			               }
		               }
	       	    
	       	    }
         
		});
		
		$A.enqueueAction(action);
    		
    		
    		
    	}
    //	component.set("v.Likedisable",true);
    	
    
    },
    
   
	  
    InsertLogData: function(component, event,helper, memberid, decision, FDL, OverrideType, OverrideSupervisor, GUID, IVRGUIDFromUrl)
    {
    	var PhoneNumber = component.get("v.PhoneNumberEntered");
    	var MemberNumber = component.get("v.MemberNumberEntered");
    	var SSNNumber = component.get("v.MemberNumberEntered"); 
    	var action = component.get("c.InsertLogData");
    	var ManagerCallbackComments = component.get("v.ManagerCallbackComments");
    	var PageUrl='';
    	action.setParams({"MemberId": memberid,"Decision":decision, "FDL": FDL, "PhoneNumber":PhoneNumber,"EnteredSSN":SSNNumber,"PageUrl":PageUrl, "OverrideType":OverrideType, "OverrideSupervisor":OverrideSupervisor,"ManagerCallbackComments" : ManagerCallbackComments, "GUID": GUID,"IVRGUIDFromUrl": IVRGUIDFromUrl });
    	 action.setCallback(this, function (response) {
		       	      		 var status = response.getState();            
	                               if (component.isValid() && status === "SUCCESS") {
	                            
	                                   var result = response.getReturnValue();
	                                  if(decision =='Failed Desired Level'){
	                                	  helper.GetFailedDesiredLevelLog(component,event,memberid);
	                                   }
	                                }
	   	       				});	
	   	       
	   	      					 $A.enqueueAction(action); 
	   	      				
    	 
    	
    },
    
    SaveCaseWithLogData: function(component, event, helper, memberid, accountnumber,CaseComment, AccountId, GUID, IVRGUIDFromUrl)
    {
    	var action = component.get("c.SaveCaseWithLogData");
    	action.setParams({"MemberId": memberid,"AccountNumber":accountnumber,"casecomment":CaseComment,"AccountId": AccountId,"GUID":GUID,"IVRGUIDFromUrl":IVRGUIDFromUrl});
    	 action.setCallback(this, function (response) {
		       	      		 var status = response.getState();            
	                               if (component.isValid() && status === "SUCCESS") {
	                            
	                                   var result = response.getReturnValue();
	                                  
	                                }
	   	       				});	
	   	       
	   	      					 $A.enqueueAction(action); 
    		
    },
    
    GetNextAuthenticationType: function(component, event, helper, MemberId, MemberType, MaximumPointsAvailable, PointsObtained , IsKYMAvailable, IsOTPAvailable, DebitCardStatus, IsOOWAvailable, IsPublicWalletAvailable, IsCFCUWalletAvailable){
    	var IVRGUIDFromUrl = component.get("v.IVRGUIDFromUrl");
    	if(IVRGUIDFromUrl == undefined){IVRGUIDFromUrl = '';}
    	var action = component.get("c.GetNextAuthenticationType");
    	action.setParams({"MemberId": MemberId,"MemberType":MemberType,"MaximumPointsAvailable":MaximumPointsAvailable,"PointsObtained": PointsObtained, "IsKYMAvailable": IsKYMAvailable, 
    						"IsOTPAvailable": IsOTPAvailable,"IsDebitPinAvailable":DebitCardStatus,"IsOOWAvailable":IsOOWAvailable,"IsPublicWalletAvailable": IsPublicWalletAvailable,"IsCFCUWalletAvailable": IsCFCUWalletAvailable,"IVRGUIDFromUrl":IVRGUIDFromUrl});
    	 action.setCallback(this, function (response) {
		       	      		 var status = response.getState();            
	                               if (component.isValid() && status === "SUCCESS") {
	                            
	                                   var result = response.getReturnValue();
	                                   if(PointsObtained < result.ScoreRequired){
	                                	   component.set("v.ToGetHighestLevel",result.NextLevel);
	                                   }else{
	                                	   component.set("v.ToGetHighestLevel",'Level Achieved');
	                                   }
	                                    component.set("v.NextTabLevel2", result.NextTabLevel2);
	                                    component.set("v.NextTabLevel3", result.NextTabLevel3); 
	                                    component.set("v.IsLevel2Achieved", result.IsLevel2Achieved); 
	                                    component.set("v.IsLevel3Achieved", result.IsLevel3Achieved); 
	                                   	component.set("v.HighestAchievableLevel", result.LevelofAuthentication);
	                                    
	                                    
	                                    
	                                    var ProgressBarStep2 = document.getElementById('Step2');
	                                    var Level2IndicatorLabel =  document.getElementById('Level2IndicatorLabel');
	                                    
	                                    if(result.IsLevel2Achieved == true && result.NextTabLevel2 == 'Level Reached')
	                                    {
	                                    	ProgressBarStep2.classList.add('active');
	                                    	Level2IndicatorLabel.classList.add('hidden');
	                                    	Level2IndicatorLabel.classList.remove('show');
	                                    	component.set("v.CurrentAuthenticationLevel", 'Level 2');
	                                    }
	                                    else if(result.IsLevel2Achieved == false && result.NextTabLevel2 == 'Not Achievable' )
	                                    {
	                                    	ProgressBarStep2.classList.add('three');
	                                    	Level2IndicatorLabel.classList.add('hidden');
	                                    	Level2IndicatorLabel.classList.remove('show');
	                                    }
	                                    else 
	                                    {
	                                    	ProgressBarStep2.classList.remove('three');
	                                    	ProgressBarStep2.classList.remove('active');
	                                    	ProgressBarStep2.classList.add('two');
	                                    	
	                                    }
	                                  
	                                    var ProgressBarStep3 = document.getElementById('Step3');
	                                    var Level3IndicatorLabel =  document.getElementById('Level3IndicatorLabel');
	                                    if(result.IsLevel3Achieved == true && result.NextTabLevel3 == 'Level Reached')
	                                    {
	                                    	ProgressBarStep3.classList.add('active');
	                                    	Level3IndicatorLabel.classList.add('hidden');
	                                    	Level3IndicatorLabel.classList.remove('show');
	                                    	component.set("v.CurrentAuthenticationLevel", 'Level 3');
	                                    }
	                                    else if(result.IsLevel3Achieved == false && result.NextTabLevel3 == 'Not Achievable')
	                                    {
	                                    	ProgressBarStep3.classList.add('three');
	                                    	Level3IndicatorLabel.classList.add('hidden');
	                                    	Level3IndicatorLabel.classList.remove('show');
	                                    }
	                                    else 
	                                    {
	                                    	ProgressBarStep3.classList.remove('three');
	                                    	ProgressBarStep3.classList.remove('active');
	                                    	ProgressBarStep3.classList.add('two');
	                                    	
	                                    }
	                                }
	   	       				});	
	   	       
	   	      					 $A.enqueueAction(action); 
    	
    },
    LoadSupervisor : function(component, event, helper){
    	var action = component.get("c.GetSupervisor");
    	action.setCallback(this, function (response) {
		       	      		 var status = response.getState();            
	                               if (component.isValid() && status === "SUCCESS") {
	                            
	                                   var result = response.getReturnValue();
	                                    component.set("v.Supervisor",result);
	                                }
	   	       				});	
	   	       
	   $A.enqueueAction(action); 
    },
	
	GetReloadData : function(component, event, helper,memberid,GUID,IVRGUIDFromUrl ){
	
		var DebitCardStatus = component.get("v.DebitCardStatus");
		var action = component.get("c.getDataForReload");
		action.setParams({"memberid": memberid,"GUID":GUID,"IVRGUIDFromUrl":IVRGUIDFromUrl,"DebitCardStatus" : DebitCardStatus, "IsUserSessionLoaded": component.get("v.IsUserSessionLoaded")});
    	action.setCallback(this, function (response) {
		       	      		 var status = response.getState();            
	                               if (component.isValid() && status === "SUCCESS") {
	                            
	                                   var result = response.getReturnValue();
	                                   if(result.OOWLogData !=undefined){	                                   
		                                   if(result.OOWLogData.length > 0){
		                                	   component.set("v.IsOOWAvailableOnLoad",true);
		                                	   component.set("v.status", result.OOWLogData[0].OOW_Status__c);
		                                	   component.set("v.reason", result.OOWLogData[0].OOW_Reason__c);
		                                	   component.set("v.notes", result.OOWLogData[0].OOW_Notes__c);
		                                	   var OOWSection = document.getElementById('oowComponentdiv');
		                                	   if(OOWSection !=undefined && OOWSection !=null )
												{
													OOWSection.removeAttribute('class')
													
												}
		                                	   
		                                   }
	                                   }
	                                   if(result.PublicLogData !=undefined){
	                                	   	if(result.PublicLogData.length > 0){
	                                	   		component.set("v.IsPublicWalletAvailableOnLoad",false);
	                                	   		if(result.PublicLogData[0].Public_Wallet_Status__c == 'Pass'){
	                                	   			var PublicWalletTab = document.getElementsByClassName('demo-only slds-box rightBox');
		                                	   			if(PublicWalletTab.length > 2)
															{
																var aElement;
																var liElement = PublicWalletTab[2].getElementsByClassName("slds-tabs_default__item");
																
																for(var i=0 ; i < liElement.length; i++)
																{
																	aElement = liElement[i].firstElementChild;
																	if(aElement.id =='PublicWalletTab__item'){
																		liElement[i].classList.add("green");
																		liElement[i].classList.remove("red");
															  			component.set('v.PWIconName','utility:check');
																	}
																}                               	   			
		                                	   			
															}
														}
													}
												}
	                                	   		if(result.CFCULogData !=undefined){
			                                	   	if(result.CFCULogData.length > 0){
			                                	   		component.set("v.IsCFCUWalletAvailableOnLoad", false);
			                                	   		if(result.CFCULogData[0].CFCU_Wallet_Status__c == 'Pass'){
			                                	   			var CFCUWalletTab = document.getElementsByClassName('demo-only slds-box rightBox');
				                                	   			if(CFCUWalletTab.length > 2)
																	{
																		var aElement;
																		var liElement = CFCUWalletTab[2].getElementsByClassName("slds-tabs_default__item");
																		
																		for(var i=0 ; i < liElement.length; i++)
																		{
																			aElement = liElement[i].firstElementChild;
																			if(aElement.id =='CFCUWalletTab__item'){
																				liElement[i].classList.add("green");
																				liElement[i].classList.remove("red");
																	  			component.set('v.CFCUIconName','utility:check');
																			}
																		}                               	   			
				                                	   			
																	}
																}
															}
	                                	   				}
	                                	   		if(result.OTPLogData !=undefined){
			                                	   	if(result.OTPLogData.length > 0){
			                                	   		component.set("v.IsOTPAvailableOnLoad", false);
			                                	   		if(result.OTPLogData[0].OTP_Status__c == 'Pass'){
			                                	   			var OTPTab = document.getElementsByClassName('demo-only slds-box rightBox');
				                                	   			if(OTPTab.length > 2)
																	{
																		var aElement;
																		var liElement = OTPTab[2].getElementsByClassName("slds-tabs_default__item");
																		
																		for(var i=0 ; i < liElement.length; i++)
																		{
																			aElement = liElement[i].firstElementChild;
																			if(aElement.id =='OTPTab__item'){
																				liElement[i].classList.add("green");
																				liElement[i].classList.remove("red");
																	  			component.set('v.OTPIconName','utility:check');
																			}
																		}                               	   			
				                                	   			
																	}
																}
															}
	                                	   				}
	                                	   	if(result.ScorePoints!= undefined){
			                                	   component.set("v.MaximumPointsAvailable",result.ScorePoints[0].Maximum_Points_Available__c);
			                                	   component.set("v.PointObtained",result.ScorePoints[0].Points_Obtained__c);
			                                	   component.set("v.CurrentAuthenticationLevel",result.ScorePoints[0].Current_Authentication_Level__c);
			                                	   component.set("v.HighestAchievableLevel",result.ScorePoints[0].Highest_Achievable_Level__c);
			                                	   component.set("v.ToGetHighestLevel",result.ScorePoints[0].Next_Level__c);
	                                	   		}
	                                	   		component.set("v.NextTabLevel2", result.NextTabLevel2);
	                                	   		component.set("v.NextTabLevel3", result.NextTabLevel3); 
	                                	   		component.set("v.IsLevel2Achieved", result.IsLevel2Achieved); 
	                                	   		var ProgressBarStep2 = document.getElementById('Step2');
			                                    var Level2IndicatorLabel =  document.getElementById('Level2IndicatorLabel');
			                                   
	                                            if(result.IsLevel2Achieved == true && result.NextTabLevel2 == 'Level Reached')
			                                    {
			                                    	ProgressBarStep2.classList.add('active');
			                                    	Level2IndicatorLabel.classList.add('hidden');
			                                    	Level2IndicatorLabel.classList.remove('show');
			                                    	component.set("v.CurrentAuthenticationLevel", 'Level 2');
			                                    }
			                                    else if(result.IsLevel2Achieved == false && result.NextTabLevel2 == 'Not Achievable' )
			                                    {
			                                    	ProgressBarStep2.classList.add('three');
			                                    	Level2IndicatorLabel.classList.add('hidden');
			                                    	Level2IndicatorLabel.classList.remove('show');
			                                    }
			                                    else 
			                                    {
			                                    	ProgressBarStep2.classList.remove('three');
			                                    	ProgressBarStep2.classList.remove('active');
			                                    	ProgressBarStep2.classList.add('two');
			                                    	
			                                    }
			                                  
			                                    var ProgressBarStep3 = document.getElementById('Step3');
			                                    var Level3IndicatorLabel =  document.getElementById('Level3IndicatorLabel');
			                                    if(result.IsLevel3Achieved == true && result.NextTabLevel3 == 'Level Reached')
			                                    {
			                                    	ProgressBarStep3.classList.add('active');
			                                    	Level3IndicatorLabel.classList.add('hidden');
			                                    	Level3IndicatorLabel.classList.remove('show');
			                                    	component.set("v.CurrentAuthenticationLevel", 'Level 3');
			                                    }
			                                    else if(result.IsLevel3Achieved == false && result.NextTabLevel3 == 'Not Achievable')
			                                    {
			                                    	ProgressBarStep3.classList.add('three');
			                                    	Level3IndicatorLabel.classList.add('hidden');
			                                    	Level3IndicatorLabel.classList.remove('show');
			                                    }
			                                    else 
			                                    {
			                                    	ProgressBarStep3.classList.remove('three');
			                                    	ProgressBarStep3.classList.remove('active');
			                                    	ProgressBarStep3.classList.add('two');
			                                    }
	                             }
	                                	   	
	                                   
	                                
	   	       		});	
	   	       
    	$A.enqueueAction(action); 
		
	},
	SaveFailedDesiredLevel: function(component, event, helper, memberid, FDLEventParam,GUID,IVRGUIDFromUrl){
		
		var action = component.get("c.SaveFailedDesiredLevelLog");
		action.setParams({"MemberId": memberid,"Decision": 'Failed Desired Level', "FDL":FDLEventParam, "GUID":GUID, "IVRGUIDFromUrl":IVRGUIDFromUrl });
		action.setCallback(this, function (response) {
		       	      		 var status = response.getState();            
	                               if (component.isValid() && status === "SUCCESS") {
	                            
	                                   var result = response.getReturnValue();                                  
	                                    helper.GetFailedDesiredLevelLog(component,event,memberid); 
	                                }
	   	       				});	
	   	       
			$A.enqueueAction(action); 
		
	}
	/*SaveScoreDataForReload : function(component, event, helper,memberid,IVRGUIDFromUrl, PointsObtained, MaximumPointsAvailable ){
		CurrentAuthenticationLevel = component.get("v.CurrentAuthenticationLevel");
		var action = component.get("c.SaveScoringDataForReload");
		action.setParams({"memberid": memberid,"IVRGUIDFromUrl":IVRGUIDFromUrl, "PointsObtained":PointsObtained, "MaximumPointsAvailable":MaximumPointsAvailable});
		action.setCallback(this, function (response) {
		       	      		 var status = response.getState();            
	                               if (component.isValid() && status === "SUCCESS") {
	                            
	                                   var result = response.getReturnValue();                                  
	                                    
	                                }
	   	       				});	
	   	       
	   $A.enqueueAction(action); 
	},
	*/
	
})