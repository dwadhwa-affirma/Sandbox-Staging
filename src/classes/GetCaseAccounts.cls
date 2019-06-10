public without sharing class GetCaseAccounts {
	
     @AuraEnabled    
    public static List<AccountListSelection> GetAllAccounts(Id caseid)
    {
    			case casedetails = new case();
    			List<AccountListSelection> als = new List<AccountListSelection>();
    			
				casedetails = [Select Id,AccountID,Parentid, Account_Number__c from Case where Id =: caseid limit 1];
				
				List<string> accountNumberSet = new List<string>();
				set<Id> accIdset = new set<Id>();
        		set<String> acctypeSet = new set<String>();
        
				list<Person_Account__c> paList = [SELECT Id,
                             Account_Number__c, Account_Number__r.RecType__c,TypeTranslate__c, Account_Number__r.Name FROM Person_Account__c WHERE PersonID__c =:casedetails.AccountId and (NOT TypeTranslate__c like '%Beneficiary%')];
				 for(Person_Account__c var: paList){
            			accountNumberSet.add(var.Account_Number__r.Name);
            			acctypeSet.add(var.Account_Number__r.RecType__c);
            			accIdSet.add(var.Account_Number__c);
				 }
				
				
				List<Account_Details__c> listAccountDetails = new List<Account_Details__c>();
				
				
				if(acctypeSet.contains('ACCT')){
            listAccountDetails = [SELECT Id,
                              Name,
                              RecType__c,
                              TypeTranslate__c,
                              ID1__c,
                              Balance__c,
                              Reference__c,
                              Brand__c FROM Account_Details__c Where Name IN:accountNumberSet and (RecType__c = 'ACCT' or (RecType__c = 'SHAR' and TypeTranslate__c ='1-PRIMARY SHARE')) ORDER BY Name asc, RecType__c asc];
        }else{
            listAccountDetails = [SELECT Id,
                              Name,
                              RecType__c,
                              TypeTranslate__c,
                              ID1__c,
                              Balance__c,
                              Reference__c,
                              Brand__c  FROM Account_Details__c Where Id IN:accIdSet and (RecType__c = 'ACCT' or (RecType__c = 'SHAR' and TypeTranslate__c ='1-PRIMARY SHARE')) ORDER BY Name asc, RecType__c asc];
        }
				
		 List<CaseAccountMemberDetail__c> camd = new List<CaseAccountMemberDetail__c>();
        camd = [select id,Case__c, MemberAccountid__c,  case__r.CaseNumber,case__r.OwnerId,
        				case__r.Owner.Name , case__r.Status, case__r.Category__c,
        				case__r.Primary_Category__c, case__r.Tertiary_Category__c,case__r.Secondary_Category__c,
        				case__r.Account.Name,
        				Account_Name__c, 
        				case__r.Subject, case__r.Origin,case__r.Parent.CaseNumber, case__r.ClosedDate
        				 from CaseAccountMemberDetail__c where Case__c =: caseid];
			
		        for(Account_Details__c ca : listAccountDetails )
		        {
		        	AccountListSelection objcls = new AccountListSelection();
		          	objcls.accountdetails = ca;
		          	boolean selected = false;
				        for(CaseAccountMemberDetail__c c : camd)
				        {
				         
				          if(ca.id  == c.MemberAccountid__c)
				          {		          	
				            selected = true;
				          }	          
				        }
				        if(selected)
				        {
				        	objcls.isSelected = true;
				        }
				        else
				        {
				        	objcls.isSelected = false;
				        }
				         als.add(objcls);
		        }
		        
		        system.debug('als.size()='+als.size());
		        if(als.size() != 0 && casedetails.Account_Number__c != null){
		         	for(AccountListSelection al: als){
		         		account_details__c tempAccc = (account_details__c)al.accountdetails;
		         		if(tempAccc.id == casedetails.Account_Number__c){
		         			if(al.isSelected == false){
		         				al.isSelected = true;
		         			}
		         		}
		         	}
		        }
				 
				return als;
    }
    
       @AuraEnabled 
    public static void AddAccountsandSave(Id caseid, List<String> accountids)
    {    	
    	system.debug('accountids==' +accountids);
    		case selectedcase = [select id, Account_Number__c from case where id =: caseid];
    		system.debug('selectedcase==' +selectedcase);
    		if(!accountids.contains((string)selectedcase.Account_Number__c)){
    			selectedcase.Account_Number__c = accountids[0];
    		}
    		update selectedcase;
    	    	system.debug('accountids=='+accountids);
    			list<account_details__c> ListAccountsSelected = [select id, Name from account_details__c where id in: accountids];
				
				List<CaseAccountMemberDetail__c> camd = [select id from CaseAccountMemberDetail__c
							where Case__c =: caseid];		
							
				system.debug('camd==='+camd);					
							
			if(camd.size() > 0 ){
				delete camd;
			}	            		
           
           List<CaseAccountMemberDetail__c> CaseAccountMemberDetailList = new List<CaseAccountMemberDetail__c>();
            if(ListAccountsSelected.size() > 0 )
            {
            	for(Account_Details__c ca : ListAccountsSelected)
            	{
            		
            		if(ca.Id != null)
            		{
	            		CaseAccountMemberDetail__c cd = new CaseAccountMemberDetail__c();
	            		cd.Case__c = caseid;
	            		cd.MemberAccountid__c = ca.Id ;
	            		cd.Account_Name__c = ca.Name;
	            		CaseAccountMemberDetailList.add(cd);
            		}
            		
            	}
            }
			
			 If(!CaseAccountMemberDetailList.IsEmpty())
            {
            	insert CaseAccountMemberDetailList;
            }
				
    	
    
    }
    
    public class AccountListSelection
	{
		@AuraEnabled
		public object accountdetails {get;set;}
		@AuraEnabled
		public boolean isSelected {get;set;}
	}
}