@isTest
public class SolarLoanToSignCardTest {
	@testSetup
    static void setup() {
        DocuSign_User_Details__c DTSpectrum = new DocuSign_User_Details__c();
        DTSpectrum.TemplateId__c = 'dc16d8f8-571c-497e-bbf5-42d8b25d4ee1';
        DTSpectrum.ReplyTo__c = 'noreply@spectrum.org';
        DTSpectrum.AccountId__c = '2e80db6b-16cf-4202-bf90-dfa029c5949f';
        DTSpectrum.Username__c = '524ecc26-873e-4590-b094-a079ad9a65a2';
        DTSpectrum.Password__c = '!DocusignApi';
        DTSpectrum.IntegratorKey__c = 	'12c7957a-484f-4fec-b6b3-461ec9b666aa';
        DTSpectrum.EndPoint__c = 'demo.docusign.net';
        DTSpectrum.Name = 'Spectrum';
        
        insert DTSpectrum;
    }
    @istest
    static void SetCustomFieldFalseTest(){
        SolarLoanToSignCardHelper.SetCustomFieldFalse();
    }
    static testMethod void SolarLoanDocTestData1(){
        
        Solar_Loans__c sl = new Solar_Loans__c();
        sl.Joint_First_Name__c ='Tom';
        sl.Joint_Last_Name__c = 'Jerry';
        sl.Joint_DOB__c = System.today();
        sl.Joint_SSN__c =  '1715';
        sl.Joint_FICO_Score__c = 12.00;
        sl.Joint_City__c = 'city';
        sl.Joint_State__c = 'PA';
        sl.Joint_Zip_Code__c =  '12345';
        sl.Joint_Address_1__c = 'street';
        sl.Joint_Address_2__c = 'street2';
        
        sl.Primary_First_Name__c ='Tom';
        sl.Primary_Last_Name__c = 'Jerry';
        sl.Primary_DOB__c = System.today();
        sl.Primary_SSN__c =  '1715';
        sl.Primary_Address_1__c = 'Add';
        sl.Primary_FICO_Score__c = 12.00;
        sl.Primary_City__c = 'city';
        sl.Primary_State__c = 'PA';
        sl.Primary_Zip_Code__c =  '12345';
        sl.Legal_Description__c = 'test';
        sl.Product__c = 'product';
        sl.Module__c = 'module&';
        sl.Installer_Number__c = '12';
        sl.Inverter__c = 'inverter&';
        sl.System_Size_kW__c = 12.00;
        sl.Battery__c = 'barary';
        sl.Installer__c = 'intealer&';
        sl.Application_Date__c = system.today();
        sl.Mortgage_Balance__c = 1299.00;
        sl.Final_Payment_Amount__c = 111.00;
        sl.Go_To_Payment__c = 1252.00;
        sl.Bank_Name__c = 'test & bank';
        sl.Membership_Fee__c = 126.00;
        sl.Net_Funding_Amount__c = 1213.00;
        sl.Loan_Amount__c = 1211.00;
        sl.Loan_Pmt_Amount__c = 1245.00;
        sl.Credit_Exception__c = 'cr';
        sl.ITC_Rate__c = 2.00;
        sl.ITC_Amount__c = 1245.88;
        sl.Term_months__c = 12;
        sl.OID_Fee__c = 11;
        sl.Approval_Date__c = system.today();
        sl.ECOA_Code__c = '2';
        sl.Site_UUID__c = '11';
        sl.FNI__c = '12';
        sl.Member_Number__c = '0000147163';
        sl.Status__c = 'New'; 
        sl.ACH__c = 'True';
        sl.Primary_Cell_Phone__c = '567-678-7898';
        sl.Primary_Home_Phone__c = '567-678-7898';
        sl.Primary_Work_Phone__c = '567-678-7898';
        sl.Primary_Email__c = 'test@test.com';
        sl.mem_ID_Expiration_Date__c = system.today() + 100;
        sl.mem_Primary_SSN__c = '123456789';
        
        sl.mem_Primary_DOB__c = system.today() - 50000;
        sl.mem_Primary_City__c = 'City';
        sl.Employer__c = 'T&T';
        sl.mem_Primary_Extra_Address__c = 'Extra';
        sl.mem_Primary_First_Name__c = 'First';
        sl.mem_ID_Issue_Date__c = system.today() - 500;
        sl.mem_ID_Number__c = 'RRR1';
        sl.mem_ID_Type__c = 'Passport'; 
        sl.mem_Primary_Last_Name__c = 'LAst';
        sl.Primary_Middle_Initial__c = 'M';
        sl.mem_Maiden_Name__c = 'M';
        sl.Occupation__c = 'Occ';
        sl.mem_Primary_State__c = 'State';
        sl.mem_Primary_Zip_Code__c = '12356';
        sl.Primary_Work_Phone__c = '123-121-1212';
        
        sl.mem_Joint_SSN__c = '123456789';
        sl.mem_Joint_DOB__c = system.today() - 50000;
        sl.mem_Joint_City__c = 'City';
        sl.mem_Joint_City__c = 'test@test.com';
        sl.mem_Joint_Employer__c = 'A & B';
        sl.mem_Joint_Extra_Address__c = 'Extra';
        sl.mem_Joint_First_Name__c = 'JointFirst';
        sl.Joint_Home_Phone__c = '123-345-6787';
        sl.Joint_ID_Expiration_Date__c = system.today() + 1000;
        sl.Joint_ID_Issue_Date__c = system.today() - 1000;
        sl.Joint_ID_Number__c = 'TTT';
        sl.Joint_ID_Type__c = 'Passport';
        sl.mem_Joint_Last_Name__c = 'JointLast';
        sl.Joint_Middle_Initial__c = 'M';
        sl.Joint_Cell_Phone__c = '123-456-7653';
        sl.Joint_Maiden_Name__c = 'maiden';
        sl.Joint_Occupation__c = 'Service';
        sl.mem_Joint_State__c = 'CA';
        sl.mem_Joint_Street__c = 'Street';
        sl.Joint_Work_Phone__c = '123-445-4432';
        sl.mem_Joint_Zip_Code__c = '12345'; 
        
        sl.mem_Mailing_Extra_Address__c = 'MailExtra';
        sl.mem_Mailing_State__c = 'MailState';
        sl.Primary_Middle_Initial__c = 'E';
        sl.mem_Mailing_City__c = 'City';
        sl.Mailing_Street__c = 'Street';
        sl.Mailing_Zip__c = '12345';
		
        Solar_Loans__c sl1 = new Solar_Loans__c();
        sl1.Joint_First_Name__c ='Tom';
        sl1.Joint_Last_Name__c = 'Jerry';
        sl1.Joint_DOB__c = System.today();
        sl1.Joint_SSN__c =  '123';
        //sl1.Joint_FICO_Score__c = 12.00;
        sl1.Joint_City__c = 'city';
        sl1.Joint_State__c = 'PA';
        sl1.Joint_Zip_Code__c =  '12345';
        sl1.Joint_Address_1__c = 'street';
        sl1.Joint_Address_2__c = 'street2';
        
        sl1.Primary_First_Name__c ='Tom';
        sl1.Primary_Last_Name__c = 'Jerry';
        sl1.Primary_DOB__c = System.today();
        sl1.Primary_SSN__c =  '123456789';
        sl1.Primary_Address_1__c = 'Add';
        sl1.Primary_FICO_Score__c = 12.00;
        sl1.Primary_City__c = 'city';
        sl1.Primary_State__c = 'PA';
        sl1.Primary_Zip_Code__c =  '12345';
        sl1.Legal_Description__c = 'test';
        sl1.Product__c = 'product';
        sl1.Module__c = 'module&';
        sl1.Installer_Number__c = '12';
        sl1.Inverter__c = 'inverter&';
        sl1.System_Size_kW__c = 12.00;
        sl1.Battery__c = 'barary';
        sl1.Installer__c = 'intealer&';
        sl1.Application_Date__c = system.today();
        //sl1.Mortgage_Balance__c = 1299.00;
        //sl1.Final_Payment_Amount__c = 111.00;
        //sl1.Go_To_Payment__c = 1252.00;
        sl1.Bank_Name__c = 'test & bank';
        //sl1.Membership_Fee__c = 126.00;
        sl1.Net_Funding_Amount__c = 1213.00;
        //sl1.Loan_Amount__c = 1211.00;
        //sl1.Loan_Pmt_Amount__c = 1245.00;
        sl1.Credit_Exception__c = 'cr';
        //sl1.ITC_Rate__c = 2.00;
        //sl1.ITC_Amount__c = 1245.88;
        sl1.Term_months__c = 12;
        //sl1.OID_Fee__c = 11;
        sl1.Approval_Date__c = system.today();
        sl1.ECOA_Code__c = '2';
        sl1.Site_UUID__c = '116';
        sl1.FNI__c = '12';
        sl1.Member_Number__c = '0000147163';
        sl1.Status__c = 'New'; 
        sl1.Primary_Cell_Phone__c = '567-678-7898';
        sl1.Primary_Home_Phone__c = '567-678-7898';
        sl1.Primary_Work_Phone__c = '567-678-7898';
        sl1.Primary_Email__c = 'test@test.com';
        sl1.mem_ID_Expiration_Date__c = system.today() + 100;
        sl1.mem_Primary_SSN__c = '123456789';
        //sl1.Additional_Amount__c = 11.00; 
        sl1.Brand__c = 'Spectrum';
        sl1.mem_Primary_DOB__c = system.today() - 50000;
        sl1.mem_Primary_City__c = 'City';
        sl1.Employer__c = 'T&T';
        sl1.mem_Primary_Extra_Address__c = 'Extra';
        sl1.mem_Primary_First_Name__c = 'First';
        sl1.mem_ID_Issue_Date__c = system.today() - 500;
        sl1.mem_ID_Number__c = 'RRR1';
        sl1.mem_ID_Type__c = 'Passport'; 
        sl1.mem_Primary_Last_Name__c = 'LAst';
        sl1.Primary_Middle_Initial__c = 'M';
        sl1.mem_Maiden_Name__c = 'M';
        sl1.Occupation__c = 'Occ';
        sl1.mem_Primary_State__c = 'State';
        sl1.mem_Primary_Zip_Code__c = '12356';
        sl1.Primary_Work_Phone__c = '123-121-1212';
        sl1.ACH__c = 'True';
        sl1.mem_Joint_SSN__c = '127081988';
        
        sl1.mem_Mailing_Extra_Address__c = 'MailExtra';
        sl1.mem_Mailing_State__c = 'MailState';
        
        List<Solar_Loans__c> slList = new List<Solar_Loans__c>();
        
        slList.add(sl);
       	//slList.add(sl1);
       	SolarLoan_To_Episys_API_Details__c api = new SolarLoan_To_Episys_API_Details__c();
        api.Name = 'ProductionURL';
        api.URL__c = 'https://symxapi.chevronfcu.org/devclient';
        insert api;
       	
       
        
        Test.startTest();
        Insert slList;
       
        ContentVersion objAt = new ContentVersion(Title = 'Membership Application',PathOnClient = 'Membership Application.pdf',VersionData = Blob.valueOf('Test Content'), IsMajorVersion = true);
     	Insert objAt;
      	List<ContentDocument> cdList = [SELECT Id, Title, LatestPublishedVersionId FROM ContentDocument];
   		List<ContentDocumentLink> ListCDL = new List<ContentDocumentLink>{
     		new ContentDocumentLink (ContentDocumentId = cdList[0].id, LinkedEntityId =  slList[0].id)};
     	insert ListCDL;
		
        Test.setCurrentPage(Page.InitiateSignature);
     	ApexPages.StandardSetController sc = new ApexPages.StandardSetController(slList);
        sc.setSelected(slList);
        SolarLoanToSignCard slcard = new SolarLoanToSignCard(sc);
        slcard.ExecuteSignatureMethod();
		Test.stopTest();                
    }
    
