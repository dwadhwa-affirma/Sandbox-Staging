({
	// Your renderer method overrides go here
		
	afterRender: function (component,helper) {
    this.superAfterRender();
    if(component.get("v.IspageOpenFromHomePage")== true){
    	document.getElementById('frmMemberNumber').value= component.get("v.AccountNumberFromHomePage");
    	
    }
       
   if(component.get("v.SSNFromURL") != undefined){
    	document.getElementById('frmSSN').value= component.get("v.SSNFromURL");
    }	
    	
    if(component.get("v.MemberNumberFromURL") != undefined){
    	document.getElementById('frmMemberNumber').value= component.get("v.MemberNumberFromURL");
    }
    if(component.get("v.PhoneFromURL") != undefined){
    	document.getElementById('frmPhoneNumber').value= component.get("v.PhoneFromURL");
    }
  
    // interact with the DOM here
},

rerender : function(component, helper){
    this.superRerender();
     
    	
    	if(component.get("v.isDoneRendering") == true){
        	var DebitCardStatus = component.get("v.DebitCardStatus");
	    	var IsVisible =  component.get("v.Visible");
	    	var CFCUWalletStatusForDay = component.get("v.CFCUWalletStatusForDay");
	    	var PublicWalletStatusForDay = component.get("v.PublicWalletStatusForDay");
	    	var OTPStatusForDay = component.get("v.IsOTPAvailableOnLoad");
	    	var OOWStatusForDay = component.get("v.OOWStatusForDay");
		    var element = document.getElementsByClassName('demo-only slds-box rightBox');
		    var IsUserSessionLoaded = component.get("v.IsUserSessionLoaded");
			if(element.length > 2)
			{
				var aElement;
				var liElement = element[2].getElementsByClassName("slds-tabs_default__item");
				
				for(var i=0 ; i < liElement.length; i++)
				{
					aElement = liElement[i].firstElementChild;
					
					
					//----------------------------------Public wallet -----------------------------------//
					
					if(aElement.id =='PublicWalletTab__item' && PublicWalletStatusForDay==false && component.get("v.PublicWalletColor") == 'Red'){
						liElement[i].classList.add("red");
						liElement[i].classList.remove("green");
			  			component.set('v.PWIconName','utility:close');
					}
					if(aElement.id =='PublicWalletTab__item' && PublicWalletStatusForDay==true && component.get("v.PublicWalletColor") == 'Green' ){
						liElement[i].classList.remove("red");
						liElement[i].classList.add("green");
						component.set('v.PWIconName','utility:check');
					}
					if(aElement.id =='PublicWalletTab__item' && PublicWalletStatusForDay==true && component.get("v.PublicWalletColor") == 'Grey'){
						liElement[i].classList.remove("red");
						liElement[i].classList.remove("green");	
						liElement[i].classList.add("grey");				
			  			component.set('v.PWIconName','utility:help');
					}
					
					
					//----------------------------------CFCU wallet -----------------------------------//
					
					if(aElement.id =='CFCUWalletTab__item' && CFCUWalletStatusForDay==false && component.get("v.CFCUWalletColor") == 'Red'){
						liElement[i].classList.add("red");
						liElement[i].classList.remove("green");
			  			component.set('v.CFCUIconName','utility:close');
					}
					if(aElement.id =='CFCUWalletTab__item' && CFCUWalletStatusForDay==true && component.get("v.CFCUWalletColor") == 'Green'){
						liElement[i].classList.remove("red");
						liElement[i].classList.add("green");
						component.set('v.CFCUIconName','utility:check');
					}
					if(aElement.id =='CFCUWalletTab__item' && CFCUWalletStatusForDay==true && component.get("v.CFCUWalletColor") == 'Grey'){
						liElement[i].classList.remove("red");
						liElement[i].classList.remove("green");	
						liElement[i].classList.add("grey");				
			  			component.set('v.CFCUIconName','utility:help');
					}
					
					
					
					//----------------------------------OTP -----------------------------------//
					
					if(aElement.id =='OTPTab__item' && OTPStatusForDay==false && component.get("v.OTPColor") == 'Red' ){
						liElement[i].classList.add("red");					
						liElement[i].classList.remove("green");
			  			component.set('v.OTPIconName','utility:close');
					}
					if(aElement.id =='OTPTab__item' && OOWStatusForDay == true && component.get("v.OTPColor") == 'Green'){
						liElement[i].classList.add("green");
						liElement[i].classList.remove("red");
						component.set('v.OTPIconName','utility:check');
					}
					if(aElement.id =='OTPTab__item' && OOWStatusForDay == true && component.get("v.OTPColor") == 'Grey'){
						liElement[i].classList.remove("red");
						liElement[i].classList.remove("green");
						liElement[i].classList.add("grey");	
			  			component.set('v.OTPIconName','utility:help');
					}
					
					
					if(aElement.id =='OTPTab__item' && component.get("v.OTPMessage") == 'YES' && component.get("v.OTPCancellAttept") > 1){
						liElement[i].classList.add("grey");
						liElement[i].classList.add("TabDisabled");
						liElement[i].classList.remove("green");
			  			liElement[i].classList.remove("slds-is-active");
			  			component.set('v.OTPIconName','utility:ban');
					}
					
					
					//----------------------------------OOW -----------------------------------//
					
					if(aElement.id =='OOWTab__item' && OOWStatusForDay == false && component.get("v.OOWColor") == 'Red'){
						liElement[i].classList.add("red");
						liElement[i].classList.remove("green");
						component.set('v.OOWIconName','utility:close');
					}
					if(aElement.id =='OOWTab__item' && OOWStatusForDay == true && component.get("v.OOWColor") == 'Green'){
						liElement[i].classList.add("green");
						liElement[i].classList.remove("red");
						component.set('v.OOWIconName','utility:check');
					}
					if(aElement.id =='OOWTab__item' && OOWStatusForDay == true && component.get("v.OOWColor") == 'Grey'){
						liElement[i].classList.remove("red");
						liElement[i].classList.remove("green");
						liElement[i].classList.add("grey");	
			  			component.set('v.OOWIconName','utility:help');
					}
					
					
					//----------------------------------Debit Card Pin -----------------------------------//
					
					if(DebitCardStatus =='false' && aElement.id =='DebitCardTab__item'){
						 liElement[i].classList.add("red");
						 liElement[i].classList.remove("slds-is-active");
			  			 component.set("v.DebitCardMessage", 'Member has failed the debit card authentication' );
			  			 component.set('v.DebitIconName','utility:close');
			  			 
					 }
					 if(DebitCardStatus =='true' && aElement.id =='DebitCardTab__item'){
						  liElement[i].classList.add("green");
						  liElement[i].firstChild.classList.remove("TabDisabled");
			  			  liElement[i].classList.remove("slds-is-active");
			  			  component.set("v.DebitCardMessage", 'Member has passed the debit card authentication' );
			  			  component.set('v.DebitIconName','utility:check');
			  			  
					 }
					  if((DebitCardStatus == undefined || DebitCardStatus == '') && aElement.id =='DebitCardTab__item'){
						  liElement[i].classList.add("grey");
						  liElement[i].classList.add("TabDisabled");
			  			  liElement[i].classList.remove("slds-is-active");
			  			  component.set("v.DebitCardMessage", 'Member has passed the debit card authentication' );
			  			  component.set('v.DebitIconName','utility:ban');
			  			 
					 }
				}
				
			   component.set("v.PublicWalletColor",'');
			   component.set("v.CFCUWalletColor",'');
			   component.set("v.OOWColor",'');
			   component.set("v.OTPColor",'');
		    }
		}
		
},

})