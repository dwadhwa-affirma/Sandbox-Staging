({
	doInit : function(component, event, helper) {	
		component.set("v.selectAll", false);
		 component.set("v.newOpportunity.Ownership__c","User"); 
		helper.fetchOpportunities(component);
        
	},
	
	updateRecords : function(component, event, helper) {		
		helper.updateOpportunities(component);
	},
	
	selectAllchange: function(component, event, helper) {		
		helper.selectAllOpportunities(component);
	},
	
	selectOpportunity: function(component, event, helper) {
		component.set("v.loading", true);		
		var currentId =  event.target.getAttribute('data-row-index');
		if(currentId != undefined && currentId != null && currentId != '')
		{
			var navEvt = $A.get("e.force:navigateToSObject");
	        navEvt.setParams({
	        	"recordId": currentId,
	        	"slideDevName": "related"
	        });
	        navEvt.fire(); 
		}
		component.set("v.loading", false);
	},
	 selectOwnerChange : function(component, event, helper){
	
    	var selectedVal= event.getSource().get("v.value");
    	var user = document.getElementById("ddluser2");
    	var queue = document.getElementById("ddlqueue2");
    	component.set("v.newOpportunity.User_Owner__c",null);
    	component.set("v.newOpportunity.Queue_Assigned_Id__c",null);
    	component.set("v.newOpportunity.Ownership__c",selectedVal); 	
    	if(selectedVal == "User"){
    		user.style = '';
    		queue.style = 'display:none;';
    		
    	}
    	else if(selectedVal == "Queue"){
    		queue.style = '';
    		user.style = 'display:none;';
    		var action = component.get("c.GetQueueName");
							
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
									value: obj.Name,
									label: obj.Name						
								});					
							}
							component.find("queuename").set("v.options", opts);
				               
				               
						 }
						 
					  });
					 	$A.enqueueAction(action);
    		
    		
    		
    	    }
    	
    	
    		
    }
})