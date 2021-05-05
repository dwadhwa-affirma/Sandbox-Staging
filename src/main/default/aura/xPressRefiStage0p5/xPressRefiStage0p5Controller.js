({
  doInit: function (component, event, helper) {
    var AccountList = [];
    AccountList = component.get("v.xPressRefiRecordList");
    var xRefiEligibleLoanIds = component.get("v.xRefiEligibleLoanIds");

    for (var i = 0; i < AccountList.length; i++) {
      if (
        xRefiEligibleLoanIds != undefined &&
        xRefiEligibleLoanIds.indexOf(AccountList[i].LoanId__c) == -1
      ) {
        AccountList[i].disabled = true;
        if (AccountList[i].Impermissible__c == true) {
          AccountList[i].warning = "Not Eligible: Impermissible";
        } else {
          AccountList[i].warning = "Not Eligible";
        }
      } else {
        AccountList[i].disabled = false;
      }
    }
  },

  onAccountSelect: function (component, event, helper) {
    debugger;
    var SelectedLoan = event.getSource().get("v.value");
    var AccountList = [];
    AccountList = component.get("v.xPressRefiRecordList");

    for (var i = 0; i < AccountList.length; i++) {
      if (AccountList[i].LoanId__c == SelectedLoan) {
        component.set("v.xPressRefiRecord", AccountList[i]);
      }
    }

    var evt = $A.get("e.c:xPressRefiEvent");
    evt.setParams({
      ActiveStepIndex: 0,
      xPressRefiRecord: component.get("v.xPressRefiRecord"),
    });
    evt.fire();
  },
});
