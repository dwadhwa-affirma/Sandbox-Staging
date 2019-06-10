({
	handleError: function(component, event, helper){
		 var MemberName = helper.isEmpty(component,"selectmembername", helper);
		 if(!MemberName)
        {
        	isValid = false;        	
        }        
        
        return isValid; 
	
	},
	
	isEmpty: function(component, fieldName, helper)
    {
    	var inputCmp = component.find(fieldName);
    	var value = inputCmp.get("v.value");
    	var isValid = true;
    	if(value == '' || value == undefined || value == '---None---'){
        	inputCmp.set("v.errors", [{message:"Complete this field"}]);
        	isValid = false;
        }
        else
        {
        	inputCmp.set("v.errors", null);
        }
        
        return isValid;
    	
    },
})