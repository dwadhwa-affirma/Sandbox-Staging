({
      
    handleChanged: function(component, message, helper) { 
      if (message != null ) {
        console.log(JSON.stringify(message));
       
        component.find("overlayLib").notifyClose();  
      } else {
        console.log('message is null');
      }
    },
    
    
})