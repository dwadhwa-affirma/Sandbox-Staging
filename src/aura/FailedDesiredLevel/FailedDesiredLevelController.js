({
	doInit : function(component, event, helper) {
		
		var memberId = component.get("v.recordId");
		component.set("v.memberId",memberId );
		var GUID = component.get("v.GUID");
		if(memberId != null && memberId !=undefined )
		{
			helper.GetAuthenticationLevel(component, event, helper);
		}
		
	},
	
	 onChange: function (component, event, helper) {
       var selectedLevel = event.getSource().get('v.value');
       component.set("v.SelectedLevel",selectedLevel );
    },   
	closeFailedDesiredLevelModel: function(component, event, helper) {
    	compEvent = component.getEvent("statusEvent");
    	compEvent.setParams({"FDLShowPopup" :false});
						    	compEvent.fire();
    },
    FDLSaveClose :function(component, event, helper) {
    
    	var selectedLevel = component.get("v.SelectedLevel" );
    	errorSpaninput = document.getElementById('errorSpaninput');
    	 if(selectedLevel == undefined || selectedLevel == ''){
		    			errorSpaninput.classList.add('show');
		    			errorSpaninput.classList.remove('hidden');
		  }
		  else{
		  
			  compEvent = component.getEvent("statusEvent");
			  compEvent.setParams({"FDLShowPopup" :false,"FDLSelectedLevel":selectedLevel});
						    	compEvent.fire();
		  
		  }
		  
    	
		
        
    },
})