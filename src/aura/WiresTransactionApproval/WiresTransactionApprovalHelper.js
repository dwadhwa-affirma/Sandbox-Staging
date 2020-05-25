({
	doInit : function(component, event,helper, recordId) {
    	
    	helper.getWiresTransactionData(component, event,recordId); 	
	},
    
     getWiresTransactionData : function(component, event,recordId){
         
		var action = component.get("c.getWiresData");
		action.setParams({"WiresRecordId": recordId});
	
		action.setCallback(this, function (response) {
            debugger;
        	var status = response.getState();            
            if (component.isValid() && status === "SUCCESS") {
                var result = response.getReturnValue();
                
               component.set("v.isApprovalVisible",result.isApprovalVisible);
               component.set("v.ApprovalStatus",result.ApprovalStatus);
              // component.set("v.AccountOpenfor45Days",result.AccountOpenfor45Days);
               component.set("v.BalanceStatusCode",result.WiresBalance.StatusCode);
                component.set("v.BalanceRGLines",result.WiresBalance.RGLines.trim());
		       component.set("v.WiresCount",result.WiresCount); 
             //  component.set("v.IdentificationUsed",result.IdentificationUsed); 
             //  component.set("v.EmailStable",result.EmailStable); 
             //  component.set("v.HomePhoneStable",result.HomePhoneStable); 
             //  component.set("v.WorkPhoneStable",result.WorkPhoneStable); 
             //  component.set("v.MobilePhoneStable",result.MobilePhoneStable);
               component.set("v.WiresObject",result.WiresList);
              
            }            
        	
            
        	
        });	
       $A.enqueueAction(action);
	
	},
    
    ApproveTransaction: function(component, event,helper, recordId) {
        
         var modalBody;
        var recId= component.get('v.recordId');       
        
        $A.createComponent("c:WiresApprovalReview", {recordId:recordId, AccountOpenfor45Days : component.get('v.AccountOpenfor45Days'),
             					  BalanceStatusCode : component.get('v.BalanceStatusCode'),
             					  BalanceRGLines : component.get('v.BalanceRGLines'),
             					  WiresCount : component.get('v.WiresCount'),
                                  WiresObject : component.get('v.WiresObject')},
                                                     
                                  //IdentificationUsed : component.get('v.IdentificationUsed'),
                                  //EmailStable : component.get('v.EmailStable'),
                                  //HomePhoneStable : component.get('v.HomePhoneStable'),
                                  //WorkPhoneStable : component.get('v.WorkPhoneStable'),
                                  //MobilePhoneStable : component.get('v.MobilePhoneStable')},
           function(content, status) {
               if (status === "SUCCESS") {
                   modalBody = content;
                   component.find('overlayLib').showCustomModal({
                       header: "Items to Review",
                       body: modalBody, 
                       showCloseButton: true,
                       closeCallback: function() {
                          
                       }
                   })
               }                               
           });
       	
		   
        
    }
})