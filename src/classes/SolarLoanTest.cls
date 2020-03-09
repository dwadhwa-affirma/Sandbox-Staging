@isTest
private class SolarLoanTest{
  @testSetup
  static void setupTestData(){
   
     List<Account_Details__c> account_details_Obj = new List<Account_Details__c>{
                new Account_Details__c(Name = '0000147163', Balance__c = 0.00, Combined_Account_ID__c = '0000147163S0100P0100', ID1__c = '0100', 
                Onboarded__c = true, RecType__c = 'ACCT', TypeTranslate__c = '1-PRIMARY SHARE')};
    
     insert account_details_Obj;
    
     List<Account_Details__c> account_details_Obj1 = new List<Account_Details__c>{
                new Account_Details__c(Name = '0000123456', Balance__c = 0.00, Combined_Account_ID__c = '0000147163S0100P0100', ID1__c = '0100', 
                Onboarded__c = true, RecType__c = 'ACCT', TypeTranslate__c = '1-PRIMARY SHARE')};
    
     insert account_details_Obj1;
    
    
     Account account_Obj = new Account(LastName = 'BANDATest', FirstName = 'MARIATest', Type = 'null', PersonHasOptedOutOfEmail = false, 
              NA_Eligibility__c = false, NA_LEAV_Complete__c = true, NA_LECF_Complete__c = true, NA_LECP_Complete__c = true, NA_LEEM_Complete__c = true, NA_LEHS_Complete__c = true, 
              NA_LEMD_Complete__c = false, NA_LEMP_Complete__c = false, NA_LEMQ_Complete__c = true, NA_LEOL_Complete__c = true, NA_LEOM_Complete__c = true, NA_LEPT_Complete__c = true, 
              NA_LESB_Complete__c = false, NA_LESF_Complete__c = true, NA_LEWS_Complete__c = true, NA_Opt_Out__c = false);
     Insert account_Obj; 
    
     List<Person_Account__c> person_obj= new List<Person_Account__c>{
     						   new Person_Account__c(TypeTranslate__c='0000/Primary',Account_Number__c = account_details_Obj[0].id, PersonID__c = account_Obj.Id)};
     insert person_obj;
      
     List<Person_Account__c> person_obj1= new List<Person_Account__c>{
     						   new Person_Account__c(TypeTranslate__c='0000/Primary',Account_Number__c = account_details_Obj1[0].id, PersonID__c = account_Obj.Id)};
     insert person_obj1;
    
     List<Solar_Loans__c> SolarLoan_Obj = new List<Solar_Loans__c>{
        new Solar_Loans__c(Member_Number__c = '0000265418', Status__c = 'Completed', Brand__c = 'Spectrum', Primary_First_Name__c = 'Tania', Primary_Last_Name__c = 'Cabrera')};
     Insert SolarLoan_Obj;
     
     List<SolarLoan_Document__c> SolarLoanDocList = new List<SolarLoan_Document__c>{
         new SolarLoan_Document__c(Name = 'Test Document', Solar_Loans__c = SolarLoan_Obj[0].id)};      
     insert SolarLoanDocList;
           
     test.startTest();
     ContentVersion objAt = new ContentVersion(Title = 'Test Document',PathOnClient = 'TestDocument.pdf',VersionData = Blob.valueOf('Test Content'), IsMajorVersion = true);
     Insert objAt;
      
     
     List<ContentDocument> cdList = [SELECT Id, Title, LatestPublishedVersionId FROM ContentDocument];
   	
     List<ContentDocumentLink> ListCDL = new List<ContentDocumentLink>{
     	new ContentDocumentLink (ContentDocumentId = cdList[0].id, LinkedEntityId = SolarLoan_Obj[0].Id)};
     insert ListCDL;
      
     test.stopTest();
  }
  static testMethod void test_GetCaseAttachments_UseCase1(){
    
    test.startTest();  
  	List<Solar_Loans__c> listSolarLoan  =  [SELECT Id from Solar_Loans__c limit 1];
  	List<ContentDocument> cdList = [SELECT Id, Title, LatestPublishedVersionId FROM ContentDocument limit 1];
    List<SolarLoan_Document__c> SolarLoanDocList = [SELECT id from SolarLoan_Document__c limit 1];  
      
  	List<SolarLoanDocumentAPI.SolarLoanDocumentAPIResopnse> listApiResponse = SolarLoanDocumentAPI.getSolarLoanDocuemnts();
  	RestRequest req = new RestRequest();
  	req.requestURI = '/services/apexrest/SolarLoanDocumentAPI';
      
  	req.requestBody = blob.valueof(listApiResponse[1].AttachmentID /*+ ',' + listApiResponse[1].AttachmentID*/);
  	req.httpMethod = 'post';
  	RestContext.request = req;
 	SolarLoanDocumentAPI.updateSolarLoanDocuemnts();
  	
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
  	
  	SolarLoanDocumentDeleteAttachments obj = new SolarLoanDocumentDeleteAttachments();
  	obj.execute(null);
  
  	test.stopTest();
 
  }
  
}