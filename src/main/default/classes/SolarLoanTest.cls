@isTest
private class SolarLoanTest{
  @testSetup
  static void setupTestData(){
   
     //---------------------------------------- Creating Account Details record-----------------------------------//
          
     SolarLoan_To_Episys_API_Details__c api = new SolarLoan_To_Episys_API_Details__c();
     api.URL__c = 'https://symxapi.chevronfcu.org/devclient';
     api.Name = 'ProductionURL';
     insert api;
      
      Solar_UCC_User_Details__c suud = new Solar_UCC_User_Details__c();
      suud.ClientId__c = 'ChevronFederalCreditUnionAPIClientAccount';
      suud.Client_Secret__c = 'E184441C-E05B-4301-9C85-3AAE914AE363';
      suud.Username__c = 'ChevronFederalCreditUnionAPIUserAccount';
      suud.password__c = '94B1001D-F28E-4C0B-87E5-ECCBFD9FDA8D';
      suud.URL__c = 'demo.docusign.net';
      suud.Name = 'Production';
      
      insert suud;
      
      SolarLoan_Docusign_Emails__c suud1 = new SolarLoan_Docusign_Emails__c();
      suud1.Name = 'Email For Testing';
      
      insert suud1;
      
      DocuSign_User_Details__c dt1 = new DocuSign_User_Details__c();
      
      dt1.TemplateId__c = 'ad01d585-ad0a-4e68-b537-7e75293f0ef8';
      dt1.Name = 'Chevron';      
      
      insert dt1;
      
      DocuSign_User_Details__c dt2 = new DocuSign_User_Details__c();
      
      dt2.TemplateId__c = 'dc16d8f8-571c-497e-bbf5-42d8b25d4ee1';
      dt2.Name = 'Spectrum';
      
      insert dt2; 
      
     Solar_Loan_Product_Types__c slpt = new Solar_Loan_Product_Types__c();
     slpt.Name = 'Solar';
     slpt.Description__c = 'SECURED SOLAR';
     insert slpt; 
   	     
     List<Account_Details__c> account_details_Obj = new List<Account_Details__c>{
                new Account_Details__c(Name = '0000147163', Balance__c = 0.00, Combined_Account_ID__c = '0000147163S0100P0100', 
                Onboarded__c = true,RecType__c = 'LOAN', TypeTranslate__c = '75-SECURED SOLAR')};
    
     insert account_details_Obj;
    
    
     List<Account_Details__c> account_details_Obj1 = new List<Account_Details__c>{
                new Account_Details__c(Name = '0000123456', Balance__c = 0.00, Combined_Account_ID__c = '0000147163S0100P0100', 
                Onboarded__c = true, RecType__c = 'ACCT', TypeTranslate__c = '1-PRIMARY SHARE')};
    
     insert account_details_Obj1;
    
    
    //---------------------------------------- Creating Member records---------------------------------------------//
    
    
     Account account_Obj = new Account(LastName = 'BANDATest', FirstName = 'MARIATest', Type = 'null', PersonHasOptedOutOfEmail = false, 
              NA_Eligibility__c = false, NA_LEAV_Complete__c = true, NA_LECF_Complete__c = true, NA_LECP_Complete__c = true, NA_LEEM_Complete__c = true, NA_LEHS_Complete__c = true, 
              NA_LEMD_Complete__c = false, NA_LEMP_Complete__c = false, NA_LEMQ_Complete__c = true, NA_LEOL_Complete__c = true, NA_LEOM_Complete__c = true, NA_LEPT_Complete__c = true, 
              NA_LESB_Complete__c = false, NA_LESF_Complete__c = true, NA_LEWS_Complete__c = true, NA_Opt_Out__c = false);
     Insert account_Obj; 
    
     
     
     //---------------------------------------- Creating Solar Loan record---------------------------------------------//
     
     List<Solar_Loans__c> SolarLoan_Obj = new List<Solar_Loans__c>();
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
     sl.Product_Loan_Type__c = 'Solar'; 
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
     sl.Routing_Number__c = '123456788';
     sl.Bank_Account_Number__c = '121314234';
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
     sl.County__c = 'TM';
     
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
     sl.Occupation__c = 'Occ&';
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
     sl.Joint_Occupation__c = 'Service&';
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
     sl.Map__c = 'Map';
     sl.Book__c = 'Book';
     sl.Block__c = 'Block';
     sl.Tract__c = 'Tract';
     sl.APN__c = 'APN';
     sl.Page__c = 'Page';
     sl.Subdivision__c = 'S';
     sl.Section__c = 'S1';
     sl.Lot__c = 'Lot';
     sl.mem_Primary_Street__c = 'TTT';
     sl.mem_Joint_Street__c = 'tttttttttttttttttttttttttttttttttttttttttttttt';
      
     sl.Joint_Middle_Initial__c = 'M';
     sl.mem_Joint_City__c = 'City';
     sl.mem_Joint_State__c = 'state'; 
     sl.mem_Joint_Zip_Code__c = '55555';
     sl.mem_Joint_Employer__c = 'rrr';
      
     SolarLoan_Obj.add(sl);
      
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
     sl1.Product_Loan_Type__c = 'Solar';
      
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
     sl1.Bank_Name__c = 'test1 & bank';
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
     //sl1.Member_Number__c = '0000147163';
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
     sl1.Occupation__c = 'Occ&';
     sl1.mem_Primary_State__c = 'State';
     sl1.mem_Primary_Zip_Code__c = '12356';
     sl1.Primary_Work_Phone__c = '123-121-1212';
     sl1.ACH__c = 'False';
     sl1.mem_Joint_SSN__c = '127081988';
     sl1.County__c = 'TM';
     sl1.Joint_ID_Expiration_Date__c = system.today() - 100;
     sl1.Joint_ID_Issue_Date__c = system.today() - 10;
 
     sl1.mem_Mailing_Extra_Address__c = 'MailExtra';
     sl1.mem_Mailing_State__c = 'MailState';
     sl1.mem_Primary_Foreign_Gov_t_Position__c = 'No';
     sl1.mem_Primary_A_F_Foreign_Gov_t_Position__c = 'No';
     sl1.mem_Joint_Foreign_Gov_t_Position__c = 'No';
     sl1.mem_Joint_A_F_Foreign_Gov_t_Position__c = 'No';
     sl1.Membership_confirmation__c = true;
    
      
     sl1.Map__c = 'Map';
     sl1.Book__c = 'Book';
     sl1.Block__c = 'Block';
     sl1.Tract__c = 'Tract';
     sl1.APN__c = 'APN';
     sl1.Page__c = 'Page';
     sl1.Subdivision__c = 'S';
     sl1.Section__c = 'S1';
     sl1.Lot__c = 'Lot';
     sl1.mem_Primary_Street__c = 'TTT';
     sl1.mem_Joint_Street__c = 'tttttttttttttttttttttttttttttttttttttttttttttt';
     
     sl1.Joint_Middle_Initial__c = 'M';
     sl1.mem_Joint_City__c = 'City';
     sl1.mem_Joint_State__c = 'state'; 
     sl1.mem_Joint_Zip_Code__c = '55555';
     sl1.mem_Joint_Employer__c = 'rrr'; 
      
     SolarLoan_Obj.add(sl1); 
      
     Solar_Loans__c sl2 = new Solar_Loans__c();
     sl2.Joint_First_Name__c ='Tom';
     sl2.Joint_Last_Name__c = 'Jerry';
     sl2.Joint_DOB__c = System.today();
     sl2.Joint_SSN__c =  '123';
     sl2.Joint_FICO_Score__c = 12.00;
     sl2.Joint_City__c = 'city';
     sl2.Joint_State__c = 'PA';
     sl2.Joint_Zip_Code__c =  '12345';
     sl2.Joint_Address_1__c = 'street';
     sl2.Joint_Address_2__c = 'street2';
     sl2.Product_Loan_Type__c = 'Solar'; 
     sl2.Primary_First_Name__c ='Tom';
     sl2.Primary_Last_Name__c = 'Jerry';
     sl2.Primary_DOB__c = System.today();
     sl2.Primary_SSN__c =  '123456789';
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
     sl2.Bank_Name__c = 'test & bank2';
     sl2.Membership_Fee__c = 126.00;
     sl2.Net_Funding_Amount__c = 1213.00;
     sl2.Loan_Amount__c = 1211.00;
     sl2.Loan_Pmt_Amount__c = 1245.00;
     sl2.Credit_Exception__c = 'cr';
     sl2.ITC_Rate__c = 2.00;
     sl2.ITC_Amount__c = 1245.88;
     sl2.Term_months__c = 12;
     sl2.OID_Fee__c = 11;
     sl2.Approval_Date__c = system.today();
     sl2.ECOA_Code__c = '1';
     sl2.Site_UUID__c = '1167';
     sl2.FNI__c = '12';
     //sl2.Member_Number__c = '';
     sl2.Status__c = 'Declined'; 
     sl2.Additional_Amount__c = 11.00; 
     sl2.Primary_Cell_Phone__c = '567-678-7898';
     sl2.Primary_Home_Phone__c = '567-678-7898';
     sl2.Primary_Work_Phone__c = '567-678-7898';
     sl2.Primary_Email__c = 'test@test.com';
     sl2.mem_ID_Expiration_Date__c = system.today() + 100;
     sl2.mem_Primary_SSN__c = '123456789';
     
     sl2.mem_Primary_DOB__c = system.today() - 50000;
     sl2.mem_Primary_City__c = 'City';
     sl2.Employer__c = 'T&T';
     sl2.mem_Primary_Extra_Address__c = 'Extra';
     sl2.mem_Primary_First_Name__c = 'First';
     sl2.mem_ID_Issue_Date__c = system.today() - 500;
     sl2.mem_ID_Number__c = 'RRR1';
     sl2.mem_ID_Type__c = 'Passport'; 
     sl2.mem_Primary_Last_Name__c = 'LAst';
     sl2.Primary_Middle_Initial__c = 'M';
     sl2.mem_Maiden_Name__c = 'M';
     sl2.Occupation__c = 'Occ&';
     sl2.mem_Primary_State__c = 'State';
     sl2.mem_Primary_Zip_Code__c = '12356';
     sl2.Primary_Work_Phone__c = '123-121-1212';
      
     sl2.mem_Joint_SSN__c = '123456789';
     sl2.mem_Joint_DOB__c = system.today() - 50000;
     sl2.mem_Joint_City__c = 'City';
     sl2.mem_Joint_City__c = 'test@test.com';
     sl2.mem_Joint_Employer__c = 'A & B';
     sl2.mem_Joint_Extra_Address__c = 'Extra';
     sl2.mem_Joint_First_Name__c = 'JointFirst';
     sl2.Joint_Home_Phone__c = '123-345-6787';
     sl2.Joint_ID_Expiration_Date__c = system.today() + 1000;
     sl2.Joint_ID_Issue_Date__c = system.today() - 1000;
     sl2.Joint_ID_Number__c = 'TTT';
     sl2.Joint_ID_Type__c = 'Passport';
     sl2.mem_Joint_Last_Name__c = 'JointLast';
     sl2.Joint_Middle_Initial__c = 'M';
     sl2.Joint_Cell_Phone__c = '123-456-7653';
     sl2.Joint_Maiden_Name__c = 'maiden';
     sl2.Joint_Occupation__c = 'Service&';
     sl2.mem_Joint_State__c = 'CA';
     sl2.mem_Joint_Street__c = 'Street';
     sl2.Joint_Work_Phone__c = '123-445-4432';
     sl2.mem_Joint_Zip_Code__c = '12345'; 
     
     sl2.mem_Mailing_Extra_Address__c = 'MailExtra';
     sl2.mem_Mailing_State__c = 'MailState';
     sl2.Primary_Middle_Initial__c = 'E';
     sl2.mem_Mailing_City__c = 'City';
     sl2.Mailing_Street__c = 'Street';
     sl2.Mailing_Zip__c = '12345';
     
     sl2.mem_Primary_Foreign_Gov_t_Position__c = 'Yes';
     sl2.mem_Primary_A_F_Foreign_Gov_t_Position__c = 'Yes';
     sl2.mem_Joint_Foreign_Gov_t_Position__c = 'Yes';
     sl2.mem_Joint_A_F_Foreign_Gov_t_Position__c = 'Yes'; 
     sl2.County__c = 'TM'; 
     
     sl2.Map__c = 'Map';
     sl2.Book__c = 'Book';
     sl2.Block__c = 'Block';
     sl2.Tract__c = 'Tract';
     sl2.APN__c = 'APN';
     sl2.Page__c = 'Page';
     sl2.Subdivision__c = 'S';
     sl2.Section__c = 'S1';
     sl2.Lot__c = 'Lot';
     sl2.mem_Primary_Street__c = 'TTT';
     sl2.mem_Joint_Street__c = 'tttttttttttttttttttttttttttttttttttttttttttttt';
     
     sl2.Joint_Middle_Initial__c = 'M';
     sl2.mem_Joint_City__c = 'City';
     sl2.mem_Joint_State__c = 'state'; 
     sl2.mem_Joint_Zip_Code__c = '55555';
     sl2.mem_Joint_Employer__c = 'rrr';
   
     SolarLoan_Obj.add(sl2);   
      
     Solar_Loans__c sl3 = new Solar_Loans__c();
     sl3.Primary_First_Name__c ='Tomzdgh';
     sl3.Primary_Last_Name__c = 'Jersffgry';
     sl3.Primary_DOB__c = System.today();
     sl3.Primary_SSN__c =  '123456789';
     sl3.Primary_Address_1__c = 'Add';
     sl3.Primary_FICO_Score__c = 12.00;
     sl3.Primary_City__c = 'city';
     sl3.Primary_State__c = 'PA';
     sl3.Primary_Zip_Code__c =  '12345';
     sl3.Legal_Description__c = 'test';
     sl3.Product__c = 'product';
     sl3.Module__c = 'module';
     sl3.Installer_Number__c = '12';
     sl3.Inverter__c = 'inverter';
     sl3.System_Size_kW__c = 12.00;
     sl3.Battery__c = 'barary';
     sl3.Installer__c = 'intealer';
     sl3.Application_Date__c = system.today();
     sl3.Mortgage_Balance__c = 1299.00;
     sl3.Final_Payment_Amount__c = 111.00;
     sl3.Go_To_Payment__c = 1252.00;
     sl3.Bank_Name__c = 'test bank2';
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
     sl3.Site_UUID__c = '11677';
     sl3.FNI__c = '12';
     sl3.Member_Number__c = '0000452235';
     sl3.Status__c = 'UCC Pending'; 
     sl3.Additional_Amount__c = 11.00; 
     sl3.Primary_Cell_Phone__c = '567-678-8898';
     sl3.Primary_Home_Phone__c = '567-678-4898';
     sl3.Primary_Work_Phone__c = '567-678-3898';
     sl3.Primary_Email__c = 'test1@test.com';
     sl3.mem_ID_Expiration_Date__c = system.today() + 100;
     sl3.mem_Primary_SSN__c = '123488789';
     sl3.Product_Loan_Type__c = 'Solar';
      
     sl3.mem_Primary_DOB__c = system.today() - 50000;
     sl3.mem_Primary_City__c = 'City';
     sl3.Employer__c = 'T&T';
     sl3.mem_Primary_Extra_Address__c = 'Extra';
     sl3.mem_Primary_First_Name__c = 'First';
     sl3.mem_ID_Issue_Date__c = system.today() - 500;
     sl3.mem_ID_Number__c = 'RRR1';
     sl3.mem_ID_Type__c = 'Passport'; 
     sl3.mem_Primary_Last_Name__c = 'LAst';
     sl3.Primary_Middle_Initial__c = 'M';
     sl3.mem_Maiden_Name__c = 'M';
     sl3.Occupation__c = 'Occ&';
     sl3.mem_Primary_State__c = 'State';
     sl3.mem_Primary_Zip_Code__c = '12356';
     sl3.Primary_Work_Phone__c = '123-121-1212';
      
     sl3.mem_Joint_SSN__c = '573636333';
     sl3.mem_Joint_DOB__c = system.today() - 50000;
     sl3.mem_Joint_City__c = 'City';
     sl3.mem_Joint_Employer__c = 'A & B';
     sl3.mem_Joint_Extra_Address__c = 'Extra';
     sl3.mem_Joint_First_Name__c = 'JointFirst';
     sl3.Joint_Home_Phone__c = '123-345-6787';
     sl3.Joint_ID_Expiration_Date__c = system.today() + 1000;
     sl3.Joint_ID_Issue_Date__c = system.today() - 1000;
     sl3.Joint_ID_Number__c = 'TTT';
     sl3.Joint_ID_Type__c = 'Passport';
     sl3.mem_Joint_Last_Name__c = 'JointLast';
     sl3.Joint_Middle_Initial__c = 'M';
     sl3.Joint_Cell_Phone__c = '123-456-7653';
     sl3.Joint_Maiden_Name__c = 'maiden';
     sl3.Joint_Occupation__c = 'Service&';
     sl3.mem_Joint_State__c = 'CA';
     sl3.mem_Joint_Street__c = 'Street';
     sl3.Joint_Work_Phone__c = '123-445-4432';
     sl3.mem_Joint_Zip_Code__c = '12345'; 
     sl3.UCC_Id__c = '3245-3422-25sr-24w2';
     
     SolarLoan_Obj.add(sl3);
      
     Solar_Loans__c sl4 = new Solar_Loans__c();
     sl4.Primary_First_Name__c ='Tomzdgh';
     sl4.Primary_Last_Name__c = 'Jersffgry';
     sl4.Primary_DOB__c = System.today();
     sl4.Primary_SSN__c =  '123456789';
     sl4.Primary_Address_1__c = 'P.O. Box';
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
     sl4.Bank_Name__c = 'test bank10';
     sl4.Routing_Number__c = '122456788';
     sl4.Bank_Account_Number__c = '121314234'; 
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
     sl4.Site_UUID__c = 'abcd';
     sl4.FNI__c = '12';
     sl4.Member_Number__c = '0000452235';
     sl4.Status__c = 'UCC Pending'; 
     sl4.ACH__c = 'True'; 
     sl4.Additional_Amount__c = 11.00; 
     sl4.Primary_Cell_Phone__c = '567-678-8898';
     sl4.Primary_Home_Phone__c = '567-678-4898';
     sl4.Primary_Work_Phone__c = '567-678-3898';
     sl4.Primary_Email__c = 'test1@test.com';
     sl4.mem_ID_Expiration_Date__c = system.today() + 100;
     sl4.mem_Primary_SSN__c = '123488789';
     sl4.Product_Loan_Type__c = 'Solar';
      
     sl4.mem_Primary_DOB__c = system.today() ;
     sl4.Joint_DOB__c = System.today(); 
     sl4.mem_Primary_City__c = 'City';
     sl4.mem_Primary_Street__c = 'P.O. Box'; 
     sl4.Employer__c = 'T&T';
     sl4.mem_Primary_Extra_Address__c = 'Extra';
     sl4.mem_Primary_First_Name__c = 'First';
     sl4.mem_ID_Issue_Date__c = system.today() - 500;
     sl4.mem_ID_Number__c = 'RRR1';
     sl4.mem_ID_Type__c = 'Passport'; 
     sl4.mem_Primary_Last_Name__c = 'LAst';
     sl4.Primary_Middle_Initial__c = 'M';
     sl4.mem_Maiden_Name__c = 'M';
     sl4.Occupation__c = 'Occ&';
     sl4.mem_Primary_State__c = 'State';
     sl4.mem_Primary_Zip_Code__c = '12356';
     sl4.Primary_Work_Phone__c = '123-121-1212';
     
     sl4.mem_Joint_SSN__c = '573636331';
     sl4.mem_Joint_DOB__c = system.today() ;
     sl4.mem_Joint_City__c = 'City';
     sl4.mem_Joint_Employer__c = 'A & B';
     sl4.mem_Joint_Extra_Address__c = 'Extra';
     sl4.mem_Joint_First_Name__c = 'JointFirst';
     sl4.Joint_Home_Phone__c = '123-345-6787';
     sl4.Joint_ID_Expiration_Date__c = system.today() + 1000;
     sl4.Joint_ID_Issue_Date__c = system.today() - 1000;
     sl4.Joint_ID_Number__c = '.';
     sl4.Joint_ID_Type__c = 'Pasport';
     sl4.mem_Joint_Last_Name__c = 'JointLasts';
     sl4.Joint_Middle_Initial__c = 'M';
     sl4.Joint_Cell_Phone__c = '123-456-7654';
     sl4.Joint_Maiden_Name__c = 'maiden';
     sl4.Joint_Occupation__c = 'Service&';
     sl4.mem_Joint_State__c = 'CA';
     sl4.mem_Joint_Street__c = 'Street';
     sl4.Joint_Work_Phone__c = '123-445-4432';
     sl4.mem_Joint_Zip_Code__c = '12345'; 
     sl4.UCC_Id__c = '3245-3422-25sr-24w2';
     sl4.Brand__c = '';
    
     SolarLoan_Obj.add(sl4);
      
      Solar_Loans__c sl5 = new Solar_Loans__c();
      sl5.ACH__c = 'False';
      sl5.Site_UUID__c = 'b';
      sl5.Status__c = 'New';
      sl5.Continue__c = false;
      sl5.Loan_Id__c = '';
      sl5.Error_Loan_Locator__c = 'abcd';
      sl5.mem_Joint_SSN__c ='573636332';
      sl5.Primary_Address_1__c = 'P.O. Box';
      sl5.Primary_Cell_Phone__c = null;
      sl5.Primary_Home_Phone__c = null;
      sl5.Primary_Work_Phone__c = null;
      sl5.Joint_DOB__c = system.today();
      sl5.mem_Joint_DOB__c = system.today();
      

      
      SolarLoan_Obj.add(sl5);
  
       
      
      
     insert SolarLoan_Obj;
      
     //---------------------------------------- Creating Solar Loan Document record-----------------------------------//
     
     List<SolarLoan_Document__c> SolarLoanDocList = new List<SolarLoan_Document__c>{
         new SolarLoan_Document__c(Name = 'Member Application_Completed', Member_Number__c = '0000214414',Solar_Loans__c = SolarLoan_Obj[0].id),
         new SolarLoan_Document__c(Document_Name__c ='Membership Application', Name = 'Membership Application', Member_Number__c = '0000147163',Solar_Loans__c = SolarLoan_Obj[0].id)};      
     insert SolarLoanDocList;
   
      test.startTest();
     
     //---------------------------------------- Creating Content Version Record for Attachment---------------------------------------------//
     
     ContentVersion objAt = new ContentVersion(Title = 'Member Application_Completed',PathOnClient = 'TestDocument.pdf',VersionData = Blob.valueOf('Test Content'), IsMajorVersion = true);
     Insert objAt;
      
     
     List<ContentDocument> cdList = [SELECT Id, Title, LatestPublishedVersionId FROM ContentDocument];
    
     //--------------------- Creating Content Document Link with Parent as "Solar Loan" record-----------------------//
     
     List<ContentDocumentLink> ListCDL = new List<ContentDocumentLink>{
        new ContentDocumentLink (ContentDocumentId = cdList[0].id, LinkedEntityId = SolarLoan_Obj[0].Id)};
     insert ListCDL;
      
     Attachment attach=new Attachment();   	
     attach.Name='Unit Test Attachment';
     Blob bodyBlob=Blob.valueOf('Unit Test Attachment Body');
     attach.body=bodyBlob;
     attach.parentId=SolarLoan_Obj[0].Id;
     insert attach;
      
     test.stopTest();
  }
  static testMethod void test_Solarloancontroller(){
      List<Solar_Loans__c> listSolarLoan  =  [SELECT Id from Solar_Loans__c limit 1];
      List<Solar_Loans__c> listSolarLoan2  =  [SELECT Id,Bank_Name__c from Solar_Loans__c where Bank_Name__c = 'test & bank2' limit 1];
      Set<ID> slids = new Set<ID>();
      slids.add(listSolarLoan2[0].id);
      test.startTest();
      SolarLoanController.waitingForResponse(listSolarLoan[0].id, 'New');
      SolarLoanController.getMemberData(listSolarLoan[0].id, 'Stage 1');
      SolarLoanController.getMemberData(listSolarLoan[0].id, 'Stage 2');
      SolarLoanController.saveRoutingInfo(listSolarLoan[0].id,'122105155','Test Bank Name');
      SolarLoanController.routingInfo('122105155');
      SolarLoanToCreateLoan.getMemberNumber(slids);
      
      test.stopTest();
  }
   
