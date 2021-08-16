@isTest
public class xPressRefiControllerTest {
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
        accDetail.Impermissible__c = false;
        accDetail.Vesting__c = 'Test';
        accDetail.Trust__c = false;
        accDetail.PMI_Company_Name__c = '';
        accDetail.Xpress_Refi_Eligibility__c = true;
		insert accDetail;

		List<Person_Account__c> person_obj = new List<Person_Account__c>{new Person_Account__c(TypeTranslate__c = '0000/Primary', Account_Number__c = accDetail.id, PersonID__c = acc.Id)};
		Insert person_obj;

		List<xPressRefi_Stages__c> xpressrefi_stages = new List<xPressRefi_Stages__c>{new xPressRefi_Stages__c(Name = 'Stage1', isActive__c = true, Order__c = 1, Stage_Component__c = 'xPressRefiStage1', StepId__c = 'Step1'), new xPressRefi_Stages__c(Name = 'Stage2', isActive__c = true, Order__c = 2, Stage_Component__c = 'xPressRefiStage2', StepId__c = 'Step2'), new xPressRefi_Stages__c(Name = 'Stage3', isActive__c = true, Order__c = 3, Stage_Component__c = 'xPressRefiStage3', StepId__c = 'Step3')};
		Insert xpressrefi_stages;
        
        xPressRefi_To_Episys_API_Details__c api = new xPressRefi_To_Episys_API_Details__c();
		api.URL__c = 'https://symxapi.chevronfcu.org/devclient';
		api.Name = 'ProductionURL';
		insert api;
        
        xPressRefi_To_Episys_API_Details__c api1 = new xPressRefi_To_Episys_API_Details__c();
		api1.URL__c = 'https://symxapi.chevronfcu.org/XpressRefi_DEV';
		api1.Name = 'ProductionCSVURL';
		insert api1;
        
        Xpress_refi_relo_discount__c xrelo = new Xpress_refi_relo_discount__c();
        xrelo.Name='Primary';
        xrelo.Discount__c =0.375;
        insert xrelo;

        xPressRefi_Docusign_Emails__c ac = new xPressRefi_Docusign_Emails__c();
		ac.Name = 'Email For Testing';
		ac.Emails__c = 'Testing';
		insert ac;
        
        xPressRefi_Case_Categories__c casecat = new xPressRefi_Case_Categories__c();
        casecat.Name='Categories';
        casecat.Primary_Category__c ='Loan Servicing';
        casecat.Secondary_Category__c ='Real Estate Loans';
        casecat.Tertiary_Category__c ='Payment Adjustment';
        insert casecat;
        
        xPressRefi_Note__c Notes = new xPressRefi_Note__c();
        Notes.Name='Stage2';
        Notes.Note__c ='Test';
        Notes.UI_Stage__c ='2';        
        insert Notes;
        
        xPressRefi_Note__c Notes2p5 = new xPressRefi_Note__c();
        Notes2p5.Name='Stage2.5';
        Notes2p5.Note__c ='Test Test';
        Notes2p5.UI_Stage__c ='2.5';        
        insert Notes2p5;
        
        List<CU_Rates__c> curateList = new List<CU_Rates__c>{new CU_Rates__c(Name = 'xPress Refi30 Year Fixed',Active__c = true,Cost_Component__c = 0.0,Product__c = '30 Year Fixed',Program__c = 'xPress Refi',Rate__c = 3.125, Type__c = 'Conforming', SS_Cell__c ='test', SS_Tab__c='test'), new CU_Rates__c(Name = 'xPress Refi15 Year Fixed', Active__c = true,Cost_Component__c = 0.0,Product__c = '15 Year Fixed',Program__c = 'xPress Refi',Rate__c = 2.500 , Type__c = 'Conforming', SS_Cell__c ='test', SS_Tab__c='test')};
        insert curateList;
       
        List<CU_Rates_Configuration__c> curateConfigList = new List<CU_Rates_Configuration__c>{new CU_Rates_Configuration__c(Rate_1_Limit__c = 548250.00,Rate_2_Limit__c = 822375.00,Rate_2_States__c = 'AK,HI', Name = 'CU Rate Configurations')};
        insert curateConfigList;
       
        
        List<Mortgage_Products_Mapping__c> MortgageProductList = new List<Mortgage_Products_Mapping__c>{new Mortgage_Products_Mapping__c(Name = 'CF30',Description__c = '30 Year Fixed'), new Mortgage_Products_Mapping__c(Name = 'CF15',Description__c = '15 Year Fixed')};
        insert MortgageProductList;
        
