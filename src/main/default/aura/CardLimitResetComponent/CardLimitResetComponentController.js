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
                var CLRecordStage  =  component.get("v.CLRecord[0].Stage__c");
                var modalBody;
                
                if(result.MemberAccount != undefined){
                    
                	component.set("v.MemberAccount", result.MemberAccount);
                	component.set("v.CLRecord.Member_Account__c", result.MemberAccount.Id);
                }    
                if(result.Member != undefined){
                    component.set("v.Member", result.Member);
                	component.set("v.CLRecord.Member_Name__c", result.Member.Name);
                }
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
        var sobjecttype = component.get("v.sobjecttype");
        stages = component.get("v.ChangeLimitStageDetails"); 
        
        if(sobjecttype != 'Account'){
            
            if(component.get("v.ContinueButtonName") == 'Submit' && component.get("v.CLRecord.Type__c") == 'Change Card Limits'){
                
                var recordId = component.get("v.recordId");
                var cardnumber = component.get("v.CLRecord.Card_Number__c");
                var cardlocator = component.get("v.CLRecord.Card_Locator__c");
                var membername = component.get("v.CLRecord.Member_Name__c");
                var authlimit = component.get("v.CLRecord.Auth_POS_Limit__c");
                var atmlimit = component.get("v.CLRecord.ATM_Usage_Limit__c");
                var type = component.get("v.CLRecord.Type__c");   
				var action = component.get("c.Submit");
                action.setParams({
                	"recordId": recordId,
                    "cardnumber": cardnumber,
                    "cardlocator": cardlocator,
                    "membername":membername,
                    "type": type,
                    "authlimit": authlimit,
                    "atmlimit": atmlimit
                    
                    
                });
                action.setCallback(this, function (response) {
           		debugger;
        		var status = response.getState();            
            		if (component.isValid() && status === "SUCCESS") {
                    	component.set("v.isExit", true);
    					$A.get("e.force:closeQuickAction").fire();
                    }
                });	
       			$A.enqueueAction(action); 
                
                helper.hideSpinner(component);
            }
            else if(component.get("v.ContinueButtonName") == 'Submit' && component.get("v.CLRecord.Type__c") != 'Change Card Limits'){
                
                var recordId = component.get("v.recordId");
                var cardnumber = component.get("v.CLRecord.Card_Number__c");
                var cardlocator = component.get("v.CLRecord.Card_Locator__c");
                var membername = component.get("v.CLRecord.Member_Name__c");
                var authlimit = component.get("v.CLRecord.Auth_POS_Limit__c");
                var atmlimit = component.get("v.CLRecord.ATM_Usage_Limit__c");
                var type = component.get("v.CLRecord.Type__c");   
				var action = component.get("c.Submit");
                action.setParams({
                	"recordId": recordId,
                    "cardnumber": cardnumber,
                    "cardlocator": cardlocator,
                    "membername":membername,
                    "type": type,
                    "authlimit": authlimit,
                    "atmlimit": atmlimit
                    
                    
                });
                action.setCallback(this, function (response) {
           		debugger;
        		var status = response.getState();            
            		if (component.isValid() && status === "SUCCESS") {
                    	component.set("v.isExit", true);
    					$A.get("e.force:closeQuickAction").fire();
                    }
                });	
       			$A.enqueueAction(action); 
                
                helper.hideSpinner(component);
                
            }                
            else{
                
                for(var i=0; i<stages.length;i++){
                    
                    var ProgressBarStepClass = document.getElementById('Step'+(i+1)).classList;
                     
                     if((ProgressBarStepClass[0] == undefined || ProgressBarStepClass[0] == 'half')){
                         
                         var stages2 = [];
                         stages2 = component.get("v.ChangeLimitStageDetails");
                         var dynamicText;
                         
                         if(i==0 && (component.get("v.CLRecord.Member_Name__c") == '' || component.get("v.CLRecord.Member_Name__c") == undefined)){
                            alert('Please Select Member');	
                            helper.hideSpinner(component,helper);
                            return;            
                         }
                         else if(i==0 && (component.get("v.CLRecord.Member_Name__c") != '' && component.get("v.CLRecord.Member_Name__c") != undefined)){
                            
                            component.set("v.ActiveStepIndex", (i+1)); 
                            dynamicText = component.get("v.CLRecord.Member_Name__c");     
                            stages2[i].Stage_Action__c = dynamicText;
                            component.set("v.ChangeLimitStageDetails", stages2);
                            component.set("v.isMemberSelected", true);
                             
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
                         else if(i==1 && (component.get("v.CLRecord.Card_Number__c") != '' && component.get("v.CLRecord.Card_Number__c") != undefined)){
                            
                            component.set("v.ActiveStepIndex", (i+1));
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
                      
                        if(i==2 && (component.get("v.CLRecord.Type__c") == '' || component.get("v.CLRecord.Type__c") == undefined)){
                            alert('Please Select Request Type');	
                            helper.hideSpinner(component,helper);
                            return;            
                        }
                        if(i==2 && component.get("v.CLRecord.Type__c") == 'Change Card Limits' && component.get("v.CLRecord.ATM_Usage_Limit__c") == undefined
                                            && component.get("v.CLRecord.Auth_POS_Limit__c") == undefined){
                            
                            dynamicText = component.get("v.CLRecord.Type__c");
                            stages2[1].Stage_Action__c = component.get("v.CLRecord.Card_Number__c");
                            stages2[0].Stage_Action__c = component.get("v.CLRecord.Member_Name__c");
                            stages2[i].Stage_Action__c = dynamicText;
                            component.set("v.ChangeLimitStageDetails", stages2);
                            $A.createComponent("c:"+stages[2].Stage_Component__c,{recordId: component.get("v.recordId"), CLRecord: component.get("v.CLRecord")},
                                function(msgBox){           
                                    if (component.isValid()) {
                                        var targetCmp = component.find('ModalDialogPlaceholder');
                                        var body = targetCmp.get("v.body");
                                        body.splice(0, 1, msgBox);
                                        targetCmp.set("v.body", body); 
                                    }
                                    helper.hideSpinner(component);	
                                }
                                );
                                break;
                            
                        }
                        else if(i==2 && (component.get("v.CLRecord.Type__c") != 'Change Card Limits')){
                            
                            component.set("v.ActiveStepIndex", (i+1));
                            dynamicText = component.get("v.CLRecord.Type__c");   
                            stages2[1].Stage_Action__c = component.get("v.CLRecord.Card_Number__c");
                            stages2[0].Stage_Action__c = component.get("v.CLRecord.Member_Name__c");
                            stages2[i].Stage_Action__c = dynamicText;
                            component.set("v.ChangeLimitStageDetails", stages2);
                            component.set("v.CLRecord.ATM_Usage_Limit__c", '510.00');
                            component.set("v.CLRecord.Auth_POS_Limit__c", '2500.00');
                            
                            $A.createComponent("c:"+stages[i+1].Stage_Component__c,{recordId: component.get("v.recordId"), CLRecord: component.get("v.CLRecord")},
                                function(msgBox){           
                                    if (component.isValid()) {
                                        var targetCmp = component.find('ModalDialogPlaceholder');
                                        var body = targetCmp.get("v.body");
                                        body.splice(0, 1, msgBox);
                                        targetCmp.set("v.body", body); 
                                    }
                                    helper.hideSpinner(component);	
                                }
                                );
                            component.set("v.ContinueButtonName", 'Submit');
                            break;
                        }
                        if(i==3 && component.get("v.CLRecord.Type__c") == 'Change Card Limits' && component.get("v.CLRecord.ATM_Usage_Limit__c") != undefined
                                            && component.get("v.CLRecord.Auth_POS_Limit__c") != undefined){
                           
                            component.set("v.ActiveStepIndex", (i));
                            dynamicText = component.get("v.CLRecord.Type__c");
                            stages2[1].Stage_Action__c = component.get("v.CLRecord.Card_Number__c");
                            stages2[0].Stage_Action__c = component.get("v.CLRecord.Member_Name__c");
                            stages2[2].Stage_Action__c = dynamicText;
                            stages2[3].Stage_Action__c = 'Confirmation';
                            component.set("v.ChangeLimitStageDetails", stages2);
                            $A.createComponent("c:"+stages[3].Stage_Component__c,{recordId: component.get("v.recordId"), CLRecord: component.get("v.CLRecord")},
                                function(msgBox){           
                                    if (component.isValid()) {
                                        var targetCmp = component.find('ModalDialogPlaceholder');
                                        var body = targetCmp.get("v.body");
                                        body.splice(0, 1, msgBox);
                                        targetCmp.set("v.body", body); 
                                    }
                                    helper.hideSpinner(component);	
                                }
                                );
                            component.set("v.ContinueButtonName", 'Submit');
                            break;
                        }
                     }
                } 
            }
    	}
        
        if(sobjecttype == 'Account'){
            
            for(var i=0; i<stages.length;i++){
                
                var ProgressBarStepClass = document.getElementById('Step'+(i+2)).classList;
                 
                 if((ProgressBarStepClass[0] == undefined || ProgressBarStepClass[0] == 'half')){
                     
                     var stages2 = [];
                     stages2 = component.get("v.ChangeLimitStageDetails");
                     var dynamicText;
                     
                     if(i==0 && (component.get("v.CLRecord.Card_Number__c") == '' || component.get("v.CLRecord.Card_Number__c") == undefined)){
                        alert('Please Select Card Number');	
                        helper.hideSpinner(component,helper);
                        return;            
                      }
                     else if(i==0 && (component.get("v.CLRecord.Card_Number__c") != '' && component.get("v.CLRecord.Card_Number__c") != undefined)){
                        
                        component.set("v.ActiveStepIndex", (i+1)); 
                        dynamicText = component.get("v.CLRecord.Card_Number__c");   
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
                    if(i==1 && (component.get("v.CLRecord.Type__c") == '' || component.get("v.CLRecord.Type__c") == undefined)){
                        alert('Please Select Request Type');	
                        helper.hideSpinner(component,helper);
                        return;            
                    }
                    else if(i==1 && (component.get("v.CLRecord.Type__c") == 'Change Card Limits')){
                       
                        dynamicText = component.get("v.CLRecord.Type__c");
                        stages2[0].Stage_Action__c = component.get("v.CLRecord.Card_Number__c");
                        stages2[i].Stage_Action__c = dynamicText;
                        component.set("v.ChangeLimitStageDetails", stages2);
                        
                        $A.createComponent("c:"+stages[1].Stage_Component__c,{recordId: component.get("v.recordId"), CLRecord: component.get("v.CLRecord")},
                            function(msgBox){           
                                if (component.isValid()) {
                                    var targetCmp = component.find('ModalDialogPlaceholder');
                                    var body = targetCmp.get("v.body");
                                    body.splice(0, 1, msgBox);
                                    targetCmp.set("v.body", body); 
                                }
                                helper.hideSpinner(component);	
                            }
                            );
                        break;
                    }
                    else if(i==1 && (component.get("v.CLRecord.Type__c") != 'Change Card Limits')){
                        
                        component.set("v.ActiveStepIndex", (i+1));
                        dynamicText = component.get("v.CLRecord.Type__c");   
                        stages2[0].Stage_Action__c = component.get("v.CLRecord.Card_Number__c");
                        stages2[i].Stage_Action__c = dynamicText;
                        component.set("v.ChangeLimitStageDetails", stages2);
                        
                        $A.createComponent("c:"+stages[i+1].Stage_Component__c,{recordId: component.get("v.recordId"), CLRecord: component.get("v.CLRecord")},
                            function(msgBox){           
                                if (component.isValid()) {
                                    var targetCmp = component.find('ModalDialogPlaceholder');
                                    var body = targetCmp.get("v.body");
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
        }
        
     },
    
    
    back: function (component, event, helper) {      
      
       var stages = [];
       var sobjecttype = component.get("v.sobjecttype");
       stages = component.get("v.ChangeLimitStageDetails"); 
       /*if(component.get("v.isMemberSelected") == true && component.get("v.ActiveStepIndex") == 0){
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
       }*/
       
		for(var i=0; i<stages.length;i++){
            var ProgressBarStepClass = document.getElementById('Step'+(i+1)).classList;   
            if(ProgressBarStepClass[0] == "half"){
                var stages2 = [];
                stages2 = component.get("v.ChangeLimitStageDetails");
               
                if(i==2 && (component.get("v.CLRecord.Type__c") == 'Change Card Limits')){
                        component.set("v.CLRecord.Type__c",'');
                    
                    	$A.createComponent("c:"+stages[2].Stage_Component__c,{recordId: component.get("v.recordId"), CLRecord: component.get("v.CLRecord")},
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
                else{    
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
        }
              
    },
    
    getActionValue : function(component, event) {
	  
      var CL = event.getParam("CLRecord");
	  component.set("v.CLRecord", CL);
        
    },
    
    backView:function (component, event, helper) {  
    	
    
    }
})