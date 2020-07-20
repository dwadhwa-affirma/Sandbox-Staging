({
	doInit : function(component, event, helper) {
        debugger;
        helper.showSpinner(component);
        if(component.get("v.EFTRecord.Expired__c")){
            component.set("v.UpdateText","Expire");
        }
        
        if(component.get("v.isDocusignEmailSelected") && component.get("v.EFTRecord.Action_Type__c") != 'Expire' && !component.get("v.EFTRecord.Expired__c")
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
				
				}
			});
        $A.enqueueAction(action);
        }
        
        else if(component.get("v.isDocusignEmailSelected") == false 
        		&& component.get("v.EFTRecord.Action_Type__c") != 'Expire' 
        		&& !component.get("v.EFTRecord.Expired__c")
        		&& component.get("v.EFTRecord.Action_Type__c") != 'View'){
		var action = component.get("c.getEpisysEmailAddresses");
		var recordId = component.get("v.recordId");	
		action.setParams({
		"recordId": component.get("v.recordId")
		});	
		action.setCallback(this, function(resp) {			
			var state=resp.getState();			
			if(state === "SUCCESS"){				
				var res = resp.getReturnValue();
                var emailList = res["EmailIds"];
                component.set("v.EmailIdsList",emailList);
                	
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
	
	onEmailChange: function (component, event, helper) {
    	var MemberEmail = event.getSource().get('v.value');    
    	component.set("v.EFTRecord.Docusign_Member_Email__c",MemberEmail);
    	
    	var evt = $A.get("e.c:EFTEvent");
        var EFT = component.get("v.EFTRecord");
        var isDocusignEmailSelected = true;
        
		if(EFT != undefined){
            evt.setParams({ "EFTRecord": EFT, "isDocusignEmailSelected": isDocusignEmailSelected});
            evt.fire();
        }
    }
	
	
})