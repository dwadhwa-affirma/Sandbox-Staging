({
	editDetails : function(component, event, helper) {
	debugger;
		component.set("v.isEditable", true);
		//helper.getTimeZoneList(component);
		if(component.get("v.travelDetailsInstance.MasterCardSFObj.Destination__c") == "Domestic")		
		helper.getStateList(component);
		else
		helper.getCountryList(component);
	},
	doInit : function(component, event, helper) {
	//component.set("v.loading", true);
		component.set("v.isEditable", false);		
		if(component.get("v.travelDetailsInstance.MasterCardSFObj.Departure_Date__c") == undefined)
		component.set("v.ifSFObjExist", false);
		else
		component.set("v.ifSFObjExist", true);
		//component.set("v.loading", false);
	},
	cancelEdit : function(component, event, helper) {
		component.getEvent("RefreshEvt").setParams({"EventType" : 'Refresh', "ErrorMessage" : '' }).fire();				
		component.set("v.isEditable", false);			  
	},
	updateDetails : function(component, event, helper) {
	component.set("v.loading", true);
		helper.SaveMCDetails(component);		
		
	},
	deleteDetails : function(component, event, helper) {
	var r = confirm("Are you sure you want to delete this trip?");
	if (r == true){
	component.set("v.loading", true);
		helper.DeleteDetail(component);
		}
	else{
		return false;
	}
	}
	
})