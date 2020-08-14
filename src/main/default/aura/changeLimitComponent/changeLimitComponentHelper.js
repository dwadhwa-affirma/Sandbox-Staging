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
	}
})