@isTest
private class LeadBusinessHoursControllerTest
{
	static testMethod void testMethod1(){
	
	Lead led = new Lead();
	led.lastname= 'test';
	led.status= 'open';
	led.Product_Type__c= 'cards';
	led.Brand__c= 'CFCU';
	led.Lead_Type__c='Business';
	insert led;
	
	OpenHours__c ld = new OpenHours__c();
	ld.Open_Hours__c= 60;
	ld.leadID__C= led.ID ;
	insert ld;
	
	PageReference pageRef = Page.Lead_Business_Hours;
    Test.setCurrentPage(pageRef);        
    ApexPages.currentPage().getParameters().put('Id', led.Id);   
    LeadBusinessHoursController controller = new LeadBusinessHoursController(new ApexPages.StandardController(led));
   
        
        
	}
}