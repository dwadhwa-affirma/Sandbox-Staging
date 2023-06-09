({
	doInit : function(component, event, helper) {
	    
        var action = component.get("c.getCardLimits");
		var recordId = component.get("v.recordId");
		var CLRecord = component.get("v.CLRecord");
        var memberNumber = CLRecord.Member_Number__c;
        var membername = CLRecord.Member_Name__c;
        var cardnumber = CLRecord.Card_Number__c;
        
        var type = CLRecord.Type__c;
        var isMemberSelected = component.get("v.isMemberSelected");
        var evt = $A.get("e.c:CardLimitResetEvent");
        var ATM = component.get("v.CLRecord.ATM_Usage_Limit__c");
        var AUTH = component.get("v.CLRecord.Auth_POS_Limit__c");
       
        if(type == 'Change Card Limits'){
            
            component.set("v.ChangeCardLimitIsEnabled",true);
            action.setParams({
                "recordId": recordId,
                "cardnumber": cardnumber,
                "membername": membername,
                "memberNumber": memberNumber
            });
            
            action.setCallback(this, function(resp) {
                var state=resp.getState();			
                if(state === "SUCCESS"){
                    var result =  resp.getReturnValue();
                    if(result != undefined){
                        if(result.AuthLimit != undefined && result.AuthLimit != '' && AUTH == undefined){
                            component.set("v.CLRecord.Auth_POS_Limit__c", result.AuthLimit);
                        }
                        else if(AUTH != undefined){
                            component.set("v.CLRecord.Auth_POS_Limit__c",AUTH);
                        }
                        else{
                            component.set("v.CLRecord.Auth_POS_Limit__c",'2500.00');
                        }
                        if(result.UsageLimit != undefined && result.UsageLimit != '' && ATM == undefined){
                            component.set("v.CLRecord.ATM_Usage_Limit__c", result.UsageLimit);
                        }
                        else if(ATM != undefined){
                        	component.set("v.CLRecord.ATM_Usage_Limit__c",ATM);   
                        }
                        else{
                        	component.set("v.CLRecord.ATM_Usage_Limit__c",'510.00');   
                        }
                        evt.setParams({ "CLRecord": CLRecord, "isMemberSelected": isMemberSelected});
            			evt.fire();
                    }
                }
            });
            $A.enqueueAction(action);
        }
        else{
			component.set("v.ChangeCardLimitIsEnabled",false);
        }

	},
    
    onTypeChange: function (component, event, helper) {
        
        var type = event.getSource().get('v.value');    
    	component.set("v.CLRecord.Type__c",type);
    	
    	var evt = $A.get("e.c:CardLimitResetEvent");
        var CL = component.get("v.CLRecord");
        
        var isMemberSelected = component.get("v.isMemberSelected");
        
        if(CL != undefined){
            evt.setParams({ "CLRecord": CL, "isMemberSelected": isMemberSelected});
            evt.fire();
    	}
    	
    },
    
    handleChange: function (component, event, helper) {
        
        var evt = $A.get("e.c:CardLimitResetEvent");
        var CL = component.get("v.CLRecord");
        var isMemberSelected = component.get("v.isMemberSelected");
        var ATM = component.get("v.CLRecord.ATM_Usage_Limit__c");
        var AUTH = component.get("v.CLRecord.Auth_POS_Limit__c");
        
        component.set("v.CLRecord.ATM_Usage_Limit__c",ATM);
        component.set("v.CLRecord.Auth_POS_Limit__c",AUTH);
        
        if(CL != undefined){
            evt.setParams({ "CLRecord": CL, "isMemberSelected": isMemberSelected});
            evt.fire();
    	}
    	
    }
    
  
})