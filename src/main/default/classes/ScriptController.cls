public class ScriptController {
	
	 public string KEEP_ALIVE_URL {get;set;}
	 public ScriptController()
	 {
	 		ID id = UserInfo.getUserId();
        		List<User> u = [SELECT KEEP_ALIVE_URL__c from User Where ID=:id ];
        		if(u.size() > 0)
        		{
        			KEEP_ALIVE_URL = u[0].KEEP_ALIVE_URL__c;
        		}

	 }
     
}