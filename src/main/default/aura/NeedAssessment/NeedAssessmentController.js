({

    doInit: function (component, event, helper) {
        var action = component.get("c.FetchNeedAssessmentData");
        var recordid = component.get("v.recordId");
        action.setParams({ "accountid": recordid });
        component.set("v.loading", true);
        action.setCallback(this, function (response) {        	
            var status = response.getState();            
            if (component.isValid() && status === "SUCCESS") {
                var result = response.getReturnValue();
                
                component.set("v.Model", result);
                component.set("v.Overview", true);
                component.set("v.Housing", false);
                component.set("v.AutoVehicle", false);
                component.set("v.ContactPreference", false);
                component.set("v.CurrentFeedback", false);
                component.set("v.Withdrawals", false);
                component.set("v.SharedBranching", false);
                component.set("v.Deposits", false);
                component.set("v.PaymentsTransfers", false);
                component.set("v.ATMNETWORK", false);
                component.set("v.OtherMilestones", false);
                component.set("v.Recommendations", false);
                component.set("v.CurrentLoans", false);
                component.set("v.loading", false);    
                component.set("v.PrimaryAccount", false);   
                component.set("v.ExtendedBenefits", false);    
                component.set("v.EarnMore", false);                    
            }
        });  
                  
                     
        $A.enqueueAction(action);
    },
    
    onCheckoptOut : function(component, event, helper) {
    	var assessmentData = component.get("v.Model");    	
		helper.changeOptOut(component, assessmentData.AccountDetails.NA_Opt_Out__c, assessmentData.AccountDetails.Id);
	 }, 
    
    onGroup: function(component, event) {        
		 var selected = event.getSource().getLocalId();
		 component.set("v.SectionSelection", selected);
	 },
    
    selectTab: function (component, event, helper) {       
    
        var activeTab;
        activeTab = event.target.getAttribute("id");

        var activeTab = event.target.getAttribute("id");
        component.set("v.Overview", false);
        component.set("v.Housing", false);
        component.set("v.ContactPreference", false);
        component.set("v.AutoVehicle", false);
        component.set("v.CurrentFeedback", false);
         component.set("v.Withdrawals", false);
        component.set("v.SharedBranching", false);
         component.set("v.Deposits", false);
         component.set("v.PaymentsTransfers", false);
         component.set("v.ATMNETWORK", false);
        component.set("v.OtherMilestones", false);
        component.set("v.CurrentLoans", false);
        component.set("v.Recommendations", false);
        component.set("v.PrimaryAccount", false);
        component.set("v.ExtendedBenefits", false);
        component.set("v.EarnMore", false);          
        if (activeTab == 'tab-default-2__item') {            
            component.set("v.ContactPreference", true);
        }
        else if (activeTab == 'tab-default-3__item') {
            component.set("v.Housing", true);
        }
        else if (activeTab == 'tab-default-4__item') {
            component.set("v.AutoVehicle", true);
        }
        else if (activeTab == 'tab-default-5__item') {
            component.set("v.CurrentFeedback", true);
        }
        else if (activeTab == 'tab-default-6__item') {
            component.set("v.Withdrawals", true);
        }
        else if (activeTab == 'tab-default-7__item') {
            component.set("v.SharedBranching", true);
        }
        else if (activeTab == 'tab-default-8__item') {
            component.set("v.OtherMilestones", true);
        }      
        else if (activeTab == 'tab-default-9__item') {
            component.set("v.PrimaryAccount", true);
        }   
          else if (activeTab == 'tab-default-10__item') {
            component.set("v.Deposits", true);
        }
         else if (activeTab == 'tab-default-13__item') {
            component.set("v.PaymentsTransfers", true);
        }
         else if (activeTab == 'tab-default-99__item') {
            component.set("v.Recommendations", true);
        }
        else if (activeTab == 'tab-default-11__item') {
            component.set("v.ATMNETWORK", true);
        }
        else if (activeTab == 'tab-default-12__item') {
            component.set("v.CurrentLoans", true);
        }
        else if (activeTab == 'tab-default-14__item') {
            component.set("v.ExtendedBenefits", true);
        }
        else if (activeTab == 'tab-default-15__item') {
            component.set("v.EarnMore", true);
        }
        else {
            component.set("v.Overview", true);
        }        
    },
    
    HandleSaveAssessment: function (component, event, helper) { 	
    	
    	component.get("v.recordId");    	
    	component.set("v.loading", true);
        var section = event.getParam("SectionName");
        var objNeedsAssesment = event.getParam("objNeedsAssesment");
        var SubItems = event.getParam("SubItems");        
        var recordid = component.get("v.recordId");
        var deletedItems = event.getParam("deletedItems");
        if(SubItems == undefined || SubItems == null)
        {
        	SubItems = '';
        }
        
        helper.SaveAssessmentHelper(component, section, objNeedsAssesment, recordid, SubItems, deletedItems);
    },

})