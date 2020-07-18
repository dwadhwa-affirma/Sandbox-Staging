({
    doInit : function(component, event, helper) {  
    	var newValue = component.get("v.ItemObject");    	
    	var columnTypes = component.get("v.ColumnType");
    	var columnIndex = component.get("v.ColumnIndex");    	
    	var ischildtable = component.get("v.IsChildTable");    	
    	if(newValue != undefined)
    	{    		
	        var fieldName = '';
	        var ObjectId = '';
	        var value = '';
	       
	        var currentFieldType = '';
	        if(columnTypes != undefined && columnIndex != undefined && ischildtable != "true")
	        {
	        	currentFieldType = columnTypes[columnIndex];	        	
	        	if(currentFieldType == "link" && component.get("v.FieldName").indexOf("|") > 0)
	        	{
	        		var fieldNames = component.get("v.FieldName").split("|");	        		
	        		ObjectId = fieldNames[0];
	        		fieldName = fieldNames[1];	        	
	        		component.set("v.mId", newValue[ObjectId]);
	        		component.set("v.IsLink", true);	        	
	        	}
	        	else
	        	{
                    fieldName = component.get("v.FieldName");
	        		component.set("v.IsLink", false);
	        	}
	        }           
	        else
	        {
	        	fieldName = component.get("v.FieldName"); 
	        	component.set("v.IsLink", false);
	        }
	       
	        if(fieldName != undefined && fieldName.indexOf('__r.') > 0 || fieldName.indexOf('.') > 0)
	        {	        
	        	var arrayname = fieldName.split('.');
	        	if(newValue[arrayname[0]] != undefined && newValue[arrayname[0]] != null)
	        		value = newValue[arrayname[0]][arrayname[1]];	        	    	
	        }
	        else
	        {  
	        	value = newValue[fieldName];	        	 	
	        }
            
            var datetime = new Date(value);
	        if(datetime.toString() != "NaN" && datetime != "Invalid Date" && currentFieldType != '' && currentFieldType == 'date')
	        {                
	        	value = helper.formatDate("MM/dd/yyyy",datetime);	        	
	        }
	        else if(datetime.toString() != "NaN" && datetime != "Invalid Date" && fieldName.indexOf("Date") > 0)
	        {
	        	value = helper.formatDate("MM/dd/yyyy hh:mm t",datetime);
	        	
	        	var usaTime = new Date(value).toLocaleString("en-US", {timeZone: "America/Los_Angeles"});
	        	usaTime = new Date(usaTime);
	        	var result = usaTime.toLocaleString();
				//console.log('USA time: '+usaTime.toLocaleString())
	        	
	        	/*var localTime = datetime.getTime();
	        	var localOffset = datetime.getTimezoneOffset() * 60000;
	        	var utc = localTime + localOffset;
	        	var offset = -8.0;   
	        	var convered = utc + (3600000*offset);
	        	datetime = new Date(convered); */
	        	value = helper.formatDate("MM/dd/yyyy hh:mm t",new Date(result));
	        }	       
	        component.set("v.FieldValue", value);
	       
        }   
	}  ,
	
	 ClickObj: function(component, event, helper) {  
	 var id = component.get("v.mId");
			var sObectEvent = $A.get("e.force:navigateToSObject");
		   					 sObectEvent .setParams({
		   					 "recordId": id,
		    				 "slideDevName": "view"
		   					});
	    					sObectEvent.fire(); 
	 }
    
    
})