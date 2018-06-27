@isTest
private class QueueOwnersControllerTest{
  @testSetup
  static void setupTestData(){
    test.startTest();
    Account account_Obj = new Account(Name='Saumil',Website = 'null', CreatedDate = Date.ValueOf('2017-12-05 21:21:23'), LastModifiedDate = Date.ValueOf('2017-12-06 00:58:53'), PersonHasOptedOutOfEmail = false, NA_Eligibility__c = false, NA_LEAV_Complete__c = false, NA_LECF_Complete__c = false, NA_LECP_Complete__c = false, NA_LEEM_Complete__c = false, NA_LEHS_Complete__c = false, NA_LEMD_Complete__c = false, NA_LEMP_Complete__c = false, NA_LEMQ_Complete__c = false, NA_LEOL_Complete__c = false, NA_LEOM_Complete__c = false, NA_LEPT_Complete__c = false, NA_LESB_Complete__c = false, NA_LESF_Complete__c = false, NA_LEWS_Complete__c = false, NA_Opt_Out__c = false);
    Insert account_Obj; 
    Contact contact_Obj = new Contact(AccountId = account_Obj.id, LastName = 'DILTZ', MailingCity = ' ', MailingState = ' ', MailingPostalCode =  ' ',MailingCountryCode = 'US', HasOptedOutOfEmail = false, CreatedDate = Date.ValueOf('2017-12-05 21:21:23'),  LastModifiedDate = Date.ValueOf('2017-12-06 00:58:53'), smagicinteract__SMSOptOut__c = false, et4ae5__HasOptedOutOfMobile__c = false);
    Insert contact_Obj; 
    Case case_Obj = new Case(ContactId = contact_Obj.id, AccountId = account_Obj.id,Brand__c='Chevron', IsEscalated = false, CreatedDate = Date.ValueOf('2017-12-05 21:22:05'),  LastModifiedDate = Date.ValueOf('2017-12-05 21:22:06'), Additional_Documents__c = false, Staff_Escalated__c = false, Five_Day_Flag__c = false, IsMarkDeleted__c = false, IsMarkRead__c = false, IsMarkSaved__c = false, MaritzCX__Response_Deleted_From_MaritzCX__c = false, SLATemp__c = false);
    Insert case_Obj; 
    test.stopTest();
  }
  static testMethod void test_GetuserCases_UseCase1(){
    List<Account> account_Obj  =  [SELECT Id,IsDeleted,Fax,AccountNumber,Website,PhotoUrl,CreatedDate,CreatedById,LastModifiedDate,LastModifiedById,PersonHasOptedOutOfEmail,NA_Eligibility__c,NA_LEAV_Complete__c,NA_LECF_Complete__c,NA_LECP_Complete__c,NA_LEEM_Complete__c,NA_LEHS_Complete__c,NA_LEMD_Complete__c,NA_LEMP_Complete__c,NA_LEMQ_Complete__c,NA_LEOL_Complete__c,NA_LEOM_Complete__c,NA_LEPT_Complete__c,NA_LESB_Complete__c,NA_LESF_Complete__c,NA_LEWS_Complete__c,NA_Opt_Out__c from Account];
    System.assertEquals(true,account_Obj.size()>0);
    List<Contact> contact_Obj  =  [SELECT Id,IsDeleted,MasterRecordId,AccountId,LastName,MailingCity,MailingState,MailingPostalCode,MailingCountryCode,HasOptedOutOfEmail,CreatedDate,CreatedById,LastModifiedDate,LastModifiedById,smagicinteract__SMSOptOut__c,et4ae5__HasOptedOutOfMobile__c from Contact];
    System.assertEquals(true,contact_Obj.size()>0);
    List<Case> case_Obj  =  [SELECT Id,IsDeleted,CaseNumber,ContactId,AccountId,AssetId,IsEscalated,CreatedDate,CreatedById,LastModifiedDate,LastModifiedById,Additional_Documents__c,Staff_Escalated__c,Five_Day_Flag__c,IsMarkDeleted__c,IsMarkRead__c,IsMarkSaved__c,MaritzCX__Response_Deleted_From_MaritzCX__c,SLATemp__c from Case];
    System.assertEquals(true,case_Obj.size()>0);
    QueueOwnersController obj01 = new QueueOwnersController();
    QueueOwnersController.GetuserCases();
  }
  static testMethod void test_saveUserCases_UseCase1(){
    List<Account> account_Obj  =  [SELECT Id,IsDeleted,Fax,AccountNumber,Website,PhotoUrl,CreatedDate,CreatedById,LastModifiedDate,LastModifiedById,PersonHasOptedOutOfEmail,NA_Eligibility__c,NA_LEAV_Complete__c,NA_LECF_Complete__c,NA_LECP_Complete__c,NA_LEEM_Complete__c,NA_LEHS_Complete__c,NA_LEMD_Complete__c,NA_LEMP_Complete__c,NA_LEMQ_Complete__c,NA_LEOL_Complete__c,NA_LEOM_Complete__c,NA_LEPT_Complete__c,NA_LESB_Complete__c,NA_LESF_Complete__c,NA_LEWS_Complete__c,NA_Opt_Out__c from Account];
    System.assertEquals(true,account_Obj.size()>0);
    List<Contact> contact_Obj  =  [SELECT Id,IsDeleted,MasterRecordId,AccountId,LastName,MailingCity,MailingState,MailingPostalCode,MailingCountryCode,HasOptedOutOfEmail,CreatedDate,CreatedById,LastModifiedDate,LastModifiedById,smagicinteract__SMSOptOut__c,et4ae5__HasOptedOutOfMobile__c from Contact];
    System.assertEquals(true,contact_Obj.size()>0);
    List<Case> case_Obj  =  [SELECT Id,IsDeleted,OwnerId,CaseNumber,ContactId,AccountId,AssetId,IsEscalated,CreatedDate,CreatedById,LastModifiedDate,LastModifiedById,Additional_Documents__c,Staff_Escalated__c,Five_Day_Flag__c,IsMarkDeleted__c,IsMarkRead__c,IsMarkSaved__c,MaritzCX__Response_Deleted_From_MaritzCX__c,SLATemp__c from Case];
    System.assertEquals(true,case_Obj.size()>0);
    QueueOwnersController obj01 = new QueueOwnersController();
    QueueOwnersController.QueueWrapper qw = new QueueOwnersController.QueueWrapper(case_Obj[0]);
    
    qw.selected = true;
    
    List<QueueOwnersController.QueueWrapper> listQueue = new List<QueueOwnersController.QueueWrapper> ();
    
    listQueue.add(qw);
    string dataserialize = JSON.serialize(listQueue);
    
    QueueOwnersController.saveUserCases(dataserialize,case_Obj[0].OwnerId);
  }
 /*  static testMethod void test_QueueOwnersController.QueueWrapper(){
    List<Account> account_Obj  =  [SELECT Id,IsDeleted,Fax,AccountNumber,Website,PhotoUrl,CreatedDate,CreatedById,LastModifiedDate,LastModifiedById,PersonHasOptedOutOfEmail,NA_Eligibility__c,NA_LEAV_Complete__c,NA_LECF_Complete__c,NA_LECP_Complete__c,NA_LEEM_Complete__c,NA_LEHS_Complete__c,NA_LEMD_Complete__c,NA_LEMP_Complete__c,NA_LEMQ_Complete__c,NA_LEOL_Complete__c,NA_LEOM_Complete__c,NA_LEPT_Complete__c,NA_LESB_Complete__c,NA_LESF_Complete__c,NA_LEWS_Complete__c,NA_Opt_Out__c,smagicinteract__SMSOptOut__pc,	 from Account];
    System.assertEquals(true,account_Obj.size()>0);
    List<Contact> contact_Obj  =  [SELECT Id,IsDeleted,MasterRecordId,AccountId,LastName,MailingCity,MailingState,MailingPostalCode,MailingStateCode,MailingCountryCode,HasOptedOutOfEmail,CreatedDate,CreatedById,LastModifiedDate,LastModifiedById,smagicinteract__SMSOptOut__c,et4ae5__HasOptedOutOfMobile__c from Contact];
    System.assertEquals(true,contact_Obj.size()>0);
    List<Case> case_Obj  =  [SELECT Id,IsDeleted,CaseNumber,ContactId,AccountId,AssetId,IsEscalated,CreatedDate,CreatedById,LastModifiedDate,LastModifiedById,Additional_Documents__c,Staff_Escalated__c,Five_Day_Flag__c,IsMarkDeleted__c,IsMarkRead__c,IsMarkSaved__c,MaritzCX__Response_Deleted_From_MaritzCX__c,SLATemp__c from Case];
    System.assertEquals(true,case_Obj.size()>0);
    QueueOwnersController obj01 = new QueueOwnersController();
    QueueOwnersController.QueueWrapper obj31 = new QueueOwnersController.QueueWrapper(new Case());
  }*/
}