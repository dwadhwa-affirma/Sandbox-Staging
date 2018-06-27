({

    doInit: function (component, event, helper) {   
    debugger; 	
        var action = component.get("c.FetchLeedData");
        
        var recordid = component.get("v.recordId");        
        action.setParams({ "AccountID": recordid });
        component.set("v.loading", true);
        
        helper.getEpsys(component);
        //helper.fetchPicklistFields(component);
       // helper.fetchEventSourceOptions(component);
        
        var requestProduct = {'objName': component.get("v.objInfo"), 'contrfieldName': 'Product_Type__c','depfieldName': 'Product_Subtype__c' };
        var requestTypeProduct = {'DependentFieldName': 'depnedentFieldMap', 'fieldId': 'objProductType' };
        helper.fetchPicklistValues(component, requestProduct, requestTypeProduct);
        
        var requestStatus = {'objName': component.get("v.objInfo"), 'contrfieldName': 'Status','depfieldName': 'Sub_Status__c' };       
        var requestTypeStatus = {'DependentFieldName': 'depnedentFieldMapLeadStatus', 'fieldId': 'LeadStatus' }; 
        helper.fetchPicklistValues(component, requestStatus, requestTypeStatus);
        
      
        helper.fetchMemberAccountDetails(component, recordid);
        
        action.setCallback(this, function (response) {        	
            var status = response.getState();            
            if (component.isValid() && status === "SUCCESS") {
                var result = response.getReturnValue();                
                component.set("v.LeadObject", result);                
                component.set("v.loading", false);
                
                /*var footer = document.getElementById('CreateLeadFooter');
        		var body = helper.closest(footer,'.modal-container');
        		body.append(footer);
        		footer.previousSibling.remove();
        		footer.parentNode.setAttribute('id','createLeadPopup');*/
        		
        		component.set('v.LeadObject.Lead_Type__c','Individual');
        		component.set('v.LeadObject.Status','Open');
            }
        });  
                
        $A.enqueueAction(action);
    },
    
    leadCreatorChange : function(component, event, helper) {

    	var data = component.get('v.leadCreators');
    	
    	var controllerValueKey = event.getSource().get("v.value");

    	for(var k=0; k < data.length; k++)
    	{
    		if(data[k].Branch_Name__c == controllerValueKey)
    		{
    			component.set("v.LeadObject.Episys_User_ID__c", data[k].Episys_ID__c);
    			break;
    		}
    	}
    },
    
    SaveLead: function (component, event, helper) {
    
        var objLead = component.get("v.LeadObject");
        var selectedActNumber = component.get("v.selectedAcctNumber");
        
        if(selectedActNumber != null)
        {
        	component.set("v.LeadObject.Member_Account__c",selectedActNumber.Id);        
        }
        
        var isValid = helper.handleError(component,event,helper);
          	
    	if(isValid)
    	{
    		component.set("v.loading", true);
    		helper.HandleSaveLead(component, objLead);
    	}
    },
    
    closePopup: function(component, event, helper) {
	  $A.get('e.force:closeQuickAction').fire();
   },    
   
   changeLeadStatus : function(component, event, helper) {	   
	   
	  var controllerValueKey = event.getSource().get("v.value");
 
      // get the map values   
      var Map = component.get("v.depnedentFieldMapLeadStatus");
 
      // check if selected value is not equal to None then call the helper function.
      // if controller field value is none then make dependent field value is none and disable field
      if (controllerValueKey != '--- None ---' && controllerValueKey != 'Open') {
 
         // get dependent values for controller field by using map[key].  
         // for i.e "India" is controllerValueKey so in the map give key Name for get map values like 
         // map['India'] = its return all dependent picklist values.
         var ListOfDependentFields = Map[controllerValueKey];
         
         var requestTypeLead = {'dependentFieldId': 'objSubStatus', 'fieldstatus': 'isDependentDisableLeadSubStatus' };         
         helper.fetchDepValues(component, ListOfDependentFields, requestTypeLead);
 
      } else {
         var defaultVal = [{
            class: "optionClass",
            label: '--- None ---',
            value: '--- None ---'
         }];
         component.find('objSubStatus').set("v.options", defaultVal);
         component.set("v.isDependentDisableLeadSubStatus", true);
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
    
        var inp = component.get('v.LeadObject.Episys_User_ID__c');
        if(inp > 9999)
        {
        	 component.set('v.LeadObject.Episys_User_ID__c',9999);
        }
    },
   
   
})