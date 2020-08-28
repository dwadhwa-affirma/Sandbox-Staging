/**
 * This class contains unit tests for validating the behavior of Apex classes
 * and triggers.
 *
 * Unit tests are class methods that verify whether a particular piece
 * of code is working properly. Unit test methods take no arguments,
 * commit no data to the database, and are flagged with the testMethod
 * keyword in the method definition.
 *
 * All test methods in an organization are executed whenever Apex code is deployed
 * to a production organization to confirm correctness, ensure code
 * coverage, and prevent regressions. All Apex classes are
 * required to have at least 75% code coverage in order to be deployed
 * to a production organization. In addition, all triggers must have some code coverage.
 * 
 * The @isTest class annotation indicates this class only contains test
 * methods. Classes defined with the @isTest annotation do not count against
 * the organization size limit for all Apex scripts.
 *
 * See the Apex Language Reference for more information about Testing and Code Coverage.
 */
@isTest
private class ConvertPreMemberToMemberSchedularTest {

    static testMethod void myUnitTest() {
     
   	MemberConversionSetting__c mcs = new MemberConversionSetting__c();
      
      mcs.Automation__c = 10;
      mcs.Manual__c = 10;
      mcs.Name = 'PrimaryRecord';
      insert mcs;

      
       RecordType rec = [Select Name, Id From RecordType where sObjectType='Account' and isActive=true and Name='Person Account'];
       
        RecordType rec1 = [Select Name, Id From RecordType where sObjectType='Account' and isActive=true and Name='Pre Member'];
       
        Create_SLA__c cl = new Create_SLA__c();
        cl.Status__c = 'Open';
        cl.Name = 'Open';
        cl.hours__c = 8;
        insert cl;
        
        Create_SLA__c cl1 = new Create_SLA__c();
        cl1.Status__c = 'In Process';
        cl1.Name = 'In Process';
        cl1.hours__c = 20;
        insert cl1;
        
        Create_SLA__c cl2 = new Create_SLA__c();
        cl2.Status__c = 'Resolution';
        cl2.Name = 'Resolution';
        cl2.hours__c = 20;
        insert cl2;
        
        Account act = new Account();
        act.FirstName = 'Test';
        act.LastName = 'Test1';
        act.PersonEmail = 'test@test.com';
        act.Alternate_Email__pc = 'test1@gmail.com';
        act.Alt_Email_Raw__c ='test2@gmail.com';
        act.Email_raw__c ='test3@gmail.com';
        act.RecordtypeId = rec.Id;
        act.Residential_Street__pc = '11';
        act.Home_Phone__pc ='011-11111';
        insert act;
        
        Account pact = new Account();
        pact.FirstName = 'Test';
        pact.LastName = 'Test1';
        pact.PersonEmail = 'test@test.com';
        pact.RecordtypeId = rec1.Id;
        pact.Residential_Street__pc ='11';
        pact.Home_Phone__pc ='011-11111';
        insert pact;
        
        opportunity opp = new Opportunity();
        opp.Accountid = pact.id;
        opp.Name = 'Name';
        opp.StageName = 'Closed Won';
        opp.CloseDate = system.today();
        opp.Is_Converted__c = true;
        opp.DESCRIPTION = 'DESCRIPTION';
        opp.Opportunity_Source__c = 'Campaign Outreach';
        
        insert opp;
        
        Case cas = new Case();
        cas.Accountid = pact.id;
        cas.Brand__c ='Chevron';
        insert cas;
		Needs_Assesment__c na = new Needs_Assesment__c();
        na.Member__c = pact.id;
        insert na;
        
        NA_Other_Existing_Loans__c nao = new NA_Other_Existing_Loans__c();
        nao.Needs_Assessment__c = na.id;
        insert nao;
        
        NA_Membership_Referral_Questions__c nq = new NA_Membership_Referral_Questions__c();
        nq.Needs_Assessment__c = na.id;
        insert nq;
        
        NA_Deposit__c dep = new NA_Deposit__c();
        dep.Needs_Assessment__c = na.id;
        insert dep;
        
        Test.startTest();
        Account_Details__c account_details_Obj = new Account_Details__c(Open_Date__c = Date.newInstance(2020, 2, 2),Onboarded__c = false, RecType__c = 'ACCT', TypeTranslate__c = '2-TRUST');
    	Insert account_details_Obj;
        
        Person_Account__c person_account_Obj = new Person_Account__c(Name_Type__c = 0,Account_Number__c = account_details_Obj.id, PersonID__c = act.id, Relationship__c = null, TypeTranslate__c = '0000/Primary');
    	Insert person_account_Obj;
        
        Account act1 = new Account();
        act1.FirstName = 'Test1';
        act1.LastName = 'Test11';
        act1.Email_raw__c = 'test1@test.com';
        act1.RecordtypeId = rec.Id;
        act1.Residential_Street__pc = '11';
        act1.BIRTH_DATE__pc = system.Today().addyears(20);
        insert act1;
         
         
        Account_Details__c account_details_Obj1 = new Account_Details__c(Open_Date__c = Date.newInstance(2020, 2, 2),Onboarded__c = false, RecType__c = 'ACCT', TypeTranslate__c = '2-TRUST');
    	Insert account_details_Obj1;
        
        Person_Account__c person_account_Obj1 = new Person_Account__c(Name_Type__c = 0,Account_Number__c = account_details_Obj1.id, PersonID__c = act1.id, Relationship__c = null, TypeTranslate__c = '0000/Primary');
    	Insert person_account_Obj1;
        
        Account act2 = new Account();
        act2.FirstName = 'Test2';
        act2.LastName = 'Testl2';
        act2.Email_raw__c = 'test2@test.com';
        act2.RecordtypeId = rec.Id;
        act2.Residential_Street__pc = '11';
        act2.BIRTH_DATE__pc = system.Today().addyears(20);
        act2.Residential_Zipocde__pc ='112233';
        act2.Mobile_Phone__pc ='989898';
        act2.Home_Phone__pc ='010101';
        act2.Work_Phone__pc ='787878';
        act2.Alt_Email_Raw__c = 'test2@gmail.com';
        insert act2;
        
        Account pact1 = new Account();
        pact1.FirstName = 'Test1';
        pact1.LastName = 'Test11';
        pact1.Email_raw__c = 'test1@test.com';
        pact1.RecordtypeId = rec1.Id;
        pact1.Residential_Street__pc ='11';
        pact1.BIRTH_DATE__pc = system.Today().addyears(20);
        insert pact1;
        
        Account act12 = new Account();
        act12.FirstName = 'Test2';
        act12.LastName = 'Test2';
        act12.RecordtypeId = rec.Id;
        act12.Residential_Street__pc ='11';
        act12.BIRTH_DATE__pc = system.Today().addyears(20);
        act12.Residential_Zipocde__pc ='112233';
        insert act12;
        
        Account pact2 = new Account();
        pact2.FirstName = 'Test2';
        pact2.LastName = 'Test2';
        pact2.RecordtypeId = rec1.Id;
        pact2.Residential_Street__pc ='11';
        pact2.BIRTH_DATE__pc = system.Today().addyears(20);
        pact2.Residential_Zipocde__pc ='112233';
        insert pact2;
        
        Account pact3 = new Account();
        pact3.FirstName = 'Test3';
        pact3.LastName = 'Test3';
        pact3.Email_raw__c = 'test3@test.com';
        pact3.Alternate_Email__pc ='test1@gmail.com';
        pact3.Alt_Email_Raw__c = 'test2@gmail.com';
        pact3.RecordtypeId = rec1.Id;
        pact3.BIRTH_DATE__pc = system.Today().addyears(20);
        pact3.Residential_Zipocde__pc ='112233';
        insert pact3;
        Account pact4 = new Account();
        pact4.FirstName = 'Test3';
        pact4.LastName = 'Test3';
        pact4.Email_raw__c = 'test3@test.com';
        pact4.RecordtypeId = rec1.Id;
        pact4.Residential_Street__pc ='33';
        pact4.BIRTH_DATE__pc = system.Today().addyears(20);
        pact4.Residential_Zipocde__pc ='112233';
        pact4.Mobile_Phone__pc ='989898';
        pact4.Home_Phone__pc ='010101';
        pact4.Work_Phone__pc ='787878';
        insert pact4;
        
        Account act5 = new Account();
        act5.FirstName = 'Test5';
        act5.LastName = 'LTest5';
        act5.Email_raw__c = 'test3@test.com';
        act5.RecordtypeId = rec.Id;
        insert act5;
        
        Account pact5 = new Account();
        pact5.FirstName = 'Test5';
        pact5.LastName = 'LTest51';
        pact5.Email_raw__c = 'test31@test.com';
        pact5.RecordtypeId = rec1.Id;
        insert pact5;
        
        
        Account act6 = new Account();
        act6.FirstName = 'Test6';
        act6.LastName = 'LTest6';
        act6.RecordtypeId = rec.Id;
        act6.Residential_City__pc='ct';
        insert act6;
        
        Account pact6 = new Account();
        pact6.FirstName = 'Test61';
        pact6.LastName = 'LTest61';
        pact6.RecordtypeId = rec1.Id;
        pact6.Residential_City__pc='ct';
        insert pact6;
        
        Account pact7 = new Account();
        pact7.FirstName = 'Test7';
        pact7.LastName = 'Test7';
        pact7.Email_raw__c = 'test7@test.com';
        pact7.RecordtypeId = rec1.Id;
        pact7.Residential_Street__pc ='33';
        pact7.BIRTH_DATE__pc = system.Today().addyears(20);
        pact7.Residential_Zipocde__pc ='112233';
        pact7.Mobile_Phone__pc ='989898';
        pact7.Home_Phone__pc ='010101';
        pact7.Work_Phone__pc ='787878';
        insert pact7;
        
        
        Account act8 = new Account();
        act8.FirstName = 'Test8';
        act8.LastName = 'LTest8';
        act8.Residential_Street__pc = 's8';
        act8.RecordtypeId = rec.Id;
        
        insert act8;
        
        Account pact8 = new Account();
        pact8.FirstName = 'Test8';
        pact8.LastName = 'LTest8';
        pact8.RecordtypeId = rec1.Id;
        pact8.Residential_Street__pc = 's8';
        insert pact8; 
        
        Account act9 = new Account();
        act9.FirstName = 'NonEle';
        act9.LastName = 'LNonEle';
        act9.Residential_Street__pc = 'NonEle';
        act9.RecordtypeId = rec.Id;
        
        insert act9;
        
          
        
        Set<ID> pactid = new Set<Id>();
        pactid.add(pact.id);
        pactid.add(pact1.id);
        pactid.add(pact2.id);
        pactid.add(pact3.id);
        pactid.add(pact4.id);
        pactid.add(pact5.id);
        pactid.add(pact6.id);
        pactid.add(pact7.id);
        pactid.add(pact8.id);
        
         List<Account> PreMemberAccount = [SELECT Id, PersonEmail, Email_raw__c, Alt_Email_Raw__c, FirstName,MiddleName,LastName, Name, Salutation ,Suffix,
						Phone_Check__c, Mobile_Phone__pc, Residential_Street__pc ,RecordType.Name,Residential_City__pc,Residential_State__pc, Residential_Zipocde__pc,Residential_Extra_Address__pc,createddate
    		 				 FROM Account where RecordType.Name = 'Pre Member' and IsConverted__c=false and id IN: pactid];
        
        
         String CRON_EXP = '0 0 0 15 3 ? *';
         
       
       		
        Account_Details__c account_details_Obj9 = new Account_Details__c(Open_Date__c = Date.newInstance(2020, 2, 2),Onboarded__c = false, RecType__c = 'ACCT', TypeTranslate__c = '2-TRUST');
    	Insert account_details_Obj9;
        //Person_Account__c person_account_Obj9 = new Person_Account__c(Name_Type__c = 0,Account_Number__c = account_details_Obj9.id, PersonID__c = act9.id, Relationship__c = null, TypeTranslate__c = '0000/Primary');
    	//Insert person_account_Obj9;
    	
        Test.stopTest();	
    	
        Account_Details__c account_details_Obj12 = new Account_Details__c(Open_Date__c = Date.newInstance(2020, 2, 25),Onboarded__c = false, RecType__c = 'ACCT', TypeTranslate__c = '2-TRUST');
    	Insert account_details_Obj12;
        //Person_Account__c person_account_Obj12 = new Person_Account__c(Account_Number__c = account_details_Obj12.id, PersonID__c = act12.id, Relationship__c = null, TypeTranslate__c = '0000/Primary');
    	//Insert person_account_Obj12;
    		
    		
        String jobId = System.schedule('ScheduleApexClassTest',  CRON_EXP, new ConvertPreMemberToMemberSchedular());
        CronTrigger ct = [SELECT Id, CronExpression, TimesTriggered, NextFireTime FROM CronTrigger WHERE id = :jobId];
        System.assertEquals(CRON_EXP, ct.CronExpression);
        System.assertEquals(0, ct.TimesTriggered);
       
         ConvertPreMemberToMemberSchedular.clearPhoneNumber('011 7373737');           
        // ConvertPreMemberToMemberSchedular.clearPhoneNumber(' ');
           
        
    }
}