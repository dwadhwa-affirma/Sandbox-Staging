public class CFCUAccount {
    public string fedid {get;set;}
    public string AccountId {get;set;}
    public Person_Account__c personAccount {get;set;}
    public Contact userBusinessContact {get;set;}
    public Contact userPersonContact {get;set;}
    public string AccountNumber {get;set;}
    public string Brand {get;set;}
    public string LoggedinUser {get;set;}
    public User CurrentUser {get;set;}
    
    @TestVisible public string Get10DigitFid(string fedid)
	{
			Integer  l = fedid.length();
            
            if (l <10)
            {
            	Integer  zerotoadd = 10-l;
            	string prepend='';
            	for (Integer  i=0; i<zerotoadd; i++)
            	{
            		prepend = '0' + prepend;
            		
            	}
            	
            	fedid = prepend + fedid;
            }
            
            return fedid;
	}
    
    public void CFCUAccount()
    {
    	/*personAccount = new Person_Account__c();
    	string LoggedinUser = UserInfo.getUserId();
        List<User> u = [SELECT Name, ContactId, FederationIdentifier from User Where ID=:LoggedinUser];
        CurrentUser = u[0];
        fedid = u[0].FederationIdentifier;
        List<contact> c = [SELECT AccountId, FirstName, MiddleName, LastName FROM Contact WHERE Id =:u[0].ContactId];
        	 
        if (c.size()>0)
         {
         	userBusinessContact = c[0];
         }
            
	    fedid =  Get10DigitFid(fedid);
	    List<Person_Account__c> personaccounts =  [SELECT Account_Number__c,Id,Name, PersonID__c FROM Person_Account__c Where Name_Type__c = 0 and Account_Number__r.Name =:fedid];
            
         if(personaccounts.size()>0)
         {
        	 personAccount = personaccounts[0];
             AccountId = personaccount.PersonID__c;
             AccountNumber = personaccount.Account_Number__c;
         }
            
        List <Account_Details__c> ad = [Select Brand__c FROM Account_Details__c Where ID = :AccountNumber];
        if(ad.size()>0)
        {
        	Brand = ad[0].Brand__c;
        }*/
        	
    }
    
    
}