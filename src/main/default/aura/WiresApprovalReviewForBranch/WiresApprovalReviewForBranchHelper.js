({
    ApproveTransactions: function(component, event,helper, recordId, actionType) {
        var action = component.get("c.ApproveTransaction");
        var wires = JSON.stringify(component.get("v.WiresObject"));
        var approvalStatus = component.get("v.WiresObject.Approval_Status__c");
        var wireAmount=component.get("v.WiresObject.TotalFromAccount__c");
        action.setParams({"WiresRecordId": recordId, "Action": actionType,
                          "wiresdetails": wires
                         });
        
        action.setCallback(this, function (response) {
            var status = response.getState();            
            if (component.isValid() && status === "SUCCESS") {
                var result = response.getReturnValue();
                if(result ==true){
                    alert('The transaction has already been approved.');                    
                    location.reload();
                    return false;
                }
                else{
                    if(actionType == 'Approve')
                    {
                        if(wireAmount > 100000 && (approvalStatus=='Pending for Approval' || approvalStatus=='Good Funds Review')){
                            alert('Transaction has been sent for second approval.');   
                        }else{
                            alert('Transaction has been Approved.');   
                        }
                    }
                    else{
                        alert('Transaction has been Rejected.');  
                    }
                }
                
                $A.get('e.force:refreshView').fire();
                location.reload();
            }            
        });	
        $A.enqueueAction(action);   
    },

    SecondApproveTransaction: function(component, event,helper, recordId, actionType) {
        var action = component.get("c.ApproveTransactionSecondApproval");
        var wires = JSON.stringify(component.get("v.WiresObject"));
        var approvalStatus = component.get("v.WiresObject.Approval_Status__c");
        var wireAmount=component.get("v.WiresObject.TotalFromAccount__c");
        action.setParams({"WiresRecordId": recordId, "Action": actionType,
                          "wiresdetails": wires
                         });
        
        action.setCallback(this, function (response) {
            var status = response.getState();            
            if (component.isValid() && status === "SUCCESS") {
                var result = response.getReturnValue();
                if(result.isAlreadyApproved){
                    alert('The transaction has already been approved.');
                    return false;
                }
                else{
                    if(actionType == 'Approve')
                    {                        
                        alert('Transaction has been Approved.'); 
                        
                    }
                    else{
                        alert('Transaction has been Rejected.');  
                    }
                }
                
                $A.get('e.force:refreshView').fire();
                location.reload();
            }            
        });	
        $A.enqueueAction(action);   
    }
})