@isTest
private class Member360ViewLightningControllerTest {

    @testSetup
	static void setupTestData(){
		
    	ACH_To_Episys_API_Details__c api = new ACH_To_Episys_API_Details__c();
        api.URL__c = 'https://symxapi.chevronfcu.org/devclient';
        api.Name = 'ProductionURL';
        insert api;
        
		List<Account_Details__c> account_details_Obj = new List<Account_Details__c>{
						new Account_Details__c(Name = '0000147163', Balance__c = 0.00, Combined_Account_ID__c = '0000147163S0100P0100', ID1__c = '0100', Onboarded__c = true, RecType__c = 'ACCT', TypeTranslate__c = '1-PRIMARY SHARE',WARNING_01_CODE__c='ABC',
                        WARNING_02_CODE__c='ABC',
                        WARNING_03_CODE__c='ABC',
                        WARNING_04_CODE__c='ABC',
                        WARNING_05_CODE__c='ABC',
                        WARNING_06_CODE__c='ABC',
                        WARNING_07_CODE__c='ABC',
                        WARNING_08_CODE__c='ABC',
                        WARNING_09_CODE__c='ABC',
                        WARNING_10_CODE__c='ABC',
                        WARNING_11_CODE__c='ABC',
                        WARNING_12_CODE__c='ABC',
                        WARNING_13_CODE__c='ABC',
                        WARNING_14_CODE__c='ABC',
                        WARNING_15_CODE__c='ABC',
                        WARNING_16_CODE__c='ABC',
                        WARNING_17_CODE__c='ABC',
                        WARNING_18_CODE__c='ABC',
                        WARNING_19_CODE__c='ABC',
                        WARNING_20_CODE__c='ABC',
                        Comment_Block_01__c='ABC',
                        Comment_Block_02__c='ABC',
                        Comment_Block_03__c='ABC',
                        Comment_Block_04__c='ABC',
                        Comment_Block_05__c='ABC',
                        Comment_Block_06__c='ABC',
                        Comment_Block_07__c='ABC',
                        Comment_Block_08__c='ABC',
                        Comment_Block_09__c='ABC',
                        Comment_Block_10__c='ABC',
                        Comment_Block_11__c='ABC',
                        Comment_Block_12__c='ABC',
                        Comment_Block_13__c='ABC',
                        Comment_Block_14__c='ABC',
                        Comment_Block_15__c='ABC',
                        Comment_Block_16__c='ABC',
                        Comment_Block_17__c='ABC',
                        Comment_Block_18__c='ABC',
                        Comment_Block_19__c='ABC',
                        Comment_Block_20__c='ABC'
                        ),
						
                        new Account_Details__c(Name = '0000147163', Balance__c = 0.00, Combined_Account_ID__c = '0000147163S0100P0100', ID1__c = '0100', Onboarded__c = true, RecType__c = 'SHAR', TypeTranslate__c = '1-PRIMARY SHARE',WARNING_01_CODE__c='ABC',
                        WARNING_02_CODE__c='ABC',
                        WARNING_03_CODE__c='ABC',
                        WARNING_04_CODE__c='ABC',
                        WARNING_05_CODE__c='ABC',
                        WARNING_06_CODE__c='ABC',
                        WARNING_07_CODE__c='ABC',
                        WARNING_08_CODE__c='ABC',
                        WARNING_09_CODE__c='ABC',
                        WARNING_10_CODE__c='ABC',
                        WARNING_11_CODE__c='ABC',
                        WARNING_12_CODE__c='ABC',
                        WARNING_13_CODE__c='ABC',
                        WARNING_14_CODE__c='ABC',
                        WARNING_15_CODE__c='ABC',
                        WARNING_16_CODE__c='ABC',
                        WARNING_17_CODE__c='ABC',
                        WARNING_18_CODE__c='ABC',
                        WARNING_19_CODE__c='ABC',
                        WARNING_20_CODE__c='ABC',
                        Comment_Block_01__c='ABC',
                        Comment_Block_02__c='ABC',
                        Comment_Block_03__c='ABC',
                        Comment_Block_04__c='ABC',
                        Comment_Block_05__c='ABC',
                        Comment_Block_06__c='ABC',
                        Comment_Block_07__c='ABC',
                        Comment_Block_08__c='ABC',
                        Comment_Block_09__c='ABC',
                        Comment_Block_10__c='ABC',
                        Comment_Block_11__c='ABC',
                        Comment_Block_12__c='ABC',
                        Comment_Block_13__c='ABC',
                        Comment_Block_14__c='ABC',
                        Comment_Block_15__c='ABC',
                        Comment_Block_16__c='ABC',
                        Comment_Block_17__c='ABC',
                        Comment_Block_18__c='ABC',
                        Comment_Block_19__c='ABC',
                        Comment_Block_20__c='ABC'
                        ),
                        
                        new Account_Details__c(Name = '0000147163', Balance__c = 0.00, Combined_Account_ID__c = '0000147163S0100P0100', ID1__c = '0100', Onboarded__c = true, RecType__c = 'CARD', TypeTranslate__c = '1-PRIMARY SHARE',WARNING_01_CODE__c='ABC',
                        WARNING_02_CODE__c='ABC',
                        WARNING_03_CODE__c='ABC',
                        WARNING_04_CODE__c='ABC',
                        WARNING_05_CODE__c='ABC',
                        WARNING_06_CODE__c='ABC',
                        WARNING_07_CODE__c='ABC',
                        WARNING_08_CODE__c='ABC',
                        WARNING_09_CODE__c='ABC',
                        WARNING_10_CODE__c='ABC',
                        WARNING_11_CODE__c='ABC',
                        WARNING_12_CODE__c='ABC',
                        WARNING_13_CODE__c='ABC',
                        WARNING_14_CODE__c='ABC',
                        WARNING_15_CODE__c='ABC',
                        WARNING_16_CODE__c='ABC',
                        WARNING_17_CODE__c='ABC',
                        WARNING_18_CODE__c='ABC',
                        WARNING_19_CODE__c='ABC',
                        WARNING_20_CODE__c='ABC',
                        Comment_Block_01__c='ABC',
                        Comment_Block_02__c='ABC',
                        Comment_Block_03__c='ABC',
                        Comment_Block_04__c='ABC',
                        Comment_Block_05__c='ABC',
                        Comment_Block_06__c='ABC',
                        Comment_Block_07__c='ABC',
                        Comment_Block_08__c='ABC',
                        Comment_Block_09__c='ABC',
                        Comment_Block_10__c='ABC',
                        Comment_Block_11__c='ABC',
                        Comment_Block_12__c='ABC',
                        Comment_Block_13__c='ABC',
                        Comment_Block_14__c='ABC',
                        Comment_Block_15__c='ABC',
                        Comment_Block_16__c='ABC',
                        Comment_Block_17__c='ABC',
                        Comment_Block_18__c='ABC',
                        Comment_Block_19__c='ABC',
                        Comment_Block_20__c='ABC'
                        )
            };
						

	Insert account_details_Obj;
		    
	Account account_Obj = new Account(LastName = 'BANDATest', FirstName = 'MARIATest', Type = 'null', PersonHasOptedOutOfEmail = false, NA_Eligibility__c = false, NA_LEAV_Complete__c = true, NA_LECF_Complete__c = true, NA_LECP_Complete__c = true, NA_LEEM_Complete__c = true, NA_LEHS_Complete__c = true, NA_LEMD_Complete__c = false, NA_LEMP_Complete__c = false, NA_LEMQ_Complete__c = true, NA_LEOL_Complete__c = true, NA_LEOM_Complete__c = true, NA_LEPT_Complete__c = true, NA_LESB_Complete__c = false, NA_LESF_Complete__c = true, NA_LEWS_Complete__c = true, NA_Opt_Out__c = false, smagicinteract__SMSOptOut__pc = false, et4ae5__HasOptedOutOfMobile__pc = false);
    Insert account_Obj; 
    
    Account_Details__c obj = [select id from Account_Details__c where id =: account_details_Obj[0].id];
    
    List<Person_Account__c> person_obj= new List<Person_Account__c>{
            new Person_Account__c(TypeTranslate__c='0000/Primary',Account_Number__c = account_details_Obj[0].id, PersonID__c = account_Obj.Id), 
            new Person_Account__c(TypeTranslate__c='0000/Primary',Account_Number__c = account_details_Obj[0].Id, PersonID__c = account_Obj.Id), 
            new Person_Account__c(Account_Number__c = account_details_Obj[2].Id, PersonID__c = account_Obj.Id)};
    Insert person_obj;
		     
	Account account_Obj1 = new Account(LastName = 'BANDATest1', FirstName = 'MARIATest1', Type = 'null', PersonHasOptedOutOfEmail = false, NA_Eligibility__c = false, NA_LEAV_Complete__c = true, NA_LECF_Complete__c = true, NA_LECP_Complete__c = true, NA_LEEM_Complete__c = true, NA_LEHS_Complete__c = true, NA_LEMD_Complete__c = false, NA_LEMP_Complete__c = false, NA_LEMQ_Complete__c = true, NA_LEOL_Complete__c = true, NA_LEOM_Complete__c = true, NA_LEPT_Complete__c = true, NA_LESB_Complete__c = false, NA_LESF_Complete__c = true, NA_LEWS_Complete__c = true, NA_Opt_Out__c = false, smagicinteract__SMSOptOut__pc = false, et4ae5__HasOptedOutOfMobile__pc = false);
    Insert account_Obj1;      
	List<Person_Account__c> person_obj1= 
		new List<Person_Account__c>{new Person_Account__c(TypeTranslate__c='0000/Primary',Account_Number__c = account_details_Obj[1].Id, PersonID__c = account_Obj.Id), 
		new Person_Account__c(TypeTranslate__c='0000/Primary',Account_Number__c = account_details_Obj[2].Id, PersonID__c = account_Obj1.Id)};
	Insert person_obj1; 	
		    	
	List<Case> case_Obj = new List<Case>{
        new Case(Status = 'In Process', Origin = null, Subject = 'Test', ClosedDate = null, IsEscalated = false, AccountId = account_Obj.Id, Account_Number__c = account_details_Obj[0].Id, Additional_Documents__c = false, Staff_Escalated__c = false, Five_Day_Flag__c = false, IsMarkDeleted__c = false, IsMarkRead__c = false, IsMarkSaved__c = false, Primary_Category__c = 'Account Maintenance', Secondary_Category__c = 'Account Services', Tertiary_Category__c = 'Extended Check Hold', MaritzCX__Response_Deleted_From_MaritzCX__c = false, SLATemp__c = false),
        new Case(Status = 'In Process', Origin = null, Subject = 'Test', ClosedDate = null, IsEscalated = false, AccountId = account_Obj.Id, Account_Number__c = account_details_Obj[0].Id, Additional_Documents__c = false, Staff_Escalated__c = false, Five_Day_Flag__c = false, IsMarkDeleted__c = false, IsMarkRead__c = false, IsMarkSaved__c = false, Primary_Category__c = 'Account Maintenance', Secondary_Category__c = 'Account Services', Tertiary_Category__c = 'Extended Check Hold', MaritzCX__Response_Deleted_From_MaritzCX__c = false, SLATemp__c = false),
		new Case(Status = 'In Process', Origin = null, Subject = 'Test', ClosedDate = null, IsEscalated = false, AccountId = account_Obj.Id, Account_Number__c = account_details_Obj[0].Id, Additional_Documents__c = false, Staff_Escalated__c = false, Five_Day_Flag__c = false, IsMarkDeleted__c = false, IsMarkRead__c = false, IsMarkSaved__c = false, Primary_Category__c = 'Account Maintenance', Secondary_Category__c = 'Account Services', Tertiary_Category__c = 'Extended Check Hold', MaritzCX__Response_Deleted_From_MaritzCX__c = false, SLATemp__c = false),
		new Case(Status = 'In Process', Origin = null, Subject = 'Test', ClosedDate = null, IsEscalated = false,AccountId = account_Obj.Id,  Account_Number__c = account_details_Obj[0].Id, Additional_Documents__c = false, Staff_Escalated__c = false, Five_Day_Flag__c = false, IsMarkDeleted__c = false, IsMarkRead__c = false, IsMarkSaved__c = false, Primary_Category__c = 'Account Maintenance', Secondary_Category__c = 'Account Services', Tertiary_Category__c = 'Extended Check Hold', MaritzCX__Response_Deleted_From_MaritzCX__c = false, SLATemp__c = false)		    
    };                     
           
        
         /*CaseAccountMemberDetail__c camd2 = new CaseAccountMemberDetail__c();
        camd1.Account_Name__c = account_details_Obj[1].Name;
        camd1.Case__c = case_Obj[0].id;
        camd1.MemberAccountid__c = account_details_Obj[1].Id;
        
        insert camd2;*/
             /* List<Case> case_Obj = new List<Case>();
              
              Case cs1 = new Case(Status = 'In Process', Origin = null, Subject = 'Test', ClosedDate = null, IsEscalated = false, AccountId = account_Obj.Id, Account_Number__c = account_details_Obj[0].Id, Additional_Documents__c = false, Staff_Escalated__c = false, Five_Day_Flag__c = false, IsMarkDeleted__c = false, IsMarkRead__c = false, IsMarkSaved__c = false, Primary_Category__c = 'Account Maintenance', Secondary_Category__c = 'Account Services', Tertiary_Category__c = 'Extended Check Hold', MaritzCX__Response_Deleted_From_MaritzCX__c = false, SLATemp__c = false);
              Case cs2 = new Case(Status = 'In Process', Origin = null, Subject = 'Test', ClosedDate = null, IsEscalated = false, AccountId = account_Obj.Id, Account_Number__c = account_details_Obj[0].Id, Additional_Documents__c = false, Staff_Escalated__c = false, Five_Day_Flag__c = false, IsMarkDeleted__c = false, IsMarkRead__c = false, IsMarkSaved__c = false, Primary_Category__c = 'Account Maintenance', Secondary_Category__c = 'Account Services', Tertiary_Category__c = 'Extended Check Hold', MaritzCX__Response_Deleted_From_MaritzCX__c = false, SLATemp__c = false);
              Case cs3 = new Case(Status = 'In Process', Origin = null, Subject = 'Test', ClosedDate = null, IsEscalated = false, AccountId = account_Obj.Id, Account_Number__c = account_details_Obj[0].Id, Additional_Documents__c = false, Staff_Escalated__c = false, Five_Day_Flag__c = false, IsMarkDeleted__c = false, IsMarkRead__c = false, IsMarkSaved__c = false, Primary_Category__c = 'Account Maintenance', Secondary_Category__c = 'Account Services', Tertiary_Category__c = 'Extended Check Hold', MaritzCX__Response_Deleted_From_MaritzCX__c = false, SLATemp__c = false);
              Case cs4 = new Case(Status = 'In Process', Origin = null, Subject = 'Test', ClosedDate = null, IsEscalated = false,AccountId = account_Obj.Id,  Account_Number__c = account_details_Obj[0].Id, Additional_Documents__c = false, Staff_Escalated__c = false, Five_Day_Flag__c = false, IsMarkDeleted__c = false, IsMarkRead__c = false, IsMarkSaved__c = false, Primary_Category__c = 'Account Maintenance', Secondary_Category__c = 'Account Services', Tertiary_Category__c = 'Extended Check Hold', MaritzCX__Response_Deleted_From_MaritzCX__c = false, SLATemp__c = false);
              
              case_Obj.Add(cs1);
              case_Obj.Add(cs2);
              case_Obj.Add(cs3);
              case_Obj.Add(cs4);*/
                         
			  Insert case_Obj;
              
              /*    CaseAccountMemberDetail__c camd1 = new CaseAccountMemberDetail__c();
                camd1.Account_Name__c = account_details_Obj[1].Name;
                camd1.Case__c = case_Obj[0].id;
                camd1.MemberAccountid__c = account_details_Obj[1].Id;
                
                insert camd1;*/
              
		List<CaseComment> CaseComment_Obj = new List<CaseComment>{		 
						new CaseComment(CommentBody='test', IsPublished = true,ParentId=case_Obj[0].Id),
						new CaseComment(CommentBody='test1', IsPublished = true,ParentId=case_Obj[0].Id),
						new CaseComment(CommentBody='test2', IsPublished = true,ParentId=case_Obj[0].Id),
						new CaseComment(CommentBody='test3', IsPublished = true,ParentId=case_Obj[0].Id),
						
						new CaseComment(CommentBody='test', IsPublished = true,ParentId=case_Obj[1].Id),
						new CaseComment(CommentBody='test1', IsPublished = true,ParentId=case_Obj[1].Id)
						
							    
						};
              
            /*  List<CaseComment> CaseComment_Obj = new List<CaseComment>();
              
              CaseComment cm1 = new CaseComment(CommentBody='test', IsPublished = true,ParentId=case_Obj[0].Id);
              CaseComment cm2 = new CaseComment(CommentBody='test1', IsPublished = true,ParentId=case_Obj[0].Id);
			  CaseComment cm3 =	new CaseComment(CommentBody='test2', IsPublished = true,ParentId=case_Obj[0].Id);
			  CaseComment cm4 =	new CaseComment(CommentBody='test3', IsPublished = true,ParentId=case_Obj[0].Id);
			  CaseComment cm5 =	new CaseComment(CommentBody='test', IsPublished = true,ParentId=case_Obj[1].Id);
			  CaseComment cm6 =	new CaseComment(CommentBody='test1', IsPublished = true,ParentId=case_Obj[1].Id);
              CaseComment_Obj.Add(cm1);
              CaseComment_Obj.Add(cm2);
              CaseComment_Obj.Add(cm3);
              CaseComment_Obj.Add(cm4);
              CaseComment_Obj.Add(cm5);
              CaseComment_Obj.Add(cm6);
              */
                            TEst.starttest();
			insert CaseComment_Obj;
	
			List<Task> task_Obj = new List<Task>{		 
						new Task(Subject='test', Description='Description',Status = 'Open',WhatId=case_Obj[0].Id),
						new Task(Subject='test1', Description='Description',Status = 'Open',WhatId=case_Obj[0].Id),
						new Task(Subject='test2', Description='Description',Status = 'Open',WhatId=case_Obj[0].Id),
						new Task(Subject='test3', Description='Description',Status = 'Open',WhatId=case_Obj[0].Id),
						
						new Task(Subject='test', Description='Description',Status = 'Open',WhatId=case_Obj[1].Id),
						new Task(Subject='test1', Description='Description',Status = 'Open',WhatId=case_Obj[1].Id)
						
							    
						};
             /* List<Task> task_Obj = new List<Task>();
              Task t1 = new Task(Subject='test', Description='Description',Status = 'Open',WhatId=case_Obj[0].Id);
              Task t2 = new Task(Subject='test1', Description='Description',Status = 'Open',WhatId=case_Obj[0].Id);
			  Task t3 = new Task(Subject='test2', Description='Description',Status = 'Open',WhatId=case_Obj[0].Id);
			  Task t4 =	new Task(Subject='test3', Description='Description',Status = 'Open',WhatId=case_Obj[0].Id);
			  Task t5 =	new Task(Subject='test', Description='Description',Status = 'Open',WhatId=case_Obj[1].Id);
			  Task t6 =	new Task(Subject='test1', Description='Description',Status = 'Open',WhatId=case_Obj[1].Id);
              task_Obj.Add(t1);
              task_Obj.Add(t2);
              task_Obj.Add(t3);
              task_Obj.Add(t4);
              task_Obj.Add(t5);
              task_Obj.Add(t6);*/
			  insert task_Obj;
			
		/*	
			
			List<Case> case_Obj1 = new List<Case>{
		    new Case(Status = 'In Process', Origin = null, Subject = 'Test', ClosedDate = null, IsEscalated = false, AccountId = account_Obj1.Id, Account_Number__c = account_details_Obj[1].Id, Additional_Documents__c = false, Staff_Escalated__c = false, Five_Day_Flag__c = false, IsMarkDeleted__c = false, IsMarkRead__c = false, IsMarkSaved__c = false, Primary_Category__c = 'Account Maintenance', Secondary_Category__c = 'Account Services', Tertiary_Category__c = 'Extended Check Hold', MaritzCX__Response_Deleted_From_MaritzCX__c = false, SLATemp__c = false),
		    new Case(Status = 'In Process', Origin = null, Subject = 'Test', ClosedDate = null, IsEscalated = false, AccountId = account_Obj1.Id, Account_Number__c = account_details_Obj[1].Id, Additional_Documents__c = false, Staff_Escalated__c = false, Five_Day_Flag__c = false, IsMarkDeleted__c = false, IsMarkRead__c = false, IsMarkSaved__c = false, Primary_Category__c = 'Account Maintenance', Secondary_Category__c = 'Account Services', Tertiary_Category__c = 'Extended Check Hold', MaritzCX__Response_Deleted_From_MaritzCX__c = false, SLATemp__c = false),
		    new Case(Status = 'In Process', Origin = null, Subject = 'Test', ClosedDate = null, IsEscalated = false, AccountId = account_Obj1.Id, Account_Number__c = account_details_Obj[1].Id, Additional_Documents__c = false, Staff_Escalated__c = false, Five_Day_Flag__c = false, IsMarkDeleted__c = false, IsMarkRead__c = false, IsMarkSaved__c = false, Primary_Category__c = 'Account Maintenance', Secondary_Category__c = 'Account Services', Tertiary_Category__c = 'Extended Check Hold', MaritzCX__Response_Deleted_From_MaritzCX__c = false, SLATemp__c = false),
		    new Case(Status = 'In Process', Origin = null, Subject = 'Test', ClosedDate = null, IsEscalated = false, AccountId = account_Obj1.Id,  Account_Number__c = account_details_Obj[1].Id, Additional_Documents__c = false, Staff_Escalated__c = false, Five_Day_Flag__c = false, IsMarkDeleted__c = false, IsMarkRead__c = false, IsMarkSaved__c = false, Primary_Category__c = 'Account Maintenance', Secondary_Category__c = 'Account Services', Tertiary_Category__c = 'Extended Check Hold', MaritzCX__Response_Deleted_From_MaritzCX__c = false, SLATemp__c = false)
		    
                };   
            */  
        /*   List<Case> case_Obj1 = new List<Case>();
          Case cs5 = new Case(Status = 'In Process', Origin = null, Subject = 'Test', ClosedDate = null, IsEscalated = false, AccountId = account_Obj1.Id, Account_Number__c = account_details_Obj[1].Id, Additional_Documents__c = false, Staff_Escalated__c = false, Five_Day_Flag__c = false, IsMarkDeleted__c = false, IsMarkRead__c = false, IsMarkSaved__c = false, Primary_Category__c = 'Account Maintenance', Secondary_Category__c = 'Account Services', Tertiary_Category__c = 'Extended Check Hold', MaritzCX__Response_Deleted_From_MaritzCX__c = false, SLATemp__c = false);
		  Case cs6 = new Case(Status = 'In Process', Origin = null, Subject = 'Test', ClosedDate = null, IsEscalated = false, AccountId = account_Obj1.Id, Account_Number__c = account_details_Obj[1].Id, Additional_Documents__c = false, Staff_Escalated__c = false, Five_Day_Flag__c = false, IsMarkDeleted__c = false, IsMarkRead__c = false, IsMarkSaved__c = false, Primary_Category__c = 'Account Maintenance', Secondary_Category__c = 'Account Services', Tertiary_Category__c = 'Extended Check Hold', MaritzCX__Response_Deleted_From_MaritzCX__c = false, SLATemp__c = false);
		  Case cs7 = new Case(Status = 'In Process', Origin = null, Subject = 'Test', ClosedDate = null, IsEscalated = false, AccountId = account_Obj1.Id, Account_Number__c = account_details_Obj[1].Id, Additional_Documents__c = false, Staff_Escalated__c = false, Five_Day_Flag__c = false, IsMarkDeleted__c = false, IsMarkRead__c = false, IsMarkSaved__c = false, Primary_Category__c = 'Account Maintenance', Secondary_Category__c = 'Account Services', Tertiary_Category__c = 'Extended Check Hold', MaritzCX__Response_Deleted_From_MaritzCX__c = false, SLATemp__c = false);
		  Case cs8 = new Case(Status = 'In Process', Origin = null, Subject = 'Test', ClosedDate = null, IsEscalated = false, AccountId = account_Obj1.Id,  Account_Number__c = account_details_Obj[1].Id, Additional_Documents__c = false, Staff_Escalated__c = false, Five_Day_Flag__c = false, IsMarkDeleted__c = false, IsMarkRead__c = false, IsMarkSaved__c = false, Primary_Category__c = 'Account Maintenance', Secondary_Category__c = 'Account Services', Tertiary_Category__c = 'Extended Check Hold', MaritzCX__Response_Deleted_From_MaritzCX__c = false, SLATemp__c = false);

         case_Obj1.Add(cs5);
         case_Obj1.Add(cs6);
         case_Obj1.Add(cs7);
         case_Obj1.Add(cs8);
           */   
	/*	 Insert case_Obj1;
		List<CaseComment> CaseComment_Obj1 = new List<CaseComment>{		 
						new CaseComment(CommentBody='test', IsPublished = true,ParentId=case_Obj1[0].Id),
						new CaseComment(CommentBody='test1', IsPublished = true,ParentId=case_Obj1[0].Id),
						new CaseComment(CommentBody='test2', IsPublished = true,ParentId=case_Obj1[0].Id),
						new CaseComment(CommentBody='test3', IsPublished = true,ParentId=case_Obj1[0].Id),
						
						new CaseComment(CommentBody='test', IsPublished = true,ParentId=case_Obj1[1].Id),
						new CaseComment(CommentBody='test1', IsPublished = true,ParentId=case_Obj1[1].Id)
						
							    
						};
			insert CaseComment_Obj1;
			
			List<Task> task_Obj1 = new List<Task>{		 
						new Task(Subject='test', Description='Description',Status = 'Open',WhatId=case_Obj1[0].Id),
						new Task(Subject='test1', Description='Description',Status = 'Open',WhatId=case_Obj1[0].Id),
						new Task(Subject='test2', Description='Description',Status = 'Open',WhatId=case_Obj1[0].Id),
						new Task(Subject='test3', Description='Description',Status = 'Open',WhatId=case_Obj1[0].Id),
						
						new Task(Subject='test', Description='Description',Status = 'Open',WhatId=case_Obj1[1].Id),
						new Task(Subject='test1', Description='Description',Status = 'Open',WhatId=case_Obj1[1].Id)
						
							    
						};
			insert task_Obj1;*/
			TEst.stoptest();	
		    
  }
 static testMethod void GetAllDataTest() {
 	TEst.starttest();
 	List<Account> obj = [select id from Account limit 2];
 	Memeber360ViewLightningController.GetAllData(obj[0].Id);
 	Memeber360ViewLightningController.GetAllData(obj[1].Id);
 TEst.stoptest();
 }   
 
