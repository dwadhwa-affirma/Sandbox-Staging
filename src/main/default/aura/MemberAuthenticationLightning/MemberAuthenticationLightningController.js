({
	 doInit : function (component, event) {   
	 
	          if( window.MemberAuthInitialized == undefined){
	        	  
		          var utilityBarAPI = component.find("MAAPUtilityBar");
		          var eventHandler = function(response){
	               
	              var evt = $A.get("e.force:navigateToComponent");
			        console.log('Event '+evt);		       
			       window.MemberAuthInitialized = true;
			        evt.setParams({
			            componentDef  : "c:LightningVerification" ,
			            componentAttributes : {
			                UtilityBarId: 'MAAPUtilityBar'
			            }
			        });
	      
			        evt.fire();
	              
	               var dismissActionPanel = $A.get("e.force:closeQuickAction");   
	               dismissActionPanel.fire();
	            };
            
            
            
	            utilityBarAPI.onUtilityClick({ 
	                eventHandler: eventHandler 
	            }).then(function(result){
	                
	            //   if (response.utilityVisible){
	              
	                var evt = $A.get("e.force:navigateToComponent");
	                console.log('Event '+evt);
			            window.MemberAuthInitialized = true; 
				        evt.setParams({
				            componentDef  : "c:LightningVerification" ,
				            componentAttributes : {
				               UtilityBarId: 'MAAPUtilityBar'
				            }
			        
			        	});
			        
			        evt.fire();
			     //   }
	                	var dismissActionPanel = $A.get("e.force:closeQuickAction");   
	                	dismissActionPanel.fire();
	            	}).catch(function(error){
	                
            	});
       
	          }       
    
        
    },
    

})