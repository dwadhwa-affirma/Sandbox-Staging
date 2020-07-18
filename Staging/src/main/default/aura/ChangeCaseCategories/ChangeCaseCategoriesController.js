({
    selectUpdateCaseAction : function( cmp, event, helper) {
        var actionAPI = cmp.find("quickActionAPI");
        var args = {actionName: "Case.Update_Categories"};
        actionAPI.selectAction(args).then(function(result){
            
        }).catch(function(e){
           debugger;
            if(e.errors){
            }
                //If the specified action isn't found on the page, show an error message in the my component 
            
        });
        
         
        actionAPI.getAvailableActions().then(function(result){
            debugger;
            }).catch(function(e){
                if(e.errors){
                    //If the specified action isn't found on the page, show an error message in the my component 
                }
            });
    },
    
    doInit : function(component, event, helper) {
    	var action = component.get("c.getData");
	   var recordid = component.get("v.recordId");	  
	    var parameters = {"caseId": recordid };
	    
	    action.setParams(parameters);
		action.setCallback(this, function(response){
		var status = response.getState();
	        	if(component.isValid() && status === "SUCCESS")
	        	{
	        		var result =  response.getReturnValue();	
	        		
	        		component.set('v.hasAccess', result.hasAccess);	
	        		   	
			 		     		
	        	}            	
	       });
	   $A.enqueueAction(action);
    }
   
})