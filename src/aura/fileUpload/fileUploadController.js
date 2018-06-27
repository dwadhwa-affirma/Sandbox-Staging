{
    doSave: function(component, event, helper) {
        if (component.find("fileId").get("v.files") != null && component.find("fileId").get("v.files").length > 0) {
            helper.uploadHelper(component, event);
        } else {
            alert('Please Select a Valid File');
        }
    },
 
    handleFilesChange: function(component, event, helper) {
        var fileNames = new Array();
        if (event.getSource().get("v.files").length > 0) {
            for(var i = 0; i < event.getSource().get("v.files").length; i++)
            {
            	fileNames.push(event.getSource().get("v.files")[i]['name']);    
            }
            
        }
        component.set("v.fileNames", fileNames);
    },
})