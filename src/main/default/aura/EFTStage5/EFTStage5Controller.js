({
	doInit : function(component, event, helper) {
        debugger;       
		var type = component.get('v.EFTRecord.EFT_ID_Type__c');//.split(',')[1];
		//component.set('v.isLoan', false);
        if(type != 'Loan' && component.get("v.EFTRecord.Action_Type__c") == 'Create'){
            component.set('v.isLoan', false);
            component.set('v.EFTRecord.Frequency__c', 'Monthly');
            //component.set('v.EFTRecord.Payment_Amount__c', 0);
        }
        //helper.getDaysPicklist(component, event);
        //component.find("Day_of_Month__c").set("v.value","");
         //component.find("Day_of_Month__c").set("v.value", component.get('v.EFTRecord.Day_of_Month__c'));
       
	},
    
    onMonthChange : function(component, event, helper) {
         debugger;
        /*if(event.getSource().get("v.class") == "alternateamount"){
            var PaymentAmount = component.get("v.EFTRecord.Payment_Amount__c");
            var AlternateAmount= event.getSource().get("v.value");
            if(AlternateAmount <= PaymentAmount && AlternateAmount != "" && AlternateAmount != null){
                alert('Alternate Amount should be greater than Payment Amount');
                event.stopPropagation();
                component.set("v.EFTRecord.Alternate_Amount__c","");
                return;
            }
        }*/
        var evt = $A.get("e.c:EFTEvent");
        if(event.getSource().get("v.class") == "paymentamount"){
          // var PaymentAmt =new Intl.NumberFormat('en-US', { style: 'currency', currency: 'USD' }).format(component.get("v.EFTRecord.Payment_Amount__c")); 
             //component.set("v.EFTRecord.Payment_Amount__c",PaymentAmt);
        }
        
        var PaymentAmt = component.get("v.EFTRecord.Payment_Amount__c");
       
        var AlternateAmt = component.get("v.EFTRecord.Alternate_Amount__c");
        var EffectiveDate = component.get("v.EFTRecord.Effective_Date__c");
        var Frequency = component.get('v.EFTRecord.Frequency__c');
        var MonthDay = component.get('v.EFTRecord.Day_of_Month__c');
        var MonthDay2 = component.get('v.EFTRecord.Second_Day_of_Month__c');
        component.set("v.EFTRecord.Stage__c",'Payment Monthly');
        
		if(MonthDay != undefined){
            evt.setParams({ "EFTRecord": component.get("v.EFTRecord")});
            evt.fire();
        }
    }
})