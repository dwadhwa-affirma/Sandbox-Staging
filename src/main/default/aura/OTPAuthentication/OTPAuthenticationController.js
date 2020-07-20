/*
 * sfdcmonkey.com 
 * 11/17/2017
 * support API 41.0 and above
 */
({
   doInit : function(component, event, helper) {
    	debugger;
    	component.set("v.currentStep", "1");
    	component.set("v.IsEmailVisible", false);
    	component.set("v.loading", false);
    	var params = event.getParam('arguments');
    	var IsReLoadRequired ;
    	var IsUserSessionLoaded;
		if (params) {
			IsReLoadRequired =  params.param2;
			IsUserSessionLoaded = params.param3;
			component.set("v.IsReLoadRequired", IsReLoadRequired);
			component.set("v.IsUserSessionLoaded", IsUserSessionLoaded);
			
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
        
       
    		var action = component.get("c.GetOTPLogForReload");
    		if(IsReLoadRequired == undefined){IsReLoadRequired = false}
    		if(IsUserSessionLoaded == undefined){IsUserSessionLoaded = false} 
    		action.setParams({"memberid" : recordid ,"IVRGUIDFromUrl": IVRGUIDFromUrl , "IsUserSessionLoaded": IsUserSessionLoaded,"IsReLoadRequired": IsReLoadRequired});
    		action.setCallback(this, function(response){
            
    			var status = response.getState();
    			if(component.isValid() && status === "SUCCESS")
    			{
    				var result =  response.getReturnValue();
    				if(result.Verified != undefined && result.Verified.length > 0 && result.Verified!=null)
    				{
    					component.set("v.verified", result.Verified);
    					component.set("v.currentStep", "3");
    					component.set("v.IsEmailVisible", false);
    					
    				}else{
									var action = component.get("c.ListOfEmailsAndPhoneNumbers");
							       
							        action.setParams({"accid" : recordid , "IsAuth" : IsCallingfromAuth, "GUID" : GUID, "IVRGUIDFromUrl": IVRGUIDFromUrl });
									action.setCallback(this, function(response){
							            
										var status = response.getState();
										if(component.isValid() && status === "SUCCESS")
										{
											var result =  response.getReturnValue();
							               	component.set("v.Model", result);
							               	component.set("v.IsEmailVisible", true);
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
    				
    			}
			});
		 
    		$A.enqueueAction(action);
    	
    	
	},

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
    
  /*  doInit : function(component, event, helper) {
    	debugger;
    	var params = event.getParam('arguments');
    	var IsReLoadRequired ;
    	var IsUserSessionLoaded;
		if (params) {
			IsReLoadRequired =  params.param2;
			IsUserSessionLoaded = params.param3;
			component.set("v.IsReLoadRequired", IsReLoadRequired);
			component.set("v.IsUserSessionLoaded", IsUserSessionLoaded);
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
        
        if((IsReLoadRequired == undefined && IsUserSessionLoaded == false) ||(IsReLoadRequired == true && IsUserSessionLoaded == false) || (IsReLoadRequired == false && IsUserSessionLoaded == true))
    	{
    		var action = component.get("c.GetOTPLogForReload");
    		action.setParams({"memberid" : recordid ,"IVRGUIDFromUrl": IVRGUIDFromUrl , "IsUserSessionLoaded": IsUserSessionLoaded});
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
	*/
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
	         component.find('InputOTPTxt2').set("v.value", '');
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
	 var EmailandPhoneModelCount = parseInt(component.get("v.Model.EmailsList_Options.length")) + parseInt(component.get("v.Model.PhoneList_Options.length"));
     var emailArray =[];
     var phoneArray =[];
     var emailLength = parseInt(component.get("v.Model.EmailsList_Options.length")) ;
     var phoneLength = parseInt(component.get("v.Model.PhoneList_Options.length")) ;  
     for(var i=0 ; i < emailLength; i++)
      {
      	 emailArray.push(component.get("v.Model.EmailsList_Options")[i]);
      }
      for(var i=0 ; i < phoneLength; i++)
      {
      	 phoneArray.push(component.get("v.Model.PhoneList_Options")[i]);
      }  
	 if(selectedOTPSendOption)
	 {
		  action.setParams({"accid" : recordid, "GUID" : GUID, "fieldName": selectedOTPSendOption,"IVRGUIDFromUrl": IVRGUIDFromUrl});
	 }
	 else
		  action.setParams({"accid" : recordid, "fieldName": ''});
	 
	  action.setCallback(this, function(response){
		  var status = response.getState();
		  var result =  response.getReturnValue();
		  
		  if(status === "SUCCESS")
		  {
			  
			  	component.set("v.verified", "Cancelled");
			   
			  if(result.PhoneAndEmailList != undefined && result.PhoneAndEmailList.length > 0){
					 
                  var resultLength = parseInt(result.PhoneAndEmailList.length);
                  if(emailLength  > 0 ){
                      
                      for(var i =0 ; i < emailLength; i++){
                          
                          for(var j= 0 ; j < resultLength;  j++ )
                          {
                               	var objIndex = emailArray.findIndex((obj => obj.Value == result.PhoneAndEmailList[j]));
                              if(objIndex >=0){emailArray[objIndex].isEnabled = true;}

                              
                          }
                                                    	
                      }
                      
                      component.set("v.Model.EmailsList_Options", emailArray);
                      var emailDisableCount = 0;
                      for(var i =0 ; i < emailArray.length; i++)
                      {
                          if(emailArray[i].isEnabled == false){
                              emailDisableCount = parseInt(emailDisableCount) + 1; 
                          }
                      }
                  }
                  if(phoneLength  > 0 ){
                      
                      for(var i =0 ; i < phoneLength; i++){
                          
                          for(var j= 0 ; j < resultLength;  j++ )
                          {
                               	var objIndex = phoneArray.findIndex((obj => obj.Value == result.PhoneAndEmailList[j]));
                                 
                              if(objIndex >=0){phoneArray[objIndex].isEnabled = true;}

                              
                          }
                                                    	
                      }
                      
                      component.set("v.Model.PhoneList_Options", phoneArray);
                      var phoneDisableCount = 0;
                      for(var i =0 ; i < phoneArray.length; i++)
                      {
                          if(phoneArray[i].isEnabled == false){
                              phoneDisableCount = parseInt(phoneDisableCount) + 1; 
                          }
                      }
                  }		
					//  component.set("v.IsCanceledCalled", true);
					  component.set("v.currentStep", "1");
                  	  component.set("v.selectedValue", "");	
					  if(phoneDisableCount == 0 &&  emailDisableCount == 0){
						  component.set("v.IsAllEmailandPhoneExhausted" , true);
						  component.set("v.currentStep", "3");
					  }
			  }
			  else
			  {
				   component.set("v.currentStep", "1");
			  }
			  
			  
			  var compEvent = component.getEvent("statusEvent");
			  compEvent.setParams({"OTPVarifiedStatus" : "Cancelled","ActionType": 'OTP',"IsAllEmailandPhoneExhausted":component.get("v.IsAllEmailandPhoneExhausted")});
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
	  
   },
   resendOTP : function(component, event, helper) {
         
         var IVRGUIDFromUrl = component.get("v.IVRGUIDFromUrl");
		 var EmailandPhoneModelCount = parseInt(component.get("v.Model.EmailsList_Options.length")) + parseInt(component.get("v.Model.PhoneList_Options.length"));
	     var emailArray =[];
	     var phoneArray =[];
	     var emailLength = parseInt(component.get("v.Model.EmailsList_Options.length")) ;
	     var phoneLength = parseInt(component.get("v.Model.PhoneList_Options.length")) ;  
	     for(var i=0 ; i < emailLength; i++)
	      {
	      	 emailArray.push(component.get("v.Model.EmailsList_Options")[i]);
	      }
	      for(var i=0 ; i < phoneLength; i++)
	      {
	      	 phoneArray.push(component.get("v.Model.PhoneList_Options")[i]);
	      } 
		
		 var action = component.get("c.OTPResend");
		 action.setParams({"IVRGUIDFromUrl": IVRGUIDFromUrl});
		 action.setCallback(this, function(response){
		  var status = response.getState();
		  var result =  response.getReturnValue();
		  
			  if(status === "SUCCESS")
			  {
				  if(result.PhoneAndEmailList != undefined && result.PhoneAndEmailList.length > 0){
		                  var resultLength = parseInt(result.PhoneAndEmailList.length);
		                  if(emailLength  > 0 ){
		                      
		                      for(var i =0 ; i < emailLength; i++){
		                          
		                          for(var j= 0 ; j < resultLength;  j++ )
		                          {
		                               	var objIndex = emailArray.findIndex((obj => obj.Value == result.PhoneAndEmailList[j]));
		                              if(objIndex >=0){emailArray[objIndex].isEnabled = true;}
		
		                              
		                          }
		                                                    	
		                      }
		                      
		                      component.set("v.Model.EmailsList_Options", emailArray);
                              var emailDisableCount = 0;
                              for(var i =0 ; i < emailArray.length; i++)
                              {
                                  if(emailArray[i].isEnabled == false){
                                      emailDisableCount = parseInt(emailDisableCount) + 1; 
                                  }
                              }
		                  }
		                  if(phoneLength  > 0 ){
		                      
		                      for(var i =0 ; i < phoneLength; i++){
		                          
		                          for(var j= 0 ; j < resultLength;  j++ )
		                          {
		                               	var objIndex = phoneArray.findIndex((obj => obj.Value == result.PhoneAndEmailList[j]));
		                                 
		                              if(objIndex >=0){phoneArray[objIndex].isEnabled = true;}
		
		                              
		                          }
		                                                    	
		                      }
	                      
                              component.set("v.Model.PhoneList_Options", phoneArray);
                              var phoneDisableCount = 0;
                              for(var i =0 ; i < phoneArray.length; i++)
                              {
                                  if(phoneArray[i].isEnabled == false){
                                      phoneDisableCount = parseInt(phoneDisableCount) + 1; 
                                  }
                              }
		                  }
				  	}
				 	component.set("v.currentStep", "1");
				 	component.set("v.selectedValue", "");
					if(emailDisableCount == 0 && phoneDisableCount ==0){
							  component.set("v.IsAllEmailandPhoneExhausted" , true);
							 
					 }
				  
				  	 var compEvent = component.getEvent("statusEvent");
				  	 compEvent.setParams({"OTPVarifiedStatus" : "Cancelled","ActionType": 'OTP',"IsAllEmailandPhoneExhausted":component.get("v.IsAllEmailandPhoneExhausted")});
				  	 compEvent.fire();
				  
			  }
		  });
		 $A.enqueueAction(action);
		 
	},
})