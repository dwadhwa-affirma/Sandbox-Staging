({
    doInit : function(component, event, helper) {          
        var recordId = component.get("v.recordId");	
		var action = component.get("c.getStageData");	
        var sobjecttype = component.get("v.sobjecttype");
		action.setParams({
		"recordId": recordId,
            "sObjectType": sobjecttype
		});
		action.setCallback(this, function (response) {
            debugger;
        	var status = response.getState();            
            if (component.isValid() && status === "SUCCESS") {
                var result = [];
                result = response.getReturnValue();    	            
               	var Stages = [];
                Stages=result.xPressRefiStages;
                
                component.set("v.xPressRefiStageDetails", Stages);            
               
                $A.createComponent("c:"+Stages[0].Stage_Component__c,{recordId: component.get("v.recordId")},
                            function(msgBox){                
                                 if (component.isValid()) {                                    
                                     var targetCmp = component.find('ModalDialogPlaceholder');
                                    var body = targetCmp.get("v.body");
                                    body.push(msgBox);
                                    targetCmp.set("v.body", body); 
               
                                }
                            }
		       			 );               
            }                   	
        });	
       $A.enqueueAction(action);
	},
    
    cancelAction: function(component, event, helper) {       	
    	$A.get("e.force:closeQuickAction").fire();
	},

    Continue: function (component, event, helper){
        debugger;
        //helper.showSpinner(component);
        var stages = [];
        stages = component.get("v.xPressRefiStageDetails");       
        
        $A.createComponent("c:"+stages[1].Stage_Component__c,{recordId: component.get("v.recordId")},
                                function(msgBox){                
                                    if (component.isValid()) {                                        
                                        var targetCmp = component.find('ModalDialogPlaceholder');
                                        var body = targetCmp.get("v.body");                                        
                                        body.splice(0, 1, msgBox);
                                        targetCmp.set("v.body", body); 
                                       // helper.hideSpinner(component);
                                        
                                    }
                                }
                                    );
           
}

})
