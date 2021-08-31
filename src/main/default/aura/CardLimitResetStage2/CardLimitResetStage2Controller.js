({
	doInit : function(component, event, helper) {
	    
		var action = component.get("c.getCards");
        var recordId = component.get("v.recordId");
		var CLRecord = component.get("v.CLRecord");
        var memberName = CLRecord.Member_Name__c;
        var memberId = CLRecord.Member__c;
       
        var evt = $A.get("e.c:CardLimitResetEvent");
        evt.setParams({"isMemberSelected": false});
        evt.fire();
        var evt1 = $A.get("e.c:CardLimitResetEvent");
        if(recordId.startsWith("001")){
            component.set("v.objectname", "Account");
        }
        action.setParams({
			"recordId": recordId,
            "sObjectType": memberName,
            "memId" : memberId
		});			
		action.setCallback(this, function(resp) {
			var state=resp.getState();			
			if(state === "SUCCESS"){
				var result =  resp.getReturnValue();
                
                if(result != undefined){
                    
                    if(result.CardList != undefined && result.CardList != ''){
                    	evt1.setParams({"isMemberSelected": true});
            			evt1.fire();
                        
                        var arrayMapKeys = [];
                        for(var key in result.CardList){
                            arrayMapKeys.push({key: key, value: result.CardList[key]});
                        }
                        
                        component.set("v.mapValues", arrayMapKeys);
                        //component.set('v.CardListMap', result.CardList);
                    }
                    
                    if(result.DormantCardList != undefined && result.DormantCardList != ''){
                        evt1.setParams({"isMemberSelected": true});
            			evt1.fire();
                        
                        var arrayMapKeys = [];
                        for(var key in result.DormantCardList){
                            arrayMapKeys.push({key: key, value: result.DormantCardList[key]});
                        }
                        
                        component.set("v.mapValues", arrayMapKeys);
                        //component.set('v.CardListMap', result.DormantCardList);
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
        var clist = component.get("v.CardList");
       
        var SelectedCardLocator;
        var SelectedAccountNumber;
        var CL = component.get("v.CLRecord");
        var evt = $A.get("e.c:CardLimitResetEvent");
        var isMemberSelected = component.get("v.isMemberSelected");
        
        var action = component.get("c.getCardDetails");
        var recordId = component.get("v.recordId");
		var CLRecord = component.get("v.CLRecord");
        
        var memberName = CLRecord.Member_Name__c;
        
        /*if(event.getSource().get('v.checked') == false && clist.length != 0){
            for(var i=0;i<clist.length;i++){
                if(clist[i].Card_Number__c == SelectedCardNumber){
                    clist.splice(i,1);
                }
            }                      
        }*/
	    
        if(event.getSource().get('v.checked') != false){
            helper.showSpinner(component);
            action.setParams({
                "recordId": recordId,
                "sObjectType": memberName,
                "SelectedCardNumber":SelectedCardNumber
            });
            
            action.setCallback(this, function(resp) {
                var state=resp.getState();			
                if(state === "SUCCESS"){
                    var result =  resp.getReturnValue();
                    if(result != undefined){
                        if(result.CardList != undefined && result.CardList != ''){
                            component.set('v.CardListMap', result.CardList);
                        }
                        var map=component.get('v.CardListMap');
                    
                        for(var i=0;i<map.length;i++){
                            if(map[i].CardNumber == SelectedCardNumber){
                                SelectedCardLocator = map[i].CardLocator;
                                SelectedAccountNumber = map[i].AccountNumber;
                                break;
                            }
                        }
                        component.set("v.CLRecord.Card_Number__c",SelectedCardNumber);
                        component.set("v.CLRecord.Card_Locator__c",SelectedCardLocator);
                        component.set("v.CLRecord.Member_Number__c",SelectedAccountNumber);
                        //var acc = {Card_Number__c: SelectedCardNumber, Card_Locator__c: SelectedCardLocator, Member_Number__c: SelectedAccountNumber};
                        //clist.push(acc);
                        //component.set("v.CardList", clist);
                       
                        if(SelectedAccountNumber != undefined){
                            //evt.setParams({ "CLRecord": CLRecord, "isMemberSelected": isMemberSelected, "CLRecord2": component.get("v.CardList")});
                            evt.setParams({ "CLRecord": CLRecord, "isMemberSelected": isMemberSelected});
                            evt.fire();
                        }
                        helper.hideSpinner(component);
                        
                    }
                }
            });
            
            $A.enqueueAction(action);
        }   
       
    }
  
})