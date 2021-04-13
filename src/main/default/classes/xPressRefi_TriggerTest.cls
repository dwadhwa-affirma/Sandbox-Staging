@isTest
public class xPressRefi_TriggerTest {
     @testSetup
    static void setup(){
        test.startTest();
       
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
		insert accDetail;
       
       xPressRefi_To_Episys_API_Details__c api = new xPressRefi_To_Episys_API_Details__c();
		api.URL__c = 'https://symxapi.chevronfcu.org/devclient';
		api.Name = 'ProductionURL';
		insert api;
        
        xPressRefi_To_Episys_API_Details__c api1 = new xPressRefi_To_Episys_API_Details__c();
		api1.URL__c = 'https://symxapi.chevronfcu.org/XpressRefi_DEV';
		api1.Name = 'ProductionCSVURL';
		insert api1;
       
       xPressRefi__c objXpressRefi = new xPressRefi__c();
		objXpressRefi.Current_Interest_Rate__c = accDetail.Interest_Rate__c;
		objXpressRefi.Principal_Balance__c = accDetail.PRINCIPAL_BALANCE__c;
		objXpressRefi.LoanId__c = accDetail.Loan_Number__c;
		objXpressRefi.Maturity_Date__c = accDetail.Maturity_Date__c;
		objXpressRefi.Property_City__c = accDetail.Property_City__c;
		objXpressRefi.Member_Number__c = accDetail.Name;
		objXpressRefi.Property__c = accDetail.PROPERTY_ADDRESS__c;
		objXpressRefi.Property_State__c = accDetail.Property_State__c;
		objXpressRefi.Property_Zip__c = accDetail.Property_Zip__c;
		objXpressRefi.Product_Type__c = '30 Year Fixed';
       objXpressRefi.New_Product_Type__c = '15 Year Fixed';
		objXpressRefi.P_I_Payment__c = 2130;
		objXpressRefi.Member__c = acc.id;
		objXpressRefi.Borrower_First_Name__c = 'Test';
		objXpressRefi.Borrower_Last_Name__c = 'Test1';
		objXpressRefi.Property_County__c = accDetail.County_Name__c;
		objXpressRefi.Home_Value__c = accDetail.Home_Value__c;
        objXpressRefi.Start_Date_Calc__c = accDetail.OPEN_DATE__c;
        objXpressRefi.Brand_Code__c = accDetail.Brand_Code__c;
        objXpressRefi.Investor__c = accDetail.Investor__c;
        objXpressRefi.Rate_Expiration_Date__c = Date.today().addDays(45);
        objXpressRefi.Debit_Share_Account__c = accDetail.Name;
        objXpressRefi.Loan_Program_Type__c = accDetail.Loan_Program_Type__c;
        objXpressRefi.Borrower_Name_1__c = accDetail.Mortgage_Name_1__c;
        objXpressRefi.Borrower_Name_2__c = accDetail.Mortgage_Name_2__c;
        objXpressRefi.Income__c = accDetail.Income__c;
        objXpressRefi.Due_Date__c = accDetail.Due_Date__c;
       objXpressRefi.is_CSV_Generated__c = false;
       objXpressRefi.Impermissible__c = false;
        objXpressRefi.Is_Mortgage_Cadence__c = true;
		insert objXpressRefi;
        
        xPressRefi_Docusign_Emails__c ac = new xPressRefi_Docusign_Emails__c();
		ac.Name = 'Email For Testing';
		ac.Emails__c = 'Testing';
		insert ac;
        
        xPressRefi_Docusign_API_User_Details__c adAPIChevron = new xPressRefi_Docusign_API_User_Details__c();
		adAPIChevron.Name = 'Chevron XR FIXED';
		adAPIChevron.AccountId__c = 'Test';
		adAPIChevron.EndPoint__c = 'Test';
		adAPIChevron.IntegratorKey__c = 'Test';
		adAPIChevron.Password__c = 'Test';
		adAPIChevron.ReplyTo__c = 'Test';
		adAPIChevron.TemplateId__c = 'Test';
		adAPIChevron.Username__c = 'Test';
		insert adAPIChevron;

		xPressRefi_Docusign_API_User_Details__c adAPISpectrum = new xPressRefi_Docusign_API_User_Details__c();
		adAPISpectrum.Name = 'Spectrum';
		adAPISpectrum.AccountId__c = 'Test';
		adAPISpectrum.EndPoint__c = 'Test';
		adAPISpectrum.IntegratorKey__c = 'Test';
		adAPISpectrum.Password__c = 'Test';
		adAPISpectrum.ReplyTo__c = 'Test';
		adAPISpectrum.TemplateId__c = 'Test';
		adAPISpectrum.Username__c = 'Test';
		insert adAPISpectrum;
        
        MortgageProductsDocuSignTemplateMapping__c productTemplateMapping = new MortgageProductsDocuSignTemplateMapping__c();
		productTemplateMapping.Brand__c = 'Chevron';
        productTemplateMapping.Template_Name__c = '	XR FIXED';
        productTemplateMapping.name = 'CF30';
        insert productTemplateMapping;
        
        xPressRefi_Docusign_API_User_Details__c ContactSpectrum = new xPressRefi_Docusign_API_User_Details__c();
		ContactSpectrum.Name = 'Spectrum Contact Info';
		ContactSpectrum.AccountId__c = 'Test';
		ContactSpectrum.EndPoint__c = 'Test';
		ContactSpectrum.IntegratorKey__c = 'Test';
		ContactSpectrum.Password__c = 'Test';
		ContactSpectrum.ReplyTo__c = 'Test';
		ContactSpectrum.TemplateId__c = 'Test';
		ContactSpectrum.Username__c = 'Test';
		insert ContactSpectrum;
        
        xPressRefi_Docusign_API_User_Details__c ContactCFCU = new xPressRefi_Docusign_API_User_Details__c();
		ContactCFCU.Name = 'Chevron Contact Info';
		ContactCFCU.AccountId__c = 'Test';
		ContactCFCU.EndPoint__c = 'Test';
		ContactCFCU.IntegratorKey__c = 'Test';
		ContactCFCU.Password__c = 'Test';
		ContactCFCU.ReplyTo__c = 'Test';
		ContactCFCU.TemplateId__c = 'Test';
		ContactCFCU.Username__c = 'Test';
		insert ContactCFCU;
        
        test.stopTest();
        
    }
   static testMethod void test1(){
       
       test.startTest();
       List<xPressRefi__c> objXpressRefi = [select id, Name, Property_State__c, Principal_Balance__c
		                                        from xPressRefi__c
		                                        limit 1];
      
       objXpressRefi[0].Docusign_Status__c = 'Completed';
       update objXpressRefi;
       
       test.stopTest();

    }
    
