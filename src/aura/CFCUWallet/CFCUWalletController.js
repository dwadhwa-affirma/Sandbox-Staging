({
	doInit : function(component, event, helper) {
		
		var memberId = component.get("v.recordId");
		//var CFCUWalletStatusForDay = component.get("v.CFCUWalletStatusForDay");
		var IVRGUIDFromUrl = component.get("v.IVRGUIDFromUrl");
		helper.GetJointMemberDetail(component, event,helper, memberId, IVRGUIDFromUrl);
		component.set("v.IsSubmitClicked",false);
		component.set("v.ScoreObtained",0 );
		component.set("v.QuestionAttempt",0 );
		component.set("v.FailedCount",0 );
        component.set("v.IsButtonDisabled", true);
        helper.buttonOnLoad(component, event, helper);
		var params = event.getParam('arguments');
		if (params) {
			var IsReLoadRequired =  params.param2;
			component.set("v.IsReLoadRequired", IsReLoadRequired);
		}
		
	},
	
	ButtonClick : function(component, event, helper) {
        var ButtonId = event.getSource().getLocalId();
        var Button = event.getSource();
        helper.ButtonPassFailMethod(component, event, helper,ButtonId,Button);
       
       
    },
})