@isTest
public class ManageTravelPlansControllerTest {
	
	@testSetup
		  static void setupTestData(){
			  	test.startTest();
			  	
			  	Account acc = new Account();
		    	//acc.RecordTypeID=rtId;
		    	acc.FirstName='Test FName';
		        acc.LastName='Test LName';    
		        acc.Mobile_Phone__pc='555-469-3885'; 
		        acc.Email_raw__c='test@test.com'; 	
		        insert acc;
        
			  	Account_Details__c accDetail = new Account_Details__c();
		        accDetail.Name = '0000147163';
		        accDetail.RecType__c = 'ACCT';
		        accDetail.TypeTranslate__c = '1-PERSONAL';
		        insert accDetail;
		        
		        Account_Details__c accDetail1 = new Account_Details__c();
		        accDetail1.Name = '0000147163';
		        accDetail1.RecType__c = 'CARD';
		        accDetail1.TypeTranslate__c = '15-CHEVRON DEBIT CARD';
		        accDetail1.Status__c = 1;
		        accDetail1.Card_Number__c= '5165967021121165';
		        accDetail1.Card_Name__c = 'MINDY O RIGA';
		        accDetail1.TypeTranslate__c = '15-CHEVRON DEBIT CARD';
		        insert accDetail1;
		        
		        List<Account_Details__c> obj = [select id from Account_Details__c where id =: accDetail.id limit 1];
    
    			List<Person_Account__c> person_obj= new List<Person_Account__c>{
	    		new Person_Account__c(TypeTranslate__c='0000/Primary',Account_Number__c = accDetail.id, PersonID__c = acc.Id), 
	    		new Person_Account__c(TypeTranslate__c='0000/Primary',Account_Number__c = accDetail.Id, PersonID__c = acc.Id)};
		     	Insert person_obj;
		        
				List<Case> case_Obj = new List<Case>{
			    new Case(Status = 'In Process',Description = 'Orginal Desc', Origin = null, Subject = 'Test', ClosedDate = null, IsEscalated = false, AccountId = acc.Id, Account_Number__c = accDetail.Id, Additional_Documents__c = false, Staff_Escalated__c = false, Five_Day_Flag__c = false, IsMarkDeleted__c = false, IsMarkRead__c = false, IsMarkSaved__c = false, Primary_Category__c = 'Card services', Secondary_Category__c = 'ATM/Debit', Tertiary_Category__c = 'Travel notification', MaritzCX__Response_Deleted_From_MaritzCX__c = false, SLATemp__c = false),
			    new Case(Status = 'In Process',Description = 'Orginal Desc', Origin = null, Subject = 'Test', ClosedDate = null, IsEscalated = false, AccountId = acc.Id, Account_Number__c = accDetail.Id, Additional_Documents__c = false, Staff_Escalated__c = false, Five_Day_Flag__c = false, IsMarkDeleted__c = false, IsMarkRead__c = false, IsMarkSaved__c = false, Primary_Category__c = 'Card services', Secondary_Category__c = 'ATM/Debit', Tertiary_Category__c = 'Travel notification', MaritzCX__Response_Deleted_From_MaritzCX__c = false, SLATemp__c = false),
			    new Case(Status = 'In Process',Description = 'Orginal Desc', Origin = null, Subject = 'Test', ClosedDate = null, IsEscalated = false, AccountId = acc.Id, Account_Number__c = accDetail.Id, Additional_Documents__c = false, Staff_Escalated__c = false, Five_Day_Flag__c = false, IsMarkDeleted__c = false, IsMarkRead__c = false, IsMarkSaved__c = false, Primary_Category__c = 'Card services', Secondary_Category__c = 'ATM/Debit', Tertiary_Category__c = 'Travel notification', MaritzCX__Response_Deleted_From_MaritzCX__c = false, SLATemp__c = false),
			    new Case(Status = 'In Process', Description = 'Orginal Desc', Origin = null, Subject = 'Test', ClosedDate = null, IsEscalated = false,AccountId = acc.Id,  Account_Number__c = accDetail.Id, Additional_Documents__c = false, Staff_Escalated__c = false, Five_Day_Flag__c = false, IsMarkDeleted__c = false, IsMarkRead__c = false, IsMarkSaved__c = false, Primary_Category__c = 'Account Maintenance', Secondary_Category__c = 'Account Services', Tertiary_Category__c = 'Extended Check Hold', MaritzCX__Response_Deleted_From_MaritzCX__c = false, SLATemp__c = false)
		    	}; 
		    	
				Insert case_Obj;
				
				Mastercard_Travel__c mcObj = new Mastercard_Travel__c();
			  	mcobj.CardId__c = accDetail1.id;
			  	mcobj.Case__c= case_Obj[0].Id;
			  	mcobj.Country__c= 'India';
			  	mcobj.Departure_Date__c= Date.newInstance(2018, 09, 09);
			  	mcobj.Destination__c= 'International';
			  	mcobj.Email__c='test@test.com';
			  	mcobj.IsEmailPreferred__c= true;
			  	mcobj.IsPhonePreferred__c=false;
			  	mcobj.Return_Date__c=Date.newInstance(2018, 09, 10);
			  	mcobj.State__c='';
			  	mcobj.Timezone__c='America/Los_Angeles';
			  	mcobj.US_Mobile_Number__c='123456789';
			  	insert mcObj;
			  	test.stopTest();
		  }
		  
