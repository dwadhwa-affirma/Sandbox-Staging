({
	doInit : function(component, event, helper) {
	
		// Home banner component code start
		var bannerTitledata = $A.get("$Label.c.Notification_Banner_Title");
		var bannerTextdata = $A.get("$Label.c.Notification_Banner_Text");
		var BannerLinkdata = $A.get("$Label.c.Notification_Banner_Link");
		var BannerLinkHoverdata = $A.get("$Label.c.Notification_Banner_Link_Hover");
		var bannerLinkTextdata = $A.get("$Label.c.Notification_Banner_Link_Text");		
		var bannerExpirationdata = $A.get("$Label.c.Notification_Banner_Expiration");
		
		component.set('v.bannerTitle', bannerTitledata);
		component.set('v.bannerText', bannerTextdata);
		component.set('v.BannerLink', BannerLinkdata);
		component.set('v.BannerLinkHover', BannerLinkHoverdata);
		component.set('v.bannerLinkText', bannerLinkTextdata);	
			
				
		var currDate = new Date().toISOString().slice(0,10).replace(/-/g,"");
		if(currDate <= bannerExpirationdata)
		{
			component.set('v.bannerExpirationFlag', true);
		}
		else
		{
			component.set('v.bannerExpirationFlag', false);
		}
		// Home banner component code end
		
        debugger;
        //Execute Member search if query string has account number
        var returnValue=helper.getUrlParameter("c__accountNumber");
        if(returnValue) {
            component.set("v.searchText",returnValue);
        	helper.searchRecords(component, event, helper);
        }
	},
	searchRecords : function(component, event, helper) {	
		helper.searchRecords(component, event, helper);
	},
	searchRecord : function(component, event, helper) {	
	if(event.getParams().keyCode == 13){	
		helper.fetchrecords(component);
		}
	},
	clearSearch : function(component, event, helper) {
		component.set("v.searchText", '');		
		component.set("v.Model", null);
		component.set("v.NoRecord", false);		
		var table  = document.getElementById('tblMembernoSearch');
			if(table)
				table.style = 'display:none';
		
	},
	
    showGrid : function(component, event, helper) {	  
		var table  = document.getElementById('tblMembernoSearch');
			if(table)
				table.style = '';
	},
    
	/*selectMember : function(component, event, helper) {
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
	}*/
	selectMember : function(component, event, helper) {
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
        
        
		/*var UserProfile = component.get("v.UserProfile");
		if(UserProfile == 'Call Center'){
				var evt = $A.get("e.force:navigateToComponent");
		        console.log('Event '+evt);
		        var currentId = event.target._id;
		        var AccountNumber = component.get("v.searchText");
		        evt.setParams({
		            componentDef  : "c:LightningVerification" ,
		            componentAttributes : {
		                MemberIdFromHomePage : currentId,
		                AccountNumberFromHomePage: AccountNumber,
		                IspageOpenFromHomePage: true
		            }
		        
		        });
      
		        evt.fire();
            }
            else{
            	
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
            
            }*/
            
        

        
	}
})