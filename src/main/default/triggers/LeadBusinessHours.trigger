trigger LeadBusinessHours on Lead(after insert, after update, before insert, before update ){
    
    Id userid = UserInfo.getUserId();
    List<User> users = [SELECT Name, UserRole.Name
                        FROM User
                        WHERE Id = :userid];
    String userRole = '';
    if (users.size() > 0){
        userRole = users[0].UserRole.Name;
    }
    
    system.debug('userRole:' + userRole);
    
    Id profileId = userinfo.getProfileId();
    String ProfileName = [Select Id, Name
                          from Profile
                          where Id = :profileId].Name;
    
    Map<ID, Schema.RecordTypeInfo> rt_Map = Lead.sObjectType.getDescribe().getRecordTypeInfosById();
    Id taskRT = Schema.SObjectType.Task.getRecordTypeInfosByName().get('SEG').getRecordTypeId();
    Id LeadRT = Schema.SObjectType.Lead.getRecordTypeInfosByName().get('Company Lead').getRecordTypeId();
    Id LeadRT2 = Schema.SObjectType.Lead.getRecordTypeInfosByName().get('Non-Member Lead').getRecordTypeId();
    system.debug('ProfileName' + ProfileName);
    List<Task> lTask = new List<Task>();
    List<Lead> leadList = new List<Lead>();
    
    boolean hasExecuted = false;
    Sla_Manager__mdt[] slaDefList;
    String NewLeadSources;
    slaDefList = [SELECT DeveloperName,Event_Source__c,Opportunity_Source__c,Product_Type__c,SLA__c,StageName__c FROM Sla_Manager__mdt WHERE Object_Name__c = 'Lead' ORDER BY DeveloperName ASC];
    NewLeadSources = slaDefList[0].Opportunity_Source__c; // First Definition is used for Lead Source Breaches
    
    if (Trigger.isAfter){
        
        List<OpenHours__c> openHours = new List<OpenHours__c>();
        for (Lead lead : Trigger.new ){
            
            if (Trigger.isInsert && Trigger.isAfter){
                system.debug('31');
                OpenHours__c obj = new OpenHours__c();
                obj.LeadId__c = lead.Id;
                obj.Open_Hours__c = 0;
                openHours.add(obj);
                
                //-------------------------------Xpress Refi Form--------------------------------------//
                
                if (lead.Episys_User_ID__c != 7002 && lead.LeadSource == 'Xpress Form - Web' && lead.I_m_interested_in__c == 'Xpress Form - Web'){
                    
                    System.debug('Calling Future class');
                    MarketingLeadCheck.LeadCheck(lead.id);
                }
            }
        }
        
        insert openHours;
        
        //------------------------------------------Task Create on "Outreach"--------------------------------//
        
        List<Id> companyLeadIds = new List<Id>();
        List<Lead> companyLeads = new List<Lead>();
        BusinessHours stdBusinessHours = [select id
                                          from businesshours
                                          where isDefault = true];
        
        if (Trigger.isUpdate){
            
            for (Lead lead : Trigger.new ){
                Lead oldLead = Trigger.oldMap.get(lead.Id);
                if (rt_map.get(lead.recordTypeID).getName().containsIgnoreCase('Company Lead') && oldLead.Status != lead.Status && lead.Status == 'Outreach'){
                    companyLeadIds.add(lead.id);
                    companyLeads.add(lead);
                }
            }
            System.debug('companyLeadIds' + companyLeadIds);
            System.debug('companyLeads' + companyLeads);
            
            List<task> tasklist = [select whoId, status
                                   from task
                                   where ActivityDate != null and whoId in:companyLeadIds];
            
            if (tasklist.size() > 0){
                delete tasklist;
            }
            
            if (companyLeads.size() > 0){
                
                for (Lead lead : companyLeads){
                    
                    Task t = new Task();
                    t.ActivityDate = Date.valueOf(BusinessHours.addgmt(stdBusinessHours.id, system.now(), 10 * 60 * 60 * 1000L));
                    t.Activity_Date_Time__c = BusinessHours.addgmt(stdBusinessHours.id, system.now(), 10 * 60 * 60 * 1000L);
                    t.OwnerId = lead.OwnerId;
                    t.Priority = 'Normal';
                    t.RecordTypeId = taskRT;
                    t.Status = 'Open';
                    t.Subject = 'Email' + ' ' + lead.FirstName + ' ' + lead.LastName;
                    t.WhoId = lead.id;
                    lTask.add(t);
                    
                    Task t1 = new Task();
                    t1.Activity_Date_Time__c = BusinessHours.addgmt(stdBusinessHours.id, system.now(), 70 * 60 * 60 * 1000L);
                    t1.ActivityDate = Date.valueOf(t1.Activity_Date_Time__c) - 1;
                    t1.OwnerId = lead.OwnerId;
                    t1.Priority = 'Normal';
                    t1.RecordTypeId = taskRT;
                    t1.Status = 'Open';
                    t1.Subject = 'LinkedIn' + ' ' + lead.FirstName + ' ' + lead.LastName;
                    t1.WhoId = lead.id;
                    lTask.add(t1);
                    
                    Task t2 = new Task();
                    t2.Activity_Date_Time__c = BusinessHours.addgmt(stdBusinessHours.id, system.now(), 140 * 60 * 60 * 1000L);
                    t2.ActivityDate = Date.valueOf(t2.Activity_Date_Time__c) - 1;
                    t2.OwnerId = lead.OwnerId;
                    t2.Priority = 'Normal';
                    t2.RecordTypeId = taskRT;
                    t2.Status = 'Open';
                    t2.Subject = 'Email / Call Voice Message' + ' ' + lead.FirstName + ' ' + lead.LastName;
                    t2.WhoId = lead.id;
                    lTask.add(t2);
                    
                    Task t3 = new Task();
                    t3.Activity_Date_Time__c = BusinessHours.addgmt(stdBusinessHours.id, system.now(), 300 * 60 * 60 * 1000L);
                    t3.ActivityDate = Date.valueOf(t3.Activity_Date_Time__c) - 1;
                    t3.OwnerId = lead.OwnerId;
                    t3.Priority = 'Normal';
                    t3.RecordTypeId = taskRT;
                    t3.Status = 'Open';
                    t3.Subject = 'Email' + ' ' + lead.FirstName + ' ' + lead.LastName;
                    t3.WhoId = lead.id;
                    lTask.add(t3);
                    
                    Task t4 = new Task();
                    t4.Activity_Date_Time__c = BusinessHours.addgmt(stdBusinessHours.id, system.now(), 1000 * 60 * 60 * 1000L);
                    t4.ActivityDate = Date.valueOf(t4.Activity_Date_Time__c) - 1;
                    t4.OwnerId = lead.OwnerId;
                    t4.Priority = 'Normal';
                    t4.RecordTypeId = taskRT;
                    t4.Status = 'Open';
                    t4.Subject = 'Call / Voice Message' + ' ' + lead.FirstName + ' ' + lead.LastName;
                    t4.WhoId = lead.id;
                    lTask.add(t4);
                    
                    Task t5 = new Task();
                    t5.Activity_Date_Time__c = BusinessHours.addgmt(stdBusinessHours.id, system.now(), 1200 * 60 * 60 * 1000L);
                    t5.ActivityDate = Date.valueOf(t5.Activity_Date_Time__c) - 1;
                    t5.OwnerId = lead.OwnerId;
                    t5.Priority = 'Normal';
                    t5.RecordTypeId = taskRT;
                    t5.Status = 'Open';
                    t5.Subject = 'Email' + ' ' + lead.FirstName + ' ' + lead.LastName;
                    t5.WhoId = lead.id;
                    lTask.add(t5);
                    
                }
            }
            if (!lTask.IsEmpty())
                insert lTask;
        }
        
    }
    
    
    if (Trigger.isInsert && Trigger.isBefore){
        BusinessHours stdBusinessHours = [select id
                                          from businesshours
                                          where isDefault = true];
        
        
        string uid = UserInfo.getUserId();
        User usr = [Select id, name, alias
                    from User
                    where id = :uid];
        List<Episys_User__c> eusr = new List<Episys_User__c>();
        List<Episys_User__c> eusr1 = new List<Episys_User__c>();
        List<Lead> assignqueue = new List<Lead>();
        Set<Id> LeadIdSet = new Set<Id>();
        Set<Decimal> Episys_User_ID = new Set<Decimal>();
        Map<Decimal, String> epsMap = new Map<Decimal, String>();
        Map<String, String> BranchMap = new Map<String, String>();
        List<Group> LeadBranchQueue = new List<Group>();
        List<Episys_User__c> euser2 = new List<Episys_User__c>();
        List<Group> LeadQueueNameList = new List<Group>();
        Set<String> LeadQueueNameSet = new Set<String>();
        Set<String> branchnameSet = new Set<String>();
        eusr = [SELECT id, alias__c, Assigned_Branch__c, Episys_ID__c, Episys_Name__c, Branch_Name__c, Default__c
                from Episys_User__c
                where alias__c = :usr.alias AND Default__c = :true
                order by Default__c desc
                limit 1];
        
        euser2 = [SELECT id, alias__c, Assigned_Branch__c, Episys_ID__c, Episys_Name__c, Branch_Name__c, Default__c
                  from Episys_User__c
                  where alias__c = :usr.alias
                  order by Default__c desc
                  limit 1];
        
        List<Episys_User__c> listeusr = [SELECT id, alias__c, Episys_Name__c, Assigned_Branch__c, Episys_ID__c, Branch_Name__c, Default__c
                                         from Episys_User__c];
        
        if (eusr.size() > 0){
            Episys_User_ID.Add(eusr[0].Episys_ID__c);
        }
        
        // code for assigning queue starts from here
        for (Lead lead : Trigger.new ){
            
            if (lead.Episys_User_ID__c != null){
                
                Episys_User_ID.Add(lead.Episys_User_ID__c);
                for (Episys_User__c item : listeusr){
                    
                    if (item.Episys_ID__c == lead.Episys_User_ID__c){
                        
                        lead.Branch_of_Lead_creator__c = item.Branch_Name__c;
                        lead.Episys_Name__c = item.Episys_Name__c;
                        break;
                    }
                }
            } else{
                if (eusr.size() > 0){
                    lead.Episys_User_ID__c = eusr[0].Episys_ID__c;
                    lead.Branch_of_Lead_creator__c = eusr[0].Branch_Name__c;
                    lead.Episys_Name__c = eusr[0].Episys_Name__c;
                    Episys_User_ID.Add(lead.Episys_User_ID__c);
                } else{
                    if (euser2.size() > 0){
                        lead.Episys_User_ID__c = euser2[0].Episys_ID__c;
                        lead.Branch_of_Lead_creator__c = euser2[0].Branch_Name__c;
                        lead.Episys_Name__c = euser2[0].Episys_Name__c;
                        Episys_User_ID.Add(lead.Episys_User_ID__c);
                    }
                }
            }
            
        }
        
        List<Episys_User__c> episysUsers = [SELECT id, alias__c, Assigned_Branch__c, Episys_ID__c, Branch_Name__c, Default__c
                                            from Episys_User__c
                                            where Episys_ID__c in:Episys_User_ID];
        Group OppQueue = new Group();
        String groupName;
        Id groupnameid;
        List<Group> listQueue = [select id, Name, Email
                                 from Group
                                 where Type = 'Queue' and (Email like '%lead.com' or Email like '%opportunity.com')];
        
        
        system.debug('Episys_User_ID##' + Episys_User_ID);
        system.debug('episysUsers##' + episysUsers);
        
        for (Lead lead : Trigger.new ){
            
            system.debug('Episys_User_ID##' + lead.Episys_User_ID__c);
            System.debug('lead.recordTypeID' + lead.recordTypeID);
            if (lead.Status == 'New' && lead.Episys_User_ID__c != 7002 && lead.recordTypeID != null && !rt_map.get(lead.recordTypeID).getName().containsIgnoreCase('Company Lead') && (lead.LeadSource == 'Branch Walk in' || lead.LeadSource == 'Branch Call')){
                System.debug('1111');
                if (episysUsers.size() > 0){
                    
                    for (Episys_User__c episysItem : episysUsers){
                        
                        system.debug('episysItem.Episys_ID__c###' + episysItem.Episys_ID__c);
                        system.debug('---Lead------episysItem.Episys_ID__c###' + lead.Episys_User_ID__c);
                        if (lead.Episys_User_ID__c == episysItem.Episys_ID__c){
                            
                            system.debug('Episys user matched###');
                            string BranchQueue = episysItem.Branch_Name__c.replace(' ', '_').replace('-', '_').replace('/', '_').toLowerCase();
                            system.debug('EBranchQueue###' + BranchQueue);
                            for (Group grp : listQueue){
                                
                                if (grp.Email.containsIgnoreCase(BranchQueue)){
                                    
                                    groupName = grp.Name;
                                    groupnameid = grp.id;
                                    break;
                                }
                                system.debug('groupName###' + groupName);
                            }
                            if (groupName != null && groupName != ''){
                                
                                lead.OwnerId = groupnameid;
                            } else{
                                
                                system.debug('Condition Product Type###');
                                string ProductType = lead.Product_Type__c.replace(' ', '_').replace('-', '_').replace('/', '_').toLowerCase();
                                system.debug('ProductType###' + ProductType);
                                for (Group grp : listQueue){
                                    
                                    if (grp.Email.containsIgnoreCase(ProductType)){
                                        
                                        groupName = grp.Name;
                                        groupnameid = grp.id;
                                        break;
                                    }
                                }
                                system.debug('groupName###' + groupName);
                                if (groupName != null && groupName != ''){
                                    
                                    lead.OwnerId = groupnameid;
                                }
                            }
                        }
                    }
                } else{
                    system.debug('Condition Product Type###');
                    string ProductType = lead.Product_Type__c.replace(' ', '_').replace('-', '_').replace('/', '_').toLowerCase();
                    system.debug('ProductType###' + ProductType);
                    for (Group grp : listQueue){
                        
                        if (grp.Email.containsIgnoreCase(ProductType)){
                            groupName = grp.Name;
                            groupnameid = grp.id;
                            break;
                        }
                    }
                    system.debug('groupName###' + groupName);
                    if (groupName != null && groupName != ''){
                        lead.OwnerId = groupnameid;
                    }
                }
            } else if (lead.Status == 'New' && lead.Episys_User_ID__c != 7002 && lead.recordTypeID != null && !rt_map.get(lead.recordTypeID).getName().containsIgnoreCase('Company Lead') && lead.LeadSource == 'Event'){
                System.debug('2222');
                string BranchQueue = '';
                if (eusr.size() > 0){
                    BranchQueue = eusr[0].Branch_Name__c.replace(' ', '_').replace('-', '_').replace('/', '_').toLowerCase();
                } else if (euser2.size() > 0){
                    BranchQueue = euser2[0].Branch_Name__c.replace(' ', '_').replace('-', '_').replace('/', '_').toLowerCase();
                }
                
                system.debug('EBranchQueue###' + BranchQueue);
                if (BranchQueue != null && BranchQueue != ''){
                    for (Group grp : listQueue){
                        
                        if (grp.Email.containsIgnoreCase(BranchQueue)){
                            
                            groupName = grp.Name;
                            groupnameid = grp.id;
                            break;
                        }
                        system.debug('groupName###' + groupName);
                    }
                }
                if (groupnameid != null){
                    lead.OwnerId = groupnameid;
                } else{
                    system.debug('Condition Product Type###');
                    string ProductType = lead.Product_Type__c.replace(' ', '_').replace('-', '_').replace('/', '_').toLowerCase();
                    system.debug('ProductType###' + ProductType);
                    for (Group grp : listQueue){
                        
                        if (grp.Email.containsIgnoreCase(ProductType)){
                            
                            groupName = grp.Name;
                            groupnameid = grp.id;
                            break;
                        }
                    }
                    system.debug('groupName###' + groupName);
                    if (groupName != null && groupName != ''){
                        
                        lead.OwnerId = groupnameid;
                    }
                }
            } else if (lead.Status == 'New' && lead.Episys_User_ID__c != 7002 && lead.recordTypeID != null && !rt_map.get(lead.recordTypeID).getName().containsIgnoreCase('Company Lead') && (lead.LeadSource != 'Branch Walk in' && lead.LeadSource != 'Branch Call' && lead.LeadSource != 'Refer a Member - Branch' && lead.LeadSource != 'Refer a Member - Web')){
                System.debug('3333');
                system.debug('Condition Product Type###');
                string ProductType = lead.Product_Type__c.replace(' ', '_').replace('-', '_').replace('/', '_').toLowerCase();
                system.debug('ProductType###' + ProductType);
                for (Group grp : listQueue){
                    
                    if (grp.Email.containsIgnoreCase(ProductType)){
                        groupName = grp.Name;
                        groupnameid = grp.id;
                        break;
                    }
                }
                system.debug('groupName###' + groupName);
                if (groupName != null && groupName != ''){
                    
                    lead.OwnerId = groupnameid;
                }
                
            } else if (lead.recordTypeID != null && !rt_map.get(lead.recordTypeID).getName().containsIgnoreCase('Company Lead') && lead.Episys_User_ID__c != 7002 && (lead.Status == 'Outreach' || lead.Status == 'Analyzing Needs' || lead.Status == 'Prospect Considering') && lead.LeadSource != 'Refer a Member - Branch' && lead.LeadSource != 'Refer a Member - Web'){
                System.debug('4444');
                lead.OwnerId = uid;
            } else if (lead.Episys_User_ID__c != 7002 && lead.LeadSource == 'Real Estate help desk' && lead.I_m_interested_in__c == 'Home Loan Help Desk'){
                
                if (lead.Are_you_a_current_member__c == 'No'){
                    lead.Current_Member__c = 'No';
                }
                if (lead.Are_you_a_current_member__c == 'Yes'){
                    lead.Current_Member__c = 'Yes';
                }
                System.debug('5555');
                for (Group grp : listQueue){
                    if (grp.name.containsIgnoreCase('Real Estate')){
                        groupName = grp.Name;
                        groupnameid = grp.id;
                        break;
                    }
                }
                if (groupName != null && groupName != ''){
                    system.debug('Queue Name: ' + groupName);
                    lead.OwnerId = groupnameid;
                }
            } else if (lead.Status == 'New' && lead.Episys_User_ID__c != 7002 && lead.LeadSource == 'SEG Contact Form'){
                System.debug('9999');
                
                for (Group grp : listQueue){
                    if (grp.name.containsIgnoreCase('Business Development Queue')){
                        groupName = grp.Name;
                        groupnameid = grp.id;
                        break;
                    }
                    system.debug('groupName###' + groupName);
                }
                
                if (groupnameid != null){
                    lead.OwnerId = groupnameid;
                }
                
            } else if (lead.Status == 'New' && lead.Episys_User_ID__c != 7002 && lead.LeadSource == 'Expat Services Form'){
                System.debug('8888');
                
                for (Group grp : listQueue){
                    if (grp.name.containsIgnoreCase('Ex-Patriates')){
                        groupName = grp.Name;
                        groupnameid = grp.id;
                        break;
                    }
                    system.debug('groupName###' + groupName);
                }
                
                if (groupnameid != null){
                    lead.OwnerId = groupnameid;
                }
                lead.Product_Type__c = 'Accounts/Shares';
                lead.Product_Subtype__c = 'Membership';
            } else{
                //------------------------------- from Graham Smith 5/6/21 start --------------------------------------//
                // Looks for a match on referring first name, referring last name and referring email.
                // Only want to do this if single insert.
                if (Trigger.new.size() == 1){
                    if ((lead.LeadSource == 'Refer a Member - Branch' && lead.Person__c == null) || lead.LeadSource == 'Refer a Member - Web'){
                        if (lead.Referring_Member_Email__c != null){
                            String testEmail = lead.Referring_Member_Email__c;
                            String testFN = lead.Referring_Member_FirstName__c;
                            String testLN = lead.Referring_Member_LastName__c;
                            List<Account> matchingAccounts = [SELECT Id, FirstName, LastName, PersonEmail
                                                              FROM Account
                                                              WHERE FirstName = :testFN AND LastName = :testLN AND PersonEmail = :testEmail
                                                              LIMIT 1];
                            if (matchingAccounts.size() > 0){
                                lead.Person__c = matchingAccounts[0].Id;
                            }
                        }
                    }
                }
                //------------------------------- from Graham Smith 5/6/21 end --------------------------------------//
                
                
            }
        }
        
        /*----PRJ0011432-11432: MARS Functionality Review Changes Start-----*/
        updateSLAFields(Trigger.new, null);
        /*----PRJ0011432-11432: MARS Functionality Review Changes End-----*/
    }
    
    if (Trigger.isupdate && Trigger.isBefore){
        BusinessHours stdBusinessHours = [select id
                                          from businesshours
                                          where isDefault = true];
        set<id> setlead = new Set<id>();
        for (Lead ld1 : [select id, Name
                         from lead
                         where Owner.Type = 'Queue' and id IN:trigger.New ]){
                             
                             SetLead.add(ld1.id);
                         }
        system.debug('--------------' + setlead);
        
        Lead leadObject = new Lead();
        Schema.SObjectType objType = leadObject.getSObjectType();
        Map<String, Schema.SObjectField> mapFields = Schema.SObjectType.Lead.fields.getMap();
        
        for (Lead ld : trigger.New ){
            Lead oldlead = trigger.oldMap.get(ld.Id);
            
            Set<String> updatedFields = new Set<String>();
            for (String str : mapFields.keyset()){
                try{
                    if (ld.get(str) != oldlead.get(str)){
                        updatedFields.add(str);
                    }
                } catch (Exception e){
                    System.Debug('Error: ' + e);
                }
            }
            
            
            if (SetLead.contains(ld.id) && ld.Status == 'Closed - Not Converted'){
                ld.Adderror('Queue owned leads cannot be closed.');
            }
            
            System.debug('userRole:' + userRole);
            System.debug('Product_Type__c:' + ld.Product_Type__c);
            System.debug('ld.Status:' + ld.Status);
            System.debug('oldlead.Status:' + oldlead.Status);
            System.debug('updatedFields:' + updatedFields);
            
            if ((oldlead.Status == 'Closed - Converted' || (oldlead.Status == 'Closed - Not Converted' && ld.Status == 'Closed - Not Converted')) 
                && ld.Product_Type__c == 'Mortgage' && (userRole == 'Mortgage Sales Manager 5' || userRole == 'Mortgage Sales Manager 7') 
                && updatedFields.size() == 1 && updatedFields.contains('leadsource')){
                    // Allow Mortgage Sales Manager to update the Lead Source
                } 
            else if( (oldlead.Status == 'Closed - Converted' || oldlead.Status == 'Closed - Not Converted') && 
                    (userRole == 'Mortgage Sales Manager 5'|| userRole == 'Mortgage Sales Manager 7') &&
                    ld.Product_Type__c == 'Mortgage' && updatedFields.contains('leadsource') && updatedFields.contains('event_source__c') && (ld.LeadSource== 'Event' || ld.LeadSource=='Member Intelligence')
                    && updatedFields.size() == 2 )
            {
                // Allow Mortgage Sales Manager to update the Lead Source when leadsource='event' or ld.LeadSource=='Member Intelligence'
            }
            
            else{
                if ((oldlead.Status == 'Closed - Converted' || (oldlead.Status == 'Closed - Not Converted' && ld.Status == 'Closed - Not Converted')) && Profilename != 'CFCU Admin'){
                    ld.Adderror('Lead fields are read only for Closed Leads.');
                }
            }
            
        }
        
        for (Lead lead : Trigger.New ){
            if (lead.Episys_User_ID__c != null){
                List<Episys_User__c> euser = [SELECT id, alias__c, Assigned_Branch__c, Episys_Name__c, Episys_ID__c, Branch_Name__c, Default__c
                                              from Episys_User__c
                                              where Episys_ID__c = :lead.Episys_User_ID__c];
                if (euser.size() > 0){
                    lead.Branch_of_Lead_creator__c = euser[0].Branch_Name__c;
                    lead.Episys_Name__c = euser[0].Episys_Name__c;
                }
            } else{
                lead.Branch_of_Lead_creator__c = '';
                lead.Episys_Name__c = '';
            }
            
            //--------------------------------Company Lead--------------------------------------------------//
            
            if (lead.Company != '' && lead.Company != null){
                system.debug('Company Lead');
                lead.RecordTypeId = LeadRT;                
            }
        }
        
        /*----PRJ0011432-11432: MARS Functionality Review Changes Start-----*/
        updateSLAFields(Trigger.new, Trigger.old);
        /*----PRJ0011432-11432: MARS Functionality Review Changes End-----*/
    }
    
    /*----PRJ0011432-11432: MARS Functionality Review Changes Start-----*/
    decimal getSLA(Lead Ld) {
        // Routine loops through all metadata for opportunities and if a match is found, returns the SLA based on Event_Source__c,Opportunity_Source__c,Product_Type__c & StageName__c combination.
        // Definitions can include single values or lists for Event_Source__c & Opportunity_Source__c.
        // Wildcard * in Event_Source__c or Opportunity_Source__c def means it only requires ld.[field] is populated.
        Boolean leadSourceOK,productTypeOK,eventSourceOK,stageOK;
        String defEventSource,defLeadSource,defLeadProductType,defStage;
        Decimal sla;
        leadSourceOK = false;
        productTypeOK       = false;
        eventSourceOK       = false;
        stageOK             = false;
        for(Sla_Manager__mdt slaDef : slaDefList) {
            if(slaDef.Event_Source__c == '*') { // * = something has to have been chosen, but it doesn't matter what.
                if(!String.isBlank(Ld.Event_Source__c)) {
                    eventSourceOK = true;
                }
            } else {
                if(String.isBlank(slaDef.Event_Source__c)) {
                    eventSourceOK = true;
                } else  {
                    defEventSource = slaDef.Event_Source__c;
                    if(String.isNotBlank(Ld.Event_Source__c) && defEventSource.contains(Ld.Event_Source__c)) {
                        eventSourceOK = true;
                    }
                }
            }
            if(slaDef.Opportunity_Source__c == '*') { // * = something has to have been chosen, but it doesn't matter what.
                if(!String.isBlank(Ld.LeadSource)) {
                    leadSourceOK = true;
                }
            } else {
                if(String.isBlank(slaDef.Opportunity_Source__c)) {
                    leadSourceOK = true;
                } else  {
                    defLeadSource = slaDef.Opportunity_Source__c;
                    if(String.isNotBlank(Ld.LeadSource) && defLeadSource.contains(Ld.LeadSource)) {
                        leadSourceOK = true;
                    } 
                }
            }
            if(String.isBlank(slaDef.Product_Type__c)) {
                productTypeOK = true;
            } else {
                defLeadProductType = slaDef.Product_Type__c;
                // Maybe one day, list of product will be used.  Ready for that.
                if(String.isNotBlank(Ld.Product_Type__c) && defLeadProductType.contains(Ld.Product_Type__c)) {
                    productTypeOK = true;
                }
            }
            if(String.isBlank(slaDef.StageName__c)) {
                stageOK = true;
            } else {
                defStage = slaDef.StageName__c;
                if(defStage == Ld.Status) {
                    stageOK = true;
                }
            }
            if(eventSourceOK && leadSourceOK && productTypeOK && eventSourceOK && stageOK) {
                sla = slaDef.Sla__c;
                break;
            }
            else{
                sla = null;  
            }
        }
        return sla;
    }
    
    
    
    
    
    public void updateSLAFields(List<Lead> newLeadList, List<Lead> oldLeadList){
        system.debug('newLeadList'+ newLeadList);
        system.debug('oldLeadList'+ oldLeadList);
        BusinessHours stdBusinessHours = [select id
                                          from businesshours
                                          where isDefault = true];
        
        
        Map<string, Lead> mapOldLead = new Map<string, Lead>();
        
        
        
        if (trigger.isBefore){
            if (trigger.isinsert){
                if (newLeadList.size() > 0){
                    for (Lead l : newLeadList){
                        /*--------Update SLA Field------*/
                        string status = l.Status;
                        
                        l.SLA__c = getSLA(l);
                        /*--------Update TimeStamp Fields------*/
                        if (status == 'New'){
                            l.TimeStamp_New_status__c = DateTime.now();
                        } else if (l.Status == 'Outreach'){
                            l.TimeStamp_Outreach_status__c = DateTime.now();
                        }
                        else if (status == 'Considering'){
                            l.TimeStamp_Considering_status__c = DateTime.now();
                        } 
                        else if (l.Status == 'Analyzing Needs'){
                            l.TimeStamp_Analyzing_Needs_status__c = DateTime.now();
                        }
                        
                        /*----------Update Yellow and Breach TimeStamp Fields--------*/
                        if (l.SLA__c != NULL && stdBusinessHours != NULL && l.Status == 'New' && l.TimeStamp_New_status__c != null){
                            l.SLA_Yellow_Start_Time__c = BusinessHours.addgmt(stdBusinessHours.id, l.TimeStamp_New_status__c, (Long) ((l.SLA__c - 1) * 3600000));
                            l.SLA_Breach_Time__c = BusinessHours.addgmt(stdBusinessHours.id, l.TimeStamp_New_status__c, (Long) ((l.SLA__c) * 3600000));
                            system.debug('SLA_Breach_Time__c New '+l.SLA_Breach_Time__c);

                        }
                        else if (l.SLA__c != NULL && stdBusinessHours != NULL && l.Status == 'Outreach' && l.TimeStamp_Outreach_status__c != null){
                            l.SLA_Yellow_Start_Time__c = BusinessHours.addgmt(stdBusinessHours.id, l.TimeStamp_Outreach_status__c, (Long)((l.SLA__c - 1) * 3600000));
                            l.SLA_Breach_Time__c = BusinessHours.addgmt(stdBusinessHours.id, l.TimeStamp_Outreach_status__c, ((Long) (l.SLA__c) * 3600000));
                        }else{
                            l.SLA_Yellow_Start_Time__c = null;
                            l.SLA_Breach_Time__c = null;
                        }
                    }
                }
            }
            
            if (trigger.isUpdate){
                
                for (Lead ol : oldLeadList){
                    mapOldLead.put(ol.Id, ol);
                }
                if (newLeadList.size() > 0){
                    for (Lead l : newLeadList){
                        /*--------Update SLA Field------*/
                        string status = l.Status;
                        
                        Lead oldlead = mapOldLead.get(l.Id);
                        string oldStatus = oldlead.Status;
                        string oldProductType = oldlead.Product_Type__c;
                        string newProductType = l.Product_Type__c;
                        string oldLeadSource = oldlead.LeadSource;
                        string newLeadSource = l.LeadSource;
                        l.SLA__c = getSLA(l);
                        
                        
                        /*--------Update TimeStamp Fields------*/
                        if (status == 'New' && oldStatus != 'New'){
                            l.TimeStamp_New_status__c = DateTime.now();
                        } else if (status == 'Outreach' && oldStatus != 'Outreach'){
                            l.TimeStamp_Outreach_status__c = DateTime.now();
                        }
                        else if (status == 'Considering' && oldStatus != 'Considering'){
                            l.TimeStamp_Considering_status__c = DateTime.now();
                        } 
                        else if (l.Status == 'Analyzing Needs' && oldStatus != 'Analyzing Needs'){
                            l.TimeStamp_Analyzing_Needs_status__c = DateTime.now();
                        }
                        
                        /*----------Update Yellow and Breach TimeStamp Fields--------*/
                        if (l.SLA__c != NULL && stdBusinessHours != NULL && l.Status == 'New' && l.TimeStamp_New_status__c != null && oldStatus != 'New'){
                            l.SLA_Yellow_Start_Time__c = BusinessHours.addgmt(stdBusinessHours.id, l.TimeStamp_New_status__c, (Long) ((l.SLA__c - 1) * 3600000));                            
                            l.SLA_Breach_Time__c = BusinessHours.addgmt(stdBusinessHours.id, l.TimeStamp_New_status__c, (Long) ((l.SLA__c) * 3600000));
                            system.debug('SLA_Breach_Time__c New '+l.SLA_Breach_Time__c);
                            if(l.Hour_Spent_New_Status__c != 0 && l.Hour_Spent_New_Status__c != null){
                                l.SLA_Yellow_Start_Time__c = BusinessHours.addgmt(stdBusinessHours.id, l.SLA_Yellow_Start_Time__c, -(Long)(l.Hour_Spent_New_Status__c*3600000));
                                l.SLA_Breach_Time__c = BusinessHours.addgmt(stdBusinessHours.id, l.SLA_Breach_Time__c, -(Long)(l.Hour_Spent_New_Status__c*3600000));
                            }
                        } else if (l.SLA__c != NULL && stdBusinessHours != NULL && l.Status == 'Outreach' && l.TimeStamp_Outreach_status__c != null && oldStatus != 'Outreach'){
                            l.SLA_Yellow_Start_Time__c = BusinessHours.addgmt(stdBusinessHours.id, l.TimeStamp_Outreach_status__c, (Long) ((l.SLA__c - 1) * 3600000));
                            l.SLA_Breach_Time__c = BusinessHours.addgmt(stdBusinessHours.id, l.TimeStamp_Outreach_status__c, (Long) ((l.SLA__c) * 3600000)); 
                            
                            if(l.Hour_Spent_Outreach_Status__c != 0 && l.Hour_Spent_Outreach_Status__c != null){
                                l.SLA_Yellow_Start_Time__c = BusinessHours.addgmt(stdBusinessHours.id, l.SLA_Yellow_Start_Time__c, -(Long)(l.Hour_Spent_Outreach_Status__c*3600000));
                                l.SLA_Breach_Time__c = BusinessHours.addgmt(stdBusinessHours.id, l.SLA_Breach_Time__c, -(Long)(l.Hour_Spent_Outreach_Status__c*3600000));
                            }
                        } 
                        else if(newProductType == 'Mortgage' && oldProductType != 'Mortgage' && l.SLA__c != NULL && stdBusinessHours != NULL && l.Status == 'New' && l.TimeStamp_New_status__c != null){
                            l.SLA_Yellow_Start_Time__c = BusinessHours.addgmt(stdBusinessHours.id, l.TimeStamp_New_status__c, (Long) ((l.SLA__c - 1) * 3600000));                            
                            l.SLA_Breach_Time__c = BusinessHours.addgmt(stdBusinessHours.id, l.TimeStamp_New_status__c, (Long) ((l.SLA__c) * 3600000));
                            if(l.Hour_Spent_New_Status__c != 0 && l.Hour_Spent_New_Status__c != null){
                                l.SLA_Yellow_Start_Time__c = BusinessHours.addgmt(stdBusinessHours.id, l.SLA_Yellow_Start_Time__c, -(Long)(l.Hour_Spent_New_Status__c*3600000));
                                l.SLA_Breach_Time__c = BusinessHours.addgmt(stdBusinessHours.id, l.SLA_Breach_Time__c, -(Long)(l.Hour_Spent_New_Status__c*3600000));
                            }
                        }
                        else if(NewLeadSources.contains(newLeadSource) && !NewLeadSources.contains(oldLeadSource) && newProductType == 'Mortgage' && l.SLA__c != NULL && stdBusinessHours != NULL && l.Status == 'New' && l.TimeStamp_New_status__c != null){
                            l.SLA_Yellow_Start_Time__c = BusinessHours.addgmt(stdBusinessHours.id, l.TimeStamp_New_status__c, (Long) ((l.SLA__c - 1) * 3600000));                            
                            l.SLA_Breach_Time__c = BusinessHours.addgmt(stdBusinessHours.id, l.TimeStamp_New_status__c, (Long) ((l.SLA__c) * 3600000));
                            if(l.Hour_Spent_New_Status__c != 0 && l.Hour_Spent_New_Status__c != null){
                                l.SLA_Yellow_Start_Time__c = BusinessHours.addgmt(stdBusinessHours.id, l.SLA_Yellow_Start_Time__c, -(Long)(l.Hour_Spent_New_Status__c*3600000));
                                l.SLA_Breach_Time__c = BusinessHours.addgmt(stdBusinessHours.id, l.SLA_Breach_Time__c, -(Long)(l.Hour_Spent_New_Status__c*3600000));
                            }
                        }
                        
                        
                        /*----------Update Hours Spent Fields--------*/
                        DateTime currentTime = Datetime.now();
                        if (status != 'New' && oldStatus == 'New' && l.TimeStamp_New_status__c != null){
                            decimal TimeDiff = BusinessHours.diff(stdBusinessHours.id, l.TimeStamp_New_status__c, currentTime);
                            decimal hh = (TimeDiff / 3600000).setScale(2);
                            l.Hour_Spent_New_Status__c = l.Hour_Spent_New_Status__c != null ? l.Hour_Spent_New_Status__c + hh : hh;
                            if(oldlead.isSLABreached__c == true){
                                l.SLABreached__c = true;
                            }
                        } 
                        else if (status != 'Outreach' && oldStatus == 'Outreach' && l.TimeStamp_Outreach_status__c != null){
                            decimal TimeDiff = BusinessHours.diff(stdBusinessHours.id, l.TimeStamp_Outreach_status__c, currentTime);
                            decimal hh = (TimeDiff / 3600000).setScale(2);
                            l.Hour_Spent_Outreach_Status__c = l.Hour_Spent_Outreach_Status__c != null ? l.Hour_Spent_Outreach_Status__c + hh : hh;
                            if(oldlead.isSLABreached__c == true){
                                l.SLABreached__c = true;
                            }
                        } 
                        else if (status != 'Considering' && oldStatus == 'Considering' && l.TimeStamp_Considering_status__c != null){
                            decimal TimeDiff = BusinessHours.diff(stdBusinessHours.id, l.TimeStamp_Considering_status__c, currentTime);
                            decimal hh = (TimeDiff / 3600000).setScale(2);
                            l.Hour_Spent_Considering_Status__c = l.Hour_Spent_Considering_Status__c != null ? l.Hour_Spent_Considering_Status__c + hh : hh;
                            system.debug('  l.Hour_Spent_Considering_Status__c in milli '+  hh);
                        } 
                        else if (status != 'Analyzing Needs' && oldStatus == 'Analyzing Needs' && l.TimeStamp_Analyzing_Needs_status__c != null){
                            decimal TimeDiff = BusinessHours.diff(stdBusinessHours.id, l.TimeStamp_Analyzing_Needs_status__c, currentTime);
                            decimal hh = (TimeDiff / 3600000).setScale(2);
                            l.Hour_Spent_Analyzing_Need_Status__c = l.Hour_Spent_Analyzing_Need_Status__c != null ? l.Hour_Spent_Analyzing_Need_Status__c + hh : hh;
                            
                        }
                        
                    }
                }
            }
        }
        
    }
    /*----PRJ0011432-11432: MARS Functionality Review Changes End-----*/
    
}