({
	fetchPicklistFields: function(component) {
		var picklistFields = component.get("v.picklistFields");
		 
		var NAFields = ["Home_Improvement__c", "Home_Improvement_Timeframe__c", "Home_Improvement_Plan__c", "College__c", "College_Timeframe__c", "College_Plan__c",
			"Medical__c", "Medical_Timeframe__c", "Medical_Plan__c", "Purchase_RV_Boat__c", "Purchase_RV_Boat_Timeframe__c", "Purchase_RV_Boat_Plan__c", "Retirement_New__c", "Retirement_Timeframe__c", 
			"Retirement_Plan__c", "Travel__c", "Travel_Timeframe__c", "Travel_Plan__c", "Life_Events__c", "Life_Events_Timeframe__c", "Life_Events_Plan__c", "Other__c", "Other_Timeframe__c", "Other_Plan__c"];
		picklistFields['Needs_Assesment__c'] = NAFields;
		 
		this.getPicklistValues(component,picklistFields);
	},

	getPicklistValues : function(component, sobjFieldsmap) {		
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
						this.buildPicklist(component, obj + "." + field, optionValues);
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
	}
})