     static testMethod void SolarLoanDocTestData2(){
        
        Solar_Loans__c sl = new Solar_Loans__c();
        sl.Joint_First_Name__c ='Tom';
        sl.Joint_Last_Name__c = 'Jerry';
        sl.Joint_DOB__c = System.today();
        sl.Joint_SSN__c =  '1715';
        sl.Joint_FICO_Score__c = 12.00;
        sl.Joint_City__c = 'city';
        sl.Joint_State__c = 'PA';
        sl.Joint_Zip_Code__c =  '12345';
        sl.Joint_Address_1__c = 'street';
        sl.Joint_Address_2__c = 'street2';
        
        sl.Primary_First_Name__c ='Tom';
        sl.Primary_Last_Name__c = 'Jerry';
        sl.Primary_DOB__c = System.today();
        sl.Primary_SSN__c =  '1715';
        sl.Primary_Address_1__c = 'Add';
        sl.Primary_FICO_Score__c = 12.00;
        sl.Primary_City__c = 'city';
        sl.Primary_State__c = 'PA';
        sl.Primary_Zip_Code__c =  '12345';
        sl.Legal_Description__c = 'test';
        sl.Product__c = 'product';
        sl.Module__c = 'module&';
        sl.Installer_Number__c = '12';
        sl.Inverter__c = 'inverter&';
        sl.System_Size_kW__c = 12.00;
        sl.Battery__c = 'barary';
        sl.Installer__c = 'intealer&';
        sl.Application_Date__c = system.today();
        sl.Mortgage_Balance__c = 1299.00;
        sl.Final_Payment_Amount__c = 111.00;
        sl.Go_To_Payment__c = 1252.00;
        sl.Bank_Name__c = 'test & bank';
        sl.Membership_Fee__c = 126.00;
        sl.Net_Funding_Amount__c = 1213.00;
        sl.Loan_Amount__c = 1211.00;
        sl.Loan_Pmt_Amount__c = 1245.00;
        sl.Credit_Exception__c = 'cr';
        sl.ITC_Rate__c = 2.00;
        sl.ITC_Amount__c = 1245.88;
        sl.Term_months__c = 12;
        sl.OID_Fee__c = 11;
        sl.Approval_Date__c = system.today();
        sl.ECOA_Code__c = '2';
        sl.Site_UUID__c = '11';
        sl.FNI__c = '12';
        sl.Member_Number__c = '0000147163';
        sl.Status__c = 'New'; 
        sl.ACH__c = 'True';
        sl.Primary_Cell_Phone__c = '567-678-7898';
        sl.Primary_Home_Phone__c = '567-678-7898';
        sl.Primary_Work_Phone__c = '567-678-7898';
        sl.Primary_Email__c = 'test@test.com';
        sl.mem_ID_Expiration_Date__c = system.today() + 100;
        sl.mem_Primary_SSN__c = '123456789';
        
        sl.mem_Primary_DOB__c = system.today() - 50000;
        sl.mem_Primary_City__c = 'City';
        sl.Employer__c = 'T&T';
        sl.mem_Primary_Extra_Address__c = 'Extra';
        sl.mem_Primary_First_Name__c = 'First';
        sl.mem_ID_Issue_Date__c = system.today() - 500;
        sl.mem_ID_Number__c = 'RRR1';
        sl.mem_ID_Type__c = 'Passport'; 
        sl.mem_Primary_Last_Name__c = 'LAst';
        sl.Primary_Middle_Initial__c = 'M';
        sl.mem_Maiden_Name__c = 'M';
        sl.Occupation__c = 'Occ';
        sl.mem_Primary_State__c = 'State';
        sl.mem_Primary_Zip_Code__c = '12356';
        sl.Primary_Work_Phone__c = '123-121-1212';
        
        sl.mem_Joint_SSN__c = '123456789';
        sl.mem_Joint_DOB__c = system.today() - 50000;
        sl.mem_Joint_City__c = 'City';
        sl.mem_Joint_City__c = 'test@test.com';
        sl.mem_Joint_Employer__c = 'A & B';
        sl.mem_Joint_Extra_Address__c = 'Extra';
        sl.mem_Joint_First_Name__c = 'JointFirst';
        sl.Joint_Home_Phone__c = '123-345-6787';
        sl.Joint_ID_Expiration_Date__c = system.today() + 1000;
        sl.Joint_ID_Issue_Date__c = system.today() - 1000;
        sl.Joint_ID_Number__c = 'TTT';
        sl.Joint_ID_Type__c = 'Passport';
        sl.mem_Joint_Last_Name__c = 'JointLast';
        sl.Joint_Middle_Initial__c = 'M';
        sl.Joint_Cell_Phone__c = '123-456-7653';
        sl.Joint_Maiden_Name__c = 'maiden';
        sl.Joint_Occupation__c = 'Service';
        sl.mem_Joint_State__c = 'CA';
        sl.mem_Joint_Street__c = 'Street';
        sl.Joint_Work_Phone__c = '123-445-4432';
        sl.mem_Joint_Zip_Code__c = '12345'; 
        
        sl.mem_Mailing_Extra_Address__c = 'MailExtra';
        sl.mem_Mailing_State__c = 'MailState';
        sl.Primary_Middle_Initial__c = 'E';
        sl.mem_Mailing_City__c = 'City';
        sl.Mailing_Street__c = 'Street';
        sl.Mailing_Zip__c = '12345';
        
        List<Solar_Loans__c> slList = new List<Solar_Loans__c>();
        
        slList.add(sl);
       	
        Test.startTest();
        Insert slList;
       
        Test.setCurrentPage(Page.InitiateSignature);
     	ApexPages.StandardSetController sc = new ApexPages.StandardSetController(slList);
        sc.setSelected(slList);
        SolarLoanToSignCard slcard = new SolarLoanToSignCard(sc);
        Test.stopTest();                
    }
    
