({
	doInit : function(component, event, helper) {
        debugger;
        helper.showSpinner(component);
        if(component.get("v.EFTRecord.Expired__c")){
            component.set("v.UpdateText","Expire");
        }
        
        if(component.get("v.EFTRecord.Action_Type__c") != 'Expire' && !component.get("v.EFTRecord.Expired__c")
           && component.get("v.EFTRecord.Action_Type__c") != 'View'){
		var action = component.get("c.createCase");
		//var recordId = component.get("v.recordId");	
		action.setParams({
		"EFTRecord": component.get("v.EFTRecord")
		});	
		action.setCallback(this, function(resp) {			
			var state=resp.getState();			
			if(state === "SUCCESS"){				
				var res = resp.getReturnValue();
                component.set("v.EFTRecord",res);
                if(component.get("v.EFTRecord.Action_Type__c") == 'Create' || (component.get("v.EFTRecord.Action_Type__c") == 'Update' && !component.get("v.EFTRecord.Expired__c")))
				{
                    helper.sendACHDocument(component, event, helper);
                }
				/*var eft =[];
				eft=res;
                component.set("v.EFTRecord",eft[0]);
                component.set("v.CaseId",eft[0].Case__r.CaseNumber);
                alert(component.get("v.CaseId"));*/
				}
			});
        $A.enqueueAction(action);
        }
        
        if(component.get("v.EFTRecord.Action_Type__c") == 'View' || component.get("v.EFTRecord.Expired__c")){
		var action = component.get("c.getEFT");
		//var recordId = component.get("v.recordId");	
		action.setParams({
		"EFTRecord": component.get("v.EFTRecord")
		});	
		action.setCallback(this, function(resp) {			
			var state=resp.getState();			
			if(state === "SUCCESS"){
						
				var res = resp.getReturnValue();
                
                component.set("v.EFTRecord",res);
                if(!component.get("v.EFTRecord.Expired__c")){
                
                	component.set("v.EFTRecord.Action_Type__c", "View");
                	
                }
                helper.hideSpinner(component);
				}
			});
        $A.enqueueAction(action);
        }
	},
	
	
})