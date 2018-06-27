({
	doInit : function(component, event, helper) {
	
		component.set("v.IsThereCases", false);
	    var action = component.get("c.GetPagingData");
	    var accid = component.get("v.recordId");	 
	    action.setParams({
	    	"accid" : accid,
	        "PageNo": 1,
	        "PageSize":10	,
	        "SectionName":'active cases',
	        "SortDir":'',
	        "SortBy":'',
	        "SearchText":''      
	    });	
	    
	     action.setCallback(this, function(response){
	    	var state = response.getState();
	        if (state === "SUCCESS") {
	        	var result =  response.getReturnValue();
	        	if(result.accList.totalrecords >0 ){
	        		component.set("v.IsThereCases", true);
	        		
	        		var arrTabs = document.getElementsByClassName("title");
			        for(var i = 0; i < arrTabs.length; i++){
			        	if (arrTabs[i].textContent == "Accounts 360 View"){
			        		//component.set("v.tabIndex", i+1);
			        		arrTabs[i].parentElement.parentElement.parentElement.className += " heightLight";
			        	}
			        }
	        	}
	        }
	    });
	        
	    $A.enqueueAction(action);
		
	}
	    
})