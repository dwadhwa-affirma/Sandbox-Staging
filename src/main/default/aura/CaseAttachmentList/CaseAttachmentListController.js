({
	doInit : function(component, event, helper) {		
		helper.getCaseAttachments(component);
		
	},
	
	deleteAttachment: function(component, event, helper) {		
		helper.deleteAttachment(component);
		
	},
	openApproveAttachments: function (component, event, helper)
	{
		component.set('v.showMemberAttachmentDiv',true);
	/*	 var childCmp = component.find("approveAttachmentPopup");
		 childCmp.loadDocuments();*/
	},
	
	openUploadAttachments: function (component, event, helper)
	{
		component.set('v.showUploadAttachmentDiv',true);
	/*	 var childCmp = component.find("approveAttachmentPopup");
		 childCmp.loadDocuments();*/
	},
    openOnBaseAttachments: function (component, event, helper)
	{
		component.set('v.showOnBaseAttachmentDiv',true);
	},
	
	ClosePopup: function(component, event, helper)
	{
		component.set('v.showMemberAttachmentDiv',false);
		component.set('v.showUploadAttachmentDiv',false);
        component.set('v.showOnBaseAttachmentDiv',false);
		 $A.get('e.force:refreshView').fire();
	}
	
})