public class clspicklist{    
  
  
    public static Map<String,List<String>> getDependentOptionsImpl(string objApiName , string contrfieldApiName , string depfieldApiName){
        system.debug(objApiName + '##' + contrfieldApiName + '###' + depfieldApiName);
           
        String objectName = objApiName.toLowerCase();
        String controllingField = contrfieldApiName.toLowerCase();
        String dependentField = depfieldApiName.toLowerCase();
        system.debug('item---1');
        Map<String,List<String>> objResults = new Map<String,List<String>>();
            //get the string to sobject global map
        Map<String,Schema.SObjectType> objGlobalMap = Schema.getGlobalDescribe();
         
        if (!Schema.getGlobalDescribe().containsKey(objectName)){
            System.debug('OBJNAME NOT FOUND --.> ' + objectName);
            return null;
         }
                 
        system.debug('item---2' + objResults);
        Schema.SObjectType objType = Schema.getGlobalDescribe().get(objectName);
        if (objType==null){
            return objResults;
        }
        Bitset bitSetObj = new Bitset();
        Map<String, Schema.SObjectField> objFieldMap = objType.getDescribe().fields.getMap();
        //Check if picklist values exist
        if (!objFieldMap.containsKey(controllingField) || !objFieldMap.containsKey(dependentField)){
            System.debug('FIELD NOT FOUND --.> ' + controllingField + ' OR ' + dependentField);
            return objResults;     
        }
        system.debug('item---3');
        List<Schema.PicklistEntry> contrEntries = objFieldMap.get(controllingField).getDescribe().getPicklistValues();
        List<Schema.PicklistEntry> depEntries = objFieldMap.get(dependentField).getDescribe().getPicklistValues();
         objFieldMap = null;
        List<Integer> controllingIndexes = new List<Integer>();
        for(Integer contrIndex=0; contrIndex<contrEntries.size(); contrIndex++){            
            Schema.PicklistEntry ctrlentry = contrEntries[contrIndex];
            String label = ctrlentry.getLabel();
            objResults.put(label,new List<String>());
            controllingIndexes.add(contrIndex);
        }

        List<Schema.PicklistEntry> objEntries = new List<Schema.PicklistEntry>();
        List<PicklistEntryWrapper> objJsonEntries = new List<PicklistEntryWrapper>();
        for(Integer dependentIndex=0; dependentIndex<depEntries.size(); dependentIndex++){            
               Schema.PicklistEntry depentry = depEntries[dependentIndex];
               objEntries.add(depentry);
        } 
        objJsonEntries = (List<PicklistEntryWrapper>)JSON.deserialize(JSON.serialize(objEntries), List<PicklistEntryWrapper>.class);
        List<Integer> indexes;
        
        for (PicklistEntryWrapper objJson : objJsonEntries){
        	try
                {    
		            if (objJson.validFor==null || objJson.validFor==''){
		                continue;
		            }
		            indexes = bitSetObj.testBits(objJson.validFor,controllingIndexes);	
		            List<Integer> listIndexes = new List<Integer>();            
		            for (Integer idx : indexes){                
		                    String contrLabel = contrEntries[idx].getLabel();			                
			                
			                if(objResults.get(contrLabel) != null){
			                	objResults.get(contrLabel).add(objJson.label);
			                }			                                         
		            	}
		            	
		            }
	                catch(exception ex)
	                {
	                	
	                }
        }        
        
        for (String fieldName : objResults.keySet()){
			if(objApiName != 'Opportunity'){
            objResults.get(fieldName).add('Other');
			}
        }
      
        
        
        objEntries = null;
        objJsonEntries = null;        
         system.debug('objResults##' + objResults);
        return objResults;
    }
    
	public class PicklistEntryWrapper{
	    
	    public PicklistEntryWrapper(){            
	        }
	   public String active {get;set;}
	   public String defaultValue {get;set;}
	   public String label {get;set;}
	   public String value {get;set;}
	   public String validFor {get;set;}
	}

 
}