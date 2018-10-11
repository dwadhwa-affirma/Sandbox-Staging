@isTest
public class LeadBusinessHoursTriggerTest {
	static testMethod void LeadBusinessHoursTriggerTest(){
		test.StartTest();
		 	
		
      
    	Group g1 = new Group(Name='Branch 14 - 1600 Smith Queue', type='Queue');
            insert g1;
        
      /*  Lead_Queue__c lq = new Lead_Queue__c();
        lq.Episys_User_Branch_Name__c = '14 1600 Smith';
        lq.Lead_Queue_Name__c = 'Branch 14 - 1600 Smith Queue';
        insert lq;*/
        
         Episys_User__c eu = new Episys_User__c();
             eu.Episys_ID__c = 1;
             eu.Episys_Name__c = 'test';
             eu.Assigned_Branch__c =14;
        insert eu;
            
            
              Lead newlead = new Lead(LastName = 'LastName268', Status = 'New', HasOptedOutOfEmail = false, IsConverted = false, IsUnreadByOwner = false, 
                       smagicinteract__SMSOptOut__c = false, Escalated__c = false, Membership_Required_old__c = false, Keep__c = false, et4ae5__HasOptedOutOfMobile__c = false, Episys_Flag__c = false,
                                temp__c = false, Episys_User_ID__c= 1,LeadSource = 'Other', Product_Type__c ='Cards');
         Lead newlead1 = new Lead(LastName = 'LastName268', Status = 'New', HasOptedOutOfEmail = false, IsConverted = false, IsUnreadByOwner = false, 
                       smagicinteract__SMSOptOut__c = false, Escalated__c = false, Membership_Required_old__c = false, Keep__c = false, et4ae5__HasOptedOutOfMobile__c = false, Episys_Flag__c = false,
                                temp__c = false, Episys_User_ID__c= 1,LeadSource = 'Branch Walk in', Product_Type__c ='Cards');
        Lead newlead2 = new Lead(LastName = 'LastName269', Status = 'Prospect Considering', HasOptedOutOfEmail = false, IsConverted = false, IsUnreadByOwner = false, 
                       smagicinteract__SMSOptOut__c = false, Escalated__c = false, Membership_Required_old__c = false, Keep__c = false, et4ae5__HasOptedOutOfMobile__c = false, Episys_Flag__c = false,
                                temp__c = false, Episys_User_ID__c= 1,LeadSource = 'Branch Walk in', Product_Type__c ='Cards');
         Lead newlead3 = new Lead(LastName = 'LastName268', Status = 'Prospect Considering', HasOptedOutOfEmail = false, IsConverted = false, IsUnreadByOwner = false, 
                       smagicinteract__SMSOptOut__c = false, Escalated__c = false, Membership_Required_old__c = false, Keep__c = false, et4ae5__HasOptedOutOfMobile__c = false, Episys_Flag__c = false,
                                temp__c = false, Episys_User_ID__c= 1033,LeadSource = 'Branch Walk in', Product_Type__c ='Cards');
         Lead newlead4 = new Lead(LastName = 'LastName270', Status = 'Closed - Converted', HasOptedOutOfEmail = false, IsConverted = false, IsUnreadByOwner = false, 
                       smagicinteract__SMSOptOut__c = false, Escalated__c = false, Membership_Required_old__c = false, Keep__c = false, et4ae5__HasOptedOutOfMobile__c = false, Episys_Flag__c = false,
                                temp__c = false, Episys_User_ID__c= 1033, LeadSource = 'Branch Walk in', Product_Type__c ='Cards');
        
    	Insert newlead; 
        Insert newlead1;
        Insert newlead2;
        Insert newlead3;
        Insert newlead4;
        try{
	        newlead4.LastName = 'Test'  ;
	        Update newlead4;
	        system.assert(true,'Lead fields are read only for Closed Leads.');
        }
        catch(Exception e)
        {
        String message = e.getMessage();
         system.assert(message.contains('Lead fields are read only for Closed Leads.'), 'message=' + message);

        }
    	OpenHours__c olc = new OpenHours__c();
    	olc.leadid__c = newlead.id;
    	Insert olc; 
		
		OpenLeadBusinessHours ol = new OpenLeadBusinessHours();
		ol.execute(null);
		
		test.StopTest();		
	}
}