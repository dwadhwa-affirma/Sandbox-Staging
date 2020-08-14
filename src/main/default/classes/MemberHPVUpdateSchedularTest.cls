@isTest
public class MemberHPVUpdateSchedularTest {
    static testMethod void myUnitTest() {

        Account act = new Account();
        act.FirstName = 'Test';
        act.LastName = 'Test1';
        act.PersonEmail = 'test@test.com';
        act.Alternate_Email__pc = 'test1@gmail.com';       
        act.Residential_Street__pc = '11';
        insert act;

        Account act1 = new Account();
        act1.FirstName = 'Test';
        act1.LastName = 'Test1';
        act1.PersonEmail = 'test@test.com';
        act1.Alternate_Email__pc = 'test1@gmail.com';       
        act1.Residential_Street__pc = '11';
        insert act1;

        Account_Details__c account_details_Obj2 = new Account_Details__c(Onboarded__c = false, RecType__c = 'ACCT', TypeTranslate__c = '2-TRUST', High_Value_Flag__c = 1, createddate = System.today()-1);
        Insert account_details_Obj2;
        
        Account_Details__c account_details_Obj1 = new Account_Details__c(RecType__c = 'SHAR', TypeTranslate__c = '47-2 YEAR CERTIFICATE', Activity_Date__c = null, Correspondence_Date__c = null, Assigned_Branch__c = 24, Parent_Account__c = account_details_Obj2.id, High_Value_Flag__c = 2, createddate = System.today()-1);
    	Insert account_details_Obj1;
    	
    	Account_Details__c account_details_Obj = new Account_Details__c(RecType__c = 'SHAR', TypeTranslate__c = '47-2 YEAR CERTIFICATE', Activity_Date__c = system.Today().addDays(-240), Correspondence_Date__c = system.Today().addDays(-240), Assigned_Branch__c = 24, Parent_Account__c = account_details_Obj2.id, createddate = System.today()-1);
                Insert account_details_Obj;
        
        Person_Account__c person_account_Obj = new Person_Account__c(Account_Number__c = account_details_Obj2.id, PersonID__c = act.id, Relationship__c = null, TypeTranslate__c = '0000/Primary');
            Insert person_account_Obj;
        
        Person_Account__c person_account_Obj1 = new Person_Account__c(Account_Number__c = account_details_Obj1.id, PersonID__c = act.id, Relationship__c = null, TypeTranslate__c = '0000/Primary');
            Insert person_account_Obj1;
        
        Test.startTest();
        Person_Account__c person_account_Obj2 = new Person_Account__c(Account_Number__c = account_details_Obj2.id, PersonID__c = act1.id, Relationship__c = null, TypeTranslate__c = '0000/Primary');
            Insert person_account_Obj2;
        
        Person_Account__c person_account_Obj3 = new Person_Account__c(Account_Number__c = account_details_Obj1.id, PersonID__c = act1.id, Relationship__c = null, TypeTranslate__c = '0000/Primary');
            Insert person_account_Obj3;
        
        Member_HP_HV__c hpvobj = new Member_HP_HV__c();
        hpvobj.Member__c=act1.id;
        hpvobj.Oldest_Account_Open_Date__c=System.Today()-15;
        hpvobj.Total_HPV__c=1;
        hpvobj.Total_HV__c =1;
        insert hpvobj;

        Datetime dt = Datetime.now().addMinutes(1);
        String CRON_EXP = '0 '+ dt.minute() + ' * ' + dt.day() + ' ' + dt.month() + ' ? ' + dt.year();
               
        
                   
                String jobId = System.schedule('ScheduleApexClassTest',  CRON_EXP, new MemberHPVUpdateSchedular());
                CronTrigger ct = [SELECT Id, CronExpression, TimesTriggered, NextFireTime FROM CronTrigger WHERE id = :jobId];
                System.assertEquals(CRON_EXP, ct.CronExpression);
                System.assertEquals(0, ct.TimesTriggered);
                
        Test.stopTest();


    }
}