        RecordType rec = [select Id, Name, SobjectType
		                  from RecordType
		                  where SobjectType = 'Case' and name = 'Account Servicing'
		                  limit 1];
        
        CaseRecordType__c crt = new CaseRecordType__c();
		crt.Name = 'Test';
		crt.Primary_Category__c = 'Loan Servicing';
		crt.Secondary_Category__c = 'Real Estate Loans';
		crt.Teritiary_Category__c = 'Payment Adjustment';
		crt.RecordTypeId__c = rec.id;
		crt.SLA__c = 10;
		insert crt;
        
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
        objXpressRefi.Impermissible__c = accDetail.Impermissible__c;
        objXpressRefi.Trust__c = accDetail.Trust__c;
        objXpressRefi.Vesting__c = accDetail.Vesting__c;
        objXpressRefi.PMI_Company_Name__c = accDetail.PMI_Company_Name__c;
        objXpressRefi.Income__c = 250.0;
		insert objXpressRefi;
        
        Profile pf = [Select Id
		              from profile
		              where Name = 'System Administrator'];

		User uu = new User(firstname = 'Dhwani', lastName = 'Bhavsar', email = 'dbhavsar@test.com', Username = 'dbhavsar@test.com', EmailEncodingKey = 'ISO-8859-1', Alias = 'dbha', TimeZoneSidKey = 'America/Los_Angeles', LocaleSidKey = 'en_US', LanguageLocaleKey = 'en_US', ProfileId = pf.Id);


		insert uu;

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
    
    static testMethod void getStageData(){		
        Test.startTest();
        Account objAccount = [select id, Name
		                                        from Account
		                                        limit 1];
        xPressRefiController.getStageData(objAccount.id);
        Test.stopTest();
	}
    
    static testMethod void getAuthorizedMemberships(){		
        Test.startTest();
        Account objAccount = [select id, Name
		                                        from Account
		                                        limit 1];
        xPressRefiController.getAuthorizedMemberships(objAccount.id);
        Test.stopTest();
	}
    
    static testMethod void getActiveMortgages(){		
        Test.startTest();
        Account objAccount = [select id, Name
		                                        from Account
		                                        limit 1];
        xPressRefiController.getActiveMortgages(objAccount.id);
        Test.stopTest();
	}
    
    static testMethod void createCase(){		
        Test.startTest();
        Account objAccount = [select id, Name
		                                        from Account
		                                        limit 1];
        List<xPressRefi__c> objXpressRefi = [SELECT Borrower_Birth_Date__c,Income__c, Borrower_First_Name__c, Borrower_Last_Name__c, Brand_Code__c, Brand__c, Case__c, Case__r.CaseNumber, Current_Interest_Rate_Calc__c, Current_Interest_Rate__c, Debit_Share_Account__c, DocuSignId__c, Docusign_Status__c, Home_Value__c, Id, Interest_Rate__c, Investor__c, is_CSV_Generated__c, Is_Mortgage_Ware_File_Created__c, Is_Product_Change__c, LoanId__c, Mailing_Address_1__c, Mailing_Address_2__c, Mailing_Address_City__c, Mailing_Address_Zip__c, Mailing_State__c, Maturity_Date_Calc__c, Maturity_Date__c, Member_Number__c, Member__c, New_Interest_Rate_Calc__c, New_Payment_Amount_Calc__c, New_Product_Type__c, PMI_Amount__c, Principal_Balance__c, Product_Type__c, Property_Address_2__c, Property_Balance__c, Property_City__c, Property_County__c, Property_State__c, Property_Zip__c, Property__c, P_I_Payment__c, Rate_Expiration_Date__c, Share_Account__c, Start_Date_Calc__c, Member_Phone__c, Member_Email__c, Loan_Program_Type__c, Borrower_Name_1__c, Borrower_Name_2__c, Due_Date__c, PMI_Flag__c, Is_Chevron_Employee__c, Is_Primary_Residence__c, Is_Relocation_Loan__c, Impermissible__c, New_Product_Name__c, Remaining_Term__c, Vesting__c, Trust__c, PMI_Company_Name__c,Vesting_Person_1__c,Vesting_Person_2__c,Vesting_Person_3__c,Vesting_Person_4__c 
			                                            FROM xPressRefi__c
		                                        limit 1];
        xPressRefiController.createCase(objAccount.id, objXpressRefi[0]);
        Test.stopTest();
	}
    
