({
	doInit : function(component, event, helper) {
	
		var valueToDisplay = component.get("v.valueToDisplay");
		var valueToCompare = component.get("v.valueToCompare");
		var isPhoneNo = component.get("v.isPhoneNo");
		
		if(isPhoneNo){
		var valueToDisplay1, valueToCompare1;
			if(valueToDisplay != undefined && valueToDisplay != '')
				valueToDisplay1 = valueToDisplay.replace(/-/g,'').replace(/\(|\)/g,'');
			if(valueToCompare != undefined && valueToCompare != '')
				valueToCompare1 = valueToCompare.replace(/-/g,'').replace(/\(|\)/g,'')
				if(valueToDisplay1 !== undefined && valueToCompare1 !== undefined && valueToDisplay1 !== null && valueToCompare1 !== null && valueToDisplay1.toUpperCase() === valueToCompare1.toUpperCase()){
					component.set('v.IsNeedToHighLight',true);
				}else{
					component.set('v.IsNeedToHighLight',false);
				}
			
		}	
		else{	
			if(valueToDisplay !== undefined && valueToCompare !== undefined && valueToDisplay !== null && valueToCompare !== null && valueToDisplay.toUpperCase() === valueToCompare.toUpperCase()){
				component.set('v.IsNeedToHighLight',true);
			}else{
				component.set('v.IsNeedToHighLight',false);
			}
		}
	},
	
		 openAccount: function (component, event, helper) {
		 
		var currentId = event.target.id; 
		
       if(currentId != undefined && currentId != null && currentId != '')
		{
			var navEvt = $A.get("e.force:navigateToSObject");
	        navEvt.setParams({
	        	"recordId": currentId
	        	
	        });
	        navEvt.fire();        
	        component.set("v.loading", false);
		}
	 },
})