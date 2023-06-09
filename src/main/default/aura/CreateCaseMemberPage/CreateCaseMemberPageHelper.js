({
	 MAX_FILE_SIZE: 750000, 
    fetchPicklistFields: function(component) {
		var picklistFields = component.get("v.picklistFields");
		 
		var NAFields = ["Primary_Category__c"];
		picklistFields['Case'] = NAFields;
		 
		this.getPicklistValues(component,picklistFields);
	},	
		
	getPicklistValues : function(component, sobjFieldsmap) {		
		var action = component.get("c.getPicklistValues");
		
		action.setParams({
		"objpicklistFieldsMap": JSON.stringify(sobjFieldsmap)
		});			
			action.setCallback(this, function(resp) {
			var state=resp.getState();			
			if(state === "SUCCESS"){
				var res = resp.getReturnValue();
				console.log(res);
				var obj;
				for(obj in res){
					var objName = res[obj];
					console.log('object name --> ' + obj);
					var field;
					for(field in objName){
						console.log('fields --> ' + field);
						var optionValues = objName[field];
						console.log('options --> ' + optionValues);
						this.buildPicklist(component, obj + "." + field, optionValues);
					}
				}
			}
		});
		$A.enqueueAction(action);
	},
	 
	buildPicklist: function(component, elementId, optionValues) {
		var opts = [];
		if (optionValues != undefined && optionValues.length > 0) {
			opts.push({
			class: "optionClass",
			label: "--- None ---",
			value: ""
			});
		}
	 
		for (var i = 0; i < optionValues.length; i++) {
			opts.push({
			class: "optionClass",
			value: optionValues[i],
			label: optionValues[i]
			});
		}
		component.find(elementId).set("v.options", opts);
	},
    
    GetExistingLoansData : function(component, Id) {    	
		var action = component.get("c.getExistingLoans");
		
		action.setParams({
		"AssessmentId": Id
		});			
			action.setCallback(this, function(resp) {
			var state=resp.getState();
			console.log('state ' + state);
			if(state === "SUCCESS"){
				var res = resp.getReturnValue();
				component.set('v.otherExistingLoans', res);				
			}
		});
		$A.enqueueAction(action);
	},
	itemSelected : function(component, event, helper) {
        var target = event.target;   
        var SelIndex = helper.getIndexFrmParent(target,helper,"data-selectedindex");  
        if(SelIndex){
            var serverResult = component.get("v.accList");
            var selItem = serverResult[SelIndex];
            if(selItem){
               component.set("v.selectedAcctNumber",selItem);
               component.set('v.showDorpDown', 'false');
               var a= component.get('v.accList');
               for(var i=0;i<a.length;i++){
            	   if(a[i].Id == selItem.Id){
            		   a[i].isShow=false;
            	   }
               }
               component.set('v.accList', a);
               //component.set("v.last_ServerResult",serverResult);
            } 
           // component.set("v.accList",null); 
        } 
	}, 
	
	itemSelectedAdditional : function(component, event, helper) {
        var target = event.target;   
        var SelIndexid = helper.getIndexFrmParent(target,helper,"data-class");  
        var SelIndex = helper.getIndexFrmParent(target,helper,"data-selectedIndexId");  
        if(SelIndex){
            var serverResult = component.get("v.accList");
            var selItem = serverResult[SelIndex];
             var acc = component.get("v.AccountObjectlist");
          
            if(selItem){
            	  for (var len = 0; len < acc.length; len++) { 
            		   if(acc[len].Id== null && len == SelIndexid )
            		   {
            			   acc[len] = selItem;
            			   break;
            		   }
            		   
            		  
            	  }
            	 
               component.set("v.AccountObjectlist",acc);
                var a= component.get('v.accList');
               for(var i=0;i<a.length;i++){
            	   if(a[i].Id == selItem.Id){
            		   a[i].isShow=false;
            	   }
               }
               component.set('v.accList', a);
              
              }
           
              document.getElementById('MemberAccountPicker' + SelIndexid).style = '';  
           // component.set("v.accList",null); 
        }
         
	}, 
	
	
	itemMemberSelected  : function(component, event, helper) {
        var target = event.target;   
        var SelIndex = helper.getIndexFrmParent(target,helper,"data-selectedindex");  
        if(SelIndex){
            var serverResult = component.get("v.memberList");
            var selItem = serverResult[SelIndex];
            if(selItem){
               component.set("v.selectedMemberNumber",selItem);
               component.set('v.showMemberDorpDown', 'false');               
            }           
        } 
	}, 
	clearSelection: function(component, event, helper){
       
         var acc = component.get("v.selectedAcctNumber");
         var a= component.get('v.accList');
               for(var i=0;i<a.length;i++){
            	   if(a[i].Id == acc.Id){
            		   a[i].isShow=true;
            	   }
               }
               component.set('v.accList', a);
          component.set("v.selectedAcctNumber",null);
        //component.set("v.accList",null);
	},
	
	clearSelectionAdditional: function(component, event, helper){
      
       var acc = component.get("v.AccountObjectlist");
        var target = event.target;   
     // var accountval =  target.parentNode.parentNode.parentNode.parentNode.firstElementChild.title;
       //var serverResult = component.get("v.accList");
       
        var SelIndex = helper.getIndexFrmParent(target,helper,"data-account");  
        if(SelIndex){
            var serverResult = component.get("v.accList");
          //  var selItem = serverResult[SelIndex];
            var selItem = acc[SelIndex];
            	acc[SelIndex]= [{'Account_Details__c': '','Id':null}];
            	 var a= component.get('v.accList');
               for(var i=0;i<a.length;i++){
            	   if(a[i].Id == selItem.Id){
            		   a[i].isShow=true;
            	   }
               }
               component.set('v.accList', a);
       
            }
            
             component.set("v.AccountObjectlist",acc);
            
            
	},
	clearMemberSelection: function(component, event, helper){
        component.set("v.selectedMemberNumber",null);
        //component.set("v.accList",null);
	},
	getIndexFrmParent : function(target,helper,attributeToFind){
        //User can click on any child element, so traverse till intended parent found
        var SelIndex = target.getAttribute(attributeToFind);
        while(!SelIndex){
            target = target.parentNode ;
			SelIndex = helper.getIndexFrmParent(target,helper,attributeToFind);           
        }
        return SelIndex;
	},
	saveNewCase: function(component,event,helper){
		component.set('v.loading',true);
		var caseModel = component.get("v.caseObject");
		var actModel = component.get("v.accObject");
		var selectedActNumber = component.get("v.selectedAcctNumber");
		var selectedMemberNumber = component.get("v.selectedMemberNumber");
		var memObject = component.get("v.memObject");
		var AccountObjectlist = component.get("v.AccountObjectlist");
		for (var len = 0; len < AccountObjectlist.length; len++)
		 { 
            		   if(AccountObjectlist[len].Id== null || AccountObjectlist[len].Id =="" )
            		   {
            			   AccountObjectlist.splice(len,1);
            			   len= len-1;            			  
            		   }
        }
		var action;
		var parameters;
		if(selectedActNumber == undefined)
	   {
		   if(selectedMemberNumber != undefined)
		   {
			   action = component.get("c.saveDataForAccountDetails");
			   parameters = {"memObject": memObject, "caseObject": caseModel, "selectedMemberNumber" : selectedMemberNumber};
		   }
		   else
		   {
			   action = component.get("c.saveStandAloneData");
			   parameters = {"caseObject": caseModel};
		   }
	   }
	   else
	   {
		   action = component.get("c.saveData");
		   parameters = {"caseObject": caseModel, "accObject" : actModel, "selectedAcctNumber" : selectedActNumber,"AccountObjectlist":AccountObjectlist};		   
	   }
	   action.setParams(parameters);
	   action.setCallback(this, function(response){
	   		var status = response.getState();
        	if(component.isValid() && status === "SUCCESS")
        	{
        		var result =  response.getReturnValue();
        		if(result.IsSaved == 'true')
        		{

        			component.set('v.caseId', result.CaseId);
        			component.set('v.CaseNumber', result.CaseNumber);  
        			       			    						    
				    var toastEvent = $A.get("e.force:showToast");         
			          toastEvent.setParams({              
			              message : result.Message,                         
			              duration:' 3000',
			              key: 'info_alt',
			              type: 'success',
			              mode: 'pester'
			          });
			          toastEvent.fire();
			          
			        var isFileUpload = component.get('v.isFileUpload');
                    if(isFileUpload){
        				component.set("v.isFileUploadComponent", true); 
        				component.set("v.isNextPressed", false); 
        				if(document.getElementsByClassName('modal-maincontent')[0] != undefined){          
        				document.getElementsByClassName('modal-maincontent')[0].style.minHeight = '350px';
						document.getElementsByClassName('modal-maincontent')[0].style.height = '350px';
						document.getElementsByClassName('modal-maincontent')[0].style.height  = '471px';
						} 
						
                    }
                    else
                    {
                    	var varIsSaveandNew;
                    		varIsSaveandNew = component.get('v.IsSaveandNewPressed');
                    		if(!varIsSaveandNew)
                    			{
			                    	$A.get('e.force:closeQuickAction').fire();
			                    	    var navEvt = $A.get("e.force:navigateToSObject");
									    navEvt.setParams({
									      "recordId": result.CaseId,
									      "slideDevName": "related"
									    });
									    navEvt.fire();
                    			}
                    			else if(varIsSaveandNew)
                    			{
                    				
	                                helper.OpenCreateCase(component, event, helper);
                    			
                    			}
                    			
                    }    
        		}
        		else
        		{
        			var toastEvent = $A.get("e.force:showToast");
				    toastEvent.setParams({
				        message : result.Message,                         
			            duration:' 3000',
			            key: 'info_alt',
			            type: 'error',
			            mode: 'pester'
				    });
				    toastEvent.fire();
				    $A.get('e.force:closeQuickAction').fire();
        		}
        		component.set('v.loading',false);
        		
        	}
           else{
               var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        console.log("Error message: " + 
                                 errors[0].message)
                       // alert(errors[0].message);
                    }
                }
                let showToast = $A.get( "e.force:showToast" );
                showToast.setParams({
                    title : 'Error!!!',
                    type : 'error',
                    mode : 'sticky',
                    message : errors[0].message
             });
              component.set('v.loading',false);
                component.set('v.IsSaveandNewPressed', false);
                component.set('v.isSavePressed', false);
                showToast.fire();
           }
        });
         $A.enqueueAction(action);		
	},
	handleError: function(component, event, helper){
	
        var Primary_Category__c = helper.isEmpty(component,"Case.Primary_Category__c", helper);
        var Secondary_Category__c = helper.isEmpty(component,"Secondary_Category__c", helper);
        var Tertiary_Category__c = helper.isEmpty(component,"Tertiary_Category__c", helper);
        var OwnerId =  helper.isEmptyForce(component,"OwnerId", helper);
        
        
        var isValid = true;
        if(!Primary_Category__c || !Secondary_Category__c || !Tertiary_Category__c)
        {
        	isValid = false;
        }
        if(component.get("v.isStandalone") == false && component.get("v.isAccountDetails") == false)
        {
	        if(component.get('v.selectedAcctNumber') == null && component.get('v.accObject.PersonID__c') != undefined && component.get('v.accObject.PersonID__c') != null && component.get('v.accObject.PersonID__c') != '')
	        {
	        	document.getElementById('MemberPicker').style = 'border-color: rgb(194, 57, 52);box-shadow: rgb(194, 57, 52) 0 0 0 1px inset;';
	        	document.getElementById('MemberPickerError').style = '';
	        	isValid = false;
	        }
	        else
	        {
	        	document.getElementById('MemberPicker').style = '';      
	        	document.getElementById('MemberPickerError').style = 'display:none;';  
	        }       
       }
       else if(component.get("v.isAccountDetails") == true)
       {
    	   if(component.get('v.selectedMemberNumber') == null)
	        {
	        	document.getElementById('MemberAccountPicker').style = 'border-color: rgb(194, 57, 52);box-shadow: rgb(194, 57, 52) 0 0 0 1px inset;';
	        	document.getElementById('MemberAccountPickerError').style = '';
	        	isValid = false;
	        }
	        else
	        {
	        	document.getElementById('MemberAccountPicker').style = '';      
	        	document.getElementById('MemberAccountPickerError').style = 'display:none;';  
	        }
       }
	   	var inputCmp = component.find('Ownership__c');
	   	
	   	var value = inputCmp.get("v.value");
	   	if(value == 'Assign' && !OwnerId)
	   	{
	   		isValid = false;
	   	}
       
      
        return isValid;
        
    },
    isEmpty: function(component, fieldName, helper)
    {
    	var inputCmp = component.find(fieldName);
    	var value = inputCmp.get("v.value");
    	var isValid = true;
    	if(value == '' || value == '--- None ---' || value == undefined ){
        	inputCmp.set("v.errors", [{message:"Complete this field"}]);
        	isValid = false;
        }
        else
        {
        	inputCmp.set("v.errors", null);
        }
        
        
        //
        
        return isValid;
    	
    },
    
    isEmptyForce: function(component, fieldName, helper)
    {
    	var inputCmp = component.find(fieldName);
    	var value = inputCmp.get("v.value");
    	var isValid = true;
    	if(value == '' || value == '--- None ---' || value == undefined ){
    		
        	
        	/*inputCmp.elements[0].classList.add('errorForce');         	
        	if(inputCmp.elements[0].nextSibling != null && inputCmp.elements[0].nextSibling != undefined)
        	{
        		inputCmp.elements[0].nextSibling.remove();
        	}
        	inputCmp.elements[0].parentElement.append(ul);
        	
        	inputCmp.elements[0].className += ' errorForce';
        	inputCmp.elements[0].firstChild.className += ' errorForce';*/
        	
        	var OwnerId = document.getElementById('OwnerIdControl');
        	OwnerId.classList.add('errorForce');
        	OwnerId.className += ' errorForce';
        	var OwnerError = document.getElementById('OwerIdError');
        	OwnerError.style = '';
        	isValid = false;
        }
        else
        {
        	/*inputCmp.elements[0].classList.remove('errorForce');
        	if(inputCmp.elements[0].nextSibling != null && inputCmp.elements[0].nextSibling != undefined)
        	{
        	 inputCmp.elements[0].nextSibling.remove();
        	}*/
        	var OwnerId = document.getElementById('OwnerIdControl');
        	OwnerId.classList.remove('errorForce');        	
        	var OwnerError = document.getElementById('OwerIdError');
        	OwnerError.style = 'display:none;';
        }
        return isValid;
    	
    },
    
     OpenCreateCase : function(component, event, helper)
     {     	 
    	 	 var Speedcase = component.get("v.TopTenCases");
    	 	 component.set("v.caseObject.Future_Date__c", "");
			if(component.get("v.selectedAcctNumber.Name")!=null && component.get("v.selectedAcctNumber.Name")!="" ){  		component.set("v.selectedAcctNumber",null);}
	 		component.set("v.searchField","");
	 		component.set("v.caseObject.CaseComments__c", "");
	    	component.set("v.caseObject.LTK__c", "");
	 		component.set("v.caseObject.Follow_up_Text__c","");
	 	
	 		component.set('v.caseObject.Status','Open');
	 		component.set('v.caseObject.Special_Reporting_Number__c','---None---');
	 		component.set('v.caseObject.Ownership__c','Auto Assign'); 
            component.set('v.selectedMemberNumber ',null);  
            component.set('v.optionsList', null);
            component.set('v.caseObject.Subject', "");
            var scOptions = [{'Text': '--- None ---','Value': ''}];
            component.set('v.scOptions', scOptions);
            component.set('v.tcOptions', scOptions);
            component.set('v.caseObject.Primary_Category__c', '--- None ---');
            component.set('v.caseObject.Secondary_Category__c', '--- None ---');
            component.set('v.caseObject.Tertiary_Category__c', '--- None ---');
			
         	component.set('v.TopTenCases', '--- None ---');
         	component.set('v.selectedTopCategoryValue','--- None ---');
         	component.set('v.TopTenCases', Speedcase); 
      
                  
            component.set('v.caseObject.Status','Open');
            component.set('v.caseObject.Ownership__c','Auto Assign');
            
            component.set('v.isFileUpload',false);
            component.set("v.IsSaveandNewPressed", false);
            component.set("v.isFileUploadComponent", false);
          
            var acc =  component.get('v.AccountObjectlist');
            var length =   component.get("v.accountCount");
            acc.splice(0,parseInt(length));
           
            component.set('v.AccountObjectlist', acc);
            component.set("v.accountCount",0);
           if(document.getElementsByClassName('modal-maincontent')[0] != undefined){          
        				document.getElementsByClassName('modal-maincontent')[0].style.minHeight = '518px';
						document.getElementsByClassName('modal-maincontent')[0].style.height = null;
						//document.getElementsByClassName('modal-maincontent')[0].parentElement.parentElement.parentElement.parentElement.parentElement.parentElement.style.minHeight  = '641px';
						//document.getElementsByClassName('modal-maincontent')[0].parentElement.parentElement.parentElement.parentElement.parentElement.parentElement.style.height = null;
				} 
            
	         
                var a= component.get('v.accList');
               for(var i=0;i<a.length;i++){            	  
            		   a[i].isShow=true;            	   
               }
               component.set('v.accList', a);   
               
               var searchbox = document.getElementById('SearchFieldText');
               searchbox.value= "";                   
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
			        		
			        		var a= result.accList;
			               for(var i=0;i<a.length;i++){            	  
			            		   a[i].isShow=true;            	   
			               }
			        		
			        		component.set('v.accList', a);
								        		
			        		component.set('v.loading',false);	
			        		component.set("v.caseObject.Future_Date__c", "");
			        		//component.set("v.selectedAcctNumber",null);
			        		var aList = result.accList; 
			        		if(aList.length == 2 ){
				        		for(var i = 0; i < aList.length; i++){
				        			if(aList[i].RecType__c == 'ACCT'){
				        				component.set('v.singleAccountDetail', true);
				                        var serverResult = component.get("v.accList");
				                        var selItem = serverResult[0];
				                        console.log(selItem);
				                        if(selItem){
				                        	component.set("v.selectedAcctNumber",selItem);
				                    	}
				        			}
				        		}
			        		}
                            //if(component.get("v.accObject.Name")!=""){  		component.set("v.accObject.Name","");} 
					 		component.set("v.searchField","");
					 		component.set("v.caseObject.CaseComments__c", "");
					    	component.set("v.caseObject.LTK__c", "");
					    	component.set("v.isFileUpload",false);
					 		component.set("v.caseObject.Follow_up_Text__c","");
					 		component.set("v.caseObject.Subject", "");
					 		component.set('v.caseObject.Status','Open');
					 		component.set('v.caseObject.Ownership__c','Auto Assign');
					 		 component.set('v.selectedMemberNumber ',null);  
					 		 component.set('v.optionsList', null);
			        		var scOptions = [{'Text': '--- None ---','Value': ''}];
			        			component.set('v.scOptions', scOptions);
			        			component.set('v.tcOptions', scOptions);
			        			component.set('v.caseObject.Status','Open');
			        			component.set('v.caseObject.Ownership__c','Auto Assign'); 		
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
												        		
				        		component.set('v.loading',false);	 
				        		component.set("v.caseObject.Future_Date__c", "");
				        		component.set("v.selectedAcctNumber",null);
						 		component.set("v.searchField","");
						 		component.set("v.caseObject.CaseComments__c", "");
						    	component.set("v.caseObject.LTK__c", "");
						    	component.set("v.isFileUpload",false);
						 		component.set("v.caseObject.Follow_up_Text__c","");
                           
						 		component.set("v.caseObject.Subject", "");   
						 		component.set('v.caseObject.Status','Open');
						 		component.set('v.caseObject.Ownership__c','Auto Assign');
						 		 component.set('v.selectedMemberNumber ',null);
						 		 component.set('v.optionsList', null); 
						 		 var scOptions = [{'Text': '--- None ---','Value': ''}];
						 		component.set('v.scOptions', scOptions);
						 		component.set('v.tcOptions', scOptions);
						 		component.set('v.caseObject.Status','Open');
						 		component.set('v.caseObject.Ownership__c','Auto Assign');     		
				        	}            	
				       });
					   $A.enqueueAction(action);
					   }
					   
					   helper.fetchPicklistFields(component);		
            
            
					
			 		if(isStandAlone)
			 			component.set('v.loading',false);
    	 
     },
     
    
    
})