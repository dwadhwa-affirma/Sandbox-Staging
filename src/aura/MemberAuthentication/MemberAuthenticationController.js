({
	myAction : function(component, event, helper) {
		
	},
    // Default event call while page is lode
    doInit : function (component, event) {
        
        //To call apex page from lightning componant
        /*var urlEvent = $A.get("e.force:navigateToURL");        
        urlEvent.setParams({
        	"url":"/apex/Member_Authenticated",
            "target": "_top"
    	});        
    	urlEvent.fire();*/
    	//var baseurl=URL.getSalesforceBaseUrl().toString();
    	//alert(baseurl);
    	//alert(baseurl+'/apex/Member_Authenticated');
        window.open("/apex/Member_Authenticated");
        
        // To Close or Hide a Global Quick Action Lightning Component popup 
        var dismissActionPanel = $A.get("e.force:closeQuickAction");   
        dismissActionPanel.fire();
    
    }
})