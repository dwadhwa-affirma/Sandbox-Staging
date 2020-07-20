({
	doInit : function(component, event, helper) {
		var index=component.get("v.rowIndex");
		 helper.buildPicklist(component,index);
		 helper.fetchCountryData(component, index);
	},
	
	 AddNewRow : function(component, event, helper){
       // fire the AddNewRowEvt Lightning Event 
        component.getEvent("AddRowEvt").fire();     
    },
    
    removeRow : function(component, event, helper){
     // fire the DeleteRowEvt Lightning Event and pass the deleted Row Index to Event parameter/attribute
       component.getEvent("DeleteRowEvt").setParams({"indexVar" : component.get("v.rowIndex") }).fire();
    }, 
    
    
    
    ChangeDestination : function(component, event, helper){
    var index=component.get("v.rowIndex");
    var selVal=event.getSource().get("v.value");
     // fire the DeleteRowEvt Lightning Event and pass the deleted Row Index to Event parameter/attribute
     var allrows= document.getElementsByClassName("cDynamicRowDestination");
      var currentrow= allrows[index];        
       var countryspan = currentrow.getElementsByClassName("clsCountry");
        var statespan = currentrow.getElementsByClassName("clsState");
        if(selVal == 'Domestic'){
        	countryspan[0].style='display:none;';
        	statespan[0].style='';
        }
        else if(selVal == 'International'){
        	countryspan[0].style='';
        	statespan[0].style='display:none;';
        	 helper.buildPicklist(component,index);
        	helper.fetchCountryData(component, index);
        }
        else
        {
        	statespan[0].style='display:none;';
        	countryspan[0].style='display:none;';
        }
       
    }, 
       departureDateChange: function(component,event,helper){
   
	   var date = component.get("v.DepartureDate");
	   try
	   {
			var datestring = $A.localizationService.formatDate(date, "MM/DD/YY");
			component.set("v.travelDetailsInstance.Departure_Date__c", date);
					
			component.set("v.DepartureDate", datestring);
			if(date != undefined){		
			helper.validateRequired(component);
			
			}
	   }
	   catch{
		   component.set("v.DepartureDate",null);
	   }
	   
	   
		
   },
   
   ReturnDateChange: function(component,event,helper){
   
	   var date = component.get("v.ReturnDate");
	   try
	   {
		  
			var datestring = $A.localizationService.formatDate(date, "MM/DD/YY");	
			component.set("v.travelDetailsInstance.Return_Date__c", date);
			
			component.set("v.ReturnDate", datestring);
			if(date != undefined){		
			helper.validateRequired(component);

			}
		   
	   }
	   catch
	   {
	    component.set("v.ReturnDate",null);
		}
   },
   
   ChangeDestinationStateCountry : function(component, event, helper){
	   helper.validateRequired(component);
   }
})