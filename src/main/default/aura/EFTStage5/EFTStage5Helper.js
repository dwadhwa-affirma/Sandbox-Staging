({
	getDaysPicklist : function(component, event) {
		var action = component.get("c.getDaysofMonth");
        var inputState = component.find("daysPicklist");
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var result = response.getReturnValue();
                var daysMap = [];
                		
            daysMap.push({
                class: "optionClass",
                label: "--- None ---",
                value: "",
                selected: "false"
            });
            for(var key in result){
            	var selected=false;
            	if(component.get("v.EFTRecord.Day_of_Month__c") == result[key])
            	selected=true;
            	else
            	selected=false;
                daysMap.push({"class": "optionClass", label: key, value: result[key], selected: selected});
            }            
            inputState.set("v.options", daysMap);
              /*  for(var key in result){
                    daysMap.push({key: key, value: result[key]});
                }*/
              //  component.set("v.daysMap", daysMap);
            }
        });
        $A.enqueueAction(action);
	}
})