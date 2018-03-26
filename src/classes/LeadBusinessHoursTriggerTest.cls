@isTest
public class LeadBusinessHoursTriggerTest {
	static testMethod void LeadBusinessHoursTriggerTest(){
		test.StartTest();
		
		Lead newlead = new Lead(LastName = 'LastName268', Status = 'Open', HasOptedOutOfEmail = false, IsConverted = false, IsUnreadByOwner = false, 
                       smagicinteract__SMSOptOut__c = false, Escalated__c = false, Membership_Required_old__c = false, Keep__c = false, et4ae5__HasOptedOutOfMobile__c = false, Episys_Flag__c = false, temp__c = false);
    	Insert newlead; 
    	
    	OpenHours__c olc = new OpenHours__c();
    	olc.leadid__c = newlead.id;
    	Insert olc; 
		
		OpenLeadBusinessHours ol = new OpenLeadBusinessHours();
		ol.execute(null);
		
		test.StopTest();		
	}
}