		   static testMethod void getDetailsTest() {
			   	Account_Details__c objAccountDetails = [select id from Account_Details__c limit 1];
			   	Account objAccount = [select id from Account limit 1];
			   	List<Case> objCase = [select id from Case limit 4];
			   		
			   		
			   	ManageTravelPlansController.getCardDetails(objAccountDetails.Id);
			   	ManageTravelPlansController.getCardDetails(objAccount.Id);
			   	ManageTravelPlansController.getCardDetails(objCase[0].Id);
			   	ManageTravelPlansController.getCardDetails(objCase[3].Id);
			   	ManageTravelPlansController.getCountryData();
			   	ManageTravelPlansController.getTimeZone();
			   	ManageTravelPlansController.getStateData();
			   	
			  // 	ManageTravelPlansController.getCurrentTravelPlans(objAccountDetails.Id);
			   //	ManageTravelPlansController.getCurrentTravelPlans(objAccount.Id);
			   //	ManageTravelPlansController.getCurrentTravelPlans(objCase[0].Id);
		   }
		   
		
			public class MockHttpGetResponseGenerator implements HttpCalloutMock {
			    // Implement this interface method
			    public HTTPResponse respond(HTTPRequest req) {			       
			        // Create a fake response
			        HttpResponse res = new HttpResponse();
			        res.setHeader('Content-Type', 'application/json');
			        res.setBody('{"Header":"","Body":{"GetSegmentAssignmentOutput":{"GetSegmentAssignmentResponse":{"CardNumber":"5509840000040026","SegmentAssignmentResponseList":{"SegmentAssignmentResponse":[{"SegmentationName":"Asia","SegmentationValue":"R01","SegmentationDescription":"Asia Segment","FromDate":"2018-11-05T12:00:00.000","ToDate":"2018-11-06T12:00:00.000","TimeZone":"America/Los_Angeles","Active":"false","CreatedDate":"2018-08-21T03:32:00.000","CreatedBy":"1DA27"},{"SegmentationName":"Asia","SegmentationValue":"R01","SegmentationDescription":"Asia Segment","FromDate":"2018-11-03T12:00:00.000","ToDate":"2018-11-04T12:00:00.000","TimeZone":"America/Los_Angeles","Active":"false","CreatedDate":"2018-08-21T03:32:00.000","CreatedBy":"1DA27"},{"SegmentationName":"US-SW","SegmentationValue":"LT1","SegmentationDescription":"Leisure travel in CA AZ NV WA","FromDate":"2018-11-12T12:00:00.000","ToDate":"2018-11-13T12:00:00.000","TimeZone":"America/Los_Angeles","Active":"false","CreatedDate":"2018-08-20T10:16:00.000","CreatedBy":"1DA27"},{"SegmentationName":"TEST","SegmentationValue":"123","SegmentationDescription":"Testing the seg time zones","FromDate":"2018-10-01T00:00:00.000","ToDate":"2018-10-04T00:00:00.000","TimeZone":"Asia/Calcutta","Active":"false","CreatedDate":"2018-08-17T10:50:00.000","CreatedBy":"1DA27"}]},"ExecutionStart":"2018-08-22T06:21:21.749Z","ExecutionUuid":"e017449f-777f-40ca-89c3-0e5e3972a4b9"},"ExecutionStart":"2018-08-22T06:21:21.749Z","ExecutionUuid":"26eced89-b856-4802-9927-5638cd356040","OpExecUuid":"b76009a0-366a-4c32-939e-d1c4c52377a0","StatusCode":"SUCCESS","SubOpExecUuid":"26eced89-b856-4802-9927-5638cd356040","Ns10":"http://ws.ips.mastercardworldwide.com/type/account/v1","Ns11":"http://ws.ips.mastercardworldwide.com/type/card/v1","Ns12":"http://ws.ips.mastercardworldwide.com/type/geo/v1","Ns13":"http://ws.ips.mastercardworldwide.com/type/common/v1","Ns14":"http://ws.ips.mastercardworldwide.com/message/card/v1","Ns15":"http://ws.ips.mastercardworldwide.com/type/person/v1","Ns16":"http://ws.ips.mastercardworldwide.com/type/cardholder/v1","Ns17":"http://ws.ips.mastercardworldwide.com/message/cardholder/v1","Ns18":"http://ws.ips.mastercardworldwide.com/message/inventoryManagement/v1","Ns19":"http://ws.ips.mastercardworldwide.com/type/inventoryManagement/v1","Ns20":"http://ws.ips.mastercardworldwide.com/message/monitor/v1","Ns21":"http://ws.ips.mastercardworldwide.com/message/monitorGateway/v1","Ns22":"http://ws.ips.mastercardworldwide.com/message/sms/v1","Ns23":"http://ws.ips.mastercardworldwide.com/type/sms/v1","Ns24":"http://ws.ips.mastercardworldwide.com/message/atm/v1","Ns25":"http://ws.ips.mastercardworldwide.com/type/atm/v1","Ns26":"http://ws.ips.mastercardworldwide.com/message/exceptionProcessing/v1","Ns27":"http://ws.ips.mastercardworldwide.com/type/securityassertion/v1","Ns28":"http://ws.ips.mastercardworldwide.com/type/exception/v1","Ns29":"http://ws.ips.mastercardworldwide.com/message/billPayIntegration/v1","Ns30":"http://ws.ips.mastercardworldwide.com/type/billPayIntegration/v1","Ns31":"http://ws.ips.mastercardworldwide.com/message/inboundHealthCheck/v1","Ns32":"http://ws.ips.mastercardworldwide.com/message/segmentation/v1","Ns33":"http://ws.ips.mastercardworldwide.com/message/inControl/v1","Ns34":"http://ws.ips.mastercardworldwide.com/message/spendControl/v1","Ns35":"http://ws.ips.mastercardworldwide.com/message/echo/v1","Ns5":"http://ws.ips.mastercardworldwide.com/message/account/v1","Ns6":"http://ws.ips.mastercardworldwide.com/type/transaction/v1","Ns7":"http://ws.ips.mastercardworldwide.com/type/currency/v1","Ns8":"http://ws.ips.mastercardworldwide.com/type/messagebase/v1","Ns9":"http://ws.ips.mastercardworldwide.com/message/transaction/v1"}},"Soapenv":"http://schemas.xmlsoap.org/soap/envelope/","Soapenc":"http://schemas.xmlsoap.org/soap/encoding/","Xsd":"http://www.w3.org/2001/XMLSchema","Xsi":"http://www.w3.org/2001/XMLSchema-instance"}');
			        res.setStatusCode(200);
			        return res;
			    }
			}	
			
