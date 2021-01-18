({
  getMultipleEFTShareLoanList: function (AccountNumber, component, event) {
    var action = component.get("c.GetMultipleEFTWarningRecords");

    action.setParams({
      AccountNumber: AccountNumber,
    });
    action.setCallback(this, function (resp) {
      var state = resp.getState();
      if (state === "SUCCESS") {
        debugger;
        var list = resp.getReturnValue();
        component.set("v.MultipleEFTWarningRecords", list);
        var eftlist = component.get("v.EFTRecordsList");

        for (var i = 0; i < eftlist.length; i++) {
          var tempid = eftlist[i].Share_Loan_Id__c;
          if (list.includes(tempid)) {
            eftlist[i].isDisabled = true;
            eftlist[i].Warning ="Use of ACH servicing is not allowed for this loan/share as it currently has multiple EFT records. To service this loan/share record, EFT changes needs to be made in Episys.";
		  }
		  else{
			eftlist[i].isDisabled = false;
            eftlist[i].Warning = ""; 
		  }
		}
		
		component.set("v.EFTRecordsList",eftlist);
      }
    });

    $A.enqueueAction(action);
  },
});