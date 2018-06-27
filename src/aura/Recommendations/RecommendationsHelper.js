({
	fetchPicklistFields: function(component) {
		var picklistFields = component.get("v.picklistFields");
		
		var NAFields = ["REC_LECF_Outcome_1__c", "REC_LECF_Outcome_2__c", 
		"REC_LECF_Outcome_3__c", "REC_LECF_Outcome_4__c", "Rec_LEHS_1_Outcome__c", 
		"Rec_LEHS_Outcome_2__c", "REC_LEAV_Outcome_1__c", "Rec_LEOL_Outcome_1__c",
		"Rec_LEOL_Outcome_2__c", "Rec_LEOM_Outcome_1__c", "Rec_LEOM_Outcome_2__c",
		"Rec_LEEM_Outcome_2__c", "Rec_LEOM_Outcome_3__c", "Rec_LEOM_Outcome_4__c",
		"Rec_LEOM_Outcome_5__c", "REC_LEMP_Outcome_1__c", "REC_LEMP_Outcome_2__c",
		"REC_LEMP_Outcome_3__c", "REC_LEMP_Outcome_4__c", "REC_LEMP_Outcome_5__c",
		"REC_LEMP_Outcome_6__c", "REC_LEMP_Outcome_7__c", "REC_LEMP_Outcome_8__c",
		"REC_LEMD_Outcome_1__c", "REC_LEMD_Outcome_2__c", "REC_LEMD_Outcome_3__c",
		"Rec_LEEM_Outcome_1__c", "REC_LEPT_Outcome_1__c", "REC_LEMQ_Outcome_1__c"
		];
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
	},

})