@isTest
private class SolarLoanDocTest{
    
 static testMethod void SolarLoanDocTestData(){
   
     //---------------------------------------- Creating Account Details record-----------------------------------//
     
     
     List<Account_Details__c> account_details_Obj = new List<Account_Details__c>{
                new Account_Details__c(Name = '0000147163', Balance__c = 0.00, Combined_Account_ID__c = '0000147163S0100P0100', ID1__c = '0100', 
                Onboarded__c = true, RecType__c = 'ACCT', TypeTranslate__c = '1-PRIMARY SHARE')};
    
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
     
     List<Solar_Loans__c> SolarLoan_Obj = new List<Solar_Loans__c>{
        new Solar_Loans__c(Member_Number__c = '0000265418', Site_UUID__c = '0064M00000XWR42QAH',Status__c = 'Completed', Brand__c = 'Spectrum', Primary_First_Name__c = 'Tania', Primary_Last_Name__c = 'Cabrera')};
     Insert SolarLoan_Obj;
     
     //---------------------------------------- Creating Solar Loan Document record-----------------------------------//
     
     List<SolarLoan_Document__c> SolarLoanDocList = new List<SolarLoan_Document__c>{
         new SolarLoan_Document__c(Name = 'Test Document', Document_Name__c = 'Member Application_Completed', NewFile__c = true,Solar_Loans__c = SolarLoan_Obj[0].id)};      
     insert SolarLoanDocList;
     
	SolarLoan_Document__c sd = new SolarLoan_Document__c();
    sd.id =  SolarLoanDocList[0].id;
    sd.NewFile__c = false;
     
    update sd;  
	delete sd;   
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
  
}