			public class MockHttpAddResponseGenerator implements HttpCalloutMock {
			    // Implement this interface method
			    public HTTPResponse respond(HTTPRequest req) {			       
			        // Create a fake response
			        HttpResponse res = new HttpResponse();
			        res.setHeader('Content-Type', 'application/json');
			        res.setBody('{"Header":"","Body":{"AddSegmentAssignmentOutput":{"AddSegmentAssignmentResponse":{"SegmentationDetails":{"SegmentationName":"Australi","SegmentationValue":"R08","FromDate":"2018-09-03T12:00:00.000","ToDate":"2018-09-04T12:00:00.000","TimeZone":"America/Los_Angeles","Active":"false"},"ExecutionStart":"2018-08-22T08:22:09.841Z","ExecutionUuid":"94da5232-ffda-41a7-9da0-723bb530151d"},"ExecutionStart":"2018-08-22T08:22:09.841Z","ExecutionUuid":"ce0aa245-7e56-4562-ac69-5909a489d467","OpExecUuid":"080d1a07-3213-4ac0-bd9c-0e5aa386ec7c","StatusCode":"SUCCESS","SubOpExecUuid":"ce0aa245-7e56-4562-ac69-5909a489d467","Ns10":"http://ws.ips.mastercardworldwide.com/type/account/v1","Ns11":"http://ws.ips.mastercardworldwide.com/type/card/v1","Ns12":"http://ws.ips.mastercardworldwide.com/type/geo/v1","Ns13":"http://ws.ips.mastercardworldwide.com/type/common/v1","Ns14":"http://ws.ips.mastercardworldwide.com/message/card/v1","Ns15":"http://ws.ips.mastercardworldwide.com/type/person/v1","Ns16":"http://ws.ips.mastercardworldwide.com/type/cardholder/v1","Ns17":"http://ws.ips.mastercardworldwide.com/message/cardholder/v1","Ns18":"http://ws.ips.mastercardworldwide.com/message/inventoryManagement/v1","Ns19":"http://ws.ips.mastercardworldwide.com/type/inventoryManagement/v1","Ns20":"http://ws.ips.mastercardworldwide.com/message/monitor/v1","Ns21":"http://ws.ips.mastercardworldwide.com/message/monitorGateway/v1","Ns22":"http://ws.ips.mastercardworldwide.com/message/sms/v1","Ns23":"http://ws.ips.mastercardworldwide.com/type/sms/v1","Ns24":"http://ws.ips.mastercardworldwide.com/message/atm/v1","Ns25":"http://ws.ips.mastercardworldwide.com/type/atm/v1","Ns26":"http://ws.ips.mastercardworldwide.com/message/exceptionProcessing/v1","Ns27":"http://ws.ips.mastercardworldwide.com/type/securityassertion/v1","Ns28":"http://ws.ips.mastercardworldwide.com/type/exception/v1","Ns29":"http://ws.ips.mastercardworldwide.com/message/billPayIntegration/v1","Ns30":"http://ws.ips.mastercardworldwide.com/type/billPayIntegration/v1","Ns31":"http://ws.ips.mastercardworldwide.com/message/inboundHealthCheck/v1","Ns32":"http://ws.ips.mastercardworldwide.com/message/segmentation/v1","Ns33":"http://ws.ips.mastercardworldwide.com/message/inControl/v1","Ns34":"http://ws.ips.mastercardworldwide.com/message/spendControl/v1","Ns35":"http://ws.ips.mastercardworldwide.com/message/echo/v1","Ns5":"http://ws.ips.mastercardworldwide.com/message/account/v1","Ns6":"http://ws.ips.mastercardworldwide.com/type/transaction/v1","Ns7":"http://ws.ips.mastercardworldwide.com/type/currency/v1","Ns8":"http://ws.ips.mastercardworldwide.com/type/messagebase/v1","Ns9":"http://ws.ips.mastercardworldwide.com/message/transaction/v1"}},"Soapenv":"http://schemas.xmlsoap.org/soap/envelope/","Soapenc":"http://schemas.xmlsoap.org/soap/encoding/","Xsd":"http://www.w3.org/2001/XMLSchema","Xsi":"http://www.w3.org/2001/XMLSchema-instance"}');
			        res.setStatusCode(200);
			        return res;
			    }
			}
			
