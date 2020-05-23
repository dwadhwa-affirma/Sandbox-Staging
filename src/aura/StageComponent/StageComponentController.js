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
                /*if(EFT != undefined){
                    component.set("v.EFTRecord", EFT);
                }*/
               
				Stages.sort(helper.Sort);
				component.set("v.ActiveStepIndex", (0));
                component.set("v.EFTStageDetails", Stages);
                component.set("v.MemberAccount", result.MemberAccount);
                component.set("v.EFTRecord.Member_Account__c", result.MemberAccount.Id);
                var EFTRecordStage  =  component.get("v.EFTRecord[0].Stage__c");
                var modalBody;
                for(var i=0;i<Stages.length;i++){
                    
                    if(EFTRecordStage != undefined && Stages[i].Stage_Label__c == EFTRecordStage){
                        var ActiveStage= document.getElementById(Stages[i].StepId__c);                        
                       // component.set("v.ActiveStepIndex", (i));
                       // if(ActiveStage != undefined){
                        if(i != 3){
                            $A.createComponent("c:"+Stages[i].Stage_Component__c,{recordId: component.get("v.recordId")},
                            function(msgBox){                
                                 if (component.isValid()) {                                    
                                     var targetCmp = component.find('ModalDialogPlaceholder');
                                    var body = targetCmp.get("v.body");
                                    body.push(msgBox);
                                    targetCmp.set("v.body", body); 
               
                                }
                            }
                                              );}
                        if(i==3){
                            
                            $A.createComponent("c:"+stages[i].Stage_Component__c,{recordId: component.get("v.recordId"), ShareLoanType: component.get("v.SelectedShareLoan")},
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
                           return;  
                        //}   
                      
                        
                    }
                     else if(EFTRecordStage == undefined){
                        
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
       helper.showSpinner(component);
       var stages = [];
       stages = component.get("v.EFTStageDetails"); 
        for(var i=0; i<stages.length;i++){
            var ProgressBarStepClass = document.getElementById('Step'+(i+1)).classList;   
            if((ProgressBarStepClass[0] == undefined || ProgressBarStepClass[0] == 'half')){
                if(i !=4){
                     document.getElementById('Step'+(i+1)).classList.remove('half');
                document.getElementById('Step'+(i+1)).classList.add('active');
                document.getElementById('Step'+(i+2)).classList.add('half');
                }
                else{
                    document.getElementById('Step'+(i+1)).classList.remove('half');
                document.getElementById('Step'+(i+1)).classList.add('active');
                }
                
           		//component.find("ModalDialogPlaceholder").destroy();
              //  if(i==0){
                  // var AccountId = component.get("v.MemberAccount.Id");
                  // component.set("v.EFTRecord.Action_Type__c", 'Create');
                   //component.set("v.EFTRecord.Stage__c", 'Share/Loan');
                   //component.set("v.EFTRecord.Member_Account__c", AccountId);
                   helper.SaveStageValues(component, event, component.get("v.EFTRecord"), i, stages); 
               // }
               /* else if(i==1){
                   //var SelectedShareLoan = component.get("v.SelectedShareLoan");
                   //component.set("v.EFTRecord.Share_Loan_Id__c", SelectedShareLoan.split(',')[0]);
                   //component.set("v.EFTRecord.Share_Loan_Type__c", 'Share/Loan');
                   //component.set("v.EFTRecord.Share_Loan_Description__c", AccountId);
                   helper.SaveStageValues(component, event, component.get("v.EFTRecord")); 
                }
                else if(i==2){
                   //var SelectedShareLoan = component.get("v.SelectedShareLoan");
                   component.set("v.EFTRecord.Bank_Name__c", component.get("v.RoutingBankName"));
                   component.set("v.EFTRecord.Routing_Number__c", component.get("v.RoutingNumber"));
                    component.set("v.EFTRecord.Account_Number__c", component.get("v.AccountNumber"));
                    component.set("v.EFTRecord.Type__c	", component.get("v.Type"));
                   
                   helper.SaveStageValues(component, event, component.get("v.EFTRecord")); 
                }
                
                else if(i==3){
                   //var SelectedShareLoan = component.get("v.SelectedShareLoan");
                   component.set("v.EFTRecord.Payment_Amount__c", component.get("v.PaymentAmt"));
                   component.set("v.EFTRecord.Alternate_Amount__c", component.get("v.AlternateAmt"));
                    component.set("v.EFTRecord.Effective_Date__c", component.get("v.EffectiveDate"));
                    component.set("v.EFTRecord.Frequency__c	", component.get("v.Frequency"));
                   component.set("v.EFTRecord.Day_of_Month__c	", component.get("v.MonthDay"));
                   helper.SaveStageValues(component, event, component.get("v.EFTRecord")); 
                }*/
                /*if(i==0){
                	 var stages2 = [];
                	 stages2 = component.get("v.EFTStageDetails"); 
                	stages2[0].Stage_Action__c = component.get("v.Action");
                	//component.set("v.EFTStageDetails", stages2);
                }*/
                
           /* if(i == 2 ){
                $A.createComponent("c:"+stages[i+1].Stage_Component__c,{recordId: component.get("v.recordId"), ShareLoanType: component.get("v.SelectedShareLoan")},
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
            }*/
                 
            	break;
                
            }
            else{
                
                if(i == 0){
                   // alert('Please Select Action');
                }
            }
        }  
       // helper.hideSpinner(component,helper);
        
       	
       
        
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
               // if(i !=4){
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
              //  }
             /*   if(i == 4){
                    $A.createComponent("c:"+stages[i-1].Stage_Component__c,{recordId: component.get("v.recordId"), ShareLoanType: component.get("v.SelectedShareLoan")},
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
                } */
            
            	return;
                
            }
        }   
       
        
    },
    
   getActionValue : function(component, event) {
	   var EFT = event.getParam("EFTRecord");
	   component.set("v.EFTRecord", EFT);
       /* var action = event.getParam("Action");
         var SelectedShareLoan = event.getParam("SelectedShareLoan");
       
       	var RoutingNumber = event.getParam("RoutingNumber");
        var RoutingBankName = event.getParam("RoutingBankName");
        var AccountNumber = event.getParam("AccountNumber");
        var Type = event.getParam('Type');
       
       
		var PaymentAmt = event.getParam("PaymentAmt");
        var AlternateAmt = event.getParam("AlternateAmt");
        var EffectiveDate = event.getParam("EffectiveDate");
        var Frequency = event.getParam('Frequency');       
       	var MonthDay = event.getParam('MonthDay');
       
       
        // set the handler attributes based on event data
        if(SelectedShareLoan != '' && SelectedShareLoan != null && SelectedShareLoan != undefined){
        	 component.set("v.SelectedShareLoan", SelectedShareLoan);
        	 //alert(SelectedShareLoan);
        }
       
       if(Type != '' && Type != null && Type != undefined){
        	 component.set("v.RoutingNumber", RoutingNumber);
        	 component.set("v.RoutingBankName", RoutingBankName);
           component.set("v.AccountNumber", AccountNumber);
           component.set("v.Type", Type);
        }
       
       if(MonthDay != '' && MonthDay != null && MonthDay != undefined){
        	 component.set("v.PaymentAmt", PaymentAmt);
        	 component.set("v.AlternateAmt", AlternateAmt);
           component.set("v.EffectiveDate", EffectiveDate);
            component.set("v.Frequency", Frequency);
           component.set("v.MonthDay", MonthDay);
        }
       
       
       if(!component.get("v.isExit")){
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