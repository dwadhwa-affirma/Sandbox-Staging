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
           }
           
		});
		 
		$A.enqueueAction(action);
        
    },
    
    ExpireEFT: function(component, event, EFTRecord){
        
        var action = component.get("c.expireEFT");	
       
		var EFTRecord  = component.get("v.EFTRecord");	
        if(EFTRecord.length == 1){
            EFTRecord = EFTRecord.splice(0, 1);
        }
		//EFTRecord.attributes = null;
		action.setParams({
		"EFTRecord": EFTRecord
		});			
		action.setCallback(this, function(resp) {
			var state=resp.getState();			
			if(state === "SUCCESS"){
				var result = resp.getReturnValue();   
                 //component.set("v.ActiveStepIndex", 4);
                 component.set("v.EFTRecord.Expired__c", true);
                 var stages2 = [];
		       	stages2 = component.get("v.EFTStageDetails");
                 stages2[4].Stage_Action__c = 'Pending Verification'; 
                component.set("v.EFTStageDetails", stages2);
                 var stages = [];
       		  stages = component.get("v.EFTStageDetails");
                $A.createComponent("c:"+stages[4].Stage_Component__c,{recordId: component.get("v.recordId"), EFTRecord: component.get("v.EFTRecord")},
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
           
		});
		 
		$A.enqueueAction(action);
        
    }
    
    
})