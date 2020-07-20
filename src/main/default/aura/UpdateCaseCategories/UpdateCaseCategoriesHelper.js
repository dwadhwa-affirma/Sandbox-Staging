({
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
      //component.set("v." + requestType.fieldstatus, false);
      
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
	
	
	
	handleError: function(component, event, helper){
	
        var Primary_Category__c = helper.isEmpty(component,"Primary_Category__c", helper);
        var Secondary_Category__c = helper.isEmpty(component,"Secondary_Category__c", helper);
        var Tertiary_Category__c = helper.isEmpty(component,"Tertiary_Category__c", helper);      
        
        
        var isValid = true;
        if(!Primary_Category__c || !Secondary_Category__c || !Tertiary_Category__c)
        {
        	isValid = false;
        }
        return isValid;
        
    },
    
    isEmpty: function(component, fieldName, helper)
    {
    	var inputCmp = component.find(fieldName);
    	var value = inputCmp.get("v.value");
    	var isValid = true;
    	if(value == '' || value == '--- None ---' || value == undefined ){
        	inputCmp.set("v.errors", [{message:"Complete this field"}]);
        	isValid = false;
        }
        else
        {
        	inputCmp.set("v.errors", null);
        }
        
        
        //
        
        return isValid;
    	
    },
    
    SaveCaseCategories: function(component,event,helper){
		component.set('v.loading',true);
		var caseModel = component.get("v.caseObject");		
		var action = component.get("c.saveCategories");
		var parameters = {"caseObject": caseModel}   
	   
	   action.setParams(parameters);
	   action.setCallback(this, function(response){
	   		var status = response.getState();
        	if(component.isValid() && status === "SUCCESS")
        	{
        		var result =  response.getReturnValue();
        		if(result.IsSaved == 'true')
        		{
        			var toastEvent = $A.get("e.force:showToast");
				    toastEvent.setParams({
				        message : result.Message,                         
			            duration:' 3000',
			            key: 'info_alt',
			            type: 'success',
			            mode: 'pester'
				    });
				    toastEvent.fire();
				    $A.get('e.force:closeQuickAction').fire();
				     $A.get('e.force:refreshView').fire();
        		}
        		
        		component.set('v.loading',false);
        		
        	}
        });
         $A.enqueueAction(action);		
	}
})