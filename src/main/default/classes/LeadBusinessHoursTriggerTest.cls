@isTest
public class LeadBusinessHoursTriggerTest {
	static testMethod void LeadBusinessHoursTriggerTest(){
		
        
    	Group g1 = new Group(Name='Branch 14 - 1600 Smith Queue', type='Queue');
            insert g1;
        Group g2 = new Group(Name='Products & Services Referral Queue', type='Queue',Email ='cards_accounts_shares@opportunity.com');
            insert g2;
        
         QueueSobject mappingObject = new QueueSobject(QueueId = g1.Id, SobjectType = 'Lead');
        System.runAs(new User(Id = UserInfo.getUserId()))
        {insert mappingObject;}
        
        
         QueueSobject mappingObject1 = new QueueSobject(QueueId = g2.Id, SobjectType = 'Lead');
        System.runAs(new User(Id = UserInfo.getUserId()))
        {insert mappingObject1;}
      
     
       
         User ur = [select id,name,alias from user where id=:UserInfo.getUserID()];
         Episys_User__c eu = new Episys_User__c();
             eu.Episys_ID__c = 1;
             eu.Episys_Name__c = 'test';
             eu.Assigned_Branch__c =14;
             eu.alias__c = ur.alias;
        insert eu;
       
        Episys_User__c eu1 = new Episys_User__c();
             eu1.Episys_ID__c = 2;
        	 eu1.alias__c = ur.alias;
             eu1.Episys_Name__c = 'test';
             eu1.Assigned_Branch__c =14;
             eu1.Default__c = true;
        insert eu1;
            
            
         Lead newlead = new Lead(Brand__c='CFCU', FirstName = 'FirstName270',LastName = 'LastName268', Status = 'New', HasOptedOutOfEmail = false, IsConverted = false, IsUnreadByOwner = false, 
                       smagicinteract__SMSOptOut__c = false, Escalated__c = false, Membership_Required_old__c = false, Keep__c = false, et4ae5__HasOptedOutOfMobile__c = false, Episys_Flag__c = false,
                                temp__c = false, Episys_User_ID__c= 1,LeadSource = 'Other', Product_Type__c ='Cards');
         Lead newlead1 = new Lead(Brand__c='CFCU',FirstName = 'FirstName270',LastName = 'LastName268', Status = 'New', HasOptedOutOfEmail = false, IsConverted = false, IsUnreadByOwner = false, 
                       smagicinteract__SMSOptOut__c = false, Escalated__c = false, Membership_Required_old__c = false, Keep__c = false, et4ae5__HasOptedOutOfMobile__c = false, Episys_Flag__c = false,
                                temp__c = false, Episys_User_ID__c= 1,LeadSource = 'Branch Walk in', Product_Type__c ='Cards');
        Lead newlead2 = new Lead(Brand__c='CFCU',FirstName = 'FirstName270',LastName = 'LastName269', Status = 'Prospect Considering', HasOptedOutOfEmail = false, IsConverted = false, IsUnreadByOwner = false, 
                       smagicinteract__SMSOptOut__c = false, Escalated__c = false, Membership_Required_old__c = false, Keep__c = false, et4ae5__HasOptedOutOfMobile__c = false, Episys_Flag__c = false,
                                temp__c = false, Episys_User_ID__c= 1,LeadSource = 'Branch Walk in', Product_Type__c ='Cards');
         Lead newlead3 = new Lead(Brand__c='CFCU',FirstName = 'FirstName270',LastName = 'LastName268', Status = 'Prospect Considering', HasOptedOutOfEmail = false, IsConverted = false, IsUnreadByOwner = false, 
                       smagicinteract__SMSOptOut__c = false, Escalated__c = false, Membership_Required_old__c = false, Keep__c = false, et4ae5__HasOptedOutOfMobile__c = false, Episys_Flag__c = false,
                                temp__c = false, Episys_User_ID__c= 1033,LeadSource = 'Branch Walk in', Product_Type__c ='Cards');
        
        Lead newlead5 = new Lead(Brand__c='CFCU',FirstName = 'FirstName270',LastName = 'LastName270', Status = 'new', HasOptedOutOfEmail = false, IsConverted = false, IsUnreadByOwner = false, 
                       smagicinteract__SMSOptOut__c = false, Escalated__c = false, Membership_Required_old__c = false, Keep__c = false, et4ae5__HasOptedOutOfMobile__c = false, Episys_Flag__c = false,
                                temp__c = false, LeadSource = 'Event', Product_Type__c ='Cards');
        test.StartTest();
		
    	Insert newlead; 
        Insert newlead1;
        Insert newlead2;
        Insert newlead3;  
        Insert newlead5;
       
    	OpenHours__c olc = new OpenHours__c();
    	olc.leadid__c = newlead.id;
    	Insert olc; 
		
		OpenLeadBusinessHours ol = new OpenLeadBusinessHours();
		ol.execute(null);
		
        delete eu;
      
		delete eu1; 
		test.StopTest();		
	}
    static testMethod void LeadBusinessHoursTriggerTest1(){
		test.StartTest();
        User ur = [select id,name,alias from user where id=:UserInfo.getUserID()];
       
        Group g2 = new Group(Name='Products & Services Referral Queue', type='Queue',Email ='accounts_shares@lead.com');
            insert g2;
        
        Lead newlead5 = new Lead(Brand__c='CFCU',FirstName = 'FirstName270',LastName = 'LastName270', Status = 'new', HasOptedOutOfEmail = false, IsConverted = false, IsUnreadByOwner = false, 
                       smagicinteract__SMSOptOut__c = false, Escalated__c = false, Membership_Required_old__c = false, Keep__c = false, et4ae5__HasOptedOutOfMobile__c = false, Episys_Flag__c = false,
                                temp__c = false,  LeadSource = 'Event', Product_Type__c ='Accounts/Shares');
        Insert newlead5;
       
		
		OpenLeadBusinessHours ol = new OpenLeadBusinessHours();
		ol.execute(null);
		
		test.StopTest();		
	}
     static testMethod void LeadBusinessHoursTriggerTest2(){
		test.StartTest();
         Profile testProfile = [SELECT Id 
                           FROM profile
                           WHERE Name = 'CFCU Admin' 
                           LIMIT 1];
         User testUser = new User(LastName = 'test user 1', 
                             Username = 'testing.user.1@example.com', 
                             Email = 'test.1@example.com', 
                             Alias = 'testu1', 
                             TimeZoneSidKey = 'GMT', 
                             LocaleSidKey = 'en_GB', 
                             EmailEncodingKey = 'ISO-8859-1', 
                             ProfileId = testProfile.Id, 
                             LanguageLocaleKey = 'en_US');
         
        Episys_User__c eu = new Episys_User__c();
             eu.Episys_ID__c = 1538;
             eu.Episys_Name__c = 'test';
             eu.Assigned_Branch__c =14;
             eu.alias__c = testUser.alias;
        insert eu; 
         
        Id LeadRT = Schema.SObjectType.Lead.getRecordTypeInfosByName().get('Company Lead').getRecordTypeId();
      
        Lead newlead4 = new Lead(Brand__c='CFCU',FirstName = 'FirstName270',LastName = 'LastName270', Status = 'New',company = 'c', RecordTypeId = LeadRT, HasOptedOutOfEmail = false, IsConverted = false, IsUnreadByOwner = false, 
                       smagicinteract__SMSOptOut__c = false, Escalated__c = false, Membership_Required_old__c = false, Keep__c = false, et4ae5__HasOptedOutOfMobile__c = false, Episys_Flag__c = false,
                       temp__c = false, Episys_User_ID__c= 1538, LeadSource = 'Branch Walk in', Product_Type__c ='Cards');
        system.runAs(testUser) {
        	Insert newlead4;
        }
        system.runAs(testUser) {
        	newlead4.Status = 'Outreach';
            newlead4.Sub_Status__c = '1st attempt';
            update newlead4;
        } 
		
		test.StopTest();		
	}
	static testMethod void LeadBusinessHoursTriggerTest3(){
		test.StartTest();
         Profile testProfile = [SELECT Id 
                           FROM profile
                           WHERE Name = 'CFCU Admin' 
                           LIMIT 1];
         User testUser = new User(LastName = 'test user 1', 
                             Username = 'testing.user.1@example.com', 
                             Email = 'test.1@example.com', 
                             Alias = 'testu1', 
                             TimeZoneSidKey = 'GMT', 
                             LocaleSidKey = 'en_GB', 
                             EmailEncodingKey = 'ISO-8859-1', 
                             ProfileId = testProfile.Id, 
                             LanguageLocaleKey = 'en_US');
         
        Episys_User__c eu = new Episys_User__c();
             eu.Episys_ID__c = 1538;
             eu.Episys_Name__c = 'test';
             eu.Assigned_Branch__c =14;
             eu.alias__c = testUser.alias;
        insert eu; 
         
        Id LeadRT = Schema.SObjectType.Lead.getRecordTypeInfosByName().get('Non-Member Lead').getRecordTypeId();
      
        Lead newlead4 = new Lead(Brand__c='CFCU',FirstName = 'FirstName270',LastName = 'LastName270', Status = 'New',company = 'c', RecordTypeId = LeadRT, HasOptedOutOfEmail = false, IsConverted = false, IsUnreadByOwner = false, 
                       smagicinteract__SMSOptOut__c = false, Escalated__c = false, Membership_Required_old__c = false, Keep__c = false, et4ae5__HasOptedOutOfMobile__c = false, Episys_Flag__c = false,
                       temp__c = false, Episys_User_ID__c= 1538, LeadSource = 'Branch Walk in', Product_Type__c ='Cards');
        system.runAs(testUser) {
        	Insert newlead4;
        }
		
		test.StopTest();		
	}
	static testMethod void LeadBusinessHoursTriggerTest4(){
		test.StartTest();
        Profile testProfile = [SELECT Id 
                           FROM profile
                           WHERE Name = 'CFCU Admin' 
                           LIMIT 1];
         User testUser = new User(LastName = 'test user 1', 
                             Username = 'testing.user.1@example.com', 
                             Email = 'test.1@example.com', 
                             Alias = 'testu1', 
                             TimeZoneSidKey = 'GMT', 
                             LocaleSidKey = 'en_GB', 
                             EmailEncodingKey = 'ISO-8859-1', 
                             ProfileId = testProfile.Id, 
                             LanguageLocaleKey = 'en_US');
         
        Id LeadRT = Schema.SObjectType.Lead.getRecordTypeInfosByName().get('Non-Member Lead').getRecordTypeId();
      
        Lead newlead4 = new Lead(Brand__c='CFCU',FirstName = 'FirstName270',LastName = 'LastName270', Status = 'New',company = 'c', RecordTypeId = LeadRT, HasOptedOutOfEmail = false, IsConverted = false, IsUnreadByOwner = false, 
                       smagicinteract__SMSOptOut__c = false, Escalated__c = false, Membership_Required_old__c = false, Keep__c = false, et4ae5__HasOptedOutOfMobile__c = false, Episys_Flag__c = false,
                       temp__c = false, Episys_User_ID__c= 1538, LeadSource = 'Branch Walk in', Product_Type__c ='Cards');
        system.runAs(testUser) {
        	Insert newlead4;
        }
		
		test.StopTest();		
	}    
    static testMethod void LeadBusinessHoursTriggerTest5(){
		test.StartTest();
          Profile testProfile = [SELECT Id 
                           FROM profile
                           WHERE Name = 'CFCU Admin' 
                           LIMIT 1];
         User testUser = new User(LastName = 'test user 1', 
                             Username = 'testing.user.1@example.com', 
                             Email = 'test.1@example.com', 
                             Alias = 'testu1', 
                             TimeZoneSidKey = 'GMT', 
                             LocaleSidKey = 'en_GB', 
                             EmailEncodingKey = 'ISO-8859-1', 
                             ProfileId = testProfile.Id, 
                             LanguageLocaleKey = 'en_US');
         
        Id LeadRT = Schema.SObjectType.Lead.getRecordTypeInfosByName().get('Non-Member Lead').getRecordTypeId();
      
        Lead newlead4 = new Lead(Brand__c='CFCU',FirstName = 'FirstName270',LastName = 'LastName270', Status = 'New',company = 'c', RecordTypeId = LeadRT, HasOptedOutOfEmail = false, IsConverted = false, IsUnreadByOwner = false, 
                       smagicinteract__SMSOptOut__c = false, Escalated__c = false, Membership_Required_old__c = false, Keep__c = false, et4ae5__HasOptedOutOfMobile__c = false, Episys_Flag__c = false,
                       temp__c = false, Episys_User_ID__c= 1538, LeadSource = 'Event', Product_Type__c ='Cards');
        system.runAs(testUser) {
        	Insert newlead4;
        }
		
		test.StopTest();		
	}
    static testMethod void LeadBusinessHoursTriggerTest6(){
		test.StartTest();
        Profile testProfile = [SELECT Id 
                           FROM profile
                           WHERE Name = 'CFCU Admin' 
                           LIMIT 1];
         User testUser = new User(LastName = 'test user 1', 
                             Username = 'testing.user.1@example.com', 
                             Email = 'test.1@example.com', 
                             Alias = 'testu1', 
                             TimeZoneSidKey = 'GMT', 
                             LocaleSidKey = 'en_GB', 
                             EmailEncodingKey = 'ISO-8859-1', 
                             ProfileId = testProfile.Id, 
                             LanguageLocaleKey = 'en_US');
         
        Id LeadRT = Schema.SObjectType.Lead.getRecordTypeInfosByName().get('Non-Member Lead').getRecordTypeId();
      
        Lead newlead4 = new Lead(Brand__c='CFCU',FirstName = 'FirstName270',LastName = 'LastName270', Status = 'New',company = 'c', RecordTypeId = LeadRT, HasOptedOutOfEmail = false, IsConverted = false, IsUnreadByOwner = false, 
                       smagicinteract__SMSOptOut__c = false, Escalated__c = false, Membership_Required_old__c = false, Keep__c = false, et4ae5__HasOptedOutOfMobile__c = false, Episys_Flag__c = false,
                       temp__c = false, Episys_User_ID__c= 1538, LeadSource = 'Other', Product_Type__c ='Cards');
        system.runAs(testUser) {
        	Insert newlead4;
        }
		
		test.StopTest();		
	}
    static testMethod void LeadBusinessHoursTriggerTest7(){
		
         Profile testProfile = [SELECT Id 
                           FROM profile
                           WHERE Name = 'CFCU Admin' 
                           LIMIT 1];
         User testUser = new User(LastName = 'test user 1', 
                             Username = 'testing.user.1@example.com', 
                             Email = 'test.1@example.com', 
                             Alias = 'testu1', 
                             TimeZoneSidKey = 'GMT', 
                             LocaleSidKey = 'en_GB', 
                             EmailEncodingKey = 'ISO-8859-1', 
                             ProfileId = testProfile.Id, 
                             LanguageLocaleKey = 'en_US');
         
        List<Lead> leadList = new List<Lead>();
        String RecTypeId= [select Id from RecordType where (Name='Person Account') and (SobjectType='Account')].Id; 
        Id LeadRT = Schema.SObjectType.Lead.getRecordTypeInfosByName().get('Non-Member Lead').getRecordTypeId();
      	List<Person_Account__c> palist = new List<Person_Account__c>();
        List<Account_Details__c> acclist = new List<Account_Details__c>();
        
        Account acc = new Account(
        RecordTypeID=RecTypeId,
        FirstName='Test FName',
        LastName='Test LName',
        PersonMailingStreet='street',
        PersonMailingPostalCode='12345',
        PersonMailingCity='SFO',
        Email_raw__c='test@yahoo.com',
        PersonHomePhone='1234567',
        PersonMobilePhone='12345678');         
        insert acc;
		
        test.StartTest();
        
		Account_Details__c accDetails = new Account_Details__c();
           accDetails.Name = 'test';
           accDetails.RESTRICTED_ACCESS__c = 1;
           accDetails.RecType__c = 'ACCT';
           accDetails.Reference__c  = 'BC02';
        
        
        Account_Details__c accDetails2 = new Account_Details__c();
           accDetails2.Name = 'test2';
           accDetails2.RESTRICTED_ACCESS__c = 1;
           accDetails2.RecType__c = 'ACCT';
           accDetails2.Reference__c  = 'BC01';
        
        acclist.add(accDetails);
        acclist.add(accDetails2);
        insert acclist;
        
        Person_Account__c pa = new Person_Account__c();
           pa.PersonID__c = acc.Id;
           pa.Account_Number__c = accDetails.Id;
           pa.Name_Type__c = 0;
        
        
        Person_Account__c pa2 = new Person_Account__c();
           pa2.PersonID__c = acc.Id;
           pa2.Account_Number__c = accDetails2.Id;
           pa2.Name_Type__c = 0;
        
        palist.add(pa);
        palist.add(pa2);
        insert palist;
        
        Lead newlead1 = new Lead(Are_you_a_current_member__c = 'No', Brand__c='CFCU',I_m_interested_in__c = 'Xpress Form - Web',FirstName = 'FirstName270',LastName = 'LastName270', Status = 'New',company = 'c', RecordTypeId = LeadRT, HasOptedOutOfEmail = false, IsConverted = false, IsUnreadByOwner = false, 
                       Home_Phone__c = '555-555-5555',email = 'test1@yahoo.com',smagicinteract__SMSOptOut__c = false, Escalated__c = false, Membership_Required_old__c = false, Keep__c = false, et4ae5__HasOptedOutOfMobile__c = false, Episys_Flag__c = false,
                       temp__c = false, Episys_User_ID__c= 1538, LeadSource = 'Xpress Form - Web', Product_Type__c ='Mortgage');
        
        Lead newlead2 = new Lead(Brand__c='Spectrum',I_m_interested_in__c = 'Xpress Form - Web',FirstName = 'FirstName270',LastName = 'LastName270', Status = 'New',company = 'c', RecordTypeId = LeadRT, HasOptedOutOfEmail = false, IsConverted = false, IsUnreadByOwner = false, 
                       Home_Phone__c = '556-555-5555',email = 'test@yahoo.com',smagicinteract__SMSOptOut__c = false, Escalated__c = false, Membership_Required_old__c = false, Keep__c = false, et4ae5__HasOptedOutOfMobile__c = false, Episys_Flag__c = false,
                       temp__c = false, Episys_User_ID__c= 1538, LeadSource = 'Xpress Form - Web', Product_Type__c ='Mortgage');
        
        Lead newlead3 = new Lead(Brand__c='CFCU',I_m_interested_in__c = 'Xpress Form - Web',FirstName = 'FirstName270',LastName = 'LastName270', Status = 'New',company = 'c', RecordTypeId = LeadRT, HasOptedOutOfEmail = false, IsConverted = false, IsUnreadByOwner = false, 
                       Home_Phone__c = '556-555-5555',email = 'test@yahoo.com',smagicinteract__SMSOptOut__c = false, Escalated__c = false, Membership_Required_old__c = false, Keep__c = false, et4ae5__HasOptedOutOfMobile__c = false, Episys_Flag__c = false,
                       temp__c = false, Episys_User_ID__c= 1538, LeadSource = 'Xpress Form - Web', Product_Type__c ='Mortgage');
        
        leadList.add(newlead1);
        leadList.add(newlead2);
        leadList.add(newlead3);
        
        system.runAs(testUser) {
        	Insert leadList;
        }
		
		test.StopTest();		
	}
    static testMethod void LeadBusinessHoursTriggerTest8(){
		 test.StartTest();
        //User ur = [select id,name,alias from user where alias='JFRA'];
          Profile testProfile = [SELECT Id 
                           FROM profile
                           WHERE Name = 'CFCU Admin' 
                           LIMIT 1];
         User testUser = new User(LastName = 'test user 1', 
                             Username = 'testing.user.1@example.com', 
                             Email = 'test.1@example.com', 
                             Alias = 'testu1', 
                             TimeZoneSidKey = 'GMT', 
                             LocaleSidKey = 'en_GB', 
                             EmailEncodingKey = 'ISO-8859-1', 
                             ProfileId = testProfile.Id, 
                             LanguageLocaleKey = 'en_US');
        List<Lead> leadList = new List<Lead>();
        String RecTypeId= [select Id from RecordType where (Name='Person Account') and (SobjectType='Account')].Id; 
        Id LeadRT = Schema.SObjectType.Lead.getRecordTypeInfosByName().get('Non-Member Lead').getRecordTypeId();
      	List<Person_Account__c> palist = new List<Person_Account__c>();
        List<Account_Details__c> acclist = new List<Account_Details__c>();
        
        Account acc = new Account(
        RecordTypeID=RecTypeId,
        FirstName='Test FName',
        LastName='Test LName',
        PersonMailingStreet='street',
        PersonMailingPostalCode='12345',
        PersonMailingCity='SFO',
        Email_raw__c='test@yahoo.com',
        PersonHomePhone='1234567',
        PersonMobilePhone='12345678');         
        insert acc;
		
        Lead newlead1 = new Lead(Are_you_a_current_member__c = 'No', Brand__c='Spectrum',I_m_interested_in__c = 'Xpress Form - Web',FirstName = 'FirstName270',LastName = 'LastName270', Status = 'New',company = 'c', RecordTypeId = LeadRT, HasOptedOutOfEmail = false, IsConverted = false, IsUnreadByOwner = false, 
                       Home_Phone__c = '555-555-5555',email = 'test@yahoo.com',smagicinteract__SMSOptOut__c = false, Escalated__c = false, Membership_Required_old__c = false, Keep__c = false, et4ae5__HasOptedOutOfMobile__c = false, Episys_Flag__c = false,
                       temp__c = false, Episys_User_ID__c= 1538, LeadSource = 'Xpress Form - Web', Product_Type__c ='Mortgage');
       
        leadList.add(newlead1);
      
        system.runAs(testUser) {
        	Insert leadList;
        }
		
		test.StopTest();		
	}
    static testMethod void LeadBusinessHoursTriggerTest9(){
      
        test.StartTest();	
        Group g1 = new Group(Name='Branch 14 - 1600 Smith Queue', type='Queue');
            insert g1;
        Group g2 = new Group(Name='Products & Services Referral Queue', type='Queue',Email ='cards_accounts_shares@opportunity.com');
            insert g2;
      
          User ur = [select id,name,alias from user where id=:UserInfo.getUserID()];
          Episys_User__c eu = new Episys_User__c();
             eu.Episys_ID__c = 1;
             eu.Episys_Name__c = 'test';
             eu.Assigned_Branch__c =14;
             eu.alias__c = ur.alias;
        insert eu;
        
          List<Lead> leadList = new List<Lead>();
     List<BusinessHours> bhs=[select id from BusinessHours where IsDefault=true];
       System.assert(bhs.size()==1);      
        
     
        Lead newlead0 = new Lead(Brand__c='CFCU',FirstName = 'FirstName270',LastName = 'LastName270', Status = 'New', HasOptedOutOfEmail = false, IsConverted = false, IsUnreadByOwner = false, 
                       smagicinteract__SMSOptOut__c = false, Escalated__c = false, Membership_Required_old__c = false, Keep__c = false, et4ae5__HasOptedOutOfMobile__c = false, Episys_Flag__c = false,
                                temp__c = false,  LeadSource = 'Branch Call', Product_Type__c ='Mortgage');
        leadList.add(newlead0);
        Insert newlead0;
         
        newlead0.Status='Considering';
      
        update newlead0;
       
     Lead newlead1 = new Lead(Brand__c='CFCU',FirstName = 'FirstName270',LastName = 'LastName270', Status = 'Outreach', HasOptedOutOfEmail = false, IsConverted = false, IsUnreadByOwner = false, 
                       smagicinteract__SMSOptOut__c = false, Escalated__c = false, Membership_Required_old__c = false, Keep__c = false, et4ae5__HasOptedOutOfMobile__c = false, Episys_Flag__c = false,
                                temp__c = false,  LeadSource = 'Branch Call', Product_Type__c ='Mortgage',Sub_Status__c='No Response',Product_Amount__c=28.00);
	      leadList.add(newlead1);
        Insert newlead1;
       newlead1.Status='New';
      
      
        update newlead1;
         Lead newlead2 = new Lead(Brand__c='CFCU',FirstName = 'FirstName270',LastName = 'LastName270', Status = 'Considering', HasOptedOutOfEmail = false, IsConverted = false, IsUnreadByOwner = false, 
                       smagicinteract__SMSOptOut__c = false, Escalated__c = false, Membership_Required_old__c = false, Keep__c = false, et4ae5__HasOptedOutOfMobile__c = false, Episys_Flag__c = false,
                                temp__c = false,  LeadSource = 'Branch Call', Product_Type__c ='Mortgage',Sub_Status__c='No Response',Product_Amount__c=28.00);
	   leadList.add(newlead2);
        Insert newlead2;
       newlead2.Status='Outreach';
        newlead2.Sub_Status__c = '1st attempt';
         newlead2.TimeStamp_Outreach_status__c = Datetime.now();

        update newlead2;
        
        newlead2.Status='New';
        newlead2.SLA__c = 10.0;
        newlead2.Hour_Spent_New_Status__c=1.00;
         update newlead2;

		test.StopTest();		
	}
}