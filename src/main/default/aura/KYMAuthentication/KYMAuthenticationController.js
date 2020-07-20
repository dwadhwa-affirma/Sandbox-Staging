({
	doInit : function(component, event, helper) {
		
	},
    
    onChange: function (component, event, helper) {
    	var selectedPicklistValue =  component.get("v.selectedKYMvalue");
       component.set("v.selectedKYMvalue", selectedPicklistValue);
        var element;
        var errorElement = document.getElementById('errorSpan');
        element = component.find("Otherreason");
        if(selectedPicklistValue == 'Other'){       
        	
        	$A.util.addClass(element, 'show');
        	$A.util.removeClass(element, 'hidden');
        	errorElement.classList.remove('show');
			errorElement.classList.add('hidden');
        	
        }
        else if(selectedPicklistValue == 'Select')
        {
        	errorElement.classList.add('show');
			errorElement.classList.remove('hidden');
			$A.util.removeClass(element, 'show');
        	$A.util.addClass(element, 'hidden');
        }
        
        else{
        
        	$A.util.removeClass(element, 'show');
        	$A.util.addClass(element, 'hidden');
        	errorElement.classList.remove('show');
			errorElement.classList.add('hidden');
        }
    },
    
    saveKYMLog: function(component, event, helper) {
    	
      
	  	var reason =  component.get("v.selectedKYMvalue");
	  	var element = document.getElementById('errorSpan');
	  	var InputElement='';
	  	if(reason == 'Select'){
	  		
	  		
	  		element.classList.add('show');
	  		element.classList.remove('hidden');
	  		
	  		
	  		 }
	  	else if(reason == 'Other'){
	  		 InputElement = component.find("Otherreason").get("v.value");	  		
	  		var errorSpaninput = document.getElementById('errorSpaninput');
	  			if(InputElement == ''){
	  				
	  				errorSpaninput.classList.add('show');
				    errorSpaninput.classList.remove('hidden');
	  			}
	  			else
	  			{
	  				errorSpaninput.classList.remove('show');
				    errorSpaninput.classList.add('hidden');
				    helper.saveMethod(component, event, reason, element, InputElement);
	  			}
	  			
	  		
	  	}
	  	else{
	  			helper.saveMethod(component, event, reason, element, InputElement);
	  				
			   	}
    },
})