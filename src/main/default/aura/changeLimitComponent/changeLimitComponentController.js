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
                Stages=result.CLStages;
                var CLRecord =[];
                CLRecord = result.CLRecord;
                helper.showSpinner(component);
				Stages.sort(helper.Sort);
				component.set("v.ActiveStepIndex", (0));
                component.set("v.ChangeLimitStageDetails", Stages);
                component.set("v.MemberAccount", result.MemberAccount);
                component.set("v.CLRecord.Member_Account__c", result.MemberAccount.Id);
                var CLRecordStage  =  component.get("v.CLRecord[0].Stage__c");
                var modalBody;
                
                $A.createComponent("c:"+Stages[0].Stage_Component__c,{recordId: component.get("v.recordId"),CLRecord: component.get("v.CLRecord")},
                            function(msgBox){                
                                 if (component.isValid()) {                                    
                                     var targetCmp = component.find('ModalDialogPlaceholder');
                                    var body = targetCmp.get("v.body");
                                    body.push(msgBox);
                                    targetCmp.set("v.body", body); 
               							
                                }
                                helper.hideSpinner(component);
                            }
		       			 ); 
                
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
        helper.showSpinner(component);
        var stages = [];
        stages = component.get("v.ChangeLimitStageDetails"); 
        if(component.get("v.isMemberSelected") == false && component.get("v.ActiveStepIndex") == 0){
        	if(component.get("v.CLRecord.Member_Name__c") =="" || component.get("v.CLRecord.Member_Name__c") ==undefined){
    		   alert('Please Select Member');	
            		helper.hideSpinner(component,helper);
            		return;   
    	   }
           component.set("v.isMemberSelected", true); 
        }
        for(var i=0; i<stages.length;i++){
       		 var ProgressBarStepClass = document.getElementById('Step'+(i+1)).classList;
             if((ProgressBarStepClass[0] == undefined || ProgressBarStepClass[0] == 'half')){
             	 component.set("v.ActiveStepIndex", (i+1));
                 var stages2 = [];
                 stages2 = component.get("v.ChangeLimitStageDetails");
                 var dynamicText;
                 
                 if(i==0){
                    dynamicText = component.get("v.CLRecord.Member_Name__c");     
                    stages2[i].Stage_Action__c = dynamicText;
                 	component.set("v.ChangeLimitStageDetails", stages2);
                 
                    $A.createComponent("c:"+stages[i+1].Stage_Component__c,{recordId: component.get("v.recordId"), CLRecord: component.get("v.CLRecord")},
                        function(msgBox){           
                            if (component.isValid()) {
                                var targetCmp = component.find('ModalDialogPlaceholder');
                                var body = targetCmp.get("v.body");
                                //body.push(msgBox);
                                body.splice(0, 1, msgBox);
                                targetCmp.set("v.body", body); 
                           }
                           helper.hideSpinner(component);	
                        }
                     );
                     break;
                 }
                 if(i==1 && (component.get("v.CLRecord.Card_Number__c") == '' || component.get("v.CLRecord.Card_Number__c") == undefined)){
            		alert('Please Select Card Number');	
            		helper.hideSpinner(component,helper);
            		return;            
                  }
                 else{
                 	
                    dynamicText = component.get("v.CLRecord.Card_Number__c");   
                    stages2[0].Stage_Action__c = component.get("v.CLRecord.Member_Name__c");
                    stages2[i].Stage_Action__c = dynamicText;
                 	component.set("v.ChangeLimitStageDetails", stages2);
                 
                    $A.createComponent("c:"+stages[i+1].Stage_Component__c,{recordId: component.get("v.recordId"), CLRecord: component.get("v.CLRecord")},
                        function(msgBox){           
                            if (component.isValid()) {
                                var targetCmp = component.find('ModalDialogPlaceholder');
                                var body = targetCmp.get("v.body");
                                //body.push(msgBox);
                                body.splice(0, 1, msgBox);
                                targetCmp.set("v.body", body); 
                           }
                           helper.hideSpinner(component);	
                        }
                     );
                 break;	     
                 }
                
             }
            
        }    
     },
    
    
    back: function (component, event, helper) {      
      
       var stages = [];
       stages = component.get("v.ChangeLimitStageDetails"); 
       if(component.get("v.isMemberSelected") == true && component.get("v.ActiveStepIndex") == 0){
    	   component.set("v.isMemberSelected", false);
    	   
    	   $A.createComponent("c:"+stages[0].Stage_Component__c,{recordId: component.get("v.recordId"), CLRecord: component.get("v.CLRecord"), isMemberSelected: component.get("v.isMemberSelected")},
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
           //helper.hideSpinner(component);
           return;          
       }
       
		for(var i=0; i<stages.length;i++){
            var ProgressBarStepClass = document.getElementById('Step'+(i+1)).classList;   
            if(ProgressBarStepClass[0] == "half"){
                component.set("v.ActiveStepIndex", (i-1)); 
             	
                $A.createComponent("c:"+stages[i-1].Stage_Component__c,{recordId: component.get("v.recordId"), CLRecord: component.get("v.CLRecord")},
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
	  
      var CL = event.getParam("CLRecord");
	  component.set("v.CLRecord", CL);
        
    },
    
    backView:function (component, event, helper) {  
    	
    
    },
    
    
    ExpireEFT: function (component, event, helper) { 
     
    
    },
    
    backACH: function (component, event, helper) { 
     
    },
    
    submitACH: function (component, event, helper) { 
          
    },
    
    OpenInPersonSigning : function (component, event, helper) {
             
    },

    backSigninPerson  : function (component, event, helper) {
     
    }
})