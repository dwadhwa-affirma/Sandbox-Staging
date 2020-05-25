({
	doInit : function(component, event, helper) {
        debugger;       
		var type = component.get('v.EFTRecord.EFT_ID_Type__c');//.split(',')[1];
        if(type != 'Loan'){
            component.set('v.isLoan', false);
            component.set('v.EFTRecord.Frequency__c', 'Monthly');
        }
        
       
	},
    
    onMonthChange : function(component, event, helper) {
         debugger;
        var evt = $A.get("e.c:EFTEvent");
        var PaymentAmt = component.get("v.EFTRecord.Payment_Amount__c");
        var AlternateAmt = component.get("v.EFTRecord.Alternate_Amount__c");
        var EffectiveDate = component.get("v.EFTRecord.Effective_Date__c");
        var Frequency = component.get('v.EFTRecord.Frequency__c');
         var MonthDay = component.get('v.EFTRecord.Day_of_Month__c');
        component.set("v.EFTRecord.Stage__c",'Payment Monthly');
        
		if(MonthDay != undefined){
            evt.setParams({ "EFTRecord": component.get("v.EFTRecord")});
            evt.fire();
        }
    }
})