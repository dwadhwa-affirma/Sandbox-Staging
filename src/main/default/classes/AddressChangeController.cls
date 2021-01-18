public class AddressChangeController {
	
	    
   // ---------------------Get data to pass in Address Change Flow..................//       	
@AuraEnabled
    public static Map<string, string> GetAllData(string accid)
    {
		 string FlowURL;
         Map<string,string> strMap = new  Map<string,string>();
         string source;
         boolean SendEmail=false;
        
        // --------------------- Get Flow URL from Custom Settings..................//   
        AddressChangeConfigurations__c acc = AddressChangeConfigurations__c.getValues('Primary');
		
		if(acc.FlowURL__c != null){
			FlowURL = acc.FlowURL__c;			
		}
		
		Account acct = [SELECT id, Name, SSN_TIN_Encrypted__pc from Account where id =: accid limit 1];
		       
        strMap.put('FlowURL',FlowURL);
        strMap.put('UserId',UserInfo.getUserId());
        strMap.put('MemberName',acct.Name);
        strMap.put('SSN',acct.SSN_TIN_Encrypted__pc);

        User currentUser = [SELECT id,alias from user where Id =: UserInfo.getUserId()];
        List<Episys_User__c> EpisysUser = [SELECT id,Alias__c,Episys_ID__c from Episys_User__c where Alias__c =: currentUser.alias limit 1];
        if(EpisysUser.size() > 0){
            strMap.put('EpisysId',String.Valueof(EpisysUser[0].Episys_ID__c));
        }
        else{
            strMap.put('EpisysId','');
        }

        return strMap; 
    }
            	
   
    
}