    static testMethod void test2(){
       Account acc = [select id, Name
		                                        from Account
		                                        limit 1];
        
       Account_details__c accDetail = [SELECT Id, Name, RecType__c,Due_Date__c, County_Name__c, Home_Value__c, OPEN_DATE__c, Investor__c, TypeTranslate__c, Brand__c, Brand_Code__c, Loan_Number__c, Mortgage_Name_1__c, Mortgage_Name_2__c, Emp_Available_Balance__c, Available_Balance__c, PROPERTY_ADDRESS__c, Property_City__c, Property_State__c, Property_Zip__c, PRINCIPAL_BALANCE__c, Interest_Rate__c, Maturity_Date__c, Emp_Balance__c, PAYMENT__c, Loan_code__c, Loan_Program_Type__c, Xpress_Refi_Eligibility__c, Impermissible__c, Income__c, PMI_Flag__c
		                                        from Account_details__c
		                                        limit 1];
        
        test.startTest();
       xPressRefi__c objXpressRefi = new xPressRefi__c();
		objXpressRefi.Current_Interest_Rate__c = accDetail.Interest_Rate__c;
		objXpressRefi.Principal_Balance__c = accDetail.PRINCIPAL_BALANCE__c;
		objXpressRefi.LoanId__c = accDetail.Loan_Number__c;
		objXpressRefi.Maturity_Date__c = accDetail.Maturity_Date__c;
		objXpressRefi.Property_City__c = accDetail.Property_City__c;
		objXpressRefi.Member_Number__c = accDetail.Name;
		objXpressRefi.Property__c = accDetail.PROPERTY_ADDRESS__c;
		objXpressRefi.Property_State__c = accDetail.Property_State__c;
		objXpressRefi.Property_Zip__c = accDetail.Property_Zip__c;
		objXpressRefi.Product_Type__c = '30 Year Fixed';
       objXpressRefi.New_Product_Type__c = '15 Year Fixed';
		objXpressRefi.P_I_Payment__c = 2130;
		objXpressRefi.Member__c = acc.id;
		objXpressRefi.Borrower_First_Name__c = 'Test';
		objXpressRefi.Borrower_Last_Name__c = 'Test1';
		objXpressRefi.Property_County__c = accDetail.County_Name__c;
		objXpressRefi.Home_Value__c = accDetail.Home_Value__c;
        objXpressRefi.Start_Date_Calc__c = accDetail.OPEN_DATE__c;
        objXpressRefi.Brand_Code__c = accDetail.Brand_Code__c;
        objXpressRefi.Investor__c = accDetail.Investor__c;
        objXpressRefi.Rate_Expiration_Date__c = Date.today().addDays(45);
        objXpressRefi.Debit_Share_Account__c = accDetail.Name;
        objXpressRefi.Loan_Program_Type__c = accDetail.Loan_Program_Type__c;
        objXpressRefi.Borrower_Name_1__c = accDetail.Mortgage_Name_1__c;
        objXpressRefi.Borrower_Name_2__c = accDetail.Mortgage_Name_2__c;
        objXpressRefi.Income__c = accDetail.Income__c;
        objXpressRefi.Due_Date__c = accDetail.Due_Date__c;
       objXpressRefi.is_CSV_Generated__c = false;
       objXpressRefi.Impermissible__c = true;
		insert objXpressRefi;
        
         objXpressRefi.is_CSV_Generated__c = true;
       update objXpressRefi;
       
       test.stopTest();

    }
    
