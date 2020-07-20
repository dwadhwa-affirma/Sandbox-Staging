({
	doInit : function(component, event, helper) {
		
		var memberId = component.get("v.recordId");
		helper.GetLogData(component, event, helper, memberId);
		
	},
	naviteToMAAPRecord : function(component, event, helper) {

    console.log( 'naviteToMAAPRecord' );

    var recordId = event.target.dataset.logid;


    var event = $A.get( 'e.force:navigateToSObject' );

    	if ( event ) {


	        event.setParams({
	            'recordId' : recordId
	        }).fire();

    	}
    },
	
})