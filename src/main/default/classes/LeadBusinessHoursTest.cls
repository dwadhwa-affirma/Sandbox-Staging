@istest
public with sharing class LeadBusinessHoursTest {
	@istest
    static void testMethod1(){
        RecordType recTpe = [Select Id, Name from RecordType where Name='Brand Details' Limit 1];
        Group g1 = new Group(Name='Branch 14 - 1600 Smith Queue', type='Queue');
        insert g1;
        Lead newlead = new Lead(LastName = 'LastName268', Status = 'New', HasOptedOutOfEmail = false, 
                                IsConverted = false, IsUnreadByOwner = false, smagicinteract__SMSOptOut__c = false,
                                Escalated__c = false, Membership_Required_old__c = false, Keep__c = false,
                                et4ae5__HasOptedOutOfMobile__c = false, Episys_Flag__c = false,
                                temp__c = false, Episys_User_ID__c= 1,LeadSource = 'Other', Product_Type__c ='Cards',
                                Brand__c ='Chevron');
       insert newlead;
        
       newlead.Brand__c = 'Spectrum';
       update newlead;
    }
    @istest
    static void testMethod2(){
        RecordType recTpe = [Select Id, Name from RecordType where Name='Brand Details' Limit 1];
        Group g1 = new Group(Name='Branch 14 - 1600 Smith Queue', type='Queue');
        insert g1;
        
        string uid = UserInfo.getUserId();
        User usr = [Select id, name, alias
                    from User
                    where id = :uid];
        
        Episys_User__c eu = new Episys_User__c();
        eu.Episys_ID__c = 1;
        eu.Episys_Name__c = 'test';
        eu.Assigned_Branch__c =14;
        eu.alias__c = usr.alias;
        eu.Default__c = true;
        insert eu;
        
        Lead newlead = new Lead(LastName = 'LastName268', Status = 'New', HasOptedOutOfEmail = false, 
                                
                                IsConverted = false, IsUnreadByOwner = false, smagicinteract__SMSOptOut__c = false,
                                Escalated__c = false, Membership_Required_old__c = false, Keep__c = false,
                                et4ae5__HasOptedOutOfMobile__c = false, Episys_Flag__c = false,
                                I_m_interested_in__c = 'Xpress Form - Web',temp__c = false, Episys_User_ID__c= 1,
                                LeadSource = 'Xpress Form - Web', Product_Type__c ='Cards',
                                Brand__c ='Chevron');
       insert newlead;
        
       newlead.Brand__c = 'Spectrum';
       update newlead;
    }
    @istest
    static void testMethod3(){
        RecordType recType = [Select Id, Name from RecordType where Name='Company Lead' and sObjectType='Lead' Limit 1];
        Group g1 = new Group(Name='Branch 14 - 1600 Smith Queue', type='Queue');
        insert g1;
        
        Episys_User__c eu = new Episys_User__c();
        eu.Episys_ID__c = 1;
        eu.Episys_Name__c = 'test';
        eu.Assigned_Branch__c =14;
        insert eu;
        
        Lead newlead = new Lead(LastName = 'LastName268', Status = 'New', HasOptedOutOfEmail = false,recordtypeid = recType.id,                                
                                IsConverted = false, IsUnreadByOwner = false, smagicinteract__SMSOptOut__c = false,
                                Escalated__c = false, Membership_Required_old__c = false, Keep__c = false,
                                et4ae5__HasOptedOutOfMobile__c = false, Episys_Flag__c = false,
                                I_m_interested_in__c = 'Xpress Form - Web',temp__c = false, Episys_User_ID__c= 1,
                                LeadSource = 'Xpress Form - Web', Product_Type__c ='Cards',
                                Brand__c ='Chevron');
       insert newlead;
        
       newlead.Status = 'Outreach';
       newlead.Sub_Status__c ='No Response'; 
       update newlead;
    }
    
    @istest
    static void testMethod4(){
        RecordType recType = [Select Id, Name from RecordType where Name='Company Lead' and sObjectType='Lead' Limit 1];
        Group g1 = new Group(Name='Branch 14 - 1600 Smith Queue', type='Queue');
        insert g1;
        
        Episys_User__c eu = new Episys_User__c();
        eu.Episys_ID__c = 1;
        eu.Episys_Name__c = 'test';
        eu.Assigned_Branch__c =14;
        insert eu;
        
        Lead newlead = new Lead(LastName = 'LastName268', Status = 'New', HasOptedOutOfEmail = false,
                                recordtypeid = recType.id,                                
                                IsConverted = false, IsUnreadByOwner = false, smagicinteract__SMSOptOut__c = false,
                                Escalated__c = false, Membership_Required_old__c = false, Keep__c = false,
                                et4ae5__HasOptedOutOfMobile__c = false, Episys_Flag__c = false,
                                I_m_interested_in__c = 'Xpress Form - Web',temp__c = false, Episys_User_ID__c= 1,
                                LeadSource = 'Refer a Member - Web', Product_Type__c ='Cards',
                                Brand__c ='Chevron', Referring_Member_Email__c = 'Leadtest@test.com',
                                Referring_Member_FirstName__c = 'testFN', Referring_Member_LastName__c = 'testLN');
        
       insert newlead;
       Account matchingAccounts = new Account(FirstName = 'testFN', LastName = 'testLN', PersonEmail='Leadtest@test.com');
       insert matchingAccounts;                                                        
       
    }
    @istest
    static void testMethod5(){
        RecordType recTpe = [Select Id, Name from RecordType where Name='Brand Details' Limit 1];
        Group g1 = new Group(Name='Branch 14 - 1600 Smith Queue', type='Queue');
        insert g1;
        
        string uid = UserInfo.getUserId();
        User usr = [Select id, name, alias
                    from User
                    where id = :uid];
        
        Episys_User__c eu = new Episys_User__c();
        eu.Episys_ID__c = 1;
        eu.Episys_Name__c = 'test';
        eu.Assigned_Branch__c =14;
        eu.alias__c = usr.alias;
        eu.Default__c = true;
        insert eu;
        
        Lead newlead = new Lead(LastName = 'LastName268', Status = 'New', HasOptedOutOfEmail = false, 
                                
                                IsConverted = false, IsUnreadByOwner = false, smagicinteract__SMSOptOut__c = false,
                                Escalated__c = false, Membership_Required_old__c = false, Keep__c = false,
                                et4ae5__HasOptedOutOfMobile__c = false, Episys_Flag__c = false,
                                I_m_interested_in__c = 'Xpress Form - Web',temp__c = false, 
                                LeadSource = 'Xpress Form - Web', Product_Type__c ='Cards',
                                Brand__c ='Chevron');
       insert newlead;
        
       
    }
    @istest
    static void testMethod6(){
        RecordType recTpe = [Select Id, Name from RecordType where Name='Company Lead' Limit 1];
        Group g1 = new Group(Name='Branch 14 - 1600 Smith Queue', type='Queue');
        insert g1;
        
        string uid = UserInfo.getUserId();
        User usr = [Select id, name, alias
                    from User
                    where id = :uid];
        
        Episys_User__c eu = new Episys_User__c();
        eu.Episys_ID__c = 1;
        eu.Episys_Name__c = 'test';
        eu.Assigned_Branch__c =14;
        eu.alias__c = usr.alias; 
        eu.Default__c = true;
        insert eu;
        
        Lead newlead = new Lead(LastName = 'LastName268', Status = 'New', HasOptedOutOfEmail = false, 
                                
                                IsConverted = false, IsUnreadByOwner = false, smagicinteract__SMSOptOut__c = false,
                                Escalated__c = false, Membership_Required_old__c = false, Keep__c = false,
                                et4ae5__HasOptedOutOfMobile__c = false, Episys_Flag__c = false,Episys_User_ID__c= 1,
                                I_m_interested_in__c = 'Xpress Form - Web',temp__c = false, 
                                LeadSource = 'Event', Product_Type__c ='Cards',
                                Brand__c ='Chevron', Event_Source__c ='Advantage Credit');
       insert newlead;
        
       
    }
    @istest
    static void testMethod7(){
        RecordType recTpe = [Select Id, Name from RecordType where Name='Company Lead' Limit 1];
        Group g1 = new Group(Name='Real Estate', type='Queue');
        insert g1;
        
        string uid = UserInfo.getUserId();
        User usr = [Select id, name, alias
                    from User
                    where id = :uid];
        
        Episys_User__c eu = new Episys_User__c();
        eu.Episys_ID__c = 1;
        eu.Episys_Name__c = 'test';
        eu.Assigned_Branch__c =14;
        eu.alias__c = usr.alias; 
        eu.Default__c = true;
        insert eu;
        
        Lead newlead = new Lead(LastName = 'LastName268', Status = 'New', HasOptedOutOfEmail = false, 
                                
                                IsConverted = false, IsUnreadByOwner = false, smagicinteract__SMSOptOut__c = false,
                                Escalated__c = false, Membership_Required_old__c = false, Keep__c = false,
                                et4ae5__HasOptedOutOfMobile__c = false, Episys_Flag__c = false,Episys_User_ID__c= 1,
                                I_m_interested_in__c = 'Home Loan Help Desk',temp__c = false, 
                                LeadSource = 'Real Estate help desk', Product_Type__c ='Cards',
                                Brand__c ='Chevron');
       insert newlead;
       Datetime dt = LeadTriggerService.getTimeStampFieldValue('New', newlead );
       boolean flag = LeadTriggerService.getOtherFieldsAreNull('New', newlead );
        LeadTriggerService.updateTimeStampOnOpp('New',newlead, 2.00, true);
       LeadTriggerService.updateTimeStampOnOpp('New',newlead, 2.00, false); 
    }
     @istest
    static void LeadOutreachTest(){
        
        
        Lead newlead = new Lead(LastName = 'LastName268', Status = 'Outreach', HasOptedOutOfEmail = false, 
                                
                                IsConverted = false, IsUnreadByOwner = false, smagicinteract__SMSOptOut__c = false,
                                Escalated__c = false, Membership_Required_old__c = false, Keep__c = false,
                                et4ae5__HasOptedOutOfMobile__c = false, Episys_Flag__c = false,Episys_User_ID__c= 1,
                                I_m_interested_in__c = 'Home Loan Help Desk',temp__c = false, Sub_Status__c ='No Response',
                                LeadSource = 'Real Estate help desk', Product_Type__c ='Cards',
                                Brand__c ='Chevron');
       insert newlead;
       Datetime dt = LeadTriggerService.getTimeStampFieldValue('Outreach', newlead );
       boolean flag = LeadTriggerService.getOtherFieldsAreNull('Outreach', newlead );
       LeadTriggerService.updateTimeStampOnOpp('Outreach',newlead, 2.00, true);
       LeadTriggerService.updateTimeStampOnOpp('Outreach',newlead, 2.00, false); 
    }
    @istest
    static void LeadConsideringTest(){
        
        
        Lead newlead = new Lead(LastName = 'LastName268', Status = 'Considering', HasOptedOutOfEmail = false, 
                                
                                IsConverted = false, IsUnreadByOwner = false, smagicinteract__SMSOptOut__c = false,
                                Escalated__c = false, Membership_Required_old__c = false, Keep__c = false,
                                et4ae5__HasOptedOutOfMobile__c = false, Episys_Flag__c = false,Episys_User_ID__c= 1,
                                I_m_interested_in__c = 'Home Loan Help Desk',temp__c = false, 
                                LeadSource = 'Real Estate help desk', Product_Type__c ='Cards',
                                Brand__c ='Chevron');
       insert newlead;
       Datetime dt = LeadTriggerService.getTimeStampFieldValue('Considering', newlead );
	   boolean flag = LeadTriggerService.getOtherFieldsAreNull('Considering', newlead );	
       LeadTriggerService.updateTimeStampOnOpp('Considering',newlead, 2.00, true);
       LeadTriggerService.updateTimeStampOnOpp('Considering',newlead, 2.00, false); 
    }
    @istest
    static void LeadAnalyzingNeedsTest(){
        
        
        Lead newlead = new Lead(LastName = 'LastName268', Status = 'Analyzing Needs', HasOptedOutOfEmail = false, 
                                
                                IsConverted = false, IsUnreadByOwner = false, smagicinteract__SMSOptOut__c = false,
                                Escalated__c = false, Membership_Required_old__c = false, Keep__c = false,
                                et4ae5__HasOptedOutOfMobile__c = false, Episys_Flag__c = false,Episys_User_ID__c= 1,
                                I_m_interested_in__c = 'Home Loan Help Desk',temp__c = false, 
                                LeadSource = 'Real Estate help desk', Product_Type__c ='Cards',
                                Brand__c ='Chevron',Product_Amount__c = 2.00);
       insert newlead;
       Datetime dt = LeadTriggerService.getTimeStampFieldValue('Analyzing Needs', newlead );
       boolean flag = LeadTriggerService.getOtherFieldsAreNull('Analyzing Needs', newlead );	
       LeadTriggerService.updateTimeStampOnOpp('Analyzing Needs',newlead, 2.00, true);
       LeadTriggerService.updateTimeStampOnOpp('Analyzing Needs',newlead, 2.00, false);  
    }
    
    @istest
    static void getTimeDifferenceTest(){
        LeadTriggerService.getTimeDifference(Datetime.now());
    }
   
    @istest
    static void slaLeadTest(){
        List<Lead> leadInsertList = new List<Lead>();
        Map<String, Sla_Manager__mdt> slaManagerMap = Sla_Manager__mdt.getAll();
        for(string key: slaManagerMap.keySet()){
            if(slaManagerMap.get(key).Object_Name__c == 'Lead'){
                Lead l = new Lead();
                l.LastName = 'Test';
                l.Status = slaManagerMap.get(key).StageName__c;
                if(slaManagerMap.get(key).StageName__c =='Outreach'){
                    l.Sub_Status__c ='No Response';
                }
                l.Product_Amount__c =2.00;
                if(slaManagerMap.get(key).Event_Source__c != null && slaManagerMap.get(key).Event_Source__c!= ''){
                	l.Event_Source__c = slaManagerMap.get(key).Event_Source__c;
                }else{
                    l.Event_Source__c ='Advantage Credit';
                }
                String[] source = slaManagerMap.get(key).Opportunity_Source__c.split(',');
                l.LeadSource =source[0];
                if(slaManagerMap.get(key).Product_Type__c != null && slaManagerMap.get(key).Product_Type__c != ''){
                l.Product_Type__c = slaManagerMap.get(key).Product_Type__c;
                }else{
                    l.Product_Type__c = 'Cards';
                }
                leadInsertList.add(l);
                
        	}
            
        }
        insert leadInsertList;
        List<Lead> updateLeadList = new List<Lead>();
        for(Lead l : leadInsertList ){
            if(l.Status == 'New'){
                l.Status = 'Outreach';
                l.Sub_Status__c ='No Response';
            }
            else if(l.Status =='Outreach')
            {
                l.Status = 'New';
            }
            else if(l.Status =='Considering'){
                l.Status = 'Analyzing Needs';
            }
            else if(l.Status == 'Analyzing Needs'){
                l.Status = 'Considering'; 
            }
            else{l.Status = 'New'; }
            updateLeadList.add(l);
        }
        update updateLeadList;
    }
     @istest
    static void slaLeadTest2(){
        List<Lead> leadInsertList = new List<Lead>();
        Lead newlead = new Lead(LastName = 'LastName268', Status = 'New', HasOptedOutOfEmail = false, 
                                
                                IsConverted = false, IsUnreadByOwner = false, smagicinteract__SMSOptOut__c = false,
                                Escalated__c = false, Membership_Required_old__c = false, Keep__c = false,
                                et4ae5__HasOptedOutOfMobile__c = false, Episys_Flag__c = false,Episys_User_ID__c= 1,
                                I_m_interested_in__c = 'Home Loan Help Desk',temp__c = false, 
                                LeadSource = 'Real Estate help desk', Product_Type__c ='Cards',
                                Brand__c ='Chevron', sla__c= 2.00,Product_Amount__c = 2.00);
       Lead newlead1 = new Lead(LastName = 'LastName268', Status = 'Outreach', HasOptedOutOfEmail = false, 
                                
                                IsConverted = false, IsUnreadByOwner = false, smagicinteract__SMSOptOut__c = false,
                                Escalated__c = false, Membership_Required_old__c = false, Keep__c = false,
                                et4ae5__HasOptedOutOfMobile__c = false, Episys_Flag__c = false,Episys_User_ID__c= 1,
                                I_m_interested_in__c = 'Home Loan Help Desk',temp__c = false, Sub_Status__c ='No Response',
                                LeadSource = 'Real Estate help desk', Product_Type__c ='Cards',
                                Brand__c ='Chevron', sla__c= 3.00,Product_Amount__c = 2.00);
        Lead newlead2 = new Lead(LastName = 'LastName268', Status = 'Considering', HasOptedOutOfEmail = false, 
                                
                                IsConverted = false, IsUnreadByOwner = false, smagicinteract__SMSOptOut__c = false,
                                Escalated__c = false, Membership_Required_old__c = false, Keep__c = false,
                                et4ae5__HasOptedOutOfMobile__c = false, Episys_Flag__c = false,Episys_User_ID__c= 1,
                                I_m_interested_in__c = 'Home Loan Help Desk',temp__c = false, 
                                LeadSource = 'Real Estate help desk', Product_Type__c ='Cards',
                                Brand__c ='Chevron' , sla__c= 3.00, Product_Amount__c = 2.00);
        Lead newlead3 = new Lead(LastName = 'LastName268', Status = 'Analyzing Needs', HasOptedOutOfEmail = false, 
                                
                                IsConverted = false, IsUnreadByOwner = false, smagicinteract__SMSOptOut__c = false,
                                Escalated__c = false, Membership_Required_old__c = false, Keep__c = false,
                                et4ae5__HasOptedOutOfMobile__c = false, Episys_Flag__c = false,Episys_User_ID__c= 1,
                                I_m_interested_in__c = 'Home Loan Help Desk',temp__c = false, 
                                LeadSource = 'Real Estate help desk', Product_Type__c ='Cards',
                                Brand__c ='Chevron',Product_Amount__c = 2.00 , sla__c= 3.00);
       leadInsertList.add(newlead);
       leadInsertList.add(newlead1);
       leadInsertList.add(newlead2);
       leadInsertList.add(newlead3);
       insert leadInsertList;
        List<Lead> updateLeadList = new List<Lead>();
        for(Lead l : leadInsertList ){
            if(l.Status == 'New'){
                l.Status = 'Outreach';
                l.Sub_Status__c ='No Response';
            }
            else if(l.Status =='Outreach')
            {
                l.Status = 'New';
            }
            else if(l.Status =='Considering'){
                l.Status = 'Analyzing Needs';
            }
            else if(l.Status == 'Analyzing Needs'){
                l.Status = 'Considering'; 
            }
            else{l.Status = 'New'; }
            updateLeadList.add(l);
        }
        update updateLeadList;
    }
}