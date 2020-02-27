({
	doInit : function(component, event, helper) {
		
		debugger;      
        var recordid = component.get("v.recordId");
        var sobjecttype = component.get("v.sobjecttype");
       if(recordid != undefined && sobjecttype != undefined)
       {
                var action = component.get("c.GetAccountNumber");
                action.setParams({"accdetailid": recordid, "sobjecttype": sobjecttype});  
                
                action.setCallback(this, function (response) {
                 var status = response.getState();            
                        if (component.isValid() && status === "SUCCESS") {
                            var result = response.getReturnValue(); 
                            
                           if(result.AccountNumber.length > 0)
                           {
                               var MemberName = result.MemberName;
                               component.set("v.AccountNumber",result.AccountNumber);
                             
                             // window.open("https://flow.boomi.com/3372c831-d7c0-471a-9e61-4432573f08bd/play/CustomOOWPlayer/?flow-id=7a4f930b-1d35-4e4b-a11c-1b1f7a37cf09&accountnumber=" + result );
                              //var win = window.open("https://flow.boomi.com/62109fbc-595b-46b1-a8ef-5fccf617ee12/play/CustomOOWPlayer?flow-id=7a4f930b-1d35-4e4b-a11c-1b1f7a37cf09&accountnumber=" + result );
                              // var win = window.open("https://flow.boomi.com/62109fbc-595b-46b1-a8ef-5fccf617ee12/play/CustomOOWPlayer?flow-id=7a4f930b-1d35-4e4b-a11c-1b1f7a37cf09&accountnumber=" + result.AccountNumber + "&firstname=allow" + MemberName + "&source=" + result.source );
                                  var win = window.open("https://flow.boomi.com/6f7caa2e-6918-4eeb-9147-a251b9572c5f/play/TravelNotificationPlayer/?flow-id=6e47f321-cfef-455b-b9fb-b4a8233d525c"+"&accountid=" + recordid);
                               window.onmessage = function (e) {
                            
                               	 
                                  var output;                              
                               
                                 
                                
                                 
                                };  
                               
                              setTimeout(function () { win.close();}, 600000);
                                
                           }
                                                
                         
                            
                        }
                   // var dismissActionPanel = $A.get("e.force:closeQuickAction"); 
                  //  dismissActionPanel.fire(); 
                
                });
                
                $A.enqueueAction(action);
				
       }     
                          
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