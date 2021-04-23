({
  doInit: function (component, event, helper) {
    //helper.showSpinner(component);
    var fullzip = component.get("v.xPressRefiRecord.Property_Zip__c");
    // var zip5, zip4, zip;
    // if(fullzip != null && fullzip != undefined && fullzip.length > 5){
    //     zip4 = fullzip.substring(5);
    //     zip5 = fullzip.substring(0,4);
    //     zip = zip5 + "-" + zip4;
    // }
    // else{
    //   zip = fullzip;
    // }

    var fullzipMemberShip = component.get("v.xPressRefiRecord.Mailing_Address_Zip__c");
    var zip5m, zip4m, zipm;
    if(fullzipMemberShip != null && fullzipMemberShip != undefined && fullzipMemberShip.length > 5){
        zip4m = fullzipMemberShip.substring(5);
        zip5m = fullzipMemberShip.substring(0,4);
        zipm = zip5m + "-" + zip4m;
    }
    else{
      zipm = fullzipMemberShip;
    }
    
    var PropertyAddress =
      component.get("v.xPressRefiRecord.Property__c") + " " +
      component.get("v.xPressRefiRecord.Property_City__c") + " " +
      component.get("v.xPressRefiRecord.Property_State__c") +
      ", " + fullzip;   
    var MembershipAddress =
      component.get("v.xPressRefiRecord.Mailing_Address_1__c") + " " +
      component.get("v.xPressRefiRecord.Mailing_Address_2__c") + " " +
      component.get("v.xPressRefiRecord.Mailing_Address_City__c") + " " +
      component.get("v.xPressRefiRecord.Mailing_State__c")  +
      ", " + zipm;     
    component.set("v.PropertyAddress",PropertyAddress);
    component.set("v.MembershipAddress",MembershipAddress);
    var evt = $A.get("e.c:xPressRefiEvent");
    evt.setParams({
      ActiveStepIndex: 1,
    });
    evt.fire();
    //helper.hideSpinner(component);
  },

  onAddressMatchRadioSelect: function (component, event, helper) {
    var changeValue = event.getSource().get("v.value"); //event.getParam("value");
    if (changeValue == "1") {
      //Selection: Yes
      var evt = $A.get("e.c:xPressRefiEvent");
      evt.setParams({
        isLoanPrimaryResidence: true,
      });
      evt.fire();
    }
    if (changeValue == "2") {
      //Selection: No
      var evt = $A.get("e.c:xPressRefiEvent");
      evt.setParams({
        isLoanPrimaryResidence: false,
      });
      evt.fire();
    }
  },
});
