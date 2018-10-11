({
	helperMethod : function() {
		
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
	            	var selected=false;            	
	            	if(obj.Default__c  == true)
	            	selected=true;
	            	else
	            	selected=false;
					opts.push({
						class: "optionClass " + obj.Episys_ID__c,
						value: obj.Branch_Name__c,
						label: obj.Episys_ID__c,
						selected: selected					
					});					
				}
				component.find("leadCreator").set("v.options", opts);		
				
	        }
	        component.set("v.loading", false);	        
	    });
	    
	    $A.enqueueAction(action);			
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
                component.set("v.accDetails", response.getReturnValue());                
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
   
   HandleSaveOpportunity : function(component, objOpp, queueid,MemAccid) {
		var action = component.get("c.OpportunityInsertUpdate");	
		
	    action.setParams({
	    	"opportunityObject" : objOpp,
	    	
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
		        $A.get('e.force:refreshView').fire();
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
	
	handleError: function(component, event, helper){
        
        var objProductType = helper.isEmpty(component,"objProductType", helper);
        var objOpportunitySource = helper.isEmptyForce(component,"objOpportunitySource", helper);
        
        var objOwnership = helper.isEmptyForce(component,"ownership", helper);
        
        var OwnershipValue = component.get('v.simpleRecord.Ownership__c');
        
        var StageName = component.get('v.simpleRecord.StageName');
        
       var ownertypevalue = component.find("ownertype").get("v.value");
       
       var MemAccNumber = component.get('v.selectedAcctNumber');
      
        var isValid = true;
        if(StageName == 'Outreach')
        {
        	var substatus = helper.isEmpty(component,"objSubStatus", helper);
        	if(!substatus)
        	{
        		isValid = false; 
        	}
        }
      /*  if(MemAccNumber == null || MemAccNumber == ''){
        	  // var memPick = document.getElementsByClassName("MemberPickerError");
        	  if(document.getElementById('MemberPickerError'))
        	  {
        	  document.getElementById('MemberPickerError').style = 'block';
        	 
        		isValid = false;
        		}
        
        }
        else{
          if(document.getElementById('MemberPickerError'))
        	  {
        	  
        	      document.getElementById('MemberPickerError').style.display = "none";
        	 }
        }*/
        if(OwnershipValue == 'Assign')
        {
	       if(ownertypevalue == 'Queue')
	       {
	    	   var queuename = helper.isEmpty(component,"queuename", helper);
	    	   if(!queuename )
	    	   {
	    		   isValid = false; 
	    	   }
	       }
	       else
	       {
	    	   var inputCmp = component.find('queuename');
	    	   inputCmp.set("v.errors", null);
	    	   var objOwnership = helper.isEmptyForce(component,"userOwner", helper);
	    	   if(!objOwnership )
	    	   {
	    		   isValid = false; 
	    	   }
	       }
       }
       else
       {
    	   	var controlId = 'userOwner' + 'Control';
        	var control = document.getElementById(controlId);
        	if(control != null && control != undefined)
        	{
	        	control.classList.remove('errorForce');   
	        	var controlErrorId = 'userOwner' + 'Error';     	
	        	var controlError = document.getElementById(controlErrorId);
	        	if(controlError != null)
	        	{
	        		controlError.style = 'display:none;';
	        	}
        	}
        	var inputCmp = component.find('queuename');
        	inputCmp.set("v.errors", null);
       }
      
        if(!objProductType || !objOpportunitySource || !objOwnership)
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
    	
    	
    	if(value == '' || value == undefined || value == '--- None ---'){
    		if(fieldName == "objSubStatus")
    		{
    			inputCmp.set("v.errors", [{message:"Please enter the Sub Status"}]);
    		}
    		else
    		{
    			inputCmp.set("v.errors", [{message:"Complete this field"}]);
        	}
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
        	
        	var controlId = fieldName + 'Control';
        	var control = document.getElementById(controlId);
        	if(control != null && control != undefined)
        	{
	        	control.classList.add('errorForce');
        	}
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
})