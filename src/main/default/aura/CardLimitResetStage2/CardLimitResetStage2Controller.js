({
	doInit : function(component, event, helper) {
	    
		var action = component.get("c.getCard");
		var recordId = component.get("v.recordId");
		var CLRecord = component.get("v.CLRecord");
        var memberName = CLRecord.Member_Name__c;
        var evt = $A.get("e.c:CardLimitResetEvent");
        action.setParams({
			"recordId": recordId,
            "sObjectType": memberName
		});			
		action.setCallback(this, function(resp) {
			var state=resp.getState();			
			if(state === "SUCCESS"){
				var result =  resp.getReturnValue();
                
                if(result != undefined){
                    
                    if(result.CardList != undefined && result.CardList != ''){
                    	evt.setParams({ "CLRecord": CLRecord, "isMemberSelected": true});
            			evt.fire();
                        component.set('v.CardListMap', result.CardList);
                    }
                    
                    if(result.DormantCardList != undefined && result.DormantCardList != ''){
                    	component.set('v.CardListMap', result.DormantCardList);
                        component.set("v.IsDormant", true);
                    }
                    
                	if((result.DormantCardList == undefined || result.DormantCardList == '') &&
                       (result.CardList == undefined || result.CardList == '')){
                		component.set("v.Empty", true);
                	}
                    
                }
			}
		});
		
		$A.enqueueAction(action);
		
	},
    
    onCardChange: function (component, event, helper) {
    	var SelectedCardNumber = event.getSource().get('v.value');
        var SelectedCardLocator;
        
        var map=component.get('v.CardListMap');
        for(var i=0;i<map.length;i++){
        	if(map[i].CardNumber == SelectedCardNumber){
            	SelectedCardLocator = map[i].CardLocator;  
                break;
            }
        }
    	component.set("v.CLRecord.Card_Number__c",SelectedCardNumber);
        component.set("v.CLRecord.Card_Locator__c",SelectedCardLocator);
    	
    	var evt = $A.get("e.c:CardLimitResetEvent");
        var CL = component.get("v.CLRecord");
        var isMemberSelected = component.get("v.isMemberSelected");
        
        
        if(CL != undefined){
            evt.setParams({ "CLRecord": CL, "isMemberSelected": isMemberSelected});
            evt.fire();
    	}
    }
  
})