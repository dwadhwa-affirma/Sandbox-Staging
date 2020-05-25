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
    
    SaveStageValues: function(component, event, EFTRecord, i, stages){
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
				var result = resp.getReturnValue();   
				component.set('v.EFTRecord', result);
                
                if(i !=4){
                    $A.createComponent("c:"+stages[i+1].Stage_Component__c,{recordId: component.get("v.recordId"), EFTRecord: component.get("v.EFTRecord")},
                                function(msgBox){                
                                     if (component.isValid()) {
                                        
                                         var targetCmp = component.find('ModalDialogPlaceholder');
                                        var body = targetCmp.get("v.body");
                                        //body.push(msgBox);
                                        body.splice(0, 1, msgBox);
                                        targetCmp.set("v.body", body); 
                   						
                                    }
                                }
                                    );
            }
           var stages2 = [];
           stages2 = component.get("v.EFTStageDetails");
           var dynamicText;
           if(i==0){
        	   		dynamicText = component.get("v.EFTRecord.Action_Type__c");                	
                }
            if(i==1){
            		dynamicText = component.get("v.EFTRecord.Share_Loan_Id__c");                	
                }
             if(i==2){
            		dynamicText = component.get("v.EFTRecord.Bank_Name__c"); 
                 	component.set("v.ContinueButtonName", 'Send ACH Document');
                }
             if(i==3){
            		dynamicText = component.get("v.EFTRecord.Payment_Amount__c"); 
            		stages2[i+1].Stage_Action__c = 'Pending Verification';               	
                }
             stages2[i].Stage_Action__c = dynamicText;
             component.set("v.EFTStageDetails", stages2);
             
               
			}
            this.hideSpinner(component);
		});
		 
		$A.enqueueAction(action);
        
    }	
    
    
})