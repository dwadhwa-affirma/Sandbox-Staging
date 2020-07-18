({
	doInit : function(component, event, helper) {
        if(!component.get("v.WiresObject.FlagAccountOpenfor45Days__c") ||
          !component.get("v.WiresObject.FlagEmailStablefor30Days__c") ||
          !component.get("v.WiresObject.FlagHomePhoneStablefor30Days__c") ||
          !component.get("v.WiresObject.FlagMobilePhoneStablefor30Days__c") ||
           !component.get("v.WiresObject.FlagWorkPhoneStablefor30Days__c")){
             component.set("v.isReasonRequired",true);
        }
	/*var accDays = component.get("v.WiresObject.AccountOpenfor45Days");
		 if(accDays.indexOf("Wires_Green_Check") > -1){
                    component.set("v.AccountOpenfor45Days","Green");
             		
                }
                else{
                   component.set("v.AccountOpenfor45Days","Red"); 
                    component.set("v.isReasonRequired",true);
                }
       	var emailStable = component.get("v.EmailStable");
		if(emailStable.indexOf("Wires_EmailGreen") > -1){
                    component.set("v.EmailStable","Green");
                }
        else{
                   component.set("v.EmailStable","Red");
             	   component.set("v.isReasonRequired",true);
            }
        var homephoneStable = component.get("v.HomePhoneStable");
        if(homephoneStable.indexOf("Wires_HomePhoneGreen") > -1){
                    component.set("v.HomePhoneStable","Green");
                }
                else{
                   component.set("v.HomePhoneStable","Red"); 
                     component.set("v.isReasonRequired",true);
                }
        var workphoneStable = component.get("v.WorkPhoneStable");
        if(workphoneStable.indexOf("Wires_WorkPhoneGreen") > -1){
                    component.set("v.WorkPhoneStable","Green");
                }
                else{
                   component.set("v.WorkPhoneStable","Red"); 
                     component.set("v.isReasonRequired",true);
                }
        var mobilephoneStable = component.get("v.MobilePhoneStable");
        if(mobilephoneStable.indexOf("Wires_MobilePhoneGreen") > -1){
           	component.set("v.MobilePhoneStable","Green");
        }
        else{
              component.set("v.MobilePhoneStable","Red"); 
             component.set("v.isReasonRequired",true);
        }*/
        
        
        
       
	
	},
    
     
    ApproveTransactions: function(component, event, helper) {
        var RecordId = component.get("v.recordId");
		helper.ApproveTransactions(component, event,helper,RecordId,"Approve");
    },
    
    RejectTransaction: function(component, event, helper) {
        var RecordId = component.get("v.recordId");
		helper.ApproveTransactions(component, event,helper,RecordId,"Reject");
    },
    
     closeModal: function(component, event, helper) {
	  $A.get('e.force:closeQuickAction').fire();
   }, 
    
    onCheck: function(component, event, helper) {
        if(component.get("v.WiresObject.Approval_Status__c") == 'Pending for Approval'){
                 if(!component.get("v.isReasonRequired") && component.get("v.WiresObject.AccountStableReview__c") &&
                  component.get("v.WiresObject.Available_Balance_Review__c") &&
                  component.get("v.WiresObject.EmailStableReview__c") &&
                  component.get("v.WiresObject.Home_Phone_Stable_Review__c") &&
                  component.get("v.WiresObject.ID_Verification_Review__c") &&
                   component.get("v.WiresObject.Mobile_Phone_Stable_Review__c") &&
                   component.get("v.WiresObject.Previous_Wires_Review__c") &&
                   component.get("v.WiresObject.Work_Phone_Stable_Review__c") ){
                    component.set("v.isApproveDisabled", false);
                }
                else if(component.get("v.isReasonRequired") && component.get("v.WiresObject.AccountStableReview__c") &&
                  component.get("v.WiresObject.Available_Balance_Review__c") &&
                  component.get("v.WiresObject.EmailStableReview__c") &&
                  component.get("v.WiresObject.Home_Phone_Stable_Review__c") &&
                  component.get("v.WiresObject.ID_Verification_Review__c") &&
                   component.get("v.WiresObject.Mobile_Phone_Stable_Review__c") &&
                   component.get("v.WiresObject.Previous_Wires_Review__c") &&
                   component.get("v.WiresObject.Work_Phone_Stable_Review__c") && (component.get("v.WiresObject.Review_Reason__c") != "" && component.get("v.WiresObject.Review_Reason__c") != undefined)){
                    component.set("v.isApproveDisabled", false);
                }
                else{
                    component.set("v.isApproveDisabled", true);
                }
     		}
        if(component.get("v.WiresObject.Approval_Status__c") == 'Pending for Second Approval'){
                 if(!component.get("v.isReasonRequired") && component.get("v.WiresObject.Account_Stable_2nd_Review__c") &&
                  component.get("v.WiresObject.Available_Balance_2nd_Review__c") &&
                  component.get("v.WiresObject.Email_Stable_2nd_Review__c") &&
                  component.get("v.WiresObject.Home_Phone_Stable_2nd_Review__c") &&
                  component.get("v.WiresObject.ID_Verification_2nd_Review__c") &&
                   component.get("v.WiresObject.Mobile_Phone_Stable_2nd_Review__c") &&
                   component.get("v.WiresObject.Previous_Wires_2nd_Review__c") &&
                   component.get("v.WiresObject.Work_Phone_Stable_2nd_Review__c") ){
                    component.set("v.isApproveDisabled", false);
                }
                else if(component.get("v.isReasonRequired") && component.get("v.WiresObject.Account_Stable_2nd_Review__c") &&
                  component.get("v.WiresObject.Available_Balance_2nd_Review__c") &&
                  component.get("v.WiresObject.Email_Stable_2nd_Review__c") &&
                  component.get("v.WiresObject.Home_Phone_Stable_2nd_Review__c") &&
                  component.get("v.WiresObject.ID_Verification_2nd_Review__c") &&
                   component.get("v.WiresObject.Mobile_Phone_Stable_2nd_Review__c") &&
                   component.get("v.WiresObject.Previous_Wires_2nd_Review__c") &&
                   component.get("v.WiresObject.Work_Phone_Stable_2nd_Review__c") && (component.get("v.WiresObject.Second_Approval_Review_Reason__c") != "" && component.get("v.WiresObject.Second_Approval_Review_Reason__c") != undefined)){
                    component.set("v.isApproveDisabled", false);
                }
                else{
                    component.set("v.isApproveDisabled", true);
                }
     		}
	  
   }, 
   
})