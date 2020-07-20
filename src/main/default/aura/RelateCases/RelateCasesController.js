({
	doInit : function(component, event, helper) {
      
        var action = component.get("c.GetAllCases");
       var recordid = component.get("v.recordId");
        
        action.setParams({"caseid": recordid});
      
        action.setCallback(this, function (response) {
            
                     
            var status = response.getState();
            if (component.isValid() && status === "SUCCESS") {
                debugger;
	               var result = response.getReturnValue(); 
	                if(result.length > 0){
	                	component.set("v.CaseObject", result);
	                	component.set("v.NoCaseFound", false);
	                	
                       
                	}
                	else
                    {
                        component.set("v.NoCaseFound", true);
                    }
                    var array = component.get("v.selectedCheckBoxes");
                    for(var i=0;i<result.length;i++){
                    	if(result[i].isSelected)
                    	array.push(result[i].cases.Id);                    	
                    }
                    component.set("v.selectedCheckBoxes", array);
                    
            }
        });
      $A.enqueueAction(action);
	},
    
      CheckboxSelect : function (component, event) {
         if(event.getSource().get("v.checked"))   { 
           var capturedCheckboxName = event.getSource().get("v.value");
   		  var selectedCheckBoxes =  component.get("v.selectedCheckBoxes");
   		  var removedCheckBoxes =  component.get("v.removedCheckBoxes");
    		if(selectedCheckBoxes.indexOf(capturedCheckboxName) > -1){            
        			selectedCheckBoxes.splice(selectedCheckBoxes.indexOf(capturedCheckboxName), 1);           
    			}
   			else{
      				selectedCheckBoxes.push(capturedCheckboxName);
  			  }
    		component.set("v.selectedCheckBoxes", selectedCheckBoxes);
    		}
    		else
    		{
    			var capturedCheckboxName = event.getSource().get("v.value");
    			var selectedCheckBoxes =  component.get("v.selectedCheckBoxes");
    			  var removedCheckBoxes =  component.get("v.removedCheckBoxes");
    			if(selectedCheckBoxes.indexOf(capturedCheckboxName) > -1){            
        			selectedCheckBoxes.splice(selectedCheckBoxes.indexOf(capturedCheckboxName), 1); 
        			removedCheckBoxes.push(capturedCheckboxName);        
    			}
   			else{
      				selectedCheckBoxes.splice(selectedCheckBoxes.indexOf(capturedCheckboxName), 1);   
  			  }
    		component.set("v.selectedCheckBoxes", selectedCheckBoxes);
    		component.set("v.removedCheckBoxes", removedCheckBoxes);
    		}
   },
    
   linkCases : function (component, event){        
		var action = component.get("c.ButtonSave_Click1");
		var recordid = component.get("v.recordId");
		var Caseids = component.get("v.selectedCheckBoxes");
		var removedcaseids = component.get("v.removedCheckBoxes");
		 action.setParams({"caseid": recordid,
			 				"Caseids" :	Caseids
			 				
		 				});

		 action.setCallback(this, function (response) {           
                     
            var status = response.getState();
            if (component.isValid() && status === "SUCCESS") {
                
	                var toastEvent = $A.get("e.force:showToast");
	             toastEvent.setParams({
	            	title: 'Success!',
	            	message: 'Case saved.',
	            	 duration:'500',
		            key: 'info_alt',
		            type: 'success',
		            mode: 'pester'
	             });
	             	toastEvent.fire();
	             	$A.get('e.force:refreshView').fire();
	             	 $A.get('e.force:closeQuickAction').fire();	             	 	
	             	
            }
        });
       
             
      $A.enqueueAction(action);
     

    },
     closePopup: function(component, event, helper) {
	  $A.get('e.force:closeQuickAction').fire();
   } 
})