({
	myAction : function(component, event, helper) {
		
	},
    // Default event call while page is lode
    doInit : function (component, event) {        
       
      
        if( window.MemberAuthInitialized == undefined)
        {
           
              var utilityBarAPI = component.find("utilitybar");
          var eventHandler = function(response){
            
                  document.location.href = "/apex/MemberAuthenticatedUtility";
            
                // To Close or Hide a Global Quick Action Lightning Component popup 
                //window.location.reload();
                window.MemberAuthInitialized = true;
               var dismissActionPanel = $A.get("e.force:closeQuickAction");   
               dismissActionPanel.fire();
            };
            
      
            utilityBarAPI.onUtilityClick({ 
                eventHandler: eventHandler 
            }).then(function(result){
               
                document.location.href = "/apex/MemberAuthenticatedUtility";
                
                window.MemberAuthInitialized = true;
                var dismissActionPanel = $A.get("e.force:closeQuickAction");   
                dismissActionPanel.fire();
            }).catch(function(error){
                
            });
        }
                
        
		       
    
        
    },   
   
   
    
})