({
  doInit: function (component, event, helper) {
    var recordId = component.get("v.recordId");
    var action = component.get("c.getActiveMortgages");
    component.set("v.ActiveStepIndex", 0);
    action.setParams({
      recordId: recordId,
    });
    action.setCallback(this, function (response) {
      debugger;
      var status = response.getState();
      if (component.isValid() && status === "SUCCESS") {
        var result = [];
        result = response.getReturnValue();
        var Stages = [];
        Stages = result.xPressRefiStages;
        var ActiveMortgages = result.ActiveMortgages;
        var isABTQualified = result.isABTQualified;
        var isFullAddressMatch = result.isFullAddressMatch;
        var stageComponenttoLoad, isError;
        var isMultipleMortgages;
        component.set("v.xPressRefiStageDetails", Stages);
        component.set("v.xRefiEligibleLoanIds", result.xRefiEligibleLoanIds);
        

        if (
          result.IsXpressRefiPending &&
          ActiveMortgages.xPressRefiList.length == 1
        ) {
          component.set("v.isError", true);
          component.set(
            "v.errorMessage",
            "There is already an active XpressRefi record exist for this account."
          );
          component.set("v.isContinueDisabled", true);
          isError = true;
        } else if (
          ActiveMortgages.xPressRefiList.length <= 0 ||
          ActiveMortgages.xPressRefiList.length == undefined
        ) {
          component.set("v.isError", true);
          component.set("v.errorMessage", "No Active Mortgages Exist");
          component.set("v.isContinueDisabled", true);
          isError = true;
        } else if (isABTQualified != undefined && !isError && !isABTQualified) {
          component.set("v.isError", true);
          var errormessage = result.NotABTQualifiedMessage;
          component.set("v.errorMessage", errormessage);
          component.set("v.isContinueDisabled", true);
          isError = true;
        } else if (isFullAddressMatch != undefined && !isError && !isFullAddressMatch) {
          stageComponenttoLoad = Stages[1].Stage_Component__c;
          isError = false;
        } else if (isFullAddressMatch != undefined && !isError && isFullAddressMatch) {
          stageComponenttoLoad = Stages[2].Stage_Component__c;
          component.set("v.ContinueButtonName", "Submit");
          isError = false;
        }

        if (ActiveMortgages.xPressRefiList.length > 1) {
          isMultipleMortgages = true;
          component.set("v.isMultipleMortgages", isMultipleMortgages);
          component.set(
            "v.PendingXpressRefiAccountId",
            result.PendingXpressRefiAccountId
          );
          stageComponenttoLoad = Stages[0].Stage_Component__c;
        } else {
          isMultipleMortgages = false;
          component.set("v.isMultipleMortgages", isMultipleMortgages);
          component.set(
            "v.xPressRefiRecord",
            ActiveMortgages.xPressRefiList[0]
          );
        }

        if (!isError) {
          component.set(
            "v.MembershipAddressDetails.MembershipAddress1",
            ActiveMortgages.MembershipAddress1
          );
          component.set(
            "v.MembershipAddressDetails.MembershipAddress2",
            ActiveMortgages.MembershipAddress2
          );
          component.set(
            "v.MembershipAddressDetails.MembershipCity",
            ActiveMortgages.MembershipCity
          );
          component.set(
            "v.MembershipAddressDetails.MembershipState",
            ActiveMortgages.MembershipState
          );
          component.set(
            "v.MembershipAddressDetails.MembershipZip",
            ActiveMortgages.MembershipZip
          );
          $A.createComponent(
            "c:" + stageComponenttoLoad,
            {
              recordId: component.get("v.recordId"),
              xPressRefiRecord: component.get("v.xPressRefiRecord"),
              MembershipAddressDetails: component.get(
                "v.MembershipAddressDetails"
              ),
              xPressRefiRecordList: ActiveMortgages.xPressRefiList,
              xRefiEligibleLoanIds: component.get("v.xRefiEligibleLoanIds")
            },
            function (msgBox) {
              if (component.isValid()) {
                var targetCmp = component.find("ModalDialogPlaceholder");
                var body = targetCmp.get("v.body");
                body.push(msgBox);
                targetCmp.set("v.body", body);
              }
            }
          );
        }
      }
    });
    $A.enqueueAction(action);
  },

  cancelAction: function (component, event, helper) {
    $A.get("e.force:closeQuickAction").fire();
    component.find("overlayLib").notifyClose();
  },

  Continue: function (component, event, helper) {
    debugger;
    helper.showSpinner(component);
    var stages = [];
    var isError = false;
    stages = component.get("v.xPressRefiStageDetails");

    var ActiveStepIndex = component.get("v.ActiveStepIndex");

    if (ActiveStepIndex == 1) {
      var isLoanPrimaryResidence = component.get("v.isLoanPrimaryResidence");
      //  if(isLoanPrimaryResidence != undefined && isLoanPrimaryResidence){
      component.set("v.ContinueButtonName", "Submit");
      //  }
      //  else if(isPrimaryResidence != undefined){
      //   component.set("v.isError", true);
      //   isError=true;
      //   component.set("v.errorMessage", "Property does not qualify, must be primary residence");
      //  }
      if (isLoanPrimaryResidence == undefined) {
        alert("Please Select one of the options.");
        helper.hideSpinner(component);
        return;
      }
    } else if (
      ActiveStepIndex == 2 &&
      component.get("v.ContinueButtonName") == "Submit"
    ) {
      if (component.get("v.xPressRefiRecord.Is_Mortgage_Cadence__c") == false) {
        ActiveStepIndex = 3;
      }
      var NewProductType = component.get(
        "v.xPressRefiRecord.New_Product_Type__c"
      );
      var IsChevronEmployeeBoolean = component.get(
        "v.xPressRefiRecord.Is_Chevron_Employee__c"
      );
      var IsPrimaryResidenceBoolean = component.get(
        "v.xPressRefiRecord.Is_Primary_Residence__c"
      );
      var IsChevronRelocationBoolean = component.get(
        "v.xPressRefiRecord.Is_Relocation_Loan__c"
      );
      var Income = component.get("v.xPressRefiRecord.Income__c");

      if (Income == undefined) {
        alert("Please Enter Income Amount.");
        helper.hideSpinner(component);
        return;
      } else if (
        IsChevronRelocationBoolean == true &&
        IsChevronEmployeeBoolean == undefined &&
        IsPrimaryResidenceBoolean == true
      ) {
        alert("Please answer Chevron Relocation question.");
        helper.hideSpinner(component);
        return;
      } else if (
        NewProductType == undefined ||
        NewProductType == null ||
        NewProductType == ""
      ) {
        alert("Please Select Product.");
        helper.hideSpinner(component);
        return;
      } else if (
        component.get("v.xPressRefiRecord.Is_Mortgage_Cadence__c") == true ||
        ActiveStepIndex == 4
      ) {
        helper.saveXpressRefiData(component, event);
        component.set("v.ContinueButtonName", "Continue");
        return;
      }
    } else if (ActiveStepIndex == 4) {
      var isVestingChanged = component.get(
        "v.xPressRefiRecord.Is_Vesting_Info_Changed__c"
      );
      var isVestingTrust = component.get(
        "v.xPressRefiRecord.Is_Vesting_Info_Trust__c"
      );

      if (isVestingChanged == undefined || isVestingTrust == undefined) {
        alert("Please Answer All Questions.");
        helper.hideSpinner(component);
        return;
      }
    } else {
      component.set("v.ContinueButtonName", "Continue");
    }
    if (ActiveStepIndex == 0) {
      var SelectedAccount = component.get(
        "v.xPressRefiRecord.LoanId__c"
      );
      var pendingAccountIds = component.get("v.PendingXpressRefiAccountId");
      if (pendingAccountIds!= undefined && pendingAccountIds.indexOf(SelectedAccount) != -1) {
        $A.createComponent(
          "c:" + stages[0].Stage_Component__c,
          {
            recordId: component.get("v.recordId"),
            xPressRefiRecord: component.get("v.xPressRefiRecord"),
            isLoanPrimaryResidence: component.get("v.isLoanPrimaryResidence"),
          },
          function (msgBox) {
            if (component.isValid()) {
              var targetCmp = component.find("ModalDialogPlaceholder");
              var body = targetCmp.get("v.body");
              body.splice(0, 1, "");
              targetCmp.set("v.body", body);
              helper.hideSpinner(component);
              component.set("v.isError", true);
              component.set(
                "v.errorMessage",
                "There is already an active XpressRefi record exist for this account."
              );
              component.set("v.isContinueDisabled", true);
              isError = true;
              return;
            }
          }
        );
      }
    }

    if (!isError) {
      if (ActiveStepIndex == 4) {
        helper.saveXpressRefiData(component, event);
        component.set("v.ContinueButtonName", "Continue");
        return;
      } else {
        $A.createComponent(
          "c:" + stages[ActiveStepIndex + 1].Stage_Component__c,
          {
            recordId: component.get("v.recordId"),
            xPressRefiRecord: component.get("v.xPressRefiRecord"),
            isLoanPrimaryResidence: component.get("v.isLoanPrimaryResidence"),
          },
          function (msgBox) {
            if (component.isValid()) {
              var targetCmp = component.find("ModalDialogPlaceholder");
              var body = targetCmp.get("v.body");
              body.splice(0, 1, msgBox);
              targetCmp.set("v.body", body);
              helper.hideSpinner(component);
            }
          }
        );
      }
    } else {
      component.set("v.isContinueDisabled", true);
      $A.createComponent(
        "c:" + stages[ActiveStepIndex].Stage_Component__c,
        { recordId: component.get("v.recordId") },
        function (msgBox) {
          if (component.isValid()) {
            var targetCmp = component.find("ModalDialogPlaceholder");
            var body = targetCmp.get("v.body");
            body.splice(0, 1, "");
            targetCmp.set("v.body", body);
            helper.hideSpinner(component);
          }
        }
      );
    }
  },

  getActionValue: function (component, event) {
    var ActiveStepIndex = event.getParam("ActiveStepIndex");
    if (ActiveStepIndex != undefined) {
      component.set("v.ActiveStepIndex", ActiveStepIndex);
      component.set("v.isContinueDisabled", false);
    }

    var isLoanPrimaryResidence = event.getParam("isLoanPrimaryResidence");
    if (isLoanPrimaryResidence != undefined) {
      component.set("v.isLoanPrimaryResidence", isLoanPrimaryResidence);
    }

    var xPressRefiRecord = event.getParam("xPressRefiRecord");
    if (xPressRefiRecord != undefined)
      component.set("v.xPressRefiRecord", xPressRefiRecord);
  },
});