@isTest
public class AddressChangeLogTriggerTest {
	
	static testMethod void test1(){
		
				Account acc = new Account();
		    	//acc.RecordTypeID=rtId;
		    	acc.FirstName='Test FName';
		        acc.LastName='Test LName';    
		        acc.Mobile_Phone__pc='555-469-3885'; 
		        acc.Email_raw__c='dbhavsar@affirma.com'; 	
		        insert acc;
        
			  	Account_Details__c accDetail = new Account_Details__c();
		        accDetail.Name = '0000147163';
		        accDetail.RecType__c = 'ACCT';
		        accDetail.TypeTranslate__c = '1-PERSONAL';
		        insert accDetail;
		      	RecordType rt = [Select id, Name , SobjectType from Recordtype where sObjectType = 'case' and Name = 'Account Servicing' limit 1];
        		CaseRecordType__c c = new CaseRecordType__c();
        		c.Primary_Category__c = 'Account Maintenance';
        		c.Secondary_Category__c= 'Memberships';
        		c.Teritiary_Category__c= 'Address/Contact Updates';
        		c.RecordTypeId__c = rt.Id;
        		c.Name = '1';
        		insert c;
		list<CaseRecordType__c> scList = [SELECT Id,
                                                   Primary_Category__c,
                                                   Secondary_Category__c,
                                                   Teritiary_Category__c,
                                                   Record_Type_Name__c,
                                                   RecordTypeId__c FROM CaseRecordType__c WHERE Primary_Category__c = 'Account Maintenance' AND Secondary_Category__c= 'Memberships' AND Teritiary_Category__c= 'Address/Contact Updates' LIMIT 1];	
        
        List<Case> case_Obj = new List<Case>{
			new Case(Status = 'In Process',description='Original Desc', Origin = null, Subject = 'Test', ClosedDate = null, IsEscalated = false, AccountId = acc.Id,
                     Account_Number__c = accDetail.Id, RecordTypeId = scList[0].RecordTypeId__c,Additional_Documents__c = false, Staff_Escalated__c = false, Five_Day_Flag__c = false, IsMarkDeleted__c = false, IsMarkRead__c = false, IsMarkSaved__c = false, Primary_Category__c = 'Card services', Secondary_Category__c = 'ATM/Debit', Tertiary_Category__c = 'Travel notification', MaritzCX__Response_Deleted_From_MaritzCX__c = false, SLATemp__c = false)	};		    	
		    Insert case_Obj;
		
		AddressChangeLog__c objAC = new AddressChangeLog__c();
	 	//objAC.AccountNumber__c='0000000123';
	 	objAC.Address_New__c = 'New Address';
	 	objAC.Address_Old__c = 'Old Address';
	 	objAC.CaseId__c =case_Obj[0].Id;
	 	objAC.City_New__c = 'City Old';
	 	objAC.City_Old__c = 'City New';
	 	objAC.Email__c = 'test@test.com';
	 	//objAC.MemberName__c = 'Name';
	 	//objAC.MobilePhone__c = ''';
	 	objAC.State_New__c = 'CA';
	 	objAC.State_Old__c = 'CA';
	 	objAC.Zip_New__c = '12345';
	 	objAC.Zip_Old__c = '67890';
        objAC.AccountNumbersString__c =accDetail.Name;
	 	insert objAC;
	
	}
    
}