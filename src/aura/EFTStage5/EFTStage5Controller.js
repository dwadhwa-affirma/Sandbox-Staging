({
	doInit : function(component, event, helper) {
		var type = component.get('v.ShareLoanType').split(',')[1];
        if(type != 'Loan'){
            component.set('v.isLoan', false);
        }
       
	},
    
    onMonthChange : function(component, event, helper) {
         debugger;
        var evt = $A.get("e.c:EFTEvent");
        var PaymentAmt = component.get("v.eftObject2.Payment_Amount__c");
        var AlternateAmt = component.get("v.eftObject2.Alternate_Amount__c");
        var EffectiveDate = component.get("v.eftObject2.Effective_Date__c");
        var Frequency = component.get('v.eftObject2.Frequency__c');
         var MonthDay = component.get('v.eftObject2.Day_of_Month__c');
        
		if(MonthDay != undefined){
            evt.setParams({ "PaymentAmt": PaymentAmt , 
                          "AlternateAmt": AlternateAmt,
                          "EffectiveDate": EffectiveDate,
                          "Frequency": Frequency,
                          "MonthDay": MonthDay});
            evt.fire();
        }
    }
})