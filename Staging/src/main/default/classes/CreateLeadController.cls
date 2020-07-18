public class CreateLeadController {
    
    @AuraEnabled   
    public static Lead FetchLeedData(string AccountID)
    {
    	List<Account> acclist = [Select Id,Name,Alternate_Email__pc,Owner.Name,Owner.ID,Suffix,FirstName,MiddleName,
        LastName,PersonEmail,Residential_City__pc,Residential_Country_Code__pc,Residential_Country__pc,Residential_Extra_Address__pc,
        Residential_State__pc,Residential_Street__pc,Residential_Zipocde__pc,PersonMobilePhone, Home_Phone__pc, Phone  from Account where Id =: AccountID limit 1];
        Account acc = acclist[0];
        if(acc == null)
        {
            ApexPages.Message msgs = new ApexPages.Message(ApexPages.Severity.ERROR, 'Invalid Account');
            ApexPages.addMessage(msgs );            
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
                  
        return leadObject;           
    }
    
    @AuraEnabled
    public static String LeadInsertUpdate(Lead leadObject, string MemberAccountID)
    {    	    	  
    	if(leadObject.Ownership__c == 'Assign' || leadObject.Ownership__c == 'Keep'){       		
       		leadObject.Keep__c = true;
       	}
       
       leadObject.Member_Account__r = null;
       leadObject.Person__r = null;       
       leadObject.Mortgage_Loan_Officer__r = null;
        
       Database.DMLOptions dmo=new Database.DMLOptions();
  	   dmo.assignmentRuleHeader.useDefaultRule= true;

  	   leadobject.setOptions(dmo);
        
        system.debug('1===' + leadObject);
        insert leadObject;                                 
        
        return leadObject.Id;         
    }
    
    
    @AuraEnabled
	public static Map<String,List<String>> getDependentOptionsImpl(String objName, String contrfieldName, String depfieldName)
	{
		return clspicklist.getDependentOptionsImpl(objName, contrfieldName, depfieldName);
	}
	
	@AuraEnabled
	public static Map<string,object> getMemberAccounts(String AccountId)
	{
		list<Person_Account__c> paList = new list<Person_Account__c>();
            paList = [SELECT Id,
                             Account_Number__c, Account_Number__r.RecType__c, Account_Number__r.Name FROM Person_Account__c WHERE PersonID__c =: AccountId];
        
        List<Account> acc = [SELECT Id,
                          Name,
                          Alternate_Email__pc,
                          FirstName,
                          MiddleName,
                          LastName,
                          PersonEmail,
                          Residential_City__pc,
                          Residential_Country_Code__pc,
                          Residential_Country__pc,
                          Residential_Extra_Address__pc,
                          Residential_State__pc,
                          Residential_Street__pc,
                          Residential_Zipocde__pc,
                          PersonHomePhone,
                          Email_raw__c,
                          PersonID__c FROM Account Where Id =:AccountId];
                                               
       Map<string,object> mapList = new Map<string,object>();
       mapList.put('memberDetails', accountDetails(paList));
      
       if(acc.size() > 0){
       		mapList.put('accountDetails', acc[0]);
       }
       else
       {
       		mapList.put('accountDetails', null);
       }
       return mapList;
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
	
	private static List<Account_Details__c> accountDetails(list<Person_Account__c> paList){
        set<String> accountNumberSet = new set<String>();
        set<Id> accIdset = new set<Id>();
        set<String> acctypeSet = new set<String>();
        for(Person_Account__c var: paList){
            accountNumberSet.add(var.Account_Number__r.Name);
            acctypeSet.add(var.Account_Number__r.RecType__c);
            accIdSet.add(var.Account_Number__c);
        }
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
}