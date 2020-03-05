/*
 * sfdcmonkey.com 
 * 11/17/2017
 * support API 41.0 and above
 */
({
   
  
   openModel: function(component, event, helper) {
    // for Display Model,set the "isOpen" attribute to "true"*****
      component.set("v.isOpen", true);
   },
    
   closeModel: function(component, event, helper) {
    // for Hide/Close Model,set the "isOpen" attribute to "Fasle" 
	   var action = component.get("c.CancelOTP");
	   var recordid = component.get("v.recordId");
	   
	   var parameters = {"accid": recordid};
       action.setParams(parameters);
	   action.setCallback(this, function(response){
            	var status = response.getState();
            	if(component.isValid() && status === "SUCCESS")
            	{
            			component.set("v.isOpen", false);            	
            	}            	
           });
            $A.enqueueAction(action);
            component.set("v.loading", 'true');
            location.reload();	
   },
   onRadioSelect: function(component, event) {	   
		 var selected = event.getSource().get("v.class");
		 component.set("v.selectedValue", selected);
		 component.set('v.optionRequired',false);
   },
    moveNext : function(component,event,helper){
     // control the next button based on 'currentStep' attribute value    
     var getCurrentStep = component.get("v.currentStep");
        if(getCurrentStep == "1"){
        
            
            var selectedOTPSendOption = component.get("v.selectedValue");
            if(selectedOTPSendOption == null || selectedOTPSendOption == undefined || selectedOTPSendOption == "")
            {            	         
            	component.set('v.optionRequired',true);
            	return false;
            }
            var Brand = component.get("v.Model.Brand");
            
            var action = component.get("c.GenerateRandomOTP");
	        var recordid = component.get("v.recordId");
	        var GUID = component.get("v.GUID");
	        var IVRGUIDFromUrl = component.get("v.IVRGUIDFromUrl");
	        var parameters = {"BrandName": Brand,"fieldName" : selectedOTPSendOption,  "resend" : "false", "accid": recordid, "GUID" : GUID,"IVRGUIDFromUrl": IVRGUIDFromUrl };
            action.setParams(parameters);
            action.setCallback(this, function(response){
            	var status = response.getState();
            	if(component.isValid() && status === "SUCCESS")
            	{
            		var result =  response.getReturnValue();
            		
            		component.set("v.keyModel", result);
            	}
            	component.set("v.currentStep", "2");
            	
            	component.set("v.loading", 'false');
            });
            
            $A.enqueueAction(action);
            component.set("v.loading", 'true');
           
        }
        else if(getCurrentStep == 2){
            component.set("v.currentStep", "3");
        }
    },
    
    moveBack : function(component,event,helper){
      // control the back button based on 'currentStep' attribute value    
        var getCurrentStep = component.get("v.currentStep");
         if(getCurrentStep == "2"){
            component.set("v.currentStep", "1");
         }
         else if(getCurrentStep == 3){
            component.set("v.currentStep", "2");
         }
    },
    
    finish : function(component,event,helper){
      // on last step show the alert msg, hide popup modal box and reset the currentStep attribute  
        alert('Thank You !');
        component.set("v.isOpen", false); 
        component.set("v.currentStep", "1");
    },
   
   // when user click direactly on step 1,step 2 or step 3 indicator then showing appropriate step using set 'currentStep'   
    selectFromHeaderStep1 : function(component,event,helper){
        component.set("v.currentStep", "1");
    },
    selectFromHeaderStep2 : function(component,event,helper){
        component.set("v.currentStep", "2");
    },
    selectFromHeaderStep3 : function(component,event,helper){
        component.set("v.currentStep", "3");
    },
    
    doInit : function(component, event, helper) {
    	debugger;
    	var params = event.getParam('arguments');
    	var IsReLoadRequired ;
		if (params) {
			IsReLoadRequired =  params.param2;
			component.set("v.IsReLoadRequired", IsReLoadRequired);
			}
    	
    	var recordid = component.get("v.recordId");
        var GUID = component.get("v.GUID");
        var IVRGUIDFromUrl = component.get("v.IVRGUIDFromUrl");
        var IsCallingfromAuth = component.get("v.IsCallingfromAuth");
        window.addEventListener("keydown", function(event) {
            var kcode = event.code;
            if(kcode == 'Escape'){
              event.preventDefault();
                event.stopImmediatePropagation();
            }
        }, true);
        
        if(IsReLoadRequired == true)
    	{
    		var action = component.get("c.GetOTPLogForReload");
    		action.setParams({"memberid" : recordid ,"IVRGUIDFromUrl": IVRGUIDFromUrl });
    		action.setCallback(this, function(response){
            
    			var status = response.getState();
    			if(component.isValid() && status === "SUCCESS")
    			{
    				var result =  response.getReturnValue();
    				if(result.Verified != undefined && result.Verified.length > 0)
    				{
    					component.set("v.verified", result.Verified);
    					component.set("v.currentStep", "3");
    				}
    			}
			});
		 
    		$A.enqueueAction(action);
    	}
    	else
    	{
				var action = component.get("c.ListOfEmailsAndPhoneNumbers");
		       
		        action.setParams({"accid" : recordid , "IsAuth" : IsCallingfromAuth, "GUID" : GUID, "IVRGUIDFromUrl": IVRGUIDFromUrl });
				action.setCallback(this, function(response){
		            
					var status = response.getState();
					if(component.isValid() && status === "SUCCESS")
					{
						var result =  response.getReturnValue();
		               	component.set("v.Model", result);
						if(result.IsIneligible == 'true')
						{
							component.set("v.currentStep", "3");
							component.set("v.verified", "Changed");
							var compEvent = component.getEvent("statusEvent");
				            compEvent.setParams({"OTPVarifiedStatus" : "Changed","ActionType": 'OTP'});
			  			    compEvent.fire();                	
						}
		                if(result.PhoneList_Options.length == 0 && result.EmailsList_Options.length == 0)
		                {
		                	component.set("v.currentStep", "3");
		                	component.set("v.verified", "NoContactInfo");     
		                	var compEvent = component.getEvent("statusEvent");
				            compEvent.setParams({"OTPVarifiedStatus" : "NoContactInfo","ActionType": 'OTP'});
			  			    compEvent.fire();           	
		                } 
		                else
						{
		                  setTimeout(function(){   var ele = document.getElementsByName("others");
			               for(var i=0;i<ele.length;i++)
			                  ele[i].checked = false; }, 3000);
		                }                
		               component.set("v.loading", 'false');
		              
		               
					}
				});
				 
				$A.enqueueAction(action);
				component.set("v.loading", 'true');
		}
	},
	
	 declineAtFirstStep : function(component, event, helper) {
         
		var action = component.get("c.DeclineOTPAtFirstStep");
        var recordid = component.get("v.recordId");
        var GUID = component.get("v.GUID");
        var IVRGUIDFromUrl = component.get("v.IVRGUIDFromUrl");
        action.setParams({"accid" : recordid, "GUID" : GUID,"IVRGUIDFromUrl": IVRGUIDFromUrl});
		action.setCallback(this, function(response){
            
			var status = response.getState();
			if(component.isValid() && status === "SUCCESS")
			{				
				component.set("v.currentStep", "3");
				component.set("v.verified", "Declined");	
				var compEvent = component.getEvent("statusEvent");
		        compEvent.setParams({"OTPVarifiedStatus" : "Declined","ActionType": 'OTP'});
	  			compEvent.fire();			
			}
			component.set("v.loading", 'false');
			
		});
		 
		$A.enqueueAction(action);
		component.set("v.loading", 'true');
	},
	
	 resendOTP : function(component, event, helper) {
         component.set("v.currentStep", "1");
         component.set("v.selectedValue", "");
		
	},
	clickverifyOTP:  function(component, event, helper) {
		var action = component.get("c.verifyOTP");
		var keyModel = component.get("v.keyModel");		
		var recordid = component.get("v.recordId");
		var EnteredOTP= component.get("v.EnteredOTP");
		var GUID= component.get("v.GUID");
		var IVRGUIDFromUrl = component.get("v.IVRGUIDFromUrl"); 
		 
		 if(EnteredOTP)
		 {
			  component.set('v.InputRequired',false);
			 var selectedOTPSendOption = component.get("v.selectedValue");
			 action.setParams({"accid" : recordid, "EnteredOTP": EnteredOTP,"fieldName": selectedOTPSendOption, "model": JSON.stringify(keyModel), "GUID" : GUID,"IVRGUIDFromUrl": IVRGUIDFromUrl});		 
			 action.setCallback(this, function(response){
	            
				var status = response.getState();
				if(component.isValid() && status === "SUCCESS")
				{
					var result =  response.getReturnValue();
					component.set("v.verified", result);
					var compEvent = component.getEvent("statusEvent");
		            compEvent.setParams({"OTPVarifiedStatus" : result,"ActionType": 'OTP'});
	  			    compEvent.fire();
					component.set("v.currentStep", "3");
				}
				else if (status === "ERROR") {
		            var errors = response.getError();	            
		            console.error(errors);
				}
				component.set("v.loading", 'false');
				
			});
			 
			$A.enqueueAction(action);
	            component.set("v.loading", 'true');
        }
        else
        {
        	document.getElementById('verifytxt').className = 'Inputerror';
        	component.set('v.InputRequired',true);
        	 return false;
        }
		 
	},
	 closePopup: function(component, event, helper) {		
		 var currentstep = component.get("v.currentStep");
		 if(false)
		 {
			  var recordid = component.get("v.recordId");
			  var selectedOTPSendOption = component.get("v.selectedValue");
			  var action = component.get("c.CancelOTP");
			 if(selectedOTPSendOption)
			 {
				  action.setParams({"accid" : recordid, "fieldName": selectedOTPSendOption});
			 }
			 else
				  action.setParams({"accid" : recordid, "fieldName": ''});
			 
			  action.setCallback(this, function(response){
				  var status = response.getState();
				  component.set("v.loading", 'false');
				  if(status === "SUCCESS")
				  {
					  component.set("v.verified", "Cancelled");
					  var compEvent = component.getEvent("statusEvent");
			          compEvent.setParams({"OTPVarifiedStatus" : "Cancelled","ActionType": 'OTP'});
		  			  compEvent.fire();
					  $A.get('e.force:closeQuickAction').fire();
					  if(currentstep != 1){
					  location.reload();
					  }	
				  }
				  else if (status === "ERROR") {
				     var errors = response.getError();	            
				     console.error(errors);
				  }
				  
			  });
			  $A.enqueueAction(action);
			  component.set("v.loading", 'true');
		 }
		 else
		 {
			 $A.get('e.force:closeQuickAction').fire();
			 if(currentstep != 1){
			 location.reload();	
			 }
		 }
		 
		 
   },
   CancelVerification : function(component, event, helper) {
	 var recordid = component.get("v.recordId");
	 var selectedOTPSendOption = component.get("v.selectedValue");
	 var action = component.get("c.CancelOTP");
	 var GUID = component.get("v.GUID");
	 var IVRGUIDFromUrl = component.get("v.IVRGUIDFromUrl");  
	 if(selectedOTPSendOption)
	 {
		  action.setParams({"accid" : recordid, "GUID" : GUID, "fieldName": selectedOTPSendOption,"IVRGUIDFromUrl": IVRGUIDFromUrl});
	 }
	 else
		  action.setParams({"accid" : recordid, "fieldName": ''});
	 
	  action.setCallback(this, function(response){
		  var status = response.getState();
		  var result =  response.getReturnValue();
		  component.set("v.CancelledAttempt", result);
		  if(status === "SUCCESS")
		  {
			  component.set("v.verified", "Cancelled");
			  if(result > 0){
				  component.set("v.currentStep", "3");
			  }
			  else
			  {
				   component.set("v.currentStep", "1");
			  }
			  var compEvent = component.getEvent("statusEvent");
			  compEvent.setParams({"OTPVarifiedStatus" : "Cancelled","ActionType": 'OTP'});
			  compEvent.fire();
		  }
		  else if (status === "ERROR") {
		     var errors = response.getError();	            
		     console.error(errors);
		  }
		  component.set("v.loading", 'false');
	  });
	  $A.enqueueAction(action);
	  component.set("v.loading", 'false');
	  
   }
})