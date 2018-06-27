({
	doInit : function(component, event, helper) {
			var assessmentData = component.get("v.Model");
			var currId =  assessmentData.Id;	
			component.set("v.deletedItems",[]);
			helper.fetchPicklistFields(component);		
			//helper.GetDepositData(component, currId);
	},
	 saveExistingLoansClick: function(component, event) {		
        var assessmentData = component.get("v.Model");
        var deposits = component.get("v.deposits");
        var deletedItems = component.get("v.deletedItems");
        var updateEvent = component.getEvent("AssessmentSave");
        updateEvent.setParams({ "objNeedsAssesment": assessmentData});
        updateEvent.setParams({ "SectionName": "EarnMore" });
        updateEvent.setParams({ "SubItems": JSON.stringify(deposits)});
        updateEvent.setParams({ "deletedItems": deletedItems });
        updateEvent.fire();
        
        component.set("v.deletedItems",[]);
    },
    
    addNewLoanItem: function(component, event) {
        var deposits = component.get("v.deposits");
        
        if(deposits.length < 5)
        {
	        deposits.push({
	            'Balance__c' : ' ',
	            'Financial_Instituition__c':'',
	            'Rate__c':'',
	            'Type__c':''  
	        });
        }  
        component.set("v.deposits",deposits);
    },
    
    removeDeletedRow : function(component,event,helper){
       var index = event.getParam("indexVar"); 
       var deposits = component.get("v.deposits");  
       
       if(deposits[index].Id != undefined && deposits[index].Id != null)
       {
    	   var data = component.get("v.deletedItems");
    	   data.push(deposits[index].Id);
    	   component.set("v.deletedItems",data);
       }
       
       deposits.splice(index, 1);
       component.set("v.deposits",deposits);
    }    
})