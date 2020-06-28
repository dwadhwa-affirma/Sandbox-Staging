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
       if(component.get("v.isMemberSelected") == false && component.get("v.ActiveStepIndex") == 0){
    	   if(component.get("v.EFTRecord.Member_Name__c") =="" || component.get("v.EFTRecord.Member_Name__c") ==undefined){
    		   alert('Please Select Member');	
            		helper.hideSpinner(component,helper);
            		return;   
    	   }
    	   component.set("v.isMemberSelected", true);
    	    $A.createComponent("c:"+stages[0].Stage_Component__c,{recordId: component.get("v.recordId"), EFTRecord: component.get("v.EFTRecord"), isMemberSelected: component.get("v.isMemberSelected")},
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
            helper.hideSpinner(component);
            return;          
       }
      for(var i=0; i<stages.length;i++){
            var ProgressBarStepClass = document.getElementById('Step'+(i+1)).classList;   
            if((ProgressBarStepClass[0] == undefined || ProgressBarStepClass[0] == 'half')){
            	if(i==0 && (component.get("v.EFTRecord.Action_Type__c") == '' || component.get("v.EFTRecord.Action_Type__c") == undefined)){
            		alert('Please Select Action');	
            		helper.hideSpinner(component,helper);
            		return;            
            	}
            	
            	if(i==1 && component.get("v.EFTRecord.Action_Type__c") == 'Create' && (component.get("v.EFTRecord.Share_Loan_Id__c") == '' || component.get("v.EFTRecord.Share_Loan_Id__c") == undefined)){
            		alert('Please Select a Loan/Share');	
            		helper.hideSpinner(component,helper);
            		return;            
            	}
            	
            	else if(i==1 && component.get("v.EFTRecord.Action_Type__c") != 'Create' && (component.get("v.EFTRecord.Share_Loan_Id__c") == '' || component.get("v.EFTRecord.Share_Loan_Id__c") == undefined)){
            		alert('Please Select an EFT');	
            		helper.hideSpinner(component,helper);
            		return;
            	}
            	
            	if(i==2 && ((component.get("v.EFTRecord.Routing_Number__c") == '' || component.get("v.EFTRecord.Routing_Number__c") == undefined)
            			|| (component.get("v.EFTRecord.Bank_Name__c") == '' || component.get("v.EFTRecord.Bank_Name__c") == undefined)
            			|| (component.get("v.EFTRecord.Account_Number__c") == '' || component.get("v.EFTRecord.Account_Number__c") == undefined)
            			|| (component.get("v.EFTRecord.Type__c") == '' || component.get("v.EFTRecord.Type__c") == undefined)
            	)){
            		var emptystring ="";
            		if((component.get("v.EFTRecord.Routing_Number__c") == '' || component.get("v.EFTRecord.Routing_Number__c") == undefined)){
            			emptystring = emptystring + "ABA/Routing#" + "\n";
            		}
            		if((component.get("v.EFTRecord.Bank_Name__c") == '' || component.get("v.EFTRecord.Bank_Name__c") == undefined)){
            			emptystring = emptystring + "Bank Name" + "\n";
            		}
            		if((component.get("v.EFTRecord.Account_Number__c") == '' || component.get("v.EFTRecord.Account_Number__c") == undefined)){
            			emptystring = emptystring + "Account#" + "\n";
            		}
            		if((component.get("v.EFTRecord.Type__c") == '' || component.get("v.EFTRecord.Type__c") == undefined)){
            			emptystring = emptystring + "Type";
            		}
            		if (!confirm('The following fields are blank, are you sure you wish to continue? \n' + emptystring)) {
            				helper.hideSpinner(component,helper);
            				return;            				
            			}            	
            	}
            	if(i==3 && ((component.get("v.EFTRecord.Payment_Amount__c") == '' || component.get("v.EFTRecord.Payment_Amount__c") == undefined)
            			|| (component.get("v.EFTRecord.Day_of_Month__c") == '' || component.get("v.EFTRecord.Day_of_Month__c") == undefined)
            			|| (component.get("v.EFTRecord.Effective_Date__c") == '' || component.get("v.EFTRecord.Effective_Date__c") == undefined)
            			|| (component.get("v.EFTRecord.Frequency__c") == '' || component.get("v.EFTRecord.Frequency__c") == undefined)
            	)){
            		alert('Following fields are mandatory. Please check: \n Payment Amount \n Effective Date \n Frequency \n Day of Month');	
            		helper.hideSpinner(component,helper);
            		return;           	
            	}
            	   component.set("v.ActiveStepIndex", (i+1));
            	   var stages2 = [];
		           stages2 = component.get("v.EFTStageDetails");
		           var dynamicText;
		           if(i==0){
                        if(component.get("v.EFTRecord.Action_Type__c") == "Expire"){
                        dynamicText = "Update";
                    	}
                       else{
                           dynamicText = component.get("v.EFTRecord.Action_Type__c");
                       }		        	   		                	
		             }
		           else if(i==1){
		            		dynamicText = component.get("v.EFTRecord.Share_Loan_Id__c"); 
                       		
		                }
		           else if(i==2){
		            		dynamicText = component.get("v.EFTRecord.Bank_Name__c"); 
		                 	component.set("v.ContinueButtonName", 'Send ACH Document');
		                }
		           else if(i==3){
		        	   		if(component.get("v.EFTRecord.Alternate_Amount__c") == "" || component.get("v.EFTRecord.Alternate_Amount__c") == null || component.get("v.EFTRecord.Alternate_Amount__c") == undefined)
		        	   			dynamicText = new Intl.NumberFormat('en-US', { style: 'currency', currency: 'USD' }).format(component.get("v.EFTRecord.Payment_Amount__c")); 
		            		else
		            			dynamicText = new Intl.NumberFormat('en-US', { style: 'currency', currency: 'USD' }).format(component.get("v.EFTRecord.Alternate_Amount__c"));
		            		stages2[i+1].Stage_Action__c = 'Pending Verification';               	
		                }
		             if(i !=2 && component.get("v.ContinueButtonName") == 'Send ACH Document'){
		            	 component.set("v.ContinueButtonName", 'Continue');
		             }
		             stages2[i].Stage_Action__c = dynamicText;
		             component.set("v.EFTStageDetails", stages2);
		             
		             
                if(i==3){
                    if(component.get("v.EFTRecord.Action_Type__c") == "Expire"){
                        component.set("v.EFTRecord.Action_Type__c","Update")
                    }
                    helper.SaveStageValues(component, event, component.get("v.EFTRecord"), i, stages);
                }
		            	 
		             else{
                         if(i==1 && component.get("v.EFTRecord.Action_Type__c") == "View"){
                             component.set("v.ActiveStepIndex", 5);
                             stages2[4].Stage_Action__c = 'Existing'; 
                            // console.log();
                             stages2[3].Stage_Action__c = new Intl.NumberFormat('en-US', { style: 'currency', currency: 'USD' }).format(component.get("v.EFTRecord.Payment_Amount__c"));
                             stages2[2].Stage_Action__c = component.get("v.EFTRecord.Bank_Name__c");
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
                         else if(i==1 && component.get("v.EFTRecord.Action_Type__c") == "Expire"){
                             component.set("v.ActiveStepIndex", 4);
                             stages2[4].Stage_Action__c = 'Existing'; 
                             stages2[3].Stage_Action__c = new Intl.NumberFormat('en-US', { style: 'currency', currency: 'USD' }).format(component.get("v.EFTRecord.Payment_Amount__c"));
                             stages2[2].Stage_Action__c = component.get("v.EFTRecord.Bank_Name__c");
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
       if(component.get("v.isMemberSelected") == true && component.get("v.ActiveStepIndex") == 0){
    	   component.set("v.isMemberSelected", false);
    	   component.set("v.EFTRecord.Member_Name__c","");
    	    $A.createComponent("c:"+stages[0].Stage_Component__c,{recordId: component.get("v.recordId"), EFTRecord: component.get("v.EFTRecord"), isMemberSelected: component.get("v.isMemberSelected")},
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
       if(component.get("v.ActiveStepIndex") == 1){
    	   component.set("v.isMemberSelected", true);
    	   component.set("v.ActiveStepIndex",0);
    	   component.set("v.EFTRecord.Action_Type__c","");
    	    $A.createComponent("c:"+stages[0].Stage_Component__c,{recordId: component.get("v.recordId"), EFTRecord: component.get("v.EFTRecord"), isMemberSelected: component.get("v.isMemberSelected")},
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
             	 if(i !=2 && component.get("v.ContinueButtonName") == 'Send ACH Document'){
		            	 component.set("v.ContinueButtonName", 'Continue');
		             }
		         if(i==1){
		        	 component.set("v.EFTRecord.Action_Type__c","");	
		         }
		         if(i == 2){
		        	 component.set("v.EFTRecord.Share_Loan_Id__c","");		        	 
			         component.set("v.EFTRecord.Share_Loan_Type__c","");
			         component.set("v.EFTRecord.Share_Loan_Description__c","");
			         component.set("v.EFTRecord.EFT_ID_Type__c","");
			         component.set("v.EFTRecord.Payment_Amount__c","");
			         component.set("v.EFTRecord.Effective_Date__c","");
			         component.set("v.EFTRecord.Day_of_Month__c","");
			         component.set("v.EFTRecord.Second_Day_of_Month__c","");
			        // component.set("v.EFTRecord.Stage__c",'Share/Loan');
		         }
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
       
        
        
    },
    
    backView:function (component, event, helper) {  
    		component.set("v.ActiveStepIndex", (1)); 
    		 component.set("v.EFTRecord.Share_Loan_Id__c","");		        
              var stages = [];
       		  stages = component.get("v.EFTStageDetails");
        		var stages2 = [];
		       stages2 = component.get("v.EFTStageDetails");
        	  stages2[4].Stage_Action__c = 'Waiting';
        		stages2[3].Stage_Action__c = 'Waiting';
        		stages2[2].Stage_Action__c = 'Waiting';
        		stages2[1].Stage_Action__c = 'Waiting';
        		component.set("v.EFTStageDetails", stages2);
                    $A.createComponent("c:"+stages[1].Stage_Component__c,{recordId: component.get("v.recordId"), EFTRecord: component.get("v.EFTRecord")},
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
    
    },
    
    
    ExpireEFT: function (component, event, helper) { 
         if(component.get("v.EFTRecord.Action_Type__c") == "Expire"){
                        component.set("v.EFTRecord.Action_Type__c","Update")
                    }
    	helper.ExpireEFT(component, event, component.get("v.EFTRecord"));
    
    }
})