   static testMethod void test_Solarloancontroller2(){
      List<Solar_Loans__c> listSolarLoan  =  [SELECT Id from Solar_Loans__c limit 1];
      Set<Id> SLId = new Set<Id>();
      SLId.add(listSolarLoan[0].id); 
       
      SolarLoanToFileUCC.getJurisdiction(SLId);
      SolarLoanController.getMemberData(listSolarLoan[0].id, 'Stage 3');
   }
    
    static testMethod void test_Solarloancontroller3(){
      List<Solar_Loans__c> listSolarLoan  =  [SELECT Id,mem_Primary_Foreign_Gov_t_Position__c from Solar_Loans__c where mem_Primary_Foreign_Gov_t_Position__c = 'Yes' limit 1];
      SolarLoanTocreateLoan.MembershipExist = 'false';
      SolarLoanTocreateLoan.HasMembershipStatus  = 'OK';
      SolarLoanController.getMemberData(listSolarLoan[0].id, 'Stage 4');
  	}
        
  static testMethod void test_Solarloancontroller4(){
      List<Solar_Loans__c> listSolarLoan  =  [SELECT Id from Solar_Loans__c where mem_Primary_Foreign_Gov_t_Position__c = 'No' limit 1];
      SolarLoanTocreateLoan.MembershipExist = 'true';
      SolarLoanTocreateLoan.HasMembershipStatus  = 'OK';
      SolarLoanTocreateLoan.responseBody1 = '{"HasPrimaryAccount":"true","TotalPrimaryAccount" : "1"}';
      SolarLoanController.getMemberData(listSolarLoan[0].id, 'Stage 4');
  }
    
