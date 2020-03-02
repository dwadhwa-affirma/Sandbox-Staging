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
		if(pageReference.state.c__PINMatch == 'null'){
			component.set("v.DebitCardStatus", '');
		}else{		
			component.set("v.DebitCardStatus", pageReference.state.c__PINMatch);
		}
		if(pageReference.state.c__IVRGUID == 'null'){
		
			component.set("v.IVRGUIDFromUrl", '');
		}else{
			component.set("v.IVRGUIDFromUrl", pageReference.state.c__IVRGUID);
		}
		var PINMatchFromURL = pageReference.state.c__PINMatch;
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
		else
		{
			component.set("v.IsDebitTabVisible", true);
		}
		
	   
		    
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
		var action = component.get("c.SaveLastAchievableLevelLogs");
		action.setParams({"MemberId": memberid, "GUID" : GUID, "LastLevel": LastLevel,"IVRGUIDFromUrl":IVRGUIDFromUrl });
		action.setCallback(this, function (response) {
  		 var status = response.getState();            
               if (component.isValid() && status === "SUCCESS") {
                   var result = response.getReturnValue();
                 }	
			});
   
    	$A.enqueueAction(action);
	},
	
	MemberVerificationAttemptCheck : function(component, event, helper, memberid, DebitCardStatus,ReLoadRequired)
	{
		
		var GUID = component.get("v.GUID");
		var IVRGUIDFromUrl = component.get("v.IVRGUIDFromUrl");
		var action = component.get("c.MemberVerificationAttemptsCheck");
		if(ReLoadRequired == undefined){
			ReLoadRequired = false;
		}
		
		var SSNFromURL = component.get("v.SSNFromURL");
		var MemberNumberFromURL = component.get("v.MemberNumberFromURL");
		var PhoneFromURL = component.get("v.PhoneFromURL");
		var PageURL = component.get("v.PageURL");
		var DebitCardStatus = component.get("v.DebitCardStatus");
		if(PageURL == undefined){
			action.setParams({"MemberId": memberid,"GUID": GUID,"DebitCardStatus": DebitCardStatus,"SSNFromURL": ' ',"MemberNumberFromURL": ' ',"PhoneFromURL": ' ', "PageURL" : ' ', "IVRGUIDFromUrl": IVRGUIDFromUrl,"ReLoadRequired": ReLoadRequired});
		}
		else{
			action.setParams({"MemberId": memberid,"GUID": GUID,"DebitCardStatus": DebitCardStatus,"SSNFromURL": SSNFromURL,"MemberNumberFromURL":MemberNumberFromURL,"PhoneFromURL":PhoneFromURL,"PageURL":PageURL, "IVRGUIDFromUrl": IVRGUIDFromUrl,"ReLoadRequired":ReLoadRequired});
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
                    	component.set("v.OTPStatusForDay",result['OTPStatusForDay']);
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
					    component.set("v.CurrentAuthenticationLevel", result.CurrentAuthenticationLevel);
					    if(result['OOWStatusForDay'] == false)
					    {
					    	component.set("v.Likedisable", true);
					    }
					    else{
					    	component.set("v.Likedisable", false);
					    }
					    					    
					    if(SSNFromURL!= undefined && SSNFromURL != "" && SSNFromURL != null && SSNFromURL != 'null' )
					    {
					    	 if(result.MemberType == 'Foreign'){
					    		 component.set("v.IsOOWAvailableOnLoad", false);
					    	 }
					    	 else if(result.MemberType == 'Domestic')
					    	 {
					    		 component.set("v.IsOOWAvailableOnLoad", true);
					    	 }
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
		   var parameters = {"PhoneNumber": PhoneNumber,"MemberNumber" : MemberNumber,"SSNNumber" : SSNNumber,"IVRGUIDFromUrl":IVRGUIDFromUrl };
		
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
						  else{
						    	component.set("v.IsMemberNumberValid",false);
						    }
						
						component.set("v.ReLoadRequired", result.ReLoadRequired);
						if(result.ReLoadRequired == true){
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
        
    },
    
    GetAccountNumber : function (component, event, helper, memberid)
    {
    	var action = component.get("c.GetAccountNumber");
    		action.setParams({"accdetailid": memberid});  
		
    			action.setCallback(this, function (response) {
    			var status = response.getState();            
	       	    if (component.isValid() && status === "SUCCESS") {
	       	    	var result = response.getReturnValue(); 
                    
		               if(result.AccountNumber.length > 0)
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
	    var IsDebitPinAvailable = component.get("v.IsDebitPinAvailableOnLoad");
	    var IsOOWAvailable = component.get("v.IsOOWAvailableOnLoad");
	    var IsPublicWalletAvailable = component.get("v.IsPublicWalletAvailableOnLoad");
	    var IsCFCUWalletAvailable =   component.get("v.IsCFCUWalletAvailableOnLoad");
		var MemberType = component.get("v.Membertype");
    	var scoringModel = component.get("v.ScoringModel");
    	var LevelModel = component.get("v.LevelModel");
    	var PointsObtained = component.get("v.PointObtained");
    	var CurrentAuthenticationLevel = component.get("v.CurrentAuthenticationLevel");
    	if(IVRGUIDFromUrl != undefined && IVRGUIDFromUrl !='')
    	{
    		helper.GetScoreDataForReload (component, event, helper,memberid,IVRGUIDFromUrl );
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
	                               component.set("v.AccountNumber",result.AccountNumber);
	                                                          
	                               win = window.open(result.FlowURL+"&accountnumber=" + result.AccountNumber + "&firstname=allow" + MemberName);
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
		  							//component.set("v.OOWStatusForDay", true);
		  							helper.GetNextAuthenticationType(component, event, helper, memberid, MemberType, MaximumPointsAvailable, PointsObtained, IsKYMAvailable, IsOTPAvailable, IsDebitPinAvailable, IsOOWAvailable, IsPublicWalletAvailable, IsCFCUWalletAvailable);
		  							
		  							
		  						}
		  						else{
		  						
		  							MaximumPointsAvailable = parseInt(MaximumPointsAvailable) -parseInt(ScoreModelNegativeScore);
		  							IsOOWAvailable = false;
		  							helper.GetNextAuthenticationType(component, event, helper, memberid, MemberType, MaximumPointsAvailable, PointsObtained, IsKYMAvailable, IsOTPAvailable, IsDebitPinAvailable, IsOOWAvailable, IsPublicWalletAvailable, IsCFCUWalletAvailable);
		  							
		  						}
		  						
		  						component.set("v.MaximumPointsAvailable",MaximumPointsAvailable );
		  						component.set("v.PointsObtained",PointsObtained );
		  						 
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
	                       
	                        
	                        setTimeout(function () { 
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
	                        
	                        
			               }
		               }
	       	    
	       	    }
         
		});
		
		$A.enqueueAction(action);
    		
    		
    		
    	}
    	component.set("v.Likedisable",true);
    	
    
    },
    
   
	  
    InsertLogData: function(component, event,helper, memberid, decision, FDL, OverrideType, OverrideSupervisor, GUID, IVRGUIDFromUrl)
    {
    	var PhoneNumber = component.get("v.PhoneNumberEntered");
    	var MemberNumber = component.get("v.MemberNumberEntered");
    	var SSNNumber = component.get("v.MemberNumberEntered"); 
    	var action = component.get("c.InsertLogData");
    	var PageUrl='';
    	action.setParams({"MemberId": memberid,"Decision":decision, "FDL": FDL, "PhoneNumber":PhoneNumber,"EnteredSSN":SSNNumber,"PageUrl":PageUrl, "OverrideType":OverrideType, "OverrideSupervisor":OverrideSupervisor,"GUID": GUID,"IVRGUIDFromUrl": IVRGUIDFromUrl });
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
    
    GetNextAuthenticationType: function(component, event, helper, MemberId, MemberType, MaximumPointsAvailable, PointsObtained , IsKYMAvailable, IsOTPAvailable, IsDebitPinAvailable, IsOOWAvailable, IsPublicWalletAvailable, IsCFCUWalletAvailable){
    	var IVRGUIDFromUrl = component.get("v.IVRGUIDFromUrl");
    	if(IVRGUIDFromUrl == undefined){IVRGUIDFromUrl = '';}
    	var action = component.get("c.GetNextAuthenticationType");
    	action.setParams({"MemberId": MemberId,"MemberType":MemberType,"MaximumPointsAvailable":MaximumPointsAvailable,"PointsObtained": PointsObtained, "IsKYMAvailable": IsKYMAvailable, 
    						"IsOTPAvailable": IsOTPAvailable,"IsDebitPinAvailable":IsDebitPinAvailable,"IsOOWAvailable":IsOOWAvailable,"IsPublicWalletAvailable": IsPublicWalletAvailable,"IsCFCUWalletAvailable": IsCFCUWalletAvailable,"IVRGUIDFromUrl":IVRGUIDFromUrl});
    	 action.setCallback(this, function (response) {
		       	      		 var status = response.getState();            
	                               if (component.isValid() && status === "SUCCESS") {
	                            
	                                   var result = response.getReturnValue();
	                                   if(PointsObtained < result.ScoreRequired){
	                                	   component.set("v.ToGetHighestLevel",result.NextLevel);
	                                   }else{
	                                	   component.set("v.ToGetHighestLevel",'Level Achieved');
	                                   }
	                                    
	                                   	component.set("v.HighestAchievableLevel", result.LevelofAuthentication);
	                                   // component.set("v.MaximumPointsAvailable", MaximumPointsAvailable);
	                                    component.set("v.CurrentAuthenticationLevel", result.CurrentAuthenticationLevel);
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
	
		var action = component.get("c.getDataForReload");
		action.setParams({"memberid": memberid,"GUID":GUID,"IVRGUIDFromUrl":IVRGUIDFromUrl});
    	action.setCallback(this, function (response) {
		       	      		 var status = response.getState();            
	                               if (component.isValid() && status === "SUCCESS") {
	                            
	                                   var result = response.getReturnValue();
	                                   if(result.OOWLogData !=undefined){	                                   
		                                   if(result.OOWLogData.length > 0){
		                                	   component.set("v.IsOOWAvailableOnLoad",false);
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
	                                	   		if(result.PublicLogData[0].Public_Wallet_Status__c == 'passed'){
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
			                                	   		if(result.CFCULogData[0].CFCU_Wallet_Status__c == 'passed'){
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
			                                	   		if(result.OTPLogData[0].OTP_Status__c == 'passed'){
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
	                                	   	if(result.ScopePoints!= undefined){
			                                	   component.set("v.MaximumPointsAvailable",result.ScopePoints[0].Maximum_Points_Available__c);
			                                	   component.set("v.PointObtained",result.ScopePoints[0].Points_Obtained__c);
			                                	   component.set("v.CurrentAuthenticationLevel",result.ScopePoints[0].Current_Authentication_Level__c);
			                                	   component.set("v.HighestAchievableLevel",result.ScopePoints[0].Highest_Achievable_Level__c);
			                                	   component.set("v.ToGetHighestLevel",result.ScopePoints[0].Next_Level__c);
	                                	   		}
	                             }
	                                	   	
	                                   
	                                
	   	       		});	
	   	       
    	$A.enqueueAction(action); 
		
	},
	
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