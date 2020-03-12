({
	doInit : function(component, event, helper) {
		/*helper.fetchPicklistFields(component);*/
		component.set("v.accountCount",0);
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
	        		//component.set('v.TopTenCases', result.toptencategories);
	        		var aList = result.accList; 
	        		aList.map((obj) => {   
					obj.isShow = true;
					})   	
	        		component.set('v.accList', aList);
	        		
	        		if(aList.length != undefined && aList.length == 1){
	        			component.set('v.singleAccountDetail', true);
                        var serverResult = component.get("v.accList");
                        var selItem = serverResult[0];
                        console.log(selItem);
                        if(selItem){
                        	component.set("v.selectedAcctNumber",selItem);
                    	}	
                    	
        			}
        			component.set('v.loading',false);	
					     		
	        	}            	
	       });
		   $A.enqueueAction(action);
       }
       
      
       
       var action1 = component.get("c.getTop10Cases");
        action1.setCallback(this, function(response){
        	var status = response.getState();
        	if(component.isValid() && status === "SUCCESS")
	        	{
	        		var result =  response.getReturnValue(); 
	        		component.set('v.TopTenCases', result.toptencategories);
	        	}
        	
        });
         $A.enqueueAction(action1);
        
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
	        		//component.set('v.TopTenCases', result.toptencategories);
	        		component.set('v.memberList', result.accList);
                   
                    if(result.accList.length != undefined && result.accList.length == 1){
	        			component.set('v.singleMember', true);
                        var serverResult = component.get("v.memberList");
                        var selItem = serverResult[0];
                        console.log(selItem);
                        if(selItem){
                        	component.set("v.selectedMemberNumber",selItem);
                    	}	
                    	
        			}
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
 		component.set('v.caseObject.Special_Reporting_Number__c','---None---');
 		if(isStandAlone){
 				component.set('v.loading',false);
 			}
 		
 		var action2 = component.get("c.getDependentMap");
        var parameters = {"contrfieldApiName": 'Status',"depfieldApiName":'Sub_Status__c' };
		   action2.setParams(parameters);
		   action2.setCallback(this, function(response){
		   		var status = response.getState();
	        	if(component.isValid() && status === "SUCCESS")
	        	{
	        		
                    component.set('v.statusDependencyMap',response.getReturnValue());
                    
                    var status = [];
                    for(var key in response.getReturnValue()){
                        status.push(key)
                    }
                    component.set('v.statusValues',status);
                    component.set('v.caseObject.Status','Open');
	        		component.set('v.loading',false);	 
	        		component.set('v.subStatus',component.get('v.statusDependencyMap')[component.get('v.caseObject.Status')]);       		
	        	}            	
	       });
		   $A.enqueueAction(action2); 
	},	
	getSubStatus: function(component, event, helper) {
    	component.set('v.subStatus',component.get('v.statusDependencyMap')[component.get('v.caseObject.Status')]);
    } ,
	closePopupAfterUpload: function(component, event, helper) {
    	var caseId = component.get("v.caseId");
		var section = event.getParam("SectionName");
		if(section == 'DetailPage')
		{
	
				$A.get('e.force:closeQuickAction').fire();
                    	    var navEvt = $A.get("e.force:navigateToSObject");
						    navEvt.setParams({
						      "recordId": caseId
						    });
						    navEvt.fire();
		}
		else if(section == 'CasePage')
		{
			 	 	   
			helper.OpenCreateCase(component, event, helper);
		}
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
	  if(pcValue == 'Complaint'){
		  component.set("v.isSubStatusVisible",true);
	  }
	  else
	  {
		  component.set("v.isSubStatusVisible",false);
	  }
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
   
   onFocusLookupAdditional: function(component, event, helper)
   {
	   //component.set('v.showDorpDown', 'true');	   
	   
		var index = parseInt( event.target.getAttribute("data-class") );
		var autodiv = document.getElementById('autocompleteDiv' + index);
		autodiv.style.display = '';
   },
   
   onBlurLookup: function(component, event, helper)
   {
	   component.set('v.showDorpDown', 'false');
   },
   
    onBlurLookupAdditional: function(component, event, helper)
   {
	   //component.set('v.showDorpDown', 'false');
	   
	var index = parseInt( event.target.getAttribute("data-class") );
	var autodiv = document.getElementById('autocompleteDiv' + index);
	autodiv.style.display = 'none';
   },
   
   
   
   itemSelected : function(component, event, helper) {
		helper.itemSelected(component, event, helper);
		document.getElementById('MemberPicker').style = '';        
	},
	
	
	itemSelectedAdditional : function(component, event, helper) {
		helper.itemSelectedAdditional(component, event, helper);
		
		      
	},
	
    clearSelection : function(component, event, helper){
        helper.clearSelection(component, event, helper);
    },
     clearSelectionAdditional : function(component, event, helper){
        helper.clearSelectionAdditional(component, event, helper);
    },
    
    saveCase: function(component,event,helper){
	    var btnid = event.getSource().getLocalId();
	   // alert(btnid);
	    if (btnid == "SaveandNew")
	    {
	    	component.set("v.isSavePressed",true);
	    	component.set('v.IsSaveandNewPressed',true);
	    }
	    else if(btnid == "Save")
	    {
	    	component.set("v.isSavePressed",true);
	    	component.set("v.IsSaveandNewPressed", false);
	    	
	    }
	    else if(btnid == "Next")
	    {
	    	component.set("v.isNextPressed",true);
	    }
    	var isValid = helper.handleError(component,event,helper);
    	
    	if(isValid)
    	{
    		helper.saveNewCase(component,event,helper);
    		
    	}
    	else
    	{
    		component.set("v.isSavePressed",false);
    		component.set("v.isNextPressed",false);
    		component.set("v.IsSaveandNewPressed", false);
    	}
    	
    	if(component.get("v.IsSaveandNewPressed"))
    	{
    		component.set("v.isSavePressed",false);
    	}
    	
    	/*if(component.get("v.isFileUploadComponent"))
    	{
    		component.set("v.isNextPressed",false);
    	}*/
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
    },
    removeMemberAccount : function (component, event){
    	 var target = event.target.id;     
    	 var AccountObjectlist =  component.get("v.AccountObjectlist");
    	 var a= component.get('v.accList');
               for(var i=0;i<a.length;i++){
            	   if(a[i].Id == AccountObjectlist[target].Id){
            		   a[i].isShow=true;
            	   }
               }
               component.set('v.accList', a);
        
    	 AccountObjectlist.splice(parseInt(target),1);
    	 //AccountObjectlist.splice(target.replace('span', ''),1);
       	 component.set("v.AccountObjectlist", AccountObjectlist);
       	 var count = component.get("v.accountCount");
       	 count = count - 1;
    	 component.set("v.accountCount",count);
    },
    addMemberAccount: function (component, event) {
    var count = component.get("v.accountCount");
    if(count < 9)
    {
    			var AccountObjectlist =  component.get("v.AccountObjectlist");    	
    			AccountObjectlist.push({'Account_Details__c': '','Id':null});
    			component.set("v.AccountObjectlist", AccountObjectlist);
    			count = count + 1;
    			component.set("v.accountCount",count);
    }
    	 

    },
    
    changeTopTenCase: function (component, event){
    			var caseObject = component.get('v.caseObject');
		        caseObject.Primary_Category__c = '';
		        caseObject.Secondary_Category__c = '';
		        caseObject.Tertiary_Category__c = '';
		        caseObject.Subject = '';
		        caseObject.CaseComments__c = '';
		       component.set('v.caseObject', caseObject);
		       	
    var stc= component.get('v.selectedTopCategoryValue');//event.getSource().elements[0].value;
   //  component.set('v.selectedTopCategoryValue',stc);
    
       var alltoptencategories = component.get("v.TopTenCases");
        for(var i=0; i< alltoptencategories.length ; i++){
            if(alltoptencategories[i].Case_Type__c === stc){
                var pc= alltoptencategories[i].Primary_Category__c;
                 var sc= alltoptencategories[i].Secondary_Category__c;
                 var tc= alltoptencategories[i].Tertiary_Category__c;
                 var subject= alltoptencategories[i].Subject__c;
                 var internalcomment= alltoptencategories[i].Internal_Comments__c;            
                component.set('v.loading',true);
			    var action = component.get("c.selectCaseCategoriesforTopTenTypes");
			    
			    
			    var parameters = {"PrimaryText": pc , "SecondaryText": sc};
			     action.setParams(parameters);
			    action.setCallback(this, function(response){
			    	var status = response.getState();
		        	if(component.isValid() && status === "SUCCESS")
		        	{
		        		var result =  response.getReturnValue();  	
		        		component.set('v.scOptions', result.scOptions);
		        		component.set('v.tcOptions', result.tcOptions);		        		
		        	
		        		var caseObject = component.get('v.caseObject');
		        		caseObject.Primary_Category__c = pc;
		        		caseObject.Secondary_Category__c = sc;
		        		caseObject.Tertiary_Category__c = tc;
		        		caseObject.Subject = subject;
		        		caseObject.CaseComments__c = internalcomment;
		        		component.set('v.caseObject', caseObject);	
		        		// var selectedLC = component.find("selectedtopcategory").get("v.value");      
		        		 //component.set("v.lcselect", selectedLC.toString());            		
		        		component.set('v.loading',false);
		        	}            	
			   	});
		        $A.enqueueAction(action);
              
            }
            
        }
    
    }
    
  /*  addMemberAccount: function (component, event) {
    	var count = component.get("v.accountCount");
    	if(count < 9)
    	{
    		 $A.createComponents([
    			 [ "lightning:input",
		            {
		                "aura:id": "membername"+count,
		                "label": "Account Number",
		                "type": "text",
		                "placeholder":"Search...",
		                "onmouseenter": component.getReference("c.onFocusLookup"),
		                "onmouseleave" : component.getReference("c.onBlurLookup"),
		                "class" : "default input uiInput uiInputTextForAutocomplete uiInput--default uiInput--input uiInput uiAutocomplete uiInput--default uiInput--lookup",
		                "maxlength": "500"
		                
		               
		            }],
		            	[ "lightning:button",
		            	{
			                "aura:id": "remove"+count,
			                "label": "-",
			                "class":"slds-button",
			                "onclick": component.getReference("c.removePress")
		            	}]
		     ],
            function(newcomponents, status, errorMessage){
            		var inputboxPanel = component.get("v.inputboxPanel");
                    inputboxPanel.push(newcomponents[0]);
                    inputboxPanel.push(newcomponents[1]);
                    
                    component.set("v.inputboxPanel", inputboxPanel);
            });
    	}
    	count = count + 1;
    	component.set("v.accountCount",count);
    },
    
    removePress: function (component, event) {
    
    	 var target = event.getSource().getLocalId();
    	var memberid = target.replace('remove', 'membername');
    	alert(memberid);
    	var loc = target.replace('remove', '');
    		alert(loc);
    	var body = component.get("v.inputboxPanel");
    	body.splice(loc,1);
    	body.splice(loc,1);
    	//body.splice(target.replace('membername', ''),1);
    	
    	component.set("v.inputboxPanel", body);
    	var count = component.get("v.accountCount");
    	count = count-1;
    	 component.set("v.accountCount",count);   	 
       
      },*/
})