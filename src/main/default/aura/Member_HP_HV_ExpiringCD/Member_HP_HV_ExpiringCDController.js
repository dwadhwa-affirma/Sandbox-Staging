({
	doInit : function(component, event, helper) {
		debugger;
		var RecordId = component.get("v.recordId");
		var pageNumber = component.get("v.PageNumber");  
        var pageSize = component.find("pageSize").get("v.value"); 
		helper.GetData(component, event, helper,pageNumber, pageSize);
		
	},

	Searchaccounts: function(component, event, helper) {
		var pageNumber = component.get("v.PageNumber");  
        var pageSize = component.find("pageSize").get("v.value"); 
		helper.GetData(component, event, helper,pageNumber, pageSize);
	},
	
	handleNext: function(component, event, helper) {
        var pageNumber = component.get("v.PageNumber");  
        var pageSize = component.find("pageSize").get("v.value");
        pageNumber++;
        helper.GetData(component,event, helper, pageNumber, pageSize);
    },
     
    handlePrev: function(component, event, helper) {
        var pageNumber = component.get("v.PageNumber");  
        var pageSize = component.find("pageSize").get("v.value");
        pageNumber--;
        helper.GetData(component, event, helper, pageNumber, pageSize);
    },
     
    onSelectChange: function(component, event, helper) {
        var page = 1
        var pageSize = component.find("pageSize").get("v.value");
        helper.GetData(component,event, helper, page, pageSize);
	},
	
})