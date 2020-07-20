({
	doInit : function(component, event, helper) {			
			helper.fetchPicklistFields(component);	
			
	},
	removeLoanItemRow : function(component, event, helper){		
		   $A.get("e.c:DeleteotherEvt").
		   setParams({ "indexVar" : component.get("v.rowIndex")}).fire();		       
	}, 	
	
})