 static testmethod void GetAccountPaggingDataTest()
 {
 	TEst.starttest();
 	List<Account> obj = [select Id from Account limit 2];
 	
 	Memeber360ViewLightningController.GetPagingData(obj[0].Id,1,10,'accList','','','test');
 	Memeber360ViewLightningController.GetPagingData(obj[0].Id,1,10,'accList','Name','ASC','08/08/2012');
     
 	Memeber360ViewLightningController.GetPagingData(obj[0].Id,1,10,'cardList','','','test');
 	Memeber360ViewLightningController.GetPagingData(obj[0].Id,1,10,'cardList','Name','ASC','08/08/2012');
 	
 	Memeber360ViewLightningController.GetPagingData(obj[0].Id,1,10,'related persons','','','test');
 	Memeber360ViewLightningController.GetPagingData(obj[0].Id,1,10,'related persons','TypeTranslate__c','ASC','08/08/2012');
 	
 	Memeber360ViewLightningController.GetPagingData(obj[1].Id,1,10,'accList','','','test');
 	Memeber360ViewLightningController.GetPagingData(obj[1].Id,1,10,'accList','Name','ASC','08/08/2012');
     
 	Memeber360ViewLightningController.GetPagingData(obj[1].Id,1,10,'cardList','','','test');
 	Memeber360ViewLightningController.GetPagingData(obj[1].Id,1,10,'cardList','Name','ASC','08/08/2012');
 	
 	Memeber360ViewLightningController.GetPagingData(obj[1].Id,1,10,'related persons','','','test');
 	Memeber360ViewLightningController.GetPagingData(obj[1].Id,1,10,'related persons','TypeTranslate__c','ASC','08/08/2012');
    	TEst.stoptest();
 }
 
