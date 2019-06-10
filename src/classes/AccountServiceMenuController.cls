public class AccountServiceMenuController {
    
     @AuraEnabled
    public static Map<string, object> getAccountServiceMenuData(string recordId){
    	List<Master_Card_Menu_Settings__c> mcList= new List<Master_Card_Menu_Settings__c>();
    	Map<string, object> result = new Map<string, object>();
    	mcList = [select id, Command__c, Function__c, Menu__c, Order__c, Status__c from Master_Card_Menu_Settings__c order by name];
    	Set<string> menu = new Set<string>();
    	for(Master_Card_Menu_Settings__c m:mcList){
    		menu.add(m.Menu__c);
    	}
    	list<string> menuList= new List<string>(menu);
    	menuList = listSort(menuList);
    	result.put('Menu', menuList);
    	result.put('SubMenu', mcList);
    	
    	return result;
    }
    
    public static List<string> listSort(List<string> input) {
		  for(integer i=0; i < input.size(); i++) input[i] = input[i].toUpperCase() + input[i];
		  input.sort();
		  for(integer i=0; i < input.size(); i++) input[i] = input[i].substring( input[i].length() / 2 );
		  return input;
}
}