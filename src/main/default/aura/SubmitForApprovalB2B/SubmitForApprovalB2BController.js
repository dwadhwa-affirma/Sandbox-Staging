({
	doInit : function(component, event, helper) {
		
		var OpportunityId = component.get("v.recordId");
        var action = component.get("c.getProfileName");
        action.setParams({"OpportunityId": OpportunityId});
            
        action.setCallback(this, function(response) {
            var status = response.getState();
             if (component.isValid() && status === "SUCCESS") {
                var result = response.getReturnValue();
                if(result.SaveDisabled != undefined){
                    if(result.SaveDisabled == 'true'){
                	    component.set("v.SaveDisabled", true);    
                	}
                }
            }
        });
        $A.enqueueAction(action);
  	},
    
    cancel: function(component, event, helper) {
     	
        $A.get("e.force:closeQuickAction").fire() 
    },

    save: function(component, event, helper) {
     	
        var OpportunityId = component.get("v.recordId");
        var SEGStatus = component.get("v.simpleRecord.SEG_Status__c");
        var action = component.get("c.saveOpportunity");
        
        action.setParams({"OpportunityId": OpportunityId,
                          "SEGStatus": SEGStatus});
                          
            
        action.setCallback(this, function(response) {
            var status = response.getState();
            if (component.isValid() && status === "SUCCESS") {
                var result = response.getReturnValue();
                if(result.OppClosed == 'True'){
                   component.set("v.OppClosed", true);    
                }
                else{
                    $A.get("e.force:closeQuickAction").fire();
                    $A.get('e.force:refreshView').fire();
                }
            }
        });
        $A.enqueueAction(action);
        
    }
})