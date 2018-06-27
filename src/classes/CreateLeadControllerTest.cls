@isTest
private class CreateLeadControllerTest{
  @testSetup
  static void setupTestData(){
    test.startTest();
    Lead ld = new Lead(LastName = 'LastName268', Status = 'Open', HasOptedOutOfEmail = false, IsConverted = false, IsUnreadByOwner = false, CreatedDate = DateTime.now(), //CreatedById = acc.id,
                       LastModifiedDate = DateTime.now(), smagicinteract__SMSOptOut__c = false, Escalated__c = false, Membership_Required_old__c = false, Keep__c = false, et4ae5__HasOptedOutOfMobile__c = false, Episys_Flag__c = false, temp__c = false);
    Insert ld; 
    test.stopTest();
  }
static testMethod void test_FetchLeedData(){
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
     PageReference pageRef = Page.CreateNewLead;
        Test.setCurrentPage(pageRef);
        ApexPages.currentPage().getParameters().put('accountid', acc.id);
    Episys_User__c euc = new Episys_User__c();
        String uid = UserInfo.getUserId();
        User usr = [Select id, name, alias from User where id=:uid]; 
        euc.Alias__c =  usr.alias;
        euc.Assigned_Branch__c = 105;
        euc.Default__c = true;
        euc.Episys_ID__c = 1111;
        euc.Episys_Name__c = 'Test';

        insert euc;
      Lead l = new Lead();
        CreateNewLeadController controller = new CreateNewLeadController(new ApexPages.StandardController(l)); 
        
               controller.save();       
        controller.leadObject.Product_Type__c = 'Cards';
               controller.save();
        controller.leadObject.Brand__c = 'CFCU';

        controller.SetEpsisUserID();
        
       controller.save();

    List<Lead> ld  =  [SELECT LastName,Status,HasOptedOutOfEmail,IsConverted,IsUnreadByOwner,CreatedDate,CreatedById,LastModifiedDate,LastModifiedById,smagicinteract__SMSOptOut__c,Escalated__c,Membership_Required_old__c,Keep__c,et4ae5__HasOptedOutOfMobile__c,Episys_Flag__c,temp__c from Lead];
    System.assertEquals(true,ld.size()>0);
    CreateLeadController obj01 = new CreateLeadController();
    lead leadObj = CreateLeadController.FetchLeedData(acc.id);
    CreateLeadController.LeadInsertUpdate(leadObj,acc.id);

  }
  
  static testMethod void test_getDependentOptionsImpl(){
    List<Lead> ld  =  [SELECT LastName,Status,HasOptedOutOfEmail,IsConverted,IsUnreadByOwner,CreatedDate,CreatedById,LastModifiedDate,LastModifiedById,smagicinteract__SMSOptOut__c,Escalated__c,Membership_Required_old__c,Keep__c,et4ae5__HasOptedOutOfMobile__c,Episys_Flag__c,temp__c from Lead];
    System.assertEquals(true,ld.size()>0);
    CreateLeadController obj01 = new CreateLeadController();
    CreateLeadController.getDependentOptionsImpl('test data','test data','test data');
  }
  static testMethod void test_getMemberAccounts(){
    List<Lead> ld  =  [SELECT LastName,Status,HasOptedOutOfEmail,IsConverted,IsUnreadByOwner,CreatedDate,CreatedById,LastModifiedDate,LastModifiedById,smagicinteract__SMSOptOut__c,Escalated__c,Membership_Required_old__c,Keep__c,et4ae5__HasOptedOutOfMobile__c,Episys_Flag__c,temp__c from Lead];
    System.assertEquals(true,ld.size()>0);
    CreateLeadController obj01 = new CreateLeadController();
    CreateLeadController.getMemberAccounts('test data');
  }
  static testMethod void test_getEpsysDetails(){
    List<Lead> ld  =  [SELECT LastName,Status,HasOptedOutOfEmail,IsConverted,IsUnreadByOwner,CreatedDate,CreatedById,LastModifiedDate,LastModifiedById,smagicinteract__SMSOptOut__c,Escalated__c,Membership_Required_old__c,Keep__c,et4ae5__HasOptedOutOfMobile__c,Episys_Flag__c,temp__c from Lead];
    System.assertEquals(true,ld.size()>0);
    CreateLeadController obj01 = new CreateLeadController();
    CreateLeadController.getEpsysDetails();
  }
}