({
	doInit : function(component, event, helper) {
		
		debugger;      
        var recordid = component.get("v.recordId");
        var sobjecttype = component.get("v.sobjecttype");
       if(recordid != undefined && sobjecttype != undefined)
       {      
    	   var win = window.open("/apex/eSignature?id=" + recordid);
           
       }     
	},
	
	
	 closePopup: function(component, event, helper) {
	  $A.get('e.force:closeQuickAction').fire();
   }, 
	
})