			public class MockHttpUpdateResponseGenerator implements HttpCalloutMock {
			    // Implement this interface method
			    public HTTPResponse respond(HTTPRequest req) {			       
			        // Create a fake response
			        HttpResponse res = new HttpResponse();
			        res.setHeader('Content-Type', 'application/json');
			        res.setBody('{"Header":"","Body":{"UpdateSegmentAssignmentOutput":{"UpdateSegmentAssignmentResponse":{"SegmentationDetails":{"SegmentationName":"Europe","SegmentationValue":"R03","FromDate":"2018-08-29T12:00:00.000","ToDate":"2018-08-31T12:00:00.000","TimeZone":"America/Los_Angeles","Active":"false","CreatedDate":"2018-08-22T02:51:00.000","CreatedBy":"1DA27"},"ExecutionStart":"2018-08-22T09:51:29.172Z","ExecutionUuid":"46842fc6-3659-4f49-ada8-7c3e8aa52399"},"ExecutionStart":"2018-08-22T09:51:29.172Z","ExecutionUuid":"930ef412-a457-4a4d-a50f-f2fd60e07543","OpExecUuid":"1f30472b-232c-4121-a8ef-385107f1cdf1","StatusCode":"SUCCESS","SubOpExecUuid":"930ef412-a457-4a4d-a50f-f2fd60e07543","Ns10":"http://ws.ips.mastercardworldwide.com/type/account/v1","Ns11":"http://ws.ips.mastercardworldwide.com/type/card/v1","Ns12":"http://ws.ips.mastercardworldwide.com/type/geo/v1","Ns13":"http://ws.ips.mastercardworldwide.com/type/common/v1","Ns14":"http://ws.ips.mastercardworldwide.com/message/card/v1","Ns15":"http://ws.ips.mastercardworldwide.com/type/person/v1","Ns16":"http://ws.ips.mastercardworldwide.com/type/cardholder/v1","Ns17":"http://ws.ips.mastercardworldwide.com/message/cardholder/v1","Ns18":"http://ws.ips.mastercardworldwide.com/message/inventoryManagement/v1","Ns19":"http://ws.ips.mastercardworldwide.com/type/inventoryManagement/v1","Ns20":"http://ws.ips.mastercardworldwide.com/message/monitor/v1","Ns21":"http://ws.ips.mastercardworldwide.com/message/monitorGateway/v1","Ns22":"http://ws.ips.mastercardworldwide.com/message/sms/v1","Ns23":"http://ws.ips.mastercardworldwide.com/type/sms/v1","Ns24":"http://ws.ips.mastercardworldwide.com/message/atm/v1","Ns25":"http://ws.ips.mastercardworldwide.com/type/atm/v1","Ns26":"http://ws.ips.mastercardworldwide.com/message/exceptionProcessing/v1","Ns27":"http://ws.ips.mastercardworldwide.com/type/securityassertion/v1","Ns28":"http://ws.ips.mastercardworldwide.com/type/exception/v1","Ns29":"http://ws.ips.mastercardworldwide.com/message/billPayIntegration/v1","Ns30":"http://ws.ips.mastercardworldwide.com/type/billPayIntegration/v1","Ns31":"http://ws.ips.mastercardworldwide.com/message/inboundHealthCheck/v1","Ns32":"http://ws.ips.mastercardworldwide.com/message/segmentation/v1","Ns33":"http://ws.ips.mastercardworldwide.com/message/inControl/v1","Ns34":"http://ws.ips.mastercardworldwide.com/message/spendControl/v1","Ns35":"http://ws.ips.mastercardworldwide.com/message/echo/v1","Ns5":"http://ws.ips.mastercardworldwide.com/message/account/v1","Ns6":"http://ws.ips.mastercardworldwide.com/type/transaction/v1","Ns7":"http://ws.ips.mastercardworldwide.com/type/currency/v1","Ns8":"http://ws.ips.mastercardworldwide.com/type/messagebase/v1","Ns9":"http://ws.ips.mastercardworldwide.com/message/transaction/v1"}},"Soapenv":"http://schemas.xmlsoap.org/soap/envelope/","Soapenc":"http://schemas.xmlsoap.org/soap/encoding/","Xsd":"http://www.w3.org/2001/XMLSchema","Xsi":"http://www.w3.org/2001/XMLSchema-instance"}');
			        res.setStatusCode(200);
			        return res;
			    }
			}
			
