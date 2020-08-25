({
	doInit : function(component, event, helper) {
	    
		var recordId = component.get("v.recordId");
		var CLRecord = component.get("v.CLRecord");
        var type = CLRecord.Type__c;
        if(type == 'Change Card Limits'){
        	component.set("v.ChangeCardLimitIsEnabled",true);
            component.set("v.CLRecord.ATM_Usage_Limit__c",'510.00');
            component.set("v.CLRecord.Auth_POS_Limit__c",'2500.00');
        }
        else
			component.set("v.ChangeCardLimitIsEnabled",false);

	},
    
    onTypeChange: function (component, event, helper) {
        
        var type = event.getSource().get('v.value');    
    	component.set("v.CLRecord.Type__c",type);
    	
    	var evt = $A.get("e.c:ChangeLimitEvent");
        var CL = component.get("v.CLRecord");
        var isMemberSelected = component.get("v.isMemberSelected");
        
        if(CL != undefined){
            evt.setParams({ "CLRecord": CL, "isMemberSelected": isMemberSelected});
            evt.fire();
    	}
    	
    },
    
    handleChange: function (component, event, helper) {
        
        var evt = $A.get("e.c:ChangeLimitEvent");
        var CL = component.get("v.CLRecord");
        var isMemberSelected = component.get("v.isMemberSelected");
        
        if(CL != undefined){
            evt.setParams({ "CLRecord": CL, "isMemberSelected": isMemberSelected});
            evt.fire();
    	}
    	
    }
    
  
})