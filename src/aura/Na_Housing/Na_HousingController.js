({
	doInit : function(component, event, helper) {			
			helper.fetchPicklistFields(component);
			helper.fetchYearPickList(component);
	},
	 saveHousingClick: function(component, event) {		
        var assessmentData = component.get("v.Model");
        var updateEvent = component.getEvent("AssessmentSave");
        updateEvent.setParams({ "objNeedsAssesment": assessmentData});
        updateEvent.setParams({ "SectionName": "Housing" });
        updateEvent.fire();
    }
})