			public class MockHttpDeleteResponseGenerator implements HttpCalloutMock {
			    // Implement this interface method
			    public HTTPResponse respond(HTTPRequest req) {			       
			        // Create a fake response
			        HttpResponse res = new HttpResponse();
			        res.setHeader('Content-Type', 'application/json');
			        res.setBody('{"Header":"","Body":{"DeleteSegmentAssignmentOutput":{"DeleteSegmentAssignmentResponse":{"ExecutionStart":"2018-08-22T09:40:38.862Z","ExecutionUuid":"019cfb37-7a91-4722-b488-0247e87caa7a"},"ExecutionStart":"2018-08-22T09:40:38.862Z","ExecutionUuid":"240809e5-cab9-4c65-accb-10fbf6037c9f","OpExecUuid":"4e0ec7b3-d275-46f3-acc3-6d2a8ab952c3","StatusCode":"SUCCESS","SubOpExecUuid":"240809e5-cab9-4c65-accb-10fbf6037c9f","Ns10":"http://ws.ips.mastercardworldwide.com/type/account/v1","Ns11":"http://ws.ips.mastercardworldwide.com/type/card/v1","Ns12":"http://ws.ips.mastercardworldwide.com/type/geo/v1","Ns13":"http://ws.ips.mastercardworldwide.com/type/common/v1","Ns14":"http://ws.ips.mastercardworldwide.com/message/card/v1","Ns15":"http://ws.ips.mastercardworldwide.com/type/person/v1","Ns16":"http://ws.ips.mastercardworldwide.com/type/cardholder/v1","Ns17":"http://ws.ips.mastercardworldwide.com/message/cardholder/v1","Ns18":"http://ws.ips.mastercardworldwide.com/message/inventoryManagement/v1","Ns19":"http://ws.ips.mastercardworldwide.com/type/inventoryManagement/v1","Ns20":"http://ws.ips.mastercardworldwide.com/message/monitor/v1","Ns21":"http://ws.ips.mastercardworldwide.com/message/monitorGateway/v1","Ns22":"http://ws.ips.mastercardworldwide.com/message/sms/v1","Ns23":"http://ws.ips.mastercardworldwide.com/type/sms/v1","Ns24":"http://ws.ips.mastercardworldwide.com/message/atm/v1","Ns25":"http://ws.ips.mastercardworldwide.com/type/atm/v1","Ns26":"http://ws.ips.mastercardworldwide.com/message/exceptionProcessing/v1","Ns27":"http://ws.ips.mastercardworldwide.com/type/securityassertion/v1","Ns28":"http://ws.ips.mastercardworldwide.com/type/exception/v1","Ns29":"http://ws.ips.mastercardworldwide.com/message/billPayIntegration/v1","Ns30":"http://ws.ips.mastercardworldwide.com/type/billPayIntegration/v1","Ns31":"http://ws.ips.mastercardworldwide.com/message/inboundHealthCheck/v1","Ns32":"http://ws.ips.mastercardworldwide.com/message/segmentation/v1","Ns33":"http://ws.ips.mastercardworldwide.com/message/inControl/v1","Ns34":"http://ws.ips.mastercardworldwide.com/message/spendControl/v1","Ns35":"http://ws.ips.mastercardworldwide.com/message/echo/v1","Ns5":"http://ws.ips.mastercardworldwide.com/message/account/v1","Ns6":"http://ws.ips.mastercardworldwide.com/type/transaction/v1","Ns7":"http://ws.ips.mastercardworldwide.com/type/currency/v1","Ns8":"http://ws.ips.mastercardworldwide.com/type/messagebase/v1","Ns9":"http://ws.ips.mastercardworldwide.com/message/transaction/v1"}},"Soapenv":"http://schemas.xmlsoap.org/soap/envelope/","Soapenc":"http://schemas.xmlsoap.org/soap/encoding/","Xsd":"http://www.w3.org/2001/XMLSchema","Xsi":"http://www.w3.org/2001/XMLSchema-instance"}');
			        res.setStatusCode(200);
			        return res;
			    }
			}			


     
      @isTest static  void testsaveAccountCallouts() {
      			Account objAccount = [select id from Account limit 1];
				List<Account_Details__c> objAccountDetails = [select id from Account_Details__c limit 2];
				Test.startTest();	   	
		     	Test.setMock(HttpCalloutMock.class, new MockHttpAddResponseGenerator());
		         List<String> err = ManageTravelPlansController.MCAPICallout(objAccount.Id,'["' + objAccountDetails[0].Id + '"]','[{"Country__c":"AUSTRALIA","Departure_Date__c":"2018-09-03","Destination__c":"International","Return_Date__c":"2018-09-04","State__c":"","Email__c":"dbhavsar@affirma.com","IsEmailPreferred__c":true,"US_Mobile_Number__c":"555-763-4140"}]');
		         ManageTravelPlansController.saveTravelNotification(objAccount.Id,'["' + objAccountDetails[0].Id + '"]','[{"Country__c":"AUSTRALIA","Departure_Date__c":"2018-09-03","Destination__c":"International","Return_Date__c":"2018-09-04","State__c":"","Email__c":"dbhavsar@affirma.com","IsEmailPreferred__c":true,"US_Mobile_Number__c":"555-763-4140"}]', '5165967021121165,AUSTRALIA|');
		          List<String> err1 = ManageTravelPlansController.MCAPICallout(objAccount.Id,'["' + objAccountDetails[1].Id + '"]','[{"Country__c":"AUSTRALIA","Departure_Date__c":"2018-09-03","Destination__c":"International","Return_Date__c":"2018-09-04","State__c":"","Email__c":"dbhavsar@affirma.com","IsEmailPreferred__c":true,"US_Mobile_Number__c":"555-763-4140"}]');
		         ManageTravelPlansController.saveTravelNotification(objAccount.Id,'["' + objAccountDetails[1].Id + '"]','[{"Country__c":"AUSTRALIA","Departure_Date__c":"2018-09-03","Destination__c":"International","Return_Date__c":"2018-09-04","State__c":"","Email__c":"dbhavsar@affirma.com","IsEmailPreferred__c":true,"US_Mobile_Number__c":"555-763-4140"}]', '5165967021121165,AUSTRALIA|');
		       Test.stopTest();		      
		         
      }
      
