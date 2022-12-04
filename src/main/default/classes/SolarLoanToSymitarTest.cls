@isTest
public class SolarLoanToSymitarTest {
@testSetup
    static void setup() {
        List<Solar_Loans__c> slList = new List<Solar_Loans__c>();
       
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
        sl.Site_UUID__c = '111';
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
        sl.county__c = 'ST ';
        sl.Map__c ='TestMap';
        sl.Book__c = 'TestBook';
        sl.Page__c = 'TestPage';
        sl.APN__c = 'TestAPN';
        sl.Lot__c = 'TestLot';
        sl.Block__c = 'TestBlock';
        sl.Section__c = 'TestSection';
        sl.Tract__c = 'TestTract';
        sl.Subdivision__c ='TestSubDivision';
        sl.mem_Primary_Street__c = 'Test';
        sl.Jurisdiction__c = '10';
        slList.add(sl);
        
        Solar_Loans__c sl1 = new Solar_Loans__c();
        sl1.Joint_First_Name__c ='Tom';
        sl1.Joint_Last_Name__c = 'Jerry';
        sl1.Joint_DOB__c = System.today();
        sl1.Joint_SSN__c =  '1715';
        sl1.Joint_FICO_Score__c = 12.00;
        sl1.Joint_City__c = 'city';
        sl1.Joint_State__c = 'PA';
        sl1.Joint_Zip_Code__c =  '12345';
        sl1.Joint_Address_1__c = 'street';
        sl1.Joint_Address_2__c = 'street2';
        
        sl1.Primary_First_Name__c ='Tom';
        sl1.Primary_Last_Name__c = 'Jerry';
        sl1.Primary_DOB__c = System.today();
        sl1.Primary_SSN__c =  '1715';
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
        sl1.Mortgage_Balance__c = 1299.00;
        sl1.Final_Payment_Amount__c = 111.00;
        sl1.Go_To_Payment__c = 1252.00;
        sl1.Bank_Name__c = 'test & bank';
        sl1.Membership_Fee__c = 126.00;
        sl1.Net_Funding_Amount__c = 1213.00;
        sl1.Loan_Amount__c = 1211.00;
        sl1.Loan_Pmt_Amount__c = 1245.00;
        sl1.Credit_Exception__c = 'cr';
        sl1.ITC_Rate__c = 2.00;
        sl1.ITC_Amount__c = 1245.88;
        sl1.Term_months__c = 12;
        sl1.OID_Fee__c = 11;
        sl1.Approval_Date__c = system.today();
        sl1.ECOA_Code__c = '2';
        sl1.Site_UUID__c = '11';
        sl1.FNI__c = '12';
        sl1.Member_Number__c = '0000147164';
        sl1.Status__c = 'New'; 
        sl1.ACH__c = 'True';
        sl1.Primary_Cell_Phone__c = '567-678-7898';
        sl1.Primary_Home_Phone__c = '567-678-7898';
        sl1.Primary_Work_Phone__c = '567-678-7898';
        sl1.Primary_Email__c = 'test@test.com';
        sl1.mem_ID_Expiration_Date__c = system.today() + 100;
        sl1.mem_Primary_SSN__c = '123456789';
        
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
        
        sl1.mem_Joint_SSN__c = '123456789';
        sl1.mem_Joint_DOB__c = system.today() - 50000;
        sl1.mem_Joint_City__c = 'City';
        sl1.mem_Joint_City__c = 'test@test.com';
        sl1.mem_Joint_Employer__c = 'A & B';
        sl1.mem_Joint_Extra_Address__c = 'Extra';
        sl1.mem_Joint_First_Name__c = 'JointFirst';
        sl1.Joint_Home_Phone__c = '123-345-6787';
        sl1.Joint_ID_Expiration_Date__c = system.today() + 1000;
        sl1.Joint_ID_Issue_Date__c = system.today() - 1000;
        sl1.Joint_ID_Number__c = 'TTT';
        sl1.Joint_ID_Type__c = 'Passport';
        sl1.mem_Joint_Last_Name__c = 'JointLast';
        sl1.Joint_Middle_Initial__c = 'M';
        sl1.Joint_Cell_Phone__c = '123-456-7653';
        sl1.Joint_Maiden_Name__c = 'maiden';
        sl1.Joint_Occupation__c = 'Service';
        sl1.mem_Joint_State__c = 'CA';
        sl1.mem_Joint_Street__c = 'Streetmem_Joint_Street';
        sl1.Joint_Work_Phone__c = '123-445-4432';
        sl1.mem_Joint_Zip_Code__c = '12345'; 
        
        sl1.mem_Mailing_Extra_Address__c = 'MailExtra';
        sl1.mem_Mailing_State__c = 'MailState';
        sl1.Primary_Middle_Initial__c = 'E';
        sl1.mem_Mailing_City__c = 'City';
        sl1.Mailing_Street__c = 'Street';
        sl1.Mailing_Zip__c = '12345';
        sl1.county__c = 'ST ';
		sl1.Map__c = null;        
        sl1.Book__c = 'TestBook';
        sl1.Page__c = 'TestPage';
        sl1.APN__c = 'TestAPN';
        sl1.Lot__c = 'TestLot';
        sl1.Block__c = 'TestBlock';
        sl1.Section__c = 'TestSection';
        sl1.Tract__c = 'TestTract';
        sl1.Subdivision__c ='TestSubDivision';
        sl1.mem_Primary_Street__c = 'Test';
        sl1.Jurisdiction__c = 'Not Found';
        sl1.Additional_Amount__c = 2000.00;
        slList.add(sl1);
        insert slList;
        
        SolarLoan_To_Episys_API_Details__c slapi = new SolarLoan_To_Episys_API_Details__c();
        slapi.Name = 'ProductionURL';
        slapi.URL__c = 'https://symxapi.chevronfcu.org/devclient';
        insert slapi;
    }
     @istest
    static void insertSolarLoansTest(){ 
        Set<id> idSet = new Set<id>();
        List<Solar_Loans__c> slList = [Select id from Solar_Loans__c where Joint_First_Name__c ='Tom'];
        for(Solar_Loans__c sl : slList ){
             idSet.add(sl.Id);
        }
       
        test.startTest();
        	SolarLoanToSymitar.insertSolarLoans(idSet);
		test.stopTest();        
    }
     @istest
    static void updateEFTrecordTest(){ 
        Set<id> idSet = new Set<id>();
        List<Solar_Loans__c> slList = [Select id from Solar_Loans__c where Joint_First_Name__c ='Tom'];
        for(Solar_Loans__c sl : slList ){
             idSet.add(sl.Id);
        }
       
        test.startTest();
        	SolarLoanToSymitar.updateEFTrecord(idSet);
		test.stopTest();        
    }
    
}