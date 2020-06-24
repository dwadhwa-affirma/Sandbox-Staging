({
	doInit : function(component, event, helper) {
	
		var action = component.get("c.getMembers");
		var recordId = component.get("v.recordId");
		//var EFTRecord = component.get("v.EFTRecord");		
		
		action.setParams({
			"recordId": recordId
		});			
		action.setCallback(this, function(resp) {
			var state=resp.getState();			
			if(state === "SUCCESS"){
				var result =  resp.getReturnValue();
				result.sort(helper.Sort);
				for(var i=0;i<result.length;i++){
					var tt = result[i].TypeTranslate__c.substring(5);
					result[i].TypeTranslate__c = tt;
				}
				
	        	component.set('v.paList', result);							
			}
		});
		
		$A.enqueueAction(action);
		
	},
    onRadioChange: function (component, event, helper) {
        var changeValue = event.getParam("value");
        var childRadio = document.getElementById('childRadio');
        if(changeValue == '2'){
        	component.set("v.ActionDisabled",false);    
            childRadio.classList.remove('disable');
            component.set("v.selectedAction",'2');
            
        }
        if(changeValue == '1'){
        	component.set("v.ActionDisabled",true);    
            childRadio.classList.add('disable');
            component.set("v.EFTRecord.Action_Type__c",'Create');
            component.set("v.EFTRecord.Stage__c",'Action');
            component.set("v.selectedAction",'1');
        }
        
        var evt = $A.get("e.c:EFTEvent");
        var EFT = component.get("v.EFTRecord");
         var isMemberSelected = component.get("v.isMemberSelected");
        
		if(EFT != undefined){
            evt.setParams({ "EFTRecord": EFT , "isMemberSelected": isMemberSelected});
            evt.fire();
        }
        
        
    },
    
    onOperationSelect: function (component, event, helper) {
    	 var changeValue = event.getParam("value");
       
        if(changeValue == '3'){        	 
        	component.set("v.EFTRecord.Action_Type__c",'View');
        	component.set("v.selectedChildAction",'3');          
        }
        if(changeValue == '4'){        	 
        	component.set("v.EFTRecord.Action_Type__c",'Update');
        	component.set("v.selectedChildAction",'4');              
        }
         if(changeValue == '5'){        	 
        	component.set("v.EFTRecord.Action_Type__c",'Expire');
        	component.set("v.selectedChildAction",'5');              
        }
        component.set("v.EFTRecord.Stage__c",'Action');       
       
        
        var evt = $A.get("e.c:EFTEvent");
        var EFT = component.get("v.EFTRecord");
        var isMemberSelected = component.get("v.isMemberSelected");
        
		if(EFT != undefined){
            evt.setParams({ "EFTRecord": EFT, "isMemberSelected": isMemberSelected});
            evt.fire();
        }
    
    },
    
    onMemberChange: function (component, event, helper) {
    	var MemberName = event.getSource().get('v.value');    
    	component.set("v.EFTRecord.Member_Name__c",MemberName);
    	
    	var evt = $A.get("e.c:EFTEvent");
        var EFT = component.get("v.EFTRecord");
        var isMemberSelected = component.get("v.isMemberSelected");
        
		if(EFT != undefined){
            evt.setParams({ "EFTRecord": EFT, "isMemberSelected": isMemberSelected});
            evt.fire();
        }
    }
  
})