      @isTest static  void testsaveAccountDetailCallouts() {
      			List<Account_Details__c> objAccountDetails = [select id from Account_Details__c limit 2];
				Test.startTest();	   	
		     	Test.setMock(HttpCalloutMock.class, new MockHttpAddResponseGenerator());
		         List<String> err = ManageTravelPlansController.MCAPICallout(objAccountDetails[0].Id,'["' + objAccountDetails[0].Id + '"]','[{"Country__c":"AUSTRALIA","Departure_Date__c":"2018-09-03","Destination__c":"International","Return_Date__c":"2018-09-04","State__c":"","Email__c":"dbhavsar@affirma.com","IsEmailPreferred__c":true,"US_Mobile_Number__c":"555-763-4140"}]');
		         ManageTravelPlansController.saveTravelNotification(objAccountDetails[0].Id,'["' + objAccountDetails[0].Id + '"]','[{"Country__c":"AUSTRALIA","Departure_Date__c":"2018-09-03","Destination__c":"International","Return_Date__c":"2018-09-04","State__c":"","Email__c":"dbhavsar@affirma.com","IsEmailPreferred__c":true,"US_Mobile_Number__c":"555-763-4140"}]', '5165967021121165,AUSTRALIA|');
		         List<String> err1 = ManageTravelPlansController.MCAPICallout(objAccountDetails[1].Id,'["' + objAccountDetails[1].Id + '"]','[{"Country__c":"AUSTRALIA","Departure_Date__c":"2018-09-03","Destination__c":"International","Return_Date__c":"2018-09-04","State__c":"","Email__c":"dbhavsar@affirma.com","IsEmailPreferred__c":true,"US_Mobile_Number__c":"555-763-4140"}]');
		         ManageTravelPlansController.saveTravelNotification(objAccountDetails[1].Id,'["' + objAccountDetails[1].Id + '"]','[{"Country__c":"AUSTRALIA","Departure_Date__c":"2018-09-03","Destination__c":"International","Return_Date__c":"2018-09-04","State__c":"","Email__c":"dbhavsar@affirma.com","IsEmailPreferred__c":true,"US_Mobile_Number__c":"555-763-4140"}]', '5165967021121165,AUSTRALIA|');
		         Test.stopTest();
		        
      }
      
