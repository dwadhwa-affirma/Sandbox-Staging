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
    },
    
    getEFTPaymentDate : function(component, event) {
        var EffectiveDate = component.get("v.EFTRecord.Effective_Date__c");
        var Day1 = component.get("v.EFTRecord.Day_of_Month__c");

        var action = component.get("c.getEFTPaymentDate");
        action.setParams({
            "EffectiveDate": EffectiveDate,
            "Day1": Day1
        });
        action.setCallback(this, function(result) {
            var state = result.getState();
            if (component.isValid() && state === "SUCCESS"){
                var resultData = result.getReturnValue();
                component.set("v.EFTRecord.EFT_Payment_Date__c", resultData);                
            }
        });
        $A.enqueueAction(action);
    },

    CheckValidEffectiveDate : function(component, event, EnteredEffectiveDate) {            

        var action = component.get("c.CheckValidEffectiveDate");
        action.setParams({
            "EnteredEffectiveDate": EnteredEffectiveDate
        });
        action.setCallback(this, function(result) {
            var state = result.getState();
            if (component.isValid() && state === "SUCCESS"){
                var resultData = result.getReturnValue();
                if(resultData.isValid == 'false'){
                    component.set("v.EFTRecord.Effective_Date__c", ''); 
                    alert(resultData.ErrorMessage);
                }
            }
        });
        $A.enqueueAction(action);
    }
})