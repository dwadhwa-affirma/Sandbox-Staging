({
	helperMethod : function() {
		
	},
	
	handleError : function(component, event, helper){
        
               
       var ownertypevalue = component.find("ownertype").get("v.value");
        var isValid = true;
       
	       if(ownertypevalue == 'Queue')
	       {
	    	   var queuename = helper.isEmpty(component,"queuename", helper);
	    	   if(!queuename )
	    	   {
	    		   isValid = false; 
	    	   }
	       }
	       else if(ownertypevalue == 'User')
	       {
	    	   var userOwner = helper.isEmpty(component,"userOwner", helper);
	    	  
	    	   if(!userOwner)
	    	   {
	    		    isValid = false;
	    		    var controlId = 'userOwner' + 'Control';
	    		    var control = document.getElementById(controlId);
		        	if(control != null && control != undefined)
		        	{
			        	control.classList.add('errorForce');   
			        	var controlErrorId = 'userOwner' + 'Error';     	
			        	var controlError = document.getElementById(controlErrorId);
			        	controlError.style = '';
		        	}
		        	
	    		   
	    	   }
	    	   else
	    	   {	
	    		   
	    		   var controlId = 'userOwner' + 'Control';
	    		    var control = document.getElementById(controlId);
		        	if(control != null && control != undefined)
		        	{
			        	control.classList.remove('errorForce');   
			        	var controlErrorId = 'userOwner' + 'Error';     	
			        	var controlError = document.getElementById(controlErrorId);
			        	if(controlError != null)
			        	{
			        		controlError.style = 'display:none;';
			        	}
		        	}
	    		   
	    	   }
	    	   
	    	   
	       }
	       
       
	       return isValid;   
   },    
      
    
    isEmpty : function(component, fieldName, helper)
    {
    	var inputCmp = component.find(fieldName);
    	var value = inputCmp.get("v.value");
    	var isValid = true;
    	if(value == '' || value == undefined || value == '--- None ---'){
        	inputCmp.set("v.errors", [{message:"Complete this field"}]);
        	isValid = false;
        }
        else
        {
        	inputCmp.set("v.errors", null);
        }
        
        return isValid;
    	
    }
	
})