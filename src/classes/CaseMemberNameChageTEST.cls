@isTest
private class CaseMemberNameChageTEST {

    @testSetup
    static void SetUp(){
        test.StartTest();
        
        //Account account_Obj = new Account(LastName = 'LastName540', FirstName = 'First297', CreatedDate = DateTime.now(), LastModifiedDate = DateTime.now(), PersonEmail = 'Email88@test.com', PersonHasOptedOutOfEmail = false, Email_raw__c = 'Email191', NA_Eligibility__c = false, NA_LEAV_Complete__c = false, NA_LECF_Complete__c = false, NA_LECP_Complete__c = false, NA_LEEM_Complete__c = false, NA_LEHS_Complete__c = false, NA_LEMD_Complete__c = false, NA_LEMP_Complete__c = false, NA_LEMQ_Complete__c = false, NA_LEOL_Complete__c = false, NA_LEOM_Complete__c = false, NA_LEPT_Complete__c = false, NA_LESB_Complete__c = false, NA_LESF_Complete__c = false, NA_LEWS_Complete__c = false, NA_Opt_Out__c = false, smagicinteract__SMSOptOut__pc = false, Alternate_Email__pc = 'Email153@test.com', Residential_City__pc = 'Resid358', Residential_Country_Code__pc = '12', Residential_Country__pc = '1', Residential_Extra_Address__pc = 'Resid386', Residential_State__pc = 'Resid481', Residential_Street__pc = 'Resid202', Residential_Zipocde__pc = 'Resid562');
        //Insert account_Obj;
        
        Account account_Obj = new Account(PersonHomePhone='', PersonHasOptedOutOfEmail = false, 
                            NA_Eligibility__c = false, 
                            Name = 'MARIA BANDA', 
                        NA_LEAV_Complete__c = true, NA_LECF_Complete__c = true, NA_LECP_Complete__c = true, 
                        NA_LEEM_Complete__c = true, NA_LEHS_Complete__c = true,
                        NA_LEHS_Update__c = null, NA_LEMD_Complete__c = true, 
                        NA_LEMP_Complete__c = true, NA_LEMQ_Complete__c = true, NA_LEOL_Complete__c = true, 
                        NA_LEOM_Complete__c = true, NA_LEOM_Update__c = null, NA_LEPT_Complete__c = true, 
                        NA_LESB_Complete__c = true, NA_LESF_Complete__c = true, NA_LEWS_Complete__c = true, 
                        NA_Opt_Out_Date__c = null, NA_Opt_Out_Updated__c = null, 
                        NA_Opt_Out__c = false);
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
            
       
        
        test.StopTest();
    }
    public static testmethod void GetMemberNameList_Test(){
        // TODO : Change following Assert Statement
        Account_Details__c account_Obj = [select id from Account_Details__c order by CreatedDate desc limit 1];
        Case cas =[Select id, Account_Number__c,Accountid from Case limit 1];
        System.Assert(CaseMemberNameChange.GetMemberNameList(cas.Id) != null);      
    }
    
    public static testMethod void UpdateCaseTest()
    {
        Case cas =[Select id, Account_Number__c,Accountid from Case limit 1];
        Account act =[Select id from Account];
        CaseMemberNameChange.UpdateCase(cas.id, act.id);
    }
    
}