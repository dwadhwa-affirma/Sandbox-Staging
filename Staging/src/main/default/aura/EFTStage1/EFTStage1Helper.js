({
	Sort : function(a, b) {
		if ( a.TypeTranslate__c < b.TypeTranslate__c ){
   		 return -1;
 		 }
      if ( a.TypeTranslate__c > b.TypeTranslate__c ){
        return 1;
      }
      return 0;
    },
})