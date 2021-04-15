({
  doInit: function (component, event, helper) {
    helper.getStage2p5Note(component, event);
    var evt = $A.get("e.c:xPressRefiEvent");
    evt.setParams({
      ActiveStepIndex: 4,
    });
    evt.fire();
  },

  HandleRadioChange: function (component, event, helper) {
    var isVestingChanged = component.get(
      "v.xPressRefiRecord.Is_Vesting_Info_Changed__c"
    );
    var isVestingTrust = component.get(
      "v.xPressRefiRecord.Is_Vesting_Info_Trust__c"
    );

    if (isVestingChanged == "true" || isVestingTrust == "true") {
      component.set("v.isVestingDisabled", true);
      component.set("v.xPressRefiRecord.Is_Mortgage_Cadence__c", true);
    } else {
      component.set("v.isVestingDisabled", false);
      component.set("v.xPressRefiRecord.Is_Mortgage_Cadence__c", false);
    }

    var evt = $A.get("e.c:xPressRefiEvent");
    evt.setParams({ xPressRefiRecord: component.get("v.xPressRefiRecord") });
    evt.fire();
  },

  HandlePersonChange: function (component, event, helper) {   
    var evt = $A.get("e.c:xPressRefiEvent");
    evt.setParams({ xPressRefiRecord: component.get("v.xPressRefiRecord") });
    evt.fire();
  }
});