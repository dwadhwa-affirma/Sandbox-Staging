({
	doInit : function(component, event, helper) {
		
		var recordid = component.get("v.recordId");
		var sObj = component.get("v.sObjectName");
		
    var actionGetState = component.get("c.GetStatus");
		actionGetState.setParams({"ObjectName" : sObj,"recid" : recordid});
		
		
		actionGetState.setCallback(this, function (response) {  
			 var status = response.getState(); 
			  if (status === "SUCCESS" && response.getReturnValue() == 'true') {
				  	
				  	$A.util.removeClass( component.find("popup"), "slds-hide");
				  	
				  	var action = component.get("c.GetQueueName");
					action.setParams({"ObjectName" : sObj});					
					action.setCallback(this, function (response) {  
					  var status = response.getState();            
				       	    if (component.isValid() && status === "SUCCESS") {
				               var result = response.getReturnValue();  
				                var opts = [];
				            
				            opts.push({
								class: "optionClass",
								label: "--- None ---",
								value: ""
				            });
						
				            for(var i=0; i <  result.length; i++){
				            	var obj = result[i];
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
					  }
			  else{
				    var toastEvent = $A.get("e.force:showToast");                	        
                	 toastEvent.setParams({		            
	                	message : 'Change ownership is not allowed for closed '+response.getReturnValue(),	                        
				        duration:' 10000',
				        key: 'error_alt',
				        type: 'error',
				        mode: 'error'
	                });
				    toastEvent.fire();
                	$A.get('e.force:closeQuickAction').fire();
                	return;
			  }
		
		});
		$A.enqueueAction(actionGetState);
		
		
	},
	
	 selectOwnerChange : function(component, event, helper){
		var sObj = component.get("v.sObjectName");
		
    	var selectedVal= event.getSource().get("v.value");
    	var user = document.getElementById("ddluser1");
    	var queue = document.getElementById("ddlqueue1");
    	var keep = document.getElementById("ddlkeep1");
    	component.set("v.opportunity.User_Owner__c",null);
    	component.set("v.opportunity.Queue_Assigned_Id__c",null);
    	component.set("v.opportunity.Ownership__c",selectedVal);
    	
    	/*if(sObj =='Opportunity')
    	{
    		component.set("v.opportunity.User_Owner__c",null);
    		component.set("v.opportunity.Queue_Assigned_Id__c",null);
    		component.set("v.opportunity.Ownership__c",selectedVal);
        }
        else
        {
        	//component.set("v.lead.Queue_Assigned_Id__c",null);
          //  component.set("v.lead.Ownership__c",selectedVal);
            
            var obj = component.get('v.lead');
            obj.Ownership__c = value;
           // obj.Queue_Assigned_Id__c = null;
                        
            
        } */ 
    	if(selectedVal == "User"){
    		user.style = '';
    		queue.style = 'display:none;';
    		keep.style = 'display:none;';
    	}
    	else if(selectedVal == "Queue"){
    		queue.style = '';
    		user.style = 'display:none;';
    		keep.style = 'display:none;';
    		
    	    }
    	    
    	else
    	{
    		queue.style = 'display:none;';
    		user.style = 'display:none;';
    		keep.style = '';
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
    ChangeOwner : function(component, event, helper){
    	 
    	  var recid = component.get("v.recordId");
    	  var sObj = component.get("v.sObjectName");
    	 component.set("v.opportunity.id",recid);
    	 var objOpp = component.get("v.opportunity");
    	 var objLead = component.get("v.Lead");
    	 var isValid = helper.handleError(component,event,helper);
    	 var objname = component.get("v.sObjectName");
    	if(isValid)
    	{
			    	 var action = component.get("c.OpportunityChangeOwner");
			    	  
			    	  action.setParams({
			    		  				"opportunityObject" : objOpp,
			    		  				"recid" : recid
			    		  				
			    	  					});
			    	  action.setCallback(this, function (response) { 
			    		    
			    	  var status = response.getState();
			    			      
			    	 if(status === "SUCCESS"){
			    			   
					       	    	 var toastEvent = $A.get("e.force:showToast");
					        
					       	    	toastEvent.setParams({		            
						            message : 'Owner Assigned Successfully',	                        
						            duration:' 3000',
						            key: 'info_alt',
						            type: 'success',
						            mode: 'pester'
						        	});
					       	    	toastEvent.fire();  
					       	    	
					       	    	 var navEvt = $A.get("e.force:navigateToSObject");
					       	    	 navEvt.setParams({
					       	    		 "recordId": recid
				        	
					       	    	 });
					       	    	 $A.get('e.force:refreshView').fire();
					       	    	 $A.get('e.force:closeQuickAction').fire();
					       	    	 //navEvt.fire();           
				               
			    			}
			    		else{
			    			if(objname == 'Lead')
			    			{
				    			component.set("v.popoverMessage", "Owner can not be changed for Closed Leads");   
				    			var popover = component.find("popover");
				    			$A.util.removeClass(popover,'slds-hide');
			    			}
			    		
				    		if(objname == 'Opportunity')
				    		{
				    			component.set("v.popoverMessage", "Owner can not be changed for Closed Opportunity");   
				    			var popover = component.find("popover");
				    			$A.util.removeClass(popover,'slds-hide');
			    			}
			    		}
						 
					  });
	    		      $A.enqueueAction(action);
    	 }
    
    },
    closePopup: function(component, event, helper) {
	  $A.get('e.force:closeQuickAction').fire();
   }
   /* ChangeOwner : function(component, event, helper){
    	 var objOpp = component.get("v.opportunity");
    	 // var isValid = helper.handleError(component,event,helper);
    	//  if(isValid)
	   // 	{
    	 	 var objOpp = component.get("v.opportunity");
    		  var action = component.get("c.OpportunityChangeOwner");
    		   action.setParams({
	    	"opportunityObject" : objOpp
	    });
    		   action.setCallback(this, function (response) {  
    			   var status = response.getState();            
    			   if (component.isValid() && status === "SUCCESS") {
		       	    	var toastEvent = $A.get("e.force:showToast");
		        
		       	    	toastEvent.setParams({		            
			            message : 'Owner Assigned Successfully',	                        
			            duration:' 3000',
			            key: 'info_alt',
			            type: 'success',
			            mode: 'pester'
			        	});
		        toastEvent.fire();	               
	               
			 }
			 
			  component.set("v.loading", false);
	        
	        var navEvt = $A.get("e.force:navigateToSObject");
	        navEvt.setParams({
	        	"recordId": component.get("v.recordId");
	        	
	        });
	        navEvt.fire();  
			 
		  });
    		   $A.enqueueAction(action);
    		  
	    //	}
    
    }*/
	
})