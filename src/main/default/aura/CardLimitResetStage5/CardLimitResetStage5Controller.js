({
	doInit : function(component, event, helper) {
	    
      	helper.showSpinner(component);       
		var recordId = component.get("v.recordId");
		var CLRecord = component.get("v.CLRecord");
        var CLRecordID = CLRecord.Id;
        var CLCase = CLRecord.Case__r.CaseNumber;
    }   
  
})