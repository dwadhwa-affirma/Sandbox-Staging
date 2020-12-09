({
	doInit : function(component, event, helper) {
		
		var memberId = component.get("v.recordId");
		
		component.find("AdditionalToken1").set("v.value", "Select");
		component.find("AdditionalToken2").set("v.value","Select");
        component.find("AdditionalToken3").set("v.value","Select");
        component.find("AdditionalToken4").set("v.value","Select");
		component.set("v.AdditionalTokenOption1Match",'');
	    component.set("v.AdditionalTokenOption2Match",'');
        component.set("v.AdditionalTokenOption3Match",'');
        component.set("v.AdditionalTokenOption4Match",'');
	    component.set("v.CardNumberMatch",'');
	    component.set("v.BeneficiaryDetailMatch",'');
	    component.set("v.JointOwnerDetailMatch",'');
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
			var IsUserSessionLoaded = params.param3;
			component.set("v.IsMemberManualSearched", params.param4); 
			
			component.set("v.IsReLoadRequired", IsReLoadRequired);
			component.set("v.IsUserSessionLoaded", IsUserSessionLoaded);
		}
		
	},
	ButtonClick : function(component, event, helper) {
        var ButtonId = event.getSource().getLocalId();
        var Button = event.getSource();
        helper.ButtonPassFailMethod(component, event, helper,ButtonId,Button);
    },
})