  static testMethod void test_Solarloancontroller5(){
      List<Solar_Loans__c> listSolarLoan  =  [SELECT Id,Bank_Name__c from Solar_Loans__c where Bank_Name__c = 'test & bank' limit 1];
      SolarLoanController.getMemberData(listSolarLoan[0].id, 'Stage 2');
      SolarLoanController.getMemberData(listSolarLoan[0].id, 'Stage 5');
  }  
  
  static testMethod void test_Solarloancontroller6(){
      List<Solar_Loans__c> listSolarLoan  =  [SELECT Id,mem_Joint_SSN__c from Solar_Loans__c where mem_Joint_SSN__c = '127081988'limit 1];
     
      Test.startTest();
      SolarLoanController.getMemberData(listSolarLoan[0].id, 'Stage 4');
      SolarLoanController.getMemberData(listSolarLoan[0].id, 'Stage 7');
      Test.stopTest();
      SolarLoanController.getMemberData(listSolarLoan[0].id, 'Stage 8');
   }
    
   static testMethod void test_Solarloancontroller7(){
      List<Solar_Loans__c> listSolarLoan  =  [SELECT Id,ACH__C from Solar_Loans__c where ACH__C = 'False' limit 1];
      
      SolarLoanController.getMemberData(listSolarLoan[0].id, 'Stage 5');
   }
    
