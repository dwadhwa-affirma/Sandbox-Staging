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
        }
        
        
    },
    
      handleEvent: function(component, event, helper) {
    	var message = event.getParam("message");
    	alert(message);
	},
})