@isTest
public class SolarLoanTriggerTest {
    
    @TestSetup
    public static void setup() {
    	 
        User u = [SELECT Id,Email,username FROM User WHERE IsActive = true and Profile.Name = 'CFCU Admin' limit 1];
		
        SolarLoan_To_Episys_API_Details__c api = new SolarLoan_To_Episys_API_Details__c();
        api.Name = 'ProductionURL';
        api.URL__c = 'https://symxapi.chevronfcu.org/devclient';
        insert api;
        
        Solar_Loan_Product_Types__c slpt = new Solar_Loan_Product_Types__c();
        slpt.Name = 'Solar';
        slpt.Description__c = 'SECURED SOLAR';
        insert slpt;
        
        DocuSign_User_Details__c DTChevron = new DocuSign_User_Details__c();
        DTChevron.TemplateId__c = 'dc16d8f8-57ec-497e-bbf5-42d8b25d4ee1';
        DTChevron.ReplyTo__c = 'noreply@chevron.org';
        DTChevron.AccountId__c = '2e80de6b-16cf-4202-bf90-dfa029c5949f';
        DTChevron.Username__c = '524ecc2e-873e-4590-b094-a079ad9a65a2';
        DTChevron.Password__c = '!DocusignApi';
        DTChevron.IntegratorKey__c = 	'12u7957a-484f-4fec-b6b3-461ec9b666aa';
        DTChevron.EndPoint__c = 'demo.docusign.net';
        DTChevron.Name = 'Chevron';
        
        insert DTChevron;
        
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
        
        Account ac = new Account();
        ac.FirstName = 'Jeff';
        ac.LastName = 'Franklin';
        insert ac;
        
        Account_Details__c ad = new Account_Details__c();
        ad.Name = '0000269355';
        ad.Reference__c = 'BC01';
        insert ad;
        
        Account_Details__c ad1 = new Account_Details__c();
        ad1.Name = '0000247286';
        ad1.Reference__c = 'BC01';
        insert ad1;
        
        Person_Account__c pa = new Person_Account__c();
        pa.account_number__c = ad.id;
        pa.PersonID__c = ac.id;
        pa.Name_Type__c = 0;
        insert pa;
        
        Person_Account__c pa1 = new Person_Account__c();
        pa1.account_number__c = ad1.id;
        pa1.PersonID__c = ac.id;
        pa.Name_Type__c = 0;
        insert pa1;
        
        SolarLoan_Docusign_Emails__c sde = new SolarLoan_Docusign_Emails__c();
        sde.Name = 'Email For Testing';
        sde.Emails__c = 'drana@chevronfcu.org';
        insert sde;
        
		System.runAs(u){        
            Solar_Loans__c sl = new Solar_Loans__c();
            sl.Joint_First_Name__c ='Tom';
            sl.Joint_Last_Name__c = 'Jerry';
            sl.Joint_DOB__c = System.today();
            sl.Joint_SSN__c =  '1715';
            sl.Joint_FICO_Score__c = 12.00;
            sl.Joint_City__c = 'city';
            sl.Joint_State__c = 'PA';
            sl.Joint_Zip_Code__c =  '12345';
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
            sl.Module__c = 'module';
            sl.Installer_Number__c = '12';
            sl.Inverter__c = 'inverter';
            sl.System_Size_kW__c = 12.00;
            sl.Battery__c = 'barary';
            sl.Installer__c = 'intealer';
            sl.Application_Date__c = system.today();
            sl.Mortgage_Balance__c = 1299.00;
            sl.Final_Payment_Amount__c = 111.00;
            sl.Go_To_Payment__c = 1252.00;
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
            sl.ECOA_Code__c = '1';
            sl.Site_UUID__c = '11';
            sl.FNI__c = '12';
            sl.Member_Number__c = '0000269355';
            sl.Status__c = 'New';
            sl.Bank_Name__c = 'Test Bank';
            sl.ABA_Bank_Name__c = 'Test Bank';
            sl.Additional_Amount__c = 100.00;
            sl.ACH__c = 'True';
            insert sl;
        	
            sl.Member_Number__c = '0000247286';
            update sl;
            try{
               sl.Inverter__c = '0000247286 FIELD_CUSTOM_VALIDATION_EXCEPTION';
               update sl; 
            } catch(Exception error){
                System.assert(error.getMessage().contains('FIELD_CUSTOM_VALIDATION_EXCEPTION'));  
            }
            try{
               sl.Installer__c = '0000247286 FIELD_CUSTOM_VALIDATION_EXCEPTION';
               update sl; 
            } catch(Exception error){
                System.assert(error.getMessage().contains('FIELD_CUSTOM_VALIDATION_EXCEPTION'));  
            }
            try{
               sl.Credit_Exception__c = '0000247286 FIELD_CUSTOM_VALIDATION_EXCEPTION';
               update sl; 
            } catch(Exception error){
                System.assert(error.getMessage().contains('FIELD_CUSTOM_VALIDATION_EXCEPTION'));  
            }
            try{
               sl.mem_Joint_Extra_Address__c = '0000247286 FIELD_CUSTOM_VALIDATION_EXCEPTION';
               update sl; 
            } catch(Exception error){
                System.assert(error.getMessage().contains('FIELD_CUSTOM_VALIDATION_EXCEPTION'));  
            }
            try{
               sl.Joint_Address_1__c = '0000247286 FIELD_CUSTOM_VALIDATION_EXCEPTION';
               update sl; 
            } catch(Exception error){
                System.assert(error.getMessage().contains('FIELD_CUSTOM_VALIDATION_EXCEPTION'));  
            }
            try{
               sl.mem_Joint_Employer__c = '0000247286 FIELD_CUSTOM_VALIDATION_EXCEPTION';
               update sl; 
            } catch(Exception error){
                System.assert(error.getMessage().contains('FIELD_CUSTOM_VALIDATION_EXCEPTION'));  
            }
            try{
               sl.Joint_ID_State__c = '0000247286 FIELD_CUSTOM_VALIDATION_EXCEPTION';
               update sl; 
            } catch(Exception error){
                System.assert(error.getMessage().contains('FIELD_CUSTOM_VALIDATION_EXCEPTION'));  
            }
            try{
               sl.mem_Mailing_City__c = '0000247286 FIELD_CUSTOM_VALIDATION_EXCEPTION';
               update sl; 
            } catch(Exception error){
                System.assert(error.getMessage().contains('FIELD_CUSTOM_VALIDATION_EXCEPTION'));  
            }
            try{
               sl.Site_UUID__c = '0000247286 FIELD_CUSTOM_VALIDATION_EXCEPTION';
               update sl; 
            } catch(Exception error){
                System.assert(error.getMessage().contains('FIELD_CUSTOM_VALIDATION_EXCEPTION'));  
            }
            try{
               sl.Product_Loan_Type__c = '0000247286 FIELD_CUSTOM_VALIDATION_EXCEPTION';
               update sl; 
            } catch(Exception error){
                System.assert(error.getMessage().contains('FIELD_CUSTOM_VALIDATION_EXCEPTION'));  
            }
            try{
               sl.Member_Number__c = '0000247286 FIELD_CUSTOM_VALIDATION_EXCEPTION';
               update sl; 
            } catch(Exception error){
                System.assert(error.getMessage().contains('FIELD_CUSTOM_VALIDATION_EXCEPTION'));  
            }
            try{
               sl.Bank_Name__c = '0000247286 FIELD_CUSTOM_VALIDATION_EXCEPTION';
               update sl; 
            } catch(Exception error){
                System.assert(error.getMessage().contains('FIELD_CUSTOM_VALIDATION_EXCEPTION'));  
            }
            try{
               sl.Occupation__c = '0000247286 FIELD_CUSTOM_VALIDATION_EXCEPTION';
               update sl; 
            } catch(Exception error){
                System.assert(error.getMessage().contains('FIELD_CUSTOM_VALIDATION_EXCEPTION'));  
            }try{
               sl.mem_Primary_Extra_Address__c = '0000247286 FIELD_CUSTOM_VALIDATION_EXCEPTION';
               update sl; 
            } catch(Exception error){
                System.assert(error.getMessage().contains('FIELD_CUSTOM_VALIDATION_EXCEPTION'));  
            }
            try{
               sl.mem_Mailing_City__c = '0000247286 FIELD_CUSTOM_VALIDATION_EXCEPTION';
               update sl; 
            } catch(Exception error){
                System.assert(error.getMessage().contains('FIELD_CUSTOM_VALIDATION_EXCEPTION'));  
            }
            try{
               sl.Module__c = '0000247286 FIELD_CUSTOM_VALIDATION_EXCEPTION';
               update sl; 
            } catch(Exception error){
                System.assert(error.getMessage().contains('FIELD_CUSTOM_VALIDATION_EXCEPTION'));  
            }
			try{
               sl.mem_Primary_Street__c = '0000247286 FIELD_CUSTOM_VALIDATION_EXCEPTION';
               update sl; 
            } catch(Exception error){
                System.assert(error.getMessage().contains('FIELD_CUSTOM_VALIDATION_EXCEPTION'));  
            }
            try{
               sl.Employer__c = '0000247286 FIELD_CUSTOM_VALIDATION_EXCEPTION';
               update sl; 
            } catch(Exception error){
                System.assert(error.getMessage().contains('FIELD_CUSTOM_VALIDATION_EXCEPTION'));  
            }
            try{
               sl.Mailing_Street__c = '0000247286 FIELD_CUSTOM_VALIDATION_EXCEPTION';
               update sl; 
            } catch(Exception error){
                System.assert(error.getMessage().contains('FIELD_CUSTOM_VALIDATION_EXCEPTION'));  
            }
            try{
               sl.mem_Joint_Street__c = '0000247286 FIELD_CUSTOM_VALIDATION_EXCEPTION';
               update sl; 
            } catch(Exception error){
                System.assert(error.getMessage().contains('FIELD_CUSTOM_VALIDATION_EXCEPTION'));  
            }
            try{
               sl.Joint_Occupation__c = '0000247286 FIELD_CUSTOM_VALIDATION_EXCEPTION';
               update sl; 
            } catch(Exception error){
                System.assert(error.getMessage().contains('FIELD_CUSTOM_VALIDATION_EXCEPTION'));  
            }
            try{
               sl.Joint_Maiden_Name__c = '0000247286 FIELD_CUSTOM_VALIDATION_EXCEPTION';
               update sl; 
            } catch(Exception error){
                System.assert(error.getMessage().contains('FIELD_CUSTOM_VALIDATION_EXCEPTION'));  
            }
            try{
               sl.Joint_ID_Number__c = '0000247286 FIELD_CUSTOM_VALIDATION_EXCEPTION';
               update sl; 
            } catch(Exception error){
                System.assert(error.getMessage().contains('FIELD_CUSTOM_VALIDATION_EXCEPTION'));  
            }
			try{
               sl.Joint_First_Name__c = '0000247286 FIELD_CUSTOM_VALIDATION_EXCEPTION';
               update sl; 
            } catch(Exception error){
                System.assert(error.getMessage().contains('FIELD_CUSTOM_VALIDATION_EXCEPTION'));  
            }
            System.debug('Current User: ' + UserInfo.getUserName());

            System.debug('ttt');
            System.debug('ttt1' + u);
            
            Account a = new Account();
            a.FirstName = 'Tom';
            a.LastName =   'Jerry';
            a.PersonEmail = 'jrakesh@affirma.com';
            insert a;
            
            try {
                List<Solar_Loans__c> slInsertlist = new List<Solar_Loans__c>();
                Solar_Loans__c sl2 = new Solar_Loans__c();
                sl2.Joint_First_Name__c ='Tom Solar ';
                sl2.Joint_Last_Name__c = 'Jerry Solar ';
                sl2.Joint_DOB__c = System.today();
                sl2.Joint_SSN__c =  '1715';
                sl2.Joint_FICO_Score__c = 12.00;
                sl2.Joint_City__c = 'city ';
                sl2.Joint_State__c = 'PA ';
                sl2.Joint_Zip_Code__c =  '12345';
                sl2.Primary_First_Name__c ='Tom';
                sl2.Primary_Last_Name__c = 'Jerry';
                sl2.Primary_DOB__c = System.today();
                sl2.Primary_SSN__c =  '1715';
                sl2.Primary_Address_1__c = 'Add';
                sl2.Primary_FICO_Score__c = 12.00;
                sl2.Primary_City__c = 'city';
                sl2.Primary_State__c = 'PA';
                sl2.Primary_Zip_Code__c =  '12345';
                sl2.Legal_Description__c = 'test';
                sl2.Product__c = 'product';
                sl2.Module__c = 'module';
                sl2.Installer_Number__c = '12';
                sl2.Inverter__c = 'inverter';
                sl2.System_Size_kW__c = 12.00;
                sl2.Battery__c = 'barary';
                sl2.Installer__c = 'intealer';
                sl2.Application_Date__c = system.today();
                sl2.Mortgage_Balance__c = 1299.00;
                sl2.Final_Payment_Amount__c = 111.00;
                sl2.Go_To_Payment__c = 1252.00;
                sl2.Membership_Fee__c = 126.00;
                sl2.Net_Funding_Amount__c = 1213.00;
                sl2.Loan_Amount__c = 1211.00;
                sl2.Loan_Pmt_Amount__c = 1245.00;
                sl2.Credit_Exception__c = 'crSolar Loan Non-Text Area fieldsSolar Loan Non-Text Area fields';
                sl2.ITC_Rate__c = 2.00;
                sl2.ITC_Amount__c = 1245.88;
                sl2.Term_months__c = 12;
                sl2.OID_Fee__c = 11;
                sl2.Approval_Date__c = system.today();
                sl2.ECOA_Code__c = '1';
                sl2.Site_UUID__c = '11';
                sl2.FNI__c = '12';
                sl2.Member_Number__c = '0000269355';
                sl2.Status__c = 'New';
                sl2.Bank_Name__c = 'Test Bank';
                sl2.ABA_Bank_Name__c = 'Test Bank';
                sl2.Additional_Amount__c = 100.00;
                sl2.ACH__c = 'True';
                slInsertlist.add(sl2);
                Solar_Loans__c sl3 = new Solar_Loans__c();
                sl3.Site_UUID__c= 'cr';
            	slInsertlist.add(sl3);
                 insert slInsertlist;
            }catch(Exception error){
                System.assert(error.getMessage().contains('FIELD_CUSTOM_VALIDATION_EXCEPTION'));    
            }
            try{
               Solar_Loans__c sl3 = new Solar_Loans__c();
                sl3.Joint_First_Name__c ='Tom Solar ';
                sl3.Joint_Last_Name__c = 'Jerry Solar ';
                sl3.Joint_DOB__c = System.today();
                sl3.Joint_SSN__c =  '1715';
                sl3.Joint_FICO_Score__c = 12.00;
                sl3.Joint_City__c = 'city ';
                sl3.Joint_State__c = 'PA ';
                sl3.Joint_Zip_Code__c =  '12345';
                sl3.Primary_First_Name__c ='Tom';
                sl3.Primary_Last_Name__c = 'Jerry';
                sl3.Primary_DOB__c = System.today();
                sl3.Primary_SSN__c =  '1715';
                sl3.Primary_Address_1__c = 'Add';
                sl3.Primary_FICO_Score__c = 12.00;
                sl3.Primary_City__c = 'city';
                sl3.Primary_State__c = 'PA';
                sl3.Primary_Zip_Code__c =  '12345';
                sl3.Legal_Description__c = 'test';
                sl3.Product__c = 'product';
                sl3.Module__c = 'module';
                sl3.Installer_Number__c = '12';
                sl3.Inverter__c = 'inverter Test Bank Test Bank Test Bank Test Bank Test Bank Test Bank Test Bank ';
                sl3.System_Size_kW__c = 12.00;
                sl3.Battery__c = 'barary';
                sl3.Installer__c = 'intealer';
                sl3.Application_Date__c = system.today();
                sl3.Mortgage_Balance__c = 1299.00;
                sl3.Final_Payment_Amount__c = 111.00;
                sl3.Go_To_Payment__c = 1252.00;
                sl3.Membership_Fee__c = 126.00;
                sl3.Net_Funding_Amount__c = 1213.00;
                sl3.Loan_Amount__c = 1211.00;
                sl3.Loan_Pmt_Amount__c = 1245.00;
                sl3.Credit_Exception__c = 'cr';
                sl3.ITC_Rate__c = 2.00;
                sl3.ITC_Amount__c = 1245.88;
                sl3.Term_months__c = 12;
                sl3.OID_Fee__c = 11;
                sl3.Approval_Date__c = system.today();
                sl3.ECOA_Code__c = '1';
                sl3.Site_UUID__c = '11';
                sl3.FNI__c = '12';
                sl3.Member_Number__c = '0000269355';
                sl3.Status__c = 'New';
                sl3.Bank_Name__c = 'Test Bank';
                sl3.ABA_Bank_Name__c = 'Test Bank';
                sl3.Additional_Amount__c = 100.00;
                sl3.ACH__c = 'True';
                insert sl3;
                
            }catch(Exception error){
                System.assert(error.getMessage().contains('FIELD_CUSTOM_VALIDATION_EXCEPTION'));  
            }
            try{
                Solar_Loans__c sl4 = new Solar_Loans__c();
                sl4.Joint_First_Name__c ='Tom Solar ';
                sl4.Joint_Last_Name__c = 'Jerry Solar ';
                sl4.Joint_DOB__c = System.today();
                sl4.Joint_SSN__c =  '1715';
                sl4.Joint_FICO_Score__c = 12.00;
                sl4.Joint_City__c = 'city ';
                sl4.Joint_State__c = 'PA ';
                sl4.Joint_Zip_Code__c =  '12345';
                sl4.Primary_First_Name__c ='Tom';
                sl4.Primary_Last_Name__c = 'Jerry';
                sl4.Primary_DOB__c = System.today();
                sl4.Primary_SSN__c =  '1715';
                sl4.Primary_Address_1__c = 'Add';
                sl4.Primary_FICO_Score__c = 12.00;
                sl4.Primary_City__c = 'city';
                sl4.Primary_State__c = 'PA';
                sl4.Primary_Zip_Code__c =  '12345';
                sl4.Legal_Description__c = 'test';
                sl4.Product__c = 'product';
                sl4.Module__c = 'module';
                sl4.Installer_Number__c = '12';
                sl4.Inverter__c = 'inverter';
                sl4.System_Size_kW__c = 12.00;
                sl4.Battery__c = 'barary';
                sl4.Installer__c = 'intealer';
                sl4.Application_Date__c = system.today();
                sl4.Mortgage_Balance__c = 1299.00;
                sl4.Final_Payment_Amount__c = 111.00;
                sl4.Go_To_Payment__c = 1252.00;
                sl4.Membership_Fee__c = 126.00;
                sl4.Net_Funding_Amount__c = 1213.00;
                sl4.Loan_Amount__c = 1211.00;
                sl4.Loan_Pmt_Amount__c = 1245.00;
                sl4.Credit_Exception__c = 'cr';
                sl4.ITC_Rate__c = 2.00;
                sl4.ITC_Amount__c = 1245.88;
                sl4.Term_months__c = 12;
                sl4.OID_Fee__c = 11;
                sl4.Approval_Date__c = system.today();
                sl4.ECOA_Code__c = '1';
                sl4.Site_UUID__c = '11';
                sl4.FNI__c = '12';
                sl4.Member_Number__c = '0000269355';
                sl4.Status__c = 'New';
                sl4.Bank_Name__c = 'Test Bank Test Bank Test Bank Test Bank Test Bank Test Bank Test Bank Test Bank ';
                sl4.ABA_Bank_Name__c = 'Test Bank';
                sl4.Additional_Amount__c = 100.00;
                sl4.ACH__c = 'True';
                insert sl4;
                
            }catch(Exception error){
               
               System.assert(error.getMessage().contains('FIELD_CUSTOM_VALIDATION_EXCEPTION'));    
            }
            try{
               Solar_Loans__c sl5 = new Solar_Loans__c();
                sl5.Joint_First_Name__c ='Tom Solar ';
                sl5.Joint_Last_Name__c = 'Jerry Solar ';
                sl5.Joint_DOB__c = System.today();
                sl5.Joint_SSN__c =  '1715';
                sl5.Joint_Address_1__c = 'qwertyuioplkjhgfdsazxcvbnmlkjhgfdsaqwerty';
                sl5.Joint_FICO_Score__c = 12.00;
                sl5.Joint_City__c = 'city ';
                sl5.Joint_State__c = 'PA ';
                sl5.Joint_Zip_Code__c =  '12345';
                sl5.Primary_First_Name__c ='Tom';
                sl5.Primary_Last_Name__c = 'Jerry';
                sl5.Primary_DOB__c = System.today();
                sl5.Primary_SSN__c =  '1715';
                sl5.Primary_Address_1__c = 'Add';
                sl5.Primary_FICO_Score__c = 12.00;
                sl5.Primary_City__c = 'city';
                sl5.Primary_State__c = 'PA';
                sl5.Primary_Zip_Code__c =  '12345';
                sl5.Legal_Description__c = 'test';
                sl5.Product__c = 'product';
                sl5.Module__c = 'module';
                sl5.Installer_Number__c = '12';
                sl5.Inverter__c = 'inverter';
                sl5.System_Size_kW__c = 12.00;
                sl5.Battery__c = 'barary';
                sl5.Installer__c = '';
                sl5.Application_Date__c = system.today();
                sl5.Mortgage_Balance__c = 1299.00;
                sl5.Final_Payment_Amount__c = 111.00;
                sl5.Go_To_Payment__c = 1252.00;
                sl5.Membership_Fee__c = 126.00;
                sl5.Net_Funding_Amount__c = 1213.00;
                sl5.Loan_Amount__c = 1211.00;
                sl5.Loan_Pmt_Amount__c = 1245.00;
                sl5.Credit_Exception__c = 'cr';
                sl5.ITC_Rate__c = 2.00;
                sl5.ITC_Amount__c = 1245.88;
                sl5.Term_months__c = 12;
                sl5.OID_Fee__c = 11;
                sl5.Approval_Date__c = system.today();
                sl5.ECOA_Code__c = '1';
                sl5.Site_UUID__c = '11';
                sl5.FNI__c = '12';
                sl5.Member_Number__c = '0000269355';
                sl5.Status__c = 'New';
                sl5.Bank_Name__c = 'Test Bank';
                sl5.ABA_Bank_Name__c = 'Test Bank';
                sl5.Additional_Amount__c = 100.00;
                sl5.ACH__c = 'True';
                insert sl5;
                
            }catch(Exception error){
                System.assert(error.getMessage().contains('FIELD_CUSTOM_VALIDATION_EXCEPTION'));  
            }
            try{
               Solar_Loans__c sl6 = new Solar_Loans__c();
                sl6.Joint_First_Name__c ='Tom Solar';                
                sl6.Joint_Last_Name__c = 'Jerry Solar ';
                sl6.mem_Joint_Employer__c = 'Tom Solar qwerty plkjhggfff jhdkjsh uytrew';
                sl6.Joint_DOB__c = System.today();
                sl6.Joint_SSN__c =  '1715';
                sl6.Joint_FICO_Score__c = 12.00;
                sl6.Joint_City__c = 'city ';
                sl6.Joint_State__c = 'PA ';
                sl6.Joint_Zip_Code__c =  '12345';
                sl6.Primary_First_Name__c ='Tom';
                sl6.Primary_Last_Name__c = 'Jerry';
                sl6.Primary_DOB__c = System.today();
                sl6.Primary_SSN__c =  '1715';
                sl6.Primary_Address_1__c = 'Add';
                sl6.Primary_FICO_Score__c = 12.00;
                sl6.Primary_City__c = 'city';
                sl6.Primary_State__c = 'PA';
                sl6.Primary_Zip_Code__c =  '12345';
                sl6.Legal_Description__c = 'test';
                sl6.Product__c = 'product';
                sl6.Module__c = 'module';
                sl6.Installer_Number__c = '12';
                sl6.Inverter__c = 'inverter';
                sl6.System_Size_kW__c = 12.00;
                sl6.Battery__c = 'barary';
                sl6.Installer__c = 'intealer';
                sl6.Application_Date__c = system.today();
                sl6.Mortgage_Balance__c = 1299.00;
                sl6.Final_Payment_Amount__c = 111.00;
                sl6.Go_To_Payment__c = 1252.00;
                sl6.Membership_Fee__c = 126.00;
                sl6.Net_Funding_Amount__c = 1213.00;
                sl6.Loan_Amount__c = 1211.00;
                sl6.Loan_Pmt_Amount__c = 1245.00;
                sl6.Credit_Exception__c = 'cr';
                sl6.ITC_Rate__c = 2.00;
                sl6.ITC_Amount__c = 1245.88;
                sl6.Term_months__c = 12;
                sl6.OID_Fee__c = 11;
                sl6.Approval_Date__c = system.today();
                sl6.ECOA_Code__c = '1';
                sl6.Site_UUID__c = '11';
                sl6.FNI__c = '12';
                sl6.Member_Number__c = '0000269355';
                sl6.Status__c = 'New';
                sl6.Bank_Name__c = 'Test Bank';
                sl6.ABA_Bank_Name__c = 'Test Bank';
                sl6.Additional_Amount__c = 100.00;
                sl6.ACH__c = 'True';
                insert sl6;
                
            }catch(Exception error){
                System.assert(error.getMessage().contains('FIELD_CUSTOM_VALIDATION_EXCEPTION'));  
            }
            try{
               Solar_Loans__c sl7 = new Solar_Loans__c();
                sl7.Joint_First_Name__c ='Tom Solar';
                sl7.Joint_Last_Name__c = 'Jerry Solar ';
				sl7.mem_Joint_Extra_Address__c ='Tom Solar qwerty plkjhggfff jhdkjshdkjshkjd shdkjahk';
                sl7.Joint_DOB__c = System.today();
                sl7.Joint_SSN__c =  '1715';
                sl7.Joint_FICO_Score__c = 12.00;
                sl7.Joint_City__c = 'city ';
                sl7.Joint_State__c = 'PA ';
                sl7.Joint_Zip_Code__c =  '12345';
                sl7.Primary_First_Name__c ='Tom';
                sl7.Primary_Last_Name__c = 'Jerry';
                sl7.Primary_DOB__c = System.today();
                sl7.Primary_SSN__c =  '1715';
                sl7.Primary_Address_1__c = 'Add';
                sl7.Primary_FICO_Score__c = 12.00;
                sl7.Primary_City__c = 'city';
                sl7.Primary_State__c = 'PA';
                sl7.Primary_Zip_Code__c =  '12345';
                sl7.Legal_Description__c = 'test';
                sl7.Product__c = 'product';
                sl7.Module__c = 'module';
                sl7.Installer_Number__c = '12';
                sl7.Inverter__c = 'inverter';
                sl7.System_Size_kW__c = 12.00;
                sl7.Battery__c = 'barary';
                sl7.Installer__c = 'intealer';
                sl7.Application_Date__c = system.today();
                sl7.Mortgage_Balance__c = 1299.00;
                sl7.Final_Payment_Amount__c = 111.00;
                sl7.Go_To_Payment__c = 1252.00;
                sl7.Membership_Fee__c = 126.00;
                sl7.Net_Funding_Amount__c = 1213.00;
                sl7.Loan_Amount__c = 1211.00;
                sl7.Loan_Pmt_Amount__c = 1245.00;
                sl7.Credit_Exception__c = 'cr';
                sl7.ITC_Rate__c = 2.00;
                sl7.ITC_Amount__c = 1245.88;
                sl7.Term_months__c = 12;
                sl7.OID_Fee__c = 11;
                sl7.Approval_Date__c = system.today();
                sl7.ECOA_Code__c = '1';
                sl7.Site_UUID__c = '11';
                sl7.FNI__c = '12';
                sl7.Member_Number__c = '0000269355';
                sl7.Status__c = 'New';
                sl7.Bank_Name__c = 'Test Bank';
                sl7.ABA_Bank_Name__c = 'Test Bank';
                sl7.Additional_Amount__c = 100.00;
                sl7.ACH__c = 'True';
                insert sl7;
                
            }catch(Exception error){
                System.assert(error.getMessage().contains('FIELD_CUSTOM_VALIDATION_EXCEPTION'));  
            }
        }
    }
    static testMethod void testMethod1(){
     
        User u = [SELECT Id,Email,username FROM User WHERE IsActive = true and Profile.Name = 'CFCU Admin' limit 1];
                
        String userName = UserInfo.getUserName();
		User activeUser = [Select Email From User where Username = : userName limit 1];
		String userEmail = activeUser.Email;
        test.startTest();
            System.runAs(u){
                Solar_Loans__c s = [select id,Status__c,DocuSignId__c from Solar_Loans__c where Status__c = 'New'];
                s.Status__c = 'ACH Pending';    
                update s; 
            }
        test.stopTest();
    }
    
