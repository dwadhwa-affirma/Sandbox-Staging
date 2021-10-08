({
    doInit : function(component, event,helper, recordId) {
        helper.getWiresTransactionData(component, event,recordId); 	
    },
    
    getWiresTransactionData : function(component, event,recordId){
        var action = component.get("c.getWiresData");
        action.setParams({"WiresRecordId": recordId});
        
        action.setCallback(this, function (response) {
            var status = response.getState();            
            if (component.isValid() && status === "SUCCESS") {
                var result = response.getReturnValue();
                component.set("v.isApprovalVisible",result.isApprovalVisible);
                console.log("Approval Status:"+result.ApprovalStatus);
                component.set("v.ApprovalStatus",result.ApprovalStatus);
                component.set("v.BalanceStatusCode",result.BalanceStatusCode);
                component.set("v.BalanceRGLines",result.BalanceRGLines?result.BalanceRGLines.trim():result.BalanceRGLines);
                component.set("v.WiresCount",result.WiresCount); 
                component.set("v.WiresObject",result.WiresList);
                component.set("v.Source",result.Source);
                component.set("v.MinGoodFundAmountCheck",result.MinGoodFundAmountCheck);
            }            
            
        });	
        $A.enqueueAction(action);
        
    },
    
    ApproveTransaction: function(component, event,helper, recordId) {
        
        
        var modalBody;
        var recId= component.get('v.recordId');       
        var source=component.get("v.Source");
        var modalCompName= source=='Branch' ? 'c:WiresApprovalReviewForBranch':'c:WiresApprovalReview';
        
        $A.createComponent(modalCompName, {recordId:recordId, 
                                           AccountOpenfor45Days : component.get('v.AccountOpenfor45Days'),
                                           MinGoodFundAmountCheck: component.get('v.MinGoodFundAmountCheck'),
                                           BalanceStatusCode : component.get('v.BalanceStatusCode'),
                                           BalanceRGLines : component.get('v.BalanceRGLines'),
                                           WiresCount : component.get('v.WiresCount'),
                                           WiresObject : component.get('v.WiresObject')},
                           function(content, status) {
                               if (status === "SUCCESS") {
                                   modalBody = content;
                                   component.find('overlayLib').showCustomModal({
                                       header: "Items to Review",
                                       body: modalBody, 
                                       showCloseButton: true,
                                       closeCallback: function() {
                                       }
                                   })
                               }                               
                           });
        
    },
    CancelTransaction: function(component, event,helper, recordId,reason) {
        var action = component.get("c.CancelTransaction");
        action.setParams({"WiresRecordId": recordId, "Reason": reason});
        action.setCallback(this, function (response) {
            var status = response.getState();            
            if (status === "SUCCESS") {
                var result = response.getReturnValue();
                alert('Transaction has been cancelled.');
                $A.get('e.force:refreshView').fire();
                location.reload();
            }            
        });	
        $A.enqueueAction(action);   
    }
})