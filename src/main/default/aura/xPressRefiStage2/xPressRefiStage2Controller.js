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
    var SelectedProduct,
      SelectedInterestRate,
      SelectedPIPayment,
      SelectedProductName,
      SelectedCostComponent,
      isMortgageCadence;
    var isMultipleEmailIds = component.get("v.isMultipleEmailIds");
    var currentrecordEmailID = component.get("v.xPressRefiRecord.Member_Email__c");
    if (event != undefined) {
      SelectedProduct = event.getSource().get("v.value");
    }

    var map = component.get("v.ProductList");
    for (var i = 0; i < map.length; i++) {
      if (map[i].Product == SelectedProduct) {
        SelectedInterestRate = map[i].Rate;
        SelectedPIPayment = map[i].TotalPIPayment;
        SelectedProductName = map[i].ProductName;
        isMortgageCadence = map[i].IsMortgageCadence;
        SelectedCostComponent = map[i].CostComponent;
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
    component.set(
      "v.xPressRefiRecord.Is_Mortgage_Cadence__c",
      isMortgageCadence
    );

    if (SelectedCostComponent > 0) {
      component.set("v.IsFeeCollectionVisible", true);
    } else {
      component.set("v.IsFeeCollectionVisible", false);
    }

    if(!isMortgageCadence && isMultipleEmailIds && (currentrecordEmailID == "" || currentrecordEmailID == null || currentrecordEmailID == undefined)){
        component.set("v.isEmailSelectionVisible", true);
    }
    else{
      component.set("v.isEmailSelectionVisible", false);
    }

    var evt = $A.get("e.c:xPressRefiEvent");
    if (SelectedProduct != undefined) {
      evt.setParams({
        xPressRefiRecord: component.get("v.xPressRefiRecord"),
        IsFeeCollectionVisible: component.get("v.IsFeeCollectionVisible"),
      });
      evt.fire();
    }
  },

  HandlePrimaryResidenceChange: function (component, event, helper) {
    helper.showSpinner(component);
    var IsChevronEmployee = component.get("v.IsChevronEmployee");
    var IsPrimaryResidence = component.get("v.isLoanPrimaryResidence");
    var IsMaturityDateReset = component.get("v.IsMaturityDateReset");
    //component.get("v.IsPrimaryResidence");
    //var IsChevronRelocation = component.get("v.IsChevronRelocation");

    component.set(
      "v.xPressRefiRecord.Is_Chevron_Employee__c",
      IsChevronEmployee
    );
    component.set(
      "v.xPressRefiRecord.Is_Primary_Residence__c",
      IsPrimaryResidence
    );
    if (IsMaturityDateReset == "false") {
      component.set("v.xPressRefiRecord.Is_Maturity_Date_Reset__c", true);
    } else if (IsMaturityDateReset == "true") {
      component.set("v.xPressRefiRecord.Is_Maturity_Date_Reset__c", false);
    }

    component.set("v.xPressRefiRecord.New_Product_Type__c", "");

    var evt = $A.get("e.c:xPressRefiEvent");

    evt.setParams({
      xPressRefiRecord: component.get("v.xPressRefiRecord"),
      IsFeeCollectionVisible: component.get("v.IsFeeCollectionVisible"),
    });
    evt.fire();

    if (
      // IsChevronRelocation == "true" &&
      IsChevronEmployee == "true" &&
      IsPrimaryResidence == true
    ) {
      helper.adjustDiscountRates(component, event, true, IsMaturityDateReset);
    } else {
      helper.adjustDiscountRates(component, event, false, IsMaturityDateReset);
    }
  },

  HandleIncomeChange: function (component, event, helper) {
    var evt = $A.get("e.c:xPressRefiEvent");

    evt.setParams({
      xPressRefiRecord: component.get("v.xPressRefiRecord"),
      IsFeeCollectionVisible: component.get("v.IsFeeCollectionVisible"),
    });
    evt.fire();
  },

  HandleMatrurityReset: function (component, event, helper) {
    helper.showSpinner(component);
    var IsChevronEmployee = component.get("v.IsChevronEmployee");
    var IsPrimaryResidence = component.get("v.isLoanPrimaryResidence");
    var IsMaturityDateReset = component.get("v.IsMaturityDateReset");

    if (IsMaturityDateReset == "false") {
      component.set("v.xPressRefiRecord.Is_Maturity_Date_Reset__c", true);
    } else if (IsMaturityDateReset == "true") {
      component.set("v.xPressRefiRecord.Is_Maturity_Date_Reset__c", false);
    }

    component.set("v.IsFeeCollectionVisible", false);

    var evt = $A.get("e.c:xPressRefiEvent");

    evt.setParams({
      xPressRefiRecord: component.get("v.xPressRefiRecord"),
      IsFeeCollectionVisible: component.get("v.IsFeeCollectionVisible"),
    });
    evt.fire();

    if (
      // IsChevronRelocation == "true" &&
      IsChevronEmployee == "true" &&
      IsPrimaryResidence == true
    ) {
      helper.adjustDiscountRates(component, event, true, IsMaturityDateReset);
    } else {
      helper.adjustDiscountRates(component, event, false, IsMaturityDateReset);
    }
  },

  HandlePaymentCheck: function (component, event, helper) {
    var evt = $A.get("e.c:xPressRefiEvent");

    evt.setParams({
      xPressRefiRecord: component.get("v.xPressRefiRecord"),
      IsFeeCollectionVisible: component.get("v.IsFeeCollectionVisible"),      
    });
    evt.fire();
  },

  onChangeXpressRefiClick: function (component, event, helper) {
    debugger;
    //document.getElementById('pay_now_form_18b5022503').submit();
    var MemberNo = component.get("v.xPressRefiRecord.Member_Number__c");
    var LoanNumber = component.get("v.xPressRefiRecord.LoanId__c");
    var PayeezyConfig = component.get("v.PayeezyConfig");
    var param = {
      x_login: PayeezyConfig.x_login__c,
      x_show_form: "PAYMENT_FORM",
      x_fp_sequence: PayeezyConfig.x_fp_sequence__c,
      x_fp_hash: PayeezyConfig.x_fp_hash__c,
      x_amount: PayeezyConfig.x_amount__c,
      x_currency_code: "USD",
      x_test_request: PayeezyConfig.x_test_request__c,
      x_relay_response: "",
      donation_prompt: "",
      x_invoice_num: MemberNo,
      x_po_num: LoanNumber,
      button_code: PayeezyConfig.button_code__c,
    };
    helper.OpenWindowWithPost(
      component,
      PayeezyConfig.URL__c,
      "width=730,height=345,left=100,top=100,resizable=yes,scrollbars=yes",
      "NewFile",
      param
    );
  },

  onEmailSelect: function (component, event, helper) {
    if (event != undefined) {
      var SelectedEmailId = event.getSource().get("v.value");
      if(SelectedEmailId != ""){
        var evt = $A.get("e.c:xPressRefiEvent");
        component.set(
          "v.xPressRefiRecord.Member_Email__c",
          SelectedEmailId);  
          
          evt.setParams({
            xPressRefiRecord: component.get("v.xPressRefiRecord"),
            IsFeeCollectionVisible: component.get("v.IsFeeCollectionVisible"),
          });
          evt.fire();
      }
    }
  }
});