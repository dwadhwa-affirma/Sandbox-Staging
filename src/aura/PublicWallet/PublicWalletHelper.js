({
	getDLStateIdPassport: function (component, event, memberId) {
	
	var action = component.get("c.getPublicWalletInfo");
	action.setParams({"MemberId": memberId});
    action.setCallback(this, function (response) {
	var status = response.getState();            
		if (component.isValid() && status === "SUCCESS") {
			var result = response.getReturnValue();
        
			if(result.DLcode != undefined){
				component.set("v.DLStateIdPassport",result['DLcode']);
			}
			if(result.BDate.length > 0){
				component.set("v.BirthDate",result['BDate']);
			}
			if(result.ZCode.length > 0){
				component.set("v.ZipCode",result['ZCode']);
			}
			if(result.Emails.length > 0){
				component.set("v.Emails",result['Emails']);
			}
			if(result.MothersMaidenName.length > 0){
				component.set("v.MothersMaidenName", result.MothersMaidenName);
			}
	    }
	    });	
		  
		$A.enqueueAction(action); 
    	 
    	
    },
    
    saveMethod : function(component, event, memberId, status) {
    
    	
	    	var action = component.get("c.PublicWalletSaveLogData");
	    	var GUID = component.get("v.GUID");
	        action.setParams({"MemberId": memberId, "Status": status, "GUID" : GUID});
	        action.setCallback(this, function (response) {
			var status = response.getState();            
		    if (component.isValid() && status === "SUCCESS") {
		    	var result = response.getReturnValue();
		    }
		    else
		    {
		    	compEvent = component.getEvent("statusEvent");
		    }
		   	});	
		   	
		   	$A.enqueueAction(action);
	   
    
    },
    
    
        
  
})