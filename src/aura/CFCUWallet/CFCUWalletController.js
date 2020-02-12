({
	doInit : function(component, event, helper) {
		
		var memberId = component.get("v.recordId");
		var CFCUWalletStatusForDay = component.get("v.CFCUWalletStatusForDay");
		helper.GetJointMemberDetail(component, event, memberId);
        component.find('BeneficiaryPassButton').set("v.variant", "neutral");
        component.find('BeneficiaryFailButton').set("v.variant", "neutral");
        component.find('JointPassButton').set("v.variant", "neutral");
        component.find('JointFailButton').set("v.variant", "neutral");
        component.find('LoanPassButton').set("v.variant", "neutral");
        component.find('LoanFailButton').set("v.variant", "neutral");
        if(component.get("v.IsCFCUSectionVisible") == true){                	
            component.find('CardPassButton').set("v.variant", "neutral");
            component.find('CardFailButton').set("v.variant", "neutral");
        }
        component.find('TokenPassButton1').set("v.variant", "neutral");
        component.find('TokenFailButton1').set("v.variant", "neutral");
        component.find('TokenPassButton2').set("v.variant", "neutral");
        component.find('TokenFailButton2').set("v.variant", "neutral");
		
	},
	
	
	ButtonClick : function(component, event, helper) {
        var ButtonId = event.getSource().getLocalId();
        var Button = event.getSource();
        helper.ButtonPassFailMethod(component, event, helper,ButtonId,Button);
       
       
    },
})