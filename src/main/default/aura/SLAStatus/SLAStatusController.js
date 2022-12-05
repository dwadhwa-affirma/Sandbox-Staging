({
    doinit : function(component, event, helper) {
        helper.getDetails(component, event);
    },
    //code added to refresh the page //
    isRefreshed: function(component, event, helper) {
        location.reload();
    }
})