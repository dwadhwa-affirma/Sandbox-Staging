({
	helperMethod : function() {
		
	},
    getMemberInformation: function(component, event, helper) {
    	var recordId=component.get('v.recordId');
    var action = component.get("c.GetMemberInfomation");
    action.setParams({
        accountId : recordId
    });
    action.setCallback(this, function(response) {
        var state = response.getState();
        var response = response.getReturnValue();
        if (state == "SUCCESS") {	
            component.set("v.account",response);
        }else{
            console.log('Error occured while getting the account data.');
        }
    });
    $A.enqueueAction(action);
	},
    getMemberPageMessages:function(cmp, event, helper) {
        var action = cmp.get('c.accountDetails');	   
		action.setParams({actId : cmp.get('v.recordId')});
	    action.setCallback(this, $A.getCallback(function (response) {
	        var state = response.getState();	        
	        if (state === "SUCCESS") {	        	
	          var data = response.getReturnValue();
               cmp.set('v.ShowData', data.ShowData);
               cmp.set('v.RecordTypeName', data.RecordTypeName);
               cmp.set('v.Highvalueflag', data.Highvalueflag);
               cmp.set('v.Highpotentialflag', data.Highpotentialflag);                        
	        } 
	        else if (state === "ERROR") {	        	
	           var errors = response.getError();      
	           
	       }
	        
	   }));	   
       $A.enqueueAction(action);
     
    }
})