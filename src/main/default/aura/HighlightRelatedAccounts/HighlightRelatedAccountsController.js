({
	doInit : function(component, event, helper) {
	
	
	    var action = component.get("c.GetCaseAccounts");
	    	    var caseid = component.get("v.recordId");	
	  
	    action.setParams({
	    	"CaseId" : caseid    
	    });	
	    
	     action.setCallback(this, function(response){
	     debugger;
	    	var state = response.getState();
	        if (state === "SUCCESS") {
	        	var result =  response.getReturnValue();
	        	if(result.length >0 ){	        	
	        		var arrTabs = document.getElementsByClassName("title");
			        for(var i = 0; i < arrTabs.length; i++){
			        	if (arrTabs[i].textContent == "Related Accounts"){//			        		
			        		arrTabs[i].parentElement.parentElement.className += " heighLight";
			        		arrTabs[i].parentElement.parentElement.parentElement.className += " heighLightParent";
			        	}
			        }
	        	}
	        }
	        
	        });
	        
	    $A.enqueueAction(action);
		
	}
	    
})