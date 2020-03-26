public class AddressChangeController {
	
	    
   // ---------------------Updated by Dhwani Get Flow URL from Custom Settings..................//       	
@AuraEnabled
    public static Map<string, string> GetAllData(string accid)
    {
		 string FlowURL;
         Map<string,string> strMap = new  Map<string,string>();
         string source;
         boolean SendEmail=false;
        
         
        AddressChangeConfigurations__c acc = AddressChangeConfigurations__c.getValues('Primary');
		
		if(acc.FlowURL__c != null){
			FlowURL = acc.FlowURL__c;			
		}
		       
        strMap.put('FlowURL',FlowURL);
        strMap.put('UserId',UserInfo.getUserId());
        return strMap; 
    }
       // --------------------- Get Flow URL from Custom Settings..................//       	
   
    
}