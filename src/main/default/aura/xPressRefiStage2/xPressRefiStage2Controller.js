({
  doInit: function (component, event, helper) {
    var fullzip = component.get("v.xPressRefiRecord.Property_Zip__c");
    // var zip5, zip4, zip;
    // if (fullzip != null && fullzip != undefined && fullzip.length > 5) {
    //   zip4 = fullzip.substring(5);
    //   zip5 = fullzip.substring(0, 4);
    //   zip = zip5 + "-" + zip4;
    // } else {
    //   zip = fullzip;
    // }

    var PropertyAddress =
      component.get("v.xPressRefiRecord.Property__c") +
      " " +
      "\n" +
      component.get("v.xPressRefiRecord.Property_City__c") +
      " " +
      component.get("v.xPressRefiRecord.Property_State__c") +
      ", " +
      fullzip;
    component.set("v.PropertyAddress", PropertyAddress);
    var IsPrimaryResidence = component.get("v.isLoanPrimaryResidence");
    component.set(
      "v.xPressRefiRecord.Is_Primary_Residence__c",
      IsPrimaryResidence
    );
    helper.getProductList(component, event);
    var evt = $A.get("e.c:xPressRefiEvent");
    evt.setParams({
      ActiveStepIndex: 2,
    });
    evt.fire();
  },

  onProductSelect: function (component, event, helper) {
    debugger;
    var SelectedProduct, SelectedInterestRate, SelectedPIPayment, SelectedProductName;
    if (event != undefined) {
      SelectedProduct = event.getSource().get("v.value");
    }

    var map = component.get("v.ProductList");
    for (var i = 0; i < map.length; i++) {
      if (map[i].Product == SelectedProduct) {
        SelectedInterestRate = map[i].Rate;
        SelectedPIPayment = map[i].TotalPIPayment;
        SelectedProductName = map[i].ProductName;
        break;
      }
    }

    component.set("v.xPressRefiRecord.New_Product_Type__c", SelectedProduct);
    component.set(
      "v.xPressRefiRecord.New_Interest_Rate_Calc__c",
      SelectedInterestRate
    );
    component.set(
      "v.xPressRefiRecord.New_Payment_Amount_Calc__c",
      SelectedPIPayment
    );
    component.set(
      "v.xPressRefiRecord.New_Product_Name__c",
      SelectedProductName
    );

    var evt = $A.get("e.c:xPressRefiEvent");
    if (SelectedProduct != undefined) {
      evt.setParams({ xPressRefiRecord: component.get("v.xPressRefiRecord") });
      evt.fire();
    }
  },

  HandlePrimaryResidenceChange: function (component, event, helper) {
    var IsChevronEmployee = component.get("v.IsChevronEmployee");
    var IsPrimaryResidence = component.get("v.isLoanPrimaryResidence");//component.get("v.IsPrimaryResidence");
    //var IsChevronRelocation = component.get("v.IsChevronRelocation");

    
    component.set(
      "v.xPressRefiRecord.Is_Chevron_Employee__c",
      IsChevronEmployee
    );
    component.set(
      "v.xPressRefiRecord.Is_Primary_Residence__c",
      IsPrimaryResidence
    );
    // component.set(
    //   "v.xPressRefiRecord.Is_Relocation_Loan__c",
    //   IsChevronRelocation
    // );

    var evt = $A.get("e.c:xPressRefiEvent");

    evt.setParams({ xPressRefiRecord: component.get("v.xPressRefiRecord") });
    evt.fire();

    if (
      // IsChevronRelocation == "true" &&
      IsChevronEmployee == "true" &&
      IsPrimaryResidence == true
    ) {
      helper.adjustDiscountRates(component, event, true);
    } else {
      helper.adjustDiscountRates(component, event, false);
    }
  },

  HandleIncomeChange: function (component, event, helper) {
    var evt = $A.get("e.c:xPressRefiEvent");

    evt.setParams({ xPressRefiRecord: component.get("v.xPressRefiRecord") });
    evt.fire();
  },
});