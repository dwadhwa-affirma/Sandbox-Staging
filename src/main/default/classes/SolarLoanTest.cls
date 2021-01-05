@isTest
private class SolarLoanTest{
  @testSetup
  static void setupTestData(){
   
     //---------------------------------------- Creating Account Details record-----------------------------------//
     
     SolarLoan_Document_Settings__c sds = new SolarLoan_Document_Settings__c();
     sds.Days__c = 10;
     sds.Name = 'Done';
     insert sds; 
      
     SolarLoan_To_Episys_API_Details__c api = new SolarLoan_To_Episys_API_Details__c();
     api.URL__c = 'https://symxapi.chevronfcu.org/devclient';
     api.Name = 'ProductionURL';
     insert api;
      
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
    
     
     //---------------------------------------- Creating Person Account records--------------------------------------//
     
     List<Person_Account__c> person_obj= new List<Person_Account__c>{
                               new Person_Account__c(Name_Type__c = 0,TypeTranslate__c='0000/Primary',Account_Number__c = account_details_Obj[0].id, PersonID__c = account_Obj.Id)};
     insert person_obj;
      
     List<Person_Account__c> person_obj1= new List<Person_Account__c>{
                               new Person_Account__c(Name_Type__c = 0,TypeTranslate__c='0000/Primary',Account_Number__c = account_details_Obj1[0].id, PersonID__c = account_Obj.Id)};
     insert person_obj1;
    
     
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
     insert sl;
     
     SolarLoan_Obj.add(sl);
      
     Solar_Loans__c sl1 = new Solar_Loans__c();
     sl1.Joint_First_Name__c ='Tom';
     sl1.Joint_Last_Name__c = 'Jerry';
     sl1.Joint_DOB__c = System.today();
     sl1.Joint_SSN__c =  '123';
     sl1.Joint_FICO_Score__c = 12.00;
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
     sl1.Module__c = 'module';
     sl1.Installer_Number__c = '12';
     sl1.Inverter__c = 'inverter';
     sl1.System_Size_kW__c = 12.00;
     sl1.Battery__c = 'barary';
     sl1.Installer__c = 'intealer';
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
     sl1.Site_UUID__c = '116';
     sl1.FNI__c = '12';
     sl1.Member_Number__c = '0000147163';
     sl1.Status__c = 'New'; 
     //sl1.Additional_Amount__c = 11.00; 
     insert sl1; 
      
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
     insert sl2; 
      
     SolarLoan_Obj.add(sl2);  
      
     //---------------------------------------- Creating Solar Loan Document record-----------------------------------//
     
     List<SolarLoan_Document__c> SolarLoanDocList = new List<SolarLoan_Document__c>{
         new SolarLoan_Document__c(Member_Number__c = '0000214414',Solar_Loans__c = SolarLoan_Obj[0].id)};      
     insert SolarLoanDocList;
     
     test.startTest();
     
     //---------------------------------------- Creating Content Version Record for Attachment---------------------------------------------//
     
     ContentVersion objAt = new ContentVersion(Title = 'Test Document',PathOnClient = 'TestDocument.pdf',VersionData = Blob.valueOf('Test Content'), IsMajorVersion = true);
     Insert objAt;
      
     
     List<ContentDocument> cdList = [SELECT Id, Title, LatestPublishedVersionId FROM ContentDocument];
    
     //--------------------- Creating Content Document Link with Parent as "Solar Loan" record-----------------------//
     
     List<ContentDocumentLink> ListCDL = new List<ContentDocumentLink>{
        new ContentDocumentLink (ContentDocumentId = cdList[0].id, LinkedEntityId = SolarLoan_Obj[0].Id)};
     insert ListCDL;
      
     test.stopTest();
  }
  static testMethod void test_Solarloancontroller(){
      List<Solar_Loans__c> listSolarLoan  =  [SELECT Id from Solar_Loans__c limit 1];
      List<Solar_Loans__c> listSolarLoan2  =  [SELECT Id,Bank_Name__c from Solar_Loans__c where Bank_Name__c = 'test & bank2' limit 1];
      Set<ID> slids = new Set<ID>();
      slids.add(listSolarLoan2[0].id);
      
      SolarLoanController.waitingForResponse(listSolarLoan[0].id, 'New');
      SolarLoanController.getMemberData(listSolarLoan[0].id, 'Stage 1');
      SolarLoanController.saveRoutingInfo(listSolarLoan[0].id,'122105155','Test Bank Name');
      SolarLoanController.getMemberData(listSolarLoan[0].id, 'Stage 3');
      
      SolarLoanController.routingInfo('122105155');
      SolarLoanController.getMemberData(listSolarLoan[0].id, 'Stage 5');
      test.startTest();
      SolarLoanController.getMemberData(listSolarLoan[0].id, 'Stage 7');
      SolarLoanController.getMemberData(listSolarLoan[0].id, 'Stage 8');
      SolarLoanToCreateLoan.getMemberNumber(slids);
      
      test.stopTest();
  }
    
  static testMethod void test_Solarloancontroller2(){
      List<Solar_Loans__c> listSolarLoan  =  [SELECT Id from Solar_Loans__c limit 2];
     
      SolarLoanController.getMemberData(listSolarLoan[1].id, 'Stage 4');     
  }
    
