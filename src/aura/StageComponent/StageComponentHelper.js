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
    
    SaveStageValues: function(component, event, EFTRecord){
        var action = component.get("c.saveStageData");
		
		var EFTRecord = component.get("v.EFTRecord");		
		
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