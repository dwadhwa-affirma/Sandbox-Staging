({
    doInit : function(component, event, helper) {
        var action = component.get("c.GetAllData");     
        var recordid = component.get("v.recordId");	
        
        if(recordid == undefined)
        {
            recordid = helper.getParameterByName('c__id');
        }
        
        action.setParams({ "accid": recordid });
        
        action.setCallback(this, function (response) {
            
            var status = response.getState();
            component.set("v.loading", false);
            if (component.isValid() && status === "SUCCESS") {
                
                var result = response.getReturnValue();
                
                
            }
            else if (status === "ERROR") {
                var errors = response.getError();
                //console.error(errors);
            } 
            
            var hostname = window.location.hostname;
            
            //var URL = 'https://' + hostname + '/apex/flow?flow-id=04d6f632-1d3b-4b35-a0cd-6694169978a6&object-id=' + stracc + '&fullname=' + membername;
            //var URL = 'https://' + hostname + '/apex/flow?flow-id=32853ba9-fabc-4943-99f7-344c8e187b0d&accountid=001j000000y6s29AAA';
            var URL = 'https://flow.boomi.com/205f8437-a72f-4b9a-9dbd-f9df4a2346b3/play/AddressChangePlayer/?flow-id=95ecc8cf-6d92-4c9c-a625-23ea6a038440' + '&accountid='+recordid + '&UserId=' + result.UserId + '&MemberName=' + result.MemberName +'&EpisysId=' + result.EpisysId;
            console.log(`AddressChangeAllAccountsController: result.FlowURL ${result.FlowURL}`);
            console.log(`AddressChangeAllAccountsController: URL ${URL}`);
            //window.location.href = URL
            window.open(URL,'_blank');
            $A.get('e.force:closeQuickAction').fire();
            component.find("overlayLib").notifyClose();
        });
        
        component.set("v.loading", true);
        $A.enqueueAction(action);
        
    },
    closePopup: function(component, event, helper) {
        $A.get('e.force:closeQuickAction').fire();
        component.find("overlayLib").notifyClose();
    },
})