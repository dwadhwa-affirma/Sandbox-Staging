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
                component.set("v.Frequency",result.WiresList.Frequency__c);                
                component.set("v.MinGoodFundAmountCheck",result.MinGoodFundAmountCheck);
                
                if(result.SLABreached == true){                    
                    component.set("v.isWaitingOnMember", true);
                }
                else{
                    component.set("v.isWaitingOnMember", false);                   
                }    

                if((result.ApprovalStatus == 'Fraud Review' || result.ApprovalStatus == 'Pending for Approval' || result.ApprovalStatus == 'Pending for Second Approval') && (result.SLABreached == false)){
                    component.set("v.isWaitingOnMemberVisible",true);
                }
                else{
                    component.set("v.isWaitingOnMemberVisible",false);
                }

                var buttonClass = component.find('WaitingButton');
                if(result.WaitingForMember == true){
                    component.set("v.WaitingOnMemberLabel", "Continue");
                    component.set("v.isWaitingOnMember", true);                    
                    $A.util.addClass(buttonClass, 'yellow');                   
                }
                else{
                    component.set("v.WaitingOnMemberLabel", "Waiting On Member");
                    component.set("v.isWaitingOnMember", false);  
                    $A.util.removeClass(buttonClass, 'yellow');                   
                }  
            
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
    },

    WaitingonMember: function(component, event, action, RecordId){
        this.showSpinner(component);
        var actionmethod = component.get("c.WaitingOnMember");
        actionmethod.setParams({"WiresId": RecordId, "Action": action});
        actionmethod.setCallback(this, function (response) {
            var status = response.getState();            
            if (status === "SUCCESS") {
                var result = response.getReturnValue();                
                $A.get('e.force:refreshView').fire();               
            }  
            this.hideSpinner(component);          
        });	
        $A.enqueueAction(actionmethod); 
    },

    showSpinner: function (component) {
        var spinnerMain = component.find("Spinner");
        $A.util.removeClass(spinnerMain, "slds-hide");
      },
    
      hideSpinner: function (component) {
        var spinnerMain = component.find("Spinner");
        $A.util.addClass(spinnerMain, "slds-hide");
      }
})