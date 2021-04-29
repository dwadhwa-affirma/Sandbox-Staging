({
    getProductList : function(component, event) {
        debugger;
        var action = component.get("c.getAllProductDetails1");       
		var xPressRefiRecord  = component.get("v.xPressRefiRecord");
        var isReloDiscountApplied  = false;
        var isLoanPrimaryResidence = component.get("v.isLoanPrimaryResidence");
        component.set(
            "v.IsMaturityDateReset",
            "true"
          );
        component.set(
            "v.xPressRefiRecord.Is_Maturity_Date_Reset__c",
            false
          );
      
          var evt = $A.get("e.c:xPressRefiEvent");
      
          evt.setParams({ xPressRefiRecord: component.get("v.xPressRefiRecord") });
          evt.fire();

        action.setParams({
            "xpressrefiobj": xPressRefiRecord, 
            "isReloDiscountApplied" : isReloDiscountApplied,
            "isLoanPrimaryResidence" : isLoanPrimaryResidence            
            });			
            action.setCallback(this, function(resp) {
                var state=resp.getState();			
                if(state === "SUCCESS"){
                    var result = resp.getReturnValue(); 
                    var ProductList = result.ProductWrapperList;
                    var RatesUpdatedDate = result.RatesUpdatedDate;
                    var Note = result.Note;
                    for (var i = 0; i < ProductList.length; i++) {
                        var temp = parseFloat(component.get('v.xPressRefiRecord.P_I_Payment__c'));
                        var diff = temp - parseFloat((ProductList[i].TotalPIPayment));
                        if(true){
                            ProductList[i].MonthlySavings = diff;
                        }
                        else{

                        }
                        
                    }
                    component.set('v.ProductList', ProductList);
                    component.set('v.RatesUpdatedDate', RatesUpdatedDate);
                    component.set('v.Note', Note);                   
               }
               
            });
             
            $A.enqueueAction(action);
        

    },

    adjustDiscountRates : function(component, event, isReloDiscountApplied, isMaturityDateReset){
        debugger;
        var action = component.get("c.getAllProductDetails1");       
		var xPressRefiRecord  = component.get("v.xPressRefiRecord");
        var isReloDiscountApplied  = isReloDiscountApplied;
        var isLoanPrimaryResidence = component.get("v.isLoanPrimaryResidence");
        var isMaturityDateReset  = isMaturityDateReset;

        action.setParams({
            "xpressrefiobj": xPressRefiRecord, 
            "isReloDiscountApplied" : isReloDiscountApplied,
            "isLoanPrimaryResidence" : isLoanPrimaryResidence            
            });			
            action.setCallback(this, function(resp) {
                var state=resp.getState();			
                if(state === "SUCCESS"){
                    var result = resp.getReturnValue(); 
                    var ProductList = result.ProductWrapperList;
                    var RatesUpdatedDate = result.RatesUpdatedDate;
                    var Note = result.Note;
                    for (var i = 0; i < ProductList.length; i++) {
                        var temp = parseFloat(component.get('v.xPressRefiRecord.P_I_Payment__c'));
                        var diff = temp - parseFloat((ProductList[i].TotalPIPayment));
                        if(true){
                            ProductList[i].MonthlySavings = diff;
                        }
                        else{

                        }
                        
                    }
                    component.set('v.ProductList', ProductList); 
                    component.set('v.RatesUpdatedDate', RatesUpdatedDate);  
                    component.set('v.Note', Note);     
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
      }
})