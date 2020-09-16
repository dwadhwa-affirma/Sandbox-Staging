({
    doInit : function(component, event, helper) {
        if(!component.get("v.WiresObject.FlagAccountOpenfor45Days__c") ||
           !component.get("v.WiresObject.FlagEmailStablefor30Days__c") ||
           !component.get("v.WiresObject.FlagHomePhoneStablefor30Days__c") ||
           !component.get("v.WiresObject.FlagMobilePhoneStablefor30Days__c") ||
           !component.get("v.WiresObject.FlagWorkPhoneStablefor30Days__c")){
            component.set("v.isReasonRequired",true);
        }
        
        var wireAmount=component.get("v.WiresObject.WireAmount__c");
        var docusignStatus=component.get("v.WiresObject.Status__c");
        var isIDVUsed=component.get("v.WiresObject.Identity_Verification_Used__c");
        var RecordId = component.get("v.recordId");
        
        if(wireAmount>5000) {
            component.set("v.isIDVAuthentication",true);
            if(docusignStatus!='Completed'){
                component.set("v.isIDVAuthDone",false);
            }else{
                component.set("v.isIDVAuthDone",true);
            }
        }
        
        if(wireAmount>10000) {
            component.set("v.isNextVisible",true);
        }
    },
    ApproveTransactions: function(component, event, helper) {
        var RecordId = component.get("v.recordId");
        helper.ApproveTransactions(component, event,helper,RecordId,"Approve");
    },
    
    RejectTransaction: function(component, event, helper) {
        var RecordId = component.get("v.recordId");
        helper.ApproveTransactions(component, event,helper,RecordId,"Reject");
    },
    CancelTransaction:function(component, event, helper) {
        component.find("overlayLib1").notifyClose();
    },
    NextTransactions:function(component, event, helper) {
        var wireAmount=component.get("v.WiresObject.WireAmount__c");
        if(wireAmount>10000) {
            component.set("v.isGoodFundCheck",true);
            component.set("v.isNextVisible",false);
        }
    },
    FailRedFlagsCheck:function(component, event, helper) {
        var RecordId = component.get("v.recordId");
        helper.SendToFraud(component, event, helper,RecordId);
    },
    FailGoodFundCheck:function(component, event, helper) {
        var RecordId = component.get("v.recordId");
        helper.SendToGoodFuncdCheckFailed(component, event, helper,RecordId);
    },
    closeModal: function(component, event, helper) {
        $A.get('e.force:closeQuickAction').fire();
    }, 
    CloseDialog: function(component, event, helper) {
        component.find("overlayLib1").notifyClose();
    },
    onCheck: function(component, event, helper) {
        var isGoodFundCheck=component.get("v.isGoodFundCheck");
        var isNextVisible=component.get("v.isNextVisible");
        
        if(component.get("v.WiresObject.Approval_Status__c") == 'Pending for Approval' || 
           component.get("v.WiresObject.Approval_Status__c") == 'Fraud Review'){
            if(!component.get("v.isReasonRequired") && 
               component.get("v.WiresObject.AccountStableReview__c") &&
               component.get("v.WiresObject.EmailStableReview__c") &&
               component.get("v.WiresObject.Home_Phone_Stable_Review__c") &&
               component.get("v.WiresObject.Mobile_Phone_Stable_Review__c") &&
               component.get("v.WiresObject.Work_Phone_Stable_Review__c") ){
                
                if(isNextVisible){
                    component.set("v.isNextDisabled", false);
                }else{
                    component.set("v.isApproveDisabled", false);
                }
            }
            else if(component.get("v.isReasonRequired") && 
                    component.get("v.WiresObject.AccountStableReview__c") &&
                    component.get("v.WiresObject.EmailStableReview__c") &&
                    component.get("v.WiresObject.Home_Phone_Stable_Review__c") &&
                    component.get("v.WiresObject.Mobile_Phone_Stable_Review__c") &&
                    component.get("v.WiresObject.Work_Phone_Stable_Review__c") 
                    && (component.get("v.WiresObject.Review_Reason__c") != "" && component.get("v.WiresObject.Review_Reason__c") != undefined)){
                if(isNextVisible){
                    component.set("v.isNextDisabled", false);
                }else{
                    component.set("v.isApproveDisabled", false);
                }
            }
                else{
                    if(isNextVisible){
                        component.set("v.isNextDisabled", true);
                    }else{
                        component.set("v.isApproveDisabled", true);
                    }
                }
        }
        
        if(isGoodFundCheck){
            if(component.get("v.WiresObject.Approval_Status__c") == 'Pending for Approval'){
                if(! component.get("v.WiresObject.Available_Balance_Review__c") &&
                   component.get("v.WiresObject.Previous_Wires_Review__c")){
                    component.set("v.isApproveDisabled", true);
                }else{
                    component.set("v.isApproveDisabled", false);
                }
            }
            
            if(component.get("v.WiresObject.Approval_Status__c") == 'Pending for Second Approval'){
                if(! component.get("v.WiresObject.Available_Balance_2nd_Review__c") &&
                   component.get("v.WiresObject.Previous_Wires_2nd_Review__c")){
                    component.set("v.isApproveDisabled", true);
                }else{
                    component.set("v.isApproveDisabled", false);
                }
            }
        }
    }
})