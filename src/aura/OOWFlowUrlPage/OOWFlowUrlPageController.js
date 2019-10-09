({
	doInit : function(component, event, helper) {
		
		      
        var recordid = component.get("v.recordId");
        var sobjecttype = component.get("v.sobjecttype");
       
		var action = component.get("c.GetAccountNumber");
		action.setParams({"accdetailid": recordid, "sobjecttype": sobjecttype});  
		
		action.setCallback(this, function (response) {
		 var status = response.getState();            
	       	    if (component.isValid() && status === "SUCCESS") {
	       	    	var result = response.getReturnValue(); 
                    
	               if(result.length > 0)
	               {
                       component.set("v.AccountNumber",result);
                     
	            	 // window.open("https://flow.boomi.com/3372c831-d7c0-471a-9e61-4432573f08bd/play/CustomOOWPlayer/?flow-id=7a4f930b-1d35-4e4b-a11c-1b1f7a37cf09&accountnumber=" + result );
	            	  window.open("https://flow.boomi.com/62109fbc-595b-46b1-a8ef-5fccf617ee12/play/CustomOOWPlayer?flow-id=7a4f930b-1d35-4e4b-a11c-1b1f7a37cf09&accountnumber=" + result );
                      window.onmessage = function (e) {
					
                      	var output = e.data;
                       
                        var match = output.split(';')
                        var status = match[0];
                        var reason = match[1];
                        var notes = match[2];
                       
                        if(notes == 'null')  
                        {
                            notes = '';
                        }
                        var action1 = component.get("c.SaveLogData");
  		   					
   	      				var membernumber = result;
                          action1.setParams({"status": status, "MemberNumber": membernumber,"reason":reason,"notes":notes});
          				 action1.setCallback(this, function (response) {
	       	      		 var status1 = response.getState();            
                               if (component.isValid() && status1 === "SUCCESS") {
                            
                                   var result1 = response.getReturnValue();
                            
                            
                                }
   	       				});	
   	       
   	      					 $A.enqueueAction(action1);  
                          
                          
  						component.set("v.status", status);
  						component.set("v.reason", reason);
  						component.set("v.notes", notes);
  						
						};  
                       
                       
                        
	               }
	       	    
	       	      
	             
	       	    	
	       	    }
           // var dismissActionPanel = $A.get("e.force:closeQuickAction"); 
          //  dismissActionPanel.fire(); 
		
		});
		
		$A.enqueueAction(action);
		
            
                          
		/*
  		   var action1 = component.get("c.SaveLogData");
  		   var status = component.get("v.status");	
   	       var membernumber = component.get("v.AccountNumber");
           action1.setParams({"status": status, "MemberNumber": membernumber});
           action1.setCallback(this, function (response) {
	       	       var status1 = response.getState();            
	       	       if (component.isValid() && status1 === "SUCCESS") {
	       	    
	       	    	   var result1 = response.getReturnValue();
	       	    
	       	    
	       	       	}
   	       });	
   	       
   	       $A.enqueueAction(action1);
*/
	},
	
	
	 closePopup: function(component, event, helper) {
	  $A.get('e.force:closeQuickAction').fire();
   }, 
	
})