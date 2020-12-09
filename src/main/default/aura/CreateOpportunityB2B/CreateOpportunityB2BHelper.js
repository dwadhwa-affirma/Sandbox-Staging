({
	helperMethod : function() {
		
	},
	
    handleError: function(component, event, helper){
    	
    	var CloseDate = component.get('v.simpleRecord.CloseDate');
        var Closure = component.find("closure").get("v.value");
        
        if(Closure != '' || Closure != undefined)
            component.set("v.simpleRecord.Closure_sale_possibility__c", Closure);
        
        var isValid = true
        //if(CloseDate == ''|| CloseDate == undefined){
        //	var substatus = helper.isEmpty(component,"CloseDate", helper);
        //    if(!substatus){
        //		isValid = false; 
        //	}
        //}
        return isValid; 
    },
    
    isEmpty: function(component, fieldName, helper){
    
        var inputCmp = component.find(fieldName);
    	var value = inputCmp.get("v.value");
    	var isValid = true;
        if(value == '' || value == undefined){
            if(fieldName == "CloseDate"){
    			inputCmp.set("v.errors", [{message:"Please enter closedate"}]);
    		}
            isValid = false;
        }
    	return isValid;
    },
    
    HandleSaveOpportunity : function(component, objOpp) {
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
	}
})