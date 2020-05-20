({
	// Your renderer method overrides go here
	unrender: function (component, event, helper) {
        debugger;
        //this.superUnrender();
      /*  var evt = $A.get("e.c:EFTEvent");
        var action = component.get("v.Action");
        //var isExit = component.get("v.isExit");        
		if(action != undefined){
            evt.setParams({ "Action": action});
            evt.fire();
        }
       /* if(action == undefined){          
            	alert('Please Select One Action');
           		return false;
            	var stgs = component.get("v.EFTStageDetails");
           		/*$A.createComponent("c:EFTStage1",{},
                            function(msgBox){                
                                 if (component.isValid()) {                                    
                                     var targetCmp = component.find('ModalDialogPlaceholder');
                                    var body = targetCmp.get("v.body");
                                    body.splice(0, 1, msgBox);
                                    //body.push(msgBox);
                                    targetCmp.set("v.body", body); 
               						return;
                                }
                            }
		       			 );
        	
        }*/        
        
        
	}
})