({
	getresponse : function(component) {
	debugger;
		component.set("v.loading", true);
		//var recordId = component.get("c.recordId");
		var action = component.get("c.GetCannedResponse");     
		  
        action.setParams({
            "recordId": ''
        });
        action.setCallback(this, function(response) {
            var state = response.getState();

            if (state === "SUCCESS") {
            	var result = response.getReturnValue();
            	component.set("v.Model", result);
            }
            component.set("v.loading", false);
        });               
		$A.enqueueAction(action);		
	},
	
    saveCannedResponse: function(component) {
        component.set("v.loading", true);
        var recordId = component.get("v.recordId");
        var Model = component.get("v.Model.response");
        var action = component.get("c.saveCannedResonses");
        
        action.setParams({
            "recordId": recordId,
            "Model": Model
        });

        action.setCallback(this, function(response) {
            var state = response.getState();

            if (state === "SUCCESS") {
                var result = response.getReturnValue();
                //component.set("v.LeadObject", result);
                var toastEvent = $A.get("e.force:showToast");

                toastEvent.setParams({
                    message: 'Record Saved Successfully',
                    duration: ' 3000',
                    key: 'info_alt',
                    type: 'success',
                    mode: 'pester'
                });
                toastEvent.fire();
                $A.get('e.force:closeQuickAction').fire();
            } else {
                
            }
            component.set("v.loading", false);
        });

        $A.enqueueAction(action);
    },
    
    handleError: function(component, event, helper){	
        //var objBrand = helper.isEmptyForce(component,"objBrand", helper);
        var objTitle = helper.isEmpty(component,"objTitle", helper);        
        var objDescription = helper.isEmpty(component,"objDescription", helper);
        
        
        var isValid = true;
        
        if(!objTitle || !objDescription)
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