      @isTest static  void testsaveCaseCallouts() {
      			List<Account_Details__c> objAccountDetails = [select id from Account_Details__c limit 2];
				List<Case> objCase = [select id, Description from Case limit 4];
				Test.startTest();	   	
		     	Test.setMock(HttpCalloutMock.class, new MockHttpAddResponseGenerator());
		        List<String> err = ManageTravelPlansController.MCAPICallout(objCase[0].Id,'["' + objAccountDetails[0].Id + '"]','[{"Country__c":"AUSTRALIA","Departure_Date__c":"2018-09-03","Destination__c":"International","Return_Date__c":"2018-09-04","State__c":"","Email__c":"dbhavsar@affirma.com","IsEmailPreferred__c":true,"US_Mobile_Number__c":"555-763-4140"}]');
		        ManageTravelPlansController.saveTravelNotification(objCase[0].Id,'["' + objAccountDetails[0].Id + '"]','[{"Country__c":"AUSTRALIA","Departure_Date__c":"2018-09-03","Destination__c":"International","Return_Date__c":"2018-09-04","State__c":"","Email__c":"dbhavsar@affirma.com","IsEmailPreferred__c":true,"US_Mobile_Number__c":"555-763-4140"}]', '5165967021121165,AUSTRALIA|');
		       // List<String> err1 = ManageTravelPlansController.MCAPICallout(objCase[1].Id,'["' + objAccountDetails[1].Id + '"]','[{"Country__c":"AUSTRALIA","Departure_Date__c":"2018-09-03","Destination__c":"International","Return_Date__c":"2018-09-04","State__c":"","Email__c":"dbhavsar@affirma.com","IsEmailPreferred__c":true,"US_Mobile_Number__c":"555-763-4140"}]');
		      	//ManageTravelPlansController.saveTravelNotification(objCase[1].Id,'["' + objAccountDetails[1].Id + '"]','[{"Country__c":"AUSTRALIA","Departure_Date__c":"2018-09-03","Destination__c":"International","Return_Date__c":"2018-09-04","State__c":"","Email__c":"dbhavsar@affirma.com","IsEmailPreferred__c":true,"US_Mobile_Number__c":"555-763-4140"}]', '5165967021121165,AUSTRALIA|');  
		       Test.stopTest();        
      }
      
      @isTest static  void testsaveCaseCallouts1() {
      			List<Account_Details__c> objAccountDetails = [select id from Account_Details__c limit 2];
				List<Case> objCase = [select id, Description from Case limit 4];
				Test.startTest();	   	
		     	Test.setMock(HttpCalloutMock.class, new MockHttpAddResponseGenerator());
		        
		        List<String> err1 = ManageTravelPlansController.MCAPICallout(objCase[0].Id,'["' + objAccountDetails[1].Id + '"]','[{"Country__c":"AUSTRALIA","Departure_Date__c":"2018-09-03","Destination__c":"International","Return_Date__c":"2018-09-04","State__c":"","Email__c":"dbhavsar@affirma.com","IsEmailPreferred__c":true,"US_Mobile_Number__c":"555-763-4140"}]');
		      	ManageTravelPlansController.saveTravelNotification(objCase[0].Id,'["' + objAccountDetails[1].Id + '"]','[{"Country__c":"AUSTRALIA","Departure_Date__c":"2018-09-03","Destination__c":"International","Return_Date__c":"2018-09-04","State__c":"","Email__c":"dbhavsar@affirma.com","IsEmailPreferred__c":true,"US_Mobile_Number__c":"555-763-4140"}]', '5165967021121165,AUSTRALIA|');  
		       Test.stopTest();        
      }
      
