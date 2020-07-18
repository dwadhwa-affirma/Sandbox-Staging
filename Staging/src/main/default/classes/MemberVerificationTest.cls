@isTest
public class MemberVerificationTest {
	
	/*@TestSetup
    public static void setup() {

      Profile[] p1 = [select Id from Profile where Name = 'CFCU Admin' limit 1];
        
        User user1 = new User(alias = 'u1',lastname='test999', languagelocalekey='en_US', 
                              email='User1@avfg.com', emailencodingkey='UTF-8', 
                              localesidkey='en_US', profileId = p1[0].id, timezonesidkey='America/Los_Angeles', 
                              username='test9991'+'@avfg.com');
        
        insert user1;
        
         Case cs = new Case();
           cs.Brand__c = 'Chevron';
           cs.Previous_Owner__c = user1.Id;
           
        insert cs;
        ids1=cs.Id;
        System.debug('ids1==' + ids1);
    }*/
    
    static testMethod void testMethod1(){
    
    	
     
    	Id rtId = [SELECT Id FROM RecordType WHERE IsPersonType = TRUE AND SObjectType='Account' LIMIT 1].Id;
		Account acc = new Account();
    	acc.RecordTypeID=rtId;
    	acc.FirstName='Test FName';
        acc.LastName='Test LName';
    	acc.Mobile_Phone__pc = '9169954478';
    	acc.PersonEmail='test@yahoo.com';
    	acc.Home_Phone__pc = '1234567896';
    	acc.Work_Phone__pc = '4785123698';
        //acc.PersonHomePhone='1234567';
        acc.PersonMobilePhone='12345678';
        acc.Alternate_Email__pc = 'test@gmail.com';
        insert acc;
        
         List<AccountHistory> coh = new List<AccountHistory>{ new AccountHistory
         	(accountid = acc.id, Field = 'Mobile_Phone__pc'),
         	new AccountHistory (accountid = acc.id, Field = 'Home_Phone__pc'),
         	new AccountHistory(accountid = acc.id, Field = 'PersonEmail'),
         	new AccountHistory(accountid = acc.id, Field = 'Work_Phone__pc'),
         	new AccountHistory(accountid = acc.id, Field = 'Alternate_Email__pc')
         };
          insert coh;
        
  		Test.startTest();
        Account_Details__c accDetail = new Account_Details__c();
        accDetail.Name = 'Test123';
        //accDetail.RecType__c = 'ACCT';
        accDetail.Reference__c = 'BC02';
        accDetail.Comment_Block_01__c = 'TELEPHONE/EMAIL CHANGED WITHIN 60 DAYS';
        insert accDetail;
        
        Person_Account__c pa = new Person_Account__c();
        pa.PersonID__c = acc.Id;
        pa.Account_Number__c = accDetail.Id;        
        insert pa;
       Test.stopTest();
        
        Account acc2 = new Account();
    	acc2.RecordTypeID=rtId;
    	acc2.FirstName='Test FName';
        acc2.LastName='Test LName';
    	acc2.Mobile_Phone__pc = '9169954478';
    	acc2.PersonEmail='test@yahoo.com';
    	acc2.Home_Phone__pc = '1234567896';
    	acc2.Work_Phone__pc = '4785123698';
        //acc2.PersonHomePhone='1234567';
        acc2.PersonMobilePhone='12345678';
        acc2.Alternate_Email__pc = 'test@gmail.com';
        insert acc2;
         coh = new List<AccountHistory>{ new AccountHistory
         	(accountid = acc2.id, Field = 'Mobile_Phone__pc'),
         	new AccountHistory (accountid = acc2.id, Field = 'Home_Phone__pc'),
         	new AccountHistory(accountid = acc2.id, Field = 'PersonEmail'),
         	new AccountHistory(accountid = acc2.id, Field = 'Work_Phone__pc'),
         	new AccountHistory(accountid = acc2.id, Field = 'Alternate_Email__pc')
         };
          insert coh;
        Account_Details__c accDetail2 = new Account_Details__c();
        accDetail2.Name = 'Test123';
        accDetail2.RecType__c = 'ACCT';
        accDetail2.Reference__c = 'BC02';
  
        insert accDetail2;
        
       
        
        
        Person_Account__c pa2 = new Person_Account__c();
        pa2.PersonID__c = acc.Id;
        pa.Account_Number__c = accDetail2.Id;        
        insert pa2;
   
   	    smagicinteract__SMS_Template__c SM = new smagicinteract__SMS_Template__c();
   	    SM.smagicinteract__Name__c = 'SpectrumSMS';
   	    SM.smagicinteract__Text__c = 'Test';
   	    insert SM;
   	    
   	    OTPSettings__c otp = new OTPSettings__c();
   	    otp.Name = 'Member Verification';
   	    otp.OTPExpirationSeconds__c = 1;
   	    insert otp;
   	     
    	MemberVerification controller = new MemberVerification();
    	controller.accids = new List<string>();   	
    	controller.accids.add(accDetail.id);
    	controller.allRelatedAccounts = new List<string>();
    	controller.allRelatedAccounts.add(acc.id);
    	controller.acc = acc;
    	controller.IsIneligible();
    	string resend = 'true';
    	string fieldName  = 'Mobile_Phone__pc - ' + acc.Id;
    	ApexPages.currentPage().getParameters().put('fieldName',fieldName);
    	ApexPages.currentPage().getParameters().put('resend',resend);
    	controller.ResendOTP();
    	
    	
    	resend = 'true';
    	fieldName  = 'Alternate_Email__pc - ' + acc.Id;
    	ApexPages.currentPage().getParameters().put('fieldName',fieldName);
    	ApexPages.currentPage().getParameters().put('resend',resend);
    	controller.ResendOTP();
    	
        //string x = controller.buttonClass;
        controller.cancelOTP();
        string phone = '1236547896';
        string message = 'Test';
        string Name = 'TestUser';
        List<SelectOption> Xyz = controller.PhoneList_Options;
        List<SelectOption> Abc = controller.EmailsList_Options;
        controller.SendSMS(phone,message,Name);
        
        controller.IsEmail = true;
        controller.verifyOTP();
        controller.DeclineOTP();
        string otpstring = '896542';
        string email = 'test@123.com';
        
      
        
       /* acc2.PersonEmail='test1@yahoo.com';
    	acc2.Home_Phone__pc = '2234567896';
    	acc2.Work_Phone__pc = '5785123698';
    	acc2.Mobile_Phone__pc = '3169954478';
    	acc2.PersonMobilePhone='12345679';
        acc2.Alternate_Email__pc = 'tes1t@gmail.com';
        update acc2;
        acc.Mobile_Phone__pc = '3169954478';
    	acc.PersonEmail='test45@yahoo.com';
    	acc.Home_Phone__pc = '5234567896';
    	acc.Work_Phone__pc = '4685123698';
        //acc.PersonHomePhone='1234567';
        acc.PersonMobilePhone='12346678';
        acc.Alternate_Email__pc = 'teset@gmail.com';
        update acc;
        controller = new MemberVerification();
    	controller.accids = new List<string>();   	
    	controller.accids.add(accDetail.id);
    	controller.allRelatedAccounts = new List<string>();
    	controller.allRelatedAccounts.add(acc.id);
    	controller.acc = acc;
    	controller.IsIneligible();
    	resend = 'true';
    	fieldName  = 'PersonEmail';
    	ApexPages.currentPage().getParameters().put('fieldName',fieldName);
    	ApexPages.currentPage().getParameters().put('resend',resend);
    	controller.ResendOTP();
        //string x = controller.buttonClass;
        controller.cancelOTP();
        phone = '1236547896';
        message = 'Test';
        Name = 'TestUser';
        Xyz = controller.PhoneList_Options;
        Abc = controller.EmailsList_Options;
        controller.SendSMS(phone,message,Name);
        
        controller.IsEmail = true;
        controller.verifyOTP();
        controller.DeclineOTP();
        otpstring = '896542';
        email = 'test@123.com';
        Test.stopTest();*/
        //controller.SendOTPEmail(otpstring,email);
    }
    
