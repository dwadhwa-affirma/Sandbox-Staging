({
	doinit: function (cmp, event, helper) {		
		
		
		var action = cmp.get('c.accountDetails');	   
		action.setParams({actId : cmp.get('v.recordId')});
	    action.setCallback(this, $A.getCallback(function (response) {
	        var state = response.getState();	        
	        if (state === "SUCCESS") {	        	
	          var data = response.getReturnValue();
               cmp.set('v.ShowData', data.ShowData);
               cmp.set('v.Memberisunder18', data.Memberisunder18);
               cmp.set('v.RecordTypeName', data.RecordTypeName);
               cmp.set('v.Memberisnotprimary', data.Memberisnotprimary);
               cmp.set('v.MemberRefreshNeeded', data.MemberRefreshNeeded);
               cmp.set('v.Memberhaspartiallycompleted', data.Memberhaspartiallycompleted);
               cmp.set('v.AMemberAssessmentisdue', data.AMemberAssessmentisdue);
               cmp.set('v.MemberOptOut', data.MemberOptOut);
               cmp.set('v.Opt_Out_Date', data.Opt_Out_Date);
               
               cmp.set('v.Highvalueflag', data.Highvalueflag);
               cmp.set('v.Highpotentialflag', data.Highpotentialflag);
                
               cmp.set('v.ShowOTPInvalidAttempt', data.ShowOTPInvalidAttempt);
               cmp.set('v.OTPNextAttemptValidAfterHours', data.OTPNextAttemptValidAfterHours);
               cmp.set('v.IsShowOTPButton', data.IsShowOTPButton);
               setTimeout(function(){ 
            	   	if(cmp.get('v.ShowOTPInvalidAttempt') == 'true')
		               {
		                   var node = document.querySelectorAll('a[title="OTP"]');
		                   if(node && node.length > 0)
		                   {
		                    	var buttonnode = node[0].parentElement;
		                    	buttonnode.classList.add('redOTP');                       
		                   }              
		               }
		               else
		               {
		                    
		                   var node = document.querySelectorAll('a[title="OTP"]');
		                   if(node && node.length > 0)
		                   {
		                    	var buttonnode = node[0].parentElement;
		                    	buttonnode.classList.remove('redOTP');    				
		                   }
		                }
		                if(cmp.get('v.IsShowOTPButton') == 'false')
		                {
		                	var node = document.querySelectorAll('a[title="OTP"]');
		                   if(node && node.length > 0)
		                   {
		                    	var buttonnode = node[0].parentElement;
		                    	buttonnode.classList.add('btnOTPtab');    
		                    	cmp.set('v.ShowOTPInvalidAttempt', 'false');				
		                   }
		                }
		                else
		                {
		                	var node = document.querySelectorAll('a[title="OTP"]');
		                   if(node && node.length > 0)
		                   {
		                    	var buttonnode = node[0].parentElement;
		                    	buttonnode.classList.remove('btnOTPtab');	                    					
		                   }
		                }
               }, 3000);
               
                                          
	        } 
	        else if (state === "ERROR") {	        	
	           var errors = response.getError();      
	           
	       }
	        
	   }));	   
       $A.enqueueAction(action);
     
	                    
	}
})