    static testMethod void test3(){
       Account acc = [select id, Name
		                                        from Account
		                                        limit 1];
        
       Account_details__c accDetail = [SELECT Id, Name, RecType__c,Due_Date__c, County_Name__c, Home_Value__c, OPEN_DATE__c, Investor__c, TypeTranslate__c, Brand__c, Brand_Code__c, Loan_Number__c, Mortgage_Name_1__c, Mortgage_Name_2__c, Emp_Available_Balance__c, Available_Balance__c, PROPERTY_ADDRESS__c, Property_City__c, Property_State__c, Property_Zip__c, PRINCIPAL_BALANCE__c, Interest_Rate__c, Maturity_Date__c, Emp_Balance__c, PAYMENT__c, Loan_code__c, Loan_Program_Type__c, Xpress_Refi_Eligibility__c, Impermissible__c, Income__c, PMI_Flag__c
		                                        from Account_details__c
		                                        limit 1];
        
       test.startTest(); 
       xPressRefi__c objXpressRefi = new xPressRefi__c();
		objXpressRefi.Current_Interest_Rate__c = accDetail.Interest_Rate__c;
		objXpressRefi.Principal_Balance__c = accDetail.PRINCIPAL_BALANCE__c;
		objXpressRefi.LoanId__c = accDetail.Loan_Number__c;
		objXpressRefi.Maturity_Date__c = accDetail.Maturity_Date__c;
		objXpressRefi.Property_City__c = accDetail.Property_City__c;
		objXpressRefi.Member_Number__c = accDetail.Name;
		objXpressRefi.Property__c = accDetail.PROPERTY_ADDRESS__c;
		objXpressRefi.Property_State__c = accDetail.Property_State__c;
		objXpressRefi.Property_Zip__c = accDetail.Property_Zip__c;
		objXpressRefi.Product_Type__c = '30 Year Fixed';
       objXpressRefi.New_Product_Type__c = '30 Year Fixed';
		objXpressRefi.P_I_Payment__c = 2130;
		objXpressRefi.Member__c = acc.id;
		objXpressRefi.Borrower_First_Name__c = 'Test';
		objXpressRefi.Borrower_Last_Name__c = 'Test1';
		objXpressRefi.Property_County__c = accDetail.County_Name__c;
		objXpressRefi.Home_Value__c = accDetail.Home_Value__c;
        objXpressRefi.Start_Date_Calc__c = accDetail.OPEN_DATE__c;
        objXpressRefi.Brand_Code__c = accDetail.Brand_Code__c;
        objXpressRefi.Investor__c = accDetail.Investor__c;
        objXpressRefi.Rate_Expiration_Date__c = Date.today().addDays(45);
        objXpressRefi.Debit_Share_Account__c = accDetail.Name;
        objXpressRefi.Loan_Program_Type__c = accDetail.Loan_Program_Type__c;
        objXpressRefi.Borrower_Name_1__c = accDetail.Mortgage_Name_1__c;
        objXpressRefi.Borrower_Name_2__c = accDetail.Mortgage_Name_2__c;
        objXpressRefi.Income__c = accDetail.Income__c;
        objXpressRefi.Due_Date__c = accDetail.Due_Date__c;
       objXpressRefi.is_CSV_Generated__c = false;
       objXpressRefi.Impermissible__c = false;
		insert objXpressRefi;
		
        objXpressRefi.Is_Mortgage_Ware_File_Created__c = true;
       update objXpressRefi;
       test.stopTest();

    }
    
    static testMethod void test4(){
       
       test.startTest();
       List<xPressRefi__c> objXpressRefi = [select id, Name, Property_State__c, Principal_Balance__c
		                                        from xPressRefi__c
		                                        limit 1];
      
       objXpressRefi[0].Contact_DocuSign_Status__c = 'Completed';
       update objXpressRefi;
       
       test.stopTest();

    }
}