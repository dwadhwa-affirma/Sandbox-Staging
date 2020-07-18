@isTest
public class AccountTriggerTest {
    
    static testMethod void testMethod1(){
       
        String RecTypeId= [select Id from RecordType where (Name='Person Account') and (SobjectType='Account')].Id;
        
        Account acc = new Account(
           RecordTypeID=RecTypeId,
           FirstName='Test FName',
           LastName='Test LName',
           PersonMailingStreet='test@yahoo.com',
           PersonMailingPostalCode='12345',
           PersonMailingCity='SFO',
           PersonEmail='test@yahoo.com',
           PersonHomePhone='1234567',
           PersonMobilePhone='12345678');         
        insert acc;
        
        Valid_Branch__c va = new Valid_Branch__c();
			va.name = '2 Test';
		insert va;
		
        Account_Details__c accDetails = new Account_Details__c();
           accDetails.Name = 'test';
           accDetails.RESTRICTED_ACCESS__c = 1;
           accDetails.RecType__c = 'ACCT';
        insert accDetails;
        
        Person_Account__c pa = new Person_Account__c();
           pa.PersonID__c = acc.Id;
           pa.Account_Number__c = accDetails.Id;
           pa.Name_Type__c = 0;
        insert pa;

		
        
      //  acc.Employee_Restricted_Access__c = 1;
      //  update acc;
        
        try{
        acc.Employee_Restricted_Access__c = 1;
        update acc;
        }catch (DmlException ex) {
            System.assertEquals('Member Name cannot be changed.', ex.getDmlMessage(0));   
        }
    }
}