    static testMethod void testMethod2(){
    	List<Account> alist = new List<Account>();
    	Id rtId = [SELECT Id FROM RecordType WHERE IsPersonType = TRUE AND SObjectType='Account' LIMIT 1].Id;
		Account acc = new Account();
    	acc.RecordTypeID=rtId;
    	acc.FirstName='Test FName';
        acc.LastName='Test LName';   
        alist.add(acc);
        //insert acc;
  
        Account_Details__c accDetail = new Account_Details__c();
        accDetail.Name = 'Test123';
        accDetail.RecType__c = 'ACCT';
        accDetail.Reference__c = 'BC02';
        //accDetail.Comment_Block_01__c = 'TELEPHONE/EMAIL CHANGED WITHIN 60 DAYS';
        insert accDetail;
        
        Person_Account__c pa = new Person_Account__c();
        pa.PersonID__c = acc.Id;
        pa.Account_Number__c = accDetail.Id;        
        insert pa;
        
        
        Account acc2 = new Account();
    	acc2.RecordTypeID=rtId;
    	acc2.FirstName='Test FName';
        acc2.LastName='Test LName';
         alist.add(acc2);
       // insert acc2;
        insert alist;
	
		
        
        Person_Account__c pa2 = new Person_Account__c();
        pa2.PersonID__c = acc2.Id;
        pa.Account_Number__c = accDetail.Id;        
        insert pa2;
   
   	    smagicinteract__SMS_Template__c SM = new smagicinteract__SMS_Template__c();
   	    SM.smagicinteract__Name__c = 'SpectrumSMS';
   	    SM.smagicinteract__Text__c = 'Test';
   	    insert SM;
   	    
   	    OTPSettings__c otp = new OTPSettings__c();
   	    otp.Name = 'Member Verification';
   	    otp.OTPExpirationSeconds__c = 1;
   	    insert otp;
   	     
    	MemberVerification controller = new MemberVerification();
    	controller.accids = new List<string>();   	
    	controller.accids.add(accDetail.id);
    	controller.allRelatedAccounts = new List<string>();
    	controller.allRelatedAccounts.add(acc.id);
    	controller.acc = acc;
    	controller.IsIneligible();
    	string resend = 'true';
    	string fieldName  = 'PersonEmail';
    	ApexPages.currentPage().getParameters().put('fieldName',fieldName);
    	ApexPages.currentPage().getParameters().put('resend',resend);
    	controller.ResendOTP();
        //string x = controller.buttonClass;
        controller.cancelOTP();
        string phone = '1236547896';
        string message = 'Test';
        string Name = 'TestUser';
        List<SelectOption> Xyz = controller.PhoneList_Options;
        List<SelectOption> Abc = controller.EmailsList_Options;
        controller.SendSMS(phone,message,Name);
        
        controller.IsEmail = true;
        controller.verifyOTP();
        controller.DeclineOTP();
        string otpstring = '896542';
        string email = 'test@123.com';
        //controller.SendOTPEmail(otpstring,email);
    }
}