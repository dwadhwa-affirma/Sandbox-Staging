/*
 * Source : sfdcmonkey.com 
 * Date : 25/9/2017
 * Locker Service Ready code.
 */
({
    MAX_FILE_SIZE: 24500000, //Max file size 4.5 MB 
    CHUNK_SIZE: 750000,      //Chunk Max size 750Kb 
    
    uploadHelper: function(component, event) {
        // start/show the loading spinner   
        component.set("v.showLoadingSpinner", true);
        // get the selected files using aura:id [return array of files]
        var fileInput = component.find("fileId").get("v.files");
        // get the first file using array index[0]  
        var files = fileInput;
        var self = this;
        // check the selected file size, if select file size greter then MAX_FILE_SIZE,
        // then show a alert msg to user,hide the loading spinner and return from function  
        // 
        
        component.set("v.fileProcessed", 0);
        if(files != null)
        {
        for(var i =0; i < files.length; i++)
        {
            var file = files[i];
            if (file.size > self.MAX_FILE_SIZE) {
                component.set("v.showLoadingSpinner", false);
                component.set("v.fileName", 'Alert : File size cannot exceed ' + self.MAX_FILE_SIZE + ' bytes.\n' + ' Selected file size: ' + file.size);
                return;
        	}
        }
      
        
        this.processNextFile(component, this);
        }
     
        
    },
 
 
    processNextFile: function(component, helper)
    {
    	
    	 var fileProcessed = component.get("v.fileProcessed");
    	 var fileInput = component.find("fileId").get("v.files");
    	 var files = fileInput;
    	 if(fileProcessed < files.length )
    	 {
	    	 var file = files[fileProcessed];
	         var objFileReader = new FileReader();
	         objFileReader.onload = 
	    	 $A.getCallback(function() {
				var fileContents = objFileReader.result;
	            var base64 = 'base64,';
	            var dataStart = fileContents.indexOf(base64) + base64.length;
	 
	           
	            fileContents = fileContents.substring(dataStart);
	            
	            component.set("v.currentFile", file.name);
	            // call the uploadProcess method 
	            helper.uploadProcess(component, helper, file, fileContents);
	         });
	         objFileReader.readAsDataURL(file);
	      }
	      else
	      {
	    	  component.set("v.showLoadingSpinner", false);
	    	   $A.get('e.force:refreshView').fire();
	    	  /*  var dismissActionPanel = $A.get("e.force:closeQuickAction");
	    	    dismissActionPanel.fire();*/
	    	    
	    	   var toastEvent = $A.get("e.force:showToast");
	        
		        toastEvent.setParams({		            
		            message : 'File(s) uploaded Successfully',	                        
		            duration:' 3000',
		            key: 'info_alt',
		            type: 'success',
		            mode: 'pester'
		        });
		        toastEvent.fire();	
		        var varIsUploadandNew;
                	varIsUploadandNew = component.get('v.IsUploadandNewPressed');
                	 var updateEvent = component.getEvent("ClosePopup");
                	if(!varIsUploadandNew)
                	{ updateEvent.setParams({ "SectionName": 'DetailPage'});}
                	else
                	{
                		updateEvent.setParams({ "SectionName": 'CasePage'});
                		var fileNames = new Array();
                		component.set("v.fileNames", fileNames);
                	}
		       
		         
			updateEvent.fire();
	      }
    
    },
 
    uploadProcess: function(component, helper, file, fileContents) {
        // set a default size or startpostiton as 0 
        var startPosition = 0;
        // calculate the end size or endPostion using Math.min() function which is return the min. value   
        var endPosition = Math.min(fileContents.length, startPosition + helper.CHUNK_SIZE);
 
        // start with the initial chunk, and set the attachId(last parameter)is null in begin
        helper.uploadInChunk(component, helper, file, fileContents, startPosition, endPosition, '');
    },
 
 
    uploadInChunk: function(component, helper, file, fileContents, startPosition, endPosition, attachId) {
        // call the apex method 'saveChunk'
        var getchunk = fileContents.substring(startPosition, endPosition);
        var action = component.get("c.saveChunk");
        action.setParams({
            parentId: component.get("v.parentId"),
            fileName: file.name,
            base64Data: encodeURIComponent(getchunk),
            contentType: file.type,
            fileId: attachId
        });
        console.log(component.get("v.parentId"));
        // set call back 
        action.setCallback(helper, function(response) {
            // store the response / Attachment Id   
            attachId = response.getReturnValue();
            var state = response.getState();
            if (state === "SUCCESS") {
                // update the start position with end postion
                startPosition = endPosition;
                endPosition = Math.min(fileContents.length, startPosition + helper.CHUNK_SIZE);
                // check if the start postion is still less then end postion 
                // then call again 'uploadInChunk' method , 
                // else, diaply alert msg and hide the loading spinner
                if (startPosition < endPosition) {
                    helper.uploadInChunk(component, helper, file, fileContents, startPosition, endPosition, attachId);
                } else {
                    //alert('your File is uploaded successfully');
                    
                     var fileProcessed = component.get("v.fileProcessed");
	                component.set("v.fileProcessed", 1 + fileProcessed);
	                helper.processNextFile(component, helper);
                }
               
                // handel the response errors        
            } else if (state === "INCOMPLETE") {
                alert("From server: " + response.getReturnValue());
            } else if (state === "ERROR") {
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        console.log("Error message: " + errors[0].message);
                    }
                } else {
                    console.log("Unknown error");
                }
            }
        });
        // enqueue the action
        $A.enqueueAction(action);
    }
})