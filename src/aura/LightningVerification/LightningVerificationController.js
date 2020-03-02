({
		doInit : function(component, event, helper) {
			
		helper.doInit(component, event,helper);
		
		var PhoneNumber = component.get("v.PhoneFromURL");
	    var MemberNumber = component.get("v.MemberNumberFromURL");
	    var SSNNumber = component.get("v.SSNFromURL");
	    var IVRGUIDFromUrl =  component.get("v.IVRGUIDFromUrl");
	    helper.getMemberSearch(component, event,PhoneNumber,MemberNumber,SSNNumber,IVRGUIDFromUrl);
	   
		},
		
		onRender : function (component, event, helper) {
	        
	        var memberid = component.get("v.ReMemberId");
	        var IVRGUIDFromUrl =  component.get("v.IVRGUIDFromUrl");
	        var GUID =  component.get("v.GUID");
	        var attribute1 = memberid;
	        var ReLoadRequired = component.get("v.ReLoadRequired");
	        if(ReLoadRequired != undefined && memberid != undefined && component.get("v.IsReLoaded") ==false){
	        
	        	var element = document.getElementById(memberid);
	        	element.checked = true;
	        	component.set("v.IsRightDivVisible", true);
	        	var DebitCardStatus = component.get("v.DebitCardStatus");
				helper.MemberVerificationAttemptCheck(component, event, helper, memberid, DebitCardStatus, ReLoadRequired);
				component.set("v.IsReLoaded", true);
				component.set("v.SelectedmemberId",memberid);
				
	        }
	        
	        if(ReLoadRequired == true){	
	        	
	        	var PublicWalletComponent = component.find('PublicWallet');
		        if(PublicWalletComponent!=undefined)PublicWalletComponent.PublicWalletMethod(attribute1,ReLoadRequired);
		            
		        var CFCUWalletComponent = component.find('CFCUWallet');		        
		        if(CFCUWalletComponent!=undefined)CFCUWalletComponent.CFCUWalletMethod(attribute1,ReLoadRequired);
		        
		        var OTPComponent = component.find('OTPAuthentication');		        
		        if(OTPComponent!=undefined)OTPComponent.OTPMethod(attribute1,ReLoadRequired); 
		              	            
		        helper.GetReloadData(component, event, helper, memberid, GUID, IVRGUIDFromUrl);	
		    }
		},
		
			
		MemberCompEvent : function(component, event, helper){
		var IVRGUIDFromUrl = component.get("v.IVRGUIDFromUrl");
		var ReLoadRequired = component.get("v.ReLoadRequired");
		var MaximumPointsAvailable = component.get("v.MaximumPointsAvailable");
		var PointsObtained = component.get("v.PointObtained");
		var IsKYMAvailable = component.get("v.IsKYMAvailableOnLoad");
	    var IsOTPAvailable = component.get("v.IsOTPAvailableOnLoad");
	    var IsDebitPinAvailable = component.get("v.IsDebitPinAvailableOnLoad");
	    var IsOOWAvailable = component.get("v.IsOOWAvailableOnLoad");
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
    	//---------------------------For checking MC Pin Change and Failed desired level score -----------//
    	
    	
    	if(isFDLogCalculated == false && isFDLogPreviousDay == true )
		 {
			MaximumPointsAvailable = parseInt(MaximumPointsAvailable) - parseInt(FDLogPreviousDayNegativePoint);	
			component.set("v.isFDLogCalculated",true);
		 }
		if(isPinChangeCalculated == false && isPINChange == true )
		 {
			MaximumPointsAvailable = parseInt(MaximumPointsAvailable) - parseInt(PINChangeNegativePoint);
			component.set("v.isPinChangeCalculated",true);
		 }
    	    	
    	//---------------------------For checking MC Pin Change and Failed desired level score -----------//
    	  	
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
		if(isDebitPinCalculated == false && DebitCardStatus == 'true' )
		 {
				 PointsObtained = parseInt(PointsObtained) + parseInt(DebitPinPositivePoint);
				 component.set("v.PointObtained",PointsObtained );
				  MaximumPointsAvailable = parseInt(MaximumPointsAvailable) + parseInt(DebitPinPositivePoint);
				 component.set("v.isDebitPinCalculated",true);
		 }
		if(isDebitPinCalculated == false && DebitCardStatus == 'false' )
		 {
				 MaximumPointsAvailable = parseInt(MaximumPointsAvailable) - parseInt(DebitPinNegativePoint);
				 component.set("v.isDebitPinCalculated",true);
		 }
		for(var i=0 ; i < liElement.length; i++)
		{
			 aElement = liElement[i].firstElementChild;
			 if(eventParam == "Cancelled" && aElement.id =='OTPTab__item'){			  
	  			component.set("v.IsOTPAvailableOnLoad",IsOTPAvailable);
	  			helper.GetNextAuthenticationType(component, event, helper, memberid, MemberType, MaximumPointsAvailable, PointsObtained, IsKYMAvailable, IsOTPAvailable, IsDebitPinAvailable, IsOOWAvailable, IsPublicWalletAvailable, IsCFCUWalletAvailable);
			}
			if(eventParam == "Authenticated" && aElement.id =='OTPTab__item'){
				liElement[i].classList.add("green");
				component.set('v.OTPIconName','utility:check');
	  			PointsObtained = parseInt(PointsObtained) + parseInt(ScoreModelPositiveScore);
	  			component.set("v.PointObtained",PointsObtained);
	  			IsOTPAvailable = false;
	  			component.set("v.IsOTPAvailableOnLoad",IsOTPAvailable);
	  			component.set("v.OTPStatusForDay",true);
	  			helper.GetNextAuthenticationType(component, event, helper, memberid, MemberType, MaximumPointsAvailable, PointsObtained, IsKYMAvailable, IsOTPAvailable, IsDebitPinAvailable, IsOOWAvailable, IsPublicWalletAvailable, IsCFCUWalletAvailable);
			}
			if(eventParam == "Valid" && aElement.id =='OTPTab__item'){
				liElement[i].classList.add("green");
				component.set('v.OTPIconName','utility:check');
	  			PointsObtained = parseInt(PointsObtained) + parseInt(ScoreModelPositiveScore);
	  			component.set("v.PointObtained",PointsObtained);
	  			IsOTPAvailable = false;
	  			component.set("v.IsOTPAvailableOnLoad",IsOTPAvailable);
	  			component.set("v.OTPStatusForDay",true);
	  			helper.GetNextAuthenticationType(component, event, helper, memberid, MemberType, MaximumPointsAvailable, PointsObtained, IsKYMAvailable, IsOTPAvailable, IsDebitPinAvailable, IsOOWAvailable, IsPublicWalletAvailable, IsCFCUWalletAvailable);
			}
			if(eventParam == "Declined" && aElement.id =='OTPTab__item'){
				liElement[i].classList.add("red");
	  			component.set('v.OTPIconName','utility:close');	  			
	  			MaximumPointsAvailable = parseInt(MaximumPointsAvailable) - parseInt(ScoreModelNegativeScore);
	  			IsOTPAvailable = false;
	  			component.set("v.IsOTPAvailableOnLoad",IsOTPAvailable);
	  			helper.GetNextAuthenticationType(component, event, helper, memberid, MemberType, MaximumPointsAvailable, PointsObtained, IsKYMAvailable, IsOTPAvailable, IsDebitPinAvailable, IsOOWAvailable, IsPublicWalletAvailable, IsCFCUWalletAvailable);
			}
			if(eventParam == "Changed" && aElement.id =='OTPTab__item'){
				liElement[i].classList.add("red");
	  			component.set('v.OTPIconName','utility:close');
	  			MaximumPointsAvailable = parseInt(MaximumPointsAvailable) - parseInt(ScoreModelNegativeScore);
	  			IsOTPAvailable = false;
	  			component.set("v.IsOTPAvailableOnLoad",IsOTPAvailable);
	  			helper.GetNextAuthenticationType(component, event, helper, memberid, MemberType, MaximumPointsAvailable, PointsObtained, IsKYMAvailable, IsOTPAvailable, IsDebitPinAvailable, IsOOWAvailable, IsPublicWalletAvailable, IsCFCUWalletAvailable);
			}
			if(eventParam == "Invalid" && aElement.id =='OTPTab__item'){
				liElement[i].classList.add("red");
	  			component.set('v.OTPIconName','utility:close');	  			
	  			MaximumPointsAvailable = parseInt(MaximumPointsAvailable) - parseInt(ScoreModelNegativeScore);
	  			IsOTPAvailable = false;
	  			component.set("v.IsOTPAvailableOnLoad",IsOTPAvailable);
	  			helper.GetNextAuthenticationType(component, event, helper, memberid, MemberType, MaximumPointsAvailable, PointsObtained, IsKYMAvailable, IsOTPAvailable, IsDebitPinAvailable, IsOOWAvailable, IsPublicWalletAvailable, IsCFCUWalletAvailable);
	  			
			}
			if(KYMeventParam == "SUCCESS" && aElement.id =='KYMTab__item'){
			 
				liElement[i].classList.add("green");
	  			component.set('v.KYMIconName','utility:check');
	  			PointsObtained = parseInt(PointsObtained) + parseInt(ScoreModelPositiveScore);
	  			component.set("v.PointObtained",PointsObtained);
	  			IsKYMAvailable = false;
	  			component.set("v.IsKYMAvailableOnLoad",IsKYMAvailable);
	  			helper.GetNextAuthenticationType(component, event, helper, memberid, MemberType, MaximumPointsAvailable, PointsObtained, IsKYMAvailable, IsOTPAvailable, IsDebitPinAvailable, IsOOWAvailable, IsPublicWalletAvailable, IsCFCUWalletAvailable);
			 }
			 
			 if(KYMeventParam == "FAIL" && aElement.id =='KYMTab__item')
			 {
				 liElement[i].classList.add("red");
	  			 component.set('v.KYMIconName','utility:close');
	  			 MaximumPointsAvailable = parseInt(MaximumPointsAvailable) - parseInt(ScoreModelNegativeScore);
	  			 IsKYMAvailable = false;
	  			 component.set("v.IsKYMAvailableOnLoad",IsKYMAvailable);
	  			 helper.GetNextAuthenticationType(component, event, helper, memberid, MemberType, MaximumPointsAvailable, PointsObtained, IsKYMAvailable, IsOTPAvailable, IsDebitPinAvailable, IsOOWAvailable, IsPublicWalletAvailable, IsCFCUWalletAvailable);
			 }
			 
			 
			 if(parseInt(PublicWalletScore) > 2 && parseInt(PublicWalletFailedCount) <= 1 && aElement.id =='PublicWalletTab__item')
			 {
				 	component.set("v.PublicWalletColor",'Green');
				 	liElement[i].classList.add("green");
				 	liElement[i].classList.remove("red");
				 	component.set('v.PWIconName','utility:check');
	  				PointsObtained = parseInt(PointsObtained) + parseInt(ScoreModelPositiveScore);
	  				component.set("v.PointObtained",PointsObtained);
	  				IsPublicWalletAvailable = false;
	  				component.set("v.IsPublicWalletAvailableOnLoad",IsPublicWalletAvailable);
                 	component.set("v.PublicWalletStatusForDay", true);
	  				helper.GetNextAuthenticationType(component, event, helper, memberid, MemberType, MaximumPointsAvailable, PointsObtained, IsKYMAvailable, IsOTPAvailable, IsDebitPinAvailable, IsOOWAvailable, IsPublicWalletAvailable, IsCFCUWalletAvailable);
			 }
			 if((parseInt(PublicWalletScore) <= 2 || parseInt(PublicWalletFailedCount) > 1) && aElement.id =='PublicWalletTab__item')
			 {
				 component.set("v.PublicWalletColor",'Red');
				 liElement[i].classList.add("red");
				 liElement[i].classList.remove("green");
	  			 component.set('v.PWIconName','utility:close');
	  			 MaximumPointsAvailable = parseInt(MaximumPointsAvailable) - parseInt(ScoreModelNegativeScore);
	  			 IsPublicWalletAvailable = false;
	  			 component.set("v.IsPublicWalletAvailableOnLoad",IsPublicWalletAvailable);
	  			 helper.GetNextAuthenticationType(component, event, helper, memberid, MemberType, MaximumPointsAvailable, PointsObtained, IsKYMAvailable, IsOTPAvailable, IsDebitPinAvailable, IsOOWAvailable, IsPublicWalletAvailable, IsCFCUWalletAvailable);
	  			 
			 }			 
			 if(parseInt(CFCUWalletScore) > 2 && parseInt(CFCUWalletFailedCount) <=1 && aElement.id =='CFCUWalletTab__item')
			 {
				 	liElement[i].classList.add("green");
				 	liElement[i].classList.remove("red");
	  				component.set('v.CFCUIconName','utility:check');
	  				PointsObtained = parseInt(PointsObtained) + parseInt(ScoreModelPositiveScore);
	  				component.set("v.PointObtained",PointsObtained);
	  				IsCFCUWalletAvailable = false;
	  				component.set("v.IsCFCUWalletAvailableOnLoad",IsCFCUWalletAvailable);
	  				component.set("v.CFCUWalletStatusForDay", true);
	  				helper.GetNextAuthenticationType(component, event, helper, memberid, MemberType, MaximumPointsAvailable, PointsObtained, IsKYMAvailable, IsOTPAvailable, IsDebitPinAvailable, IsOOWAvailable, IsPublicWalletAvailable, IsCFCUWalletAvailable);
	  				
			 }
			 if((parseInt(CFCUWalletScore) <= 2 || parseInt(CFCUWalletFailedCount) > 1 ) && aElement.id =='CFCUWalletTab__item')
			 {
				 liElement[i].classList.add("red");
				 liElement[i].classList.remove("green");
	  			 component.set('v.CFCUIconName','utility:close');
	  			 MaximumPointsAvailable = parseInt(MaximumPointsAvailable) - parseInt(ScoreModelNegativeScore);
	  			 IsCFCUWalletAvailable = false;
	  			 component.set("v.IsCFCUWalletAvailableOnLoad",IsCFCUWalletAvailable);
	  			 helper.GetNextAuthenticationType(component, event, helper, memberid, MemberType, MaximumPointsAvailable, PointsObtained, IsKYMAvailable, IsOTPAvailable, IsDebitPinAvailable, IsOOWAvailable, IsPublicWalletAvailable, IsCFCUWalletAvailable);
			 }
			
			 component.set("v.MaximumPointsAvailable", MaximumPointsAvailable);
			
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
		component.set("v.IsRightDivVisible", true);
		var memberid = event.getSource().get('v.value');
		var membername = event.getSource().get('v.label');
		var MemberType = component.get("v.Membertype");
		var ReLoadRequired = component.get("v.ReLoadRequired");
		component.set("v.SelectedmemberId",memberid );
		component.set("v.SelectedmemberName",membername );
		var DebitCardStatus = component.get("v.DebitCardStatus");
		var attribute1 = component.get('v.SelectedmemberId');
		var PublicWalletComponent = component.find('PublicWallet');
        if(PublicWalletComponent!=undefined){
        	PublicWalletComponent.PublicWalletMethod(attribute1,ReLoadRequired);
        }
        
        var CFCUWalletComponent = component.find('CFCUWallet');
        if(CFCUWalletComponent!=undefined)CFCUWalletComponent.CFCUWalletMethod(attribute1,ReLoadRequired);
        
        var OTPComponent = component.find('OTPAuthentication');
        if(OTPComponent!=undefined)OTPComponent.OTPMethod(attribute1,ReLoadRequired);
        
		helper.MemberVerificationAttemptCheck(component, event, helper, memberid, DebitCardStatus, ReLoadRequired);
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
       if(selectedoverrideType == 'Verbal'){       
       		$A.util.addClass(element, 'show');
       		$A.util.removeClass(element, 'hidden');
       		errorSpaninput.classList.remove('show');
       		errorSpaninput.classList.add('hidden');
        }
        else{
        	$A.util.removeClass(element, 'show');
        	$A.util.addClass(element, 'hidden');
        	errorSpaninput.classList.remove('show');
		    errorSpaninput.classList.add('hidden');
		    errorSpan.classList.remove('show');
		    errorSpan.classList.add('hidden');
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
    	}
    	
    	else{
		    	if(button == 'ViewHistory'){
		    	}
		    	else if(button == 'FailedDesiredLevel'){
		    		component.set("v.AuthenticationDecision",'Failed Desired Level');
		    		decision = component.get("v.AuthenticationDecision");
		    		FDL = 'Yes';
		    		helper.InsertLogData(component, event, helper, memberid, decision, FDL, OverrideType, OverrideSupervisor, GUID, IVRGUIDFromUrl );
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
    		 var baseURL = urlString.substring(0, urlString.indexOf("/n"));
    		 baseURL = baseURL + '/lightning/r/Account/'+ memberid + '/view';
    		 window.open(baseURL,"_blank");  
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
    clearAll : function(component, event){
	   
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
	   
   },
	
})