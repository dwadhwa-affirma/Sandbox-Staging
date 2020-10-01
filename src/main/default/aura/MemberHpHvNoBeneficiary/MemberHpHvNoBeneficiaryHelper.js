({
    GetData : function(component, event, helper, RecordId) {
        debugger;
		var action = component.get("c.getData");
            //action.setParams({"LogId": LogId});
            component.set('v.columns', [
                {label: 'Account Name', fieldName: 'URL', type: 'url',typeAttributes: { 
                    label: {
                        fieldName: 'Name'
                    },
                    target: '_self' 
                }},
                    {label: 'Member Branch', fieldName: 'Member_Branch__c', type: 'text'},
                    {label: 'Phone', fieldName: 'Phone', type: 'Phone'},
                    {label: 'High Value Flag', fieldName: 'High_Value_Flag__c', type: 'text'}
                ]);
		    action.setCallback(this, function (response) {
			var status = response.getState();            
				if (component.isValid() && status === "SUCCESS") {                        
                        var result = response.getReturnValue();
                        if(result.length > 0){
                            // set listViewResult attribute with response
                            
                            result.forEach(function(item) {
                                item['URL'] = '/lightning/r/Account/' + item['Id'] + '/view';
                            });
                            component.set("v.listViewResult",result);
                               
                        }   
                }
            });
            $A.enqueueAction(action); 
    }
})
