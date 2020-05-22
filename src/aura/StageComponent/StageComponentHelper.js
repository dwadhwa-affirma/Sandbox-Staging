({
	Sort : function(a, b) {
		if ( a.Order__c < b.Order__c ){
   		 return -1;
 		 }
      if ( a.Order__c > b.Order__c ){
        return 1;
      }
      return 0;
    },
    
    showSpinner: function(component) {
		var spinnerMain =  component.find("Spinner");
		$A.util.removeClass(spinnerMain, "slds-hide");
	},
 
	hideSpinner : function(component) {
		var spinnerMain =  component.find("Spinner");
		$A.util.addClass(spinnerMain, "slds-hide");
	},
    
    SaveStageValues: function(component, event, EFTRecord){
        var action = component.get("c.saveStageData");
		
       
		var EFTRecord  = component.get("v.EFTRecord");	
        if(EFTRecord.length == 1){
            EFTRecord = EFTRecord.splice(0, 1);
        }
		
		action.setParams({
		"EFTRecord": EFTRecord
		});			
		action.setCallback(this, function(resp) {
			var state=resp.getState();			
			if(state === "SUCCESS"){
				
							
			}
		});
		
		$A.enqueueAction(action);
    }	
    
    
})