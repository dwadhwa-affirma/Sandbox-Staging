({
	myAction : function(component, event, helper) {
		
	},
    handleCreateCase: function(component, event, helper) {
        var recordId = component.get("v.recordId");
        var modalBody;
        $A.createComponent("c:CreateCaseMemberPage", {recordId:recordId,isQuickAction: false},
           function(content, status) {
               if (status === "SUCCESS") {
                   modalBody = content;
                   component.find('overlayLib').showCustomModal({
                       header: "Create Case",
                       body: modalBody,
                       showCloseButton: true,
                       cssClass: "mymodal",
                       closeCallback: function() {
                       }
                   })
               }
           });
    },
    handleCreateOpportunity: function(component, event, helper) {
         var recordId = component.get("v.recordId");
        var modalBody;
        $A.createComponent("c:CreateOpportunity", {recordId:recordId,isQuickAction: false},
           function(content, status) {
               if (status === "SUCCESS") {
                   modalBody = content;
                   component.find('overlayLib').showCustomModal({
                       header: "Create Opportunity",
                       body: modalBody,
                       showCloseButton: true,
                       cssClass: "mymodal",
                       closeCallback: function() {
                       }
                   })
               }
           });
    },
    handleAddressChange: function(component, event, helper) {
        var recordId = component.get("v.recordId");
        var modalBody;
        $A.createComponent("c:AddressChangeAllAccounts", {recordId:recordId,isQuickAction: false},
           function(content, status) {
               if (status === "SUCCESS") {
                   modalBody = content;
                   component.find('overlayLib').showCustomModal({
                       header: "Address Change",
                       body: modalBody,
                       showCloseButton: true,
                       cssClass: "mymodal",
                       closeCallback: function() {
                       }
                   })
               }
           });
    },
    handleAccountServices: function(component, event, helper) {
        var recordId = component.get("v.recordId");
        var modalBody;
        $A.createComponent("c:AccountServiceMenu", {recordId:recordId,isQuickAction: false},
           function(content, status) {
               if (status === "SUCCESS") {
                   modalBody = content;
                   component.find('overlayLib').showCustomModal({
                       header: "Account Services",
                       body: modalBody,
                       showCloseButton: true,
                       cssClass: "mymodal",
                       closeCallback: function() {
                       }
                   })
               }
           });
    }
})