@isTest
private class TakeOwnershipControllerTest {

    @testSetup
    static void SetUp(){
        test.StartTest();
        
        //Account account_Obj = new Account(LastName = 'LastName540', FirstName = 'First297', CreatedDate = DateTime.now(), LastModifiedDate = DateTime.now(), PersonEmail = 'Email88@test.com', PersonHasOptedOutOfEmail = false, Email_raw__c = 'Email191', NA_Eligibility__c = false, NA_LEAV_Complete__c = false, NA_LECF_Complete__c = false, NA_LECP_Complete__c = false, NA_LEEM_Complete__c = false, NA_LEHS_Complete__c = false, NA_LEMD_Complete__c = false, NA_LEMP_Complete__c = false, NA_LEMQ_Complete__c = false, NA_LEOL_Complete__c = false, NA_LEOM_Complete__c = false, NA_LEPT_Complete__c = false, NA_LESB_Complete__c = false, NA_LESF_Complete__c = false, NA_LEWS_Complete__c = false, NA_Opt_Out__c = false, smagicinteract__SMSOptOut__pc = false, Alternate_Email__pc = 'Email153@test.com', Residential_City__pc = 'Resid358', Residential_Country_Code__pc = '12', Residential_Country__pc = '1', Residential_Extra_Address__pc = 'Resid386', Residential_State__pc = 'Resid481', Residential_Street__pc = 'Resid202', Residential_Zipocde__pc = 'Resid562');
        //Insert account_Obj;
        SolarLoan_To_Episys_API_Details__c api = new SolarLoan_To_Episys_API_Details__c();
        api.URL__c = 'https://symxapi.chevronfcu.org/devclient';
        api.Name = 'ProductionURL';
        insert api;
        
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
        insert sl;
        
        Account account_Obj = new Account(PersonHomePhone='', PersonHasOptedOutOfEmail = false, Name = 'MARIA BANDA');
        Insert account_Obj; 
            
        Account_Details__c account_details_Obj = new Account_Details__c(Onboarded__c = false, RecType__c = 'ACCT', TypeTranslate__c = '2-TRUST');
            Insert account_details_Obj;
            
        Account_Details__c account_details_Child_Obj = new Account_Details__c(Parent_Account__c = account_details_Obj.Id,  Name = '0000147163', RecordTypeId = '012j00000010KElAAM',CreatedDate = Date.ValueOf('2017-12-05 21:07:23'), LastModifiedDate = Date.ValueOf('2018-02-08 12:52:36'), Onboarded__c = true, RecType__c = 'SHAR', Reference__c = 'BC01');
            Insert account_details_Child_Obj; 
        
                
        Person_Account__c person_account_Obj = new Person_Account__c(Account_Number__c = account_details_Obj.id, PersonID__c = account_Obj.id, Relationship__c = null, TypeTranslate__c = '0000/Primary');
            Insert person_account_Obj; 
            
        Contact contact_Obj = new Contact(AccountId = account_Obj.Id, LastName = 'BANDA', HasOptedOutOfEmail = false, CreatedDate = Date.ValueOf('2017-12-05 21:18:53'), LastModifiedDate = Date.ValueOf('2018-02-08 11:26:44'));
            Insert contact_Obj;
        
        Case caseObj =new Case(Status = 'In Process', Description='test description', Phone_Number__c='', CaseComments__c ='new comment',  Brand__c = 'CFCU', Primary_Category__c = 'Marketing', ContactId = contact_Obj.id, Origin = null, Subject = 'Test', ClosedDate = null, IsEscalated = false,Account_Number__c = account_Details_Obj.Id, Additional_Documents__c = false, Staff_Escalated__c = false, Five_Day_Flag__c = false, IsMarkDeleted__c = false, IsMarkRead__c = false, IsMarkSaved__c = false, Secondary_Category__c = 'Account Services', Tertiary_Category__c = 'Extended Check Hold', MaritzCX__Response_Deleted_From_MaritzCX__c = false, SLATemp__c = false);
            Insert caseObj;

       Lead ld = new Lead (LastName = 'Test',Product_Type__c = 'Card',Brand__c = 'CFCU',FirstName = 'test',MiddleName = 'New', Description = 'New',
       Salutation = 'MR.',Suffix = 'MR',Status = 'New',Phone= '1234567890',Email='test@test.com',MobilePhone='1234567892',How_did_you_hear_about_us__c='Website',
       LeadSource='BDO-Realtor Referral' , Street_Address_1__c='Address 1',State__c= 'NY',Zip_Code__c= '12345',City__c='NYC',Country__c ='USA');                             
       insert ld;  
      
      Opportunity op = new Opportunity(Name = 'Name', StageName = 'Open',  CloseDate = system.today(),  Is_Converted__c = true,   Opportunity_Source__c = 'Word of mouth', AccountId = account_Obj.id,  Ownership__c = 'Auto Assign', Episys_User_ID__c = 1);
       insert op;
       
        
      test.StopTest();
    }
    static testMethod void changeCaseOwnershipTest() {
        // TO DO: implement unit test
        Solar_Loans__c solarloan = [select Id from Solar_Loans__c limit 1];
        TakeOwnershipController.changeCaseOwnership(solarloan.Id);
        
        Case objCase = [select Id from case limit 1];
        TakeOwnershipController.changeCaseOwnership(objCase.Id);
        
        Lead l = [select Id from Lead limit 1];
        TakeOwnershipController.changeCaseOwnership(l.Id);
       
        Opportunity o = [select Id from Opportunity limit 1];
        TakeOwnershipController.changeCaseOwnership(o.Id);
        
    }
}