@isTest
public class HomeCustomLinksLightningControllerTest
{
	
	static void SetUp(){
		test.StartTest();
	}
	
	static void TearDown(){
		test.StopTest();
	}
	
	// Test Method: GetAllData
	public static testmethod void Test_GetAllData(){
		SetUp();
		
		Home_Page_Link__c home_page_link_Obj = new Home_Page_Link__c(Name = 'CFCU Links', CreatedDate = Date.ValueOf('2018-02-22 03:31:33'), LastModifiedDate = Date.ValueOf('2018-02-22 03:31:33'), Link__c = 'http://thehub.chevronfcu.org/Interact/Pages/Content/Document.aspx?id=2991', Type__c = 'CFCU');
    	Insert home_page_link_Obj; 
		
        Home_Page_Link__c home_page_link_Obj_2 = new Home_Page_Link__c(Name = 'MARS Procedures Guide', CreatedDate = Date.ValueOf('2018-02-22 03:31:33'), LastModifiedDate = Date.ValueOf('2018-02-22 03:31:33'), Link__c = 'http://thehub.chevronfcu.org/Interact/Pages/Content/Document.aspx?id=2991', Type__c = 'CFCU');
    	Insert home_page_link_Obj_2; 
		
		System.Assert(HomeCustomLinksLightningController.GetAllData() != null);
		TearDown();
	}
}