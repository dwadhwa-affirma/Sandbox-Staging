({
    doInit : function(component, event, helper) {
        debugger;  
        var userId = $A.get("$SObjectType.CurrentUser.Id")
        var recordid = component.get("v.recordId");
        
        if(recordid != undefined)
        {
            var action = component.get("c.GetAccountNumber");
            action.setParams({"accdetailid": recordid});  
            action.setCallback(this, function (response) {
                var status = response.getState();    
                if (component.isValid() && status === "SUCCESS") {
                    var result = response.getReturnValue();     
                    if(result.AccountNumber.length > 0 && result.FlowURL.length>0)
                    {
                        var win = window.open(result.FlowURL+'&account='+ result.AccountNumber+'&LaunchByUserId='+userId); 
                        $A.get('e.force:closeQuickAction').fire();
                    }   
                }
            });
            $A.enqueueAction(action);
        }
        
        //var win = window.open('https://flow.manywho.com/4aa12667-5b91-49e4-a628-d2a409a0d781/play/WiresPlayer/?flow-id=4e93a4fb-2034-42ec-94c0-b5a48a93d218&account=0000247286'+ result.AccountNumber); 
        //https://flow.manywho.com/4aa12667-5b91-49e4-a628-d2a409a0d781/play/WiresPlayer/?flow-id=4e93a4fb-2034-42ec-94c0-b5a48a93d218&account={!Account_Details__c.Name}
    },
    
    
    closePopup: function(component, event, helper) {
        $A.get('e.force:closeQuickAction').fire();
    }, 
    
})