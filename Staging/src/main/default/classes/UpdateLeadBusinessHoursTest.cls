@isTest
public class UpdateLeadBusinessHoursTest
{	
	static testMethod void UpdateLeadBusinessHoursTest1(){
		test.StartTest();
		
		Lead newlead = new Lead(LastName = 'LastName268', Status = 'Open', HasOptedOutOfEmail = false, IsConverted = false, IsUnreadByOwner = false, 
                       smagicinteract__SMSOptOut__c = false, Escalated__c = false, Membership_Required_old__c = false, Keep__c = false, et4ae5__HasOptedOutOfMobile__c = false, Episys_Flag__c = false, temp__c = false);
    	Insert newlead; 
    	system.debug('lstLeads1===' + newlead);
        
    	UpdateLeadBusinessHours obj = new UpdateLeadBusinessHours();
        obj.startdate = system.now().adddays(-10);
        obj.enddate = system.now().adddays(1);
    	
        
    	Database.executeBatch(obj,1000);
		
		test.StopTest();		
	}		
}