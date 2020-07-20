({
	doInit : function(component, event, helper) {
		
		
		
		//helper.GetLogData(component, event, helper, memberId, GUID);
	},
	
	executeMethod : function (component, event, helper) {
	        console.log("Inside Execute method.. ");
	        var params = event.getParam('arguments');
	        console.log('Param 1: '+ params.param1);
	        var memberId = params.param1;
	        var GUID = params.param2;
	        helper.GetLogData(component, event, helper, memberId, GUID);
        },
	
})