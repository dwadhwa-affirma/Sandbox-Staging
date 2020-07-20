({
	doInit : function(component, event, helper) {
		//helper.buildPicklist(component, "CountryList");
		 helper.createObjectData(component, event);
		//helper.getDetails(component);
		helper.getCardDetails(component);	
		//var email = document.getElementById('txtEmail');
		//email.addAttribute("disabled");	
	},
	
	moveNext : function(component,event,helper){
     // control the next button based on 'currentStep' attribute value    
     var getCurrentStep = component.get("v.currentStep");
        if(getCurrentStep == "1"){  
          var selectedcards =  component.get("v.selectedCheckBoxes");
          if(selectedcards.length <= 0)
          {
        	  component.set("v.popoverMessage", "Please Select at least one card ");   
        	  var popover = component.find("popover");
          		$A.util.removeClass(popover,'slds-hide');
          		
          }   
          else{
            component.set("v.currentStep", "2");    
            }    
        }
        else if(getCurrentStep == 2){
        var data= component.get("v.travelDetails");
        var missingdata=false;
        var overlappeddates=false;
        for(var i=0;i<data.length;i++){
        	if(data[i].Departure_Date__c == ""){
        		missingdata =true;
        		break;
        	}
        	if(data[i].Return_Date__c == ""){
        		missingdata =true;
        		break;
        	}
        	if(data[i].State__c == "" && data[i].Country__c == ""){
        		missingdata =true;
        		break;
        	}
        	if(data[i].Destination__c == ""){
        		missingdata =true;
        		break;
        	}
        }
        for(var i=0;i<data.length;i++){
        	 for(var j=0;j<data.length;j++){
        		 if(i!=j)
        		 {
        			 if(data[j].Departure_Date__c >= data[i].Departure_Date__c && data[j].Departure_Date__c <= data[i].Return_Date__c)
        			 {
        				 overlappeddates =true;
        				 break;
        			 }
        			 if(data[j].Return_Date__c >= data[i].Departure_Date__c && data[j].Return_Date__c <= data[i].Return_Date__c)
        			 {
        				 overlappeddates =true;
        				 break;
        			 }
        		 }
        	 }
        	
         }
        if(missingdata){
        		component.set("v.popoverMessage", "Please Enter All Details");   
        	  var popover = component.find("popover");
          		$A.util.removeClass(popover,'slds-hide')
        }
        else if(overlappeddates){
        		component.set("v.popoverMessage", "Each travel destination requires unique dates. Please select different start and end date.");   
        	  var popover = component.find("popover");
          		$A.util.removeClass(popover,'slds-hide')
        }
        else{
            component.set("v.currentStep", "3");  
            var td =   component.get("v.travelDetails");
            component.set("v.travelDetails", td);   
            } 
        /* var destinations =  component.get("v.addedDestinations");
         var departuredate = component.get("v.DepartureDate");
         var returndate = component.get("v.ReturnDate");
         var errorstr="";
         if(destinations.length == 0){
        	 if(errorstr == "")
        	 errorstr += "Destination";
        	 else
        	 errorstr += ", Destination";
          }
          if(departuredate == undefined){ 
        	  if(errorstr == "")
        	 errorstr += "Departure Date";
        	 else
        	 errorstr += ", Departure Date";
          }
           if(returndate == undefined){ 
        	   if(errorstr == "")
        	 errorstr += "Return Date";
        	 else
        	 errorstr += ", Return Date";
           }
         if(destinations.length == 0 || departuredate == undefined || returndate == undefined){
        	  component.set("v.popoverMessage", "Please Enter following Details: " + errorstr);   
        	  var popover = component.find("popover");
          		$A.util.removeClass(popover,'slds-hide');
         }
          else{
            component.set("v.currentStep", "3");    
            }     */   
           // component.set("v.currentStep", "3");         
        }
        else if(getCurrentStep == 3){
         
          var traveldetailsobj=component.get("v.travelDetails");
        	if(traveldetailsobj.Email__c == '' && traveldetailsobj.IsEmailPreferred__c == true){
        	  component.set("v.popoverMessage", "Please Enter Email Address");   
        	  var popover = component.find("popover");
          		$A.util.removeClass(popover,'slds-hide');
          		var btn = document.getElementById('btnNext');
		       btn.disabled = true;	
        	}
        	else if(traveldetailsobj.US_Mobile_Number__c == '' && traveldetailsobj.IsPhonePreferred__c == true){
        		component.set("v.popoverMessage", "Please Enter Phone No");   
        	   var popover = component.find("popover");
          		$A.util.removeClass(popover,'slds-hide');
          		var btn = document.getElementById('btnNext');
		       btn.disabled = true;	
        	}
        	else if(traveldetailsobj.US_Mobile_Number__c == '' && traveldetailsobj.Email__c == ''){
        		component.set("v.popoverMessage", "Please Enter Either Email or Phone No");   
        	   var popover = component.find("popover");
          		$A.util.removeClass(popover,'slds-hide');
          		var btn = document.getElementById('btnNext');
		       btn.disabled = true;	
        	}
        	else
        	{
        		component.set("v.currentStep", "4");
        		var popover = component.find("popover");
        		$A.util.addClass(popover,'slds-hide');
        		var btn = document.getElementById('btnNext');
		       btn.disabled = false;	
            }
        }
    },
    
    closePopup: function(component, event, helper) {
	  $A.get('e.force:closeQuickAction').fire();
   }, 
    
     selectAllCard: function(component, event, helper) {
     debugger;
      var selectedCheckBoxes =  component.get("v.selectedCheckBoxes");  
    	 var checkboxes = document.getElementsByClassName("chkCard");
    	 var selectallEleVal = component.get("v.checkAllCard");
    	 if(selectallEleVal == true){
    	   var popover = component.find("popover");
          		$A.util.addClass(popover,'slds-hide');
    		 for(var i=0;i<checkboxes.length;i++)
    		 {
    			 checkboxes[i].checked =true;
    			 if(selectedCheckBoxes.indexOf(checkboxes[i].value) > -1){            
        			//selectedCheckBoxes.splice(selectedCheckBoxes.indexOf(checkboxes[i].value), 1);           
    			}
	   			else{
	      				selectedCheckBoxes.push(checkboxes[i].value);
	  			  }
    			 component.set("v.selectedCheckBoxes", selectedCheckBoxes);
    		 }
    	 }            
         else{
         for(var i=0;i<checkboxes.length;i++)
    		 {
    			 checkboxes[i].checked =false;
    			 if(selectedCheckBoxes.indexOf(checkboxes[i].value) > -1){            
        			selectedCheckBoxes.splice(selectedCheckBoxes.indexOf(checkboxes[i].value), 1);         			
    			}   			
    			 component.set("v.selectedCheckBoxes", selectedCheckBoxes);
    		 }
         }
        	
   }, 
    selectCard: function(component, event, helper) {
      if(event.getSource().get("v.checked"))   { 
       var popover = component.find("popover");
      $A.util.addClass(popover,'slds-hide');
    	  var capturedCheckboxName = event.getSource().get("v.value");
   		  var selectedCheckBoxes =  component.get("v.selectedCheckBoxes");   		
    		if(selectedCheckBoxes.indexOf(capturedCheckboxName) > -1){            
        			selectedCheckBoxes.splice(selectedCheckBoxes.indexOf(capturedCheckboxName), 1);           
    			}
   			else{
      				selectedCheckBoxes.push(capturedCheckboxName);
  			  }
    		component.set("v.selectedCheckBoxes", selectedCheckBoxes);
      }
      else
    		{
    			var capturedCheckboxName = event.getSource().get("v.value");
    			var selectedCheckBoxes =  component.get("v.selectedCheckBoxes");
    			
    			if(selectedCheckBoxes.indexOf(capturedCheckboxName) > -1){            
        			selectedCheckBoxes.splice(selectedCheckBoxes.indexOf(capturedCheckboxName), 1);         			
    			}   			
    		component.set("v.selectedCheckBoxes", selectedCheckBoxes);
    		}
    	
   }, 

   
   editInfo: function(component,event,helper){   
	  // component.set("v.isDisabled", false);
	   component.set("v.currentStep", "1");
	    var popover = component.find("popover");
			$A.util.addClass(popover,'slds-hide');
			component.set("v.isSubmitDisabled",false); 
   },
   
   changeDestination: function(component,event,helper){
	   			var sele = document.getElementById('pickState');
	   			var cele = document.getElementById('pickCountry');
	   		var val =component.get("v.travelDetails.Destination__c");
	   		
	   		 var array = component.get("v.addedDestinations");	  
   			
    		component.set("v.addedDestinations", array);
	   		if(val == "Domestic"){
	   			cele.style = 'display:none;';
	   			sele.style = '';
	   			array.splice(0,array.length)
	   			component.set("v.addedDestinations", array);
	   		}
	   		else if(val == "International"){
	   			array.splice(0,array.length)
	   			component.set("v.addedDestinations", array);
	   			sele.style = 'display:none;';
	   			cele.style = '';
	   		}
	   		else
	   		{
	   			cele.style = 'display:none;';
	   			sele.style = 'display:none;';
	   		}
   },
   addDestination: function(component,event,helper){	
   debugger;   
	   var val =component.get("v.travelDetails.Destination__c");
	   var selectedVal;
	   if(val == "Domestic"){
		   selectedVal = component.get("v.travelDetails.State__c");
	   }
	   else if(val == "International"){
		   selectedVal = component.get("v.CountryValue");
	   }
	   
	  
	   var array = component.get("v.addedDestinations");
	   if(selectedVal != ""){
	   if(array.indexOf(selectedVal) < 0){            
        			array.push(selectedVal);         
    			}
    			}
    		
	   //array.push(selectedVal);                    	
	   component.set("v.addedDestinations", array);	  
	   var div =  document.getElementById('divAddedDestinations');
	   div.style = '';
	   if(array.length !=0){
		   var popover = component.find("popover");
			$A.util.addClass(popover,'slds-hide');
	   }
   },
   
   deleteDestination: function(component,event,helper){
	   var dataindex = event.target.getAttribute("data-row-index");
	   var ele= document.getElementById(dataindex); 
	   var deletedVal = ele.firstChild.getElementsByTagName('button')[0].innerText;
	   
	   var array = component.get("v.addedDestinations");
	   if(array.indexOf(deletedVal) > -1){            
        			array.splice(array.indexOf(deletedVal), 1);           
    		}
   			
    		component.set("v.addedDestinations", array);
	   
	 //  document.getElementById("tblDestination").deleteRow(0);
   },
   
   saveTravelNotificationData: function(component,event,helper){
	   component.set("v.isSubmitDisabled",true);	   
	   var ele = document.getElementById('btnEdit');
	   ele.style = 'display:none;';	
	   var selectedCards = component.get("v.selectedCheckBoxes") ;
	   var traveldetailsobj=component.get("v.travelDetails");
	   var finaltravelDetailsobj = [];
	   for(var i=0; i<traveldetailsobj.length;i++){
		   finaltravelDetailsobj.push({
			Country__c: traveldetailsobj[i].Country__c,
			Departure_Date__c: traveldetailsobj[i].Departure_Date__c,
			Destination__c: traveldetailsobj[i].Destination__c,
			Return_Date__c: traveldetailsobj[i].Return_Date__c,
			State__c: traveldetailsobj[i].State__c,
			Email__c: traveldetailsobj.Email__c,
			IsEmailPreferred__c: traveldetailsobj.IsEmailPreferred__c,
			IsPhonePreferred__c: traveldetailsobj.IsPhonePreferred__c,
			US_Mobile_Number__c: traveldetailsobj.US_Mobile_Number__c,
			Timezone__c: traveldetailsobj[i].Timezone__c			
			});
	   }
	   component.set("v.finaltravelDetails", finaltravelDetailsobj);
	 //  var selecteddestinations = component.get("v.addedDestinations");
	  // var finalselecteddestinations = selecteddestinations.join(', ');
	  var ele = document.getElementById('divloading');
	  ele.style = '';
	 // component.set("v.loading", true);
	  helper.MCAPICallout(component, selectedCards,finaltravelDetailsobj);
	  // helper.saveTravelNotification(component, selectedCards,finaltravelDetailsobj);	
   },
   
   addNewRow: function(component, event, helper) {
        // call the comman "createObjectData" helper method for add new Object Row to List  
        helper.createObjectData(component, event);
    },
 
    // function for delete the row 
    removeDeletedRow: function(component, event, helper) {
        // get the selected row Index for delete, from Lightning Event Attribute  
        var index = event.getParam("indexVar");
        // get the all List (contactList attribute) and remove the Object Element Using splice method    
        var AllRowsList = component.get("v.travelDetails");
        AllRowsList.splice(index, 1);
        // set the contactList after remove selected row element  
        component.set("v.travelDetails", AllRowsList);
    },
    
    validateRequiredDetails: function(component, event, helper) {
     var data= component.get("v.travelDetails");
        var missingdata=false;
        var invalidDate=false;
         var invalidVacationLength=false;
        var pastdate=false;
        var today = new Date();
        	var dd = today.getDate();
        	var mm = today.getMonth()+1; //January is 0!
        	var yyyy = today.getFullYear();
        if(dd<10) {
        	dd = '0'+dd;
        	}
		if(mm<10) {
		    mm = '0'+mm;
		} 
        var todaydate = yyyy + '-' + mm + '-' + dd;
        for(var i=0;i<data.length;i++){
        	if(data[i].Departure_Date__c == ""){
        		missingdata =true;
        		break;
        	}
        	if(data[i].Return_Date__c == ""){
        		missingdata =true;
        		break;
        	}
        	if(data[i].State__c == "" && data[i].Country__c == ""){
        		missingdata =true;
        		break;
        	}
        	if(data[i].Destination__c == ""){
        		missingdata =true;
        		break;
        	}
        }
        if(!missingdata){
        		var popover = component.find("popover");
			$A.util.addClass(popover,'slds-hide');
        }
        for(var i=0;i<data.length;i++){
        	if((data[i].Return_Date__c != "" && data[i].Departure_Date__c != "") && (data[i].Return_Date__c <= data[i].Departure_Date__c)){
        		invalidDate =true;        		
        	}  
        	if((data[i].Return_Date__c != "" && data[i].Departure_Date__c != "") ){
        		 //Get 1 day in milliseconds
				  var one_day = 1000 * 60 * 60 * 24;

				// Convert both dates to milliseconds
				var date2_ms = new Date(data[i].Return_Date__c).getTime();
				var date1_ms = new Date(data[i].Departure_Date__c).getTime();

				// Calculate the difference in milliseconds
				var difference_ms = date2_ms - date1_ms;

				// Convert back to days and return
				if (Math.round(difference_ms/one_day) > 365){
					invalidVacationLength = true;
				} 
        	}
        	if(data[i].Departure_Date__c != ""){
        		var d_Date = new Date(data[i].Departure_Date__c);
        		d_Date = new Date(d_Date.getTime() + (d_Date.getTimezoneOffset() * 60000));
        		//d_Date = Date.parse();
        		var s_mm =d_Date.getMonth()+1, s_dd = d_Date.getDate();
        		if(s_dd<10) {
        				s_dd = '0'+s_dd;
        			}
        		if(s_mm<10) {
        			s_mm = '0'+s_mm;
        		} 
        		var s_date = d_Date.getFullYear() + "-" + (s_mm) + "-" + s_dd;
	        	if(s_date < todaydate){
	        		pastdate= true;
	        	} 
        	}     	     	
        }
        if(invalidDate){
        	component.set("v.popoverMessage", "To Date Should be Greater than From Date");   
        	 var popover = component.find("popover");
          		$A.util.removeClass(popover,'slds-hide');
          		var btn = document.getElementById('btnNext');
		       btn.disabled = true;	
        }
        if(invalidVacationLength){
        	component.set("v.popoverMessage", "The travel notice cannot be longer than 365 days");   
        	 var popover = component.find("popover");
          		$A.util.removeClass(popover,'slds-hide');
          		var btn = document.getElementById('btnNext');
		       btn.disabled = true;	
        }
       // else if(!invalidDate){
        //	var popover = component.find("popover");
		//	$A.util.addClass(popover,'slds-hide');
       // }
        if(pastdate){
        	component.set("v.popoverMessage", "From Date can not be in the past");   
        	 var popover = component.find("popover");
          		$A.util.removeClass(popover,'slds-hide');
          		var btn = document.getElementById('btnNext');
		       btn.disabled = true;	
        }
        if(!pastdate && !invalidDate && !invalidVacationLength){
        	var popover = component.find("popover");
			$A.util.addClass(popover,'slds-hide');
			var btn = document.getElementById('btnNext');
		    btn.disabled = false;	
        }
       
    },
    
    detailsTab: function(component, event, helper) {
        helper.clearAll(component, event);
        //make fruits tab active and show tab data
        component.find("detailsTab").getElement().className = 'slds-tabs--scoped__item slds-active customClassForTab slds-text-title--caps';
        component.find("detailsTabDataId").getElement().className = 'slds-tabs--scoped__content slds-show customClassForTabData';
        component.set("v.currentTab", "1");
    },
    editTab: function(component, event, helper) { 
    if(event.source != undefined){
    var eventtype= event.getParams().EventType;
    if(eventtype == 'Refresh' || eventtype == 'RefreshEvt'){ 
    	var ele = document.getElementById('divloading');
		ele.style = '';
        helper.clearAll(component, event);        
        //make vegetables tab active and show tab data
        component.find("editTab").getElement().className = 'slds-tabs--scoped__item slds-active customClassForTab slds-text-title--caps';
        component.find("editTabDataId").getElement().className = 'slds-tabs--scoped__content slds-show customClassForTabData';
        
        helper.getCurrentTravelPlans(component);
             
		ele.style = 'display:none;';
		}
	else if(eventtype == 'Error'){
	var errormessage = event.getParams().ErrorMessage;
			component.set("v.popoverMessage", errormessage);   
			var popover = component.find("popover");
			$A.util.removeClass(popover,'slds-hide');
			$A.util.addClass(popover,'errorDelete');			
		}
	}
	else
	{
	    var ele = document.getElementById('divloading');
		ele.style = '';
           
		component.set("v.currentTab", "2"); 
		helper.clearAll(component, event);   
		    
        //make vegetables tab active and show tab data
        component.find("editTab").getElement().className = 'slds-tabs--scoped__item slds-active customClassForTab slds-text-title--caps';
        component.find("editTabDataId").getElement().className = 'slds-tabs--scoped__content slds-show customClassForTabData';
        
        helper.getCurrentTravelPlans(component);
            
		
		 var popover = component.find("popover");
	     $A.util.addClass(popover,'slds-hide');
	}
    },

    editDetails: function(component, event, helper) {
        //helper.clearAll(component, event);
        component.set('v.editIndex', 1);
        debugger;
        
        //make fruits tab active and show tab data
      /*  component.find("detailsTab").getElement().className = 'slds-tabs--scoped__item slds-active customClassForTab slds-text-title--caps';
        component.find("detailsTabDataId").getElement().className = 'slds-tabs--scoped__content slds-show customClassForTabData';
        component.set("v.currentTab", "1");
        component.set("v.isEditClicked", true);
        component.set("v.currentStep", "1");*/
    },
    hideErrorMessage: function(component, event, helper) {
    	var popover = component.find("popover");
			$A.util.addClass(popover,'slds-hide');
			
    },
    ClearData: function(component, event, helper) {
    	helper.deleteObjectData(component, event);   
	    component.set("v.DepartureDate",'') ;
	    component.set("v.ReturnDate",'') ;
	   component.set("v.currentStep",'1');
	   component.set("v.currentTab",'1');
      
       var selectedCheckBoxes =  component.get("v.selectedCheckBoxes");  
    	 var checkboxes = document.getElementsByClassName("chkCard");
    	 var selectallEleVal = component.get("v.checkAllCard");    	          
        
         for(var i=0;i<checkboxes.length;i++)
    		 {
    			 checkboxes[i].checked =false;
    			 if(selectedCheckBoxes.indexOf(checkboxes[i].value) > -1){            
        			selectedCheckBoxes.splice(selectedCheckBoxes.indexOf(checkboxes[i].value), 1);         			
    			}   			
    			 component.set("v.selectedCheckBoxes", selectedCheckBoxes);
    		 }
         
    },
    
    moveBack : function(component,event,helper){
     // control the next button based on 'currentStep' attribute value    
     var getCurrentStep = component.get("v.currentStep");
        if(getCurrentStep == "2"){
            component.set("v.currentStep", "1");      
        }
        if(getCurrentStep == "3"){
            component.set("v.currentStep", "2");      
        }
       
 
 },
 
 validateEmail : function(component, event, helper) {
	 	var traveldetailsobj=component.get("v.travelDetails");
        var Email = traveldetailsobj.Email__c;
		var isValidEmail = true;
      
        var emailFieldValue = Email;
        // Store Regular Expression That 99.99% Works. [ http://emailregex.com/] 
        var regExpEmailformat = /^(([^<>()\[\]\\.,;:\s@"]+(\.[^<>()\[\]\\.,;:\s@"]+)*)|(".+"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$/;  
        // check if Email field in not blank,
        // and if Email field value is valid then set error message to null, 
        // and remove error CSS class.
        // ELSE if Email field value is invalid then add Error Style Css Class.
        // and set the error Message.  
        // and set isValidEmail boolean flag value to false.
        
        if(!$A.util.isEmpty(emailFieldValue)){   
            if(emailFieldValue.match(regExpEmailformat)){			 
              isValidEmail = true;
        }else{           
             isValidEmail = false;
        }
       }
        
     if(!isValidEmail){
    	 	component.set("v.popoverMessage", 'Please Enter a Valid Email Address');   
			var popover = component.find("popover");
			$A.util.removeClass(popover,'slds-hide');
			var btn = document.getElementById('btnNext');
		    btn.disabled = true;
     }
     else{
    	 var popover = component.find("popover");
			$A.util.addClass(popover,'slds-hide');
			var btn = document.getElementById('btnNext');
		    btn.disabled = false;
     }
	},

validatePhone : function(component, event, helper) {
	 	var traveldetailsobj=component.get("v.travelDetails");
        var PhoneNo = traveldetailsobj.US_Mobile_Number__c;
		var isValidPhone = true;
      
        var phoneFieldValue = PhoneNo;
        // Store Regular Expression That 99.99% Works. [ http://emailregex.com/] 
        var regExpPhoneformat = /^[\+]?[(]?[0-9]{3}[)]?[-\s\.]?[0-9]{3}[-\s\.]?[0-9]{4,6}$/im;  
        // check if Email field in not blank,
        // and if Email field value is valid then set error message to null, 
        // and remove error CSS class.
        // ELSE if Email field value is invalid then add Error Style Css Class.
        // and set the error Message.  
        // and set isValidEmail boolean flag value to false.
        
        if(!$A.util.isEmpty(phoneFieldValue)){   
            if(phoneFieldValue.match(regExpPhoneformat)){			 
              isValidPhone = true;
        }else{           
             isValidPhone = false;
        }
       }
        
     if(!isValidPhone){
    	 	component.set("v.popoverMessage", 'Please Enter a Valid Phone No');   
			var popover = component.find("popover");
			$A.util.removeClass(popover,'slds-hide');
			var btn = document.getElementById('btnNext');
		    btn.disabled = true;
     }
     else{
    	 var popover = component.find("popover");
			$A.util.addClass(popover,'slds-hide');
			var btn = document.getElementById('btnNext');
		    btn.disabled = false;
     }
	},

})