({
  doInit: function (component, event, helper) {
    //helper.showSpinner(component);
    debugger;
    var recordId = component.get("v.recordId");
    var ShareLoanID = component.get("v.EFTRecord.Share_Loan_Id__c");
    var Operation = component.get("v.EFTRecord.Action_Type__c"); 
    var EFTLocator = component.get("v.EFTRecord.EftLocator__c"); 

    var action = component.get("c.getEFTRecordsforShareLoan1");
    var CurrentEFT =component.get("v.CurrentEFT");
    component.set("v.isExpireEFT", undefined);
    if(CurrentEFT == 0){
        action.setParams({
            re: recordId,
            sh: ShareLoanID,
            op: Operation,
            ef: EFTLocator
          });
          action.setCallback(this, function (response) {
            helper.showSpinner(component);
            var state = response.getState();
            if (component.isValid() && state === "SUCCESS") {
              var result = response.getReturnValue();
              if (result.length > 0) {               
                //if(component.get("v.EFTRecord.Action_Type__c") == 'Create' || (component.get("v.EFTRecord.Action_Type__c") == 'Update' && result.length > 1)){
                  component.set("v.isExistingEFT", true);                
                  component.set("v.EFTCount", result.length);
                  component.set("v.EFTRecordsList", result);
                  var CurrentEFT =component.get("v.CurrentEFT");
                  if(CurrentEFT == 0){
                    component.set("v.CurrentEFT", 0);   
                    component.set("v.CurrentEFTRecord", result[0]);               
                  }
        
                  var evt = $A.get("e.c:EFTEvent");
                  var isExistingEFT = component.get("v.isExistingEFT");                    
                  var EFTCount = component.get("v.EFTCount");
                 
                  evt.setParams({
                    EFTRecord: component.get("v.EFTRecord"),
                    isExistingEFT: isExistingEFT,
                    EFTCount: EFTCount,
                    CurrentEFT: component.get("v.CurrentEFT"),
                    EFTRecordsList: component.get("v.EFTRecordsList"),
                    isExpireEFT: component.get("v.isExpireEFT"),
                    CurrentEFTRecord: component.get("v.CurrentEFTRecord")
                  });
                  evt.fire();
               // }
                // else if(component.get("v.EFTRecord.Action_Type__c") == 'Update' && result.length == 1){
                //   var div =component.find("divFIData");                
                //   $A.util.removeClass(div, 'divFI');
                // }
                
              }
              
              else{
                var div =component.find("divFIData");                
                $A.util.removeClass(div, 'divFI');
              }
              
            }
            helper.hideSpinner(component);
          });
          $A.enqueueAction(action);
    }
    else{
        var EFTRecordList = component.get("v.EFTRecordsList");
        component.set("v.CurrentEFTRecord", EFTRecordList[component.get("v.CurrentEFT")]);
         var evt = $A.get("e.c:EFTEvent");
                var isExistingEFT = component.get("v.isExistingEFT");                    
                var EFTCount = component.get("v.EFTCount");
               
                evt.setParams({
                  EFTRecord: component.get("v.EFTRecord"),
                  isExistingEFT: isExistingEFT,
                  EFTCount: EFTCount,
                  CurrentEFT: component.get("v.CurrentEFT"),
                  EFTRecordsList: component.get("v.EFTRecordsList"),
                  isExpireEFT: component.get("v.isExpireEFT"),
                  CurrentEFTRecord: component.get("v.CurrentEFTRecord")
                });
                evt.fire();
                 helper.hideSpinner(component);
    }

    if(component.get("v.CurrentEFT") == component.get("v.EFTCount")){
        component.set("v.isExistingEFT", false); 
        var div =component.find("divFIData");                
        $A.util.removeClass(div, 'divFI');
        var evt = $A.get("e.c:EFTEvent");          
                evt.setParams({
                  EFTRecord: component.get("v.EFTRecord"),
                  isExistingEFT: component.get("v.isExistingEFT"),
                  EFTCount: component.get("v.EFTCount"),
                  CurrentEFT: component.get("v.CurrentEFT"),
                  EFTRecordsList: component.get("v.EFTRecordsList"),
                  isExpireEFT: component.get("v.isExpireEFT"),
                  CurrentEFTRecord: component.get("v.CurrentEFTRecord")
                });
                evt.fire(); 
    }
    
    
  },

  LoadBankName: function (component, event, helper) {
    var RoutingNumber = component.get("v.EFTRecord.Routing_Number__c");
    if (
      RoutingNumber != null &&
      (RoutingNumber.length != 9 ||
        (RoutingNumber.substring(0, 1) != "0" &&
          RoutingNumber.substring(0, 1) != "1" &&
          RoutingNumber.substring(0, 1) != "2" &&
          RoutingNumber.substring(0, 1) != "3"))
    ) {
      alert("Plese enter valid ABA/Routing Number.");
      return;
    }
    helper.showSpinner(component);
    var action = component.get("c.routingInfo");
    action.setParams({
      RoutingNumber: component.get("v.EFTRecord.Routing_Number__c"),
    });
    action.setCallback(this, function (response) {
      var state = response.getState();
      if (component.isValid() && state === "SUCCESS") {
        var result = response.getReturnValue();
        if (result != undefined && result != "" && result != null)
          component.set("v.EFTRecord.Bank_Name__c", result);
        var a = component.get("c.onTypeChange");
        $A.enqueueAction(a);
      }
      helper.hideSpinner(component, helper);
    });

    $A.enqueueAction(action);
  },

  onTypeChange: function (component, event, helper) {
    debugger;
    var evt = $A.get("e.c:EFTEvent");
    var RoutingNumber = component.get("v.EFTRecord.Routing_Number__c");
    var RoutingBankName = component.get("v.EFTRecord.Bank_Name__c");
    var AccountNumber = component.get("v.EFTRecord.Account_Number__c");
    var Type = component.get("v.EFTRecord.Type__c"); //event.getSource().get('v.value');
    var isExistingEFT = component.get("v.isExistingEFT");
    var EFTCount = component.get("v.EFTCount");

    component.set("v.EFTRecord.Stage__c", "FI");

    
    var callingEle = event.getSource().get("v.name");
    if(callingEle == "accountnumber"){
      var validity = component.find("accountNumber").get("v.validity");
      if(validity.valid == false){
        component.set("v.EFTRecord.Account_Number__c","");
      }
    }

    if (Type != undefined) {
      evt.setParams({
        EFTRecord: component.get("v.EFTRecord"),
        isExistingEFT: isExistingEFT,
        EFTCount: EFTCount,
      });
      evt.fire();
    }
  },

  onRadioChange: function (component, event, helper){
      var selectedValue = event.getSource().get('v.value');
      if(selectedValue == "2"){
          component.set("v.isExpireEFT", true);
      }
      else{
        component.set("v.isExpireEFT", false);
      }

      var evt = $A.get("e.c:EFTEvent");          
      evt.setParams({
                  EFTRecord: component.get("v.EFTRecord"),
                  isExistingEFT: component.get("v.isExistingEFT"),
                  EFTCount: component.get("v.EFTCount"),
                  CurrentEFT: component.get("v.CurrentEFT"),
                  EFTRecordsList: component.get("v.EFTRecordsList"),
                  isExpireEFT: component.get("v.isExpireEFT"),
                  CurrentEFTRecord: component.get("v.CurrentEFTRecord")
                });
                evt.fire();
  }
});