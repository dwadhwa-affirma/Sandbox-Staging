({
    getStage2p5Note : function(component, event) {
        debugger;
        var action = component.get("c.getStage2p5Note");
        action.setCallback(this, function(resp) {
            var state=resp.getState();			
                if(state === "SUCCESS"){
                    var result = resp.getReturnValue(); 
                    var Note = result.Note;
                    component.set('v.Note', Note);  
                }
        });
        $A.enqueueAction(action);
    }
})