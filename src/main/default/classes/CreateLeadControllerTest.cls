@isTest
private class CreateLeadControllerTest{
  	@testSetup
	static void setupTestData(){
    	
        test.startTest();
    	Group g1 = new Group(Name='Branch 14 - 1600 Smith Queue', type='Queue');
        insert g1;
  		Episys_User__c eu = new Episys_User__c();
        eu.Episys_ID__c = 1;
        eu.Episys_Name__c = 'test';
        eu.Assigned_Branch__c =14;
        insert eu;
            
    	Lead ld = new Lead(LastName = 'LastName268', Status = 'New',Brand__c = 'CFCU', HasOptedOutOfEmail = false, IsConverted = false, IsUnreadByOwner = false, CreatedDate = DateTime.now(), //CreatedById = acc.id,
                       LastModifiedDate = DateTime.now(), smagicinteract__SMSOptOut__c = false, Escalated__c = false, Membership_Required_old__c = false, Keep__c = false, 
                       et4ae5__HasOptedOutOfMobile__c = false, Episys_User_ID__c =1, Product_Type__c ='Cards', Product_Subtype__c ='Credit Cards',Episys_Flag__c = false, temp__c = false, LeadSource='PTM');
    	Insert ld; 
    	test.stopTest();
  }
	
    static testMethod void test_FetchLeedData(){
   		test.startTest();
    	String RecTypeId= [select Id from RecordType where (Name='Person Account') and (SobjectType='Account')].Id;
        
        Lead led = new Lead(Brand__c = 'CFCU',LastName = 'LastName268', Status = 'New', HasOptedOutOfEmail = false, IsConverted = false, IsUnreadByOwner = false, CreatedDate = DateTime.now(), //CreatedById = acc.id,
                       LastModifiedDate = DateTime.now(), smagicinteract__SMSOptOut__c = false, Escalated__c = false, Membership_Required_old__c = false, Keep__c = false, 
                       et4ae5__HasOptedOutOfMobile__c = false, Episys_User_ID__c =1, Product_Type__c ='Cards', Product_Subtype__c ='Credit Cards',Episys_Flag__c = false, temp__c = false, LeadSource='PTM');
 
        
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
    	String uid = UserInfo.getUserId();
        User usr = [Select id, name, alias from User where id=:uid]; 
        
        Episys_User__c euc = new Episys_User__c();
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
        CreateLeadController.LeadInsertUpdate(led,acc.id);
       	test.stopTest();

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
    
    static testMethod void test_FetchLeedData1(){
   		test.startTest();
    	String RecTypeId= [select Id from RecordType where (Name='Person Account') and (SobjectType='Account')].Id;
        
        Lead led = new Lead(Brand__c = 'CFCU',LastName = 'LastName268', Status = 'New', HasOptedOutOfEmail = false, IsConverted = false, IsUnreadByOwner = false, CreatedDate = DateTime.now(), //CreatedById = acc.id,
                       LastModifiedDate = DateTime.now(), smagicinteract__SMSOptOut__c = false, Escalated__c = false, Membership_Required_old__c = false, Keep__c = false, 
                       et4ae5__HasOptedOutOfMobile__c = false, Episys_User_ID__c =1, Product_Type__c ='Cards', Product_Subtype__c ='Credit Cards',Episys_Flag__c = false, temp__c = false, LeadSource='PTM');
 
        
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
    	String uid = UserInfo.getUserId();
        User usr = [Select id, name, alias from User where id=:uid]; 
        
        Episys_User__c euc = new Episys_User__c();
        euc.Alias__c =  usr.alias;
        euc.Assigned_Branch__c = 105;
        euc.Default__c = true;
        euc.Episys_ID__c = 1111;
        euc.Episys_Name__c = 'Test';
	    insert euc;
        
        Episys_User__c euc1 = new Episys_User__c();
        euc1.Alias__c =  usr.alias;
        euc1.Assigned_Branch__c = 106;
        euc1.Default__c = true;
        euc1.Episys_ID__c = 8147;
        euc1.Episys_Name__c = 'Test RJ';
	    insert euc1;
        
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
        CreateLeadController.LeadInsertUpdate(led,acc.id);
       	test.stopTest();

  	}
}