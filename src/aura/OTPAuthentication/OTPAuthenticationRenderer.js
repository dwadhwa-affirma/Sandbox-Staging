({
	rerender: function (component,helper) {
	    this.superRerender();
	    var OTPStatusForDay = component.get("v.OTPStatusForDay");
	    var element = document.getElementById('btnNext');
	    if(OTPStatusForDay ==  false)
	    {
	    			   
		    if(element != null){
		    	element.disabled = true;
		    }
		    
	    }
	    else
	    {
	    	if(element != null){
		    	element.disabled = false;
		    }
	    }
    },
    
   
})