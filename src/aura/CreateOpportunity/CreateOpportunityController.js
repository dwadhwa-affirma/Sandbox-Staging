({
	doInit : function(component, event, helper) {
	 var action = component.get("c.FetchLeadData");
        component.find("objOpportunityStage").set("v.disabled", true);
        component.set("v.simpleRecord.Ownership__c",'Auto Assign');
        var recordid = component.get("v.recordId");        
        action.setParams({ "AccountID": recordid });
        component.set("v.loading", true);
		 helper.getEpsys(component);	 
		 component.set('v.simpleRecord.AccountId', recordid);
		 var requestProduct = {'objName': component.get("v.objInfo"), 'contrfieldName': 'Product_Type__c','depfieldName': 'Product_Sub__c' };
        var requestTypeProduct = {'DependentFieldName': 'depnedentFieldMap', 'fieldId': 'objProductType' };
        helper.fetchPicklistValues(component, requestProduct, requestTypeProduct);
        
        helper.fetchMemberAccountDetails(component, recordid);
        
        action.setCallback(this, function (response) {        	
            var status = response.getState();            
            if (component.isValid() && status === "SUCCESS") {
                var result = response.getReturnValue();                
                component.set("v.LeadObject", result[0]); 
                              
                component.set("v.loading", false);               
                component.set('v.simpleRecord.Episys_User_ID__c',result[0].Episys_User_ID__c);
                 component.set('v.EpisysUser',result[0].Branch_of_Lead_creator__c);
                  component.set('v.simpleRecord.StageName','New');
                  component.set("v.group.Name", result[1].Name); 
                  component.set("v.RecordTypeName",result[2] );
                   var opts = [];
	            
	            opts.push({
					class: "optionClass",
					label: "--- None ---",
					value: ""
	            });
			
	            for(var i=0; i <  result[1].length; i++){
	            	var obj = result[1][i];
					opts.push({
						class: "optionClass " + obj.Id,
						value: obj.Id,
						label: obj.Name						
					});					
				}
				component.find("queuename").set("v.options", opts);
                  
                
               
                  
                  
            }
        });  
                
        $A.enqueueAction(action);
	},
	
	closePopup: function(component, event, helper) {
	  $A.get('e.force:closeQuickAction').fire();
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
    
   
       EpisysUserID : function(component, event, helper){
    
        var inp = component.get('v.simpleRecord.Episys_User_ID__c');
        if(inp > 9999)
        {
        	 component.set('v.simpleRecord.Episys_User_ID__c',9999);
        }
    },
    
    leadCreatorChange : function(component, event, helper) {

    	var data = component.get('v.leadCreators');
    	
    	var controllerValueKey = event.getSource().get("v.value");

    	for(var k=0; k < data.length; k++)
    	{
    		if(data[k].Branch_Name__c == controllerValueKey)
    		{
    			component.set("v.simpleRecord.Episys_User_ID__c", data[k].Episys_ID__c);
    			break;
    		}
    	}
    },
    
    QueueNameChange : function(component, event, helper){
    	
    	var queueselected = event.getSource().get("v.value");
    		//var queueselected =	component.find("queuename").get("v.value");
    	component.set("v.GroupNameSelected", queueselected);
    },
    
    selectOwnerTypeChange : function(component, event, helper)
    {
    	var selectedVal= event.getSource().get("v.value");
    	var divAssign = document.getElementById("divAssign");
    	component.set("v.simpleRecord.Ownership__c",selectedVal);
    	var SubStatus = document.getElementById("objSubStatusdiv");
    	//var objOpportunityStagediv = document.getElementById("objOpportunityStagediv");
    	if(selectedVal == "Assign")
    	{
    		divAssign.style = 'display:none;';
    		component.find("objOpportunityStage").set("v.disabled", true);
    		component.find("objOpportunityStage").set("v.value", 'New');
    		SubStatus.style ='display:none;';
    	}
    	else if(selectedVal == "Auto Assign")
    	{
    		divAssign.style = 'display:none;';
    		SubStatus.style ='display:none;';
    		component.find("objOpportunityStage").set("v.disabled", true);
    		component.find("objOpportunityStage").set("v.value", 'New');
    	}
    	else if(selectedVal == "Keep")
    	{
    		divAssign.style = 'display:none;';
    		component.find("objOpportunityStage").set("v.disabled", false);
    		SubStatus.style ='display:none;';
    	}
    	
    	
    	
    	
    	
    },
    
    selectOwnerChange : function(component, event, helper){
    	var selectedVal= event.getSource().get("v.value");
    	var user = document.getElementById("ddluser");
    	var queue = document.getElementById("ddlqueue");
        component.set("v.simpleRecord.User_Owner__c",null);
         component.set("v.simpleRecord.Queue_Assigned_Id__c",null);
       	
    	if(selectedVal == "User"){
    		user.style = '';
    		queue.style = 'display:none;';
    		
    	}
    	else if(selectedVal == "Queue"){
    		queue.style = '';
    		user.style = 'display:none;';
    	    }	
    	    
    	 var controlId = 'userOwner' + 'Control';
        	var control = document.getElementById(controlId);
        	if(control != null && control != undefined)
        	{
	        	control.classList.remove('errorForce');   
	        	var controlErrorId = 'userOwner' + 'Error';     	
	        	var controlError = document.getElementById(controlErrorId);
	        	if(controlError != null)
	        	{
	        		controlError.style = 'display:none;';
	        	}
        	}
        	var inputCmp = component.find('queuename');
        	inputCmp.set("v.errors", null);
    },
    
    selectStageChange : function(component, event, helper){
    
    	var selectedVal= event.getSource().get("v.value");
    	var SubStatus = document.getElementById("objSubStatusdiv");
    	if(selectedVal =='Outreach')
    	{
    		SubStatus.style ='';
    		
    	}
    	else
    	{
    		SubStatus.style ='display:none;';
    	}
    	
    
    },
    
     changeProductType : function(component, event, helper) {	   
	   
	  var controllerValueKey = event.getSource().get("v.value");
 
      // get the map values   
      var Map = component.get("v.depnedentFieldMap");
 
      // check if selected value is not equal to None then call the helper function.
      // if controller field value is none then make dependent field value is none and disable field
      if (controllerValueKey != '--- None ---') { 
         
         var ListOfDependentFields = Map[controllerValueKey];           
         var requestTypeProduct  = {'dependentFieldId': 'objProductSubType', 'fieldstatus': 'isDependentDisable' };         
         
                
         helper.fetchDepValues(component, ListOfDependentFields, requestTypeProduct);         
 
      } else {
         var defaultVal = [{
            class: "optionClass",
            label: '--- None ---',
            value: '--- None ---'
         }];
         component.find('objProductSubType').set("v.options", defaultVal);
         component.set("v.isDependentDisable", true);
      }
   },   
       
   SaveOpportunity: function (component, event, helper) {
    
        var objOpp = component.get("v.simpleRecord");
        var queueid = component.get("v.GroupNameSelected");
        var isValid = helper.handleError(component,event,helper);
        
        var selectedActNumber = component.get("v.selectedAcctNumber");
        
    	if(isValid)
    	{
    		component.set("v.loading", true);
    		 if(component.get('v.simpleRecord.Product_Sub__c') == '--- None ---')
		    {
    			 objOpp.Product_Sub__c = '';
		    }
    		if(component.get('v.simpleRecord.Sub_Status__c') == '--- None ---')
		    {
    			 objOpp.Sub_Status__c = '';
		    }
		    if(selectedActNumber != null)
	        {
	        	objOpp.Member_Account__c =  selectedActNumber.Id;      
	        }
    		helper.HandleSaveOpportunity(component, objOpp, queueid);
    	}
    },
})