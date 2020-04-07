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
		
		Account acct = [SELECT id, Name, SSN_TIN_Encrypted__pc from Account where id =: accid limit 1];
		       
        strMap.put('FlowURL',FlowURL);
        strMap.put('UserId',UserInfo.getUserId());
        strMap.put('MemberName',acct.Name);
        strMap.put('SSN',acct.SSN_TIN_Encrypted__pc);
        return strMap; 
    }
       // --------------------- Get Flow URL from Custom Settings..................//       	
   
    
}