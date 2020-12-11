public class AccountServiceMenuController {
    
     @AuraEnabled
    public static Map<string, object> getAccountServiceMenuData(string recordId){
    	List<Master_Card_Menu_Settings__c> mcList= new List<Master_Card_Menu_Settings__c>();
    	Map<string, object> result = new Map<string, object>();
    	mcList = [select id, Command__c, Function__c, Menu__c, Order__c, URL__c,Status__c, isVisibleonCase__c, isVisibleonMember__c, isVisibleonMemberAccount__c  from Master_Card_Menu_Settings__c order by name];
    	Set<string> menu = new Set<string>();
    	for(Master_Card_Menu_Settings__c m:mcList){
    		menu.add(m.Menu__c);
    	}
    	list<string> menuList= new List<string>(menu);
    	menuList = listSort(menuList);
    	result.put('Menu', menuList);
    	result.put('SubMenu', mcList);
    	
    	
    		Boolean IsUserInGroup,IsUserInEFTGroup, IsUserInAddressChangeGroup;
    		Group grp = [SELECT DeveloperName,Email,Id,Name,RelatedId,Type FROM Group where DeveloperName ='OOW_Execute' Limit 1];
			Group grpEFT = [SELECT DeveloperName,Email,Id,Name,RelatedId,Type FROM Group where DeveloperName ='EFT_Tool' Limit 1];
			Group grpAddressChange = [SELECT DeveloperName,Email,Id,Name,RelatedId,Type FROM Group where DeveloperName ='Address_Change' Limit 1];
 	
 	
 		/*------------ EFT Tool Group --------------------*/
		 	GroupMember[] gm  = [SELECT GroupId,Id,UserOrGroupId FROM GroupMember where GroupId =: grp.id and UserOrGroupId =: UserInfo.getUserId() ];
			GroupMember[] gmEFT  = [SELECT GroupId,Id,UserOrGroupId FROM GroupMember where GroupId =: grpEFT.id and UserOrGroupId =: UserInfo.getUserId() ];
			GroupMember[] gmAddressChange  = [SELECT GroupId,Id,UserOrGroupId FROM GroupMember where GroupId =: grpAddressChange.id and UserOrGroupId =: UserInfo.getUserId() ];
		 	
		 	if(gm.size() > 0)
		 	{
		 		IsUserInGroup = true;
		 	}
		 	else 
		 	{
		 		IsUserInGroup = false;
		 	}
        	
        	/*------------ EFT Tool Group --------------------*/
        	if(gmEFT.size() > 0)
		 	{
		 		IsUserInEFTGroup = true;
		 	}
		 	else 
		 	{
		 		IsUserInEFTGroup = false;
			 }
			 
			 /*------------ Address Change Group --------------------*/
			 if(gmAddressChange.size() > 0)
		 	{
				IsUserInAddressChangeGroup = true;
		 	}
		 	else 
		 	{
				IsUserInAddressChangeGroup = false;
		 	}
        
			system.debug('IsUserInEFTGroup=='+IsUserInEFTGroup);
			system.debug('IsUserInAddressChangeGroup=='+IsUserInAddressChangeGroup);
    	
 			result.put('UserStatus', IsUserInGroup);
			result.put('UserStatusEFT', IsUserInEFTGroup);
			result.put('UserStatusAddressChange', IsUserInAddressChangeGroup);
    	
    	return result;
    }
    
    public static List<string> listSort(List<string> input) {
		  for(integer i=0; i < input.size(); i++) input[i] = input[i].toUpperCase() + input[i];
		  input.sort();
		  for(integer i=0; i < input.size(); i++) input[i] = input[i].substring( input[i].length() / 2 );
		  return input;
}

 


}