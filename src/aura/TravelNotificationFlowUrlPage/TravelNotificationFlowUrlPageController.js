({
	doInit : function(component, event, helper) {
		
		debugger;      
        var recordid = component.get("v.recordId");
        var sobjecttype = component.get("v.sobjecttype");
       if(recordid != undefined && sobjecttype != undefined)
       {      
    	   var win = window.open("https://flow.boomi.com/6f7caa2e-6918-4eeb-9147-a251b9572c5f/play/TravelNotificationPlayer/?flow-id=6e47f321-cfef-455b-b9fb-b4a8233d525c"+"&accountid=" + recordid);
           
       }     
	},
	
	
	 closePopup: function(component, event, helper) {
	  $A.get('e.force:closeQuickAction').fire();
   }, 
	
})