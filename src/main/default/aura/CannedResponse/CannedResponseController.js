({
    doInit: function(component, event, helper) {
    	helper.getresponse(component);
    },
    SaveResponse: function(component, event, helper) {
        var isValid = helper.handleError(component, event, helper);
        debugger;
        if (isValid) {
            helper.saveCannedResponse(component);
        }
    },
    closePopup: function(component, event, helper) {

    },

})