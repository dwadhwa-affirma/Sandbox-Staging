@isTest
public class WiresBeneficiaryOTPTest {
     static testMethod void test1(){
     	Account_Details__c accDetail = new Account_Details__c();
		accDetail.Name = '0000000123';
		accDetail.RecType__c = 'ACCT';
		accDetail.TypeTranslate__c = '1-PERSONAL';
		insert accDetail;
     	
     	Wires_Beneficiary_OTP__c objWC = new Wires_Beneficiary_OTP__c();
	 	objWC.Email__c='test@test.com';
	 	objWC.Entered_OTP__c = '12345';
	 	objWC.Member_Number__c = accDetail.Name;
	 	objWC.OTP1__c ='12345';
	 	objWC.Mobile_Phone__c = '1234567890';
        
	 	insert objWC;
     }
}