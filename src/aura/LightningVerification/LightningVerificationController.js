({
		doInit : function(component, event, helper) {
		component.set("v.CurrentAuthenticationLevel","Level 1");	
		helper.doInit(component, event,helper);
		var PhoneNumber = component.get("v.PhoneFromURL");
	    var MemberNumber = component.get("v.MemberNumberFromURL");
	    var SSNNumber = component.get("v.SSNFromURL");
	    var IVRGUIDFromUrl =  component.get("v.IVRGUIDFromUrl");
	    console.log('IVRGUIDFromUrl'+ IVRGUIDFromUrl);
	    helper.getMemberSearch(component, event,PhoneNumber,MemberNumber,SSNNumber,IVRGUIDFromUrl);
	    
		},
		
		/*LocationUpdate : function(component, event, helper) {
        var PhoneNumber = component.get("v.PhoneFromURL");
	    var MemberNumber = component.get("v.MemberNumberFromURL");
	    var SSNNumber = component.get("v.SSNFromURL");
	    var IVRGUIDFromUrl =  component.get("v.IVRGUIDFromUrl");
	    helper.getMemberSearch(component, event,PhoneNumber,MemberNumber,SSNNumber,IVRGUIDFromUrl);
		},
		*/
		onRender : function (component, event, helper) {
	         console.log('onRender called');
	        var memberid = component.get("v.ReMemberId");
	        var IVRGUIDFromUrl =  component.get("v.IVRGUIDFromUrl");
	        var GUID =  component.get("v.GUID");
	        var attribute1 = memberid;
	        var ReLoadRequired = component.get("v.ReLoadRequired");
	        var PointsObtained = component.get("v.PointObtained");
	        var IsUserSessionLoaded = component.get("v.IsUserSessionLoaded");
	        if(ReLoadRequired != undefined && (memberid != undefined && memberid != '') && component.get("v.IsReLoaded") ==false && IVRGUIDFromUrl != ''){
	        
	        	var element = document.getElementById(memberid);
	        	if(element != undefined)
	        		element.checked = true;
	        		
	        	component.set("v.IsRightDivVisible", true);
	        	var DebitCardStatus = component.get("v.DebitCardStatus");
				helper.MemberVerificationAttemptCheck(component, event, helper, memberid, DebitCardStatus, ReLoadRequired, PointsObtained);
				component.set("v.IsReLoaded", true);
				component.set("v.SelectedmemberId",memberid);
				
	        }
	        var IsGetReloadDataCalled = component.get("v.IsGetReloadDataCalled");
	        if(ReLoadRequired == true && (memberid != undefined && memberid != '')){	
	        	
	        	var PublicWalletComponent = component.find('PublicWallet');
		        if(PublicWalletComponent!=undefined)PublicWalletComponent.PublicWalletMethod(attribute1,ReLoadRequired,IsUserSessionLoaded);
		            
		        /*var CFCUWalletComponent = component.find('CFCUWallet');		        
		        if(CFCUWalletComponent!=undefined)CFCUWalletComponent.CFCUWalletMethod(attribute1,ReLoadRequired,IsUserSessionLoaded);
		        
		        var OTPComponent = component.find('OTPAuthentication');		        
		        if(OTPComponent!=undefined)OTPComponent.OTPMethod(attribute1,ReLoadRequired); */
		        if(IsGetReloadDataCalled == false ){      	            
		        	helper.GetReloadData(component, event, helper, memberid, GUID, IVRGUIDFromUrl);	
		        	component.set("v.IsGetReloadDataCalled", true);
		        }
		    }
		    if(IsUserSessionLoaded == true && (memberid != undefined && memberid != ''))
		    {
		    	var PublicWalletComponent = component.find('PublicWallet');
		        if(PublicWalletComponent!=undefined)PublicWalletComponent.PublicWalletMethod(attribute1,ReLoadRequired,IsUserSessionLoaded);
		            
		       var CFCUWalletComponent = component.find('CFCUWallet');		        
		        if(CFCUWalletComponent!=undefined)CFCUWalletComponent.CFCUWalletMethod(attribute1,ReLoadRequired, IsUserSessionLoaded);
		        
		         var OTPComponent = component.find('OTPAuthentication');		        
		        if(OTPComponent!=undefined)OTPComponent.OTPMethod(attribute1,ReLoadRequired); 
		        if(IsGetReloadDataCalled == false ){      	            
		        	helper.GetReloadData(component, event, helper, memberid, GUID, IVRGUIDFromUrl);	
		        	component.set("v.IsGetReloadDataCalled", true);
		        }
		    	
		    }
		    
		    
		},
		
			
		MemberCompEvent : function(component, event, helper){
		console.log('MemberCompEvent called');
		var IVRGUIDFromUrl = component.get("v.IVRGUIDFromUrl");
		var ReLoadRequired = component.get("v.ReLoadRequired");
		var MaximumPointsAvailable = component.get("v.MaximumPointsAvailable");
		var PointsObtained = component.get("v.PointObtained");
		var IsKYMAvailable = component.get("v.IsKYMAvailableOnLoad");
	    var IsOTPAvailable = component.get("v.IsOTPAvailableOnLoad");
	    //var IsDebitPinAvailable = component.get("v.IsDebitPinAvailableOnLoad");
	    var IsOOWAvailable;
	    if(component.get("v.IsOOWTabVisible") == true)
	    {
	    	IsOOWAvailable = component.get("v.OOWStatusForDay");
	    }
	    else if(component.get("v.IsOOWTabVisible") == false)
	    {
	    	IsOOWAvailable = false;
	    }
	  //  var IsOOWAvailable = component.get("v.IsOOWAvailableOnLoad"); 
	    var IsPublicWalletAvailable = component.get("v.IsPublicWalletAvailableOnLoad");
	    var IsCFCUWalletAvailable =   component.get("v.IsCFCUWalletAvailableOnLoad");
		var memberid = component.get("v.SelectedmemberId");
		var MemberType = component.get("v.Membertype");
		var KYMeventParam = event.getParam("KYMVarifiedStatus");
		var PublicWalletScore = event.getParam("PublicWalletScoreObtained");
		var PublicWalletFailedCount = event.getParam("PublicWalletFailedCount");
		var CFCUWalletScore = event.getParam("CFCUWalletScoreObtained");
		var CFCUWalletFailedCount = event.getParam("CFCUWalletFailedCount");
		var ActionType = event.getParam("ActionType");
		var eventParam = event.getParam("OTPVarifiedStatus");
        var scoringModel = component.get("v.ScoringModel");
        var LevelModel = component.get("v.LevelModel");
    	var LastLevel = component.get("v.HighestAchievableLevel");
    	var DebitCardStatus = component.get("v.DebitCardStatus");
    	var CurrentAuthenticationLevel = component.get("v.CurrentAuthenticationLevel");
    	var isPINChange = component.get("v.isPINChange");
    	var isFDLogPreviousDay = component.get("v.isFDLogPreviousDay");
    	var PINChangeNegativePoint =  parseInt(0);
    	var FDLogPreviousDayNegativePoint =  parseInt(0);
    	var isFDLogCalculated = component.get("v.isFDLogCalculated");
    	var isPinChangeCalculated = component.get("v.isPinChangeCalculated");
    	var FDLEventParam = event.getParam("FDLSelectedLevel");
    	var FDLShowPopup = event.getParam("FDLShowPopup");
    	var NegativeScoreObtained = component.get("v.NegativeScoreObtained");
    	var TotalScoreRequiredToAchieveLevel = component.get("v.TotalScoreRequiredToAchieveLevel");
    	var CurrentScore = component.get("v.CurrentScore");
    	/*var IsDebitPinAvailable;
	    if(DebitCardStatus =='true')
	    {	IsDebitPinAvailable = true;
	    }else if(DebitCardStatus =='false')
	    {
	    	IsDebitPinAvailable = false;
	    }*/
	    
	    
    	component.set("v.isFailedDesiredLevelModelOpen",FDLShowPopup);
    	for(var i=0; i< LevelModel.length; i++)
    	{
	    	if(LevelModel[i].Tiers__c == component.get("v.HighestAchievableLevel")){
	    		
	    		 component.set("v.RangeStart",LevelModel[i].Range_Start__c	);
	             component.set("v.RangeEnd",LevelModel[i].Range_End__c);
	    	}
	    	if(LevelModel[i].Tiers__c == component.get("v.CurrentAuthenticationLevel")){
	    		
	    		 component.set("v.CurrentLevelRangeStart",LevelModel[i].Range_Start__c	);
	             component.set("v.CurrentLevelRangeEnd", LevelModel[i].Range_End__c);
	    	}
    	}
    	var DebitPinPositivePoint;
    	var DebitPinNegativePoint;
    	for(var i=0; i< scoringModel.length; i++)
    	{
	    	if(scoringModel[i].Authentication_Type__c == ActionType){
	    		
	    		 component.set("v.ScoreModelNegativeScore",scoringModel[i].Negative_Point_Value__c);
	             component.set("v.ScoreModelPositiveScore",scoringModel[i].Positive_Point_Value__c);
	    	}
	    	if(scoringModel[i].Authentication_Type__c == 'Debit Pin')
	    	{
	    		DebitPinPositivePoint = scoringModel[i].Positive_Point_Value__c;
	    		DebitPinNegativePoint = scoringModel[i].Negative_Point_Value__c;
	    	}
	    	
	    	if(scoringModel[i].Authentication_Type__c == 'PIN Change' && isPINChange == true){
	    		
	    		PINChangeNegativePoint = scoringModel[i].Negative_Point_Value__c;
	    	}
	    	
	    	if(scoringModel[i].Authentication_Type__c == 'Failed Desired Level' && isFDLogPreviousDay == true){
	    		
	    		FDLogPreviousDayNegativePoint = scoringModel[i].Negative_Point_Value__c;
	    	}
	    	
    	}
    	
    	  	
    	var ScoreModelNegativeScore = component.get("v.ScoreModelNegativeScore");
    	var ScoreModelPositiveScore = component.get("v.ScoreModelPositiveScore");
    	var RangeStart = component.get("v.RangeStart");
    	var RangeEnd = component.get("v.RangeEnd");
    	var CurrentLevelRangeStart = component.get("v.CurrentLevelRangeStart");
    	var CurrentLevelRangeEnd = component.get("v.CurrentLevelRangeEnd");
		var element = document.getElementsByClassName('demo-only slds-box rightBox');
		var aElement;
		var liElement = element[2].getElementsByClassName("slds-tabs_default__item");
		var GUID = component.get("v.GUID");
		var OTPCancellAttept;
		var isDebitPinCalculated = component.get("v.isDebitPinCalculated");
		TotalScoreRequiredToAchieveLevel = RangeStart;
		console.log('Line 189---MaximumPointsAvailable' + MaximumPointsAvailable);
		console.log('Line 190---PointsObtained' + PointsObtained);
		console.log('Line 191---DebitCardStatus' + DebitCardStatus);
		console.log('Line 192---DebitCardStatus' + CurrentScore);
		console.log('Line 193---ScoreModelNegativeScore' + ScoreModelNegativeScore);
		console.log('Line 194---ScoreModelPositiveScore' + ScoreModelPositiveScore);
		console.log('Line 195---FDLogPreviousDayNegativePoint' + FDLogPreviousDayNegativePoint);
		console.log('Line 196---IVRGUIDFromUrl' + IVRGUIDFromUrl);
		
		//---------------------------For checking MC Pin Change and Failed desired level score -----------//
    	
    	
    	if(isFDLogCalculated == false && isFDLogPreviousDay == true )
		 {
			MaximumPointsAvailable = parseInt(MaximumPointsAvailable) - parseInt(FDLogPreviousDayNegativePoint);	
			component.set("v.isFDLogCalculated",true);
		 }
		/*if(isPinChangeCalculated == false && isPINChange == true )
		 {
			
			MaximumPointsAvailable = parseInt(MaximumPointsAvailable) - parseInt(PINChangeNegativePoint);
			component.set("v.isPinChangeCalculated",true);
		 }
    	    	*/
    	//---------------------------For checking MC Pin Change and Failed desired level score -----------//
		
		
		/*if(isDebitPinCalculated == false && DebitCardStatus == 'true' )
		 {
				 PointsObtained = parseInt(PointsObtained) + parseInt(DebitPinPositivePoint);
				  component.set("v.PointObtained",PointsObtained );
				  CurrentScore = parseInt(CurrentScore) +  parseInt(DebitPinPositivePoint);
				  MaximumPointsAvailable = parseInt(MaximumPointsAvailable) + parseInt(DebitPinPositivePoint);
				 component.set("v.isDebitPinCalculated",true);
		 }
		if(isDebitPinCalculated == false && DebitCardStatus == 'false' )
		 {
				 MaximumPointsAvailable = parseInt(MaximumPointsAvailable) - parseInt(DebitPinNegativePoint);
				 component.set("v.isDebitPinCalculated",true);
				 NegativeScoreObtained = parseInt(NegativeScoreObtained) + parseInt(DebitPinNegativePoint);
				 CurrentScore = parseInt(CurrentScore) -  parseInt(DebitPinNegativePoint);
				 TotalScoreRequiredToAchieveLevel = parseInt(TotalScoreRequiredToAchieveLevel) +  parseInt(NegativeScoreObtained);
		 }*/
		for(var i=0 ; i < liElement.length; i++)
		{
			 aElement = liElement[i].firstElementChild;
			 if(eventParam == "Cancelled" && aElement.id =='OTPTab__item'){			  
	  			component.set("v.IsOTPAvailableOnLoad",IsOTPAvailable);
	  			helper.GetNextAuthenticationType(component, event, helper, memberid, MemberType, MaximumPointsAvailable, PointsObtained, IsKYMAvailable, IsOTPAvailable, DebitCardStatus, IsOOWAvailable, IsPublicWalletAvailable, IsCFCUWalletAvailable);
			}
			if(eventParam == "Authenticated" && aElement.id =='OTPTab__item'){
				liElement[i].classList.add("green");
				component.set('v.OTPIconName','utility:check');
	  			PointsObtained = parseInt(PointsObtained) + parseInt(ScoreModelPositiveScore);
	  			CurrentScore = parseInt(CurrentScore) +  parseInt(ScoreModelPositiveScore);
	  			component.set("v.PointObtained",PointsObtained);
	  			IsOTPAvailable = false;
	  			component.set("v.IsOTPAvailableOnLoad",IsOTPAvailable);
	  			component.set("v.OTPStatusForDay",true);
	  			console.log('Line 248---PointsObtained' + PointsObtained);
	  			console.log('Line 249---CurrentScore' + CurrentScore);
	  			console.log('Line 250---ScoreModelPositiveScore' + ScoreModelPositiveScore);	  			
	  			helper.GetNextAuthenticationType(component, event, helper, memberid, MemberType, MaximumPointsAvailable, PointsObtained, IsKYMAvailable, IsOTPAvailable, DebitCardStatus, IsOOWAvailable, IsPublicWalletAvailable, IsCFCUWalletAvailable);
	  			helper.RedrawComponent(liElement[i]);
			}
			if(eventParam == "Valid" && aElement.id =='OTPTab__item'){
				liElement[i].classList.add("green");
				component.set('v.OTPIconName','utility:check');
	  			PointsObtained = parseInt(PointsObtained) + parseInt(ScoreModelPositiveScore);
	  			CurrentScore = parseInt(CurrentScore) +  parseInt(ScoreModelPositiveScore);
	  			component.set("v.PointObtained",PointsObtained);
	  			IsOTPAvailable = false;
	  			component.set("v.IsOTPAvailableOnLoad",IsOTPAvailable);
	  			component.set("v.OTPStatusForDay",true);
	  			console.log('Line 263---PointsObtained' + PointsObtained);
	  			console.log('Line 264---CurrentScore' + CurrentScore);
	  			console.log('Line 265---ScoreModelPositiveScore' + ScoreModelPositiveScore);	
	  			helper.GetNextAuthenticationType(component, event, helper, memberid, MemberType, MaximumPointsAvailable, PointsObtained, IsKYMAvailable, IsOTPAvailable, DebitCardStatus, IsOOWAvailable, IsPublicWalletAvailable, IsCFCUWalletAvailable);
	  			helper.RedrawComponent(liElement[i]);
			}
			if(eventParam == "Declined" && aElement.id =='OTPTab__item'){
				liElement[i].classList.add("red");
	  			component.set('v.OTPIconName','utility:close');	  			
	  			MaximumPointsAvailable = parseInt(MaximumPointsAvailable) - parseInt(ScoreModelNegativeScore);
	  			NegativeScoreObtained = parseInt(NegativeScoreObtained) + parseInt(ScoreModelNegativeScore);
	  			CurrentScore = parseInt(CurrentScore) -  parseInt(ScoreModelNegativeScore);
				TotalScoreRequiredToAchieveLevel = parseInt(TotalScoreRequiredToAchieveLevel) +  parseInt(NegativeScoreObtained);
	  			IsOTPAvailable = false;
	  			component.set("v.IsOTPAvailableOnLoad",IsOTPAvailable);
	  			console.log('Line 278---MaximumPointsAvailable' + MaximumPointsAvailable);
	  			console.log('Line 279---NegativeScoreObtained' + NegativeScoreObtained);
	  			console.log('Line 280---ScoreModelNegativeScore' + ScoreModelNegativeScore);
	  			console.log('Line 281---CurrentScore' + CurrentScore);	
	  			helper.GetNextAuthenticationType(component, event, helper, memberid, MemberType, MaximumPointsAvailable, PointsObtained, IsKYMAvailable, IsOTPAvailable, DebitCardStatus, IsOOWAvailable, IsPublicWalletAvailable, IsCFCUWalletAvailable);
	  			helper.RedrawComponent(liElement[i]);
			}
			if(eventParam == "Changed" && aElement.id =='OTPTab__item'){
				liElement[i].classList.add("red");
	  			component.set('v.OTPIconName','utility:close');
	  			MaximumPointsAvailable = parseInt(MaximumPointsAvailable) - parseInt(ScoreModelNegativeScore);
	  			NegativeScoreObtained = parseInt(NegativeScoreObtained) + parseInt(ScoreModelNegativeScore);
	  			CurrentScore = parseInt(CurrentScore) -  parseInt(ScoreModelNegativeScore);
				TotalScoreRequiredToAchieveLevel = parseInt(TotalScoreRequiredToAchieveLevel) +  parseInt(NegativeScoreObtained);
	  			IsOTPAvailable = false;
	  			component.set("v.IsOTPAvailableOnLoad",IsOTPAvailable);
	  			console.log('Line 294---MaximumPointsAvailable' + MaximumPointsAvailable);
	  			console.log('Line 295---NegativeScoreObtained' + NegativeScoreObtained);
	  			console.log('Line 296---ScoreModelNegativeScore' + ScoreModelNegativeScore);
	  			console.log('Line 297---CurrentScore' + CurrentScore);	
	  			helper.GetNextAuthenticationType(component, event, helper, memberid, MemberType, MaximumPointsAvailable, PointsObtained, IsKYMAvailable, IsOTPAvailable, DebitCardStatus, IsOOWAvailable, IsPublicWalletAvailable, IsCFCUWalletAvailable);
	  			helper.RedrawComponent(liElement[i]);
			}
			if(eventParam == "Invalid" && aElement.id =='OTPTab__item'){
				liElement[i].classList.add("red");
	  			component.set('v.OTPIconName','utility:close');	  			
	  			MaximumPointsAvailable = parseInt(MaximumPointsAvailable) - parseInt(ScoreModelNegativeScore);
	  			NegativeScoreObtained = parseInt(NegativeScoreObtained) + parseInt(ScoreModelNegativeScore);
	  			CurrentScore = parseInt(CurrentScore) -  parseInt(ScoreModelNegativeScore);
				TotalScoreRequiredToAchieveLevel = parseInt(TotalScoreRequiredToAchieveLevel) +  parseInt(NegativeScoreObtained);
	  			IsOTPAvailable = false;
	  			component.set("v.IsOTPAvailableOnLoad",IsOTPAvailable);
	  			console.log('Line 310---MaximumPointsAvailable' + MaximumPointsAvailable);
	  			console.log('Line 311---NegativeScoreObtained' + NegativeScoreObtained);
	  			console.log('Line 312---ScoreModelNegativeScore' + ScoreModelNegativeScore);
	  			console.log('Line 313---CurrentScore' + CurrentScore);	
	  			helper.GetNextAuthenticationType(component, event, helper, memberid, MemberType, MaximumPointsAvailable, PointsObtained, IsKYMAvailable, IsOTPAvailable, DebitCardStatus, IsOOWAvailable, IsPublicWalletAvailable, IsCFCUWalletAvailable);
	  			helper.RedrawComponent(liElement[i]);
	  			
			}
			if(KYMeventParam == "SUCCESS" && aElement.id =='KYMTab__item'){
			 
				liElement[i].classList.add("green");
	  			component.set('v.KYMIconName','utility:check');
	  			PointsObtained = parseInt(PointsObtained) + parseInt(ScoreModelPositiveScore);
	  			CurrentScore = parseInt(CurrentScore) +  parseInt(ScoreModelPositiveScore);
	  			component.set("v.PointObtained",PointsObtained);
	  			IsKYMAvailable = false;
	  			component.set("v.IsKYMAvailableOnLoad",IsKYMAvailable);
	  			helper.GetNextAuthenticationType(component, event, helper, memberid, MemberType, MaximumPointsAvailable, PointsObtained, IsKYMAvailable, IsOTPAvailable, DebitCardStatus, IsOOWAvailable, IsPublicWalletAvailable, IsCFCUWalletAvailable);
	  			helper.RedrawComponent(liElement[i]);
			 }
			 
			 if(KYMeventParam == "FAIL" && aElement.id =='KYMTab__item')
			 {
				 liElement[i].classList.add("red");
	  			 component.set('v.KYMIconName','utility:close');
	  			 MaximumPointsAvailable = parseInt(MaximumPointsAvailable) - parseInt(ScoreModelNegativeScore);
	  			 NegativeScoreObtained = parseInt(NegativeScoreObtained) + parseInt(ScoreModelNegativeScore);
	  			 CurrentScore = parseInt(CurrentScore) -  parseInt(ScoreModelNegativeScore);
				 TotalScoreRequiredToAchieveLevel = parseInt(TotalScoreRequiredToAchieveLevel) +  parseInt(NegativeScoreObtained);
	  			 IsKYMAvailable = false;
	  			 component.set("v.IsKYMAvailableOnLoad",IsKYMAvailable);
	  			 helper.GetNextAuthenticationType(component, event, helper, memberid, MemberType, MaximumPointsAvailable, PointsObtained, IsKYMAvailable, IsOTPAvailable, DebitCardStatus, IsOOWAvailable, IsPublicWalletAvailable, IsCFCUWalletAvailable);
	  			 helper.RedrawComponent(liElement[i]);
			 }
			 
			 
			 if(parseInt(PublicWalletScore) > 2 && parseInt(PublicWalletFailedCount) <= 1 && aElement.id =='PublicWalletTab__item')
			 {
				 	component.set("v.PublicWalletColor",'Green');
				 	liElement[i].classList.add("green");
				 	liElement[i].classList.remove("red");
				 	component.set('v.PWIconName','utility:check');
	  				PointsObtained = parseInt(PointsObtained) + parseInt(ScoreModelPositiveScore);
	  				CurrentScore = parseInt(CurrentScore) +  parseInt(ScoreModelPositiveScore);
	  				component.set("v.PointObtained",PointsObtained);
	  				IsPublicWalletAvailable = false;
	  				component.set("v.IsPublicWalletAvailableOnLoad",IsPublicWalletAvailable);
                 	component.set("v.PublicWalletStatusForDay", true);
                 	console.log('Line 358---PointsObtained' + PointsObtained);
                 	console.log('Line 359---CurrentScore' + CurrentScore);
                 	console.log('Line 360---ScoreModelPositiveScore' + ScoreModelPositiveScore);
	  				helper.GetNextAuthenticationType(component, event, helper, memberid, MemberType, MaximumPointsAvailable, PointsObtained, IsKYMAvailable, IsOTPAvailable, DebitCardStatus, IsOOWAvailable, IsPublicWalletAvailable, IsCFCUWalletAvailable);
	  				helper.RedrawComponent(liElement[i]);
			 }
			 if((parseInt(PublicWalletScore) <= 2 || parseInt(PublicWalletFailedCount) > 1) && aElement.id =='PublicWalletTab__item')
			 {
				 component.set("v.PublicWalletColor",'Red');
				 liElement[i].classList.add("red");
				 liElement[i].classList.remove("green");
	  			 component.set('v.PWIconName','utility:close');
	  			 MaximumPointsAvailable = parseInt(MaximumPointsAvailable) - parseInt(ScoreModelNegativeScore);
	  			 NegativeScoreObtained = parseInt(NegativeScoreObtained) + parseInt(ScoreModelNegativeScore);
	  			 CurrentScore = parseInt(CurrentScore) -  parseInt(ScoreModelNegativeScore);
				 TotalScoreRequiredToAchieveLevel = parseInt(TotalScoreRequiredToAchieveLevel) +  parseInt(NegativeScoreObtained);
	  			 IsPublicWalletAvailable = false;
	  			 component.set("v.IsPublicWalletAvailableOnLoad",IsPublicWalletAvailable);
	  			 console.log('Line 376---MaximumPointsAvailable' + MaximumPointsAvailable);
	  			 console.log('Line 377---NegativeScoreObtained' + NegativeScoreObtained);
	  			 console.log('Line 378---ScoreModelNegativeScore' + ScoreModelNegativeScore);
	  			 console.log('Line 379---CurrentScore' + CurrentScore);	
	  			 helper.GetNextAuthenticationType(component, event, helper, memberid, MemberType, MaximumPointsAvailable, PointsObtained, IsKYMAvailable, IsOTPAvailable, DebitCardStatus, IsOOWAvailable, IsPublicWalletAvailable, IsCFCUWalletAvailable);
	  			 helper.RedrawComponent(liElement[i]);
	  			 
			 }			 
			 if(parseInt(CFCUWalletScore) > 2 && parseInt(CFCUWalletFailedCount) <=1 && aElement.id =='CFCUWalletTab__item')
			 {
				 	liElement[i].classList.add("green");
				 	liElement[i].classList.remove("red");
	  				component.set('v.CFCUIconName','utility:check');
	  				PointsObtained = parseInt(PointsObtained) + parseInt(ScoreModelPositiveScore);
	  				CurrentScore = parseInt(CurrentScore) +  parseInt(ScoreModelPositiveScore);
	  				component.set("v.PointObtained",PointsObtained);
	  				IsCFCUWalletAvailable = false;
	  				component.set("v.IsCFCUWalletAvailableOnLoad",IsCFCUWalletAvailable);
	  				component.set("v.CFCUWalletStatusForDay", true);
	  				console.log('Line 394---PointsObtained' + PointsObtained);
                 	console.log('Line 395---CurrentScore' + CurrentScore);
                 	console.log('Line 396---ScoreModelPositiveScore' + ScoreModelPositiveScore);
	  				helper.GetNextAuthenticationType(component, event, helper, memberid, MemberType, MaximumPointsAvailable, PointsObtained, IsKYMAvailable, IsOTPAvailable, DebitCardStatus, IsOOWAvailable, IsPublicWalletAvailable, IsCFCUWalletAvailable);
	  				helper.RedrawComponent(liElement[i]);
			 }
			 if((parseInt(CFCUWalletScore) <= 2 || parseInt(CFCUWalletFailedCount) > 1 ) && aElement.id =='CFCUWalletTab__item')
			 {
				 liElement[i].classList.add("red");
				 liElement[i].classList.remove("green");
	  			 component.set('v.CFCUIconName','utility:close');
	  			 MaximumPointsAvailable = parseInt(MaximumPointsAvailable) - parseInt(ScoreModelNegativeScore);
	  			 NegativeScoreObtained = parseInt(NegativeScoreObtained) + parseInt(ScoreModelNegativeScore);
	  			 CurrentScore = parseInt(CurrentScore) -  parseInt(ScoreModelNegativeScore);
				 TotalScoreRequiredToAchieveLevel = parseInt(TotalScoreRequiredToAchieveLevel) +  parseInt(NegativeScoreObtained);
	  			 IsCFCUWalletAvailable = false;
	  			 component.set("v.IsCFCUWalletAvailableOnLoad",IsCFCUWalletAvailable);
	  			 console.log('Line 412---MaximumPointsAvailable' + MaximumPointsAvailable);
	  			 console.log('Line 413---NegativeScoreObtained' + NegativeScoreObtained);
	  			 console.log('Line 414---ScoreModelNegativeScore' + ScoreModelNegativeScore);
	  			 console.log('Line 415---CurrentScore' + CurrentScore);	
	  			 helper.GetNextAuthenticationType(component, event, helper, memberid, MemberType, MaximumPointsAvailable, PointsObtained, IsKYMAvailable, IsOTPAvailable, DebitCardStatus, IsOOWAvailable, IsPublicWalletAvailable, IsCFCUWalletAvailable);
	  			 helper.RedrawComponent(liElement[i]);
			 }
			 
			 
			
			 component.set("v.MaximumPointsAvailable", MaximumPointsAvailable);
			
		}
		if(FDLEventParam !=undefined)
		{
				 helper.SaveFailedDesiredLevel(component, event, helper, memberid, FDLEventParam,GUID,IVRGUIDFromUrl);
				
		}
		
		
	},
	
	
	
	searchMember: function(component, event, helper) {
		var value =  event.target.value;
		var id = event.target.id;
		if(id == 'frmPhoneNumber')
		{
			component.set("v.PhoneNumberEntered", value);
		}
		else if(id == 'frmMemberNumber')
		{
			var len = value.length;
			var finalstring = value;
			
			if(value.length < 10)
			{
				for(var i=0;i<10-parseInt(len); i++)
                     {
                         finalstring = '0'+finalstring;
                         
                     } 
				
			}
			component.set("v.MemberNumberEntered", finalstring);
            component.set("v.OOWMemberNumberEntered",finalstring);
			
			if(event.keyCode == 13){
				document.getElementById('frmMemberNumber').value= finalstring; 
			}
		}
		else if(id == 'frmSSN')
		{
			component.set("v.SSNEntered", value);
		}
		
	    if(event.keyCode == 13){
	    
		    var PhoneNumber = component.get("v.PhoneNumberEntered");
		    var MemberNumber = component.get("v.MemberNumberEntered");
		    var SSNNumber = component.get("v.SSNEntered");
		    
		    if(PhoneNumber != undefined && PhoneNumber != '')
		    {       
	    		    var str = PhoneNumber.replace(/-/g,'');
			        var strlength = str.length; 
			        var message = '';
			        
			       var PhoneNumberMessage = document.getElementById('PhoneNumberMessage'); 
			        
			        if(strlength != 10){
			        	 message = 'please enter correct 10 digit phone number';
			        	 PhoneNumberMessage.firstElementChild.innerText = message;
			        }
			        else
			        {		        
			        	var newPhone = str.slice(0,3) + '-' + str.slice(3,6) + '-' + str.slice(6,10);
			        	document.getElementById("frmPhoneNumber").value = newPhone;
			        	PhoneNumberMessage.firstElementChild.innerText = '';
				     }
		    }
		    
		    else if(SSNNumber!=undefined && SSNNumber == '7777' && SSNNumber!='')
	    	{
                alert('SSN 7777 can not be searched'); 
            }
           var IVRGUIDFromUrl =  component.get("v.IVRGUIDFromUrl");
           helper.getMemberSearch(component, event,PhoneNumber,MemberNumber,SSNNumber);
        }
   }, 
	
	handleRadioClick : function(component, event, helper){
		console.log('handleRadioClick called');
		component.set("v.IsRightDivVisible", true);
		var memberid = event.getSource().get('v.value');
		var membername = event.getSource().get('v.label');
		var MemberType = component.get("v.Membertype");
		var ReLoadRequired = component.get("v.ReLoadRequired");
		var PointsObtained = component.get("v.PointObtained");
		component.set("v.SelectedmemberId",memberid );
		component.set("v.SelectedmemberName",membername );
		var DebitCardStatus = component.get("v.DebitCardStatus");
		var attribute1 = component.get('v.SelectedmemberId');
		var PublicWalletComponent = component.find('PublicWallet');
		var IsUserSessionLoaded = component.get("v.IsUserSessionLoaded");
		/*if(ReLoadRequired == undefined){
			ReLoadRequired = false;
		}*/
		console.log('Line 520---PointsObtained' + PointsObtained);
		console.log('Line 521---DebitCardStatus' + DebitCardStatus);
	    if(PublicWalletComponent!=undefined){
        	PublicWalletComponent.PublicWalletMethod(attribute1,ReLoadRequired, IsUserSessionLoaded);
        }
        
        var CFCUWalletComponent = component.find('CFCUWallet');
        if(CFCUWalletComponent!=undefined)CFCUWalletComponent.CFCUWalletMethod(attribute1,ReLoadRequired, IsUserSessionLoaded);
        
        var OTPComponent = component.find('OTPAuthentication');
        if(OTPComponent!=undefined)OTPComponent.OTPMethod(attribute1,ReLoadRequired);
        console.log('Line 531---PointsObtained' + PointsObtained);
        console.log('Line 532---DebitCardStatus' + DebitCardStatus);
       helper.MemberVerificationAttemptCheck(component, event, helper, memberid, DebitCardStatus, ReLoadRequired, PointsObtained);
      
    
       
	},
	
	 handleActive: function (component, event, helper) {
        helper.GetActiveTabId(component, event);
    },
    
    OpenOOWComponent : function (component, event, helper) {
    	
    	var memberid = component.get("v.SelectedmemberId");
    	var GUID = component.get("v.GUID");
    	var IVRGUIDFromUrl = component.get("v.IVRGUIDFromUrl");
    	helper.LoadOOWComponent(component, event, helper, memberid, GUID, IVRGUIDFromUrl);
    	
    },
    
   openModel: function(component, event, helper) {
    	var memberid = component.get("v.SelectedmemberId");
    	if(memberid == undefined){
    		alert('Please search for member');
    	}
    	else{
    		component.set("v.isOpen", true);
    		component.set("v.overrideType", ' ');
    		helper.LoadSupervisor(component, event, helper);
		} 
    },
    
    closeModel: function(component, event, helper) {
    	component.set("v.isOpen", false);
    },
    
    onChange: function (component, event, helper) {
       var selectedoverrideType = event.getSource().get('v.value');
       component.set('v.overrideType',selectedoverrideType);
       var errorSpaninput = document.getElementById('errorSpaninput');
       var errorSpan = document.getElementById('errorSpan');
       component.find('Supervisor').set("v.value", 'Select');
       var element; 
       element = component.find("Supervisor");
       
       var elementOne;
       elementOne = component.find("ManagerComments");

       if(selectedoverrideType == 'Verbal'){       
			$A.util.addClass(element, 'show');
			$A.util.removeClass(element, 'hidden');
			errorSpaninput.classList.remove('show');
			errorSpaninput.classList.add('hidden');
			
			$A.util.removeClass(elementOne, 'show');
			$A.util.addClass(elementOne, 'hidden');
			errorSpaninputOne.classList.remove('show');
			errorSpaninputOne.classList.add('hidden');
			
		}
		else if(selectedoverrideType == 'Manager Callback'){ 
		
			$A.util.addClass(elementOne, 'show');
			$A.util.removeClass(elementOne, 'hidden');
			errorSpaninput.classList.remove('show');
			errorSpaninput.classList.add('hidden');
			
			$A.util.removeClass(element, 'show');
			$A.util.addClass(element, 'hidden');
			errorSpan.classList.remove('show');
			errorSpan.classList.add('hidden');
		
		}
		else{
			$A.util.removeClass(element, 'show');
			$A.util.addClass(element, 'hidden');
			errorSpaninput.classList.remove('show');
			errorSpaninput.classList.add('hidden');
			errorSpan.classList.remove('show');
			errorSpan.classList.add('hidden');
			
			$A.util.removeClass(elementOne, 'show');
			$A.util.addClass(elementOne, 'hidden');
			errorSpaninputOne.classList.remove('show');
			errorSpaninputOne.classList.add('hidden');
			
		}
    },   
    
    onChangeSupervior: function (component, event, helper) {
    	
    	var OverrideSupervisor = component.find('Supervisor').get('v.value');
    	var errorSpan = document.getElementById('errorSpan');
    	if(OverrideSupervisor != 'Select'){
    		errorSpan.classList.remove('show');
		    errorSpan.classList.add('hidden');
    	}
    },
     
    AuthenticatedLog : function(component,event, helper, decision)
    {
    	var decision;
    	var button = event.getSource().getLocalId();
    	var OverrideType;
    	var OverrideSupervisor;
    	var errorSpaninput;
    	var GUID = component.get("v.GUID");
    	var IVRGUIDFromUrl = component.get("v.IVRGUIDFromUrl");
    	var memberid = component.get("v.SelectedmemberId");
    	var FDL = '';
    	if(memberid == undefined){
    		alert('Please search for member');
    	}else{
		    	if(button == 'ViewHistory'){
		    	}
		    	
		    	else if(button == 'CreateCase'){
		    		component.set("v.AuthenticationDecision",'Authentication Failed');
		    		decision = component.get("v.AuthenticationDecision");
		    		helper.InsertLogData(component, event, helper, memberid, decision, FDL, OverrideType, OverrideSupervisor, GUID, IVRGUIDFromUrl);
		    	}
		    	else if(button == 'OverrideRequested'){
		    		component.set("v.AuthenticationDecision",'Override Requested');
		    		errorSpaninput = document.getElementById('errorSpaninput');
		    		errorSpan = document.getElementById('errorSpan');
		    		decision = component.get("v.AuthenticationDecision");
		    		OverrideSupervisor = component.find('Supervisor').get('v.value');
		    		OverrideType = component.get('v.overrideType');
		    		
		    		if(OverrideType == undefined || OverrideType == ' '){
		    			errorSpaninput.classList.add('show');
		    			errorSpaninput.classList.remove('hidden');
		    		}
		    		else if(OverrideType == 'Manager Callback'){
						InputElement = component.find("ManagerComments").get("v.value");	  		
						var errorSpaninputOne = document.getElementById('errorSpaninputOne');
						if(InputElement == ''){
							errorSpaninputOne.classList.add('show');
							errorSpaninputOne.classList.remove('hidden');
						}
						else{
							errorSpaninputOne.classList.remove('show');
							errorSpaninputOne.classList.add('hidden');
							component.set("v.isOpen", false);
							component.set("v.ManagerCallbackComments", InputElement);
							helper.InsertLogData(component, event, helper, memberid, decision, FDL, OverrideType, OverrideSupervisor, GUID, IVRGUIDFromUrl);
						}
					}
		    		else if(OverrideType == 'Verbal' && OverrideSupervisor == 'Select'){
		    			errorSpan.classList.add('show');
		    			errorSpan.classList.remove('hidden');
		    		}
		    		else{
		    			component.set("v.isOpen", false);
		    			helper.InsertLogData(component, event, helper, memberid, decision, FDL, OverrideType, OverrideSupervisor, GUID, IVRGUIDFromUrl);
		    		}
		    	}		    	
    	}
    },
    
    ConvertToLead : function (component, event, helper) {
    var createRecordEvent = $A.get("e.force:createRecord");
    createRecordEvent.setParams({
        "entityApiName": "Lead"
    });
    createRecordEvent.fire();
},


NavigateToMember : function(component , event, helper){
   var memberid = component.get('v.SelectedmemberId');
   var GUID = component.get("v.GUID");
   var IVRGUIDFromUrl = component.get("v.IVRGUIDFromUrl");
   var LastLevel = component.get("v.CurrentAuthenticationLevel");
   if(memberid == undefined){
    		alert('Please search for member');
    	}
    	else{
    		 helper.LastAcheivableLogs(component, event, memberid, GUID, LastLevel, IVRGUIDFromUrl);
    		 var urlString = window.location.href;
    		 if(IVRGUIDFromUrl == undefined){
    			 var baseURL = urlString.substring(0, urlString.indexOf("/one"));
    		 }
    		 else
    		 {
    			 var baseURL = urlString.substring(0, urlString.indexOf("/lightning"));
    		 }
    		 baseURL = baseURL + '/lightning/r/Account/'+ memberid + '/view';
    		 window.open(baseURL,"_self");  
    	}
    
   
},
    openCaseModel: function(component, event, helper) {
    	var memberid = component.get("v.SelectedmemberId");
    	if(memberid == undefined){
    		alert('Please search for member');
    	}
    	else{
    		component.set("v.isCaseModelOpen", true);
    		helper.GetAccountNumber(component, event, helper, memberid)
    		
    		
		} 
    },
    closeCaseModel: function(component, event, helper) {
    	component.set("v.isCaseModelOpen", false);
    },
    
    CreateCase: function(component, event, helper) {
    	
    	var memberid = component.get("v.SelectedmemberId");
    	var accountnumber = component.get("v.AccountNumber");
    	var CaseComment = component.find('CaseComment').get('v.value');
    	var AccountId = component.get("v.AccountId");
    	var GUID = component.get("v.GUID");
    	var IVRGUIDFromUrl = component.get("v.IVRGUIDFromUrl");
    	helper.SaveCaseWithLogData(component, event, helper, memberid, accountnumber, CaseComment, AccountId, GUID, IVRGUIDFromUrl)
    	component.set("v.isCaseModelOpen", false);
    },
    
    openViewHistoryModel : function(component, event, helper) {
    	
	    	var memberid = component.get("v.SelectedmemberId");
	    	if(memberid == undefined || memberid==null ){
	    		alert('Please search for member');
	    	}
	    	else{
	    		component.set("v.isViewHistoryModelOpen", true);
	    		
			} 
    	},
    	OpenDescription : function(component, event, helper) {
    	
    		component.set("v.isViewDescriptionModelOpen", true);
    	},
    
    closeViewHistoryModel: function(component, event, helper) {
    	component.set("v.isViewHistoryModelOpen", false);
    },
    closeViewDedcriptionModel : function(component, event, helper) {
    	component.set("v.isViewDescriptionModelOpen", false);
    },
    
    openFailedDesiredLevelModel : function(component, event, helper) {
    	
	    	var memberid = component.get("v.SelectedmemberId");
	    	if(memberid == undefined || memberid==null ){
	    		alert('Please search for member');
	    	}
	    	else{
	    		component.set("v.isFailedDesiredLevelModelOpen", true);
	    		
			} 
    	},
     closeFailedDesiredLevelModel: function(component, event, helper) {
    	component.set("v.isFailedDesiredLevelModelOpen", false);
    },
   
    
    clearAll : function(component, event){
	    console.log('Clearall called');
	   document.getElementById("frmPhoneNumber").value = '';
	   document.getElementById("frmMemberNumber").value = '';
	   document.getElementById("frmSSN").value = '';
	   var PhoneNumberMessage = document.getElementById('PhoneNumberMessage'); 
	   PhoneNumberMessage.firstElementChild.innerText = '';
	   var MemberNumberDiv = document.getElementById('MemberNoDiv');						    	
	   MemberNumberDiv.firstChild.classList.add("hidden");
	   MemberNumberDiv.firstChild.classList.remove("show");
	   component.set("v.PhoneNumberEntered","");
	   component.set("v.MemberNumberEntered","");
	   component.set("v.SSNEntered","");
	   component.set("v.IsMatchingMemberFound",false);
	   component.set("v.IsMemberNumberValid",false);
	   component.set("v.accounts",null);
	   component.set("v.ActiveTabId",'');
	   component.set("v.ActiveTab",'');
	   component.set("v.SelectedmemberId",null);
	   component.set("v.AccountNumber",'');
	   component.set("v.IsRightDivVisible",false);
	   component.set("v.Likedisable",false);
	   component.set("v.reason",'');
	   component.set("v.notes",'');
	   component.set("v.status",'');
	   component.set("v.ScoreModelNegativeScore",'');
	   component.set("v.ScoreModelPositiveScore",'');
	   component.set("v.OTPValidStatus",'');
	   component.set("v.MaximumScore",'');
	   component.set("v.NegativeScoreObtained",0);
	   component.set("v.PositiveScoreObtained",0);
	   component.set("v.AuthenticationDecision",'');
	   component.set("v.IsKYMTabVisible", false);
	   component.set("v.Attempts",0);
	   component.set("v.ShowFailedDesiredLevel",false);
	   component.set("v.KYMIconName",'utility:help');
	   component.set("v.PWIconName",'utility:help');
	   component.set("v.OOWIconName",'utility:help');
	   component.set("v.OTPIconName",'utility:help');
	   component.set("v.DebitIconName",'utility:help');
	   component.set("v.CFCUIconName",'utility:help');
	   component.set("v.HighestAchievableLevel",'' );
	   component.set("v.ToGetHighestLevel",'' );
	   component.set("v.MaximumPointsAvailable",0 );
	   component.set("v.IsKYMAvailableOnLoad",false);
	   component.set("v.IsOTPAvailableOnLoad",false);
	   component.set("v.IsDebitPinAvailableOnLoad",false);
	   component.set("v.IsOOWAvailableOnLoad",true);
	   component.set("v.IsPublicWalletAvailableOnLoad",false);
	   component.set("v.IsCFCUWalletAvailableOnLoad",false);
	   component.set("v.GUID",'');
	   component.set("v.SSNFromURL",'' );
	   component.set("v.MemberNumberFromURL",'' );
	   component.set("v.PhoneFromURL",'' );
	   component.set("v.LastAchievable30day",'' );
	   component.set("v.PointObtained",0 );
	   component.set("v.ShowFailedDesiredLevelCount",0 );
	   component.set("v.CurrentAuthenticationLevel",'Level 1');
	   component.set("v.CFCUWalletStatusForDay",true);
	   component.set("v.PublicWalletStatusForDay",true);
	   component.set("v.OOWStatusForDay",true);
	   component.set("v.OTPStatusForDay",true); 
	   component.set("v.isPINChange",false);
	   component.set("v.isFDLogPreviousDay",false);
	   component.set("v.PublicWalletColor",'');
	   component.set("v.CFCUWalletColor",'');
	   component.set("v.OOWColor",'');
	   component.set("v.OTPColor",'');
	   component.set("v.DebitCardStatus",'');
	   component.set("v.isDebitPinCalculated",false);
	   component.set("v.isPinChangeCalculated",false);
	   component.set("v.isFDLogCalculated",false);
	   component.set("v.IVRGUIDFromUrl",'' );
	   component.set("v.ReMemberId",'' );
	   component.set("v.IsOOWTabVisible", true);
	   component.set("v.IsDebitTabVisible", true);
	   component.set("v.ReasonCodeFromUrl",'');
	   component.set("v.HighFlagFromUrl",'');
	   component.set("v.ManagerCallbackComments",'');
	   component.set("v.IsGetReloadDataCalled",false);
	   component.set("v.ReLoadRequired",false);
	   component.set("v.IsReLoaded",false);
	   component.set("v.IsUserSessionLoaded",false);
	   component.set("v.EnteredCardNumber",'');
	   component.set("v.CardNumberMatch",'');
	   component.set("v.MemberNumberMatch",'');
	   component.set("v.PhoneNumberMatch",'');
	   component.set("v.SSNnumberMatch",'');
	   component.set("v.PINMatch",'');
	   component.set("v.IsMemberManualSearched",false);
	   component.set("v.MultipleMemberNumberAlert",'');
       component.set("v.OOWMemberNumberEntered",'');
	   window.location.href = '/lightning/cmp/c__LightningVerification';
	   
	    
   },
	
})