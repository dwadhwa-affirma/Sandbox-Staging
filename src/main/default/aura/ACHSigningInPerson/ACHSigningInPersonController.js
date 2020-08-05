({
    Init : function(component, event, helper) {
        debugger;
        helper.doInit(component, event, helper);
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
                if(res.Alternate_Amount__c == undefined || res.Alternate_Amount__c == '' || res.Alternate_Amount__c == null){
                    component.set("v.EFTRecord.isAlternateAmount__c",false);
                }
                else{
                    component.set("v.EFTRecord.isAlternateAmount__c",true);
                }
                				
				}
			});
        $A.enqueueAction(action);
        
        let today = new Date();
        let todayDate= today.getMonth()+1 +'/'+today.getDate()+"/"+today.getFullYear();
        component.set("v.todayDate",todayDate);
        
        var cmpTarget = component.find('eSignDiv');
	  	$A.util.addClass(cmpTarget, 'hidediv');
    },
    erase:function(component, event, helper){
        helper.eraseHelper(component, event, helper);
    },
    save:function(component, event, helper){        
        component.set('v.loading', true);
        component.set("v.saveDisabled",true);
        //event.target.set("v.disabled", true);
        helper.saveHelper(component, event, helper, component.get("v.EFTRecord"));
    },
    handleMemberSignatureClick:function(component, event, helper){
        var attachementId = component.get("v.attachmentId");
        if(!attachementId) {
         	var eSignDiv=component.find("eSignDiv");
                $A.util.removeClass(eSignDiv, 'hidediv');
                $A.util.addClass(eSignDiv, 'showdiv');
        
        		var authwrapDiv=component.find("authwrap");
                $A.util.removeClass(authwrapDiv, 'showdiv');
                $A.util.addClass(authwrapDiv,'hidediv'); 
        }
    },
    handleDoneClick:function(component, event, helper){
        helper.savePDF(component, event, helper);
    },
    cancelAction: function(component, event, helper) {
        $A.get("e.force:closeQuickAction").fire();
    }
})