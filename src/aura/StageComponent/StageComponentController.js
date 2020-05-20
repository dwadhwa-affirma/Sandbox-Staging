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
                var EFT =[];
                EFT = result.EFT;
                if(EFT != undefined){
                    component.set("v.EFTRecord", EFT);
                }
               
				Stages.sort(helper.Sort);
				component.set("v.ActiveStepIndex", (0));
                component.set("v.EFTStageDetails", Stages);
                component.set("v.MemberAccount", result.MemberAccount);
                var EFTRecordStage  =  component.get("v.EFTRecord[0].Stage__c");
                var modalBody;
                for(var i=0;i<Stages.length;i++){
                    
                    if(EFTRecordStage != undefined && Stages[i].Stage_Label__c == EFTRecordStage){
                        var ActiveStage= document.getElementById(Stages[i].StepId__c);                        
                       // component.set("v.ActiveStepIndex", (i));
                       // if(ActiveStage != undefined){
                            $A.createComponent("c:"+Stages[i].Stage_Component__c,{recordId: component.get("v.recordId")},
                            function(msgBox){                
                                 if (component.isValid()) {                                    
                                     var targetCmp = component.find('ModalDialogPlaceholder');
                                    var body = targetCmp.get("v.body");
                                    body.push(msgBox);
                                    targetCmp.set("v.body", body); 
               
                                }
                            }
		       			 );
                           return;  
                        //}   
                      
                        
                    }
                     else if(EFTRecordStage == undefined){
                        
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
                         return;
                        }
                    
                }
            }            
        	
            
        	
        });	
       $A.enqueueAction(action);
	},
    
    cancelAction: function(component, event, helper) {
       	component.set("v.isExit", true);
    	$A.get("e.force:closeQuickAction").fire();
	},
    
    Continue: function (component, event, helper) {
       debugger;
       
       var stages = [];
       stages = component.get("v.EFTStageDetails"); 
        for(var i=0; i<stages.length;i++){
            var ProgressBarStepClass = document.getElementById('Step'+(i+1)).classList;   
            if((ProgressBarStepClass[0] == undefined || ProgressBarStepClass[0] == 'half')){
                document.getElementById('Step'+(i+1)).classList.remove('half');
                document.getElementById('Step'+(i+1)).classList.add('active');
                document.getElementById('Step'+(i+2)).classList.add('half');
                
           		//component.find("ModalDialogPlaceholder").destroy();
               /* if(i==0){
                   var AccountId = component.get("v.MemberAccount.Id");
                   component.set("v.EFTRecord.Action_Type__c", 'Create');
                   component.set("v.EFTRecord.Stage__c", 'Share/Loan');
                   component.set("v.EFTRecord.Member_Account__c", AccountId);
                   helper.SaveStageValues(component, event, component.get("v.EFTRecord")); 
                }
                if(i==0){
                	 var stages2 = [];
                	 stages2 = component.get("v.EFTStageDetails"); 
                	stages2[0].Stage_Action__c = component.get("v.Action");
                	//component.set("v.EFTStageDetails", stages2);
                }*/
                  $A.createComponent("c:"+stages[i+1].Stage_Component__c,{recordId: component.get("v.recordId")},
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
                 
            	break;
                
            }
            else{
                
                if(i == 0){
                   // alert('Please Select Action');
                }
            }
        }  
        
        
       	
       
        
    },
    
    
     back: function (component, event, helper) {
       debugger;
       var stages = [];
       stages = component.get("v.EFTStageDetails"); 
        for(var i=0; i<stages.length;i++){
            var ProgressBarStepClass = document.getElementById('Step'+(i+1)).classList;   
            if(ProgressBarStepClass[0] == "half"){
                 
                document.getElementById('Step'+(i)).classList.remove('active');
                document.getElementById('Step'+(i)).classList.add('half');
                document.getElementById('Step'+(i+1)).classList.remove('half');
                
                  $A.createComponent("c:"+stages[i-1].Stage_Component__c,{recordId: component.get("v.recordId")},
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
    
   getActionValue : function(component, event) {
        var action = event.getParam("Action");
        // set the handler attributes based on event data
       if(!component.get("v.isExit")){
               if(action != undefined){
               component.set("v.Action", action);
               component.set("v.isError", false);                   
       		}
           else{
                component.set("v.isError", true); 
             
           }
       }
       
        
        
    }
})