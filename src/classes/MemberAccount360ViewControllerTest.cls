@isTest
public class MemberAccount360ViewControllerTest {
	
	@testSetup
		  static void setupTestData(){
		    test.startTest();
		    List<Account_Details__c> account_details_Obj = new List<Account_Details__c>{
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
)
						};
						

		    Insert account_details_Obj;
		    	Account_Details__c obj = [select id from Account_Details__c limit 1];
		    	
		List<Case> case_Obj = new List<Case>{
		    new Case(Status = 'In Process', Origin = null, Subject = 'Test', ClosedDate = null, IsEscalated = false,  Account_Number__c = obj.Id, Additional_Documents__c = false, Staff_Escalated__c = false, Five_Day_Flag__c = false, IsMarkDeleted__c = false, IsMarkRead__c = false, IsMarkSaved__c = false, Primary_Category__c = 'Account Maintenance', Secondary_Category__c = 'Account Services', Tertiary_Category__c = 'Extended Check Hold', MaritzCX__Response_Deleted_From_MaritzCX__c = false, SLATemp__c = false),
		    new Case(Status = 'In Process', Origin = null, Subject = 'Test', ClosedDate = null, IsEscalated = false,  Account_Number__c = obj.Id, Additional_Documents__c = false, Staff_Escalated__c = false, Five_Day_Flag__c = false, IsMarkDeleted__c = false, IsMarkRead__c = false, IsMarkSaved__c = false, Primary_Category__c = 'Account Maintenance', Secondary_Category__c = 'Account Services', Tertiary_Category__c = 'Extended Check Hold', MaritzCX__Response_Deleted_From_MaritzCX__c = false, SLATemp__c = false),
		    new Case(Status = 'In Process', Origin = null, Subject = 'Test', ClosedDate = null, IsEscalated = false,  Account_Number__c = obj.Id, Additional_Documents__c = false, Staff_Escalated__c = false, Five_Day_Flag__c = false, IsMarkDeleted__c = false, IsMarkRead__c = false, IsMarkSaved__c = false, Primary_Category__c = 'Account Maintenance', Secondary_Category__c = 'Account Services', Tertiary_Category__c = 'Extended Check Hold', MaritzCX__Response_Deleted_From_MaritzCX__c = false, SLATemp__c = false),
		    new Case(Status = 'In Process', Origin = null, Subject = 'Test', ClosedDate = null, IsEscalated = false,  Account_Number__c = obj.Id, Additional_Documents__c = false, Staff_Escalated__c = false, Five_Day_Flag__c = false, IsMarkDeleted__c = false, IsMarkRead__c = false, IsMarkSaved__c = false, Primary_Category__c = 'Account Maintenance', Secondary_Category__c = 'Account Services', Tertiary_Category__c = 'Extended Check Hold', MaritzCX__Response_Deleted_From_MaritzCX__c = false, SLATemp__c = false),
		    new Case(Status = 'In Process', Origin = null, Subject = 'Test', ClosedDate = null, IsEscalated = false,  Account_Number__c = obj.Id, Additional_Documents__c = false, Staff_Escalated__c = false, Five_Day_Flag__c = false, IsMarkDeleted__c = false, IsMarkRead__c = false, IsMarkSaved__c = false, Primary_Category__c = 'Account Maintenance', Secondary_Category__c = 'Account Services', Tertiary_Category__c = 'Extended Check Hold', MaritzCX__Response_Deleted_From_MaritzCX__c = false, SLATemp__c = false)
                };                
				    Insert case_Obj;
		List<CaseComment> CaseComment_Obj = new List<CaseComment>{		 
						new CaseComment(CommentBody='test', IsPublished = true,ParentId=case_Obj[0].Id),
						new CaseComment(CommentBody='test1', IsPublished = true,ParentId=case_Obj[0].Id),
						new CaseComment(CommentBody='test2', IsPublished = true,ParentId=case_Obj[0].Id),
						new CaseComment(CommentBody='test3', IsPublished = true,ParentId=case_Obj[0].Id),
						
						new CaseComment(CommentBody='test', IsPublished = true,ParentId=case_Obj[1].Id),
						new CaseComment(CommentBody='test1', IsPublished = true,ParentId=case_Obj[1].Id),
						new CaseComment(CommentBody='test2', IsPublished = true,ParentId=case_Obj[1].Id),
						new CaseComment(CommentBody='test3', IsPublished = true,ParentId=case_Obj[1].Id)
							    
						};
			insert CaseComment_Obj;
		    test.stopTest();
  }
 static testMethod void GetAllDataTest() {
 	
 	Account_Details__c obj = [select id from Account_Details__c limit 1];
 	 test.startTest();
 	MemberAccountWrapperFor360ViewController.GetAllData(obj.Id);
 	
 	MemberAccountWrapperFor360ViewController.GetPagingData(obj.Id,1,10,'accList','','','test');
 	MemberAccountWrapperFor360ViewController.GetPagingData(obj.Id,1,10,'accList','Name','ASC','08/08/2012');
     
 	MemberAccountWrapperFor360ViewController.GetPagingData(obj.Id,1,10,'cardList','','','test');
 	MemberAccountWrapperFor360ViewController.GetPagingData(obj.Id,1,10,'cardList','Name','ASC','08/08/2012');
     
	MemberAccountWrapperFor360ViewController.GetPagingData(obj.Id,1,10,'related persons','','','test');
 	MemberAccountWrapperFor360ViewController.GetPagingData(obj.Id,1,10,'related persons','TypeTranslate__c','ASC','08/08/2012');
     
	MemberAccountWrapperFor360ViewController.GetPagingData(obj.Id,1,10,'active cases','','','test');
 	MemberAccountWrapperFor360ViewController.GetPagingData(obj.Id,1,10,'active cases','CaseNumber','ASC','08/08/2012');
     
	MemberAccountWrapperFor360ViewController.GetPagingData(obj.Id,1,10,'close cases','','','test');
 	MemberAccountWrapperFor360ViewController.GetPagingData(obj.Id,1,10,'close cases','CaseNumber','ASC','08/08/2012');
     
	MemberAccountWrapperFor360ViewController.GetPagingData(obj.Id,1,10,'Case Comments','AccountNumberName','Desc','test');
 	MemberAccountWrapperFor360ViewController.GetPagingData(obj.Id,1,10,'Case Comments','AccountName','ASC','08/08/2012');
     
	MemberAccountWrapperFor360ViewController.GetPagingData(obj.Id,1,10,'Active Tasks','AccountNumberName','Asc','test');
 	MemberAccountWrapperFor360ViewController.GetPagingData(obj.Id,1,10,'Active Tasks','AccountName','Asc','08/08/2012');
     
	MemberAccountWrapperFor360ViewController.GetPagingData(obj.Id,1,10,'Warning/Comments','accNum','asc','Comments');
 	MemberAccountWrapperFor360ViewController.GetPagingData(obj.Id,1,10,'Warning/Comments','tpeTrans','asc','08/08/2012');
	MemberAccountWrapperFor360ViewController.GetPagingData(obj.Id,1,10,'Warning/Comments','shareNo','asc','Comments');
 	MemberAccountWrapperFor360ViewController.GetPagingData(obj.Id,1,10,'Warning/Comments','recTpe','asc','08/08/2012');
   
         test.stopTest();  
 	
 }   
}