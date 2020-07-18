({
	HandleSaveLead : function(component, objLead) {
		var action = component.get("c.LeadInsertUpdate");
		delete objLead["Owner"];	
	    action.setParams({
	    	"leadObject" : objLead,
	    	"MemberAccountID" : component.get("v.recordId")
	    });
	    
	    action.setCallback(this, function(response){	    	    	
	        var state = response.getState();
	        if (state === "SUCCESS") {
	            var result =  response.getReturnValue();
	            //component.set("v.LeadObject", result);
				var toastEvent = $A.get("e.force:showToast");
	        
		        toastEvent.setParams({		            
		            message : 'Record Saved Successfully',	                        
		            duration:' 3000',
		            key: 'info_alt',
		            type: 'success',
		            mode: 'pester'
		        });
		        toastEvent.fire();		
	        }	        
	        component.set("v.loading", false);
	        
	        var navEvt = $A.get("e.force:navigateToSObject");
	        navEvt.setParams({
	        	"recordId": result,
	        	"slideDevName": "related"
	        });
	        navEvt.fire();        
	        
	    });
	    
	    $A.enqueueAction(action);
	},
	
	getEpsys : function(component){
		var action = component.get("c.getEpsysDetails");
		
		
		action.setCallback(this, function(response){	    	    	
	        var state = response.getState();
	        if (state === "SUCCESS") {
	            var result =  response.getReturnValue();	       
	            component.set('v.leadCreators', result);
	                 
	            var opts = [];
	            
	            opts.push({
					class: "optionClass",
					label: "--- None ---",
					value: ""
	            });
			
	            for(var i=0; i <  result.length; i++){
	            	var obj = result[i];
					opts.push({
						class: "optionClass " + obj.Episys_ID__c,
						value: obj.Branch_Name__c,
						label: obj.Branch_Name__c						
					});					
				}
				component.find("leadCreator").set("v.options", opts);		
				
	        }
	        component.set("v.loading", false);	        
	    });
	    
	    $A.enqueueAction(action);			
	},
	
	
	handleError: function(component, event, helper){	
        var LeadStatus = helper.isEmpty(component,"LeadStatus", helper);
        var LastName = helper.isEmptyForce(component,"LastName", helper);
        var objProductType = helper.isEmpty(component,"objProductType", helper);
        var objBrand = helper.isEmptyForce(component,"objBrand", helper);
        var LeadType = helper.isEmptyForce(component,"LeadType", helper);        
        var phoneValidate = this.isHomePhone(component, component.get("v.LeadObject.Phone"), "inpPhone");
        var homePhoneValidate = this.isHomePhone(component, component.get("v.LeadObject.Home_Phone__c"), "inpHomePhone");
        var otherPhoneValidate = this.isHomePhone(component, component.get("v.LeadObject.Other_Phone__c"), "inpOtherPhone");
        
        var isValid = true;
        var emailValidate = helper.isEmail(component);
        if(!LeadStatus || !objProductType || !objBrand || !LeadType || !LastName || !emailValidate || !phoneValidate || !homePhoneValidate || !otherPhoneValidate)
        {
        	isValid = false;        	
        }        
        
        return isValid;        
    },    
    
    isEmail : function(component){
    	var isValid = true;
    	var value = component.find('email').get("v.value");
    	var regExpEmailformat = /^(([^<>()\[\]\\.,;:\s@"]+(\.[^<>()\[\]\\.,;:\s@"]+)*)|(".+"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$/;
    	 if(value == '' || value  == undefined || value.match(regExpEmailformat)){    		 
    		 component.find('email').set("v.errors", null);
    	 }
    	 else
    	 {
    		 component.find('email').set("v.errors", [{message:"Invalid email !"}]);    	 
    		 isValid = false;
    	 }
    	 return isValid;;
    },
    
    isPhone : function(component, value, field){        
    	var isValid = true;
    	 if(value == '' || value  == undefined || !isNaN(value)){    		 
    		 component.find(field).set("v.errors", null);
    	 }
    	 else
    	 {
    		 component.find(field).set("v.errors", [{message:"Invalid phone !"}]);    	 
    		 isValid = false;
    	 }
    	 return isValid;
    },
    
    isHomePhone : function(component, value, field){        
    	var isValid = true;
    	var regExp = /^[0-9-]+$/;
    	 if(value == '' || value  == undefined || value.match(regExp)){    		 
    		 component.find(field).set("v.errors", null);
    	 }
    	 else
    	 {
    		 component.find(field).set("v.errors", [{message:"Invalid phone !"}]);    	 
    		 isValid = false;
    	 }
    	 return isValid;
    },
	
	isEmpty: function(component, fieldName, helper)
    {
    	var inputCmp = component.find(fieldName);
    	var value = inputCmp.get("v.value");
    	var isValid = true;
    	if(value == '' || value == undefined || value == '--- None ---'){
        	inputCmp.set("v.errors", [{message:"Complete this field"}]);
        	isValid = false;
        }
        else
        {
        	inputCmp.set("v.errors", null);
        }
        
        return isValid;
    	
    },
    
     isEmptyForce: function(component, fieldName, helper)
    {
    	var inputCmp = component.find(fieldName);
    	var value = inputCmp.get("v.value");
    	var isValid = true;
    	if(value == '' || value == '--- None ---' || value == undefined ){
        	/*inputCmp.elements[0].classList.add('errorForce');         	
        	if(inputCmp.elements[0].nextSibling != null && inputCmp.elements[0].nextSibling != undefined)
        	{
        		inputCmp.elements[0].nextSibling.remove();
        	}
        	inputCmp.elements[0].parentElement.append(ul);
        	
        	inputCmp.elements[0].className += ' errorForce';
        	if(inputCmp.elements[0].firstChild)
        	{
        		inputCmp.elements[0].firstChild.className += ' errorForce';
        	}*/
        	var controlId = fieldName + 'Control';
        	var control = document.getElementById(controlId);
        	control.classList.add('errorForce');        	
        	
        	var controlErrorId = fieldName + 'Error';
        	var controlError = document.getElementById(controlErrorId);
        	controlError.style = '';
        	isValid = false;

        }
        else
        {
        	/*inputCmp.elements[0].classList.remove('errorForce');
        	if(inputCmp.elements[0].nextSibling != null && inputCmp.elements[0].nextSibling != undefined)
        	{
        	 inputCmp.elements[0].nextSibling.remove();
        	}*/
        	var controlId = fieldName + 'Control';
        	var control = document.getElementById(controlId);
        	control.classList.remove('errorForce');   
        	var controlErrorId = fieldName + 'Error';     	
        	var controlError = document.getElementById(controlErrorId);
        	controlError.style = 'display:none;';
        }
        return isValid;
    	
    },
    
    
    fetchPicklistValues: function(component, objRequest, RequestType) {
      // call the server side function  
      var action = component.get("c.getDependentOptionsImpl");
      // pass paramerters [object name , contrller field name ,dependent field name] -
      // to server side function


      action.setParams(objRequest);
      //set callback   
      action.setCallback(this, function(response) {
         if (response.getState() == "SUCCESS") {
            //store the return response from server (map<string,List<string>>)  
            var StoreResponse = response.getReturnValue();
 
            // once set #StoreResponse to depnedentFieldMap attribute 
//            component.set("v.depnedentFieldMap", StoreResponse);
            component.set("v." + RequestType.DependentFieldName, StoreResponse);
 
            // create a empty array for store map keys(@@--->which is controller picklist values) 
 
            var listOfkeys = []; // for store all map keys (controller picklist values)
            var ControllerField = []; // for store controller picklist value to set on ui field. 
 
            // play a for loop on Return map 
            // and fill the all map key on listOfkeys variable.
            for (var singlekey in StoreResponse) {
               listOfkeys.push(singlekey);
            }
            
            //set the controller field value for ui:inputSelect  
            if (listOfkeys != undefined && listOfkeys.length > 0) {
               ControllerField.push({
                  class: "optionClass",
                  label: "--- None ---",
                  value: "--- None ---"
               });
            }
 
            for (var i = 0; i < listOfkeys.length; i++) {
               ControllerField.push({
                  class: "optionClass",
                  label: listOfkeys[i],
                  value: listOfkeys[i]
               });
            }
            // set the ControllerField variable values to country(controller picklist field)
            //component.find('objProductType').set("v.options", ControllerField);
            component.find(RequestType.fieldId).set("v.options", ControllerField);            
         }
      });
      $A.enqueueAction(action);
   },
 
 
   fetchDepValues: function(component, ListOfDependentFields, requestType) {
      // create a empty array var for store dependent picklist values for controller field)  
      var dependentFields = [];
 
      if (ListOfDependentFields != undefined && ListOfDependentFields.length > 0) {
         dependentFields.push({
            class: "optionClass",
            label: "--- None ---",
            value: "--- None ---"
         });
 
      }
      for (var i = 0; i < ListOfDependentFields.length; i++) {
         dependentFields.push({
            class: "optionClass",
            label: ListOfDependentFields[i],
            value: ListOfDependentFields[i]
         });
      }
      // set the dependentFields variable values to State(dependent picklist field) on ui:inputselect    
//      component.find('objProductSubType').set("v.options", dependentFields);
      // make disable false for ui:inputselect field 
//      component.set("v.isDependentDisable", false);
      
      
      component.find(requestType.dependentFieldId).set("v.options", dependentFields);
      // make disable false for ui:inputselect field 
      component.set("v." + requestType.fieldstatus, false);
      
   },

    fetchMemberAccountDetails: function(component, AccountId)
    {
    	var action = component.get("c.getMemberAccounts");
    	action.setParams({
    		'AccountId': AccountId
    	});
      
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {    
                var result =  response.getReturnValue();  	
                component.set("v.accDetails", result.memberDetails);   
                 component.set("v.memberaccDetails", result.accountDetails);                
            }
         });
         $A.enqueueAction(action); 
    	
    },
    itemSelected : function(component, event, helper) {
        var target = event.target;   
        var SelIndex = helper.getIndexFrmParent(target,helper,"data-selectedindex");  
        if(SelIndex){
            var serverResult = component.get("v.accDetails");
            var selItem = serverResult[SelIndex];
            if(selItem){
               component.set("v.selectedAcctNumber",selItem);
               component.set('v.showDorpDown', 'false');
               //component.set("v.last_ServerResult",serverResult);
            } 
           // component.set("v.accList",null); 
        } 
	}, 
	clearSelection: function(component, event, helper){
        component.set("v.selectedAcctNumber",null);
        //component.set("v.accList",null);
	},
	getIndexFrmParent : function(target,helper,attributeToFind){
        //User can click on any child element, so traverse till intended parent found
        var SelIndex = target.getAttribute(attributeToFind);
        while(!SelIndex){
            target = target.parentNode ;
			SelIndex = helper.getIndexFrmParent(target,helper,attributeToFind);           
        }
        return SelIndex;
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

	buildPicklist: function(component, elementId, optionValues) {
		var opts = [];
		if (optionValues != undefined && optionValues.length > 0) {
			opts.push({
			class: "optionClass",
			label: "--- None ---",
			value: ""
			});
		}
	 
		for (var i = 0; i < optionValues.length; i++) {
			opts.push({
			class: "optionClass",
			value: optionValues[i],
			label: optionValues[i]
			});
		}
		component.find(elementId).set("v.options", opts);
	},
	
	fetchPicklistFields: function(component) {
		var picklistFields = component.get("v.picklistFields");
		 
		var NAFields = ["Event_Source__c"];
		picklistFields['Lead'] = NAFields;
		 
		this.getPicklistValues(component,picklistFields);
	},	
	 
	getPicklistValues : function(component, sobjFieldsmap) {		
		var action = component.get("c.getPicklistValues");
		console.log('sobjFieldsmap --> ' + JSON.stringify(sobjFieldsmap));
		action.setParams({
		"objpicklistFieldsMap": JSON.stringify(sobjFieldsmap)
		});			
			action.setCallback(this, function(resp) {
			var state=resp.getState();			
			if(state === "SUCCESS"){
				var res = resp.getReturnValue();
				console.log(res);
				var obj;
				for(obj in res){
					var objName = res[obj];
					console.log('object name --> ' + obj);
					var field;
					for(field in objName){
						console.log('fields --> ' + field);
						var optionValues = objName[field];
						console.log('options --> ' + optionValues);
						this.buildPicklist(component, field, optionValues);
					}
				}
			}
		});
		$A.enqueueAction(action);
	}
	
	
	
})