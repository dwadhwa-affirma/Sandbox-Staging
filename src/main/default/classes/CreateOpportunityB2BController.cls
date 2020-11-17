public with sharing class CreateOpportunityB2BController {
	
	 @AuraEnabled   
    public static List<object> FetchLeadData(string AccountID){
    
    	List<object> listObj = new List<object>(); 
    	List<Account> acclist = [Select Id,Name,Alternate_Email__pc,Owner.Name,Owner.ID,Suffix,FirstName,MiddleName,RecordType.Name,
        LastName,PersonEmail,Residential_City__pc,Residential_Country_Code__pc,Residential_Country__pc,Residential_Extra_Address__pc,
        Residential_State__pc,Residential_Street__pc,Residential_Zipocde__pc,PersonMobilePhone, Home_Phone__pc, Phone  from Account where Id =: AccountID limit 1];
        Account acc = acclist[0];
        if(acc == null){
        	return null;   
        }        
        return acclist;
    }
		
	@AuraEnabled
    public static String OpportunityInsertUpdate(Opportunity opportunityObject){    
    	
        Id currentUserId = UserInfo.getUserId(); 
    	
    	opportunityObject.Name= 'Name';
 		opportunityObject.CloseDate = date.newInstance(2048,12,31);    	   
        insert opportunityObject;                                 
        
        return opportunityObject.Id;         
    }    
}