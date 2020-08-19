({
	doInit : function(component, event, helper) {
	    
		var recordId = component.get("v.recordId");
		var CLRecord = component.get("v.CLRecord");
        var type = CLRecord.Type__c;
        
        if(type == 'Change Card Limits')
        	component.set("v.ChangeCardLimitIsEnabled",true);
		
		
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
    	
    }
  
})