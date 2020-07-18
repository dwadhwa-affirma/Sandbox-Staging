({
	doInit : function(component, event, helper) {			
		helper.fetchPicklistFields(component);	
	},
	 saveHousingClick: function(component, event) {		
        var assessmentData = component.get("v.Model");
        var updateEvent = component.getEvent("AssessmentSave");
        updateEvent.setParams({ "objNeedsAssesment": assessmentData});
        updateEvent.setParams({ "SectionName": "Recommendations" });
        updateEvent.fire();
    },
    showhideDetails: function(component, event, helper) {		
    	var attName =  event.target.id;
    	var value = component.get('v.' + attName);
    	component.set('v.' + attName, !value)
    },
    expandcollapseallClick: function(component, event, helper){
    	var elements = document.getElementsByClassName('descicn');
        var elementsLength = elements.length;
        var value = false;
        for (var i = 0; i < elementsLength; i++) {
            debugger; 
            var attname = elements[i].getAttribute('id');            
            if(i==0){
                value = component.get('v.' + attname);
            	component.set('v.' + attname, !value);
                value = !value;
           	}
            else{
                component.set('v.' + attname, value);
            }
        } 
    }
})