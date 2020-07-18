({
	getDetails : function(component) {
		var action = component.get("c.getDetails");
		var recordId = component.get("v.recordId");	
		action.setParams({
		"caseId": recordId
		});	
		action.setCallback(this, function(resp) {			
			var state=resp.getState();			
			if(state === "SUCCESS"){				
				var res = resp.getReturnValue();
				console.log(res);
				 
				}
			});
	},
	
	getCardDetails : function(component) {	
		var action = component.get("c.getCardDetails");
		var recordId = component.get("v.recordId");	
		action.setParams({
		"accid": recordId
		});	
		action.setCallback(this, function(resp) {			
			var state=resp.getState();			
			if(state === "SUCCESS"){	
			debugger;		
				
				var res = resp.getReturnValue();
				console.log(res);
				if(res != null){	
				 
				 if(res.isTravelCard != false){
					var cardlist = res.accList;	
					var finalcardlist = [];
					//cardlist.cardDetails.map((obj) => {   
					//obj.CardType = "";
					//})	
					for(var i=0;i<cardlist.length;i++){
						/*var cardtype=cardlist[i].cardClassification; 
						if(cardtype == "11" || cardtype =="12"){
							cardlist[i].CardType = "ATM";
						}
						else if(cardtype == "13" || cardtype =="14" || cardtype =="15" || cardtype =="18"){
							cardlist[i].CardType = "DEBIT";
						}
						else if(cardtype == "16" || cardtype =="17"){
							cardlist[i].CardType = "HSA";
						}
						else
						{	
							cardlist[i].CardType = "NA";
						}*/	
						var iobj = 	cardlist[i].cardDetails;				
						iobj.CardType = cardlist[i].cardClassification;
						if(iobj.Card_Name__c == '' || iobj.Card_Name__c == undefined){
							iobj.Card_Name__c = '(No Name Record Exists)';
						}
						if(iobj.Card_Number__c == undefined){
							
						}
						else if(iobj.Card_Number__c == null || iobj.Card_Number__c.length != 16){
							
						}
						else
						{
							finalcardlist.push(iobj);
						}
						
					}	

					component.set("v.isTravelCard", true);	
					component.set("v.cardList", finalcardlist);
					component.set("v.travelDetails.US_Mobile_Number__c", res.USPhone);
					component.set("v.travelDetails.Email__c", res.Email);
					/*if(res.USPhone == '' || res.USPhone == undefined){
						component.set("v.isPhoneDisabled", true);
					}
					if(res.Email == '' || res.Email == undefined){
						component.set("v.isEmailDisabled", true);
					}*/
					
				//this.buildPicklist(component, "CountryList");
				//this.fetchCountryData(component);
				}				
				else
				{
					component.set("v.isTravelCard", false);
				}
				}
				}
				
			});
			$A.enqueueAction(action);
	},
	closest: function(el, selector) {
    var matchesFn;

    // find vendor prefix
    ['matches','webkitMatchesSelector','mozMatchesSelector','msMatchesSelector','oMatchesSelector'].some(function(fn) {
        if (typeof document.body[fn] == 'function') {
            matchesFn = fn;
            return true;
        }
        return false;
    })

    var parent;

    // traverse parents
    while (el) {
        parent = el.parentElement;
        if (parent && parent[matchesFn](selector)) {
            return parent;
        }
        el = parent;
    }

    return null;
},

fetchCountryData : function(component) {	
			var action = component.get("c.getCountryData");		
			action.setCallback(this, function(resp) {
				var state=resp.getState();			
				if(state === "SUCCESS"){					
					var res = resp.getReturnValue();
					console.log(res);					
					this.buildPicklist(component, "CountryList", res);				
				}
			});
			
			$A.enqueueAction(action);
			
	},

buildPicklist: function(component, elementId, optionValues) {
		var opts = [];	
		opts.push({
			class: "optionClass",
			label: "--- None ---",
			value: ""
			});
		if(optionValues != undefined)
		{
			for (var i = 0; i < optionValues.length; i++) {
				opts.push({
				class: "optionClass",
				value: optionValues[i].toUpperCase(),
				label: optionValues[i].toUpperCase()
				});
			}
		}
		
		component.find(elementId).set("v.options", opts);
	},
saveTravelNotification: function(component, selectedCards,traveldetailsobj, isAPIError, res){
	var action = component.get("c.saveTravelNotification");		
		action.setParams({
			"id" : component.get("v.recordId"),
			"selectedCards" : JSON.stringify(selectedCards),
			"traveldetailsobj": JSON.stringify(traveldetailsobj),
			"result": res
		   
		});	
		
		action.setCallback(this, function(resp) {
			component.set("v.loading", false);
			var state=resp.getState();			
			if(state === "SUCCESS"){
				var res = resp.getReturnValue();
				console.log(res);
				if(!isAPIError){
					//alert('Your request has been processed successfully');
					var toastEvent = $A.get("e.force:showToast");
		        
			        toastEvent.setParams({		            
			            message : 'Your request has been processed successfully',	                        
			            duration:'500',		           
			            key: 'info_alt',
			            type: 'success',
			            mode: 'pester'
			        });
			        toastEvent.fire();	
		        }
		        var ele = document.getElementById('divloading');
		        ele.style = 'display:none;';
		        if(!isAPIError)
		         $A.get('e.force:closeQuickAction').fire();
		        }
		        });
		$A.enqueueAction(action);
},

createObjectData: function(component, event) {
        // get the contactList from component and add(push) New Object to List  
        var RowItemList = component.get("v.travelDetails");
        RowItemList.push({
            'sobjectType': 'Mastercard_Travel__c',
            'Destination__c': '',
            'State__c': '',
            'Departure_Date__c': '',
            'Return_Date__c': '',
            'Country__c': ''
        });
        // set the updated list to attribute (contactList) again    
        component.set("v.travelDetails", RowItemList);
    },
    
    
     clearAll: function(component, event) {
        // this method set all tabs to hide and inactive
        var getAllLI = document.getElementsByClassName("customClassForTab");
        var getAllDiv = document.getElementsByClassName("customClassForTabData");
        for (var i = 0; i < getAllLI.length; i++) {
            getAllLI[i].className = "slds-tabs--scoped__item slds-text-title--caps customClassForTab";
            getAllDiv[i].className = "slds-tabs--scoped__content slds-hide customClassForTabData";
        }
    },
    
    getCurrentTravelPlans : function(component) {
    
		var action = component.get("c.getCurrentTravelPlans");
		var recordId = component.get("v.recordId");	
		action.setParams({
		"recordId": recordId
		});	
		action.setCallback(this, function(resp) {			
			var state=resp.getState();			
			if(state === "SUCCESS"){				
				var res = resp.getReturnValue();
				console.log(res);
				 var traveldetails = res;
				 component.set("v.travelEditDetails", traveldetails);
				 component.set("v.currentTab", "2");   
				}
				var ele = document.getElementById('divloading');
				ele.style = 'display:none;';
			});
			$A.enqueueAction(action);
			
	},
	
	MCAPICallout: function(component, selectedCards,traveldetailsobj){
	var action = component.get("c.MCAPICallout");		
		action.setParams({
			"id" : component.get("v.recordId"),
			"selectedCards" : JSON.stringify(selectedCards),
			"traveldetailsobj": JSON.stringify(traveldetailsobj)
					
		});	
		var isAPIError=false;
		action.setCallback(this, function(resp) {
			component.set("v.loading", false);
			var state=resp.getState();			
			if(state === "SUCCESS"){
					var res = resp.getReturnValue();
					if(res.length > 0){
					var ele = document.getElementById('divloading');
						 ele.style = 'display:none;';
						
						var errormessageconstant = "Error while processing request for following cards:";
						var errormessage = errormessageconstant;
						var successmessageconstant = "The Travel Notice has been placed for the following cards:"
						var successmessage = successmessageconstant;
						for(var i=0;i<res.length; i++){
						
						    var result = res[i].split('|');
						    var subresult = result[0].split(',');
						    if(result[1] == '')
							successmessage = successmessageconstant + "\n" + subresult[0] + ' ' + result[1];
						}
						if(successmessage == successmessageconstant){
						 successmessage = '';
						}
						for(var i=0;i<res.length; i++){
						    var result = res[i].split('|');
						    var subresult = result[0].split(',');
						     if(result[1] != '')
							errormessage = errormessage + "\n" + subresult[0] + ' ' + result[1];
						}
						var finalmessage = successmessage + '\n' + errormessage;
						
						if(errormessage != errormessageconstant){
						  component.set("v.popoverMessage", finalmessage);   
							var popover = component.find("popover");
							$A.util.removeClass(popover,'slds-hide');
							$A.util.addClass(popover,'errorSave');
							isAPIError =true;
						}
						 
						  var ele = document.getElementById('btnEdit');
						  ele.style = '';
					}
					//else
					//{
					//	component.set("v.isStartOverVisible", true);
					//}					
					this.saveTravelNotification(component, selectedCards,traveldetailsobj, isAPIError, res.join(';'));	
					
					//this.saveTravelNotification(component, selectedCards,traveldetailsobj);	
		        }
		     });
		$A.enqueueAction(action);
},

deleteObjectData: function(component, event) {
        // get the contactList from component and add(push) New Object to List  
        var RowItemList = component.get("v.travelDetails");
        var finaltravelDetailsobj = [];
        for(var i=0; i<RowItemList.length;i++){
		   finaltravelDetailsobj.push({
		   sobjectType: 'Mastercard_Travel__c',
			Country__c: '',
			Departure_Date__c: '',
			Destination__c: '',
			Return_Date__c: '',
			State__c: ''			
			});
	   }
	   for(var i=0; i<finaltravelDetailsobj.length;i++){
		   if(i != 0)
		   {
			   finaltravelDetailsobj.splice(i, 1);
		   }
		   else
		   {
			   finaltravelDetailsobj.IsEmailPreferred__c = false;
			   finaltravelDetailsobj.IsPhonePreferred__c = false;
		   }
	   }
        component.set("v.travelDetails", finaltravelDetailsobj);
    },
    
})