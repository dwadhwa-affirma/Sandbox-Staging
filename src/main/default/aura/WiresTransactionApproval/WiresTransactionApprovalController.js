({
	doInit : function(component, event, helper) {
		
		var RecordId = component.get("v.recordId");
		helper.doInit(component, event,helper,RecordId);
		
	},
    ApproveTransaction: function(component, event, helper) {		
		var RecordId = component.get("v.recordId");
		helper.ApproveTransaction(component, event,helper,RecordId);	
	},
    handleConfirmDialog : function(component, event, helper) {
        component.set('v.showConfirmDialog', true);
        
        var yesButton=component.find("btnYes");
        yesButton.set("v.disabled",'disabled');
        
    },
    handleConfirmDialogYes : function(component, event, helper) {
        debugger;
        console.log('Yes');
        var reason = component.get("v.Reason");
        var RecordId = component.get("v.recordId");
        helper.CancelTransaction(component, event,helper,RecordId,reason);	
        component.set('v.showConfirmDialog', false);
    },
    handleConfirmDialogNo : function(component, event, helper) {
        console.log('No');
        component.set('v.showConfirmDialog', false);
    },
    commentKeyUp: function(component, event, helper) {
        debugger;
        var reason=component.get('v.Reason');
        var yesButton=component.find("btnYes");
        if(reason.length>0){
            yesButton.set("v.disabled",'');
        }else{
            yesButton.set("v.disabled",'disabled');
        }
    },
    handleWaitingonMember: function(component, event, helper) {
        var buttonClass = component.find('WaitingButton');
        var RecordId = component.get("v.recordId");
		if(component.get("v.WaitingOnMemberLabel") == 'Waiting On Member'){
            component.set("v.WaitingOnMemberLabel", "Continue");
            component.set("v.isWaitingOnMember", true);   
            $A.util.addClass(buttonClass, 'yellow');    
            helper.WaitingonMember(component, event,'Waiting', RecordId);
        }
        else if(component.get("v.WaitingOnMemberLabel") == 'Continue'){
            component.set("v.WaitingOnMemberLabel", "Waiting On Member");
            component.set("v.isWaitingOnMember", false);   
            $A.util.removeClass(buttonClass, 'yellow');
            helper.WaitingonMember(component, event,'Continue', RecordId);
        }
        
    }
})