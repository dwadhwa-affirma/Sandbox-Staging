({
	 doInit : function (component, event) {        
       
      
      //  if( window.MemberAuthInitialized == undefined)
     //   {
           
              var utilityBarAPI = component.find("utilitybar");
          var eventHandler = function(response){
            
                //  window.open("/lightning/n/Verification");
            
                // To Close or Hide a Global Quick Action Lightning Component popup 
                //window.location.reload();
                var evt = $A.get("e.force:navigateToComponent");
		        console.log('Event '+evt);
		       
		        var AccountNumber = component.get("v.searchText");
		        evt.setParams({
		            componentDef  : "c:LightningVerification" ,
		            componentAttributes : {
		               
		            }
		        
		        });
      
		        evt.fire();
                window.MemberAuthInitialized = true;
               var dismissActionPanel = $A.get("e.force:closeQuickAction");   
               dismissActionPanel.fire();
            };
            
      
            utilityBarAPI.onUtilityClick({ 
                eventHandler: eventHandler 
            }).then(function(result){
               
               //  window.open("/lightning/n/Verification");
                 var evt = $A.get("e.force:navigateToComponent");
		        console.log('Event '+evt);
		       
		        var AccountNumber = component.get("v.searchText");
		        evt.setParams({
		            componentDef  : "c:LightningVerification" ,
		            componentAttributes : {
		               
		            }
		        
		        });
      
		        evt.fire();
             //   window.MemberAuthInitialized = true;
                var dismissActionPanel = $A.get("e.force:closeQuickAction");   
                dismissActionPanel.fire();
            }).catch(function(error){
                
            });
       // }
                
        
		       
    
        
    },
})