    static testMethod void getReloDiscountRates(){		
        Test.startTest();
        xPressRefiController.getReloDiscountRates();
        Test.stopTest();
	}
    
    static testMethod void CreateMortgageCadenceCSVFile(){		
        Test.startTest();
        List<xPressRefi__c> objXpressRefi = [select id, Name
		                                        from xPressRefi__c
		                                        limit 1];
        set<id> ids=new set<id>();
        ids.add(objXpressRefi[0].id);
        xPressRefiController.CreateMortgageCadenceCSVFile(ids);
        Test.stopTest();
	}
    
    static testMethod void CreateMortgageWareCSVFile(){		
        Test.startTest();
        List<xPressRefi__c> objXpressRefi = [select id, Name
		                                        from xPressRefi__c
		                                        limit 1];
        set<id> ids=new set<id>();
        ids.add(objXpressRefi[0].id);
        xPressRefiController.CreateMortgageWareCSVFile(ids);
        Test.stopTest();
	}
    
    static testMethod void getAllProductDetails1(){		
        Test.startTest();
        List<xPressRefi__c> objXpressRefi = [SELECT Borrower_Birth_Date__c,Is_Maturity_Date_Reset__c, Borrower_First_Name__c, Borrower_Last_Name__c, Brand_Code__c, Brand__c, Case__c, Case__r.CaseNumber, Current_Interest_Rate_Calc__c, Current_Interest_Rate__c, Debit_Share_Account__c, DocuSignId__c, Docusign_Status__c, Home_Value__c, Id, Interest_Rate__c, Investor__c, is_CSV_Generated__c, Is_Mortgage_Ware_File_Created__c, Is_Product_Change__c, LoanId__c, Mailing_Address_1__c, Mailing_Address_2__c, Mailing_Address_City__c, Mailing_Address_Zip__c, Mailing_State__c, Maturity_Date_Calc__c, Maturity_Date__c, Member_Number__c, Member__c, New_Interest_Rate_Calc__c, New_Payment_Amount_Calc__c, New_Product_Type__c, PMI_Amount__c, Principal_Balance__c, Product_Type__c, Property_Address_2__c, Property_Balance__c, Property_City__c, Property_County__c, Property_State__c, Property_Zip__c, Property__c, P_I_Payment__c, Rate_Expiration_Date__c, Share_Account__c, Start_Date_Calc__c, Member_Phone__c, Member_Email__c, Loan_Program_Type__c, Borrower_Name_1__c, Borrower_Name_2__c, Due_Date__c, PMI_Flag__c, Is_Chevron_Employee__c, Is_Primary_Residence__c, Is_Relocation_Loan__c, Impermissible__c, New_Product_Name__c, Remaining_Term__c, Vesting__c, Trust__c, PMI_Company_Name__c
			                                            FROM xPressRefi__c
		                                        limit 1];
        set<id> ids=new set<id>();
        ids.add(objXpressRefi[0].id);
        xPressRefiController.getAllProductDetails1(objXpressRefi[0],false, true);
        Test.stopTest();
	}
    
    static testMethod void saveXpressRefiData(){		
        Test.startTest();
        Account_details__c accDetail = [SELECT Id, Name, RecType__c,Due_Date__c, County_Name__c, Home_Value__c, OPEN_DATE__c, Investor__c, TypeTranslate__c, Brand__c, Brand_Code__c, Loan_Number__c, Mortgage_Name_1__c, Mortgage_Name_2__c, Emp_Available_Balance__c, Available_Balance__c, PROPERTY_ADDRESS__c, Property_City__c, Property_State__c, Property_Zip__c, PRINCIPAL_BALANCE__c, Interest_Rate__c, Maturity_Date__c, Emp_Balance__c, PAYMENT__c, Loan_code__c, Loan_Program_Type__c, Xpress_Refi_Eligibility__c, Impermissible__c, Income__c
		          FROM Account_Details__c LIMIT 1];
         Account objAccount = [select id, Name
		                                        from Account
		                                        limit 1];
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
		objXpressRefi.P_I_Payment__c = 2130;
		objXpressRefi.Member__c = objAccount.id;
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
       
        
        xPressRefiController.saveXpressRefiData(objXpressRefi,objAccount.id);
        Test.stopTest();
	}
    
    static testMethod void getProductMapping(){		
    	Test.startTest();
        xPressRefiController.getProductMapping('CF30');
        Test.stopTest();
    }
    
    
}