   static testMethod void test_Solarloancontroller8(){

       List<Solar_Loans__c> listSolarLoan  =  [SELECT Id,Status__c from Solar_Loans__c where Status__c = 'UCC Pending' limit 1];
       SolarLoanUCCSchedule sh1 = new SolarLoanUCCSchedule();
	   String sch = '0 0 23 * * ?'; 
       system.schedule('Test Territory Check', sch, sh1); 
       SolarLoanUCCBatch b = new SolarLoanUCCBatch();
	   Database.executeBatch(b);
   }  
    
    static testMethod void test_Solarloancontroller9(){
      List<Solar_Loans__c> listSolarLoan  =  [SELECT Id,mem_Joint_SSN__c,ACH__c from Solar_Loans__c where mem_Joint_SSN__c = '127081988'limit 1];
      
      SolarLoanController.getMemberData(listSolarLoan[0].id, 'Stage 6');    } 
    
   static testMethod void test_Solarloancontroller10(){
      List<Solar_Loans__c> listSolarLoan  =  [SELECT Id,mem_Joint_SSN__c from Solar_Loans__c where mem_Joint_SSN__c = '573636331'limit 1];
      
      SolarLoanController.getMemberData(listSolarLoan[0].id, 'Stage 7');
      SolarLoanController.getMemberData(listSolarLoan[0].id, 'Stage 3');} 
    
