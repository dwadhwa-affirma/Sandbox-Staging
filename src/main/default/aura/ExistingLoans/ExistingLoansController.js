({
	doInit : function(component, event, helper) {			
			helper.fetchPicklistFields(component);
			component.set("v.deletedItems",[]);			
	},
	 saveExistingLoansClick: function(component, event) {		
        var assessmentData = component.get("v.Model");
        var otherExistingLoans = component.get("v.otherExistingLoans");
        var deletedItems = component.get("v.deletedItems");
        var updateEvent = component.getEvent("AssessmentSave");
        updateEvent.setParams({ "objNeedsAssesment": assessmentData});
        updateEvent.setParams({ "SectionName": "ExistingLoans" });
        var index;
        for(index in otherExistingLoans){
        	var existloan = otherExistingLoans[index];
        	if(existloan.End_Date__c == undefined || existloan.End_Date__c == null || existloan.End_Date__c == '')
        	{
        		existloan.End_Date__c = null;
        	}
        }
        
        updateEvent.setParams({ "SubItems": JSON.stringify(otherExistingLoans)});
         updateEvent.setParams({ "deletedItems": deletedItems });
        updateEvent.fire();
        
        component.set("v.deletedItems",[]);
    },
    
    addNewLoanItem: function(component, event) {		
        var otherExistingLoans = component.get("v.otherExistingLoans");
        otherExistingLoans.push({
            'Financial_Institution__c' : ' ',
            'Type_of_Loan__c':'',
            'Balance__c':'',
            'Rate__c' : '',
            'End_Date__c' : ''
        });
        component.set("v.otherExistingLoans",otherExistingLoans);
    },
    
    removeDeletedRow : function(component,event,helper){
       var index = event.getParam("indexVar"); 
       var otherExistingLoans = component.get("v.otherExistingLoans");              
       if(otherExistingLoans[index].Id != undefined && otherExistingLoans[index].Id != null)
       {
    	   var data = component.get("v.deletedItems");
    	   data.push(otherExistingLoans[index].Id);
    	   component.set("v.deletedItems",data);
       }
       
       otherExistingLoans.splice(index, 1);
       component.set("v.otherExistingLoans",otherExistingLoans);
    }    
})