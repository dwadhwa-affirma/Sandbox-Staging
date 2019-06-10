({
	doInit : function(component, event, helper) {
	debugger;
		helper.buildPicklist(component, "primaryList");	
		helper.buildPicklist(component, "secondaryList");	
		helper.buildPicklist(component, "tirtiaryList");	
		helper.getBasicDetail(component);
		component.set("v.SaveNew", false);
		helper.getAttachments(component);
	},
	
	changePrimary : function(component, event, helper) {	
		var value = event.getSource().get("v.value");
		helper.buildPicklist(component, "secondaryList");	
		helper.buildPicklist(component, "tirtiaryList");
		component.set("v.SearchText", '');
		helper.fetchSecondaryData(component, value);
	},
	
	changeSecondary : function(component, event, helper) {
		helper.buildPicklist(component, "tirtiaryList");
		var primary = component.get("v.PrimaryValue");
		var secondary = component.get("v.SecondaryValue");
		component.set("v.SearchText", '');
		helper.fetchTirtiaryData(component, primary, secondary);
	},
	
	changeCategories : function(component, event, helper) {
		var primary = component.get("v.PrimaryValue");
		var secondary = component.get("v.SecondaryValue");
		var tirtiary = event.getSource().get("v.value");
		
		helper.fetchItemsbyCategory(component, primary,secondary,tirtiary);
	},
	
	searchText : function(component, event, helper) {	
			// on enter key press
			if(event.getParams().keyCode == 13){								
				var searchValue = component.get('v.SearchText');
				helper.buildPicklist(component, "secondaryList");	
				helper.buildPicklist(component, "tirtiaryList");	
				component.set("v.PrimaryValue", '--- None ---');
				helper.fetchItemsbySearchText(component, searchValue);
			}
	},	
	
	changeDescription : function(component, event, helper) {
		var categoryId = event.target.value;
		component.set("v.SelectedCategory", categoryId);		
		helper.fetchDescription(component, categoryId);
		helper.fetchCRAttachments(component, categoryId);
	}, 	 
	
	saveAndNewMemberCommentClick : function(component, event, helper) {
		component.set("v.SaveNew", true);
		//this.saveclick(component, event, helper);
		var a = component.get('c.saveclick');
        $A.enqueueAction(a);
	},
	
	saveMemberCommentClick : function(component, event, helper) {
		component.set("v.SaveNew", false);
		var a = component.get('c.saveclick');
        $A.enqueueAction(a);		
	},
	
	saveclick : function(component, event, helper) {		
		var MemberDescription = component.get('v.MemberDescription');
		var Draft = component.get('v.ModelMemberComment.Draft__c');
		var CaseId = component.get('v.recordId');
		var secureEmailAddress = component.get('v.Secure_Email_Address');	
		var Attachments = component.get('v.Attachments');	
		var CURead = component.get('v.ModelMemberComment.CU_Read__c');
		var CRAttachments = component.get('v.CRAttachments');
		var selectedCannedResponse = component.get("v.SelectedCategory");
		
		
		var len = 0;
		
		if(Attachments != null){
			for(var i = 0; i< Attachments.length; i++){
					if(Attachments[i].checkvalue == true){
						len = len+1;
					}
			}
		}
		
		if(CRAttachments != null){
			for(var i = 0; i< CRAttachments.length; i++){
					if(CRAttachments[i].checkvalue == true){
						len = len+1;
					}
			}
		}
		
		if(len > 5){
			alert('Exceeded Maximum Attachments(5)');
			return false;
		}
		
		
		if(CaseId == undefined)
		{
			CaseId = helper.getParameterByName('c__id');
		}	
		
		if(Draft == undefined || Draft == null || Draft == '')
		{
			Draft = false;
		}
		var ReadOnly  = component.get('v.ReadOnly');
		if(ReadOnly || (MemberDescription != undefined && MemberDescription != null && MemberDescription != ''))		
		{
			var error  = document.getElementById('DescriptionError');
			//if(error){
			//	error.style = 'display:none;';
				component.set("v.isError", false);
			//	}
			
			helper.saveComment(component, MemberDescription, CaseId, Draft, secureEmailAddress, Attachments, CURead, CRAttachments, selectedCannedResponse);	
			 	
		}			
		else
		{
			var error  = document.getElementById('DescriptionError');
			//if(error){
			//	error.style = '';
				component.set("v.isError", true);
			//	}
			/*var toastEvent = $A.get("e.force:showToast");
	        
		        toastEvent.setParams({		            
		            message : 'Description is required.',	                        
		            duration:' 3000',
		            key: 'info_alt',
		            type: 'error',
		            mode: 'pester'
		        });
		        toastEvent.fire();*/
		}
	}, 	 
	
	 	 
	
	closePopup: function(component, event, helper) {
	var CaseId = component.get('v.recordId');
	
	if(CaseId == undefined)
		{
			CaseId = helper.getParameterByName('c__id');
		}	
	  var MemberComment = component.get('v.ModelMemberComment');
				    var isedit = component.get('v.isEdit');
				    if(isedit == true){
				    	var sObectEvent = $A.get("e.force:navigateToSObject");
		   					 sObectEvent .setParams({
		   					 "recordId": MemberComment.Case__c,
		    				 "slideDevName": "detail"
		   					});
	    					sObectEvent.fire(); 
                       
				    }
				    else
				    {
				    	 var sObectEvent = $A.get("e.force:navigateToSObject");
		   					 sObectEvent .setParams({
		   					 "recordId": CaseId,
		    				 "slideDevName": "detail"
		   					});
	    					sObectEvent.fire();                        
				    }
	
               //  location.reload();	
               $A.get('e.force:closeQuickAction').fire();
               $A.get('e.force:refreshView').fire();
   },    
})