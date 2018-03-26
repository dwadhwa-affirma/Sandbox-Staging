@isTest
public class CardDetailsTest {
	  static testMethod void testMethod1(){
	  	  PageReference pageRef = Page.MasterCardAlerts;
	  	   Test.setCurrentPage(pageRef);       
	  	    ApexPages.currentPage().getParameters().put('card', 'ABC');
        ApexPages.currentPage().getParameters().put('account', '1111');  
	  	 CFCU_Mastercard_Alerts__c obj = new CFCU_Mastercard_Alerts__c();
	  	 obj.Member_Number__c = 'ABC';
	  	 obj.Card_Number__c = '1111';
	  	 CardDetails controller = new CardDetails(new ApexPages.StandardController(obj)); 
	  	List<CFCU_Mastercard_Alerts__c> accList = 	controller.accList; 
	  
	  }
}