({
	getAccounts : function(component) {		
		var action = component.get("c.getMemberAccounts");		
		var firstname = component.get("v.FirstName");	
		var lastname = component.get("v.LastName");
		var ssn = component.get("v.SSNNumber");
		var city = component.get("v.ResidentialCity");
		var state = component.get("v.ResidentialState");
		component.set("v.loading", true);
		component.set("v.NoRecordAccountDetails", false);		
		component.set("v.NoRecordAccounts", false);		
	    action.setParams({
	    	"firstnameQuery" : firstname,
	    	"lastnameQuery" : lastname,
	    	"SSNLast4Query" : ssn,
	    	"memberCityQuery" : city,
	    	"memberStateQuery" : state
	    });
	    
	    action.setCallback(this, function(response){	    	    	
	        var state = response.getState();
	        if (state === "SUCCESS") {
	            var result =  response.getReturnValue();	            
	            component.set("v.accounts", result);		
	            	            
	            if(result.length > 0){	                  	
                	component.set("v.NoRecordAccounts", false);
                }
                else
                {                  
                	component.set("v.NoRecordAccounts", true);
                }                		
	        }	        
	        component.set("v.loading", false);
	        
	    });
	    
	    $A.enqueueAction(action);
	},
	
	getAccountDetails : function(component){
		var action = component.get("c.getAccountDetails");		
		var membernumber = component.get("v.MemberNumber");	
		var cardname = component.get("v.CardName");
		var cardnumber = component.get("v.CardNumber");
		var vinnumber = component.get("v.VINNumber");
		var loannumber = component.get("v.LoanNumber");
		var propertyaddress = component.get("v.PropertyAddress");
		var propertycity = component.get("v.PropertyCity");
		var propertystate = component.get("v.PropertyState");
		var propertyzip = component.get("v.PropertyZip");
		
		component.set("v.loading", true);		
		
	    action.setParams({
	    	"MembernumberQuery" : membernumber,
	    	"CardnameQuery" : cardname,
	    	"CardnumberQuery" : cardnumber,
	    	"VINQuery" : vinnumber,
	    	"LoannumberQuery" : loannumber,
	    	"PropertyAddressQuery" :propertyaddress ,
	    	"PropertyCityQuery" :propertycity,
	    	"PropertyStateQuery" :propertystate,
	    	"PropertyZipQuery" :propertyzip
	    });
	    
	    component.set("v.NoRecordAccounts", false);	   
	    component.set("v.NoRecordAccountDetails", false); 
	    action.setCallback(this, function(response){	    	    	
	        var state = response.getState();
	        if (state === "SUCCESS") {
	            var result =  response.getReturnValue();
	            component.set("v.accDetails", result);
	            if(result.length > 0){	            
                component.set("v.NoRecordAccountDetails", false);
                }
                else
                {
                	component.set("v.NoRecordAccountDetails", true);
                }
                				
	        }
	        component.set("v.loading", false);	        
	    });
	    
	    $A.enqueueAction(action);
	}
})