  static testMethod void test_Solarloancontroller3(){
      List<Solar_Loans__c> listSolarLoan  =  [SELECT Id from Solar_Loans__c limit 3];
      
      SolarLoanController.getMemberData(listSolarLoan[2].id, 'Stage 3');
      Solar_Loans__c sl2 = new Solar_Loans__c();
      sl2.id =  listSolarLoan[2].id;
      sl2.Additional_Amount__c = 56.00;
      sl2.EftLocator__c = '12';
      sl2.Member_Number__c = '0000147163';
      sl2.Status__c = 'Completed';  
      update sl2;
  }  
    
  static testMethod void test_GetCaseAttachments_UseCase1(){
    
    test.startTest();  
    
    // ---------------------------Fetching Solar Loan record from test set up data -----------------------------------//
    List<Solar_Loans__c> listSolarLoan  =  [SELECT Id,status__c from Solar_Loans__c limit 1];
    
    // ---------------------------Fetching Cotent Document record from test set up data ------------------------------//
    List<ContentDocument> cdList = [SELECT Id, Title, LatestPublishedVersionId FROM ContentDocument limit 1];
    
    // ---------------------------Fetching Solar Loan document record from test set up data -------------------------//
    List<SolarLoan_Document__c> SolarLoanDocList = [SELECT id from SolarLoan_Document__c limit 1];  
   
    // --------------------------------Calling non static method of SolarLoanAPI class------------------------------//  
    
    Solar_Loans__c sl1 = new Solar_Loans__c();
	sl1.id =  listSolarLoan[0].id;
    sl1.Sunlight_Update__c = true;
    sl1.Status__c = 'Done';  
    update sl1;
    
    List<SolarLoanDocumentAPI.SolarLoanDocumentAPIResopnse> listApiResponse = SolarLoanDocumentAPI.getSolarLoanDocuemnts();
    RestRequest req = new RestRequest();
    req.requestURI = '/services/apexrest/SolarLoanDocumentAPI';
      
    req.requestBody = blob.valueof(listApiResponse[1].AttachmentID /*+ ',' + listApiResponse[1].AttachmentID*/);
    req.httpMethod = 'post';
    RestContext.request = req;
    
    // --------------------------------Calling static method from SolarLoanAPI class---------------------------------//
    
    SolarLoanDocumentAPI.updateSolarLoanDocuemnts();
    
    //--------------------------------- Creating Custom setting data --------------------------------------------------//
    SolarLoan_Document_Settings__c docSetting1 = new SolarLoan_Document_Settings__c();
    docSetting1.Days__c = 120;
    docSetting1.Name = 'Closed';
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
    
    // ---------------------------Fetching Solar Loan record from test set up data -----------------------------------//
    List<Solar_Loans__c> listSolarLoan  =  [SELECT Id,status__c from Solar_Loans__c limit 1];
    
    // ---------------------------Fetching Cotent Document record from test set up data ------------------------------//
    List<ContentDocument> cdList = [SELECT Id, Title, LatestPublishedVersionId FROM ContentDocument limit 1];
    
    // ---------------------------Fetching Solar Loan document record from test set up data -------------------------//
    List<SolarLoan_Document__c> SolarLoanDocList = [SELECT id from SolarLoan_Document__c limit 1];  
      
    // --------------------------------Calling non static method of SolarLoanAPI class------------------------------//  
    
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
    test.startTest();  
    //--------------------------------- Creating Custom setting data --------------------------------------------------//
    SolarLoan_Document_Settings__c docSetting1 = new SolarLoan_Document_Settings__c();
    docSetting1.Days__c = 120;
    docSetting1.Name = 'Closed';
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
  static testMethod void test_GetCaseAttachments_UseCase3(){
    
    // ---------------------------Fetching Solar Loan record from test set up data -----------------------------------//
    List<Solar_Loans__c> listSolarLoan  =  [SELECT Id,status__c from Solar_Loans__c limit 1];
    
    // ---------------------------Fetching Cotent Document record from test set up data ------------------------------//
    List<ContentDocument> cdList = [SELECT Id, Title, LatestPublishedVersionId FROM ContentDocument limit 1];
    
    // ---------------------------Fetching Solar Loan document record from test set up data -------------------------//
    List<SolarLoan_Document__c> SolarLoanDocList = [SELECT id from SolarLoan_Document__c limit 1];  
      
    // --------------------------------Calling non static method of SolarLoanAPI class------------------------------//  
    
    Datetime yesterday = Datetime.now().addDays(-121);
    Solar_Loans__c sl1 = new Solar_Loans__c();
	sl1.id =  listSolarLoan[0].id;
    sl1.Sunlight_Update__c = true;
    sl1.Status__c = 'Declined';  
    update sl1;
	
	 
    SolarLoanDocList[0].IsMovedToOnBase__c = true;
    SolarLoanDocList[0].Solar_Loans__c = sl1.id;
    update SolarLoanDocList[0];      
      
    Test.setCreatedDate(SolarLoanDocList[0].Id, yesterday);      
    test.startTest();  
    //--------------------------------- Creating Custom setting data --------------------------------------------------//
    SolarLoan_Document_Settings__c docSetting1 = new SolarLoan_Document_Settings__c();
    docSetting1.Days__c = 120;
    docSetting1.Name = 'Closed';
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
}