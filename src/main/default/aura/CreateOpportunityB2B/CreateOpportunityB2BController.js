({
	doInit : function(component, event, helper) {
     
	 var action = component.get("c.FetchLeadData");
     //component.find("objOpportunityStage").set("v.disabled", true);
     var recordid = component.get("v.recordId");        
     action.setParams({ "AccountID": recordid });
     component.set("v.loading", true);
	 component.set('v.simpleRecord.AccountId', recordid);
	 
        	action.setCallback(this, function (response) {        	
            var status = response.getState();            
            if (component.isValid() && status === "SUCCESS") {
                var result = response.getReturnValue();                
                component.set("v.loading", false);               
                component.set('v.simpleRecord.StageName','New');
                //component.set('v.simpleRecord.AccountID',recordid);
                component.set("v.RecordTypeName",result[2] );
                
            }
        });  
        
        $A.enqueueAction(action);
	},
	
	closePopup: function(component, event, helper) {
	  $A.get('e.force:closeQuickAction').fire();
        
        var isQuickAction = component.get("v.isQuickAction");
       if(!isQuickAction) {
           	component.find("overlayLib").notifyClose();
       }
   },
   
   SaveOpportunity: function (component, event, helper) {
    
       var objOpp = component.get("v.simpleRecord");
       var isValid = helper.handleError(component,event,helper); 
       if(isValid){
       		component.set("v.loading", true);
    		helper.HandleSaveOpportunity(component, objOpp); 
       }
    },
    
   
})