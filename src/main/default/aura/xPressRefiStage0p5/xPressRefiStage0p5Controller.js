({
  onAccountSelect: function (component, event, helper) {
      debugger;
    var SelectedLoan = event.getSource().get("v.value");
    var AccountList = [];
    AccountList = component.get("v.xPressRefiRecordList");

    for (var i = 0; i < AccountList.length; i++) {
        if (AccountList[i].LoanId__c == SelectedLoan){
            component.set("v.xPressRefiRecord",AccountList[i]);
        }
    }

    var evt = $A.get("e.c:xPressRefiEvent");
    evt.setParams({
      ActiveStepIndex: 0,
      xPressRefiRecord: component.get("v.xPressRefiRecord")
    });
    evt.fire();
  },
});
