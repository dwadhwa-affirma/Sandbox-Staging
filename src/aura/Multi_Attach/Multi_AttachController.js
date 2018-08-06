({

doInit : function(component, event, helper) {
debugger;
        //Send LC Host as parameter to VF page so VF page can send message to LC; make it all dynamic
        component.set('v.lcHost', window.location.hostname);
        var closeEvent =  component.getEvent("ClosePopup");
        var frameSrc = '/apex/FileUpload?id=' + component.get('v.recordId') + '&lcHost=' + component.get('v.lcHost');
        console.log('frameSrc:' , frameSrc);
        component.set('v.frameSrc', frameSrc);

        //Add message listener
        component.set('v.closeDone', false);
        window.removeEventListener('message');
        window.addEventListener("message", function(event) {

            console.log('event.data:', event.data);

            // Handle the message
            if(event.data.state == 'Uploading'){
                //Set vfHost which will be used later to send message
              //  component.set('v.vfHost', event.data.vfHost);
                component.set("v.showLoadingSpinner", true);
                document.getElementById("btnCancel").disabled = true;
            }
           

            if(event.data.state == 'fileUploadprocessed'){

                //var uiMessage = component.find('uiMessage');

                //Disable Upload button until file is selected again

                //component.find('uploadFileButton').set('v.disabled', true);
                if(component.get('v.closeDone') != undefined && !component.get('v.closeDone')){
                	component.set("v.showLoadingSpinner", false);
	                 var toastEvent = $A.get("e.force:showToast");         
	                 toastEvent.setParams({              
				              message : 'Attachment uploaded successfully.',                         
				              duration:'1000',
				              key: 'info_alt',
				              type: 'success',
				              mode: 'pester'
				          });
	                 toastEvent.fire();
	                 var currId = component.get("v.recordId");	
	                 
	                 
	                 	component.set('v.closeDone', true);
	                 	var updateEvent = component.getEvent("ClosePopup");
	                  	updateEvent.fire();
                  }
                 /*if(updateEvent != null)
                 {
                	
                	 $A.get('e.force:refreshView').fire();
                 }*/
            }
            
             if(event.data.state == 'ErrorOccured'){
              if(component.get('v.closeDone') != undefined && !component.get('v.closeDone')){
                	component.set("v.showLoadingSpinner", false);
	                alert('Failed to Upload Files:' + event.data.ErrorStr);
	                 var currId = component.get("v.recordId");	
	                 
	                 
	                 	component.set('v.closeDone', true);
	                 	var updateEvent = component.getEvent("ClosePopup");
	                  	updateEvent.fire();
                  }
             
            	 
             }
            
            
        }, false);
    },
    
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