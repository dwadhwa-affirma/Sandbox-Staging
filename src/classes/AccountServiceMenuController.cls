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
    	
    	
    		Boolean IsUserInGroup;
    		Group grp = [SELECT DeveloperName,Email,Id,Name,RelatedId,Type FROM Group where DeveloperName ='OOW_Execute' Limit 1];
 	
		 	GroupMember[] gm  = [SELECT GroupId,Id,UserOrGroupId FROM GroupMember where GroupId =: grp.id and UserOrGroupId =: UserInfo.getUserId() ];
		 	
		 	if(gm.size() > 0)
		 	{
		 		IsUserInGroup = true;
		 	}
		 	else 
		 	{
		 		IsUserInGroup = false;
		 	}
    	
 			result.put('UserStatus', IsUserInGroup);
    	
    	return result;
    }
    
    public static List<string> listSort(List<string> input) {
		  for(integer i=0; i < input.size(); i++) input[i] = input[i].toUpperCase() + input[i];
		  input.sort();
		  for(integer i=0; i < input.size(); i++) input[i] = input[i].substring( input[i].length() / 2 );
		  return input;
}

 


}