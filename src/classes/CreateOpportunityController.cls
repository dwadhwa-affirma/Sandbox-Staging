public with sharing class CreateOpportunityController {
	
	 @AuraEnabled   
    public static List<object> FetchLeadData(string AccountID)
    {
    	List<object> listObj = new List<object>(); 
    	List<Account> acclist = [Select Id,Name,Alternate_Email__pc,Owner.Name,Owner.ID,Suffix,FirstName,MiddleName,RecordType.Name,
        LastName,PersonEmail,Residential_City__pc,Residential_Country_Code__pc,Residential_Country__pc,Residential_Extra_Address__pc,
        Residential_State__pc,Residential_Street__pc,Residential_Zipocde__pc,PersonMobilePhone, Home_Phone__pc, Phone  from Account where Id =: AccountID limit 1];
        Account acc = acclist[0];
        if(acc == null)
        {
            return null;   
        }        
        
        
    	Lead leadObject = new Lead();
        leadObject.Person__c = AccountID;
        leadObject.FirstName = acc.FirstName;
        leadObject.LastName = acc.LastName;
        leadObject.MiddleName = acc.MiddleName;
        leadObject.Suffix = acc.Suffix;
        leadObject.Home_Phone__c = acc.Home_Phone__pc;
        leadObject.Street_Address_1__c = acc.Residential_Street__pc;
        
         
        leadObject.Street_Address_2__c = acc.Residential_Extra_Address__pc;
        leadObject.Country__c = acc.Residential_Country_Code__pc;
        leadObject.State__c = acc.Residential_State__pc;
        leadObject.City__c = acc.Residential_City__pc;
		leadObject.Zip_Code__c = acc.Residential_Zipocde__pc;
		
		List<Episys_User__c> lstepisysUser = getEpsysDetails();
		//BranchOption = eu.Branch_Name__c;
		if(lstepisysUser.size() == 1)
		{
			leadObject.Branch_of_Lead_creator__c =  lstepisysUser[0].Branch_Name__c;
			leadObject.Episys_User_ID__c =  lstepisysUser[0].Episys_ID__c;
		}
		else
		{
			for(Episys_User__c eu : lstepisysUser ){
				if(eu.Default__c)
				{
					leadObject.Branch_of_Lead_creator__c =  eu.Branch_Name__c;
					leadObject.Episys_User_ID__c =  eu.Episys_ID__c;
					break;	
				}
			}			
		}       
         listObj.add(leadObject) ;  
         
         List<Group> listQueue = [select id,Name,Email from Group where Type = 'Queue' and (Email like '%lead.com' or Email like '%opportunity.com') and Name != 'Products & Services Referral Queue'];
          listObj.add(listQueue);  
                         
        listObj.add(acc.RecordType.Name);  
           
        return listObj;           
    }
	
	
	@AuraEnabled
	public static List<Episys_User__c> getEpsysDetails()
	{
		string uid= UserInfo.getUserId();		
		User usr = [Select id, name, alias from User where id=:uid];
		
		List<Episys_User__c> eusr = [SELECT id,
                      alias__c,
                      Assigned_Branch__c,Episys_ID__c, Branch_Name__c,Default__c from Episys_User__c where alias__c=:usr.alias order by Default__c]; 
                      
        return eusr;
	}
	
	
	@AuraEnabled
	public static List<Account_Details__c> getMemberAccounts(String AccountId)
	{
		system.debug('----------------------test-'+AccountId);
		list<Person_Account__c> paList = new list<Person_Account__c>();
            paList = [SELECT Id,
                             Account_Number__c, Account_Number__r.RecType__c, Account_Number__r.Name FROM Person_Account__c WHERE PersonID__c =: AccountId];
        system.debug('----------------------test-'+paList);
        return accountDetails(paList);
	}
	
	
	private static List<Account_Details__c> accountDetails(list<Person_Account__c> paList){
        set<String> accountNumberSet = new set<String>();
        set<Id> accIdset = new set<Id>();
        set<String> acctypeSet = new set<String>();
        for(Person_Account__c var: paList){
            accountNumberSet.add(var.Account_Number__r.Name);
            acctypeSet.add(var.Account_Number__r.RecType__c);
            accIdSet.add(var.Account_Number__c);
        }
        system.debug('---------------accIdSet-------test-'+accountNumberSet);
        list<Account_Details__c> accList = new list<Account_Details__c>();
        if(acctypeSet.contains('ACCT')){
            accList = [SELECT Id,
                              Name,
                              RecType__c,
                              TypeTranslate__c,
                              ID1__c,
                              Balance__c,                              
                              Combined_Account_ID__c,
                              Reference__c,
                              Brand__c FROM Account_Details__c Where Name IN:accountNumberSet ORDER BY Name asc, RecType__c asc];
        }else{
            accList = [SELECT Id,
                              Name,
                              RecType__c,
                              TypeTranslate__c,
                              ID1__c,
                              Balance__c,
                              
                              Combined_Account_ID__c,
                              Reference__c,
                              Brand__c  FROM Account_Details__c Where Id IN:accIdSet ORDER BY Name asc, RecType__c asc];
        }
        return accList;
    }	
	
	 @AuraEnabled
	public static Map<String,List<String>> getDependentOptionsImpl(String objName, String contrfieldName, String depfieldName)
	{
		system.debug('objName=='+objName);
		return clspicklist.getDependentOptionsImpl(objName, contrfieldName, depfieldName);
	}
	
	 @AuraEnabled
    public static String OpportunityInsertUpdate(Opportunity opportunityObject)
    {    
    	Id currentUserId = UserInfo.getUserId(); 
    	
    	opportunityObject.User_Owner__r=null; 
    	opportunityObject.Mortgage_Loan_Officer__r =null; 
    	opportunityObject.CloseDate = date.newInstance(2048,12,31);
    	opportunityObject.Name= 'Name';
    	
    	
    	if(opportunityObject.Ownership__c == 'Keep'){       		
       		opportunityObject.User_Owner__c = currentUserId;
       		opportunityObject.Queue_Owner__c = null;
       	}
       	else if(opportunityObject.Ownership__c == 'Auto Assign'){       		
       		
       		opportunityObject.Queue_Owner__c = null;
            opportunityObject.StageName='New';
       	}
       	else if(opportunityObject.Ownership__c == 'Assign' && opportunityObject.Queue_Assigned_Id__c!= null && opportunityObject.Queue_Assigned_Id__c!= '')
       	{
       		Group gp = [Select Name from Group where id =:opportunityObject.Queue_Assigned_Id__c];
       	//	opportunityObject.User_Owner__r=null; 
       		opportunityObject.Queue_Owner__c = gp.Name;
            opportunityObject.StageName='New';
       	}
       	system.debug('opportunityObject.Episys_User_ID__c=='+opportunityObject.Episys_User_ID__c);
       	if(opportunityObject.Episys_User_ID__c != null){
       	
       	List<Episys_User__c> eusr = [SELECT id,
                      alias__c,
                      Assigned_Branch__c,Episys_ID__c, Branch_Name__c,Default__c from Episys_User__c where Episys_ID__c =:opportunityObject.Episys_User_ID__c];
         system.debug('eusr'+eusr);
                      if(eusr.size() >0){
	//	opportunityObject.Member_Branch__c =  eusr[0].Branch_Name__c;	
		opportunityObject.Branch_of_Lead_creator__c =  eusr[0].Branch_Name__c;	}
       	}
       	else{
       		opportunityObject.Branch_of_Lead_creator__c =  '';
       	}
		//BranchOption = eu.Branch_Name__c;
		    
        insert opportunityObject;                                 
        
        return opportunityObject.Id;         
    }
    
    
}