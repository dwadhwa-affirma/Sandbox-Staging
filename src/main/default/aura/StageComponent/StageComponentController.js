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

                if(result.ErrorMessage != '' && result.ErrorMessage != undefined){
                    component.set('v.isErrorStage1', true);
                    component.set('v.ErrorMessage', result.ErrorMessage);	
                }
                else{
                    component.set('v.isErrorStage1', false);	
                }

                var modalBody;
                $A.createComponent("c:"+Stages[0].Stage_Component__c,{recordId: component.get("v.recordId"),EFTRecord: component.get("v.EFTRecord"), isError: component.get("v.isErrorStage1"),ErrorMessage: component.get("v.ErrorMessage"), },
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
            	if(i==2){
                    var isExistingEFT = component.get("v.isExistingEFT");                    
                    var EFTCount = component.get("v.EFTCount");
                    var CurrentEFT = component.get("v.CurrentEFT");
                    var EFTRecordsList = component.get("v.EFTRecordsList");

                    if(isExistingEFT && CurrentEFT < EFTCount){
                        CurrentEFT = CurrentEFT + 1;
                        component.set("v.CurrentEFT",CurrentEFT);
                    }

                    if(isExistingEFT && component.get("v.isExpireEFT") == undefined){
                        alert('Please Select one of the choices to either Proceed/Expire EFT Record.');	
            		    helper.hideSpinner(component,helper);
            		    return; 
                    }


                    if(!isExistingEFT || EFTCount <= 0){
                        if(((component.get("v.EFTRecord.Routing_Number__c") == '' || component.get("v.EFTRecord.Routing_Number__c") == undefined)
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
                    alert('The following fields are blank. Please complete all fields to continue: \n' +emptystring);
                    helper.hideSpinner(component,helper);
                    return;
            		// if (!confirm('The following fields are blank, are you sure you wish to continue? \n' + emptystring)) {
            		// 		helper.hideSpinner(component,helper);
            		// 		return;            				
            		// 	}  
                    }
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
                       if(!(component.get("v.isExistingEFT"))){
		            		dynamicText = component.get("v.EFTRecord.Bank_Name__c"); 
		                 	component.set("v.ContinueButtonName", 'Send ACH Document');                       
                            component.set("v.isSigninPersonEnabled", true);
                        }
                        else{
                            dynamicText ='Waiting';
                        }
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
                    if(component.get("v.EFTRecord.Action_Type__c") != "Expire" && component.get("v.isDocusignEmailSelected") == false){
                    		$A.createComponent("c:"+stages[4].Stage_Component__c,{recordId: component.get("v.recordId"), EFTRecord: component.get("v.EFTRecord"), isDocusignEmailSelected : false },
                                function(msgBox){                
                                     if (component.isValid()) {
                                        
                                         var targetCmp = component.find('ModalDialogPlaceholder');
                                        var body = targetCmp.get("v.body");
                                        //body.push(msgBox);
                                        body.splice(0, 1, msgBox);
                                        targetCmp.set("v.body", body); 
                                        helper.hideSpinner(component);
                                    }
                                }
                                    );
                    }
                    else{
                        helper.SaveStageValues(component, event, component.get("v.EFTRecord"), i, stages);
                        helper.hideSpinner(component);
                    }
                    
                }
		            	 
		             else{
                        var isExistingEFT = component.get("v.isExistingEFT");                    
                        var EFTCount = component.get("v.EFTCount");
                        var CurrentEFT = component.get("v.CurrentEFT");
                        var EFTRecordsList = component.get("v.EFTRecordsList");
                        

                         if(i==1 && component.get("v.EFTRecord.Action_Type__c") == "View"){
                             component.set("v.ActiveStepIndex", 5);
                             stages2[4].Stage_Action__c = 'Existing'; 
                            // console.log();
                             stages2[3].Stage_Action__c = new Intl.NumberFormat('en-US', { style: 'currency', currency: 'USD' }).format(component.get("v.EFTRecord.Payment_Amount__c"));
                             stages2[2].Stage_Action__c = component.get("v.EFTRecord.Bank_Name__c");
                             $A.createComponent("c:"+stages[4].Stage_Component__c,{recordId: component.get("v.recordId"), EFTRecord: component.get("v.EFTRecord"), isDocusignEmailSelected : true },
                                function(msgBox){                
                                     if (component.isValid()) {
                                        
                                         var targetCmp = component.find('ModalDialogPlaceholder');
                                        var body = targetCmp.get("v.body");
                                        //body.push(msgBox);
                                        body.splice(0, 1, msgBox);
                                        targetCmp.set("v.body", body); 
                                        helper.hideSpinner(component);
                                    }
                                }
                                    ); 
                         }
                         else if(i==1 && component.get("v.EFTRecord.Action_Type__c") == "Expire"){
                             component.set("v.ActiveStepIndex", 4);
                             stages2[4].Stage_Action__c = 'Existing'; 
                             stages2[3].Stage_Action__c = new Intl.NumberFormat('en-US', { style: 'currency', currency: 'USD' }).format(component.get("v.EFTRecord.Payment_Amount__c"));
                             stages2[2].Stage_Action__c = component.get("v.EFTRecord.Bank_Name__c");
                             $A.createComponent("c:"+stages[4].Stage_Component__c,{recordId: component.get("v.recordId"), EFTRecord: component.get("v.EFTRecord"), isDocusignEmailSelected : true },
                                function(msgBox){                
                                     if (component.isValid()) {
                                        
                                         var targetCmp = component.find('ModalDialogPlaceholder');
                                        var body = targetCmp.get("v.body");
                                        //body.push(msgBox);
                                        body.splice(0, 1, msgBox);
                                        targetCmp.set("v.body", body); 
                                        helper.hideSpinner(component);
                   						
                                    }
                                }
                                    ); 
                         }
                         else if(i==2 && component.get("v.isExistingEFT") == true && CurrentEFT <= EFTCount){
                                component.set("v.ActiveStepIndex", 2);
                                var isExpireEFT = component.get("v.isExpireEFT");
                                
                                if(isExpireEFT){
                                    var CurrentEFTRecord = component.get("v.CurrentEFTRecord");
                                    helper.ExpireExistingEFT(component, event, CurrentEFTRecord);
                                }                               
                                $A.createComponent("c:"+stages[2].Stage_Component__c,{recordId: component.get("v.recordId"), EFTRecord: component.get("v.EFTRecord"), isExistingEFT : isExistingEFT, EFTCount:  EFTCount, CurrentEFT: CurrentEFT, EFTRecordsList: EFTRecordsList},
                                function(msgBox){                
                                    if (component.isValid()) {
                                        
                                        var targetCmp = component.find('ModalDialogPlaceholder');
                                        var body = targetCmp.get("v.body");
                                        //body.push(msgBox);
                                        body.splice(0, 1, msgBox);
                                        targetCmp.set("v.body", body); 
                                        helper.hideSpinner(component);
                                        
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
                                        helper.hideSpinner(component);
                                    }
                                }
                                    );
                             
                         }
		            	
            
		             
		             }
		             //helper.hideSpinner(component);
		             break;   
               
			}
            		
            	
            	             
            }
           
          
        //helper.hideSpinner(component,helper);
     },
    
    
     back: function (component, event, helper) {      
       var stages = [];
       stages = component.get("v.EFTStageDetails"); 
       if(component.get("v.isMemberSelected") == true && component.get("v.ActiveStepIndex") == 0){
    	   component.set("v.isMemberSelected", false);
    	   //component.set("v.EFTRecord.Member_Name__c","");
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
                     component.set("v.isSigninPersonEnabled", false);
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
       
       var isDocusignEmailSelected = event.getParam("isDocusignEmailSelected");
       if(isDocusignEmailSelected != undefined)
       component.set("v.issubmitDisabled", !isDocusignEmailSelected);

       var isExistingEFT = event.getParam("isExistingEFT");
       if(isExistingEFT != undefined)
       component.set("v.isExistingEFT", isExistingEFT);

       var EFTCount = event.getParam("EFTCount");
       if(EFTCount != undefined)
       component.set("v.EFTCount", EFTCount);

       var CurrentEFT = event.getParam("CurrentEFT");
       if(CurrentEFT != undefined)
       component.set("v.CurrentEFT", CurrentEFT);

       var EFTRecordsList = event.getParam("EFTRecordsList");
       if(EFTRecordsList != undefined)
       component.set("v.EFTRecordsList", EFTRecordsList);

       var isExpireEFT = event.getParam("isExpireEFT");
       //if(isExpireEFT != undefined)
       component.set("v.isExpireEFT", isExpireEFT);

       var CurrentEFTRecord = event.getParam("CurrentEFTRecord");
       if(CurrentEFTRecord != undefined)
       component.set("v.CurrentEFTRecord", CurrentEFTRecord);      
        
    },
    
    backView:function (component, event, helper) {  
    		component.set("v.ActiveStepIndex", (0)); 
        	var MemberName= component.get("v.EFTRecord.Member_Name__c");
            var Member=component.get("v.EFTRecord.Member_Account__c");
            component.set("v.isSigninPersonEnabled", false);
        component.set("v.EFTRecord",{ 'sobjectType': 'EFT__c' , 'Member_Name__c' : MemberName , 'Member_Account__c' : Member });		        
              var stages = [];
       		  stages = component.get("v.EFTStageDetails");
        		var stages2 = [];
		       stages2 = component.get("v.EFTStageDetails");
        	  stages2[4].Stage_Action__c = 'Waiting';
        		stages2[3].Stage_Action__c = 'Waiting';
        		stages2[2].Stage_Action__c = 'Waiting';
        		stages2[1].Stage_Action__c = 'Waiting';
        		component.set("v.EFTStageDetails", stages2);
        $A.createComponent("c:"+stages[0].Stage_Component__c,{recordId: component.get("v.recordId"), EFTRecord: component.get("v.EFTRecord"), isMemberSelected: true},
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
    
    },
    
    backACH: function (component, event, helper) { 
        var stages = [];
        stages = component.get("v.EFTStageDetails");
        component.set("v.ActiveStepIndex",3);
        component.set("v.ContinueButtonName", 'Send ACH Document');
         $A.createComponent("c:"+stages[3].Stage_Component__c,{recordId: component.get("v.recordId"), EFTRecord: component.get("v.EFTRecord")},
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
    
    submitACH: function (component, event, helper) { 
        var stages = [];
        stages = component.get("v.EFTStageDetails");
        component.set("v.ActiveStepIndex",5);        
        helper.SaveStageValues(component, event, component.get("v.EFTRecord"), 3, stages);
    
    },
    
    OpenInPersonSigning : function (component, event, helper) {
        var stages = [];
        stages = component.get("v.EFTStageDetails");
        component.set("v.ActiveStepIndex",5);       
        helper.SaveStageValuesSignInPeron(component, event, component.get("v.EFTRecord"), 3, stages);             
    },

    backSigninPerson  : function (component, event, helper) {
        var header = document.getElementsByClassName('slds-media_center cStageComponent');
        var footer = document.getElementsByClassName('slds-modal__footer cStageComponent');
        if(header != undefined){
            header[0].style='';
        }

        if(footer != undefined){
            footer[0].style='';
        }
        var modalbody = document.getElementsByClassName('modalbody cStageComponent');
        if(modalbody != undefined){
            modalbody[0].style='max-height:411px';
        }
        component.set("v.isSigninPersonClicked",false)
        var stages = [];
        stages = component.get("v.EFTStageDetails");
        component.set("v.ActiveStepIndex",3);
        component.set("v.ContinueButtonName", 'Send ACH Document');
         $A.createComponent("c:"+stages[3].Stage_Component__c,{recordId: component.get("v.recordId"), EFTRecord: component.get("v.EFTRecord")},
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
})