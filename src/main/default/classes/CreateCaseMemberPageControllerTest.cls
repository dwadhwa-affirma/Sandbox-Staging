@isTest
private class CreateCaseMemberPageControllerTest
{
	//Initial Test Data
	//Add Logic to Create data required
	
	@testSetup
	static void SetUp(){
		Create_SLA__c cl = new Create_SLA__c();
        cl.Status__c = 'Open';
        cl.Name = 'Open';
        cl.hours__c = 8;
        insert cl;
        
        Create_SLA__c cl1 = new Create_SLA__c();
        cl1.Status__c = 'In Process';
        cl1.Name = 'In Process';
        cl1.hours__c = 20;
        insert cl1;
        
        Create_SLA__c cl2 = new Create_SLA__c();
        cl2.Status__c = 'Resolution';
        cl2.Name = 'Resolution';
        cl2.hours__c = 20;
        insert cl2;
        
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
	
	// Test Method: getData
	public static testmethod void Test_getData(){
		// TODO : Change following Assert Statement
		Account account_Obj = [select id from Account limit 1];
		System.Assert(CreateCaseMemberPageController.getData(account_Obj.Id) != null);		
	}
	
	// Test Method: getAccountDetailsData
	public static testmethod void Test_getAccountDetailsData(){
		// TODO : Change following Assert Statement
		Account_Details__c account_Obj = [select id from Account_Details__c order by CreatedDate desc limit 1];
		
		System.Assert(CreateCaseMemberPageController.getAccountDetailsData(account_Obj.Id) != null);		
	}
	
	// Test Method: saveData
	public static testmethod void Test_saveData(){
		
		Case caseobject = new Case();
		Account_Details__c account_Details_Obj = [select 
			Id, Parent_Account__c,  Name, RecordTypeId ,CreatedDate, LastModifiedDate, Onboarded__c , RecType__c, Reference__c
		 from Account_Details__c order by CreatedDate desc limit 1];
		 
		Account account_Obj = [select id, PersonEmail, Email_raw__c,PersonHomePhone, FirstName, LastName, Residential_Street__pc, Residential_Extra_Address__pc, Residential_City__pc,  Residential_State__pc, Residential_Country__pc, Residential_Zipocde__pc from Account limit 1];
		Case case_Obj = [select
			Description, Ownership__c,OwnerId,Future_Date__c,Follow_up_Text__c ,
			Id, Brand__c, LTK__c, Special_Reporting_Number__c, CaseComments__c,Phone_Number__c, Status, Primary_Category__c , ContactId, Subject, IsEscalated ,Account_Number__c, Additional_Documents__c , Staff_Escalated__c , Five_Day_Flag__c, IsMarkDeleted__c, IsMarkRead__c , IsMarkSaved__c, Secondary_Category__c, Tertiary_Category__c, MaritzCX__Response_Deleted_From_MaritzCX__c, SLATemp__c
		 from Case limit 1];
			List<Account_Details__c> acclist = new List<Account_Details__c>();	
		// TODO : Change following Assert Statement
		System.Assert(CreateCaseMemberPageController.saveData(case_Obj, account_Obj, account_Details_Obj, acclist) != null);	
		System.Assert(CreateCaseMemberPageController.saveData(case_Obj, account_Obj, null, acclist) != null);
		
		case_Obj.Primary_Category__c = null;
		System.Assert(CreateCaseMemberPageController.saveData(case_Obj, account_Obj, account_Details_Obj, acclist) != null);
		
	}
	
	// Test Method: saveData
	public static testmethod void Test_saveDataSecondaryCategory(){
		
		Case caseobject = new Case();
		Account_Details__c account_Details_Obj = [select 
			Id, Parent_Account__c,  Name, RecordTypeId ,CreatedDate, LastModifiedDate, Onboarded__c , RecType__c, Reference__c
		 from Account_Details__c order by CreatedDate desc limit 1];
		 List<Account_Details__c> acclist = new List<Account_Details__c>();	
		Account account_Obj = [select id, PersonEmail, Email_raw__c,PersonHomePhone, FirstName, LastName, Residential_Street__pc, Residential_Extra_Address__pc, Residential_City__pc,  Residential_State__pc, Residential_Country__pc, Residential_Zipocde__pc from Account limit 1];
		Case case_Obj = [select
			Description, Ownership__c,OwnerId,Future_Date__c,Follow_up_Text__c ,
			Id, Brand__c, Special_Reporting_Number__c,LTK__c, CaseComments__c,Phone_Number__c, Status, Primary_Category__c , ContactId, Subject, IsEscalated ,Account_Number__c, Additional_Documents__c , Staff_Escalated__c , Five_Day_Flag__c, IsMarkDeleted__c, IsMarkRead__c , IsMarkSaved__c, Secondary_Category__c, Tertiary_Category__c, MaritzCX__Response_Deleted_From_MaritzCX__c, SLATemp__c
		 from Case limit 1];			
		
		
		case_Obj.Secondary_Category__c = null;
		System.Assert(CreateCaseMemberPageController.saveData(case_Obj, account_Obj, account_Details_Obj,acclist) != null);
	}
	
	// Test Method: saveData
	public static testmethod void Test_saveDataTertiaryCategory(){
		
		Case caseobject = new Case();
		Account_Details__c account_Details_Obj = [select 
			Id, Parent_Account__c,  Name, RecordTypeId ,CreatedDate, LastModifiedDate, Onboarded__c , RecType__c, Reference__c
		 from Account_Details__c order by CreatedDate desc limit 1];
		 
		Account account_Obj = [select id, PersonEmail, Email_raw__c,PersonHomePhone, FirstName, LastName, Residential_Street__pc, Residential_Extra_Address__pc, Residential_City__pc,  Residential_State__pc, Residential_Country__pc, Residential_Zipocde__pc from Account limit 1];
		Case case_Obj = [select
			Description, Ownership__c,OwnerId,Future_Date__c,Follow_up_Text__c ,
			Id, Brand__c, Special_Reporting_Number__c, LTK__c, CaseComments__c,Phone_Number__c, Status, Primary_Category__c , ContactId, Subject, IsEscalated ,Account_Number__c, Additional_Documents__c , Staff_Escalated__c , Five_Day_Flag__c, IsMarkDeleted__c, IsMarkRead__c , IsMarkSaved__c, Secondary_Category__c, Tertiary_Category__c, MaritzCX__Response_Deleted_From_MaritzCX__c, SLATemp__c
		 from Case limit 1];		
		List<Account_Details__c> acclist = new List<Account_Details__c>();	
		case_Obj.Tertiary_Category__c = null;
		case_Obj.Secondary_Category__c = 'Test Category';	
		System.Assert(CreateCaseMemberPageController.saveData(case_Obj, account_Obj, account_Details_Obj,acclist) != null);		
	}
	
	// Test Method: saveStandAloneData
	public static testmethod void Test_saveStandAloneData(){
		Case case_Obj = [select 
			Description, Ownership__c,OwnerId,Future_Date__c,Follow_up_Text__c ,
			Id, Brand__c, LTK__c, Special_Reporting_Number__c, CaseComments__c,Phone_Number__c, Status, Primary_Category__c , ContactId, Subject, IsEscalated ,Account_Number__c, Additional_Documents__c , Staff_Escalated__c , Five_Day_Flag__c, IsMarkDeleted__c, IsMarkRead__c , IsMarkSaved__c, Secondary_Category__c, Tertiary_Category__c, MaritzCX__Response_Deleted_From_MaritzCX__c, SLATemp__c
		 from Case limit 1];
				
		System.Assert(CreateCaseMemberPageController.saveStandAloneData(case_Obj) != null);
		
		case_Obj.Primary_Category__c = null;
		System.Assert(CreateCaseMemberPageController.saveStandAloneData(case_Obj) != null);		
	}
	
	// Test Method: saveStandAloneData
	public static testmethod void Test_saveStandAloneDataSecondaryCategory(){
		Case case_Obj = [select 
			Description, Ownership__c,OwnerId,Future_Date__c,Follow_up_Text__c ,
			Id, Brand__c, LTK__c, Special_Reporting_Number__c, CaseComments__c,Phone_Number__c, Status, Primary_Category__c , ContactId, Subject, IsEscalated ,Account_Number__c, Additional_Documents__c , Staff_Escalated__c , Five_Day_Flag__c, IsMarkDeleted__c, IsMarkRead__c , IsMarkSaved__c, Secondary_Category__c, Tertiary_Category__c, MaritzCX__Response_Deleted_From_MaritzCX__c, SLATemp__c
		 from Case limit 1];
				
		case_Obj.Secondary_Category__c = null;
		System.Assert(CreateCaseMemberPageController.saveStandAloneData(case_Obj) != null);
	}
	
	// Test Method: saveStandAloneData
	public static testmethod void Test_saveStandAloneDataTertiaryCategory(){
		Case case_Obj = [select 
			Description, Ownership__c,OwnerId,Future_Date__c,Follow_up_Text__c ,
			Id, Brand__c, LTK__c, CaseComments__c,Phone_Number__c, Status, Primary_Category__c , ContactId, Subject, IsEscalated ,Account_Number__c, Additional_Documents__c , Staff_Escalated__c , Five_Day_Flag__c, IsMarkDeleted__c, IsMarkRead__c , IsMarkSaved__c, Secondary_Category__c, Tertiary_Category__c, MaritzCX__Response_Deleted_From_MaritzCX__c, SLATemp__c
		 from Case limit 1];
		
		case_Obj.Secondary_Category__c = 'Test Category';		
		case_Obj.Tertiary_Category__c = null;
		System.Assert(CreateCaseMemberPageController.saveStandAloneData(case_Obj) != null);
	}
	
	
	public static testmethod void Test_saveDataForAccountDetails(){
		
		Case caseobject = new Case();
		Account_Details__c account_Details_Obj = [select 
			Id, Parent_Account__c,  Name, RecordTypeId ,CreatedDate, LastModifiedDate, Onboarded__c , RecType__c, Reference__c
		 from Account_Details__c order by CreatedDate desc limit 1];
		 
		Person_Account__c person_account_Obj = [select Account_Number__c, PersonID__c, Relationship__c, TypeTranslate__c from Person_Account__c limit 1];   		
    		
		Case case_Obj = [select
			Description, Ownership__c,OwnerId,Future_Date__c,Follow_up_Text__c ,
			Id, Brand__c, LTK__c, Special_Reporting_Number__c, CaseComments__c,Phone_Number__c, Status, Primary_Category__c , ContactId, Subject, IsEscalated ,Account_Number__c, Additional_Documents__c , Staff_Escalated__c , Five_Day_Flag__c, IsMarkDeleted__c, IsMarkRead__c , IsMarkSaved__c, Secondary_Category__c, Tertiary_Category__c, MaritzCX__Response_Deleted_From_MaritzCX__c, SLATemp__c
		 from Case limit 1];
				
		// TODO : Change following Assert Statement
		System.Assert(CreateCaseMemberPageController.saveDataForAccountDetails(case_Obj, account_Details_Obj, person_account_Obj) != null);	
		
		System.Assert(CreateCaseMemberPageController.saveDataForAccountDetails(case_Obj, account_Details_Obj, null) != null);
		
		
		case_Obj.Primary_Category__c = null;
		System.Assert(CreateCaseMemberPageController.saveDataForAccountDetails(case_Obj, account_Details_Obj, person_account_Obj) != null);		
	}
	
	
	public static testmethod void Test_saveDataForAccountDetailsSecondaryCategory(){
		
		Case caseobject = new Case();
		Account_Details__c account_Details_Obj = [select 
			Id, Parent_Account__c,  Name, RecordTypeId ,CreatedDate, LastModifiedDate, Onboarded__c , RecType__c, Reference__c
		 from Account_Details__c order by CreatedDate desc limit 1];
		 
		Person_Account__c person_account_Obj = [select Account_Number__c, PersonID__c, Relationship__c, TypeTranslate__c from Person_Account__c limit 1];   		
    		
		Case case_Obj = [select
			Description, Ownership__c,OwnerId,Future_Date__c,
			Id, Brand__c, LTK__c, CaseComments__c,Phone_Number__c, Status, Primary_Category__c , ContactId, Subject, IsEscalated ,Account_Number__c, Additional_Documents__c , Staff_Escalated__c , Five_Day_Flag__c, IsMarkDeleted__c, IsMarkRead__c , IsMarkSaved__c, Secondary_Category__c, Tertiary_Category__c, MaritzCX__Response_Deleted_From_MaritzCX__c, SLATemp__c
		 from Case limit 1];
		
		case_Obj.Secondary_Category__c = null;
		System.Assert(CreateCaseMemberPageController.saveDataForAccountDetails(case_Obj, account_Details_Obj, person_account_Obj) != null);		
	}
	
	public static testmethod void Test_saveDataForAccountDetailsTertiaryCategory(){
		
		Case caseobject = new Case();
		Account_Details__c account_Details_Obj = [select 
			Id, Parent_Account__c,  Name, RecordTypeId ,CreatedDate, LastModifiedDate, Onboarded__c , RecType__c, Reference__c
		 from Account_Details__c order by CreatedDate desc limit 1];
		 
		Person_Account__c person_account_Obj = [select Account_Number__c, PersonID__c, Relationship__c, TypeTranslate__c from Person_Account__c limit 1];   		
    		
		Case case_Obj = [select
			Description, Ownership__c,OwnerId,Future_Date__c,
			Id, Brand__c, LTK__c, CaseComments__c,Phone_Number__c, Status, Primary_Category__c , ContactId, Subject, IsEscalated ,Account_Number__c, Additional_Documents__c , Staff_Escalated__c , Five_Day_Flag__c, IsMarkDeleted__c, IsMarkRead__c , IsMarkSaved__c, Secondary_Category__c, Tertiary_Category__c, MaritzCX__Response_Deleted_From_MaritzCX__c, SLATemp__c
		 from Case limit 1];
		 		
		case_Obj.Tertiary_Category__c = null;
		case_Obj.Secondary_Category__c = 'Test Category';	
		System.Assert(CreateCaseMemberPageController.saveDataForAccountDetails(case_Obj, account_Details_Obj, person_account_Obj) != null);
	}
	
	
	// Test Method: getPicklistValues
	public static testmethod void Test_getPicklistValues(){
		SetUp();
		string objpicklistfieldsmap = '';
		CollectionsInLightningCls.getPicklistValues('{"Needs_Assesment__c":["Do_you_Rent_or_Own__c","LEHS_Current_Lender__c","LEHS_Type_of_Mortgage__c","LEHS_Planning_to_Purchase__c","LEHS_Purchase_When__c","LEHS_Have_Realtor__c"]}');
		//System.Assert(CreateCaseMemberPageController.getPicklistValues(objpicklistfieldsmap) != null);
		
	}
	// Test Method: getDataValue
	public static testmethod void Test_getDataValue(){
		
		string newsearchtext = '';
		// TODO : Change following Assert Statement
		System.Assert(CreateCaseMemberPageController.getDataValue(newsearchtext) != null);
		
	}
	// Test Method: selectCaseCategories
	public static testmethod void Test_selectCaseCategories(){
		
		string selectedtext = 'Case / Category';
		// TODO : Change following Assert Statement
		System.Assert(CreateCaseMemberPageController.selectCaseCategories(selectedtext) != null);
		
	}
	// Test Method: getscOptions
	public static testmethod void Test_getscOptions(){
	
		string pcvalue = '';
		// TODO : Change following Assert Statement
		System.Assert(CreateCaseMemberPageController.getscOptions(pcvalue) != null);
	
	}
	// Test Method: gettcOptions
	public static testmethod void Test_gettcOptions(){
		
		string scvalue = '';
		// TODO : Change following Assert Statement
		System.Assert(CreateCaseMemberPageController.gettcOptions(scvalue) != null);
		
	}
	// Test Method: pcOptions
	public static testmethod void Test_pcOptions(){
		
		// TODO : Change following Assert Statement
		System.Assert(CreateCaseMemberPageController.pcOptions() != null);
		
	}
	
	// Test Method: saveTheAttachment
	public static testmethod void Test_saveTheAttachment(){
		
		
		
    	//Case case_Obj = new Case(IsEscalated = false, CreatedDate = Date.ValueOf('2018-02-09 05:20:51'), LastModifiedDate = Date.ValueOf('2018-02-09 05:20:52'), Additional_Documents__c = false, Brand__c = 'CFCU', Staff_Escalated__c = false, Five_Day_Flag__c = false, IsMarkDeleted__c = false, IsMarkRead__c = false, IsMarkSaved__c = false, MaritzCX__Response_Deleted_From_MaritzCX__c = false, SLATemp__c = false);
    	//Insert case_Obj;
	    
	    Case case_Obj =  [select Id from case limit 1];
		
        Attachment a = new Attachment();
		Id parentid = case_Obj.Id;
		string filename = 'new file';		
		string contenttype = '';
		Blob bodyBlob=Blob.valueOf('Unit Test Attachment Body');			
		String s = EncodingUtil.base64Encode(bodyBlob);
		
		System.Assert(CreateCaseMemberPageController.saveTheAttachment(parentid, filename, s, contenttype) != null);
		
	}
    
    public static testmethod void Testmethod1(){
    	    
        CreateCaseMemberPageController.selectCaseCategoriesforTopTenTypes('Loan Servicing', 'Consumer Loans');
        CreateCaseMemberPageController.getDependentMap('Primary_Category__c', 'Secondary_Category__c');
        CreateCaseMemberPageController.PicklistEntryWrapper  wrp = new CreateCaseMemberPageController.PicklistEntryWrapper();
        CreateCaseMemberPageController.getTop10Cases();
        CreateCaseMemberPageController.getPicklistValues('{"Needs_Assesment__c":["Do_you_Rent_or_Own__c","LEHS_Current_Lender__c","LEHS_Type_of_Mortgage__c","LEHS_Planning_to_Purchase__c","LEHS_Purchase_When__c","LEHS_Have_Realtor__c"]}');
    }
	
}