      @isTest static  void testdeleteCallouts() {
     	
		     	Account_Details__c objAccountDetails = [select id from Account_Details__c limit 1];
				Account objAccount = [select id from Account limit 1];
				List<Case> objCase = [select id from Case limit 4];
				Test.startTest();	   	
		     	Test.setMock(HttpCalloutMock.class, new MockHttpDeleteResponseGenerator());
		        
		        // Call method to test.
		        // This causes a fake response to be sent
		        // from the class that implements HttpCalloutMock. 
		        string res = ManageTravelPlansController.deleteCurrentTravelPlans('{"MasterCardSFObj":{"Id":"a1x3F000000I0O9QAK","CardId__c":"a0O3F000001bF5WUAU","Case__c":"5003F0000018wZPQAY","Country__c":"NEPAL","Departure_Date__c":"2018-11-05","Destination__c":"International","Email__c":"dbhavsar@affirma.com","Return_Date__c":"2018-11-06","Name":"MATR000000176","IsEmailPreferred__c":true,"IsPhonePreferred__c":false,"US_Mobile_Number__c":"555-469-3885","Timezone__c":"America/Los_Angeles","CardId__r":{"Card_Number_Last_4_Digits__c":"4902","TypeTranslate__c":"DEBIT","Card_Number__c":"5509840739294902","Id":"a0O3F000001bF5WUAU"}},"MCOriginalDataObj":{"CardNo":"5509840739294902","FromDate":"2018-11-05","FromDateTime":"2018-11-05T00:00:00","Last4Digits":"4902","SegmentName":"Asia","TimeZone":"America/Los_Angeles","ToDate":"2018-11-06", "ToDateTime":"2018-11-06T00:00:00"}}');
		       
		         Test.stopTest();   
     
     }
     
      @isTest static  void testupdateCallouts() {
     	
		     	Account_Details__c objAccountDetails = [select id from Account_Details__c limit 1];
				Account objAccount = [select id from Account limit 1];
				List<Case> objCase = [select id from Case limit 4];
				Test.startTest();	   	
		     	Test.setMock(HttpCalloutMock.class, new MockHttpUpdateResponseGenerator());
		        
		        // Call method to test.
		        // This causes a fake response to be sent
		        // from the class that implements HttpCalloutMock. 
		        string res = ManageTravelPlansController.updateCurrentTravelPlans('{"MasterCardSFObj":{"Id":"a1x3F000000I0LJQA0","CardId__c":"a0O3F000001bF5WUAU","Case__c":"5003F0000018uUoQAI","Country__c":"ALBANIA","Departure_Date__c":"2018-08-29","Destination__c":"International","Email__c":"email.sample@email.com","Return_Date__c":"2018-08-30","Name":"MATR000000142","IsEmailPreferred__c":false,"IsPhonePreferred__c":true,"US_Mobile_Number__c":"555-469-3885","Timezone__c":"America/Los_Angeles","CardId__r":{"Card_Number_Last_4_Digits__c":"4902","TypeTranslate__c":"DEBIT","Card_Number__c":"5509840739294902","Id":"a0O3F000001bF5WUAU"}},"MCOriginalDataObj":{"CardNo":"5509840739294902","FromDate":"2018-08-29","FromDateTime":"2018-08-29T00:00:00","Last4Digits":"4902","SegmentName":"Europe","TimeZone":"America/Los_Angeles","ToDate":"2018-08-30", "ToDateTime":"2018-08-30T00:00:00"}}');
		       ManageTravelPlansController.updateSFCurrentTravelPlans('{"MasterCardSFObj":{"Id":"a1x3F000000I0LJQA0","CardId__c":"a0O3F000001bF5WUAU","Case__c":"5003F0000018uUoQAI","Country__c":"ALBANIA","Departure_Date__c":"2018-08-29","Destination__c":"International","Email__c":"email.sample@email.com","Return_Date__c":"2018-08-30","Name":"MATR000000142","IsEmailPreferred__c":false,"IsPhonePreferred__c":true,"US_Mobile_Number__c":"555-469-3885","Timezone__c":"America/Los_Angeles","CardId__r":{"Card_Number_Last_4_Digits__c":"4902","TypeTranslate__c":"DEBIT","Card_Number__c":"5509840739294902","Id":"a0O3F000001bF5WUAU"}},"MCOriginalDataObj":{"CardNo":"5509840739294902","FromDate":"2018-08-29","Last4Digits":"4902","SegmentName":"Europe","TimeZone":"America/Los_Angeles","ToDate":"2018-08-30"}}');
		         Test.stopTest();   
     
     }
     
     
     @isTest static  void testgetCallouts() {
     	
		     	List<Account_Details__c> objAccountDetails = [select id from Account_Details__c limit 2];
				Account objAccount = [select id from Account limit 1];
				List<Case> objCase = [select id from Case limit 4];
				Test.startTest();	   	
		     	Test.setMock(HttpCalloutMock.class, new MockHttpGetResponseGenerator());
		        
		        // Call method to test.
		        // This causes a fake response to be sent
		        // from the class that implements HttpCalloutMock. 
		        List<ManageTravelPlansController.wrapperObject> res = ManageTravelPlansController.getCurrentTravelPlans(objAccount.Id);
		        res = ManageTravelPlansController.getCurrentTravelPlans(objAccountDetails[0].Id);
		        res = ManageTravelPlansController.getCurrentTravelPlans(objAccountDetails[1].Id);
		        res = ManageTravelPlansController.getCurrentTravelPlans(objCase[0].Id);
		        res = ManageTravelPlansController.getCurrentTravelPlans(objCase[3].Id);
		         Test.stopTest();   
     
     }
}