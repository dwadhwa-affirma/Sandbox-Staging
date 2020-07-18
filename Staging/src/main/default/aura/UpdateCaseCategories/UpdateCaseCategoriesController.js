({
	doInit : function(component, event, helper) {
		/*helper.fetchPicklistFields(component);*/
		
	  component.set('v.loading',true);
	   var action = component.get("c.getData");
	   var recordid = component.get("v.recordId");	  
	    var parameters = {"caseId": recordid };
	    
	    var requestPC = {'objName': 'Case', 'contrfieldName': 'Primary_Category__c','depfieldName': 'Secondary_Category__c' };
        var requestSC = {'DependentFieldName': 'depnedentFieldMap', 'fieldId': 'Primary_Category__c' };
        helper.fetchPicklistValues(component, requestPC, requestSC);
        
        var requestStatus = {'objName': 'Case', 'contrfieldName': 'Secondary_Category__c','depfieldName': 'Tertiary_Category__c' };       
        var requestTypeStatus = {'DependentFieldName': 'depnedentFieldMapSecondaryCategory', 'fieldId': 'Secondary_Category__c' }; 
        helper.fetchPicklistValues(component, requestStatus, requestTypeStatus);
	    
		action.setParams(parameters);
		action.setCallback(this, function(response){
		var status = response.getState();
	        	if(component.isValid() && status === "SUCCESS")
	        	{
	        		var result =  response.getReturnValue();  	
	        		component.set('v.caseObject', result.CaseData);	
	        		component.set('v.hasAccess', result.hasAccess);	
	        		var caseobj = component.get('v.caseObject');
			 		caseobj.Primary_Category__c = null;
			 		caseobj.Secondary_Category__c = null;
			 		//caseobj.Tertiary_Category__c = null;
			 		var defaultVal = [{
			            class: "optionClass",
			            label: '--- None ---',
			            value: '--- None ---'
			         }];
			 		component.find('Tertiary_Category__c').set("v.options", defaultVal);
			 		component.set('v.caseObject', caseobj);	
			 		component.set('v.loading',false);	   	
			 		     		
	        	}            	
	       });
	   $A.enqueueAction(action);

       //helper.fetchPicklistFields(component, 'Primary_Category__c');		
            
            
		//var scOptions = [{'Text': '--- None ---','Value': ''}];
 		//component.set('v.scOptions', scOptions);
 		//component.set('v.tcOptions', scOptions);
 		
 		
 		
 		
 		
	},	
	
	changePrimaryCategory: function(component, event, helper) {
	   component.set('v.loading',true);
	   var controllerValueKey = event.getSource().get("v.value");
 
      // get the map values   
      var Map = component.get("v.depnedentFieldMap");
 
      // check if selected value is not equal to None then call the helper function.
      // if controller field value is none then make dependent field value is none and disable field
      if (controllerValueKey != '--- None ---') { 
         
         var ListOfDependentFields = Map[controllerValueKey];           
         var requestTypeProduct  = {'dependentFieldId': 'Secondary_Category__c', 'fieldstatus': 'false' };         
         
                
         helper.fetchDepValues(component, ListOfDependentFields, requestTypeProduct);         
 
      } else {
         var defaultVal = [{
            class: "optionClass",
            label: '--- None ---',
            value: '--- None ---'
         }];
         component.find('Secondary_Category__c').set("v.options", defaultVal);
         
        
      }
      
       component.set('v.loading',false);
	   /*var pcValue = component.get('v.caseObject').Primary_Category__c;
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
       */ 
   },   

   changeSecondaryCategory: function(component, event, helper) {
	   component.set('v.loading',true);
	   var controllerValueKey = event.getSource().get("v.value");
 
      // get the map values   
      var Map = component.get("v.depnedentFieldMapSecondaryCategory");
 
      // check if selected value is not equal to None then call the helper function.
      // if controller field value is none then make dependent field value is none and disable field
      if (controllerValueKey != '--- None ---') { 
         
         var ListOfDependentFields = Map[controllerValueKey];           
         var requestTypeProduct  = {'dependentFieldId': 'Tertiary_Category__c', 'fieldstatus': 'false' };         
         
                
         helper.fetchDepValues(component, ListOfDependentFields, requestTypeProduct);         
 
      } else {
         var defaultVal = [{
            class: "optionClass",
            label: '--- None ---',
            value: '--- None ---'
         }];
         component.find('Tertiary_Category__c').set("v.options", defaultVal);
         
   }
        component.set('v.loading',false);
   }, 

	closePopup: function(component, event, helper) { 
	  $A.get('e.force:closeQuickAction').fire();      
   },
   
   SaveCategories: function(component,event,helper){
	    var btnid = event.getSource().getLocalId();	   
    	var isValid = helper.handleError(component,event,helper);    	
    	if(isValid)
    	{
    		helper.SaveCaseCategories(component,event,helper);
    	}
    },
})