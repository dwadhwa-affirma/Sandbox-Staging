({
	getCaseAttachments : function(component) {	
		var action = component.get("c.GetCaseAttachments");
		var recordId = component.get("v.recordId");	
		
		action.setParams({
		"RecordId": recordId
		});
			debugger;
			action.setCallback(this, function(resp) {				
			var state=resp.getState();			
			if(state === "SUCCESS"){	
			debugger;	
				var res = resp.getReturnValue();
				console.log(res);				
				component.set("v.Attachments", res.attachmentList); 	
				component.set("v.AttachmentsCount", res.attachmentList.length);
				component.set("v.CRDetail", res.CRDetail); 					 			
			}
		});
		
		$A.enqueueAction(action);
	},
	
	deleteAttachment : function(component) {	
		var attachmentId= event.target.getAttribute("id");
		var name= event.target.getAttribute("data-name");
		
		if(!confirm('Are you sure, you want to delete ' + name + ' ?'))
		{
			return;
		}
		var action = component.get("c.DeleteAttachment");
		
		action.setParams({
		"attachmentId": attachmentId
		});
		
			action.setCallback(this, function(resp) {
				debugger;
			var state=resp.getState();			
			if(state === "SUCCESS"){		
				var toastEvent = $A.get("e.force:showToast");
	        
		        toastEvent.setParams({		            
		            message : 'Attachment Deleted Successfully',	                        
		            duration:' 500',
		            key: 'info_alt',
		            type: 'success',
		            mode: 'pester'
		        });
		        toastEvent.fire();						
				  $A.get('e.force:refreshView').fire();    			
			}
		});
		
		$A.enqueueAction(action);
		
	},
	
})