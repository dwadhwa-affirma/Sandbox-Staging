({
    doInit : function(component, event, helper) {
        component.set('v.columns', [
            {label: 'User Name',fieldName: 'Name',type:'text',initialWidth: 200},
            {label: 'Count', fieldName: 'Count',type:'number',initialWidth: 200},
            
            
        ]);
            var action = component.get('c.getTotalCount'); 
            action.setCallback(this, function(a){
                var state = a.getState(); // get the response state
                
                    if(state == 'SUCCESS') {
                        var obj = a.getReturnValue();
                        var result = JSON.parse(JSON.stringify(obj));
            			component.set('v.data',result );
                    }
                });
                $A.enqueueAction(action);    
                }
})