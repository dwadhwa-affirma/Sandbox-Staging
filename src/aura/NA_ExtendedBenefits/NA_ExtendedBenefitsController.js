({
	doInit : function(component, event, helper) {
			var assessmentData = component.get("v.Model");
			var currId =  assessmentData.Id;	
			component.set("v.deletedItems",[]);
			//helper.GetExistingLoansData(component, currId);
	},
	 saveExistingLoansClick: function(component, event) {		
        var assessmentData = component.get("v.Model");
        var membershipLoans = component.get("v.membershipLoans");
        var deletedItems = component.get("v.deletedItems");
        var updateEvent = component.getEvent("AssessmentSave");
        updateEvent.setParams({ "objNeedsAssesment": assessmentData});
        updateEvent.setParams({ "SectionName": "Membership" });
        updateEvent.setParams({ "SubItems": JSON.stringify(membershipLoans)});
        updateEvent.setParams({ "deletedItems": deletedItems });
        updateEvent.fire();
        component.set("v.deletedItems",[]);        
    },
    
    addNewLoanItem: function(component, event) {
        var membershipLoans = component.get("v.membershipLoans");
        membershipLoans.push({
            'Name' : ' ',
            'Age__c':'',
            'Want_to_Refer_Membership__c':''
        });
        
        component.set("v.membershipLoans",membershipLoans);
    },
    
    removeDeletedRow : function(component,event,helper){
       var index = event.getParam("indexVar"); 
       var membershipLoans = component.get("v.membershipLoans");
       if(membershipLoans[index].Id != undefined && membershipLoans[index].Id != null)
       {
    	   var data = component.get("v.deletedItems");
    	   data.push(membershipLoans[index].Id);
    	   component.set("v.deletedItems",data);
       }
       
       membershipLoans.splice(index, 1);
       component.set("v.membershipLoans",membershipLoans);
    }    
})