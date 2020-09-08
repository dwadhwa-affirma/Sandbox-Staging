({
	doInit : function(component, event, helper) {
	    
		var action = component.get("c.getCard");
		var recordId = component.get("v.recordId");
		var CLRecord = component.get("v.CLRecord");
        var memberName = CLRecord.Member_Name__c;
        action.setParams({
			"recordId": recordId,
            "sObjectType": memberName
		});			
		action.setCallback(this, function(resp) {
			var state=resp.getState();			
			if(state === "SUCCESS"){
				var result =  resp.getReturnValue();
                if(result != undefined){
                	component.set("v.caList", result);    					
                }
			}
		});
		
		$A.enqueueAction(action);
		
	},
    
    onCardChange: function (component, event, helper) {
    	var cardNumber = event.getSource().get('v.value');    
    	component.set("v.CLRecord.Card_Number__c",cardNumber);
    	
    	var evt = $A.get("e.c:CardLimitResetEvent");
        var CL = component.get("v.CLRecord");
        var isMemberSelected = component.get("v.isMemberSelected");
        
        if(CL != undefined){
            evt.setParams({ "CLRecord": CL, "isMemberSelected": isMemberSelected});
            evt.fire();
    	}
    }
  
})