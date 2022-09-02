({
    
    ApproveTransactions: function(component, event,helper, recordId, actionType,isFromGoodFundCheck) {
        
        debugger;
        var action = component.get("c.ApproveTransaction");
        var wires = JSON.stringify(component.get("v.WiresObject"))
        action.setParams({"WiresRecordId": recordId, "Action": actionType,
                          "wiresdetails": wires
                         });
        
        action.setCallback(this, function (response) {
            
            var status = response.getState();            
            if (component.isValid() && status === "SUCCESS") {
                var result = response.getReturnValue();
                if(actionType == 'Approve'){
                    if(isFromGoodFundCheck) {
                        alert('Good Funds Deposit Found. Transaction has been Approved.');
                    }else{
                        alert('Transaction has been Approved.');   
                    }
                }else if(actionType == 'Pending for Approval'){
                    alert('Transaction has been sent for approval to review good fund.');  
                }
                    else{
                        if(isFromGoodFundCheck) {
                            alert('Good Funds Deposit Not Found. Transaction has been sent to Good Fund Review.');
                        }else{
                            alert('Transaction has been Rejected.');  
                        }
                    }
                $A.get('e.force:refreshView').fire();
                location.reload();
            }            
        });	
        $A.enqueueAction(action);
        
        
    }, 
    SendToFraud:function(component, event,helper,recordId, Reason){
        var action = component.get("c.SendToFraud");
        var wires = JSON.stringify(component.get("v.WiresObject"))
        action.setParams({"id": recordId , "Reason" : Reason});
        action.setCallback(this, function (response) {
            var status = response.getState();            
            if (component.isValid() && status === "SUCCESS") {
                alert('Transaction has been Fraud Rejected.');
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
    },
    
    GetIDVFailureDetails:function(component, event,helper,recordId){
    	debugger;
         this.showSpinner(component); 
        var action = component.get("c.GetFailedIDVDetails");        
        action.setParams({"WiresId": recordId});
        
        action.setCallback(this, function (response) {
            this.showSpinner(component); 
            var status = response.getState();            
            if (component.isValid() && status === "SUCCESS") {
                var result = response.getReturnValue();
                component.set("v.MARSDetails", result.MARSDetails);
                component.set("v.DocusignIDVFailureDetails",result.DocusignIDVFailureDetails);
                if(result.DocusignIDVFailureDetails != undefined && result.DocusignIDVFailureDetails != null){
                    var imagestring="data:image/png;base64,"+ result.DocusignIDVFailureDetails.IdFrontSideBase64EncodedString;
                    var backimagestring="data:image/png;base64,"+ result.DocusignIDVFailureDetails.IdBackSideBase64EncodedString;
                    component.set("v.IDFrontSideImage",imagestring);
                    component.set("v.IDBackSideImage",backimagestring);
                }
                
            }
			this.hideSpinner(component);            
        });	
        $A.enqueueAction(action);
	},
    
    showSpinner: function (component) {
    var spinnerMain = component.find("Spinner");
    $A.util.removeClass(spinnerMain, "slds-hide");
  },

  hideSpinner: function (component) {
    var spinnerMain = component.find("Spinner");
    $A.util.addClass(spinnerMain, "slds-hide");
  },
})