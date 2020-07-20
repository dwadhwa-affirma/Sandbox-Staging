({
	getAttachmentData : function(component, uniqueId, helper) {
	
		component.set("v.loadingOnbase", true);
		var action = component.get("c.getAttachmentData");	    
	    action.setParams({
	    	"caseId" : uniqueId
	    });
	    
	    action.setCallback(this, function(response){	    	
	        var state = response.getState();	        
	        if (state === "SUCCESS") {	     	
	            var result =  response.getReturnValue();	            
				component.set("v.Model", result);												
	        }
	        component.set("v.loadingOnbase", false);
	        
        
	    });
	    
	    $A.enqueueAction(action);
	},
	
	saveOnBasedata : function(component, uniqueId) {
	
		component.set("v.loadingOnbase", true);
		var action = component.get("c.saveAttachments");	 

	    action.setParams({	    	
	    	"wrapperString" :  JSON.stringify( component.get("v.Model.onbaseDocuments")),
	    	"caseId" : uniqueId,
	    	"approvalids" : component.get("v.Model.approvalids"),
	    });	
	    
	    action.setCallback(this, function(response){	
	        var state = response.getState();	        
	        if (state === "SUCCESS") {
	            var result =  response.getReturnValue();	  
	            $A.get('e.force:closeQuickAction').fire();
	                      
				var toastEvent = $A.get("e.force:showToast");
	        	  var updateEvent = component.getEvent("ClosePopup");
        updateEvent.fire();
		        toastEvent.setParams({		            
		            message : 'Record Saved Successfully',	                        
		            duration:' 3000',
		            key: 'info_alt',
		            type: 'success',
		            mode: 'pester'
		        });
		        toastEvent.fire();			        
		        //location.reload();	
	        }
	        else
	        {
	        	  var updateEvent = component.getEvent("ClosePopup");
        updateEvent.fire();
	                      
				var toastEvent = $A.get("e.force:showToast");
	        
		        toastEvent.setParams({		            
		            message : 'Something went wrong. Please contact administrator.',	                        
		            duration:' 3000',
		            key: 'info_alt',
		            type: 'error',
		            mode: 'pester'
		        });
		        toastEvent.fire();		
	        }
	        component.set("v.loadingOnbase", false);
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
	fetchPicklistFields: function(component) {
		var picklistFields = component.get("v.picklistFields");
		 
		var NAFields = ["Document_Type__c"];
		picklistFields['OnBase_Document__c'] = NAFields;
		 for(var k=0; k<2;k++){
			 this.getPicklistValues(component,picklistFields,k);
		}
	},
	getPicklistValues : function(component, sobjFieldsmap,upendIndex) {		
		var action = component.get("c.getPicklistValues");
		
		action.setParams({
		"objpicklistFieldsMap": JSON.stringify(sobjFieldsmap)
		});			
			action.setCallback(this, function(resp) {
			
			var state=resp.getState();
			console.log('state ' + state);
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
						component.set("v.DocTypeOptions",optionValues);



					 var currId = component.get("v.recordId");
					 this.getAttachmentData(component, currId, this);
					



					}
				}
				
				
			}
		});
		$A.enqueueAction(action);
	},
	 
	buildPicklist: function(component, elementId, optionValues) {
		var opts = [];
		if (optionValues != undefined && optionValues.length > 0) {
			opts.push({
			class: "optionClass",
			label: "--- None Sel ---",
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
	}
})