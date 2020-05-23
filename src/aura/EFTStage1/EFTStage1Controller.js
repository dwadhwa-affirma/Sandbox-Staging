({
	myAction : function(component, event, helper) {
		
	},
    onRadioChange: function (component, event, helper) {
        var changeValue = event.getParam("value");
        var childRadio = document.getElementById('childRadio');
        if(changeValue == '2'){
        	component.set("v.ActionDisabled",false);    
            childRadio.classList.remove('disable');
            
        }
        if(changeValue == '1'){
        	component.set("v.ActionDisabled",true);    
            childRadio.classList.add('disable');
            component.set("v.EFTRecord.Action_Type__c",'Create');
        }
        
        var evt = $A.get("e.c:EFTEvent");
        var EFT = component.get("v.EFTRecord");
        
		if(EFT != undefined){
            evt.setParams({ "EFTRecord": EFT});
            evt.fire();
        }
        
        
    },

  
})