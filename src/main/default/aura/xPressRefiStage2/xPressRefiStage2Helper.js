({
    getProductList : function(component, event) {
        debugger;
        var action = component.get("c.getAllProductDetails1");       
		var xPressRefiRecord  = component.get("v.xPressRefiRecord");
        var isReloDiscountApplied  = false;
        var isLoanPrimaryResidence = component.get("v.isLoanPrimaryResidence");

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

    adjustDiscountRates : function(component, event, isReloDiscountApplied){
        debugger;
        var action = component.get("c.getAllProductDetails1");       
		var xPressRefiRecord  = component.get("v.xPressRefiRecord");
        var isReloDiscountApplied  = isReloDiscountApplied;
        var isLoanPrimaryResidence = component.get("v.isLoanPrimaryResidence");

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
    }
})