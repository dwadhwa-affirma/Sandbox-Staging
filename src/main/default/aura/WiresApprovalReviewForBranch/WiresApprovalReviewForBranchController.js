({
    doInit : function(component, event, helper) {
        var wireAmount=component.get("v.WiresObject.TotalFromAccount__c");
        var docusignStatus=component.get("v.WiresObject.Status__c");
        var isIDVUsed=component.get("v.WiresObject.Identity_Verification_Used__c");
        var RecordId = component.get("v.recordId");
        
        component.set("v.isApproveDisabled", true);
        
        var approvalStatus = component.get("v.WiresObject.Approval_Status__c");
        if(approvalStatus=='Pending for Second Approval'){
            if((component.get("v.WiresObject.Available_Balance2_Review__c") 
                && component.get("v.WiresObject.Previous_Wires2_Review__c"))==false){
                component.set("v.isApproveDisabled", true);
            }else{
                component.set("v.isApproveDisabled", false);    
            }
        }else{
            if((component.get("v.WiresObject.Available_Balance_Review__c") 
                && component.get("v.WiresObject.Previous_Wires_Review__c"))==false){
                component.set("v.isApproveDisabled", true);
            }else{
                component.set("v.isApproveDisabled", false);    
            }
        }
    },
    ApproveTransactions: function(component, event, helper) {
        var RecordId = component.get("v.recordId");
        helper.ApproveTransactions(component, event,helper,RecordId,"Approve");
    },
    RejectTransaction: function(component, event, helper) {
        var firstComment = JSON.stringify(component.get("v.WiresObject.First_Approval_Comment__c"));
        var secondComment = JSON.stringify(component.get("v.WiresObject.Second_Approval_Comment__c"));
        
        if(!firstComment && !secondComment){
            alert('Please provide comment for rejecting the transaction in comment box.')
        }else{
        var RecordId = component.get("v.recordId");
        helper.ApproveTransactions(component, event,helper,RecordId,"Reject");
        }
    },
    CancelTransaction:function(component, event, helper) {
        component.find("overlayLib1").notifyClose();
    },
    closeModal: function(component, event, helper) {
        $A.get('e.force:closeQuickAction').fire();
    }, 
    CloseDialog: function(component, event, helper) {
        component.find("overlayLib1").notifyClose();
    },
    onCheck: function(component, event, helper) {
        
        var approvalStatus = component.get("v.WiresObject.Approval_Status__c");
        if(approvalStatus=='Pending for Second Approval'){
            if((component.get("v.WiresObject.Available_Balance2_Review__c") 
                && component.get("v.WiresObject.Previous_Wires2_Review__c"))==false){
                component.set("v.isApproveDisabled", true);
            }else{
                component.set("v.isApproveDisabled", false);    
            }
        }else{
            if((component.get("v.WiresObject.Available_Balance_Review__c") 
                && component.get("v.WiresObject.Previous_Wires_Review__c"))==false){
                component.set("v.isApproveDisabled", true);
            }else{
                component.set("v.isApproveDisabled", false);    
            }
        }
    }
})