    static testMethod void testMethod10(){
        
			test.startTest();
                Solar_Loans__c s = [select id,Status__c,DocuSignId__c from Solar_Loans__c where Status__c = 'New' ];
                s.Status__c = 'Declined';            
                update s;
       		test.stopTest();
        
    }
    static testMethod void testMethod11(){
    		test.startTest();
                Solar_Loans__c s = [select id,Status__c,DocuSignId__c from Solar_Loans__c where Status__c = 'New' ];
                s.Status__c = 'Expired';            
                update s; 
        	test.stopTest();
    }
    
    static testMethod void testMethod12(){
        Test.startTest();
            List<Solar_Loans__c> MemberTest = new list<Solar_Loans__c>();
            
            Solar_Loans__c s = new Solar_Loans__c();
            s.Member_Number__c = '123456';
            s.Site_UUID__c = '344';
            
            
            MemberTest.add(s);
            
            if(MemberTest.size()>0){
                insert MemberTest;
            }
            
            s.Member_Number__c = '123456';
            update MemberTest;
           
        test.stopTest();
    }
    
    static testMethod void testMethod13(){
         Test.startTest();
        	Solar_Loans__c s1 = [select id,Status__c,DocuSignId__c,EftLocator__c from Solar_Loans__c where Status__c = 'New' ];
			s1.Status__c = 'Completed';
        	s1.EftLocator__c = null;
            update s1;
        Test.stopTest();
    } 
    static testMethod void testMethod14(){
        Test.startTest();
            Solar_Loans__c s = [select Id,DocuSignId__c,Member_Number__c,Member_Name__c from Solar_Loans__c];
            s.Member_Number__c = '123456';
            s.Member_Name__c = null;
            update s;
        Test.stopTest();
      
    } 
    static testMethod void testMethod15(){
        Test.startTest();
            Solar_Loans__c s = [select Id,DocuSignId__c,Status__c,Routing_Number__c from Solar_Loans__c where Status__c = 'New' and Routing_Number__c = null ];
            s.Status__c = 'Completed';
            s.Routing_Number__c = '1234566';
            update s;
		 Test.stopTest();
    }
    /* static testMethod void testMethod16(){
        Solar_Loans__c s = [select Id,DocuSignId__c,SignatureCardURL__c from Solar_Loans__c where SignatureCardURL__c = null ];
        s.SignatureCardURL__c = 'hkdsfsdfjsdhfkjsd';
        update s;

    } */
    
