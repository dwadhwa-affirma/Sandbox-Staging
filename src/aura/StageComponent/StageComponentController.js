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
                Stages=result.EFTStages;
                var EFT = result.EFTRecord;
                if(EFT != undefined){
                    component.set("v.EFTRecord", EFT);
                }
               
				Stages.sort(helper.Sort);
               
                component.set("v.EFTStageDetails", Stages);
                var EFTRecordStage  =  component.get("v.EFTRecord.Stage__c");
                var modalBody;
                for(var i=0;i<Stages.length;i++){
                    
                    if(EFTRecordStage != undefined && Stages[i].Stage_Label__c == EFTRecordStage){
                        var ActiveStage= document.getElementById(Stages[i].StepId__c);                        
                        component.set("v.ActiveStepIndex", (i));
                        if(ActiveStage != undefined){
                            $A.createComponent("c:"+Stages[i].Stage_Component__c,{},
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
                       
                        return;
                    }
                     else{
                         $A.createComponent("c:"+Stages[0].Stage_Component__c,{},
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
                    return;
                }
            }            
        	
            
        	
        });	
       $A.enqueueAction(action);
	},
    
    cancelAction: function(component, event, helper) {
    	$A.get("e.force:closeQuickAction").fire();
	},
    
    Continue: function (component, event, helper) {
       debugger;
        // var event = component.getEvent("lightningEvent");
		//event.setParam("message", "the message to send" );
		//event.fire();
        
        var applicationEvent = $A.get("e.c:EFTEvent");
    applicationEvent.setParams({"message" : "the message to send"});
    applicationEvent.fire();
       var stages = [];
       stages = component.get("v.EFTStageDetails"); 
        for(var i=0; i<stages.length;i++){
            var ProgressBarStepClass = document.getElementById('Step'+(i+1)).classList;   
            if(ProgressBarStepClass[0] == "halFactive"){
                document.getElementById('Step'+(i+1)).classList.remove('halFactive');
                document.getElementById('Step'+(i+1)).classList.add('active');
                document.getElementById('Step'+(i+2)).classList.add('halFactive');
           		//component.find("ModalDialogPlaceholder").destroy();
                  $A.createComponent("c:"+stages[i+1].Stage_Component__c,{},
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
            
            	return;
                
            }
        }  
       	
       
        
    },
    
    
     back: function (component, event, helper) {
       debugger;
       var stages = [];
       stages = component.get("v.EFTStageDetails"); 
        for(var i=0; i<stages.length;i++){
            var ProgressBarStepClass = document.getElementById('Step'+(i+1)).classList;   
            if(ProgressBarStepClass[0] == "halFactive"){
                 
                document.getElementById('Step'+(i)).classList.remove('active');
                document.getElementById('Step'+(i)).classList.add('halFactive');
                document.getElementById('Step'+(i+1)).classList.remove('halFactive');
                
                  $A.createComponent("c:"+stages[i-1].Stage_Component__c,{},
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
            
            	return;
                
            }
        }   
       
        
    },
    
   
    
})