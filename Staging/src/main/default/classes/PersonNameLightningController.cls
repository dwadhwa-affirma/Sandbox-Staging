public class PersonNameLightningController {
     @auraenabled
    public static list<Person_Account__c> getData(string accoutid)
    {
    	list<Person_Account__c> paList = new list<Person_Account__c>();
    	Account_Details__c accDetails = [Select Parent_Account__c,RecType__c,RecordType.Name from Account_Details__c where Id=:accoutid Limit 1];
    	List<string> listStringIds = new List<string>();
    	listStringIds.add(accoutid);
    	if(accDetails.Parent_Account__c != null)
    	{
    		listStringIds.add(accDetails.Parent_Account__c);
    		List<Account_Details__c> accDetailsList = [Select Parent_Account__c,RecType__c,RecordType.Name from Account_Details__c where Parent_Account__c=:accDetails.Parent_Account__c];
    		for(Account_Details__c item: accDetailsList )
    		{
    			
    			listStringIds.add(item.id);
    		}
    	}
    	else
	    {
	    	List<Account_Details__c> accDetailsList = [Select Parent_Account__c,RecType__c,RecordType.Name from Account_Details__c where Parent_Account__c=:accDetails.Id];
    		for(Account_Details__c item: accDetailsList )
    		{
    			
    			listStringIds.add(item.id);
    		}
	    }
    	paList = [SELECT Id,
                          Account_Number__c,
                          PersonId__c,
                          PersonID__r.Name,
                          TypeTranslate__c FROM Person_Account__c WHERE Account_Number__c in: listStringIds];
    	
    	
    	AggregateResult[] groupedResults
		  = [SELECT 
                          PersonId__c,
                          PersonID__r.Name acctName,
                          TypeTranslate__c FROM Person_Account__c WHERE Account_Number__c in: listStringIds group by PersonId__c,PersonID__r.Name,TypeTranslate__c ];
    	list<Person_Account__c> paList1 = new list<Person_Account__c>();
    	for (AggregateResult ar : groupedResults)  {
    		Person_Account__c item = new Person_Account__c();
    		item.PersonId__c = (string)ar.get('PersonId__c');
    		item.PersonID__r = new Account();
    		item.PersonID__r.Name = (string)ar.get('acctName');
    		item.TypeTranslate__c = (string)ar.get('TypeTranslate__c');
    		paList1.add(item);
		}
    	
    	/*if(accDetails.RecordType.Name == 'Membership')
    	{
    		paList = [SELECT Id,
                          Account_Number__c,
                          PersonId__c,
                          PersonID__r.Name,
                          TypeTranslate__c FROM Person_Account__c WHERE Account_Number__c =:accoutid];
                          
    	}
    	else
    	{
    		string accId1;
    		if(accDetails.Parent_Account__c != null){
              accId1 = accDetails.Parent_Account__c;
            }
 
         	paList = [SELECT Id,
                          Account_Number__c,
                          PersonId__c,
                          PersonID__r.Name,
                          TypeTranslate__c FROM Person_Account__c WHERE Account_Number__c =:accoutid OR Account_Number__c =:accId1];
    	}*/
    	return paList1;
    }
}