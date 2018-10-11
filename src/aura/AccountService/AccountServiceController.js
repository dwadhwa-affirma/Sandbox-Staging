({
	doInit : function(component, event, helper) {
		// var footer = document.getElementById('OTPVerificationPageFooter');
		// footer.style = '';
		var id = component.get("v.recordId");
		var object = component.get("v.sObjectName");
		 //var cmp1 = document.getElementById('cmpOTPVerification');
		if(object == 'Account'){
			component.set("v.isOTPVisible", true);	
			 var footer = document.getElementById('OTPVerificationPageFooter');
			 if(footer != null)
			footer.style = 'display:none';	
			
			// cmp1.style = '';
		}
		else
		{
			
		}
	},
	
	openTravelNotification : function(component, event, helper) {
		 var cmp = document.getElementById('cmpTravelNotification');
		 cmp.style = '';
		 
		  var cmp1 = document.getElementById('cmpOTPVerification');
		  if(cmp1 != null)
		 cmp1.style = 'display:none';
		 
		  var div = document.getElementById('divAccountService');
		 div.style = 'display:none';
		 
		 var header = document.getElementById('AccountServices');
		 header.style = 'display:none';
		 
		 var footer = document.getElementById('OTPVerificationPageFooter');
		 if(footer != null)
		 footer.style = 'display:none';
		 component.set("v.isFooterVisible", false);
		 
	},
	
	openOTPVerification : function(component, event, helper) {
		 var cmp = document.getElementById('cmpTravelNotification');
		 cmp.style = 'display:none';
		 
		  var cmp1 = document.getElementById('cmpOTPVerification');
		  if(cmp1 != null)
		 cmp1.style = '';
		 
		  var div = document.getElementById('divAccountService');
		 div.style = 'display:none';
		 
		 var header = document.getElementById('AccountServices');
		 header.style = 'display:none';
		 component.set("v.isFooterVisible", false);
		 
		 
	},
	closePopup: function(component, event, helper) {
		$A.get('e.force:closeQuickAction').fire();
		//component.destroy();
	}
})