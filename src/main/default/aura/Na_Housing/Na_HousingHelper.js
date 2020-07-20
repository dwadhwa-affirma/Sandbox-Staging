({
	fetchPicklistFields: function(component) {
		var picklistFields = component.get("v.picklistFields");
		 
		var NAFields = ["Do_you_Rent_or_Own__c", "LEHS_Current_Lender__c", "LEHS_Type_of_Mortgage__c", "LEHS_Planning_to_Purchase__c", "LEHS_Purchase_When__c", "LEHS_Have_Realtor__c"];
		picklistFields['Needs_Assesment__c'] = NAFields;
		 
		this.getPicklistValues(component,picklistFields);
	},
	
	fetchYearPickList: function(component) {
		var action = component.get("c.getYearPickList");
        action.setCallback(this, function (resp) {			
            var status = resp.getState();
            if (component.isValid() && status === "SUCCESS") {
                var res = resp.getReturnValue();
                this.buildYearPicklist(component, 'Needs_Assesment__c.LEHS_End_Year__c', res.data);
//                if(v.Model.LEHS_End_Year__c != null)
//                {
//                	component.set("c." + Needs_Assesment__c.LEHS_End_Year__c, Needs_Assesment__c.LEHS_End_Year__c);
//                }                
            }
        });    
        $A.enqueueAction(action);
	},
	
	 
	getPicklistValues : function(component, sobjFieldsmap) {		
		var action = component.get("c.getPicklistValues");
		debugger;
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
    
    buildYearPicklist: function(component, elementId, optionValues) {
     var LEHS_End_Year = component.get('v.Model.LEHS_End_Year__c');
		var opts = [];		
		for (var i = 0; i < optionValues.length; i++) {
			opts.push({
                class: "optionClass",
                value: optionValues[i].Value,
                label: optionValues[i].Text,
                selected: (optionValues[i].Value ==  LEHS_End_Year)
			});
		}
		component.find(elementId).set("v.options", opts);
	},
})