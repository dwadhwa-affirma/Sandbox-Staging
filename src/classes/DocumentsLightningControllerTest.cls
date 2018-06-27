@isTest
global class DocumentsLightningControllerTest{
  @testSetup
  static void setupTestData(){
   
    Account account_Obj = new Account(Name='Saumil',Website = 'null', CreatedDate = Date.ValueOf('2017-12-05 21:21:23'), LastModifiedDate = Date.ValueOf('2017-12-06 00:58:53'), PersonHasOptedOutOfEmail = false, NA_Eligibility__c = false, NA_LEAV_Complete__c = false, NA_LECF_Complete__c = false, NA_LECP_Complete__c = false, NA_LEEM_Complete__c = false, NA_LEHS_Complete__c = false, NA_LEMD_Complete__c = false, NA_LEMP_Complete__c = false, NA_LEMQ_Complete__c = false, NA_LEOL_Complete__c = false, NA_LEOM_Complete__c = false, NA_LEPT_Complete__c = false, NA_LESB_Complete__c = false, NA_LESF_Complete__c = false, NA_LEWS_Complete__c = false, NA_Opt_Out__c = false);
    Insert account_Obj; 
    Contact contact_Obj = new Contact(AccountId = account_Obj.id, LastName = 'DILTZ', MailingCity = ' ', MailingState = ' ', MailingPostalCode =  ' ',MailingCountryCode = 'US', HasOptedOutOfEmail = false, CreatedDate = Date.ValueOf('2017-12-05 21:21:23'),  LastModifiedDate = Date.ValueOf('2017-12-06 00:58:53'), smagicinteract__SMSOptOut__c = false, et4ae5__HasOptedOutOfMobile__c = false);
    Insert contact_Obj; 
    Case case_Obj = new Case(ContactId = contact_Obj.id, AccountId = account_Obj.id,Brand__c='Chevron', IsEscalated = false, CreatedDate = Date.ValueOf('2017-12-05 21:22:05'),  LastModifiedDate = Date.ValueOf('2017-12-05 21:22:06'), Additional_Documents__c = false, Staff_Escalated__c = false, Five_Day_Flag__c = false, IsMarkDeleted__c = false, IsMarkRead__c = false, IsMarkSaved__c = false, MaritzCX__Response_Deleted_From_MaritzCX__c = false, SLATemp__c = false);
    Insert case_Obj; 
      RecordType objRecordType = [SELECT Id,Name FROM RecordType WHERE Name='MemberShip'];
	
		Account_Details__c  act = new Account_Details__c(Name = '0000147163', Balance__c = 0.00, Combined_Account_ID__c = '0000147163S0100P0100', ID1__c = '0100', Onboarded__c = true, RecType__c = 'ACCT', TypeTranslate__c = '1-PRIMARY SHARE', RecordType = objRecordType);
		Insert act;
      Web_Settings__c websettings = new Web_Settings__c();
      websettings.Name = 'DEV';
      websettings.WebAddress__c = 'ps://sfrtsqa.chevronfcu.org/api/';
      websettings.Origin__c = 'ChevronTest';
      websettings.key__c = 'MIICdgIBADANBgkqhkiG9w0BAQEFAASCAmAwggJcAgEAAoGBAJsB384Iu09cQdn8AeUBEJrG9tQ2HRWv6E81GmJ2qFLJNAJkIjMQ+f8RBK1QcVNsc1ouH+40DM+MjdlonBMFHFjZpNhIj7gpERlN7sgArSeP2VXwYjCCyZJ28vh8L7M6Le6GEVhbZ/dH88Ed2SmV5FXU0PcCsPo99kZwqm2oaVGfAgMBAAECgYEAmsS4TePyAj8/kQNKcPkrNx9';
      websettings.Key_Part_2__c = 'J/IE7cRf+gHepLH8FegNjZq/MZeihdMftP49+V6mFU5mSUCiwUdspFtaYX3VO4um0QCu61VmrtKmSKp2AVezPurHGh9NIIp4o/QAbc9G0JSUHDmb4veWyvAeK6qdogDL7tfs31NATGsQY7Uy4LCECQQDR8Bp/pqTDYKi42AUwVRHt/lM2TdBw9GY+IAo58OQY/G7O7gJkwUPeXZO/ycImphFlGUQvhaY7M20HOM62C/abAkEAvQRnBwpXT7bMu8';
      websettings.Key_Part_3__c = '8OnkmUikgl2ku8F/ebxhqDD0ZyL7s2qW3HnQSLM3Bk4XfKA2z/FSRoUyOA7GYyYP6goWA/TQJAId9JhzsN7nAUCO7ht3CiWfHk3ygi73afYHqu67ZQNy/TeROx0yvTlXcntZQJ/U5iFBvFgp1fusGLX9TslTbM7QJARXJrpDORdtFUEaD23wNr1w7BEZ6H4kpwam3tP1yDsbPYVpHmKHO17VVbS1fm2jFe21bAGePOh4zY77g+LmyddQJAF1v1u';
      websettings.Key_Part_4__c = 'Q+hCQCio58IvM6FtdIDeDk7wFxM0KNn1LkLdo24Kz8DRlR2OcxGYFj+YCcBh9Jby70VsntypGzzh0jxBg==';
      Insert websettings;
  
  }
  static testMethod void test_GetAllData_UseCase1(){
  	 test.startTest();
  	   Test.setMock(HttpCalloutMock.class, new CreateDocumentsResponseGenerator ());
    Account_Details__c account_Obj  =  [SELECT Id from Account_Details__c Limit 1];
    DocumentsLightningController.GetAllData(account_Obj.Id);
      test.stopTest();
  }
  
  
  
  
  
  
 
  
  
  
}