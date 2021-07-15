({
  saveXpressRefiData: function (component, event) {
      debugger;
    var action = component.get("c.saveXpressRefiData");
    var XpressRefiRecord = component.get("v.xPressRefiRecord");
    var stages = [];    
    stages = component.get("v.xPressRefiStageDetails");
    var recordId = component.get("v.recordId");

    action.setParams({
      XpressRefiRecord: XpressRefiRecord,
      recordId: recordId
    });
    action.setCallback(this, function (resp) {
      var state = resp.getState();
      if (state === "SUCCESS") {
        var result = resp.getReturnValue(); 
        if(result["Error"] != undefined){
           alert(result["Error"]);
           component.set('v.isContinueDisabled',true);
           this.hideSpinner(component);
           return;
        }
        var XpressRefirecord = result.xPressRefiRecord; 
        component.set('v.xPressRefiRecord', XpressRefirecord);
        
        $A.createComponent(
          "c:" + stages[3].Stage_Component__c,
          {
            recordId: component.get("v.recordId") , xPressRefiRecord: XpressRefirecord 
          },
          function (msgBox) {
            if (component.isValid()) {
              var targetCmp = component.find("ModalDialogPlaceholder");
              var body = targetCmp.get("v.body");              
              body.splice(0, 1, msgBox);
              targetCmp.set("v.body", body);
            }
          }
          
        );
      }
      else{
          alert('There was an error while processing your request. Please Contact Admin.');
           component.set('v.isContinueDisabled',true);
           this.hideSpinner(component);
           return;
      }
      this.hideSpinner(component);
    });

    $A.enqueueAction(action);
  },

  showSpinner: function (component) {
    var spinnerMain = component.find("Spinner");
    $A.util.removeClass(spinnerMain, "slds-hide");
  },

  hideSpinner: function (component) {
    var spinnerMain = component.find("Spinner");
    $A.util.addClass(spinnerMain, "slds-hide");
  },
});