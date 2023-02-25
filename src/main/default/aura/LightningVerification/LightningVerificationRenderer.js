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
			var KYMStatusForDay = component.get("v.KYMStatusForDay");
	    	var OTPStatusForDay = component.get("v.IsOTPAvailableOnLoad");
	    	var OOWStatusForDay = component.get("v.OOWStatusForDay");
		    var element = document.getElementsByClassName('demo-only slds-box rightBox');
		    var IsUserSessionLoaded = component.get("v.IsUserSessionLoaded");
		    console.log('Renderer 38---DebitCardStatus' + DebitCardStatus);
		    console.log('Renderer 39---CFCUWalletStatusForDay' + CFCUWalletStatusForDay);
		    console.log('Renderer 40---PublicWalletStatusForDay' + PublicWalletStatusForDay);
		    console.log('Renderer 41---OTPStatusForDay' + OTPStatusForDay);
		    console.log('Renderer 42---OOWStatusForDay' + OOWStatusForDay);
		    console.log('Renderer 43---IsUserSessionLoaded' + IsUserSessionLoaded);
			if(element.length > 2)
			{
				var aElement;
				var liElement = element[2].getElementsByClassName("slds-tabs_default__item");
				
				for(var i=0 ; i < liElement.length; i++)
				{
					aElement = liElement[i].firstElementChild;
					//----------------------------------KYM wallet -----------------------------------//
					console.log('Renderer 55---KYMTab__item' + component.get("v.KYMColor"));
					if(aElement.id =='KYMTab__item' && KYMStatusForDay==false && component.get("v.KYMColor") == 'Grey'){
						console.log('Renderer 57---KYMTab__item' + KYMStatusForDay);
						liElement[i].classList.add("grey");
						liElement[i].classList.remove("green");
			  			component.set('v.KYMIconName','utility:close');
			  			helper.RedrawComponent(liElement[i]);
					}
					if(aElement.id =='KYMTab__item' && KYMStatusForDay==true && component.get("v.KYMColor") == 'Green' ){
						console.log('Renderer 64---PublicWalletTab__item' + KYMStatusForDay);
						liElement[i].classList.remove("grey");
						liElement[i].classList.add("green");
						component.set('v.KYMIconName','utility:check');
						helper.RedrawComponent(liElement[i]);
					}
					if(aElement.id =='KYMTab__item' && KYMStatusForDay==true && component.get("v.KYMColor") == 'Grey'){
						console.log('Renderer 71---PublicWalletTab__item' + KYMStatusForDay);
						liElement[i].classList.remove("red");
						liElement[i].classList.remove("green");	
						liElement[i].classList.add("grey");				
			  			component.set('v.KYMIconName','utility:help');
			  			helper.RedrawComponent(liElement[i]);
					}
					
					//----------------------------------Public wallet -----------------------------------//
					console.log('Renderer 55---PublicWalletTab__item' + component.get("v.PublicWalletColor"));
					if(aElement.id =='PublicWalletTab__item' && PublicWalletStatusForDay==false && component.get("v.PublicWalletColor") == 'Red'){
						console.log('Renderer 57---PublicWalletTab__item' + PublicWalletStatusForDay);
						liElement[i].classList.add("red");
						liElement[i].classList.remove("green");
			  			component.set('v.PWIconName','utility:close');
			  			helper.RedrawComponent(liElement[i]);
					}
					if(aElement.id =='PublicWalletTab__item' && PublicWalletStatusForDay==true && component.get("v.PublicWalletColor") == 'Green' ){
						console.log('Renderer 64---PublicWalletTab__item' + PublicWalletStatusForDay);
						liElement[i].classList.remove("red");
						liElement[i].classList.add("green");
						component.set('v.PWIconName','utility:check');
						helper.RedrawComponent(liElement[i]);
					}
					if(aElement.id =='PublicWalletTab__item' && PublicWalletStatusForDay==true && component.get("v.PublicWalletColor") == 'Grey'){
						console.log('Renderer 71---PublicWalletTab__item' + PublicWalletStatusForDay);
						liElement[i].classList.remove("red");
						liElement[i].classList.remove("green");	
						liElement[i].classList.add("grey");				
			  			component.set('v.PWIconName','utility:help');
			  			helper.RedrawComponent(liElement[i]);
					}
					/*if(aElement.id =='PublicWalletTab__item' && PublicWalletStatusForDay==true && component.get("v.PublicWalletColor") == 'Grey' && component.get("v.IsUserSessionLoaded") == true ){
						liElement[i].classList.remove("red");
						liElement[i].classList.remove("green");	
						liElement[i].classList.add("grey");				
			  			component.set('v.PWIconName','utility:help');
					}*/
					
					//----------------------------------CFCU wallet -----------------------------------//
					console.log('Renderer 86---CFCUWalletTab__item' + component.get("v.CFCUWalletColor"));
					if(aElement.id =='CFCUWalletTab__item' && CFCUWalletStatusForDay==false && component.get("v.CFCUWalletColor") == 'Red'){
						console.log('Renderer 88---CFCUWalletTab__item' + CFCUWalletStatusForDay);
						liElement[i].classList.add("red");
						liElement[i].classList.remove("green");
			  			component.set('v.CFCUIconName','utility:close');
			  			helper.RedrawComponent(liElement[i]);
					}
					if(aElement.id =='CFCUWalletTab__item' && CFCUWalletStatusForDay==true && component.get("v.CFCUWalletColor") == 'Green'){
						console.log('Renderer 95---CFCUWalletTab__item' + CFCUWalletStatusForDay);
						liElement[i].classList.remove("red");
						liElement[i].classList.add("green");
						component.set('v.CFCUIconName','utility:check');
						helper.RedrawComponent(liElement[i]);
					}
					if(aElement.id =='CFCUWalletTab__item' && CFCUWalletStatusForDay==true && component.get("v.CFCUWalletColor") == 'Grey'){
						console.log('Renderer 102---CFCUWalletTab__item' + CFCUWalletStatusForDay);
						liElement[i].classList.remove("red");
						liElement[i].classList.remove("green");	
						liElement[i].classList.add("grey");				
			  			component.set('v.CFCUIconName','utility:help');
			  			helper.RedrawComponent(liElement[i]);
					}
					/*if(aElement.id =='CFCUWalletTab__item' && CFCUWalletStatusForDay==true && component.get("v.CFCUWalletColor") == 'Grey' && component.get("v.IsUserSessionLoaded") == true){
						liElement[i].classList.remove("red");
						liElement[i].classList.add("green");	
						liElement[i].classList.remove("grey");				
			  			component.set('v.CFCUIconName','utility:check');
					}*/
					
					
					//----------------------------------OTP -----------------------------------//
					console.log('Renderer 118---OTPTab__item' + component.get("v.OTPColor"));
					if(aElement.id =='OTPTab__item' && OTPStatusForDay==false && component.get("v.OTPColor") == 'Red' ){
						console.log('Renderer 120---OTPTab__item' + OTPStatusForDay);
						liElement[i].classList.add("red");					
						liElement[i].classList.remove("green");
			  			component.set('v.OTPIconName','utility:close');
			  			helper.RedrawComponent(liElement[i]);
					}
					if(aElement.id =='OTPTab__item' && OOWStatusForDay == true && component.get("v.OTPColor") == 'Green'){
						console.log('Renderer 127---OTPTab__item' + OTPStatusForDay);
						liElement[i].classList.add("green");
						liElement[i].classList.remove("red");
						component.set('v.OTPIconName','utility:check');
						helper.RedrawComponent(liElement[i]);
					}
					if(aElement.id =='OTPTab__item' && OOWStatusForDay == true && component.get("v.OTPColor") == 'Grey'){
						console.log('Renderer 134---OTPTab__item' + OTPStatusForDay);
						liElement[i].classList.remove("red");
						liElement[i].classList.remove("green");
						liElement[i].classList.add("grey");	
			  			component.set('v.OTPIconName','utility:help');
			  			helper.RedrawComponent(liElement[i]);
					}
					/*if(aElement.id =='OTPTab__item' && OOWStatusForDay == true && component.get("v.OTPColor") == 'Grey' && component.get("v.IsUserSessionLoaded") == true){
						liElement[i].classList.remove("red");
						liElement[i].classList.add("green");
						liElement[i].classList.remove("grey");	
			  			component.set('v.OTPIconName','utility:check');
					}*/
					
					if(aElement.id =='OTPTab__item' && component.get("v.OTPMessage") == 'YES' && component.get("v.OTPCancellAttept") > 1){
						console.log('Renderer 149---OTPTab__item' + OTPStatusForDay);
						liElement[i].classList.add("grey");
						liElement[i].classList.add("TabDisabled");
						liElement[i].classList.remove("green");
			  			liElement[i].classList.remove("slds-is-active");
			  			component.set('v.OTPIconName','utility:ban');
			  			helper.RedrawComponent(liElement[i]);
					}
					
					
					//----------------------------------OOW -----------------------------------//
					console.log('Renderer 160---OOWTab__item' + component.get("v.OOWColor"));
					if(aElement.id =='OOWTab__item' && OOWStatusForDay == false && component.get("v.OOWColor") == 'Red'){
						console.log('Renderer 160---OOWTab__item' + OOWStatusForDay);
						liElement[i].classList.add("red");
						liElement[i].classList.remove("green");
						component.set('v.OOWIconName','utility:close');
						helper.RedrawComponent(liElement[i]);
					}
					if(aElement.id =='OOWTab__item' && OOWStatusForDay == true && component.get("v.OOWColor") == 'Green'){
						console.log('Renderer 169---OOWTab__item' + OOWStatusForDay);
						liElement[i].classList.add("green");
						liElement[i].classList.remove("red");
						component.set('v.OOWIconName','utility:check');
						helper.RedrawComponent(liElement[i]);
					}
					if(aElement.id =='OOWTab__item' && OOWStatusForDay == true && component.get("v.OOWColor") == 'Grey'){
						console.log('Renderer 176---OOWTab__item' + OOWStatusForDay);
						liElement[i].classList.remove("red");
						liElement[i].classList.remove("green");
						liElement[i].classList.add("grey");	
			  			component.set('v.OOWIconName','utility:help');
			  			helper.RedrawComponent(liElement[i]);
					}
					/*if(aElement.id =='OOWTab__item' && OOWStatusForDay == true && component.get("v.OOWColor") == 'Grey' && component.get("v.IsUserSessionLoaded") == true){
						liElement[i].classList.remove("red");
						liElement[i].classList.add("green");
						liElement[i].classList.remove("grey");	
			  			component.set('v.OOWIconName','utility:check');
					}*/
					
					//----------------------------------Debit Card Pin -----------------------------------//
					
					if(component.get("v.IsDebitTabVisible") == true)
					{
						if(DebitCardStatus =='false' && aElement.id =='DebitCardTab__item'){
							console.log('Renderer 195---DebitCardTab__item' + DebitCardStatus);
							 liElement[i].classList.add("red");
							 liElement[i].classList.remove("slds-is-active");
				  			 component.set("v.DebitCardMessage", 'Member has failed the debit card authentication' );
				  			 component.set('v.DebitIconName','utility:close');
				  			 helper.RedrawComponent(liElement[i]);
						 }
						 if(DebitCardStatus =='true' && aElement.id =='DebitCardTab__item'){
							 console.log('Renderer 203---DebitCardTab__item' + DebitCardStatus);
							 //console.log('Renderer 204---DebitCardTab__item' + IsCardOwnerSSNMatch);
							 if(component.get("v.IsCardOwnerSSNMatch")){
								liElement[i].classList.add("green");
								liElement[i].classList.remove("red");
								liElement[i].classList.remove("grey");
								component.set('v.DebitIconName','utility:check');
								component.set("v.DebitCardMessage", 'Member has passed the debit card authentication' );
							 }
							 else{
								liElement[i].classList.add("grey");
								liElement[i].classList.remove("red");
								liElement[i].classList.remove("green");
								component.set('v.DebitIconName','utility:help');	
								component.set("v.DebitCardMessage", '');							
							 }
							  
							  liElement[i].firstChild.classList.remove("TabDisabled");
				  			  liElement[i].classList.remove("slds-is-active");
				  			  
				  			  
				  			  helper.RedrawComponent(liElement[i]);
				  			  
						 }
						  if((DebitCardStatus == undefined || DebitCardStatus == '') && aElement.id =='DebitCardTab__item'){
							  console.log('Renderer 213---DebitCardTab__item' + DebitCardStatus);
							  liElement[i].classList.add("grey");
							  liElement[i].classList.add("TabDisabled");
				  			  liElement[i].classList.remove("slds-is-active");
				  			  component.set("v.DebitCardMessage", '');
				  			  component.set('v.DebitIconName','utility:ban');
				  			  helper.RedrawComponent(liElement[i]);
				  			 
						 }
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