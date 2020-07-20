({
	doInit : function(component, event, helper) {	
		var currId = component.get("v.recordId");
		
		if(currId == undefined)
		{
			currId = helper.getParameterByName('id');
		}
		helper.getAttachmentData(component, currId, helper);
	},
	
	attachmentSave : function(component, event, helper) {		
		var currId = component.get("v.recordId");
		
		if(currId == undefined)
		{
			currId = helper.getParameterByName('id');
		}
		helper.saveAttachmentsdata(component, currId);
	},	
	
    closePopup: function(component, event, helper) {
    	var currId = component.get("v.recordId");
		
		if(currId == undefined)
		{
			currId = helper.getParameterByName('id');
		}
	    var updateEvent = component.getEvent("ClosePopup");
        updateEvent.fire();
		
	 // window.location ='/lightning/r/Case/' +  currId + '/view' ;
   } 
   
   
   
  
   
   
})