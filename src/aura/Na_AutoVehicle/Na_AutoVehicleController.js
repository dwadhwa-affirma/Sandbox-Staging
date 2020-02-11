({
	doInit : function(component, event, helper) {			
			helper.fetchPicklistFields(component);	
        	debugger;
	},
	 saveAutoVehicleClick: function(component, event) {		
        var assessmentData = component.get("v.Model");
        var updateEvent = component.getEvent("AssessmentSave");
        updateEvent.setParams({ "objNeedsAssesment": assessmentData});
        updateEvent.setParams({ "SectionName": "AutoVehicle" });
        updateEvent.fire();
    },
    
    changeDate : function(component, event){    	
    	var assessmentData = component.get("v.Model");
    	
    	if(event.getParams().keyCode == '46' || event.getParams().keyCode == '8')
    	{
    		var whichOne = event.getSource().getLocalId();
    		if(whichOne == 'planDate')
    		{
    			assessmentData.LEAV_PlanDate__c = '';
    		}
    		else if(whichOne == 'endDate')
    		{
    			assessmentData.LEAV_EndDateLoan__c = '';
    		}	
    	}    	
    	component.set("v.Model", assessmentData);
    }
})