  static testmethod void GetCasesPaggingDataTest()
  {
  	Test.starttest();
  	List<Account> obj = [select Id from Account limit 2];
  		
  	Memeber360ViewLightningController.GetPagingData(obj[0].Id,1,10,'active cases','','','test');
 	Memeber360ViewLightningController.GetPagingData(obj[0].Id,1,10,'active cases','CaseNumber','ASC','08/08/2012');
     
	Memeber360ViewLightningController.GetPagingData(obj[0].Id,1,10,'close cases','','','test');
 	Memeber360ViewLightningController.GetPagingData(obj[0].Id,1,10,'close cases','CaseNumber','ASC','08/08/2012');
     
	Memeber360ViewLightningController.GetPagingData(obj[0].Id,1,10,'Case Comments','AccountNumberName','Desc','test');
 	Memeber360ViewLightningController.GetPagingData(obj[0].Id,1,10,'Case Comments','AccountName','ASC','08/08/2012');
 	
 	
 	//Memeber360ViewLightningController.GetPagingData(obj[1].Id,1,10,'active cases','','','test');
 	Memeber360ViewLightningController.GetPagingData(obj[1].Id,1,10,'active cases','CaseNumber','ASC','08/08/2012');
     
	//Memeber360ViewLightningController.GetPagingData(obj[1].Id,1,10,'close cases','','','test');
 	//Memeber360ViewLightningController.GetPagingData(obj[1].Id,1,10,'close cases','CaseNumber','ASC','08/08/2012');
     
	//Memeber360ViewLightningController.GetPagingData(obj[1].Id,1,10,'Case Comments','AccountNumberName','Desc','test');
	TEst.stoptest();

  }
  
