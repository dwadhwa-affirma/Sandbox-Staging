({
	helperMethod : function() {
		
	},
	buildPicklist: function(component, index, optionValues) {
		var opts = [];	
		opts.push({
			class: "optionClass",
			label: "--- NONE ---",
			value: ""
			});
		if(optionValues != undefined)
		{
			for (var i = 0; i < optionValues.length; i++) {
				opts.push({
				class: "optionClass",
				value: optionValues[i].toUpperCase(),
				label: optionValues[i].toUpperCase()
				});
			}
		}
	/*	var a = document.getElementsByClassName("clsContrySelect")[index];
		var o=new Option("--- None --", "");
		o.setAttribute("class","optionClass");
		a.options[0] = o;
		if(optionValues != undefined)
		{
			for (var i = 1; i <= optionValues.length; i++) {
				var o1 =new Option(optionValues[i], optionValues[i]);
				o1.setAttribute("class","optionClass");				
				a.options[i] = o1;
			}
		}*/
		component.set("v.options", component.get("v.item"));
		//a.set("v.options", opts);
	},
	
	fetchCountryData : function(component, index) {	
			var action = component.get("c.getCountryData");		
			action.setCallback(this, function(resp) {
				var state=resp.getState();			
				if(state === "SUCCESS"){					
					var res = resp.getReturnValue();
					console.log(res);		
					component.set("v.item", res);			
					this.buildPicklist(component, index, res);				
				}
			});
			
			$A.enqueueAction(action);
			
	},
	
	 validateRequired : function(component){
     // fire the DeleteRowEvt Lightning Event and pass the deleted Row Index to Event parameter/attribute
       component.getEvent("ValidateRequiredEvt").setParams({"indexVar" : component.get("v.rowIndex") }).fire();
    },
})