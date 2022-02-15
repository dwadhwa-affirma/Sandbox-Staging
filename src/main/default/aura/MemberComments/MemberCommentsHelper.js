({
	getBasicDetail : function(component) {
	
		var action = component.get("c.getBasicDetails");
		var recordId = component.get("v.recordId");		
		component.set("v.loading", true);
		
		
		if(recordId == undefined)
		{
			recordId = this.getParameterByName('id');
		}
		
		action.setParams({
		"caseId": recordId
		});		
			
			action.setCallback(this, function(resp) {			
			var state=resp.getState();			
			if(state === "SUCCESS"){
				component.set("v.loading", false);
				var res = resp.getReturnValue();
				console.log(res);				
				if(res.isObjectAccess == false)
				{
				         component.set("v.isObjectAccess", false);
						//alert('NotAccessible');						
						/* var sObectEvent = $A.get("e.force:navigateToSObject");
		   					 sObectEvent .setParams({
		   					 "recordId": recordId,
		    				 "slideDevName": "detail"
		   					});
	    					sObectEvent.fire(); */
				}
				else
				{
				component.set("v.isObjectAccess", true);
				component.set("v.Model", res.AccObj);
				component.set("v.Secure_Email_Address", res.Secure_Email);	
				component.set("v.isTyfoneEmailEmpty", res.isTyfoneEmailEmpty);			
				if(res.Secure_Email == null || res.Secure_Email == '')
				{
					//res.Secure_Email_Address_Empty = true;
					component.set("v.Secure_Email_Address_Empty", true);
				}
				else
				{
					//res.Secure_Email_Address_Empty = false;
					component.set("v.Secure_Email_Address_Empty", false);
				}								
				component.set("v.MemberDescription", res.memberComment.Member_Communication__c);
				component.set("v.ModelMemberComment", res.memberComment);			
				component.set("v.isEdit", res.isEdit);							
				if(res.memberComment.Draft__c == false && res.isEdit == true)
				{				
					component.set("v.ReadOnly", true);
					
					document.getElementById('btnSaveandNew').style.display = 'none';
					//component.set("v.SaveVisible", "none");
				}
				else
				{
					component.set("v.ReadOnly", false);
					//	component.set("v.SaveVisible", "visible");
				}	
				
				if(component.get("v.ReadOnly") == true && res.isCUReadEditable == true)
				{
					component.set("v.isCUReadEditable", true);					
				}
				else
				{
					component.set("v.isCUReadEditable", false);						
				}
				
				if(res.isEdit == true && res.isCUReadEditable == false && component.get("v.ReadOnly") == false){
					document.getElementById('btnSave').style.display = 'none';
				}
				
//				var footer = document.getElementById('MemberCommentFooter');
//				var body = this.closest(footer,'.modal-container');
//				if(body!= null)
//				{
//	        		body.append(footer);
//	        		footer.previousSibling.remove();
//	        		footer.parentNode.setAttribute('id','MemberCommentPopup');			
//        		}
        		this.fetchPrimaryData(component);    
        		}    			
			}
		});
		
		$A.enqueueAction(action);
	},
	
	getAttachments : function(component) {
		var action = component.get("c.getAttachmentDetails");
		
		var recordId = component.get("v.recordId");		
		
		if(recordId == undefined)
		{
			recordId = this.getParameterByName('id');
		}
		
		component.set("v.loading", true);
		action.setParams({
		"caseId": recordId
		});			
		action.setCallback(this, function(resp) {
			var state=resp.getState();			
			if(state === "SUCCESS"){
				component.set("v.loading", false);
				var res = resp.getReturnValue();
				console.log(res);				
				component.set("v.Attachments", res);   
				if(res.length > 0){
					component.set("v.ShowAttachmentTable",true);
				}
				else{
					component.set("v.ShowAttachmentTable",false)
				}     			
			}
		});
		
		$A.enqueueAction(action);
	},
	
	fetchPrimaryData : function(component) {	
		var brand = component.get("v.Model");
		if(brand != null && brand != undefined)
		{
			var action = component.get("c.getPrimaryData");		
			component.set("v.loading", true);
			action.setParams({
			"brand": brand.Brand__c
			});			
			action.setCallback(this, function(resp) {
				var state=resp.getState();			
				if(state === "SUCCESS"){
					component.set("v.loading", false);
					var res = resp.getReturnValue();
					console.log(res);					
					this.buildPicklist(component, "primaryList", res);				
				}
			});
			
			$A.enqueueAction(action);
		}		
	},
	
	fetchSecondaryData : function(component, primaryText) {
		var brand = component.get("v.Model");
		if(brand != null && brand != undefined)
		{
			var action = component.get("c.getSecondaryData");
			
			component.set("v.loading", true);
			action.setParams({
			"brand": brand.Brand__c,
			"primaryText" : primaryText
			});			
			action.setCallback(this, function(resp) {
				var state=resp.getState();			
				if(state === "SUCCESS"){
					component.set("v.loading", false);
					var res = resp.getReturnValue();
					console.log(res);
					this.buildPicklist(component, "secondaryList", res);
					var primary = component.get("v.PrimaryValue");
					var secondary = '';
					var tirtiary = '';				
					this.fetchItemsbyCategory(component, primary);
				}
			});
			
			$A.enqueueAction(action);
		}
	},
	
	fetchTirtiaryData : function(component, primaryText, secondaryText) {		
		var brand = component.get("v.Model");
		if(brand != null && brand != undefined)
		{
			var action = component.get("c.getTertioryData");
			component.set("v.loading", true);
			action.setParams({
				"brand": brand.Brand__c,
				"primaryText" : primaryText,
				"secondaryText" : secondaryText
			});	
					
			action.setCallback(this, function(resp) {
				var state=resp.getState();			
				if(state === "SUCCESS"){
					component.set("v.loading", false);
					var res = resp.getReturnValue();
					console.log(res);
					this.buildPicklist(component, "tirtiaryList", res);		
					
					var primary = component.get("v.PrimaryValue");
					var secondary = component.get("v.SecondaryValue");				
					this.fetchItemsbyCategory(component, primary,secondary);		
				}
			});
			
			$A.enqueueAction(action);
		}
	},
	
	fetchItemsbyCategory : function(component, primaryText, secondaryText, tirtiaryText) {		
		var brand = component.get("v.Model");
		if(brand != null && brand != undefined)
		{
			var action = component.get("c.getItembyCategories");
			component.set("v.loading", true);
			action.setParams({
				"brand": brand.Brand__c,
				"selectedPrimary" : primaryText,
				"selectedSecondary" : secondaryText,
				"selectedTertiary":tirtiaryText
			});	
					
			action.setCallback(this, function(resp) {
				component.set("v.loading", false);
				var state=resp.getState();			
				if(state === "SUCCESS"){
					var res = resp.getReturnValue();
					console.log(res);
					component.set("v.response", res);
				}
			});
			
			$A.enqueueAction(action);
		}
	},
	
	fetchItemsbySearchText : function(component, searchText) {	
		var brand = component.get("v.Model");
		if(brand != null && brand != undefined)
		{
			component.set("v.loading", true);
			var action = component.get("c.getItembySearchText");
			
			
			action.setParams({
				"brand": brand.Brand__c,
				"searchText" : searchText
			});	
					
			action.setCallback(this, function(resp) {		
				var state=resp.getState();		
				component.set("v.loading", false);	
				if(state === "SUCCESS"){
					var res = resp.getReturnValue();
					console.log(res);
					component.set("v.response", res);
				}
			});
			
			$A.enqueueAction(action);
		}
	},
	
	
	fetchDescription : function(component, CategoryId){
		var brand = component.get("v.Model");
		if(brand != null && brand != undefined)
		{
			component.set("v.loading", true);				     
			var action = component.get("c.getSelectedDecription");
			
			action.setParams({
				"CategoryId" : CategoryId,
				"Brand": brand.Brand__c
			});	
					
			action.setCallback(this, function(resp) {
				component.set("v.loading", false);
				var state=resp.getState();			
				if(state === "SUCCESS"){			
					var res = resp.getReturnValue();
					console.log(res);
					component.set("v.MemberDescription", res);
					//component.set("v.MemberDescription", res);
					if(res)
					{
						var error  = document.getElementById('DescriptionError');
						//if(error)
							//error.style = 'display:none;';
							component.set("v.isError", false);
					}
				}
			});
			
			$A.enqueueAction(action);
		}
	},
	
	saveComment: function(component, MemberDescription, CaseId, Draft, secureEmailAddress, Attachments, CURead, CRAttachments, selectedCannedResponse){			     
		var action = component.get("c.saveComment");
		component.set("v.loading", true);
		action.setParams({
			"MemberDescription" : MemberDescription,
			"CaseId": CaseId,
			"Draft": Draft,
			"secureEmailAddress": secureEmailAddress,
			"Attachments" : JSON.stringify(Attachments),
			"CURead" : CURead,
			"CRAttachments" : JSON.stringify(CRAttachments),
			"selectedCannedResponse" : selectedCannedResponse
		});	
				
		action.setCallback(this, function(resp) {
			component.set("v.loading", false);
			var state=resp.getState();			
			if(state === "SUCCESS"){
				var res = resp.getReturnValue();
				console.log(res);
				
				var toastEvent = $A.get("e.force:showToast");
	        
		        toastEvent.setParams({		            
		            message : 'Record Saved Successfully',	                        
		            duration:' 3000',
		            key: 'info_alt',
		            type: 'success',
		            mode: 'pester'
		        });
		        toastEvent.fire();		       
		        component.set("v.PrimaryValue", '--- None ---');
				component.set("v.SecondaryValue", '--- None ---');
				component.set("v.TertiaryValue", '--- None ---');
				this.buildPicklist(component, "secondaryList");	
				this.buildPicklist(component, "tirtiaryList");
		
				component.set("v.Draft", false);
				component.set("v.ModelMemberComment.Draft__c", false);				
				component.set("v.MemberDescription", '');
				component.set("v.SearchText", '');
				component.set("v.response", []);
				component.set("v.SelectedCategory", '');
				
				var Attachments = component.get("v.Attachments");
				for (var i = 0; i < Attachments.length; i++) {
					Attachments[i].checkvalue = false;
				}
				
				component.set("v.Attachments", Attachments);
				component.set("v.CRAttachments", CRAttachments);
				var savenew = component.get("v.SaveNew");
				if(!savenew)
				{				    
				    var MemberComment = component.get('v.ModelMemberComment');
				    var isedit = component.get('v.isEdit');
				    if(isedit == true){
				    	var sObectEvent = $A.get("e.force:navigateToSObject");
		   					 sObectEvent .setParams({
		   					 "recordId": MemberComment.Case__c,
		    				 "slideDevName": "detail"
		   					});
	    					sObectEvent.fire();
                       /*  var relatedListEvent = $A.get("e.force:navigateToRelatedList");
                        relatedListEvent.setParams({
                            "relatedListId": "Member_Comments__r",
                            "parentRecordId": MemberComment.Case__c
                        });
                        relatedListEvent.fire();*/
				    }
				    else
				    {
				    	var isedit = component.get('v.isEdit');				    	
				    	 var sObectEvent = $A.get("e.force:navigateToSObject");
		   					 sObectEvent .setParams({
		   					 "recordId": CaseId,
		    				 "slideDevName": "detail"
		   					});
	    					sObectEvent.fire();                     
				    }
					//location.reload();
					$A.get('e.force:refreshView').fire();	
				}
				else
				{
					$A.get('e.force:closeQuickAction').fire();
					var MemberComment = component.get('v.ModelMemberComment');
					var evt = $A.get("e.force:navigateToComponent");
					var isedit = component.get('v.isEdit');	
					var cid;
				    	if(isedit == true){
				    		cid=MemberComment.Case__c;
				    	}
				    	else
				    	{
				    		cid=CaseId;
				    	}
				    	evt.setParams({
						componentDef: "c:MemberComments",
						componentAttributes: {
							 "recordId": cid,
						}
						});
						evt.fire(); 
				}
			}
		});
		
		$A.enqueueAction(action);		
	},
	buildPicklist: function(component, elementId, optionValues) {
		var opts = [];	
		opts.push({
			class: "optionClass",
			label: "--- None ---",
			value: ""
			});
		if(optionValues != undefined)
		{
			for (var i = 0; i < optionValues.length; i++) {
				opts.push({
				class: "optionClass",
				value: optionValues[i],
				label: optionValues[i]
				});
			}
		}
		
		component.find(elementId).set("v.options", opts);
	},
	closest: function(el, selector) {
    var matchesFn;

    // find vendor prefix
    ['matches','webkitMatchesSelector','mozMatchesSelector','msMatchesSelector','oMatchesSelector'].some(function(fn) {
        if (typeof document.body[fn] == 'function') {
            matchesFn = fn;
            return true;
        }
        return false;
    	});    

    var parent;

    // traverse parents
    while (el) {
        parent = el.parentElement;
        if (parent && parent[matchesFn](selector)) {
            return parent;
        }
        el = parent;
    }

    return null;
},

   getParameterByName: function(name, url) {
	    if (!url) url = window.location.href;
	    name = name.replace(/[\[\]]/g, "\\$&");
	    var regex = new RegExp("[?&]" + name + "(=([^&#]*)|&|#|$)"),
	        results = regex.exec(url);
	    if (!results) return null;
	    if (!results[2]) return '';
	    return decodeURIComponent(results[2].replace(/\+/g, " "));
	   },
	   
	   
	 fetchCRAttachments : function(component, CategoryId){
	 component.set("v.CRAttachments", null);	
		var brand = component.get("v.Model");
		if(brand != null && brand != undefined)
		{
			component.set("v.loading", true);				     
			var action = component.get("c.getSelectedAttachments");
			
			action.setParams({
				"CategoryId" : CategoryId,
				"Brand": brand.Brand__c
			});	
					
			action.setCallback(this, function(resp) {
				component.set("v.loading", false);
				var state=resp.getState();			
				if(state === "SUCCESS"){			
					var res = resp.getReturnValue();
					console.log(res);					
					component.set("v.CRAttachments", res);					
					//var caseAttachments = component.get("v.Attachments");
					//var allattachments = [];
					
					//for(var i=0; i<caseAttachments.length ; i++){
					//	allattachments.push(caseAttachments[i]);
					//}
					
					//for(var i=0; i<res.length ; i++){
					//	allattachments.push(res[i]);
					//}
					
					
					//component.set("v.Attachments", allattachments); 
					
					  
					if(res.length > 0){
						component.set("v.ShowAttachmentTable",true);
					}
				
					
				}
			});
			
			$A.enqueueAction(action);
		}
	}
})