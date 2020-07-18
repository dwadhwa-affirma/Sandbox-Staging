({
	 saveFeedbackClick: function(component, event) {
	 	
        var assessmentData = component.get("v.Model");
        var updateEvent = component.getEvent("AssessmentSave");
        updateEvent.setParams({ "objNeedsAssesment": assessmentData});
        updateEvent.setParams({ "SectionName": "CurrentFeedback" });
        updateEvent.fire();
    }
})