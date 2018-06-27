({
    handleUploadFinished: function (cmp, event) {
        // Get the list of uploaded files
        var uploadedFiles = event.getParam("files");
        var toastEvent = $A.get("e.force:showToast");         
			 toastEvent.setParams({              
			              message : 'Attachment uploaded successfully.',                         
			              duration:' 3000',
			              key: 'info_alt',
			              type: 'success',
			              mode: 'pester'
			          });
			toastEvent.fire();
			$A.get('e.force:closeQuickAction').fire();
			
    },
     closePopup: function(component, event, helper) {
    	var currId = component.get("v.recordId");
		
	
	    var updateEvent = component.getEvent("ClosePopup");
        updateEvent.fire();
		
	 // window.location ='/lightning/r/Case/' +  currId + '/view' ;
   } 
})