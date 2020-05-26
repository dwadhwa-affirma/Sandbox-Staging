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
               
				Stages.sort(helper.Sort);
				component.set("v.ActiveStepIndex", (0));
                component.set("v.EFTStageDetails", Stages);
                component.set("v.MemberAccount", result.MemberAccount);
                component.set("v.EFTRecord.Member_Account__c", result.MemberAccount.Id);
                var EFTRecordStage  =  component.get("v.EFTRecord[0].Stage__c");
                var modalBody;
                $A.createComponent("c:"+Stages[0].Stage_Component__c,{recordId: component.get("v.recordId"),EFTRecord: component.get("v.EFTRecord")},
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
       	component.set("v.isExit", true);
    	$A.get("e.force:closeQuickAction").fire();
	},
    
    Continue: function (component, event, helper) {
       debugger;
       helper.showSpinner(component);
       var stages = [];
       stages = component.get("v.EFTStageDetails"); 
      for(var i=0; i<stages.length;i++){
            var ProgressBarStepClass = document.getElementById('Step'+(i+1)).classList;   
            if((ProgressBarStepClass[0] == undefined || ProgressBarStepClass[0] == 'half')){
            	if(i==0 && (component.get("v.EFTRecord.Action_Type__c") == '' || component.get("v.EFTRecord.Action_Type__c") == undefined)){
            		alert('Please Select Action');	
            		helper.hideSpinner(component,helper);
            		return;            
            	}
            	   component.set("v.ActiveStepIndex", (i+1));
            	   var stages2 = [];
		           stages2 = component.get("v.EFTStageDetails");
		           var dynamicText;
		           if(i==0){
		        	   		dynamicText = component.get("v.EFTRecord.Action_Type__c");                	
		                }
		           else if(i==1){
		            		dynamicText = component.get("v.EFTRecord.Share_Loan_Id__c");                	
		                }
		           else if(i==2){
		            		dynamicText = component.get("v.EFTRecord.Bank_Name__c"); 
		                 	component.set("v.ContinueButtonName", 'Send ACH Document');
		                }
		           else if(i==3){
		            		dynamicText = component.get("v.EFTRecord.Payment_Amount__c"); 
		            		stages2[i+1].Stage_Action__c = 'Pending Verification';               	
		                }
		             if(i !=2 && component.get("v.ContinueButtonName") == 'Send ACH Document'){
		            	 component.set("v.ContinueButtonName", 'Continue');
		             }
		             stages2[i].Stage_Action__c = dynamicText;
		             component.set("v.EFTStageDetails", stages2);
		             
		             
		             if(i==3)
		            	 helper.SaveStageValues(component, event, component.get("v.EFTRecord"), i, stages);
		             else{		            
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
		             helper.hideSpinner(component);
		             break;   
               
			}
            		
            	
            	             
            }
           
          
       // helper.hideSpinner(component,helper);
     },
    
    
     back: function (component, event, helper) {      
       var stages = [];
       stages = component.get("v.EFTStageDetails"); 
        for(var i=0; i<stages.length;i++){
            var ProgressBarStepClass = document.getElementById('Step'+(i+1)).classList;   
            if(ProgressBarStepClass[0] == "half"){
                component.set("v.ActiveStepIndex", (i-1)); 
             
                    $A.createComponent("c:"+stages[i-1].Stage_Component__c,{recordId: component.get("v.recordId"), EFTRecord: component.get("v.EFTRecord")},
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
	   var EFT = event.getParam("EFTRecord");
	   component.set("v.EFTRecord", EFT);
       
       /*if(!component.get("v.isExit")){
               if(action != undefined){
               component.set("v.Action", action);
               component.set("v.isError", false);                   
       		}
           else{
                component.set("v.isError", true); 
             
           }
       }*/
       
        
        
    }
})