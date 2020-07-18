({
	doInit : function(component, event, helper) {
      
        var action = component.get("c.GetAllAccounts");
       var recordid = component.get("v.recordId");
        
        action.setParams({"caseid": recordid});
      
        action.setCallback(this, function (response) {
            
                     
            var status = response.getState();
            if (component.isValid() && status === "SUCCESS") {
                debugger;
	               var result = response.getReturnValue(); 
	                if(result.length > 0){
	                	component.set("v.AccountList", result);
	                	component.set("v.NoAccountsFound", false);
	                	
                       
                	}
                	else
                    {
                        component.set("v.NoAccountsFound", true);
                    }
                    var array = component.get("v.selectedCheckBoxes");
                    for(var i=0;i<result.length;i++){
                    	if(result[i].isSelected)
                    	array.push(result[i].accountdetails.Id);                    	
                    }
                    component.set("v.selectedCheckBoxes", array);
                    
            }
        });
      $A.enqueueAction(action);
	},
	
	 closePopup: function(component, event, helper) {
	  $A.get('e.force:closeQuickAction').fire();
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
   
   addAccounts : function (component, event){        
		var action = component.get("c.AddAccountsandSave");
		var recordid = component.get("v.recordId");
		var accountids = component.get("v.selectedCheckBoxes");
		if(accountids == null || accountids == ''){
		 alert('Please select at least one Account');
		 return;
		}
		var removedcaseids = component.get("v.removedCheckBoxes");
		 action.setParams({"caseid": recordid,
			 				"accountids" :	accountids
			 				
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
	             	location.reload();
            }
        });
       
             
      $A.enqueueAction(action);
     

    }
   
   
})