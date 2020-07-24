@isTest
private class SolarLoanTest{
  @testSetup
  static void setupTestData(){
   
     //---------------------------------------- Creating Account Details record-----------------------------------//
     
     SolarLoan_Document_Settings__c sds = new SolarLoan_Document_Settings__c();
     sds.Days__c = 10;
     sds.Name = 'Done';
     insert sds; 
   
     List<Account_Details__c> account_details_Obj = new List<Account_Details__c>{
                new Account_Details__c(Name = '0000147163', Balance__c = 0.00, Combined_Account_ID__c = '0000147163S0100P0100', ID1__c = '0100', 
                Onboarded__c = true, Reference__c = 'BC02',RecType__c = 'LOAN', TypeTranslate__c = '75-SECURED SOLAR')};
    
     insert account_details_Obj;
    
    
     List<Account_Details__c> account_details_Obj1 = new List<Account_Details__c>{
                new Account_Details__c(Name = '0000123456', Balance__c = 0.00, Combined_Account_ID__c = '0000147163S0100P0100', ID1__c = '0100', 
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
                               new Person_Account__c(TypeTranslate__c='0000/Primary',Account_Number__c = account_details_Obj[0].id, PersonID__c = account_Obj.Id)};
     insert person_obj;
      
     List<Person_Account__c> person_obj1= new List<Person_Account__c>{
                               new Person_Account__c(TypeTranslate__c='0000/Primary',Account_Number__c = account_details_Obj1[0].id, PersonID__c = account_Obj.Id)};
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
     sl.ECOA_Code__c = '2';
     sl.Site_UUID__c = '11';
     sl.FNI__c = '12';
     sl.Member_Number__c = '269355';
     sl.Status__c = 'New'; 
     insert sl;
     
     SolarLoan_Obj.add(sl);
      
     Solar_Loans__c sl1 = new Solar_Loans__c();
     sl1.id =  SolarLoan_Obj[0].id;
     sl1.Member_Number__c = '0000147165'; 
     sl1.Routing_Number__c = '284084350'; 
     sl1.ACH__c = 'True';
     sl1.Routing_Number__c = '122105155';
     sl1.Bank_Name__c = 'US BANK NA';
     sl1.Bank_Account_Number__c = '122105155';
     sl1.Status__c = 'Done';  
     update sl1; 
     
     //---------------------------------------- Creating Solar Loan Document record-----------------------------------//
     
     List<SolarLoan_Document__c> SolarLoanDocList = new List<SolarLoan_Document__c>{
         new SolarLoan_Document__c(Name = 'Test Document', Solar_Loans__c = SolarLoan_Obj[0].id)};      
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
      SolarLoanController.waitingForResponse(listSolarLoan[0].id, 'New');
      SolarLoanController.getMemberData(listSolarLoan[0].id, 'Stage 1');
      SolarLoanController.getMemberData(listSolarLoan[0].id, 'Stage 3');
      SolarLoanController.routingInfo('122105155');
      SolarLoanController.getMemberData(listSolarLoan[0].id, 'Stage 5');
      SolarLoanController.getMemberData(listSolarLoan[0].id, 'Stage 7');
      test.startTest();
      SolarLoanController.getMemberData(listSolarLoan[0].id, 'Stage 8');
      SolarLoanController.saveRoutingInfo(listSolarLoan[0].id,'122105155','Test Bank Name');
      test.stopTest();
  }
  static testMethod void test_GetCaseAttachments_UseCase1(){
    
    test.startTest();  
    
    // ---------------------------Fetching Solar Loan record from test set up data -----------------------------------//
    List<Solar_Loans__c> listSolarLoan  =  [SELECT Id from Solar_Loans__c limit 1];
    
    // ---------------------------Fetching Cotent Document record from test set up data ------------------------------//
    List<ContentDocument> cdList = [SELECT Id, Title, LatestPublishedVersionId FROM ContentDocument limit 1];
    
    // ---------------------------Fetching Solar Loan document record from test set up data -------------------------//
    List<SolarLoan_Document__c> SolarLoanDocList = [SELECT id from SolarLoan_Document__c limit 1];  
      
    // --------------------------------Calling non static method of SolarLoanAPI class------------------------------//  
    
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
    docSetting1.Name = 'Completed';
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