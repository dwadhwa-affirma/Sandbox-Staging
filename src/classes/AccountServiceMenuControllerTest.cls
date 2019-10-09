@isTest
public class AccountServiceMenuControllerTest {
	
	static testMethod void testMethod1(){
    
    Master_Card_Menu_Settings__c m = new Master_Card_Menu_Settings__c(Name = '1',
    									 Function__c = 'OTP', Menu__c = 'Travel', Order__c = '1', 
        								 isVisibleonCase__c = false, isVisibleonMember__c = false, 
        								 isVisibleonMemberAccount__c = false);
    insert m;    
    
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
        
    Test.startTest();
    AccountServiceMenuController.getAccountServiceMenuData(acc.id);
    test.stopTest();    
    }
}