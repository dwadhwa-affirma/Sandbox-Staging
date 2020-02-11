({
	doInit : function(component, event,helper) {
	
		// URL Encoding........................................................................................
		
		var url= window.location.href;
		var pageReference = component.get("v.pageReference");
	
		component.set("v.SSNFromURL", pageReference.state.c__EnteredSSN);
		component.set("v.MemberNumberFromURL", pageReference.state.c__EnteredMemberNumber);
		component.set("v.PhoneFromURL", pageReference.state.c__CallersPhoneNumber);
		component.set("v.DebitCardStatus", pageReference.state.c__PINMatch);
		var SSNFromURL = component.get("v.SSNFromURL");
		var MemberNumberFromURL =  component.get("v.AccountNumberFromURL");
		var PhoneFromURL =  component.get("v.PhoneFromURL");
		
		if(SSNFromURL != undefined || MemberNumberFromURL != undefined || PhoneFromURL != undefined){
			component.set("v.PageURL", url);
		}
		
		    
		// URL Encoding........................................................................................
		
		component.set("v.IsRightDivVisible", false);
		var MemberIdFromHomePage = component.get("v.MemberIdFromHomePage");
		var IspageOpenFromHomePage = component.get("v.IspageOpenFromHomePage");
		var AccountNumberFromHomePage = component.get("v.AccountNumberFromHomePage");
	
		//var membertype ='Foreign';// this need to replace from url
	
		//var membertype ='Domestic';
		
		
		//component.set("v.Membertype",membertype );
		
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
				
			//	document.getElementById('frmMemberNumber').value= MemberNumber; 
				helper.getMemberSearch(component, event,'',MemberNumber,'','');
		}
		
		
		    var DebitCardStatus = component.get("v.DebitCardStatus");
		
			if(DebitCardStatus == 'true' || DebitCardStatus == 'false'){
				component.set("v.IsCFCUSectionVisible",false);
				
			}
			else{
				component.set("v.IsCFCUSectionVisible",true);
				
			}		
	},
	
	LastAcheivableLogs : function(component, event, memberid, GUID, LastLevel)
	{
		var action = component.get("c.SaveLastAchievableLevelLogs");
		action.setParams({"MemberId": memberid, "GUID" : GUID, "LastLevel": LastLevel });
		action.setCallback(this, function (response) {
  		 var status = response.getState();            
               if (component.isValid() && status === "SUCCESS") {
                   var result = response.getReturnValue();
                 }	
			});
   
    	$A.enqueueAction(action);
	},
	
	MemberVerificationAttemptCheck : function(component, event, helper, memberid, DebitCardStatus)
	{
		
		var GUID = component.get("v.GUID");
		var action = component.get("c.MemberVerificationAttemptsCheck");
		
		var SSNFromURL = component.get("v.SSNFromURL");
		var MemberNumberFromURL = component.get("v.MemberNumberFromURL");
		var PhoneFromURL = component.get("v.PhoneFromURL");
		var PageURL = component.get("v.PageURL");
		var DebitCardStatus = component.get("v.DebitCardStatus");
		if(PageURL == undefined){
			action.setParams({"MemberId": memberid,"GUID": GUID,"DebitCardStatus": DebitCardStatus,"SSNFromURL": ' ',"MemberNumberFromURL": ' ',"PhoneFromURL": ' ', "PageURL" : ' '});
		}
		else{
			action.setParams({"MemberId": memberid,"GUID": GUID,"DebitCardStatus": DebitCardStatus,"SSNFromURL": SSNFromURL,"MemberNumberFromURL":MemberNumberFromURL,"PhoneFromURL":PhoneFromURL,"PageURL":PageURL});
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
					    component.set("v.IsOOWAvailableOnLoad",result['OOWStatusForDay']);
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
					    					    
					    if(result.MemberType == 'Foreign')
					    {
					    	 component.set("v.IsOOWAvailableOnLoad", false);
					    }
					    else
					    {
					    	component.set("v.IsOOWAvailableOnLoad", true);
					    }
		     		    if(result.OTPAttemptCount > 0){
                			component.set("v.OTPMessage",'YES');
                		}
                		else{
                			component.set("v.OTPMessage",'NO');
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
 
	getMemberSearch : function(component, event,PhoneNumber,MemberNumber,SSNNumber,DOBNumber)
	{
		  
		   var action = component.get("c.getMemberSearchData");
		   var parameters = {"PhoneNumber": PhoneNumber,"MemberNumber" : MemberNumber,"SSNNumber" : SSNNumber,"DOBNumber":DOBNumber };
		
		   action.setParams(parameters);
		   action.setCallback(this, function(response){
		   		var status = response.getState();
		    	if(component.isValid() && status === "SUCCESS"){
		    	
						var result =  response.getReturnValue();
				  //      var ScoringModelLength = result['ScoringModel'].length;
				        component.set("v.GUID",result.GUID);
						
						
					    if(result.Account.length > 0){
						    
						    component.set("v.accounts", result['Account']);
					        component.set("v.IsMatchingMemberFound", true);
					    	component.set("v.IsDOBValid" , true);
					    	
					    	/*if(ScoringModelLength > 0){
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
							}*/
						}
						
						else{						
								component.set("v.IsMatchingMemberFound", false);
								component.set("v.IsDOBValid" , false);
								component.set("v.PhoneNumberEntered","");
							    component.set("v.MemberNumberEntered","");
							    component.set("v.SSNEntered","");
							    component.set("v.DOBEntered","");
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
						var DOBDiv = document.getElementById('DOBDiv');
						if((DOBNumber !=undefined && DOBNumber != '') && IsMatchingMemberFound == false){
							
						    	DOBDiv.firstElementChild.classList.remove("hidden");
						    	//DOBDiv.firstElementChild.classList.add("show");
						    	
						    	//component.set("v.IsDOBValid",false);
						    }
						else if((DOBNumber !=undefined && DOBNumber != '') && IsMatchingMemberFound == true){
						   
						    	
						    	DOBDiv.firstElementChild.classList.add("hidden");
						    	
						    	component.set("v.IsDOBValid",true);
						  }
						  else {						    
						    	component.set("v.IsDOBValid",false);
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
    
    LoadOOWComponent: function (component, event, helper, memberid, GUID) {
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
		                          action1.setParams({"status": status, "MemberNumber": membernumber,"MemberId":memberid, "reason":reason,"notes":notes, "GUID": GUID,"name": name,"Error":Error});
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
    
   
		
	  myDOBFunction : function(component, event, dobvalue ) {
        var str = dobvalue.replace(/-/g,'');
        if (str == '')
        {
            message = 'Please enter correct date.';
        	return message;
        }        
        var strlength = str.length; 
        var message = '';
        	if(strlength != 8){
              message = 'Please enter a valid date MMDDYYYY';
              return message;
            }
            var Month = str.slice(0,2);
            var Monthlength = Month.length;
            if(Monthlength<0 || Monthlength > 2 || (Month <1 || Month >12)){
                message = 'Please enter correct month';
                return message;
            }
            
            var subString2 = str.slice(2,4);
            var date = subString2;
            var datelength = date.length;
            if(datelength < 0 || datelength > 2 || date < 1 || date >31){
                
                message = 'Please enter correct date';
                return message;
            }
            var d = new Date();
            var n = d.getFullYear();
            
            var year = str.slice(4,str);
            var yearlength = year.length;
            if(yearlength != 4 || year>n){
                
                message = 'Please enter correct year';
                return message;
            }
           
        var newDate = Month + '-' + date + '-' + year;
        
	    document.getElementById("frmDOB").value = newDate;
	   
        return message;
       
    },
    InsertLogData: function(component, event,helper, memberid, decision, FDL, OverrideType, OverrideSupervisor, GUID)
    {
    	var PhoneNumber = component.get("v.PhoneNumberEntered");
    	var MemberNumber = component.get("v.MemberNumberEntered");
    	var SSNNumber = component.get("v.MemberNumberEntered"); 
    	var DOBEntered = component.get("v.DOBEntered");
    	var action = component.get("c.InsertLogData");
    	var PageUrl='';
    	action.setParams({"MemberId": memberid,"Decision":decision, "FDL": FDL, "PhoneNumber":PhoneNumber,"EnteredSSN":SSNNumber,"DOB":DOBEntered,"PageUrl":PageUrl, "OverrideType":OverrideType, "OverrideSupervisor":OverrideSupervisor,"GUID": GUID });
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
    
    SaveCaseWithLogData: function(component, event, helper, memberid, accountnumber,CaseComment, AccountId, GUID)
    {
    	var action = component.get("c.SaveCaseWithLogData");
    	action.setParams({"MemberId": memberid,"AccountNumber":accountnumber,"casecomment":CaseComment,"AccountId": AccountId,"GUID":GUID});
    	 action.setCallback(this, function (response) {
		       	      		 var status = response.getState();            
	                               if (component.isValid() && status === "SUCCESS") {
	                            
	                                   var result = response.getReturnValue();
	                                  
	                                }
	   	       				});	
	   	       
	   	      					 $A.enqueueAction(action); 
    		
    },
    
    GetNextAuthenticationType: function(component, event, helper, MemberId, MemberType, MaximumPointsAvailable, PointsObtained , IsKYMAvailable, IsOTPAvailable, IsDebitPinAvailable, IsOOWAvailable, IsPublicWalletAvailable, IsCFCUWalletAvailable){
    	
    	var action = component.get("c.GetNextAuthenticationType");
    	action.setParams({"MemberId": MemberId,"MemberType":MemberType,"MaximumPointsAvailable":MaximumPointsAvailable,"PointsObtained": PointsObtained, "IsKYMAvailable": IsKYMAvailable, 
    						"IsOTPAvailable": IsOTPAvailable,"IsDebitPinAvailable":IsDebitPinAvailable,"IsOOWAvailable":IsOOWAvailable,"IsPublicWalletAvailable": IsPublicWalletAvailable,"IsCFCUWalletAvailable": IsCFCUWalletAvailable});
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
	
})