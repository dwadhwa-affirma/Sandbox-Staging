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
        
        /*Account_Details__c accDetail2 = new Account_Details__c();
        accDetail2.Name = 'Test';
        accDetail2.RecType__c = 'ACCT';
        accDetail2.Reference__c = 'BC02';
  
        insert accDetail2;*/
        
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
    
    static testMethod void testMethod2(){
    	
    	Id rtId = [SELECT Id FROM RecordType WHERE IsPersonType = TRUE AND SObjectType='Account' LIMIT 1].Id;
		Account acc = new Account();
    	acc.RecordTypeID=rtId;
    	acc.FirstName='Test FName';
        acc.LastName='Test LName';    	
        insert acc;
  
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
        insert acc2;
        
        /*Account_Details__c accDetail2 = new Account_Details__c();
        accDetail2.Name = 'Test';
        accDetail2.RecType__c = 'ACCT';
        accDetail2.Reference__c = 'BC02';
  
        insert accDetail2;*/
        
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