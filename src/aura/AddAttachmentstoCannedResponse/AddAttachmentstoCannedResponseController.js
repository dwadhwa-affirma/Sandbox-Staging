({
	doInit : function(component, event, helper) {		
		helper.getCaseAttachments(component);
		
	},
	
	deleteAttachment: function(component, event, helper) {		
		helper.deleteAttachment(component);
		
	},
	
	openUploadAttachments: function (component, event, helper)
	{
		component.set('v.showUploadAttachmentDiv',true);
	/*	 var childCmp = component.find("approveAttachmentPopup");
		 childCmp.loadDocuments();*/
	},
    
	ClosePopup: function(component, event, helper)
	{
		
		component.set('v.showUploadAttachmentDiv',false);
      
		 $A.get('e.force:refreshView').fire();
	}
	
})