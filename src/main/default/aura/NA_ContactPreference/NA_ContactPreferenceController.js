({
	saveContactPrefereceClick : function(component, event, helper) {
		var assessmentData = component.get("v.Model");
        var updateEvent = component.getEvent("AssessmentSave");
        updateEvent.setParams({ "objNeedsAssesment": assessmentData});
        updateEvent.setParams({ "SectionName": "ContactPreference" });
        updateEvent.fire();
	}
})