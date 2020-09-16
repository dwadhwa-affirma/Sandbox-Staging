({
    
    
    ApproveTransactions: function(component, event,helper, recordId, actionType) {
        var action = component.get("c.ApproveTransaction");
        var wires = JSON.stringify(component.get("v.WiresObject"))
        action.setParams({"WiresRecordId": recordId, "Action": actionType,
                          "wiresdetails": wires
                         });
        
        action.setCallback(this, function (response) {
            debugger;
            var status = response.getState();            
            if (component.isValid() && status === "SUCCESS") {
                var result = response.getReturnValue();
                if(actionType == 'Approve')
                    alert('Transaction Approved Successfully');
                else
                    alert('Transaction Rejected Successfully');  
                $A.get('e.force:refreshView').fire();
                location.reload();
            }            
        });	
        $A.enqueueAction(action);
        
        
    }, 
    SendToFraud:function(component, event,helper,recordId){
        var action = component.get("c.SendToFraud");
        var wires = JSON.stringify(component.get("v.WiresObject"))
        action.setParams({"id": recordId});
        action.setCallback(this, function (response) {
            var status = response.getState();            
            if (component.isValid() && status === "SUCCESS") {
                alert('Transaction has been sent to fraud review.');
                location.reload();
            }            
        });	
        $A.enqueueAction(action);
    },
    SendToGoodFuncdCheckFailed:function(component, event,helper,recordId){
        var action = component.get("c.SendToGoodFundCheckFailed");
        var wires = JSON.stringify(component.get("v.WiresObject"))
        action.setParams({"id": recordId});
        action.setCallback(this, function (response) {
            var status = response.getState();            
            if (component.isValid() && status === "SUCCESS") {
                alert('Transaction has been sent to good fund check failed review.');
                location.reload();
            }            
        });	
        $A.enqueueAction(action);
    }
})