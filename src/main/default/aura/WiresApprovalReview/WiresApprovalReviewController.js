({
    doInit : function(component, event, helper) {        
        if(!component.get("v.WiresObject.FlagAccountOpenfor45Days__c") ||
           !component.get("v.WiresObject.FlagEmailStablefor30Days__c") ||
           !component.get("v.WiresObject.FlagHomePhoneStablefor30Days__c") ||
           !component.get("v.WiresObject.FlagMobilePhoneStablefor30Days__c") ||
           !component.get("v.WiresObject.FlagWorkPhoneStablefor30Days__c")){
            component.set("v.isReasonRequired",true);
        }       
        
        
        var wireAmount=component.get("v.WiresObject.TotalFromAccount__c");
        var docusignStatus=component.get("v.WiresObject.Status__c");
        var isIDVUsed=component.get("v.WiresObject.Identity_Verification_Used__c");
        var RecordId = component.get("v.recordId");
        var isIDVFailed = component.get("v.WiresObject.Docusign_IDV_Failure__c");
        var RecordId = component.get("v.recordId");
        
        if(isIDVFailed){
            component.set("v.isIDVFailed", true);
        }
        else{
            component.set("v.isIDVFailed", false);
        }
        
        if(isIDVFailed){
            helper.showSpinner(component);
            helper.GetIDVFailureDetails(component, event,helper,RecordId)
        }
        
        // Now onwards Docusign is required for all online wires of any amount
        //if(wireAmount>5000) {
            component.set("v.isIDVAuthentication",true);
            if(docusignStatus!='Completed'){
                component.set("v.isIDVAuthDone",false);
            }else{
                component.set("v.isIDVAuthDone",true);
            }
        //}
        
        var minGoodFundAmountCheck=component.get('v.MinGoodFundAmountCheck');
        if(wireAmount>minGoodFundAmountCheck) {
            component.set("v.isNextVisible",true); 
        }
      
        var isGoodFundCheck=component.get("v.isGoodFundCheck");
        var isNextVisible=component.get("v.isNextVisible");
        
         if(component.get("v.WiresObject.Approval_Status__c") == 'Pending for Approval' || 
           component.get("v.WiresObject.Approval_Status__c") == 'Fraud Review'){
            if(!component.get("v.isReasonRequired") && 
               component.get("v.WiresObject.AccountStableReview__c") &&
               component.get("v.WiresObject.EmailStableReview__c") &&
               component.get("v.WiresObject.Home_Phone_Stable_Review__c") &&
               component.get("v.WiresObject.Mobile_Phone_Stable_Review__c") &&
               component.get("v.WiresObject.Work_Phone_Stable_Review__c") &&
               component.get("v.WiresObject.Docusign_Review__c")){
                
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
                    component.get("v.WiresObject.Work_Phone_Stable_Review__c") &&
                    component.get("v.WiresObject.Docusign_Review__c")
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
                        //component.set("v.isApproveDisabled", false);
                    }else{
                        component.set("v.isApproveDisabled", true);
                    }
                }
        }
        if(!isIDVFailed){
            helper.hideSpinner(component);
        	component.set("v.isSpinnerVisible", false);
        }
        
        var AccountOpenfor45Days = component.get("v.WiresObject.FlagAccountOpenfor45Days__c");
        var EmailStable = component.get("v.WiresObject.FlagEmailStablefor30Days__c");
        var HomePhoneStable = component.get("v.WiresObject.FlagHomePhoneStablefor30Days__c");
        var MobilePhoneStable = component.get("v.WiresObject.FlagMobilePhoneStablefor30Days__c");
         var WorkPhoneStable = component.get("v.WiresObject.FlagWorkPhoneStablefor30Days__c");
        var DocusignStatus = component.get("v.WiresObject.Status__c");
        var IDVFailure = component.get("v.WiresObject.Docusign_IDV_Failure__c");
        if(AccountOpenfor45Days){
            component.set("v.WiresObject.AccountStableReview__c", true);
        }
        if(EmailStable){
            component.set("v.WiresObject.EmailStableReview__c", true);
        }
        if(HomePhoneStable){
            component.set("v.WiresObject.Home_Phone_Stable_Review__c", true);
        }
        if(MobilePhoneStable){
            component.set("v.WiresObject.Mobile_Phone_Stable_Review__c", true);
        }
        if(WorkPhoneStable){
            component.set("v.WiresObject.Work_Phone_Stable_Review__c", true);
        }
        if(DocusignStatus == "Completed" && IDVFailure == false){
            component.set("v.WiresObject.Docusign_Review__c", true);
        }
        
        if(AccountOpenfor45Days && EmailStable && HomePhoneStable && MobilePhoneStable && WorkPhoneStable && DocusignStatus == "Completed" && IDVFailure == false){
            component.set("v.isNextDisabled",false);
        }
       	
    },
    ApproveTransactions: function(component, event, helper) {
        var RecordId = component.get("v.recordId");
        helper.ApproveTransactions(component, event,helper,RecordId,"Approve",false);
    },
    RejectTransaction: function(component, event, helper) {
        
        var firstComment = JSON.stringify(component.get("v.WiresObject.First_Approval_Comment__c"));
        var secondComment = JSON.stringify(component.get("v.WiresObject.Second_Approval_Comment__c"));
        
        if(!firstComment && !secondComment){
            alert('Please provide comment for rejecting the transaction in comment box.')
        }else{
        
        var RecordId = component.get("v.recordId");
        helper.ApproveTransactions(component, event,helper,RecordId,"Reject",false);
        }
    },
    CancelTransaction:function(component, event, helper) {
        component.find("overlayLib1").notifyClose();
    },
    NextTransactions:function(component, event, helper) {
        var RecordId = component.get("v.recordId");
        var wireAmount=component.get("v.WiresObject.TotalFromAccount__c");
        var balanceStatusCode=component.get("v.BalanceStatusCode");
        var minGoodFundAmountCheck=component.get('v.MinGoodFundAmountCheck');
        if(wireAmount>minGoodFundAmountCheck) {
            if(balanceStatusCode<=0){
                helper.ApproveTransactions(component, event,helper,RecordId,"Good Funds Review",true);
            }else{
                if(wireAmount>250000){
                      helper.ApproveTransactions(component, event,helper,RecordId,"Pending for Approval",true);
                }else{
                    helper.ApproveTransactions(component, event,helper,RecordId,"Approve",true);
                }
            }   
        }
    },
    FailRedFlagsCheck:function(component, event, helper) {
        var RecordId = component.get("v.recordId");
        var Reason =component.get("v.WiresObject.Review_Reason__c");
        helper.SendToFraud(component, event, helper,RecordId, Reason);
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
        
        debugger;
        var isGoodFundCheck=component.get("v.isGoodFundCheck");
        var isNextVisible=component.get("v.isNextVisible");
        
        if(component.get("v.WiresObject.Approval_Status__c") == 'Pending for Approval' || 
           component.get("v.WiresObject.Approval_Status__c") == 'Fraud Review'){
            if(!component.get("v.isReasonRequired") && 
               component.get("v.WiresObject.AccountStableReview__c") &&
               component.get("v.WiresObject.EmailStableReview__c") &&
               component.get("v.WiresObject.Home_Phone_Stable_Review__c") &&
               component.get("v.WiresObject.Mobile_Phone_Stable_Review__c") &&
               component.get("v.WiresObject.Docusign_Review__c") &&
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
                    component.get("v.WiresObject.Docusign_Review__c") &&
                    component.get("v.WiresObject.Work_Phone_Stable_Review__c") 
                    && (component.get("v.WiresObject.Review_Reason__c") != "" 
                        && component.get("v.WiresObject.Review_Reason__c") != undefined)){
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
                if(!component.get("v.WiresObject.Available_Balance_Review__c") ||
                   (component.get("v.WiresObject.First_Approval_Comment__c") == undefined || component.get("v.WiresObject.First_Approval_Comment__c") == '') ){//component.get("v.WiresObject.Previous_Wires_Review__c")
                    component.set("v.isApproveDisabled", true);
                }else{
                    component.set("v.isApproveDisabled", false);
                }
            }
            
            if(component.get("v.WiresObject.Approval_Status__c") == 'Pending for Second Approval'){
                if(! component.get("v.WiresObject.Available_Balance_2nd_Review__c") ||
                   (component.get("v.WiresObject.First_Approval_Comment__c") == undefined || component.get("v.WiresObject.First_Approval_Comment__c") == '')){
                    component.set("v.isApproveDisabled", true);
                }else{
                    component.set("v.isApproveDisabled", false);
                }
            }
        }
        
        if(isNextVisible){
            if((!component.get("v.WiresObject.Available_Balance_Review__c") 
                 || (component.get("v.WiresObject.First_Approval_Comment__c") == undefined || component.get("v.WiresObject.First_Approval_Comment__c") == ''))){//component.get("v.WiresObject.Previous_Wires_Review__c"))==false
                
                component.set("v.isApproveDisabled", true);
                
                }else{
                	component.set("v.isApproveDisabled", false);    
                }
        }
    },
    
    openImage:function(component, event, helper) {
       
        var byteCharacters = atob(component.get("v.DocusignIDVFailureDetails.IdFrontSideBase64EncodedString"));
    	var byteNumbers = new Array(byteCharacters.length);
        for (var i = 0; i < byteCharacters.length; i++) {
            byteNumbers[i] = byteCharacters.charCodeAt(i);
        }
        var byteArray = new Uint8Array(byteNumbers);
        var file = new Blob([byteArray], { type: 'image/png;base64' });
        var fileURL = URL.createObjectURL(file);
        window.open(fileURL);
    }, 
    
    onCommentChange: function(component, event, helper) {
        debugger;
        var comment = event.getParam('value');
        var AvailableBalance = component.get("v.WiresObject.Available_Balance_Review__c");
        var BalanceCode = component.get("v.BalanceStatusCode");
        if(comment != undefined && comment != ''){
            if(BalanceCode<= 0 && AvailableBalance == true){
                component.set("v.isApproveDisabled", false); 
            }
            else if(BalanceCode<= 0 && AvailableBalance == false){
                component.set("v.isApproveDisabled", true); 
            }
            else if(BalanceCode > 0){
                component.set("v.isApproveDisabled", false); 
            }
        }
        else{
            component.set("v.isApproveDisabled", true);
        }
    }
})