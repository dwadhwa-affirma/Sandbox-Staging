@isTest

private class MemberVerificationLightningControlleTest
{
//Initial Test Data
//Add Logic to Create data required
@testSetup
static void SetUp(){
test.StartTest();
List<Account_Details__c> account_details_Obj = new List<Account_Details__c>{
						    new Account_Details__c(Name = '0000147163', Balance__c = 0.00, Combined_Account_ID__c = '0000147163S0100P0100', ID1__c ='0100', Onboarded__c = true, RecType__c = 'ACCT', TypeTranslate__c = '1-PRIMARY SHARE',
Comment_Block_01__c='ABC',
Comment_Block_02__c='ABC',
Comment_Block_03__c='ABC',
Comment_Block_04__c='TELEPHONE/EMAIL CHANGED WITHIN 60 DAYS',
Comment_Block_05__c='ABC',
Comment_Block_06__c='ABC',
Comment_Block_07__c='ABC',
Comment_Block_08__c='ABC',
Comment_Block_09__c='ABC',
Comment_Block_10__c='ABC',
Comment_Block_11__c='ABC',
Comment_Block_12__c='ABC',
Comment_Block_13__c='ABC',
Comment_Block_14__c='ABC',
Comment_Block_15__c='ABC',
Comment_Block_16__c='TELEPHONE/EMAIL CHANGED WITHIN 60 DAYS',
Comment_Block_17__c='ABC',
Comment_Block_18__c='ABC',
Comment_Block_19__c='ABC',
Comment_Block_20__c='ABC'),
						    new Account_Details__c(Name = '0000147163', Balance__c = 0.00, Combined_Account_ID__c = '0000147163S0100P0100', ID1__c = '0100', Onboarded__c = true, RecType__c = 'SHAR', TypeTranslate__c = '1-PRIMARY SHARE',
Comment_Block_01__c='TELEPHONE/EMAIL CHANGED WITHIN 60 DAYS',
Comment_Block_02__c='ABC',
Comment_Block_03__c='ABC',
Comment_Block_04__c='ABC',
Comment_Block_05__c='ABC',
Comment_Block_06__c='ABC',
Comment_Block_07__c='ABC',
Comment_Block_08__c='ABC',
Comment_Block_09__c='TELEPHONE/EMAIL CHANGED WITHIN 60 DAYS',
Comment_Block_10__c='ABC',
Comment_Block_11__c='ABC',
Comment_Block_12__c='ABC',
Comment_Block_13__c='ABC',
Comment_Block_14__c='ABC',
Comment_Block_15__c='ABC',
Comment_Block_16__c='ABC',
Comment_Block_17__c='ABC',
Comment_Block_18__c='ABC',
Comment_Block_19__c='ABC',
Comment_Block_20__c='TELEPHONE/EMAIL CHANGED WITHIN 60 DAYS'),
						    new Account_Details__c(Name = '0000147163', Balance__c = 0.00, Combined_Account_ID__c = '0000147163S0100P0100', ID1__c = '0100', Onboarded__c = true, RecType__c = 'SHAR', TypeTranslate__c = '1-PRIMARY SHARE',
Comment_Block_01__c='ABC',
Comment_Block_02__c='ABC',
Comment_Block_03__c='ABC',
Comment_Block_04__c='ABC',
Comment_Block_05__c='ABC',
Comment_Block_06__c='ABC',
Comment_Block_07__c='ABC',
Comment_Block_08__c='ABC',
Comment_Block_09__c='ABC',
Comment_Block_10__c='TELEPHONE/EMAIL CHANGED WITHIN 60 DAYS',
Comment_Block_11__c='ABC',
Comment_Block_12__c='ABC',
Comment_Block_13__c='ABC',
Comment_Block_14__c='ABC',
Comment_Block_15__c='ABC',
Comment_Block_16__c='ABC',
Comment_Block_17__c='ABC',
Comment_Block_18__c='ABC',
Comment_Block_19__c='TELEPHONE/EMAIL CHANGED WITHIN 60 DAYS',
Comment_Block_20__c='ABC')
						};
						

		    Insert account_details_Obj;
		    
		      List<Account> account_Obj = new List<Account>{new Account(LastName = 'BANDATest', FirstName = 'MARIATest', Type = 'null', Member_Verification_OTP_Invalid_Attempt__c = system.now(), Home_Phone__pc = '123456333390', Mobile_Phone__pc = '258963147852', Work_Phone__pc = '233333232323', PersonEmail = 'test@test.com', Alternate_Email__pc = 'abc@abc.com'),
		      												new Account(LastName = 'BANDATest1', FirstName = 'MARIATest1', Type = 'null', Member_Verification_OTP_Invalid_Attempt__c = system.now(), Home_Phone__pc = '1234563333903', Mobile_Phone__pc = '2589631478524', Work_Phone__pc = '2333332323235', PersonEmail = 'test@test.com1', Alternate_Email__pc = 'abc@abc.com1')};
    Insert account_Obj; 
       
    	List<Person_Account__c> person_obj= new List<Person_Account__c>{new Person_Account__c(Account_Number__c = account_details_Obj[0].Id, PersonID__c = account_Obj[0].Id), new Person_Account__c(Account_Number__c = account_details_Obj[1].Id, PersonID__c = account_Obj[0].Id), new Person_Account__c(Account_Number__c = account_details_Obj[2].Id, PersonID__c = account_Obj[0].Id),
    																	new Person_Account__c(Account_Number__c = account_details_Obj[1].Id, PersonID__c = account_Obj[1].Id), new Person_Account__c(Account_Number__c = account_details_Obj[2].Id, PersonID__c = account_Obj[1].Id)};
		     Insert person_obj;
		     
		     
		     OTPSettings__c settings = new OTPSettings__c(Name = 'Member Verification', OTPExpirationSeconds__c = 180);
		     Insert settings;
		     test.StopTest();
		 
}

// Test Method: ListOfEmailsAndPhoneNumbers
public static testmethod void Test_ListOfEmailsAndPhoneNumbers()
{
	List<Account> lstAccount = [select Id from Account limit 1];
	MemberVerificationLightningController.ListOfEmailsAndPhoneNumbers(lstAccount[0].Id);	
}
    
public static testmethod void Test_ListOfEmailsAndPhoneNumbers2()
{
	List<Account> lstAccount = [select Id from Account limit 2];	
	MemberVerificationLightningController.ListOfEmailsAndPhoneNumbers(lstAccount[1].Id);
}


// Test Method: DeclineOTPAtFirstStep
public static testmethod void Test_DeclineOTPAtFirstStep()
{
	Account obj_Account = [select Id from Account limit 1];	
	MemberVerificationLightningController.DeclineOTPAtFirstStep(obj_Account.Id);
}

// Test Method: GenerateRandomOTP
public static testmethod void Test_GenerateRandomOTP()
{
	Account obj_Account = [select Id from Account limit 1];
	
	string fieldname = 'Home_Phone__pc - ' + obj_Account.Id;
	string brandname = 'Spectrum';
	string resend = '';
	string accid = obj_Account.Id;
	MemberVerificationLightningController.GenerateRandomOTP(fieldname, brandname, resend, accid);
	
	fieldname = 'Mobile_Phone__pc - ' + obj_Account.Id;
	brandname = 'Chevron';
	MemberVerificationLightningController.GenerateRandomOTP(fieldname, brandname, resend, accid);
	
	fieldname = 'Work_Phone__pc - ' + obj_Account.Id;
	brandname = 'Spectrum';
	MemberVerificationLightningController.GenerateRandomOTP(fieldname, brandname, resend, accid);
	
	fieldname = 'PersonEmail - ' + obj_Account.Id;
	brandname = 'Chevron';
	MemberVerificationLightningController.GenerateRandomOTP(fieldname, brandname, resend, accid);
	
	fieldname = 'Alternate_Email__pc - ' + obj_Account.Id;
	brandname = 'Chevron';
	MemberVerificationLightningController.GenerateRandomOTP(fieldname, brandname, resend, accid);
}
// Test Method: verifyOTP
public static testmethod void Test_verifyOTP()
{	
	Account obj_Account = [select Id from Account limit 1];
	string accid = obj_Account.Id;
	string enteredotp = '23456';
	string fieldname = 'Home_Phone__pc - ' + obj_Account.Id;
	KeyValuePairModel model1 = new KeyValuePairModel();
	model1.Text = EncryptString('23456');
	model1.Value=  EncryptString(string.valueof(system.now()));
	string model = JSON.serialize(model1);
	
	MemberVerificationLightningController.verifyOTP(accid, enteredotp, fieldname, model);
	
	fieldname = 'Mobile_Phone__pc - ' + obj_Account.Id;
	MemberVerificationLightningController.verifyOTP(accid, enteredotp, fieldname, model);
	
	fieldname = 'Work_Phone__pc - ' + obj_Account.Id;
	MemberVerificationLightningController.verifyOTP(accid, enteredotp, fieldname, model);
	
	fieldname = 'PersonEmail - ' + obj_Account.Id;
	MemberVerificationLightningController.verifyOTP(accid, enteredotp, fieldname, model);
	
	fieldname = 'Alternate_Email__pc - ' + obj_Account.Id;
	MemberVerificationLightningController.verifyOTP(accid, enteredotp, fieldname, model);
	
}
// Test Method: CancelOTP
public static testmethod void Test_CancelOTP()
{	
	Account obj_Account = [select Id from Account limit 1];
	string accid = obj_Account.Id;
	string fieldname = 'Home_Phone__pc - ' + obj_Account.Id;
	
	MemberVerificationLightningController.CancelOTP(accid, fieldname);	
	
	fieldname = 'Home_Phone__pc - ' + obj_Account.Id;
	MemberVerificationLightningController.CancelOTP(accid, fieldname);	
	
	fieldname = 'Mobile_Phone__pc - ' + obj_Account.Id;	
	MemberVerificationLightningController.CancelOTP(accid, fieldname);	
	
	fieldname = 'Work_Phone__pc - ' + obj_Account.Id;	
	MemberVerificationLightningController.CancelOTP(accid, fieldname);
	
	fieldname = 'PersonEmail - ' + obj_Account.Id;	
	MemberVerificationLightningController.CancelOTP(accid, fieldname);
	
	fieldname = 'Alternate_Email__pc - ' + obj_Account.Id;	
	MemberVerificationLightningController.CancelOTP(accid, fieldname);	
}

private static string EncryptString(string plaindata)
	{
		 Blob cryptoKey = Blob.valueOf('39955410e8b11fa9');
		 
		 Blob data = Blob.valueOf(plaindata);
         Blob encryptedData = Crypto.encryptWithManagedIV('AES128', cryptoKey , data );
         String b64Data = EncodingUtil.base64Encode(encryptedData);

		return b64Data;
	}
}