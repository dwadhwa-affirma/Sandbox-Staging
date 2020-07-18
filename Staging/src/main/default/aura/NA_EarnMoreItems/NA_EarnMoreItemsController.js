({
	doInit : function(component, event, helper) {		
			debugger;	
			helper.fetchPicklistFields(component);	
	},
	removeLoanItemRow : function(component, event, helper){		
		   $A.get("e.c:DeleteotherEvt").
		   setParams({ "indexVar" : component.get("v.rowIndex")}).fire();		       
	}, 	
	
})