    static testMethod void testMethod3(){
    	 Test.startTest();
            User u = [SELECT Id,Email,username FROM User WHERE IsActive = true and Profile.Name = 'CFCU Admin' limit 1];
            
            System.runAs(u){
                
                Solar_Loans__c s = [select id,Status__c,DocuSignId__c from Solar_Loans__c where Status__c = 'New'];
                s.Status__c = 'Approved';
                update s;
                
                Solar_Loans__c s1 = [select id,Status__c,DocuSignId__c from Solar_Loans__c where Status__c = 'Approved'];
                s1.Status__c = 'Completed';
                update s1;
            }
        
        Test.stopTest();
    }
    
    static testMethod void testMethod4(){
     Test.startTest();
            User u = [SELECT Id,Email,username FROM User WHERE IsActive = true and Profile.Name = 'CFCU Admin' limit 1];
            
            System.runAs(u){
                
                Solar_Loans__c s = [select id,Status__c,EftLocator__c,DocuSignId__c from Solar_Loans__c where Status__c = 'New'];
                s.Status__c = 'Approved';
                s.EftLocator__c = '123';
                s.Bank_Name__c = 'Test Bank';
                s.Additional_Amount__c = 100.00;
                update s;
                
                Solar_Loans__c s1 = [select id,Status__c,DocuSignId__c from Solar_Loans__c where Status__c = 'Approved'];
                s1.Status__c = 'Completed';
                update s1;
            }
       Test.stopTest();
    }
}