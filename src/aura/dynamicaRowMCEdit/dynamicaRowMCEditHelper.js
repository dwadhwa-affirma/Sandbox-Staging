({
	getTimeZoneList : function(component) {
		var action = component.get("c.getTimeZone");
        var inputTimeZone = component.find("InputSelectTimeZone");
        var opts=[];
        action.setCallback(this, function(a) {
        var state=a.getState();		
            opts.push({
                class: "optionClass",
                label: "--- None ---",
                value: "",
                selected: "false"
            });
            for(var i=0;i< a.getReturnValue().length;i++){
            	var selected=false;
            	if(component.get("v.travelDetailsInstance.MasterCardSFObj.Timezone__c") == a.getReturnValue()[i])
            	selected=true;
            	else
            	selected=false;
                opts.push({"class": "optionClass", label: a.getReturnValue()[i], value: a.getReturnValue()[i], selected: selected});
            }            
            inputTimeZone.set("v.options", opts);
             
        });
        $A.enqueueAction(action); 
	},
	getCountryList : function(component) {
		var action = component.get("c.getCountryData");
        var inputCountry = component.find("InputSelectCountry");
        var opts=[];
        action.setCallback(this, function(a) {
        var state=a.getState();		
            opts.push({
                class: "optionClass",
                label: "--- None ---",
                value: "",
                selected: "false"
            });
            for(var i=0;i< a.getReturnValue().length;i++){
            	var selected=false;            	
            	if(component.get("v.travelDetailsInstance.MasterCardSFObj.Country__c") == a.getReturnValue()[i])
            	selected=true;
            	else
            	selected=false;
                opts.push({"class": "optionClass", label: a.getReturnValue()[i], value: a.getReturnValue()[i], selected: selected});
            }
            inputCountry.set("v.options", opts);
             
        });
        $A.enqueueAction(action); 
	},
	
	getStateList: function(component) {
		var action = component.get("c.getStateData");
        var inputState = component.find("InputSelectState");
        var opts=[];
        action.setCallback(this, function(a) {
        var state=a.getState();		
            opts.push({
                class: "optionClass",
                label: "--- None ---",
                value: "",
                selected: "false"
            });
            for(var i=0;i< a.getReturnValue().length;i++){
            	var selected=false;
            	if(component.get("v.travelDetailsInstance.MasterCardSFObj.State__c") == a.getReturnValue()[i])
            	selected=true;
            	else
            	selected=false;
                opts.push({"class": "optionClass", label: a.getReturnValue()[i], value: a.getReturnValue()[i], selected: selected});
            }
            inputState.set("v.options", opts);
             
        });
        $A.enqueueAction(action); 
	},
	
	SaveMCDetails : function(component) {
		var action = component.get("c.updateCurrentTravelPlans");		
		action.setParams({			
			"mcObjString": JSON.stringify(component.get("v.travelDetailsInstance"))
					
		});	
		
		action.setCallback(this, function(resp) {
			component.set("v.loading", false);
			var state=resp.getState();			
			if(state === "SUCCESS"){
				var res = resp.getReturnValue();												
					if(res.length > 0){					
						component.getEvent("RefreshEvt").setParams({"EventType" : 'Error' , "ErrorMessage" : 'Error processing request: ' + res }).fire(); 
					}
				else{
					this.SaveSFDetails(component);
					}
				//alert('Details Updated Successfully');
				//component.set("v.isEditable", false);
		        }
		        });
		$A.enqueueAction(action);
	},
	
	SaveSFDetails : function(component) {
		var action = component.get("c.updateSFCurrentTravelPlans");		
		action.setParams({			
			"mcObjString": JSON.stringify(component.get("v.travelDetailsInstance"))
					
		});	
		
		action.setCallback(this, function(resp) {
			component.set("v.loading", false);
			var state=resp.getState();			
			if(state === "SUCCESS"){
				var res = resp.getReturnValue();
				alert('Details Updated Successfully');
				component.set("v.isEditable", false);
				component.getEvent("RefreshEvt").setParams({"EventType" : 'Refresh', "ErrorMessage" : '' }).fire();  
				
			    
		        }
		        component.set("v.loading", false);
		        });
		$A.enqueueAction(action);
	},
	DeleteDetail : function(component) {
		var action = component.get("c.deleteCurrentTravelPlans");		
		action.setParams({			
			"mcObjString": JSON.stringify(component.get("v.travelDetailsInstance"))					
		});	
		
		action.setCallback(this, function(resp) {
			
			var state=resp.getState();			
			if(state === "SUCCESS"){
				var res = resp.getReturnValue();									
					if(res.length > 0){					
						component.getEvent("RefreshEvt").setParams({"EventType" : 'Error' , "ErrorMessage" : 'Error processing request: ' + res }).fire(); 
					}
				else{	
					alert('Details Deleted Successfully');
					component.getEvent("RefreshEvt").setParams({"EventType" : 'Refresh', "ErrorMessage" : '' }).fire(); 
				}
				 
				//component.set("v.isEditable", false);
		        }
		        component.set("v.loading", false);
		        });
		$A.enqueueAction(action);
	},
})