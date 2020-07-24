({
    doInit : function(component, event, helper) {
    debugger;
        var selectedaction=component.get("v.EFTRecord.Action_Type__c");
        var action;
        var recordId = component.get("v.recordId");
        if(selectedaction == 'Create'){
            action = component.get("c.getShareLoanAccounts");        	
        
        	action.setParams({
            recordId: recordId
        });           
        action.setCallback(this, function(resp) {
            var state=resp.getState();           
            if(state === "SUCCESS"){            	
            	var result=[];
            	result = resp.getReturnValue();
            	if(result["Exception"] != undefined){
            		alert('An error occured. Please try again. If the issue persists, contact administrator.');
            	}
            	else{
            		result.ShareLoanList.map((obj) => {   
					obj.UtilityIcon = "utility:add";
					})
            	}
            	
            	component.set('v.ShareLoanMap', result.ShareLoanList);
            	
                //alert('d');
                           
            }
        });	
        }
       else{
            action = component.get("c.getEFTRecordsEpisys");
			action.setParams({
            	recordId: recordId
        	});           
        action.setCallback(this, function(resp) {
            var state=resp.getState();           
            if(state === "SUCCESS"){            	
            	var result=[];
            	result = resp.getReturnValue();
                component.set('v.EFTRecordsList', result);
            	
                           
            }
        });	      
                    
       }
        										
       
        $A.enqueueAction(action);
       
    },
   
    expand : function(component, event, helper) {
       
        var icon = component.get("v.AddIconName");
        var index = event.target.getAttribute('data-row-index');
        var rowId = 'trDesc' + index ;
        var rowEle = document.getElementById(rowId); 
		var btncion = document.getElementsByClassName('icon' + index);
		
		var map = [];
		map = component.get('v.ShareLoanMap');
		if(map[index].UtilityIcon == 'utility:add'){
			map[index].UtilityIcon = 'utility:dash';
			 rowEle.classList.remove('hide');
		}
        else{
        	map[index].UtilityIcon = 'utility:add';
        	rowEle.classList.add('hide');
        }
        component.set('v.ShareLoanMap', map)
        
       // var container = component.find("containerCollapsable") ;
       /* if(icon == 'utility:add'){
           // $A.util.toggleClass(container, 'hide');
            rowEle.classList.remove('hide');
            component.set('v.AddIconName','utility:dash');
        }
        else{
            //$A.util.toggleClass(container, 'hide');
            rowEle.classList.add('hide');
            component.set('v.AddIconName','utility:add');
        }*/
       
    },
    
    onRadioChange : function(component, event, helper) {
    	var evt = $A.get("e.c:EFTEvent");
        var SelectedShareLoan = event.getSource().get('v.value');
        var SelectedShareLoanID, SelectedShareLoanType , SelectedShareLoanDesc, SelectedEFTIDType, SelectedPayment, SelectedED, SelectedDay1, SelectedDay2;
      /*  if(SelectedShareLoan != null && SelectedShareLoan != undefined){
        	SelectedShareLoanID = SelectedShareLoan.split(',')[0];
            SelectedShareLoanType  = SelectedShareLoan.split(',')[2];
       		SelectedShareLoanDesc  = SelectedShareLoan.split(',')[3];
            SelectedEFTIDType  = SelectedShareLoan.split(',')[1];
            SelectedPayment = SelectedShareLoan.split(',')[4];
        }*/
        var map=component.get('v.ShareLoanMap');
        for(var i=0;i<map.length;i++){
        	if(map[i].ShareLoanID==SelectedShareLoan){
        		SelectedShareLoanID = map[i].ShareLoanID;
	            SelectedShareLoanType  = map[i].TypeTranslate;
	       		SelectedShareLoanDesc  = map[i].Description;
	            SelectedEFTIDType  = map[i].Type;
	            SelectedPayment = map[i].Payment;
	            SelectedED = map[i].EffectiveDate;
	            SelectedDay1 = map[i].Day1.toString().trim();
	            SelectedDay2 = map[i].Day2.toString().trim();	            
	            break;
        	}
        }
        
         component.set("v.EFTRecord.Share_Loan_Id__c",SelectedShareLoanID);
         component.set("v.EFTRecord.Share_Loan_Type__c",SelectedShareLoanType);
         component.set("v.EFTRecord.Share_Loan_Description__c",SelectedShareLoanDesc);
         component.set("v.EFTRecord.EFT_ID_Type__c",SelectedEFTIDType);
         component.set("v.EFTRecord.Payment_Amount__c",SelectedPayment);
         component.set("v.EFTRecord.Effective_Date__c",SelectedED);
         component.set("v.EFTRecord.Day_of_Month__c",SelectedDay1);
         component.set("v.EFTRecord.Second_Day_of_Month__c",SelectedDay2);
         component.set("v.EFTRecord.Stage__c",'Share/Loan');
         if(SelectedDay2 != '0'){
	           component.set("v.EFTRecord.Frequency__c",'Semi-Monthly'); 
	     }
         else{
        	 component.set("v.EFTRecord.Frequency__c",'Monthly'); 
         }
		if(SelectedShareLoanID != undefined){
            evt.setParams({ "EFTRecord": component.get("v.EFTRecord")});
            evt.fire();
        }
    },
        
        onEFTSelect: function(component, event, helper) {
            var evt = $A.get("e.c:EFTEvent");
        	var SelectedShareLoan = event.getSource().get('v.value');
            var EFTList=[];
            EFTList = component.get('v.EFTRecordsList');
            
            for(var i=0;i<EFTList.length;i++){
                if(EFTList[i].EftLocator__c==SelectedShareLoan){
                    component.set("v.EFTRecord.Share_Loan_Id__c",EFTList[i].Share_Loan_Id__c);
                    component.set("v.EFTRecord.Member_Account__r",EFTList[i].Member_Account__r);
                    component.set("v.EFTRecord.EFT_ID_Type__c",EFTList[i].EFT_ID_Type__c);
                    component.set("v.EFTRecord.Share_Loan_Description__c",EFTList[i].Share_Loan_Description__c);
                    component.set("v.EFTRecord.Share_Loan_Type__c",EFTList[i].Share_Loan_Type__c);
                    component.set("v.EFTRecord.Account_Number__c",EFTList[i].Account_Number__c);
                    component.set("v.EFTRecord.Bank_Name__c",EFTList[i].Bank_Name__c);
                    component.set("v.EFTRecord.Routing_Number__c",EFTList[i].Routing_Number__c);
                    component.set("v.EFTRecord.Type__c",EFTList[i].Type__c);
                    component.set("v.EFTRecord.Payment_Amount__c",EFTList[i].Payment_Amount__c);
                    component.set("v.EFTRecord.Alternate_Amount__c",EFTList[i].Alternate_Amount__c);
                    component.set("v.EFTRecord.Effective_Date__c",EFTList[i].Effective_Date__c);
                    component.set("v.EFTRecord.Frequency__c",EFTList[i].Frequency__c);
                    component.set("v.EFTRecord.Day_of_Month__c",EFTList[i].Day_of_Month__c);
                    component.set("v.EFTRecord.Second_Day_of_Month__c",EFTList[i].Second_Day_of_Month__c);
                    component.set("v.EFTRecord.EftLocator__c",EFTList[i].EftLocator__c);
                     component.set("v.EFTRecord.Id",EFTList[i].Id);
                    
                    break;
                }
            }
            evt.setParams({ "EFTRecord": component.get("v.EFTRecord")});
            evt.fire();
           
            
        }
})