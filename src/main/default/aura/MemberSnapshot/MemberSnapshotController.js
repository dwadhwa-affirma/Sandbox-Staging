({
    doInit: function(component, event, helper) {
        helper.getCurrentMAAPLevel(component, event, helper);
        helper.getAvailableOpportunity(component, event, helper);
        helper.getPromocode(component, event, helper);
        helper.getFraudWarnings(component, event, helper);
        helper.getSureveyScore(component, event, helper);
        helper.getReason(component, event, helper);
        helper.getMemberPageMessages(component, event, helper);
        
        
        var returnValue =helper.getUrlParameter("c__ivrguid");
        if(returnValue){
            helper.getReason(component, event, helper,returnValue);
        }
    },
    getValueFromApplicationEvent:function(component, event, helper) {
        var IsActiveCases = event.getParam("IsActiveCases");
        if(IsActiveCases== true){
            component.set("v.IsThereCases",true);
        }else {
            component.set("v.IsThereCases",false);
        }
    },
    handleActiveCasesClick:function(component, event, helper) {
        var evt = $A.get("e.c:MemberSnapshotEvent");   
        evt.fire();       
    },
    handleAvailableOppClick:function(component, event, helper) {
        var relatedListEvent = $A.get("e.force:navigateToRelatedList");
        relatedListEvent.setParams({
            "relatedListId": "Opportunities",
            "parentRecordId": component.get("v.recordId")
        });
        relatedListEvent.fire();
    },
    handleFraudWarningClick:function(component, event, helper) {
        var fraudWarnings=component.get("v.FraudWarnings");
        if(fraudWarnings.length == 1){  
            var navService = component.find("navigate");    
            var pageReference = {
                type: 'standard__recordPage',
                attributes: {
                    recordId:fraudWarnings[0].Id,
                    objectApiName: 'Case',
                    actionName: 'view'
                },
                state: {
                    filterName: "Authentication_Failed_Unusual_Activity_Case"
                }
            };
            
            navService.navigate(pageReference);   
        }
        else{
            var evt = $A.get("e.c:MemberSnapshotEvent");   
        evt.fire(); 
        }
    },
        
    
    
    handleSurveyScoreClick:function(component, event, helper) {
        var sureveyScore=component.get("v.SurveyScore");
        if(sureveyScore) {
            var navEvt = $A.get("e.force:navigateToSObject");
            navEvt.setParams({
                "recordId":sureveyScore.Id,
                "slideDevName": "Detail"
            });
            navEvt.fire();
        }
    },handleCreateCase: function(component, event, helper) {
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
    handleCreateOpportunity2: function(component, event, helper) {
        var recordId = component.get("v.recordId");
        var modalBody;
        $A.createComponent("c:OppQuickAction", {recordId:recordId,isQuickAction: false},
                           function(content, status) {
                               if (status === "SUCCESS") {
                                   modalBody = content;
                                   component.find('overlayLib').showCustomModal({
                                       header: "Create Opportunity",
                                       body: modalBody,
                                       showCloseButton: false,
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
        
        debugger;
        var recordId = component.get("v.recordId");
        var modalBody;
        var modalFooter;
        var object = component.get("v.sObjectName");
        $A.createComponents([
            ["c:AccountServiceMenu", {recordId:recordId,isQuickAction: false,sObjectName:object}],
            				["c:AccountServiceMenuFooter", {}]
                           ],
                           function(content, status) {
                               if (status === "SUCCESS") {
                                   modalBody = content[0];
                                   modalFooter=content[1];
                                   component.find('overlayLib').showCustomModal({
                                       header: "Account Services",
                                       body: modalBody,
                                       footer:modalFooter,
                                       showCloseButton: true,
                                       cssClass: "mymodal",
                                       closeCallback: function() {
                                       }
                                   })
                               }
                           });
    }
})