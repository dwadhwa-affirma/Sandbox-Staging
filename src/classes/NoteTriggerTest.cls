@isTest
public class NoteTriggerTest {
   public static testMethod void testMethod1(){
   		Lead led = new Lead();
	led.lastname= 'test';
	led.status= 'open';
	led.Product_Type__c= 'cards';
    led.Product_Subtype__c = 'Credit Cards' ;
	led.Brand__c= 'CFCU';
	led.Lead_Type__c='Business';
	insert led;
	
   	
   	
    	Note obj = new Note();
    	obj.Title = 'Test';
    	obj.Body = 'sdfasfda';
    	obj.ParentId = led.Id;
    	insert obj;
    	obj.Title = 'Test1';
    	try
    	{
    	update obj;
    	}
    	catch(exception ex)
    	{
    		
    	}
    }
}