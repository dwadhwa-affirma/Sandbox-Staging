({
    doInit : function(component, event, helper) {
    debugger;
        var action = component.get("c.getShareLoanAccounts");
        var recordId = component.get("v.recordId");   
        //var EFTRecord = component.get("v.EFTRecord");       
       
        action.setParams({
            recordId: recordId
        });           
        action.setCallback(this, function(resp) {
            var state=resp.getState();           
            if(state === "SUCCESS"){            	
            	var result=[];
            	result = resp.getReturnValue();
            	result.map((obj) => {   
					obj.UtilityIcon = "utility:add";
					})
            	component.set('v.ShareLoanMap', result);
            	
                //alert('d');
                           
            }
        });
       
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
        var SelectedShareLoanID, SelectedShareLoanType , SelectedShareLoanDesc, SelectedEFTIDType;
        if(SelectedShareLoan != null && SelectedShareLoan != undefined){
        	SelectedShareLoanID = SelectedShareLoan.split(',')[0];
            SelectedShareLoanType  = SelectedShareLoan.split(',')[2];
       		SelectedShareLoanDesc  = SelectedShareLoan.split(',')[3];
            SelectedEFTIDType  = SelectedShareLoan.split(',')[1];
        }
        
        
         component.set("v.EFTRecord.Share_Loan_Id__c",SelectedShareLoanID);
         component.set("v.EFTRecord.Share_Loan_Type__c",SelectedShareLoanType);
         component.set("v.EFTRecord.Share_Loan_Description__c",SelectedShareLoanDesc);
         component.set("v.EFTRecord.EFT_ID_Type__c",SelectedEFTIDType);
         component.set("v.EFTRecord.Stage__c",'Share/Loan');
        
		if(SelectedShareLoanID != undefined){
            evt.setParams({ "EFTRecord": component.get("v.EFTRecord")});
            evt.fire();
        }
    }
})