    static testMethod void test_Solarloancontroller11(){
    
      List<Solar_Loans__c> listSolarLoan  =  [SELECT Id,mem_Joint_SSN__c from Solar_Loans__c where mem_Joint_SSN__c = '573636332'limit 1];
      
      SolarLoanController.getMemberData(listSolarLoan[0].id, 'Stage 3');
    }  

  static testMethod void test_GetCaseAttachments_UseCase1(){
    
    test.startTest();  
    
    // ---------------------------Fetching Solar Loan record from test set up data -----------------------------------//
    List<Solar_Loans__c> listSolarLoan  =  [SELECT Id,status__c from Solar_Loans__c limit 1];
    
    // ---------------------------Fetching Cotent Document record from test set up data ------------------------------//
    List<ContentDocument> cdList = [SELECT Id, Title, LatestPublishedVersionId FROM ContentDocument limit 1];
    
    // ---------------------------Fetching Solar Loan document record from test set up data -------------------------//
    List<SolarLoan_Document__c> SolarLoanDocList = [SELECT id from SolarLoan_Document__c limit 1];
      
    List<Attachment> alist = [select id from Attachment Limit 1];  
   
    // --------------------------------Calling non static method of SolarLoanAPI class------------------------------//  
    
    Solar_Loans__c sl1 = new Solar_Loans__c();
	sl1.id =  listSolarLoan[0].id;
    sl1.Sunlight_Update__c = true;
    //sl1.Status__c = 'Done';  
    sl1.Current_Solar_Loan_Stage__c = 'Stage 8';  
    update sl1;
    
    List<SolarLoanDocumentAPI.SolarLoanDocumentAPIResopnse> listApiResponse = SolarLoanDocumentAPI.getSolarLoanDocuemnts();
    RestRequest req = new RestRequest();
    req.requestURI = '/services/apexrest/SolarLoanDocumentAPI';
      
    req.requestBody = blob.valueof(listApiResponse[2].AttachmentID /*+ ',' + listApiResponse[1].AttachmentID*/);
    req.httpMethod = 'post';
    RestContext.request = req;
    
    // --------------------------------Calling static method from SolarLoanAPI class---------------------------------//
    
    SolarLoanDocumentAPI.updateSolarLoanDocuemnts();
    
    //--------------------------------- Creating Custom setting data --------------------------------------------------//
    SolarLoan_Document_Settings__c docSetting1 = new SolarLoan_Document_Settings__c();
    docSetting1.Days__c = 120;
    docSetting1.Name = 'Done';
    insert docSetting1;
    
    SolarLoan_Document_Settings__c docSetting2 = new SolarLoan_Document_Settings__c();
    docSetting2.Days__c = 120;
    docSetting2.Name = 'Declined';
    insert docSetting2;
    
    SolarLoan_Document_Settings__c docSetting3 = new SolarLoan_Document_Settings__c();
    docSetting3.Days__c = 120;
    docSetting3.Name = 'Expired';
    insert docSetting3;
    
    //---------------------------------Calling SolarLoanDeleteAttachment class-------------------------------------//
    
    SolarLoanDocumentDeleteAttachments obj = new SolarLoanDocumentDeleteAttachments();
    obj.execute(null);
  
    test.stopTest();
 
  }
  static testMethod void test_GetCaseAttachments_UseCase2(){
    
    List<Solar_Loans__c> listSolarLoan  =  [SELECT Id,status__c from Solar_Loans__c limit 1];
    //List<ContentDocument> cdList = [SELECT Id, Title, LatestPublishedVersionId FROM ContentDocument limit 1];
    List<SolarLoan_Document__c> SolarLoanDocList = [SELECT id from SolarLoan_Document__c limit 1];  
      
    Datetime yesterday = Datetime.now().addDays(-121);
    Solar_Loans__c sl1 = new Solar_Loans__c();
	sl1.id =  listSolarLoan[0].id;
    sl1.Sunlight_Update__c = true;
    sl1.Status__c = 'UCC Completed';  
    update sl1;
	
    test.startTest();
    //--------------------------------- Creating Custom setting data --------------------------------------------------//
    SolarLoan_Document_Settings__c docSetting1 = new SolarLoan_Document_Settings__c();
    docSetting1.Days__c = 120;
    docSetting1.Name = 'Done';
    insert docSetting1;
    
    SolarLoan_Document_Settings__c docSetting2 = new SolarLoan_Document_Settings__c();
    docSetting2.Days__c = 120;
    docSetting2.Name = 'Declined';
    insert docSetting2;
    
    SolarLoan_Document_Settings__c docSetting3 = new SolarLoan_Document_Settings__c();
    docSetting3.Days__c = 120;
    docSetting3.Name = 'Expired';
    insert docSetting3;
    
    //---------------------------------Calling SolarLoanDeleteAttachment class-------------------------------------//
    
    test.stopTest();
      
    SolarLoanDocList[0].IsMovedToOnBase__c = true;
    SolarLoanDocList[0].Solar_Loans__c = sl1.id;
    update SolarLoanDocList[0];      
    
    Test.setCreatedDate(SolarLoanDocList[0].Id, yesterday);        
    SolarLoanDocumentDeleteAttachments obj = new SolarLoanDocumentDeleteAttachments();
    obj.execute(null);
      
  }
  static testMethod void test_GetCaseAttachments_UseCase3(){
    
	test.startTest();    
    List<Solar_Loans__c> listSolarLoan  =  [SELECT Id,status__c from Solar_Loans__c limit 1];
    //List<ContentDocument> cdList = [SELECT Id, Title, LatestPublishedVersionId FROM ContentDocument limit 1];
    List<SolarLoan_Document__c> SolarLoanDocList = [SELECT id from SolarLoan_Document__c limit 1];  

    Datetime yesterday = Datetime.now().addDays(-121);
    Solar_Loans__c sl1 = new Solar_Loans__c();
	sl1.id =  listSolarLoan[0].id;
    sl1.Sunlight_Update__c = true;
    sl1.Status__c = 'Declined';  
    update sl1;
	
	 
    SolarLoanDocList[0].IsMovedToOnBase__c = true;
    SolarLoanDocList[0].Solar_Loans__c = sl1.id;
    update SolarLoanDocList[0];      
      
    test.stopTest();
    Test.setCreatedDate(SolarLoanDocList[0].Id, yesterday);      
      
    //--------------------------------- Creating Custom setting data --------------------------------------------------//
    SolarLoan_Document_Settings__c docSetting1 = new SolarLoan_Document_Settings__c();
    docSetting1.Days__c = 120;
    docSetting1.Name = 'Done';
    insert docSetting1;
    
    SolarLoan_Document_Settings__c docSetting2 = new SolarLoan_Document_Settings__c();
    docSetting2.Days__c = 120;
    docSetting2.Name = 'Declined';
    insert docSetting2;
    
    SolarLoan_Document_Settings__c docSetting3 = new SolarLoan_Document_Settings__c();
    docSetting3.Days__c = 120;
    docSetting3.Name = 'Expired';
    insert docSetting3;
    
    //---------------------------------Calling SolarLoanDeleteAttachment class-------------------------------------//
    
    SolarLoanDocumentDeleteAttachments obj = new SolarLoanDocumentDeleteAttachments();
    obj.execute(null);
 
  } 
    