  static testmethod void GetTasksPaggingDataTest()
  {
  	TEst.starttest();
  	List<Account> obj = [select Id from Account limit 2];
  	
  	Memeber360ViewLightningController.GetPagingData(obj[0].Id,1,10,'Active Tasks','AccountNumberName','Asc','test');
 	Memeber360ViewLightningController.GetPagingData(obj[0].Id,1,10,'Active Tasks','AccountName','Asc','08/08/2012');
 	
 	Memeber360ViewLightningController.GetPagingData(obj[1].Id,1,10,'Active Tasks','AccountNumberName','Asc','test');
 	Memeber360ViewLightningController.GetPagingData(obj[1].Id,1,10,'Active Tasks','AccountName','Asc','08/08/2012');
 	
 		Memeber360ViewLightningController.GetPagingData(obj[1].Id,1,10,'Case Comments','AccountName','ASC','08/08/2012');
 		TEst.stoptest();
  }
  
  static testmethod void GetWarningCommentsPaggingDataTest()
  {
  	  	TEst.starttest();
  	List<Account> obj = [select Id from Account limit 2];
  	
  	Memeber360ViewLightningController.GetPagingData(obj[0].Id,1,10,'Warning/Comments','accNum','asc','Comments');
 	Memeber360ViewLightningController.GetPagingData(obj[0].Id,1,10,'Warning/Comments','tpeTrans','asc','08/08/2012');
	Memeber360ViewLightningController.GetPagingData(obj[0].Id,1,10,'Warning/Comments','shareNo','asc','Comments');
 	Memeber360ViewLightningController.GetPagingData(obj[0].Id,1,10,'Warning/Comments','recTpe','asc','08/08/2012');
 	
 	
 	Memeber360ViewLightningController.GetPagingData(obj[1].Id,1,10,'Warning/Comments','accNum','asc','Comments');
 	Memeber360ViewLightningController.GetPagingData(obj[1].Id,1,10,'Warning/Comments','tpeTrans','asc','08/08/2012');
	Memeber360ViewLightningController.GetPagingData(obj[1].Id,1,10,'Warning/Comments','shareNo','asc','Comments');
 	Memeber360ViewLightningController.GetPagingData(obj[1].Id,1,10,'Warning/Comments','recTpe','asc','08/08/2012');
 	TEst.stoptest();
  }
}