({  
    
    doInit : function( component, event, helper ) {    
        
        debugger;
        var wtid=component.get('v.recordId');
        let action = component.get("c.CheckOwner");  
        action.setParams({  
            wtid: wtid
        });  
        action.setCallback(this, function(response) {  
            let state = response.getState();  
            if ( state === "SUCCESS" ) {  
                component.set('v.wireDetails',response.getReturnValue());
            }  else {
                
                let showToast = $A.get( "e.force:showToast" );
                showToast.setParams({
                    title : 'Testing Toast!!!',
                    message : 'Record Not Saved due to error.' ,
                    type : 'error',
                    mode : 'sticky',
                    message : 'Some error occured'
                });
                showToast.fire();
            }
        });  
        $A.enqueueAction( action );         
    }
    
})