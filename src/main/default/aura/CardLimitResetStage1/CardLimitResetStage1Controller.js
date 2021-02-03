({
	doInit : function(component, event, helper) {
	    
        var action = component.get("c.getMembers");
		var recordId = component.get("v.recordId");
        var evt = $A.get("e.c:CardLimitResetEvent");
        action.setParams({
			"recordId": recordId
		});			
		action.setCallback(this, function(resp) {
			var state=resp.getState();			
			if(state === "SUCCESS"){
				var result =  resp.getReturnValue();
				result.PersonList.sort(helper.Sort);
				for(var i=0;i<result.PersonList.length;i++){
					var tt = result.PersonList[i].TypeTranslate__c.substring(5);
					result.PersonList[i].TypeTranslate__c = tt;
				}
                evt.setParams({ "CLRecord": '', "isMemberSelected": true});
            	evt.fire();
                component.set("v.isMemberSelected",true);
	        	component.set('v.paList', result.PersonList);    					
			}
		});
		
		$A.enqueueAction(action);
		
	},   
     
    onMemberChange: function (component, event, helper) {
    	var MemberName = event.getSource().get('v.value');    
    	component.set("v.CLRecord.Member_Name__c",MemberName);
    	
    	var evt = $A.get("e.c:CardLimitResetEvent");
        var CL = component.get("v.CLRecord");
        var isMemberSelected = component.get("v.isMemberSelected");
        
        if(CL != undefined){
            evt.setParams({ "CLRecord": CL, "isMemberSelected": isMemberSelected});
            evt.fire();
    	}
    }
  
})