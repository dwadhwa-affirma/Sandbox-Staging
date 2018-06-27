({
	doInit : function(component, event, helper) {
		/*helper.fetchPicklistFields(component);*/
		
		component.set('v.loading',true);
	   var action = component.get("c.getData");
	   var recordid = component.get("v.recordId");
	   var accountId = component.get("v.accountDetailId");
	   if(recordid == undefined && accountId == "")
		   component.set('v.isStandalone',true);
	   var isStandAlone = component.get("v.isStandalone");
	   var isAccountDetails = component.get("v.isAccountDetails");
	   if(!isStandAlone && !isAccountDetails)
	   {
		   var parameters = {"accoutid": recordid };
		   action.setParams(parameters);
		   action.setCallback(this, function(response){
		   		var status = response.getState();
	        	if(component.isValid() && status === "SUCCESS")
	        	{
	        		var result =  response.getReturnValue();  	
	        		component.set('v.accObject', result.accountDetails);
	        		
	        		component.set('v.accList', result.accList);
					/*var footer = document.getElementById('CreateCaseMemberPageFooter');
	        		
	        		footer.parentElement.parentElement.parentElement.parentElement.parentElement.parentElement.parentElement.append(footer);
	        		footer.style.display = '';
	        	
	        		var header = document.getElementById('CreateCaseMemberPageHeader');
	        		header.parentElement.parentElement.parentElement.parentElement.parentElement.parentElement.parentElement.prepend(header);
	        		header.style.display = '';
	        		
	        		header.parentNode.removeChild(header.nextSibling);
	        		
	        		header.parentNode.setAttribute('id','createCasePopup'); */
	        		
	        		component.set('v.loading',false);	        		
	        	}            	
	       });
		   $A.enqueueAction(action);
       }
       
       
       if(isAccountDetails)
       {    	   
    	   action = component.get("c.getAccountDetailsData");
    	   var parameters = {"accoutid": accountId };
		   action.setParams(parameters);
		   action.setCallback(this, function(response){
		   		var status = response.getState();
	        	if(component.isValid() && status === "SUCCESS")
	        	{
	        		var result =  response.getReturnValue();  	
	        		component.set('v.memObject', result.accountDetails);
	        		
	        		component.set('v.memberList', result.accList);
					/*var footer = document.getElementById('CreateCaseMemberPageFooter');
	        		
	        		footer.parentElement.parentElement.parentElement.parentElement.parentElement.parentElement.parentElement.append(footer);
	        		footer.style.display = '';
	        	
	        		var header = document.getElementById('CreateCaseMemberPageHeader');
	        		header.parentElement.parentElement.parentElement.parentElement.parentElement.parentElement.parentElement.prepend(header);
	        		header.style.display = '';
	        		
	        		header.parentNode.removeChild(header.nextSibling.nextSibling);
	        		
	        		header.parentNode.setAttribute('id','createCasePopup'); */
	        		
	        		component.set('v.loading',false);	        		
	        	}            	
	       });
		   $A.enqueueAction(action);
       }
       
       helper.fetchPicklistFields(component);		
            
            
		var scOptions = [{'Text': '--- None ---','Value': ''}];
 		component.set('v.scOptions', scOptions);
 		component.set('v.tcOptions', scOptions);
 		component.set('v.caseObject.Status','Open');
 		component.set('v.caseObject.Ownership__c','Auto Assign');
 		if(isStandAlone)
 			component.set('v.loading',false);
	},	
	
	closePopupAfterUpload: function(component, event, helper) {
    	var caseId = component.get("v.caseId");
		
	
	 $A.get('e.force:closeQuickAction').fire();
                    	    var navEvt = $A.get("e.force:navigateToSObject");
						    navEvt.setParams({
						      "recordId": caseId
						    });
						    navEvt.fire();
		
	 // window.location ='/lightning/r/Case/' +  currId + '/view' ;
   } ,
		
	searchEvents: function(component, event, helper) {
		var value =  event.target.value;
	    if(event.keyCode == 13){
	    
	    	component.set('v.loading',true);
	       var action = component.get("c.getDataValue");
		   var recordid = component.get("v.recordId");
		   var parameters = {"newSearchText": value };
		   action.setParams(parameters);
		   action.setCallback(this, function(response){
		   		var status = response.getState();
	        	if(component.isValid() && status === "SUCCESS")
	        	{
	        		var result =  response.getReturnValue();
	        		component.set('v.optionsList', result);
	        		component.set('v.loading',false);
	        	}            	
		   	});
            $A.enqueueAction(action);
        }
   },   
   closePopup: function(component, event, helper) {
   var isStandAlone = component.get("v.isStandalone");
   var isAccountDetails = component.get("v.isAccountDetails");
	   if(!isStandAlone || isAccountDetails)
		   $A.get('e.force:closeQuickAction').fire();
       else
       {
    	  /* var workspaceAPI = component.find("workspace");
    	   workspaceAPI.getFocusedTabInfo().then(function(response) {
            var focusedTabId = response.tabId;
            workspaceAPI.closeTab({tabId: focusedTabId});
        })
        .catch(function(error) {
            console.log(error);
        });*/
        window.close();
       }
	  
   },
   changeSelectedCategory: function(component, event, helper) {
	   component.set('v.loading',true);
	    var action = component.get("c.selectCaseCategories");
	    
	    var selectedText = event.target.value;
	    var parameters = {"selectedText": selectedText};
	     action.setParams(parameters);
	    action.setCallback(this, function(response){
	    	var status = response.getState();
        	if(component.isValid() && status === "SUCCESS")
        	{
        		var result =  response.getReturnValue();  	
        		component.set('v.scOptions', result.scOptions);
        		component.set('v.tcOptions', result.tcOptions);
        		
        		var selectedTextArray  = selectedText.split(' / ');
        		var caseObject = component.get('v.caseObject');
        		caseObject.Primary_Category__c = selectedTextArray[0];
        		caseObject.Secondary_Category__c = selectedTextArray[1];
        		caseObject.Tertiary_Category__c = selectedTextArray[2];
        		component.set('v.caseObject', caseObject);
        		component.set('v.loading',false);
        	}            	
	   	});
        $A.enqueueAction(action);
   },   
   changePrimaryCategory: function(component, event, helper) {
	   component.set('v.loading',true);
	   var pcValue = component.get('v.caseObject').Primary_Category__c;
	   var action = component.get("c.getscOptions");
	    
	    var parameters = {"pcValue": pcValue};
	    action.setParams(parameters);
	    action.setCallback(this, function(response){
	    	var status = response.getState();
        	if(component.isValid() && status === "SUCCESS")
        	{
        		var result =  response.getReturnValue();  	
        		component.set('v.scOptions', result);
        		var caseObject = component.get('v.caseObject');
        		
        		caseObject.Secondary_Category__c = null;
        		caseObject.Tertiary_Category__c = null;
        		
        		var tcOptions = [{'Text': '--- None ---','Value': ''}];
				component.set('v.tcOptions', tcOptions);
				component.set('v.loading',false);
        	}            	
	   	});
        $A.enqueueAction(action);
   },   
   changeSecondaryCategory: function(component, event, helper) {
	   component.set('v.loading',true);
	   var scValue = component.get('v.caseObject').Secondary_Category__c;
	   var action = component.get("c.gettcOptions");
	    
	    var parameters = {"scValue": scValue};
	    action.setParams(parameters);
	    action.setCallback(this, function(response){
	    	var status = response.getState();
        	if(component.isValid() && status === "SUCCESS")
        	{
        		var caseObject = component.get('v.caseObject');
        		var result =  response.getReturnValue();  	
        		component.set('v.tcOptions', result);
        		caseObject.Tertiary_Category__c = null;
        		component.set('v.loading',false);
        	}            	
	   	});
        $A.enqueueAction(action);
   },   
   onFocusLookup: function(component, event, helper)
   {
	   component.set('v.showDorpDown', 'true');	   
   },
   onBlurLookup: function(component, event, helper)
   {
	   component.set('v.showDorpDown', 'false');
   },
   itemSelected : function(component, event, helper) {
		helper.itemSelected(component, event, helper);
		document.getElementById('MemberPicker').style = '';        
	},
    clearSelection : function(component, event, helper){
        helper.clearSelection(component, event, helper);
    },
    saveCase: function(component,event,helper){
    	var isValid = helper.handleError(component,event,helper);
    	
    	if(isValid)
    	{
    		helper.saveNewCase(component,event,helper);
    	}
    },
    selectfileupload: function(component,event,helper){    	
    	var value = event.target.checked;
    	component.set('v.isFileUpload',value);
    },
    SubmitAttachment : function(component,event,helper){
    	 helper.submitfile(component,event,helper);
    },
   onFocusMemberLookup: function(component, event, helper)
   {
	   component.set('v.showMemberDorpDown', 'true');	   
   },
   onBlurMemberLookup: function(component, event, helper)
   {
	   component.set('v.showMemberDorpDown', 'false');
   },
   itemMemberSelected : function(component, event, helper) {
		helper.itemMemberSelected(component, event, helper);
		document.getElementById('MemberAccountPicker').style = '';        
	},
    clearMemberSelection : function(component, event, helper){
        helper.clearMemberSelection(component, event, helper);
    },
    
    changeDate : function(component, event){  
    	var assessmentData = component.get("v.caseObject");
    	
    	if(event.getParams().keyCode == '46' || event.getParams().keyCode == '8')
    	{
    		var whichOne = event.getSource().getLocalId();
    		
    		assessmentData.Future_Date__c  = '';
    			
    	}    	
    	component.set("v.caseObject", assessmentData);
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
            var navEvt = $A.get("e.force:navigateToSObject");
						    navEvt.setParams({
						      "recordId": cmp.get('v.caseId'),
						      "slideDevName": "related"
						    });
			navEvt.fire();
    }
     
    
})