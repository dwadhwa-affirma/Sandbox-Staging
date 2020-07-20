({
	doInit : function(component, event, helper) {			
			helper.fetchPicklistFields(component);	
	},
	removeLoanItemRow : function(component, event, helper){		
		   $A.get("e.c:DeleteotherEvt").
		   setParams({ "indexVar" : component.get("v.rowIndex")}).fire();		       
	}, 	
	
	changeDate : function(component, event){
    	var data = component.get("v.ExistingLoanItem");
    	
    	if(event.getParams().keyCode == '46' || event.getParams().keyCode == '8')
    	{
    		data.End_Date__c = '';    		
    	} 
    	  	
    	component.set("v.ExistingLoanItem", data);
    }
	
})