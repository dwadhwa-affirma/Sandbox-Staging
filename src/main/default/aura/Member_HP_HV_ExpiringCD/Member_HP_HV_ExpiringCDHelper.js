({
  GetData: function (component, event, helper, pageNumber, pageSize) {
    debugger;
    var action = component.get("c.getData");
    var MemberBranch = component.get("v.MemberBranch");
    var HighValueFlag = component.get("v.HighValueFlag");
    component.set("v.loading", true);
    action.setParams({
      MemberBranchQuery: MemberBranch,
      HighValueFlagQuery: HighValueFlag,
      pageNumber: pageNumber,
      pageSize: pageSize,
    });

    action.setCallback(this, function (response) {
      var status = response.getState();
      if (component.isValid() && status === "SUCCESS") {
        var resultData = response.getReturnValue();
        component.set("v.listViewResult", resultData.accountList);
        component.set("v.PageNumber", resultData.pageNumber);
        component.set("v.TotalRecords", resultData.totalRecords);
        component.set("v.RecordStart", resultData.recordStart);
        component.set("v.RecordEnd", resultData.recordEnd);
        component.set(
          "v.TotalPages",
          Math.ceil(resultData.totalRecords / pageSize)
        );
        if (resultData.accountList.length > 0) {          
            resultData.accountList.forEach(function (item) {
            item["URL"] = "/lightning/r/Account/" + item["Id"] + "/view";
          });
        }        
      }
      component.set("v.loading", false);
    });
    $A.enqueueAction(action);
    
  },
});
