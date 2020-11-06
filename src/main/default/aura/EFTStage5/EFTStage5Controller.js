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
        if(component.get("v.EFTRecord.Share_Loan_Id__c").substring(0,2) == "28")
        {
            component.find("Day_of_Month__c").set("v.value","1");
            component.set("v.isDayOfMonthDisabled",true);            
        }
        else{
            component.set("v.isDayOfMonthDisabled",false); 
        }   

        var evt = $A.get("e.c:EFTEvent");
        var MonthDay = component.get("v.EFTRecord.Day_of_Month__c");
        if (MonthDay != undefined) {
            evt.setParams({ EFTRecord: component.get("v.EFTRecord") });
            evt.fire();
        }
        //helper.getDaysPicklist(component, event);
        //component.find("Day_of_Month__c").set("v.value","");
         //component.find("Day_of_Month__c").set("v.value", component.get('v.EFTRecord.Day_of_Month__c'));
       
	},
    
    onMonthChange : function(component, event, helper) {
         debugger;        
        
       if(event.getSource().get("v.class") == "effectivedate"){
            helper.CheckValidEffectiveDate(component, event,event.getSource().get("v.value"));            
        }

        helper.getEFTPaymentDate(component, event);       
        
    }
})