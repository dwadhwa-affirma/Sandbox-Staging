({
	doInit : function(component, event, helper) {		
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
	}
})