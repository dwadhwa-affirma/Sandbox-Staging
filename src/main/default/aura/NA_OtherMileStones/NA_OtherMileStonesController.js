({
	doInit : function(component, event, helper) {			
		helper.fetchPicklistFields(component);
		debugger;
//		var NAFields = ["Home_Improvement__c", "Home_Improvement_Timeframe__c", "Home_Improvement_Plan__c", "College__c", "College_Timeframe__c", "College_Plan__c",
//			"Medical__c", "Medical_Timeframe__c", "Medical_Plan__c", "Purchase_RV_Boat__c", "Purchase_RV_Boat_Timeframe__c", "Purchase_RV_Boat_Plan__c", "Retirement_New__c", "Retirement_Timeframe__c", 
//			"Retirement_Plan__c", "Travel__c", "Travel_Timeframe__c", "Travel_Plan__c", "Life_Events__c", "Life_Events_Timeframe__c", "Life_Events_Plan__c", "Other__c", "Other_Timeframe__c", "Other_Plan__c"];
//			
//		var updateEvent = component.getEvent("FetchPickLists");
//        updateEvent.setParams({ "picklist": NAFields});
//        updateEvent.fire();
        
	},
	 saveMilestonesClick: function(component, event) {		
        var assessmentData = component.get("v.Model");
        var updateEvent = component.getEvent("AssessmentSave");
        updateEvent.setParams({ "objNeedsAssesment": assessmentData});
        updateEvent.setParams({ "SectionName": "OtherMilestones" });
        updateEvent.fire();
    }
})