  static testMethod void test_GetCaseAttachments_UseCase4(){
    
    //--------------------------------- Creating Custom setting data --------------------------------------------------//
    SolarLoan_Document_Settings__c docSetting1 = new SolarLoan_Document_Settings__c();
    docSetting1.Days__c = 120;
    docSetting1.Name = 'Done';
    insert docSetting1;
    
    SolarLoan_Document_Settings__c docSetting2 = new SolarLoan_Document_Settings__c();
    docSetting2.Days__c = 120;
    docSetting2.Name = 'Declined';
    insert docSetting2;
    
    SolarLoan_Document_Settings__c docSetting3 = new SolarLoan_Document_Settings__c();
    docSetting3.Days__c = 120;
    docSetting3.Name = 'Expired';
    insert docSetting3;
      
	List<Solar_Loans__c> listSolarLoan  =  [SELECT Id,status__c from Solar_Loans__c limit 1];
    //List<ContentDocument> cdList = [SELECT Id, Title, LatestPublishedVersionId FROM ContentDocument limit 1];
    List<SolarLoan_Document__c> SolarLoanDocList = [SELECT id from SolarLoan_Document__c limit 1];  

    Datetime yesterday = Datetime.now().addDays(-121);
    Solar_Loans__c sl1 = new Solar_Loans__c();
	sl1.id =  listSolarLoan[0].id;
    sl1.Sunlight_Update__c = true;
    sl1.Status__c = 'Expired';  
    update sl1;
	
	
    SolarLoanDocList[0].IsMovedToOnBase__c = true;
    SolarLoanDocList[0].Solar_Loans__c = sl1.id;
    update SolarLoanDocList[0];      
    
    Test.setCreatedDate(SolarLoanDocList[0].Id, yesterday);      
      
    //---------------------------------Calling SolarLoanDeleteAttachment class-------------------------------------//
    test.startTest();
    SolarLoanDocumentDeleteAttachments obj = new SolarLoanDocumentDeleteAttachments();
    obj.execute(null);
    test.stopTest();  
 
  }  
}