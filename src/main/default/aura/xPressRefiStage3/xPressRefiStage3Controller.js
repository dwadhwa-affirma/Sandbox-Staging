({
  doInit: function (component, event, helper) {
    debugger;
    var fullzip = component.get("v.xPressRefiRecord.Property_Zip__c");
    var zip5, zip4, zip;
    if (fullzip != null && fullzip != undefined && fullzip.length > 5) {
      zip4 = fullzip.substring(5);
      zip5 = fullzip.substring(0, 4);
      zip = zip5 + "-" + zip4;
    } else {
      zip = fullzip;
    }

    var PropertyAddress =
      component.get("v.xPressRefiRecord.Property__c") +
      " " +
      component.get("v.xPressRefiRecord.Property_City__c") +
      " " +
      component.get("v.xPressRefiRecord.Property_State__c") +
      ", " +
      zip;
    component.set("v.PropertyAddress", PropertyAddress);
    var evt = $A.get("e.c:xPressRefiEvent");
    evt.setParams({
      ActiveStepIndex: 3,
    });
    evt.fire();
  },
});