    static testMethod void SolarLoanDocTestData3(){
        	
        Solar_Loans__c sl1 = new Solar_Loans__c();
        sl1.Joint_First_Name__c ='Tom';
        sl1.Joint_Last_Name__c = 'Jerry';
        sl1.Joint_DOB__c = System.today();
        sl1.Joint_SSN__c =  '123';
        //sl1.Joint_FICO_Score__c = 12.00;
        sl1.Joint_City__c = 'city';
        sl1.Joint_State__c = 'PA';
        sl1.Joint_Zip_Code__c =  '12345';
        sl1.Joint_Address_1__c = 'street';
        sl1.Joint_Address_2__c = 'street2';
        
        sl1.Primary_First_Name__c ='Tom';
        sl1.Primary_Last_Name__c = 'Jerry';
        sl1.Primary_DOB__c = System.today();
        sl1.Primary_SSN__c =  '123456789';
        sl1.Primary_Address_1__c = 'Add';
        sl1.Primary_FICO_Score__c = 12.00;
        sl1.Primary_City__c = 'city';
        sl1.Primary_State__c = 'PA';
        sl1.Primary_Zip_Code__c =  '12345';
        sl1.Legal_Description__c = 'test';
        sl1.Product__c = 'product';
        sl1.Module__c = 'module&';
        sl1.Installer_Number__c = '12';
        sl1.Inverter__c = 'inverter&';
        sl1.System_Size_kW__c = 12.00;
        sl1.Battery__c = 'barary';
        sl1.Installer__c = 'intealer&';
        sl1.Application_Date__c = system.today();
        //sl1.Mortgage_Balance__c = 1299.00;
        //sl1.Final_Payment_Amount__c = 111.00;
        //sl1.Go_To_Payment__c = 1252.00;
        sl1.Bank_Name__c = 'test & bank';
        //sl1.Membership_Fee__c = 126.00;
        sl1.Net_Funding_Amount__c = 1213.00;
        //sl1.Loan_Amount__c = 1211.00;
        //sl1.Loan_Pmt_Amount__c = 1245.00;
        sl1.Credit_Exception__c = 'cr';
        //sl1.ITC_Rate__c = 2.00;
        //sl1.ITC_Amount__c = 1245.88;
        sl1.Term_months__c = 12;
        //sl1.OID_Fee__c = 11;
        sl1.Approval_Date__c = system.today();
        sl1.ECOA_Code__c = '2';
        sl1.Site_UUID__c = '116';
        sl1.FNI__c = '12';
        sl1.Member_Number__c = '0000147163';
        sl1.Status__c = 'New'; 
        sl1.Primary_Cell_Phone__c = '567-678-7898';
        sl1.Primary_Home_Phone__c = '567-678-7898';
        sl1.Primary_Work_Phone__c = '567-678-7898';
        sl1.Primary_Email__c = 'test@test.com';
        sl1.mem_ID_Expiration_Date__c = system.today() + 100;
        sl1.mem_Primary_SSN__c = '123456789';
        //sl1.Additional_Amount__c = 11.00; 
        sl1.Brand__c = 'Spectrum';
        sl1.mem_Primary_DOB__c = system.today() - 50000;
        sl1.mem_Primary_City__c = 'City';
        sl1.Employer__c = 'T&T';
        sl1.mem_Primary_Extra_Address__c = 'Extra';
        sl1.mem_Primary_First_Name__c = 'First';
        sl1.mem_ID_Issue_Date__c = system.today() - 500;
        sl1.mem_ID_Number__c = 'RRR1';
        sl1.mem_ID_Type__c = 'Passport'; 
        sl1.mem_Primary_Last_Name__c = 'LAst';
        sl1.Primary_Middle_Initial__c = 'M';
        sl1.mem_Maiden_Name__c = 'M';
        sl1.Occupation__c = 'Occ';
        sl1.mem_Primary_State__c = 'State';
        sl1.mem_Primary_Zip_Code__c = '12356';
        sl1.Primary_Work_Phone__c = '123-121-1212';
        sl1.ACH__c = 'True';
        sl1.mem_Joint_SSN__c = '127081988';
        sl1.Signed__c = true;
        sl1.mem_Mailing_Extra_Address__c = 'MailExtra';
        sl1.mem_Mailing_State__c = 'MailState';
        
        List<Solar_Loans__c> slList = new List<Solar_Loans__c>();
        
       	slList.add(sl1);
       	
        Test.startTest();
        Insert slList;
       
        Test.setCurrentPage(Page.InitiateSignature);
     	ApexPages.StandardSetController sc = new ApexPages.StandardSetController(slList);
        sc.setSelected(slList);
        SolarLoanToSignCard slcard = new SolarLoanToSignCard(sc);
        Test.stopTest();                
    }
}