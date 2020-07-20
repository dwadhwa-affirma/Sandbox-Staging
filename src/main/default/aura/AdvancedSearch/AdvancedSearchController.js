({
	doInit : function(component, event, helper) {
		
	},
	
	Searchaccounts : function(component, event, helper) {	
		component.set('v.IsAccountTable', true);
		component.set('v.isAccountDetailsTable', false);
		helper.getAccounts(component);
	},
	
	SearchaccountDetails: function(component, event, helper) {
		component.set('v.IsAccountTable', false);
		component.set('v.isAccountDetailsTable', true);
		helper.getAccountDetails(component);
		//document.body.scrollTop = document.documentElement.scrollTop = 0;
	},
	
	pressAccounts : function(component, event, helper) {
		component.set('v.IsAccount', true);
		component.set('v.isAccountDetails', false);
		
		component.set('v.IsAccountbtn', true);
		component.set('v.isAccountDetailsbtn', false);
		
		component.set('v.isOrText', false);		
	},
	
	keyUppressAccounts : function(component, event, helper) {		
		if(event.getParams().keyCode == 13){		
			component.set('v.IsAccountTable', true);
			component.set('v.isAccountDetailsTable', false);
			helper.getAccounts(component);
			//document.getElementById('btnSearch').click();
		}
	},
		
	pressAccountDetails : function(component, event, helper) {
		component.set('v.IsAccount', false);
		component.set('v.isAccountDetails', true);
		
		component.set('v.IsAccountbtn', false);
		component.set('v.isAccountDetailsbtn', true);
		
		component.set('v.isOrText', false);			
	},
	
	
	keyUppressAccountDetails : function(component, event, helper) {		
		if(event.getParams().keyCode == 13){		
			component.set('v.IsAccountTable', false);
			component.set('v.isAccountDetailsTable', true);
			helper.getAccountDetails(component);
			//document.body.scrollTop = document.documentElement.scrollTop = 0;
			//document.getElementById('btnSearch').click();
		}
	},
	
	clearSearch : function(component, event, helper) {
		component.set('v.FirstName', '');
		component.set('v.LastName', '');
		component.set('v.SSNNumber', '');
		component.set('v.ResidentialCity', '');
		component.set('v.ResidentialState', '');
		
		component.set('v.MemberNumber', '');
		component.set('v.CardName', '');
		component.set('v.CardNumber', '');
		component.set('v.VINNumber', '');
		component.set('v.LoanNumber', '');
		component.set('v.PropertyAddress', '');
		component.set('v.PropertyCity', '');
		component.set('v.PropertyState', '');
		component.set('v.PropertyZip', '');
		component.set('v.FirstName', '');
		
		component.set('v.accounts', '');
		component.set('v.accDetails', '');
		
		component.set('v.IsAccount', true);
		component.set('v.isAccountDetails', true);
		component.set('v.isOrText', true);
		
		component.set('v.IsAccountbtn', false);
		component.set('v.isAccountDetailsbtn', false);
				
		component.set('v.IsAccountTable', false);
		component.set('v.isAccountDetailsTable', false);	
		
		component.set("v.NoRecordAccountDetails", false);
		component.set("v.NoRecordAccounts", false);	
	},
	
	selectAccount: function(component, event, helper) {
		component.set("v.loading", true);
		var currentId = event.target._id;
		if(currentId != undefined && currentId != null && currentId != '')
		{
			var navEvt = $A.get("e.force:navigateToSObject");
	        navEvt.setParams({
	        	"recordId": currentId,
	        	"slideDevName": "related"
	        });
	        navEvt.fire();        
	        component.set("v.loading", false);
		}
	},	
})