@isTest
public class AdvancedSearchControllerTest
{
	
	
	
	// Test Method: getMemberAccounts
	public static testmethod void Test_getMemberAccounts(){
		test.StartTest();
		string firstnamequery = 'Maria';
		string lastnamequery = 'Banda';
		string ssnlast4query = '8184';
		string membercityquery = 'KATY';
		string memberstatequery = 'TX';
		
		System.Assert(AdvancedSearchController.getMemberAccounts(firstnamequery, lastnamequery, ssnlast4query, membercityquery, memberstatequery) != null);
		test.StopTest();
	}
	// Test Method: getAccountDetails
	public static testmethod void Test_getAccountDetails(){
		test.StartTest();
		string membernumberquery = '0260049344';
		string cardnamequery = 'Test';
		string cardnumberquery = '4111111111111111';
		string vinquery = 'Test';
		string loannumberquery = '0852440140';
		string propertyaddressquery = 'Test';
		string propertycityquery = 'KATY';
		string propertystatequery = 'TX';
		string propertyzipquery = 'Test';
		
		System.Assert(AdvancedSearchController.getAccountDetails(membernumberquery, cardnamequery, cardnumberquery, vinquery, loannumberquery, propertyaddressquery, propertycityquery, propertystatequery, propertyzipquery) != null);
		test.StopTest();
	}
}