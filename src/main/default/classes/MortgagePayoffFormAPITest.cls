@isTest
public class MortgagePayoffFormAPITest{
	@testSetup
	static void setupTestData(){

        Account acc = new Account();
		//acc.RecordTypeID=rtId;
		acc.FirstName = 'Test FName';
		acc.LastName = 'Test LName';
		acc.Mobile_Phone__pc = '555-469-3885';
		acc.Email_raw__c = 'test@test.com';
		acc.PersonID__c = 'V666147265';
		insert acc;

		Account_Details__c accDetail = new Account_Details__c();
		accDetail.Name = '0000000123';
		accDetail.RecType__c = 'MORT';
		accDetail.TypeTranslate__c = 'MORTGAGE';
		accDetail.Brand_Code__c = 'BC01';
		accDetail.Interest_Rate__c = 3.750;
		accDetail.Loan_Number__c = '0000023004';
		accDetail.Maturity_Date__c = date.newinstance(2045, 2, 17);
		accDetail.PRINCIPAL_BALANCE__c = 424400.15;
		accDetail.PROPERTY_ADDRESS__c = 'Property Address1';
		accDetail.Property_City__c = 'Property City';
		accDetail.Property_State__c = 'Property State';
		accDetail.Property_Zip__c = '12345';
		accDetail.PAYMENT__c = 2199.80;
		accDetail.Home_Value__c = 1056000.00;
		accDetail.OPEN_DATE__c = date.newinstance(1960, 2, 17);
		accDetail.Investor__c = 'Chevron Federal Credit Union';
		accDetail.Loan_Program_Type__c = 'CF30';
		accDetail.Mortgage_Name_1__c = 'Test Test1';
		accDetail.Mortgage_Name_2__c = 'Test2 Test2';
		accDetail.Income__c = 4500;
		accDetail.Due_Date__c = date.newinstance(2021, 2, 17);
		accDetail.Impermissible__c = false;
		accDetail.Vesting__c = 'Test';
		accDetail.Trust__c = false;
		accDetail.PMI_Company_Name__c = '';
		accDetail.Xpress_Refi_Eligibility__c = true;
		insert accDetail;

        List<Person_Account__c> person_obj = new List<Person_Account__c>{new Person_Account__c(TypeTranslate__c = '0000/Primary', Account_Number__c = accDetail.id, PersonID__c = acc.Id)};
		Insert person_obj;
	}

	static testMethod void ValidateAccountTest(){
		RestRequest req = new RestRequest();
		req.requestURI = '/services/apexrest/MortgagePayoffFormAPI';
		req.addParameter('PropertyZip', '12345');
		req.addParameter('LoanNo', '0000023004');		
		req.httpMethod = 'GET';
		RestContext.request = req;
		MortgagePayoffFormAPI.ValidateAccount();
	}

	static testMethod void CreateCase(){
		RestRequest req = new RestRequest();
		RestResponse res = new RestResponse();
		req.requestURI = '/services/apexrest/MortgagePayoffFormAPI/';
		req.httpMethod = 'POST';
        String JsonMsg='{"PropertyZip":"12345","LoanNo":"0000023004","PayoffRequestReason":"Other","PayoffRequestReasonOther":"Reason Other","PayoffGoodToDate":"2021-05-19","RequestorInfo":"Member","RequestorCompany":"Requestor Company","RequestorName":"Requestor Name","RequestorPhoneNo":"123567890","AuthorizedTitleCompany":true,"MethodofDelivery":"Email"}';
        req.requestBody = Blob.valueof(JsonMsg);              
		RestContext.request = req;
		RestContext.response = res;
        MortgagePayoffFormAPI.CreateCase();
	}
}