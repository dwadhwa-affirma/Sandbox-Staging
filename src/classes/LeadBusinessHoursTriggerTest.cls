@isTest
public class LeadBusinessHoursTriggerTest {
	static testMethod void LeadBusinessHoursTriggerTest(){
		
    	Group g1 = new Group(Name='Branch 14 - 1600 Smith Queue', type='Queue');
            insert g1;
        Group g2 = new Group(Name='Products & Services Referral Queue', type='Queue',Email ='cards_accounts_shares@opportunity.com');
            insert g2;
      
      /*  Lead_Queue__c lq = new Lead_Queue__c();
        lq.Episys_User_Branch_Name__c = '14 1600 Smith';
        lq.Lead_Queue_Name__c = 'Branch 14 - 1600 Smith Queue';
        insert lq;*/
       
         User ur = [select id,name,alias from user where id=:UserInfo.getUserID()];
         Episys_User__c eu = new Episys_User__c();
             eu.Episys_ID__c = 1;
             eu.Episys_Name__c = 'test';
             eu.Assigned_Branch__c =14;
             eu.alias__c = ur.alias;
        insert eu;
       
        Episys_User__c eu1 = new Episys_User__c();
             eu1.Episys_ID__c = 2;
        	 eu1.alias__c = ur.alias;
             eu1.Episys_Name__c = 'test';
             eu1.Assigned_Branch__c =14;
             eu1.Default__c = true;
        insert eu1;
            
            
         Lead newlead = new Lead(LastName = 'LastName268', Status = 'New', HasOptedOutOfEmail = false, IsConverted = false, IsUnreadByOwner = false, 
                       smagicinteract__SMSOptOut__c = false, Escalated__c = false, Membership_Required_old__c = false, Keep__c = false, et4ae5__HasOptedOutOfMobile__c = false, Episys_Flag__c = false,
                                temp__c = false, Episys_User_ID__c= 1,LeadSource = 'Other', Product_Type__c ='Cards', Product_Subtype__c = 'Credit Cards');
         Lead newlead1 = new Lead(LastName = 'LastName268', Status = 'New', HasOptedOutOfEmail = false, IsConverted = false, IsUnreadByOwner = false, 
                       smagicinteract__SMSOptOut__c = false, Escalated__c = false, Membership_Required_old__c = false, Keep__c = false, et4ae5__HasOptedOutOfMobile__c = false, Episys_Flag__c = false,
                                temp__c = false, Episys_User_ID__c= 1,LeadSource = 'Branch Walk in', Product_Type__c ='Cards',Product_Subtype__c = 'Credit Cards');
        Lead newlead2 = new Lead(LastName = 'LastName269', Status = 'Prospect Considering', HasOptedOutOfEmail = false, IsConverted = false, IsUnreadByOwner = false, 
                       smagicinteract__SMSOptOut__c = false, Escalated__c = false, Membership_Required_old__c = false, Keep__c = false, et4ae5__HasOptedOutOfMobile__c = false, Episys_Flag__c = false,
                                temp__c = false, Episys_User_ID__c= 1,LeadSource = 'Branch Walk in', Product_Type__c ='Cards',Product_Subtype__c = 'Credit Cards');
         Lead newlead3 = new Lead(LastName = 'LastName268', Status = 'Prospect Considering', HasOptedOutOfEmail = false, IsConverted = false, IsUnreadByOwner = false, 
                       smagicinteract__SMSOptOut__c = false, Escalated__c = false, Membership_Required_old__c = false, Keep__c = false, et4ae5__HasOptedOutOfMobile__c = false, Episys_Flag__c = false,
                                temp__c = false, Episys_User_ID__c= 1033,LeadSource = 'Branch Walk in', Product_Type__c ='Cards',Product_Subtype__c = 'Credit Cards');
         Lead newlead4 = new Lead(LastName = 'LastName270', Status = 'Closed - Converted', HasOptedOutOfEmail = false, IsConverted = false, IsUnreadByOwner = false, 
                       smagicinteract__SMSOptOut__c = false, Escalated__c = false, Membership_Required_old__c = false, Keep__c = false, et4ae5__HasOptedOutOfMobile__c = false, Episys_Flag__c = false,
                                temp__c = false, Episys_User_ID__c= 1033, LeadSource = 'Branch Walk in', Product_Type__c ='Cards',Product_Subtype__c = 'Credit Cards');
        
        Lead newlead5 = new Lead(LastName = 'LastName270', Status = 'new', HasOptedOutOfEmail = false, IsConverted = false, IsUnreadByOwner = false, 
                       smagicinteract__SMSOptOut__c = false, Escalated__c = false, Membership_Required_old__c = false, Keep__c = false, et4ae5__HasOptedOutOfMobile__c = false, Episys_Flag__c = false,
                                temp__c = false, LeadSource = 'Event', Product_Type__c ='Cards',Product_Subtype__c = 'Credit Cards');
        test.StartTest();
		
    	Insert newlead; 
        Insert newlead1;
        Insert newlead2;
        Insert newlead3;
        Insert newlead4;
        Insert newlead5;
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
		
        delete eu;
      
		delete eu1; 
		test.StopTest();		
	}
    static testMethod void LeadBusinessHoursTriggerTest1(){
		test.StartTest();
        User ur = [select id,name,alias from user where id=:UserInfo.getUserID()];
       
        Group g2 = new Group(Name='Products & Services Referral Queue', type='Queue',Email ='accounts_shares@lead.com');
            insert g2;
        
        Lead newlead5 = new Lead(LastName = 'LastName270', Status = 'new', HasOptedOutOfEmail = false, IsConverted = false, IsUnreadByOwner = false, 
                       smagicinteract__SMSOptOut__c = false, Escalated__c = false, Membership_Required_old__c = false, Keep__c = false, et4ae5__HasOptedOutOfMobile__c = false, Episys_Flag__c = false,
                                temp__c = false,  LeadSource = 'Event', Product_Type__c ='Accounts/Shares', Product_Subtype__c = 'IRA');
        Insert newlead5;
       
		
		OpenLeadBusinessHours ol = new OpenLeadBusinessHours();
		ol.execute(null);
		
		test.StopTest();		
	}
    
    
}